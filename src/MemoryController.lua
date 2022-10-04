require("PatternScanner")
require("joaat")

-- 40170+976+1
int = 'int'
float = 'float'
str = 'str'
bool = 'bool'
double = 'double'
short = 'short'
long = 'long'
addr = 'addr'

-------------------------------------------------NETWORKING----------------------------------------------------------
NETWORK = {

    GET_NETWORK_TIME = function()
        return get.Int(Global_(1312603 + 11))
    end,

    NETWORK_GET_LOCAL_HANDLE = function(Index, ScriptName)
        return get.Long(get.Memory(ScriptName)) + (8 * Index)
    end,

    NETWORK_GET_NUM_CONNECTED_PLAYERS = function()
        return get.Int(TOTAL_PLAYER);
    end,

    NETWORK_SESSION_IS_PRIVATE = function()
        return get.Bool(IS_SESSION_PUBLIC)
    end,

    NETWORK_IS_HOST = function()
        return get.Global(int, 1630317 + 1 + PLAYER_ID() * 595 + 10)
    end,

    NETWORK_IS_IN_TRANSITION = function()
        local JoinStatus = get.Int(JOIN_STATUS)
        local CheckScriptTransition = SCRIPT.DOES_SCRIPT_EXIST('fm_maintain_transition_players')
        local freemode = SCRIPT.DOES_SCRIPT_EXIST('freemode')
        if CheckScriptTransition and JoinStatus == 0 or JoinStatus == 10 and freemode then return  true end
        return false
    end,

    NETWORK_IS_SESSION_STARTED = function()
        local MainTransisi = SCRIPT.DOES_SCRIPT_EXIST('maintransition')
        local freemode = SCRIPT.DOES_SCRIPT_EXIST('freemode')
        return MainTransisi == true or freemode == true
    end,
}

-----------------------------------------------NETWORKING END----------------------------------------------------------

MEMORY = {
    --    void MEMORY::SET_BIT(int* addr, int bit) {
    --     *addr |= (1 << (bit + 1));
    -- }
    -- SET_BIT = function(Address, Offset)
    --     Address = Address | (1 << (Offset + 1))
    -- end,

    -- IS_BIT_SET = function(Address, Offset)
    --     return Address ~= Address | (1 << (Offset + 1))
    -- end,

    -- CLEAR_BIT = function(Address, Offset)
    --     Address = Address & ~(1 << (Offset + 1))
    -- end,
    --[[
Is_Bit_Set=function (_address,_bit)
    local v=readInteger(_address)
    if v==nil then
        print("Cannot read value from:",_address)
        return
    else
        return v & (1<<_bit)~=0
    end
end
Set_Bit=function(_address,_bit)
    local v=readInteger(_address)
    if v==nil then
        print("Cannot read value from:",_address)
        return false
    else
        local bm=(1<<_bit)
        local bn=v | bm
        if bn and bn~=v then
            writeInteger(_address,bn)
            return true
        end
    end
    return false
end
Clear_Bit=function(_address,_bit)
    local v=readInteger(_address)
    if v==nil then
        print("Cannot read value from:",_address)
        return false
    else
        local bm=(1<<_bit)
        if v & bm~=0 then
            local bn=(v & ~bm)
            if bn then
                writeInteger(_address,bn)
                return true
            else return false end
        else return false end
    end
end
    ]]

    SET_BIT = function(Address, Offset)
        local Var = get.Int(Address)
        set.int(Address, Var | (1 << Offset));
    end,

    IS_BIT_SET = function(Address, Offset)
        return get.Global(int, Address) & (1 << Offset) ~= 0
    end,

    CLEAR_BIT = function (Address, Offset)
        local Var = get.Int(Address)
        set.int(Address, Var & ~(1 << Offset))
    end,

}

set = {
    assembly = function(AssemblyCode, Disabler)
        return autoAssemble(AssemblyCode, Disabler)
    end,

    int = function(Address, Value)
        writeInteger(Address, Value)
    end,

    float = function(Address, Value)
        writeFloat(Address, Value)
    end,

    string = function(Address, Value)
        writeString(Address, Value)
    end,

    long = function(Address, Value)
        writeQword(Address, Value)
    end,

    short = function(Address, Value)
        writeSmallInteger(Address, Value)
    end,

    bool = function(Address, Value)
        local Var = type(Value) == 'boolean' and Boolean_To_Num(Value) or type(Value) == "string" and StrToBoolean(Value) or Value
        Var = Var ~= nil and Var & 0x01
        writeSmallInteger(Address, Var)
    end,

    byte = function(Address, Value)
        writeBytes(Address, Value)
    end,

    double = function(Address, Value)
        writeDouble(Address, Value)
    end,

    char = function(Address, String, Size)
        local bt = stringToByteTable(String)
        if #bt > Size then
            LuaEngineLog("too many characters")
            return
        elseif #bt == Size then
            goto continue
        end
        for i = 1, Size - (#bt), 1 do
            bt[#bt + i] = 0x00
        end
        ::continue::
        writeBytes(Address, bt)
    end,

    memory_value = function(Name, value)
        local memrec = getAddressList()
        memrec.getAddressList().getMemoryRecordByDescription(Name).Value = value
    end,

    memory_location = function(Name, LogA)
        getAddressList().getMemoryRecordByDescription(Name).Address = LogA
    end,

    scripts = function(Name, boolean)
        getAddressList().getMemoryRecordByDescription(Name).Active = boolean
    end,

    memory_type = function(Name, Types)
        getAddressList().getMemoryRecordByDescription(Name).Type = Types
    end,

    register_script = function(Register, Scriptname, Boolean)
        if Boolean then
            Register = Scriptname
        else
            Register = FALSE
        end
        return Register
    end,

    assembly_script = function(Script, Scriptname, Disabler, Activation)
        local function EnableScript()
            if not Scriptname then
                Scriptname, Disabler = set.assembly(Script)
            end
        end

        local function DisableScript()
            if Scriptname then
                if set.assembly(Script, Disabler) then
                    Scriptname = false
                end
            end
        end

        if Activation then
            EnableScript()
        else
            DisableScript()
            Script = false
        end
    end,

    global = function(Type, Index, Value)
        if Type == int then
            writeInteger(GA(Index), Value)
        elseif Type == float then
            writeFloat(GA(Index), Value)
        elseif Type == str then
            writeString(GA(Index), Value)
        elseif Type == bool then
            set.bool(GA(Index), Value)
        elseif Type == long then
            writeQword(GA(Index), Value)
        elseif Type == double then
            writeDouble(GA(Index), Value)
        elseif Type == short then
            writeSmallInteger(GA(Index), Value)
        else
            return print("NULL")
        end
    end,

    locals = function(Type, ScriptName, Index, Value)
        if Type == int then
            writeInteger(NETWORK.NETWORK_GET_LOCAL_HANDLE(Index, ScriptName .. "_ptr"), Value)
        elseif Type == float then
            writeFloat(NETWORK.NETWORK_GET_LOCAL_HANDLE(Index, ScriptName .. "_ptr"), Value)
        elseif Type == long then
            writeQword(NETWORK.NETWORK_GET_LOCAL_HANDLE(Index, ScriptName .. "_ptr"), Value)
        elseif Type == str then
            writeString(NETWORK.NETWORK_GET_LOCAL_HANDLE(Index, ScriptName .. "_ptr"), Value)
        end
    end
}

get = {
    Ptr = function(Pointer)
        return readPointer(Pointer)
    end,

    Int = function(Address)
        return readInteger(Address)
    end,

    Float = function(Address)
        return readFloat(Address)
    end,

    String = function(Address)
        return readString(Address)
    end,

    Long = function(Address)
        return readQword(Address)
    end,

    Short = function(Address)
        return readSmallInteger(Address)
    end,

    Bool = function(Address)
        local byte = readInteger(Address)
        local bool = byte ~= nil and byte & 0x1 or byte == nil and FALSE
        return bool == 1
    end,

    Byte = function(Address)
        local bytes = readInteger(Address)
        return bytes ~= nil and bytes & 0xff or bytes
    end,

    Double = function(Address)
        return readDouble(Address)
    end,

    Memory = function(Location)
        return getAddressSafe(Location)
    end,

    Memory_Value = function(Name)
        return AddressList.getMemoryRecordByDescription(Name).Value
    end,

    Scripts = function(Name)
        return AddressList.getMemoryRecordByDescription(Name).Active
    end,

    Assembly_Script = function(Returner, Script)
        return Returner == Script and true or false
    end,

    Memory_Location = function(Name)
        return AddressList.getMemoryRecordByDescription(Name).Address
    end,

    Memory_Type = function(Name)
        return AddressList.getMemoryRecordByDescription(Name).Type
    end,

    Opcode = function(Address)
        return disassemble(Address)
    end,

    Global = function(Type, Index)

        if Type == int then
            return get.Int(GA(Index))
        elseif Type == float then
            return get.Float(GA(Index))
        elseif Type == str then
            return get.String(GA(Index))
        elseif Type == bool then
            return get.Bool(GA(Index))
        elseif Type == long then
            return get.Long(GA(Index))
        elseif Type == double then
            return get.Double(GA(Index))
        elseif Type == short then
            return get.Short(GA(Index))
        elseif Type == addr then
            return get.Memory(GA(Index))
        else
            return print("NULL")
        end
    end,

    Locals = function(Type, Index, ScriptName)
        if Type == int then
            return readInteger(LA(Index, ScriptName))
        elseif Type == float then
            return readFloat(LA(Index, ScriptName))
        elseif Type == long then
            return readQword(LA(Index, ScriptName))
        elseif Type == str then
            return readString(LA(Index, ScriptName))
        end
    end
};

--[[{'MP'..MPX..'_H4LOOT_CASH_V',21000},
{'MP'..MPX..'_H4LOOT_WEED_V',21000},
{'MP'..MPX..'_H4LOOT_COKE_V',21000},
{'MP'..MPX..'_H4LOOT_GOLD_V',21000},
{'MP'..MPX..'_H4LOOT_PAINT_V',21000},
{'MP'..MPX..'_H4LOOT_COKE_C_SCOPED',0},
{'MP'..MPX..'_H4LOOT_GOLD_I_SCOPED',0},
--{'MP'..MPX..'_H4LOOT_WEED_C_SCOPED',720971},

]]

CPHbitset = {
    Kosatka = 0x000003,
    Velum = 0x000009,
    PatrolBoat = 0x000021,
    LongfinBoat = 0x000041,
    Alkonost = 0x000085,
    StealthAnnihilator = 0x000091,
    DemolitionCharges = 0x000100,
    CuttingTorch = 0x000200,
    PlasmaCutter = 0x000400,
    FingerprintCloner = 0x000800,
    WeaponMissionFinished = 0x001000,
    DisruptionOne = 0x002000,
    DisruptionTwo = 0x004000,
    DisruptionThree = 0x008000
};

MPX = get.Global(int, 1312763)
MPx = 'MP' .. MPX .. '_'

function MP_Auto()
    MPX = get.Global(int, 1312763)
    MPx = 'MP' .. MPX .. '_'
end

MP_Auto()

MPX = tostring(get.Global(int, 1312763))
MPx = tostring('MP' .. MPX .. '_')

function CPH_Arr()
    MPX = tostring(get.Global(int, 1312763))
    MPx = tostring('MP' .. MPX .. '_')
    CPHeist = 
    {
        {'MP' .. MPX .. '_H4LOOT_CASH_I', 0}, -- [139329]
        {'MP' .. MPX .. '_H4LOOT_CASH_I_SCOPED', 0}, -- [139329]
        {'MP' .. MPX .. '_H4LOOT_CASH_C', 0}, -- 28
        {'MP' .. MPX .. '_H4LOOT_CASH_C_SCOPED', 0}, -- 28
        {'MP' .. MPX .. '_H4LOOT_WEED_I', 0}, -- [278658]
        {'MP' .. MPX .. '_H4LOOT_WEED_I_SCOPED', 0}, -- [278658]
        {'MP' .. MPX .. '_H4LOOT_WEED_C', 0}, -- 42656
        {'MP' .. MPX .. '_H4LOOT_WEED_C_SCOPED', 0}, -- 42656
        {'MP' .. MPX .. '_H4LOOT_COKE_I', 0}, -- [557316] --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_I_SCOPED', 0}, -- [557316] --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_C', 0}, -- 720971 --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_C_SCOPED', 0}, -- 720971 --16777215
        {'MP' .. MPX .. '_H4LOOT_GOLD_I_SCOPED', 16777215}, -- [1114632]
        {'MP' .. MPX .. '_H4LOOT_GOLD_I', 16777215}, {'MP' .. MPX .. '_H4LOOT_GOLD_C_SCOPED', 255}, -- 131
        {'MP' .. MPX .. '_H4LOOT_GOLD_C', 255}, -- 131
        {'MP' .. MPX .. '_H4LOOT_PAINT_SCOPED', 255}, -- 48
        {'MP' .. MPX .. '_H4LOOT_PAINT', 255}, -- 48
        {'MP' .. MPX .. '_H4CNF_BS_ENTR', 63}, {'MP' .. MPX .. '_H4CNF_BS_ABIL', 63},
        {'MP' .. MPX .. '_H4CNF_WEP_DISRP', 3}, {'MP' .. MPX .. '_H4CNF_HEL_DISRP', 3},
        {'MP' .. MPX .. '_H4CNF_ARM_DISRP', 3}, {'MP' .. MPX .. '_H4CNF_BOLTCUT', 4641},
        {'MP' .. MPX .. '_H4CNF_GRAPPEL', 33024}, {'MP' .. MPX .. '_H4CNF_UNIFORM', 16770},
        {'MP' .. MPX .. '_H4CNF_TROJAN', 1}, {'MP' .. MPX .. '_H4CNF_APPROACH', -1},
        {'MP' .. MPX .. '_H4CNF_VOLTAGE', 3}, {'MP' .. MPX .. '_H4CNF_BS_GEN', 131071},
        {'MP' .. MPX .. '_H4CNF_WEAPONS', 2}, {'MP' .. MPX .. '_H4CNF_TARGET', 5},
        {'MP' .. MPX .. '_H4_PROGRESS', 130415}, {'MP' .. MPX .. '_H4_MISSIONS', 65535}
    }

    CPHeist2 = 
    {
        {'MP' .. MPX .. '_H4LOOT_CASH_I', 139329}, -- [139329]
        {'MP' .. MPX .. '_H4LOOT_CASH_I_SCOPED', 139329}, -- [139329]
        {'MP' .. MPX .. '_H4LOOT_CASH_C', 0}, -- 28
        {'MP' .. MPX .. '_H4LOOT_CASH_C_SCOPED', 0}, -- 28
        {'MP' .. MPX .. '_H4LOOT_WEED_I', 278658}, -- [278658]
        {'MP' .. MPX .. '_H4LOOT_WEED_I_SCOPED', 278658}, -- [278658]
        {'MP' .. MPX .. '_H4LOOT_WEED_C', 0}, -- 42656
        {'MP' .. MPX .. '_H4LOOT_WEED_C_SCOPED', 0}, -- 42656
        {'MP' .. MPX .. '_H4LOOT_COKE_I', 557316}, -- [557316] --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_I_SCOPED', 557316}, -- [557316] --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_C', 0}, -- 720971 --16777215
        {'MP' .. MPX .. '_H4LOOT_COKE_C_SCOPED', 0}, -- 720971 --16777215
        {'MP' .. MPX .. '_H4LOOT_GOLD_I_SCOPED', 1114632}, -- [1114632]
        {'MP' .. MPX .. '_H4LOOT_GOLD_I', 1114632}, {'MP' .. MPX .. '_H4LOOT_GOLD_C_SCOPED', 255}, -- 131
        {'MP' .. MPX .. '_H4LOOT_GOLD_C', 255}, -- 131
        {'MP' .. MPX .. '_H4LOOT_PAINT_SCOPED', 255}, -- 48
        {'MP' .. MPX .. '_H4LOOT_PAINT', 255}, -- 48
        {'MP' .. MPX .. '_H4CNF_BS_ENTR', 63}, {'MP' .. MPX .. '_H4CNF_BS_ABIL', 63},
        {'MP' .. MPX .. '_H4CNF_WEP_DISRP', 3}, {'MP' .. MPX .. '_H4CNF_HEL_DISRP', 3},
        {'MP' .. MPX .. '_H4CNF_ARM_DISRP', 3}, {'MP' .. MPX .. '_H4CNF_BOLTCUT', 4641},
        {'MP' .. MPX .. '_H4CNF_GRAPPEL', 33024}, {'MP' .. MPX .. '_H4CNF_UNIFORM', 16770},
        {'MP' .. MPX .. '_H4CNF_TROJAN', 1}, {'MP' .. MPX .. '_H4CNF_APPROACH', -1},
        {'MP' .. MPX .. '_H4CNF_VOLTAGE', 3}, {'MP' .. MPX .. '_H4CNF_BS_GEN', 131071},
        {'MP' .. MPX .. '_H4CNF_WEAPONS', 2}, {'MP' .. MPX .. '_H4CNF_TARGET', 5},
        {'MP' .. MPX .. '_H4_PROGRESS', 130415}, {'MP' .. MPX .. '_H4_MISSIONS', 65535}
    }

    Cayo_Perico_Award_Int = 
    {
        {'MP' .. MPX .. '_AWD_LOSTANDFOUND', 500000}, {'MP' .. MPX .. '_AWD_SUNSET', 1800000},
        {'MP' .. MPX .. '_AWD_TREASURE_HUNTER', 1000000},
        {'MP' .. MPX .. '_AWD_WRECK_DIVING', 1000000}, {'MP' .. MPX .. '_AWD_KEINEMUSIK', 1800000},
        {'MP' .. MPX .. '_AWD_PALMS_TRAX', 1800000}, {'MP' .. MPX .. '_AWD_MOODYMANN', 1800000},
        {'MP' .. MPX .. '_AWD_FILL_YOUR_BAGS', 200000000},
        {'MP' .. MPX .. '_AWD_WELL_PREPARED', 50}, {'MP' .. MPX .. '_H4_PLAYTHROUGH_STATUS', -1}
    }

    Cayo_Perico_Award_Bool = 
    {
        {'MP' .. MPX .. '_AWD_INTELGATHER', TRUE}, {'MP' .. MPX .. '_AWD_COMPOUNDINFILT', TRUE},
        {'MP' .. MPX .. '_AWD_LOOT_FINDER', TRUE}, {'MP' .. MPX .. '_AWD_MAX_DISRUPT', TRUE},
        {'MP' .. MPX .. '_AWD_THE_ISLAND_HEIST', TRUE}, {'MP' .. MPX .. '_AWD_GOING_ALONE', TRUE},
        {'MP' .. MPX .. '_AWD_TEAM_WORK', TRUE}, {'MP' .. MPX .. '_AWD_MIXING_UP', TRUE},
        {'MP' .. MPX .. '_AWD_PRO_THIEF', TRUE}, {'MP' .. MPX .. '_AWD_CAT_BURGLAR', TRUE},
        {'MP' .. MPX .. '_AWD_ONE_OF_THEM', TRUE}, {'MP' .. MPX .. '_AWD_GOLDEN_GUN', TRUE},
        {'MP' .. MPX .. '_AWD_ELITE_THIEF', TRUE}, {'MP' .. MPX .. '_AWD_PROFESSIONAL', TRUE},
        {'MP' .. MPX .. '_AWD_HELPING_OUT', TRUE}, {'MP' .. MPX .. '_AWD_COURIER', TRUE},
        {'MP' .. MPX .. '_AWD_PARTY_VIBES', TRUE}, {'MP' .. MPX .. '_AWD_HELPING_HAND', TRUE},
        {'MP' .. MPX .. '_AWD_ELEVENELEVEN', TRUE},
        {'MP' .. MPX .. '_COMPLETE_H4_F_USING_VETIR', TRUE},
        {'MP' .. MPX .. '_COMPLETE_H4_F_USING_LONGFIN', TRUE},
        {'MP' .. MPX .. '_COMPLETE_H4_F_USING_ANNIH', TRUE},
        {'MP' .. MPX .. '_COMPLETE_H4_F_USING_ALKONOS', TRUE},
        {'MP' .. MPX .. '_COMPLETE_H4_F_USING_PATROLB', TRUE}
    }
end

CPH_Arr()

--func_9241(&uLocal_5978, &uLocal_5979, &uLocal_11886);
function HashLoad()
    if not NETWORK.NETWORK_IS_IN_TRANSITION() then
        set.global(int, 2552060 + 1 + 10262 * 3 + 0 + 1, joaat('MPPLY_BECAME_CHEATER_NUM'))
        set.global(int, 2552060 + 1 + 10263 * 3 + 0 + 1, joaat('MP_PLAYING_TIME'))
        set.global(int, 2552060 + 1 + 10264 * 3 + 0 + 1, joaat('MPPLY_EXPLOITS'))
        set.global(int, 2552060 + 1 + 10265 * 3 + 0 + 1, joaat('MPPLY_GAME_EXPLOITS'))
        set.global(int, 2552060 + 1 + 10266 * 3 + 0 + 1, joaat('MPPLY_GRIEFING'))
        set.global(int, 2552060 + 1 + 70 * 3 + 0 + 1, joaat('MPPLY_TOTAL_SVC'))
        set.locals(int, 'freemode', 11699, 8)
        set.global(bool, 2440277 + 4110, true)
        Cheater = get.Global(long, 1630317 + 1 + PLAYER.PLAYER_ID() * 595 + 537 + 4)
        TimeSpent = get.Global(long, 1630317 + 1 + PLAYER.PLAYER_ID() * 595 + 537 + 5)
        Exploit = get.Global(long, 1630317 + 1 + PLAYER.PLAYER_ID() * 595 + 537 + 6)
        Glitch = get.Global(long, 1630317 + 1 + PLAYER.PLAYER_ID() * 595 + 537 + 7)
        Griefing = get.Global(long, 1630317 + 1 + PLAYER.PLAYER_ID() * 595 + 537 + 5)
        TotalSpent = get.Global(long,1590682+ 1 + PLAYER.PLAYER_ID() *883 + 211 + 44)
    end
end

function func_1275(iParam0)
    if (iParam0 < 32) then
        return MEMORY.IS_BIT_SET(2440277 + 502 + 102, iParam0)
    end
    return MEMORY.IS_BIT_SET(2440277 + 502 + 2, (iParam0 - 32))
end








--[[
    {'MP1_H4_PROGRESS',-1},
    {'MP1_H4LOOT_CASH_I',5000000},
    {'MP1_H4LOOT_CASH_C',5000000},
    {'MP1_H4LOOT_CASH_V',5000000},
    {'MP1_H4LOOT_WEED_I',5000000},
    {'MP1_H4LOOT_WEED_C',5000000},
    {'MP1_H4LOOT_WEED_V',5000000},
    {'MP1_H4LOOT_COKE_I',5000000},
    {'MP1_H4LOOT_COKE_C',5000000},
    {'MP1_H4LOOT_COKE_V',5000000},
    {'MP1_H4LOOT_GOLD_I',5000000},
    {'MP1_H4LOOT_GOLD_C',5000000},
    {'MP1_H4LOOT_GOLD_V',5000000},
    {'MP1_H4LOOT_PAINT',5000000},
    {'MP1_H4LOOT_PAINT_V',5000000},
]]---
--[[


now on the scoping thing. i've found a interesting notion, i've done a quick search on me target values:
$MPx_H4LOOT_CASH_V
88500
$MPx_H4LOOT_WEED_V
146600
$MPx_H4LOOT_COKE_V
222500
$MPx_H4LOOT_GOLD_V
329000
$MPx_H4LOOT_PAINT
179700

then i went to cayo perico and did found the right table inside the airport hangar containing cash, other had weed and in the top level the left one had weed and right one was empty:
$MPx_H4LOOT_CASH_I_SCOPED
8
$MPx_H4LOOT_WEED_I_SCOPED
5

then i went to the island and in shack near ze power plant i found the left table containing cash, right was coke:
$MPx_H4LOOT_CASH_I_SCOPED
24 (added 8)
$MPx_H4LOOT_COKE_I_SCOPED
32

after that i decided to check the cameras, found two paintings on the office, one gold and one cash inside the basement storage, gold was in the middle table and cash was in the first table you get to see when camera watching, the left one (I stats remained unchanged, i thought they would change because rockstar but nah):
$MPx_H4LOOT_CASH_C_SCOPED
128
$MPx_H4LOOT_GOLD_C_SCOPED
64
$MPx_H4LOOT_PAINT_SCOPED
24

went back and inside the north docks main hangar found one weed at the left table and one cash on the right one, inside the compound got at west storage and found some cash and gold, since they are a mess for localization it's on the two tables innit:
$MPx_H4LOOT_CASH_I_SCOPED
152 (added 128)
$MPx_H4LOOT_WEED_I_SCOPED
69 (added 64)
$MPx_H4LOOT_GOLD_C_SCOPED
72 (added 8)
$MPx_H4LOOT_CASH_C_SCOPED
132 (added 4)

then i got bored and scoped everything. haha, it'll take a while until i check the table value of each main loot.
]]

