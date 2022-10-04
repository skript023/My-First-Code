require("joaat")
MAX_INT = 2147483647 or "2147483647"
MIN_INT = -2147483647 or "-2147483647"
MAX_UINT = 4294967295 or "4294967295"
MAX_ULONG = 18446744073709551615

-- ==============================================================Asynchronous=================================================

--- Async/Await for Lua 5.1
--  This script implements async/await functions for Lua, allowing tasks to
--  be queued and scheduled independently.
--
--  This is just an example and has a bunch of issues, isn't tested, isn't
--  even actually used anywhere; I basically just got bored and had one of
--  those "what if?" type ideas 6 hours ago.

co_create = coroutine.create
co_resume = coroutine.resume
co_running = coroutine.running
co_status = coroutine.status
co_yield = coroutine.yield

-- Packs the given arguments into a table with an `n` key denoting the number
-- of elements.
function pack(...)
    return {
        n = select("#", ...),
        ...
    }
end

-- Invokes a given function with the given arguments.
function invoke(fn, ...)
    return fn(...)
end

--- Thread API
--  Implements a basic thread pool of coroutines that can execute functions.

-- Pool of threads that can be acquired. These are allowed to be GC'd.
local thread_pool = setmetatable({}, {
    __mode = "k"
})

-- Internal function used by thread pool coroutines to execute tasks and
-- return their results until the thread dies.
function thread_main()
    while true do
        co_yield(invoke(co_yield()))
    end
end

-- Creates a new thread for task execution and returns it.
function thread_create()
    -- Create and resume immediately so that thread_main yields in the loop
    -- to wait for tasks.
    local thread = co_create(thread_main)
    co_resume(thread)
    return thread
end

-- Acquires or creates a thread from the pool. The thread should have a task
-- function submitted to it via coroutine.resume, which will be executed
-- and its result returned.
--
-- When your task has finished, it is the responsibility of the caller to
-- release the thread back into the pool via thread_release.
--
-- If an error is raised, the thread follows standard coroutine semantics
-- and will die. A dead thread should not be released.
function thread_acquire()
    local thread = next(thread_pool) or thread_create()
    thread_pool[thread] = nil
    return thread
end

-- Releases a given thread back into the pool. The given thread must not
-- be dead. Releasing a thread into the pool before it has finished executing
-- a function will lead to undefined behaviour.
function thread_release(thread)
    assert(co_status(thread) ~= "dead", "attempted to release a dead thread")

    -- We need to resume a thread to get it back to the inner coroutine.yield
    -- call and make it wait for tasks again.
    co_resume(thread)
    thread_pool[thread] = true
end

--- Task API
--  Implements a basic task system around the coroutine thread pool.
--
--  This API exposes a lot of functions, most of which should be treated as
--  internal only due to invariants that need to be maintained. The following
--  functions are safe for public use:
--
--    task_create
--    task_start
--    task_join
--    task_yield
--    task_schedule
--    task_schedule_all
--
--  Task tables have the following fields which may be publicly inspected,
--  but not modified. Any field not listed here should be considered internal.
--
--    state:  State of the task, as documented below.
--    error:  If non-nil, the error that arose during task execution.
--    result: The result from the task function. This is a table of results
--            unless no values are returned, in which case it should be
--            assumed that if error == nil and result == nil that the task
--            returned no values.
--
--  Tasks may be in one of the following states:
--
--    pending:   task has been created but not yet started
--    runnable:  task has been started and can be resumed
--    running:   task has been started and is in-progress
--    suspended: task has been started but is blocked awaiting completion of
--               another task, and cannot be resumed
--    dead:      task has finished executing

-- Marker value for a successful task execution.
TASK_SUCCESS = {}
-- Marker value for a task that yielded.
TASK_YIELDED = {}

-- Stack of actively resumed tasks.
task_stack = {}
-- Mapping of tasks that are considered runnable.
task_runnable = {}
-- Counter used to forcefully join tasks due to external threads.
task_join_count = 0

-- Returns the actively running task.
function task_stack_top()
    return task_stack[#task_stack]
end

-- Pushes the given task to the top of the stack.
function task_stack_push(task)
    task_stack[#task_stack + 1] = task
end

-- Pops the task at the top of the stack.
function task_stack_pop()
    task_stack[#task_stack] = nil
end

-- Enqueues a given runnable task, allowing the scheduler to dispatch it.
function task_enqueue(task)
    assert(task.state == "runnable", "attempted to queue a non-runnable task")
    task_runnable[task] = true
end

-- Dequeues a given task, preventing the scheduler from dispatching it.
function task_dequeue(task)
    task_runnable[task] = nil
end

-- Marks a given task as having a dependent task that should be notified
-- upon completion.
function task_wait(task, dependent_task)
    if not task.notify then
        task.notify = {}
    end

    task.notify[#task.notify + 1] = dependent_task
end

-- Notifies all dependents of a task of completion, marking them as runnable
-- and allowing them to be scheduled.
function task_notify(task)
    if not task.notify then
        return
    end

    for i = #task.notify, 1, -1 do
        local dependent_task = task.notify[i]
        dependent_task.state = "runnable"
        task_enqueue(dependent_task)

        task.notify[i] = nil
    end
end

-- Internal function used by tasks to invoke their function and uphold the
-- invariants of the task API.
function task_main(task)
    return TASK_SUCCESS, invoke(unpack(task.target, 1, task.target.n))
end

-- Internal function called when a task thread has returned from a resumption.
function task_postresume(task, ok, result, ...)
    -- Pop this task from the stack.
    assert(task_stack_top() == task, "internal task stack error")
    task_stack_pop()

    -- Process the results from the task.
    if not ok or result == TASK_SUCCESS then
        -- If the task completed successfully we can recycle the thread.
        if result == TASK_SUCCESS then
            thread_release(task.thread)
        end

        -- Notify any dependent tasks that they're now unblocked.
        task_notify(task)

        task.state = "dead"
        task.thread = nil
        task.error = (not ok and result or nil)
        task.result = (ok and select("#", ...) > 0 and pack(...) or nil)
    elseif result == TASK_YIELDED then
        if (...) ~= nil then
            -- Task yielded due to blocking on another task. The task we're
            -- waiting on will be returned, so we just need to wait on it.
            task_wait((...), task)
            task.state = "suspended"
        else
            -- The task yielded explicitly. Nothing is blocking it so allow
            -- it to be rescheduled.
            task.state = "runnable"
            task_enqueue(task)
        end
    else
        -- Don't allow coroutine.yield() to be called blindly from within
        -- the body of a task; simplifies our invariants. Such code wouldn't
        -- work if it were a standard Lua function outside of a coroutine,
        -- after all.
        error("attempted to yield from a task function body")
    end
end

-- Internal function used to resume a task. Requires that the given task
-- is runnable.
function task_resume(task)
    assert(task.state == "runnable", "attempted to resume a non-runnable task")

    -- Dequeue the task so the scheduler doesn't see it, then mark it as our
    -- current running task.
    task_dequeue(task)
    task_stack_push(task)
    task.state = "running"

    -- Acquire or resume the thread this task is running on.
    if not task.thread then
        task.thread = thread_acquire()
        return task_postresume(task, co_resume(task.thread, task_main, task))
    else
        return task_postresume(task, co_resume(task.thread))
    end
end

-- Creates a new task that will execute the given function with the supplied
-- arguments. The task must be started via task_start before it can be
-- scheduled and joined upon.
function task_create(fn, ...)
    return {
        state = "pending", -- State of this task.
        target = pack(fn, ...), -- Target function and arguments.
        thread = nil, -- Thread used by this task.
        notify = nil, -- Array of tasks to notify upon completion.
        error = nil, -- Error result for this task.
        result = nil -- Success result data for this task.
    }
end

-- Starts the given task, allowing it to be scheduled and joined upon.
-- Raises an error if the task has already been started.
function task_start(task)
    assert(task.state == "pending", "attempted to start a non-pending task")
    task.state = "runnable"
    task_enqueue(task)
end

-- Blocks on a given task, either immediately executing it if in the context
-- of a non-task thread, or suspending the current task.
--
-- If the given task has already executed to completion, this function does
-- nothing. Raises an error if the given task has not been started.
function task_join(task)
    -- Dead tasks tell no tales.
    assert(task.state ~= "pending", "cannot join a pending task")
    assert(task.state ~= "running", "cannot join a running task")
    if task.state == "dead" then
        return
    end

    local current_task = task_stack_top()
    if not current_task or current_task.thread ~= co_running() or task_join_count > 0 then
        -- If there's no current task or we're joining from an external
        -- thread, we need to forcefully resume the task now and execute
        -- it to completion. To prevent blocking, we increment a counter
        -- (task_join_count) so that if the task tries to join other tasks
        -- we don't park and instead execute those fully too.
        task_join_count = task_join_count + 1
        task_resume(task)
        task_join_count = task_join_count - 1
    else
        -- We're running inside of a task so we can mark it as blocked and
        -- yield, allowing the scheduler to execute our dependency.
        co_yield(TASK_YIELDED, task)
    end
end

-- Yields the active task, suspending its execution. The task will be set in
-- a state that allows it to be resumed via task_schedule or task_join at
-- any point without waiting upon any dependencies.
--
-- The request to yield a task will be ignored if the user has explicitly
-- requested that this task, or a dependent of this task, to be joined.
--
-- Does nothing if there is no actively running task.
function task_yield()
    local task = task_stack_top()
    if task_join_count > 0 or not task then
        -- task_join was called and we're forcefully resolving this task,
        -- or there's no task to be yielded.
        return
    end

    co_yield(TASK_YIELDED)
end

-- Schedules an unspecified runnable task and executes it. This function will
-- return when the task either completes, or yields due to blocking upon
-- another task.
--
-- This function should not be called in a non-terminating loop; tasks that
-- explicitly yield may be immediately re-executed by the scheduler if so
-- and the you'd end up in a deadlock if the task doesn't stop yielding.
function task_schedule()
    local task = next(task_runnable)
    if not task then
        return
    end

    task_resume(task)
end

-- Schedules all tasks, executing them fully to completion. Any subtasks that
-- are created during execution of this function are themselves also executed.
function task_schedule_all()
    -- We collect the runnable tasks into a new list and execute it fully,
    -- and keep doing so until we run out of them. This prevents edge cases
    -- where a task yields explicitly without a dependency and gets executed
    -- in a loop because Lua's table ordering decided it wanted to constantly
    -- put it at the start of the runnable tasks mapping.
    runnables = {}
    while next(task_runnable) do
        for task in pairs(task_runnable) do
            runnables[#runnables + 1] = task
        end

        for i = #runnables, 1, -1 do
            local task = runnables[i]
            runnables[i] = nil

            task_resume(task)
        end
    end
end

--- Futures API
--  Futures provide a lighter weight read-only view of tasks to allow
--  accessing and storing their result data. All fields on futures are
--  considered internal.

-- Creates a future that monitors the given task.
function future_create(task)
    return {
        task = task, -- Task that this future is monitoring.
        error = nil, -- Error data received from the task.
        result = nil -- Result data received from the task.
    }
end

-- Returns the result of the task this future is watching. The task must
-- have been started via task_start, or an error will be raised.
--
-- If the result of the task isn't yet ready, the task will be joined and
-- waited upon for completion.
--
-- If the task fails with an error, the error is re-raised via the error()
-- function, otherwise the return values of the task are returned as-is.
function future_get(future)
    local task = future.task
    if task and task.state ~= "dead" then
        task_join(task)
        assert(task.state == "dead", "internal error: joined task must die")

        future.task = nil
        future.result = task.result
        future.error = task.error
    end

    if future.error ~= nil then
        error(future.error)
    elseif future.result ~= nil then
        return unpack(future.result, 1, future.result.n)
    end
end

--- Async/Await API
--  Provides a lightweight way of declaring async functions and awaiting upon
--  their results.

-- Marker value indicating an async function should run immediately and not
-- spawn a task. This is used as an optimization when the user would want to
-- await upon an async function immediately.
RUN_MODE_IMMEDIATE = {}

-- Wraps the given function in an async task wrapper. Calling the returned
-- function will return a future that may be queried for a result via the
-- future_get function.
function async(fn)
    return function(...)
        if (...) == RUN_MODE_IMMEDIATE then
            return fn(select(2, ...))
        else
            local task = task_create(fn, ...)
            local future = future_create(task)

            task_start(task)
            return future
        end
    end
end

-- Awaits upon a given future, returning its result or raising an error if
-- an async function failed.
--
-- Optionally, users may provide an async function in place of a future. This
-- will cause the function to be executed immediately, rather than creating
-- a future.
function await(future, ...)
    if type(future) == "function" then
        -- future in this case is assumed to be an async function, we'll
        -- optimize by just running it directly and skipping all task/future
        -- management.
        return future(RUN_MODE_IMMEDIATE, ...)
    else
        return future_get(future)
    end
end

--- Usage Examples
--
--  In a WoW environment you'd typically want to set up an OnUpdate script or
--  a timer that calls task_schedule() as many times as desired to process
--  tasks asynchronously. You can also force all outstanding tasks to be
--  executed to completion via task_schedule_all().

-- Generates several batches of numbers and strings and prints them in
-- whatever order the scheduler feels like. The print_value async function
-- is used to demonstrate that we can await upon tasks from within other
-- tasks (print_values), which waits for the scheduler to print a number
-- and yields allowing the non-deterministic ordering of output.

local print_value = async(function(value)
    print("Value: ", value)
end)

local generate_numbers = async(function(count)
    -- Generate the requested number of random numbers and yield this task
    -- on each one, allowing other tasks to be executed.
    local numbers = {}
    for i = 1, count do
        numbers[i] = math.random(25, 75)
    end

    return numbers
end)

local print_values = async(function(values)
    for i = 1, #values do
        if i % 2 == 1 then
            -- Run the print_value function immediately inside this task.
            await(print_value, values[i])
        else
            -- Spawn print_value as a new task and await upon it.
            await(print_value(values[i]))
        end
    end
end)

local generate_strings = async(function(count)
    local strings = {}
    for i = 1, count do
        strings[i] = string.format("%08x", math.random(2 ^ 8, 2 ^ 24))
    end

    return strings
end)

--[[for _ = 1, 2 do
    print_values(await(generate_numbers(3)))
    print_values(await(generate_strings(3)))
end

task_schedule_all()
]]
-- Parking a task and awaiting an external event: For this we set an external
-- boolean flag up and toggle its state, a task polls this periodically when
-- scheduled and if it isn't set then it will yield.

local event_fired = false
local wait_for_event = async(function()
    while not event_fired do
        print("Checking...")
        task_yield() -- Explicitly yield to allow other things to happen.
    end
end)

local do_work_after_event = async(function()
    print("Waiting for event...")
    await(wait_for_event())
    print("Event fired!")
end)

local fire_event = async(function()
    while not event_fired do
        if math.random(1, 25) < 10 then
            print("Firing event...")
            event_fired = true
        else
            print("Sleeping...")
            os.execute("sleep 0.1")
            task_yield() -- Explicitly yield to allow other things to happen.
        end
    end
end)

-- fire_event()
-- do_work_after_event()
-- task_schedule_all()

GlobalScript = function(Offset)
    local p = getAddress('GlobalPTR')
    if not p then
        return
    end
    return readQword(p + (8 * (Offset >> 0x12 & 0x3F))) + (8 * (Offset & 0x3FFFF));
end
function MemoryCopy(MemoryAllocation, Memory)
    local orig_type = type(Memory)
    local MemoryAllocation
    if orig_type == 'table' then
        MemoryAllocation = {}
        for orig_key, orig_value in next, Memory, nil do
            MemoryAllocation[MemoryCopy(orig_key)] = MemoryCopy(orig_value)
        end
        setmetatable(MemoryAllocation, MemoryCopy(getmetatable(Memory)))
    else -- number, string, boolean, etc
        MemoryAllocation = Memory
    end
    return MemoryAllocation
end

function const(Variable, activation, value)
    local key = Variable
    local protected = {}
    if _G[key] then
        protected[key] = _G[key]
        _G[key] = nil
    else
        protected[key] = value
    end

    local meta = {
        __index = protected,
        __newindex = function(tbl, key, value)
            if protected[key] and activation then
                error("attempting to overwrite constant " .. tostring(key) .. " to " .. tostring(value), 2)
            end
            rawset(tbl, key, value)
        end
    }
    setmetatable(_G, meta)
end

function Test(Registration, Script, Activation)
    if Activation then
        Registration = Script
    else
        Registration = "Disable"
    end
    return Registration
end

function ReturnTest(Activation, Test)
    if Activation == 1 then
        Power = 1
    end
    return (Activation == 1 or Test == 1 and Power == 1) and true or false
end

Assembly_Loader = function()
    local tbl_Assembly = {}
    FileName = 'RockstarDeveloperTools'
    if FileName == nil or FileName == '' then
        return
    end
    local fs = assert(io.open(string.format('C:/Program Files/Cheat Engine 7.2/lua/%s.asm', FileName), "r"));
    local k, ENABLER = 1, false
    for c = 1, 200, 1 do
        local line = fs:read("*line")
        if line == nil or line == '' then
            goto continue
        end
        if line == "ENABLE:" then
            ENABLER = true
            goto ENABLED
        end
        if c % 2 == 1 and ENABLER == false then
            tbl_Assembly[k] = {line}
        elseif c % 2 == 0 and ENABLER == true then
            tbl_Assembly[k] = {line}
        else
            tbl_Assembly[k][2] = line
            k = k + 1
        end
        ::ENABLED::
    end
    ::continue::
    fs:close();
    for k, v in pairs(tbl_Assembly) do
        print(v)
    end
    return tbl_Assembly
end

x = Test(LocalPlayer, "LocalPlayer", true)
z = Test(Test, "Test", true)
print(z)
print(x)
print(z)
x = Test(LocalPlayer, false)
print(x)
print(x)
x = Test(LocalPlayer, "LocalPlayer", true)
print(x)
print(z)
print(x)
y = Test(Adder, joaat("PutriNovita"), true)
print(x)
print(y)
b = joaat("PutriNovita")
w = MemoryCopy(Global_1, "Test")
c = MemoryCopy(Global_2, "Test2")
print(c)
print(w)
print(w)
print(c)
r = joaat("Adder")

s = const("r", false)
print(r)
r = 'false'
print(s)
print(r)
MEMORY = {
    SET_BIT = function(Address, Offset)
        return Address | (1 << Offset);
    end,

    IS_BIT_SET = function(Address, Offset)
        return Address & (1 << Offset)
    end,

    CLEAR_BIT = function(Address, Offset)
        return Address & ~(1 << Offset)
    end
}
function MAKELONG(a, b)
    return (a & 0xffff | b & 0xffff) << 16
end

test = MAKELONG(11111, 5)

g = 7
cs = g << 2
print(cs)
sc = MEMORY.SET_BIT(g, 4)
print(sc)
check = MEMORY.IS_BIT_SET(sc, 5)
print(check)
bc = MEMORY.CLEAR_BIT(sc, 5)
print(bc)

function RIDJoiner()
    function TCOMP(T,C,...) for K,V in pairs(C) do T[K]=V end if select('#',...)>0 then return TCOMP(T,...) else return T end end
    if not RIDJoinerForm then
    oFriendName = 0x080         --offset 0x080 Friend name
    oFriendRID  = 0x0B8           --offset 0x0B8 Friend RID
    oFriendsOnlineStat = 0x1f8  --offset 0x1f8 value 1 or 0 "1 is online and in session"
    
    
    RIDJoinerForm = createForm(true)
    TCOMP(RIDJoinerForm,{Caption='RIDJoiner',Left=110,Top=110,Height=270,Width=400})
    local AssignRID = createToggleBox(RIDJoinerForm)
    TCOMP(AssignRID,{Caption='Assign RID to the Selected',Left=212,Top=30,Height=40,Width=180})
    local TargetRID = createEdit(RIDJoinerForm)
    TCOMP(TargetRID,{TextHint='Target RID',Left=212,Top=75,Height=40,Width=180,MaxLength=10,NumbersOnly=true})
    TargetRID.Font.Size = 12
    -- Updaters
    local update = createToggleBox(RIDJoinerForm)
    TCOMP(update,{Caption='Update',Left=217,Top=135,Height=40,Width=90})
    local updateTimer = createTimer(RIDJoinerForm,false)
    local updateTimer2 = createTimer(RIDJoinerForm,false)
    updateTimer.Interval = 3000
    updateTimer2.Interval = 500
    local updateInterval = createEdit(RIDJoinerForm)
    TCOMP(updateInterval,{TextHint='Interval',Text=3000,Left=311,Top=145,Height=40,Width=50,MaxLength=4,NumbersOnly=true})
    local ms=createLabel(RIDJoinerForm)
    TCOMP(ms,{Caption='ms',Left=366,Top=150,Height=40,Width=120})
    -- Labels
    local SelectedFriendRID = createLabel(RIDJoinerForm)
    TCOMP(SelectedFriendRID,{Caption='Selected Friend RID:',Left=10,Top=215,Height=40,Width=120})
    SelectedFriendRID.Font.Size = 11
    local FriendLabel=createLabel(RIDJoinerForm)
    TCOMP(FriendLabel,{Caption='Online Friends List:',Left=10,Top=15,Height=40,Width=120})
    -- Online Friends List Box
    local OnlineFriendsList = createListBox(RIDJoinerForm)
    TCOMP(OnlineFriendsList,{Color = '0x00DFF7FF',Left=10,Top=30,Height=160,Width=200,ScrollWidth = 10})
    -- RID Assign To Join
    local RIDi = {}
    function getOnlineFriendsList()
         local OnlineFriendsNum = 0
         -- comment one of the readPointer lines
         BFriendListptr = readPointer("GTA5.exe+0290DA58")-- &gt;&gt; Epic
         -- For Steam &gt;&gt;  BFriendListptr = readPointer("GTA5.exe+02918628")
    
         local FriendsTotalNum = 15 --the first 15 Friend
            for i = 0 ,FriendsTotalNum, 1 do
                 FriendOnlineStat = readInteger(BFriendListptr + oFriendsOnlineStat + 0x200*i)
                     if FriendOnlineStat == 1 then
                        RIDi[OnlineFriendsNum] = i -- to avoid any mismatch in friends offsets for any reason
                        OnlineFriendsNum = OnlineFriendsNum + 1
                        OnlineFriendsList.Items.Add(OnlineFriendsNum ..': '.. readString(BFriendListptr + oFriendName + 0x200*i));
                     end
            end
    end
    
    getOnlineFriendsList()
    
    AssignRID.OnClick = function ()
       LastIndex = OnlineFriendsList.ItemIndex
       local TargetRID_1 = tonumber (TargetRID.text)
       local function FixRID()
             TargetRID_1 = tonumber (TargetRID.text)
             if TargetRID_1 ~= nil and (OnlineFriendsList.ItemIndex ~= -1 and OnlineFriendsList.ItemIndex == LastIndex)  then
             local RIDptr_1 = BFriendListptr  + oFriendRID + (0x200*RIDi[OnlineFriendsList.ItemIndex])
             writeInteger(RIDptr_1,TargetRID_1)
             else
              updateTimer2.Enabled = false
             end
       end
             if TargetRID_1 == nil or OnlineFriendsList.ItemIndex == -1 then
              AssignRID.Checked = false
             elseif AssignRID.Checked == true  then
              updateTimer2.OnTimer = function() FixRID() end
              FixRID()
              updateTimer2.Enabled = true
             else
              updateTimer2.Enabled = false
             end
    end
    
    OnlineFriendsList.OnSelectionChange = function ()
       if OnlineFriendsList.ItemIndex ~= -1   then
         local CurrentRID =  readInteger( BFriendListptr  + oFriendRID + (0x200*RIDi[OnlineFriendsList.ItemIndex]))
         SelectedFriendRID.Caption = 'Selected Friend RID: ' .. tostring(CurrentRID)
       end
       if  OnlineFriendsList.ItemIndex ~= LastIndex then
        AssignRID.Checked = false
        end
    end
    update.OnClick = function()
           local function updateList()
           local lastIndex = OnlineFriendsList.ItemIndex
                OnlineFriendsList.Items.Clear()
                getOnlineFriendsList()
                if lastIndex < OnlineFriendsList.Items.Count then
                   OnlineFriendsList.ItemIndex = lastIndex
                else
                   OnlineFriendsList.ItemIndex = 0
                end
           end
           if update.Checked == true then
              updateTimer.OnTimer = function() updateList() end
              updateList()
              updateTimer.Enabled = true
           else
              updateTimer.Enabled = false
           end
    end
    updateInterval.OnChange = function()
       local newInterval = tonumber(updateInterval.Text)
           if newInterval and newInterval >= 500 then
              updateTimer.Interval = newInterval
           else
              updateTimer.Interval = 3000
              sleep(200)
              updateInterval.Text = '3000'
           end
        end
    RIDJoinerForm.OnClose = function()
           RIDJoinerForm.destroy()
           RIDJoinerForm = nil
           updateTimer.destroy()
           updateTimer2.destroy()
        end
      end
    end
    RIDJoiner()

local fromColor2 = {};
local toColor2 = {};
local colorSpeed2 = {r, g, b};
local transitionTarget2;
local speeeeeeed2 = 0;
local speedc2 = 0;
local transitionOption2 = {
    completeOldColor = true
}
function transitionTimer2(sender)
    transitionTarget2.color = "0x" .. rgbToHex(fromColor2);
    fromColor2[1] = fromColor2[1] + colorSpeed2.r;
    fromColor2[2] = fromColor2[2] + colorSpeed2.g;
    fromColor2[3] = fromColor2[3] + colorSpeed2.b;
    speedc2 = speedc2 + 1;
    if speedc2 >= speeeeeeed2 then
        transitionTarget2.color = "0x" .. rgbToHex(toColor2)
        speedc2 = 0
        transitionColor2.enabled = false
        return
    end
end
if transitionColor2 == nil then
    transitionColor2 = createTimer(nil)
end
transitionColor2.interval = 1;
transitionColor2.ontimer = transitionTimer2;
transitionColor2.enabled = false;
function gotoColor2(object, color, speed)
    speedc2 = 0;
    speeeeeeed2 = speed;
    if transitionOption2.completeOldColor then
        if transitionTarget2 ~= nil then
            transitionTarget2.color = "0x" .. rgbToHex(toColor2)
        end
    end
    transitionTarget2 = object;
    fromColor2 = hexToRGB(string.format("%06X", object.color));
    toColor2 = color;
    colorSpeed2.r = round((toColor2[1] - fromColor2[1]) / speed);
    colorSpeed2.g = round((toColor2[2] - fromColor2[2]) / speed);
    colorSpeed2.b = round((toColor2[3] - fromColor2[3]) / speed);
    transitionColor2.enabled = true;
end

