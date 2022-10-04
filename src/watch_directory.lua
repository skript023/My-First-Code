--[[
	-- Cheat Engine Watch Directory module
	-- Author: DaSpamer
	
	watchDirectory.add( path:string, callback:function, subtree:boolean, filterFlags:number ):handle
	watchDirectory.remove(handle);
	
	notes:
		path: full path string (max length of MAX_PATH - 260)
		subtree: track changes to child directories as well
		filterFlags: can supply "folder" to watch changes to files/folders (creation/deletion of directories/files,*renaming is deleting and then creating)
			otherwise default is watch only files (create/delete/write events)
			
			for more flags refer to: https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-findfirstchangenotificationa
		
		*this class cannot pass what files or kind of changes has occured, to the callback function.
	
	-- example script....
	local myPath = "C:\\MyPath\\"
	local onMyPathChange = function()
		print('A change occured to the path:',myPath);
	end
	myPathWatchHandle = watchDirectory.add(myPath,onMyPathChange,false,"folder") -- watch only myPath (excluding sub directories)
	
	-- remove watch notification from directory
	-- watchDirectory.remove(myPathWatchHandle);
--]]
local is64bit = cheatEngineIs64Bit();
local _watch = {
	stream = createMemoryStream();
	handles = {};
	callback = {};
	removeQueue = {};
	timeout = 60 * 1000; -- 1 minute timeout..
	FILE_NOTIFY_CHANGE_FILE_NAME 	= 0x1; -- new file, remove file, rename file(remove and add file)
	FILE_NOTIFY_CHANGE_DIR_NAME 	= 0x2; -- new dir, remove dir, rename dir
	FILE_NOTIFY_CHANGE_ATTRIBUTES 	= 0x4; -- change attributes (readonly, access and such...)
	FILE_NOTIFY_CHANGE_LAST_WRITE 	= 0x10; -- on file written... might be called several times*
}
_watch.stream.size = 128;
_watch.streamAddr = _watch.stream.Memory;
_watch.folderFilter = _watch.FILE_NOTIFY_CHANGE_FILE_NAME | _watch.FILE_NOTIFY_CHANGE_DIR_NAME  -- added/removed/renamed files and folders
_watch.fileFilter = _watch.FILE_NOTIFY_CHANGE_FILE_NAME |_watch.FILE_NOTIFY_CHANGE_LAST_WRITE -- added/removed/renamed/written files;
_watch.add = function(path,callback,subtree,filter)
	if (type(path)~='string') then
		error('Watch Directory - Invalid path',0);
	elseif(type(callback)~='function') then
		error('Watch Directory - Invalid callback function',0);
	end
	local stream = _watch.stream;
	if ((#_watch.handles+1)*4 > stream.size) then
		stream.size = stream.size*2 -- update size of the stream
		
		-- memory address might change when updating stream size...
		if (_watch.streamAddr ~= stream.Memory) then
			_watch.streamAddr = stream.Memory;
			stream.Position = 0;
			for _,handle in ipairs(_watch.handles) do
				-- _watch.stream.writeDword(handle); -- 32 bit
				-- _watch.stream.writeQword(handle); -- 64 bit
				(is64bit and stream.writeQword or stream.writeDword)(handle);
			end
		end
	end
	if (not filter) then
		filter = _watch.fileFilter; -- lets watch by default when files are created/removed/written
	elseif (type(filter)=='string' and not tonumber(filter)) then
		filter = filter:lower() =='folder' and _watch.folderFilter or _watch.fileWrite
	end
	path = path:gsub("[^\\]+$",""); -- trim...
	subtree = subtree and 1 or 0
	local handle = executeCodeLocalEx('FindFirstChangeNotificationA',{3,path},subtree,filter); -- ANSI version.. 260 char length...
	-- local handle = executeCodeLocalEx('FindFirstChangeNotificationW',{4,path},subtree,filter); -- wide string, for longer paths
	if (not handle or handle == -1) then
		error(('Watch Directory - Failed to get handle for change notification! path: %s'):format(tostring(handle),path),0);
	end
	local sHandle = tostring(handle);
	local handleIndex = #_watch.handles+1;
	_watch.handles[sHandle] = handleIndex -- index.. so we could remove easily
	_watch.callback[handle] = callback;
	(is64bit and stream.writeQword or stream.writeDword)(handle);
	_watch.handles[handleIndex] = handle; -- insert to table only after everything else was written
	_watch.thread.resume(); -- resume regardless eh
	return handle -- handle to be used if we want to remove it later...
end

_watch.remove = function(handle) -- wait until timeout and let thread to clean up;
	_watch.removeQueue[#_watch.removeQueue+1] = handle;
	_watch.removeQueue[tostring(handle)] = true; -- before calling any callbacks after waiting for objects, make sure that the object was not marked for clean up.
end

_watch.thread_func = function(thread)
	while not thread.Terminated do
		if (#_watch.removeQueue > 0) then -- clean up..
			-- find handle..
			for key,handle in ipairs(_watch.removeQueue) do
				local sHandle = tostring(handle);
				local index = _watch.handles[sHandle]
				executeCodeLocal("FindCloseChangeNotification",handle); -- remove change notification handle...
				table.remove(_watch.handles,index); -- remove and shift table
				_watch.handles[sHandle] = nil;
				_watch.callback[handle] = nil;
			end
			_watch.removeQueue = {}; -- clean up;
			-- rebuild memory stream
			_watch.stream.Position = 0;
			local stream = _watch.stream;
			for _,handle in ipairs(_watch.handles) do
				(is64bit and stream.writeQword or stream.writeDword)(handle);
			end
		end
		if(#_watch.handles == 0) then
			-- suspend itself..
			thread.suspend();
		end
		local waitObject_Id = executeCodeLocalEx('WaitForMultipleObjects',#_watch.handles,_watch.streamAddr,0,_watch.timeout); -- 1 minute timeout...
		if (waitObject_Id) then
			if (waitObject_Id==0xFFFFFF) then
				error('Watch Directory - WAIT_FAILED',0);
			elseif(waitObject_Id ~=0x102) then -- 0x102 is time out, we set it to timeout once a minute (mainly to clean up).
				local handle = _watch.handles[waitObject_Id+1] -- waitObject_Id starts from 0 and upwards....
				if (not _watch.removeQueue[tostring(handle)]) then -- handle is not marked for clean up...
					local findNextNotify = executeCodeLocal("FindNextChangeNotification",handle);
					if (not findNextNotify or findNextNotify == 0) then
						error('Watch Directory - FindNextChangeNotification faield!',0);
					end
					synchronize(_watch.callback[handle]) -- call callback function from main thread... just in case I want to access GUI...
				end
			end
		end
	end
end
_watch.thread = createThreadSuspended(_watch.thread_func);
local _watchDirectry = {add = _watch.add; remove = _watch.remove};
if (not watchDirectory) then
	watchDirectory = _watchDirectry;
end
return _watchDirectry;