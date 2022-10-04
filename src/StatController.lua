require("joaat")
require("MemoryController")
require("ArrayData")
-- GetStatValue
-- set.global(int, 2552060 + 3270, GAMEPLAY.GET_HASH_KEY(Hash)) GA(2552060 + 1 + 1065 * 3 + 73)
--set.global(int, 2552060 + 3269, GAMEPLAY.GET_HASH_KEY(Hash))
-- set.locals(int, 'freemode', 17191, 9)
-- Stat get float 2587374[iParam0 /*3*/][func_574(iParam1)];
-- Global_2426097[PLAYER::PLAYER_ID() /*443*/].f_261
-- Global_1590682[PLAYER::PLAYER_ID() /*883*/].f_850 = func_19155(211, -1);
-- Global_1590682[PLAYER::PLAYER_ID() /*883*/].f_852 = func_19155(212, -1);
-- func_6855(133, fVar1, -1, 1);
-- Global_2426097[PLAYER::PLAYER_ID() /*443*/].f_261 = fVar1;
function StatTimer()
    local IsRun = function()
        for i = 0,30,1 do
            SYSTEM.WAIT(1000)
            UnuqueTimer = i
        end
    end
    ExecuteThread(IsRun)
    return UnuqueTimer
end

STATS = {
    STAT_GET_FLOAT = function(Hash)--2587374
        if not NETWORK.NETWORK_IS_IN_TRANSITION() then
            set.global(int, 2591939 + 1 + 37 * 3 + get.Global(int,1312763) + 1,  type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash)
            set.locals(int, 'freemode', 12622, 9)--11699
            set.global(bool, 2441237 + 4117, true)--2440277 + 4110
            SYSTEM.WAIT(20)
            _G.FloatOut = get.Global(float, 1590908 + 1 + PLAYER_ID() * 874 + 205 + 57)--1590682 + 1 + PLAYER_ID() * 883 + 211 + 57
        end
        return FloatOut
    end,

    STAT_GET_INT = function(Hash) -- Return value to function
        local RestorePoint = joaat("MP0_LAP_DANCED_BOUGHT")
        set.global(int, 2555716 + 1 + 1090 * 3 + get.Global(int,1312763) + 1,  type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash)
        SYSTEM.WAIT(50)
        set.global(int, 1379108 + 1136, 15) -- 2551832
        SYSTEM.WAIT(20)
        _G.IntOut = get.Global(int, 2555428 + 276) -- 2551544
        return IntOut
    end,

    STAT_GET_BOOL = function(Hash)--2588062
        set.global(int, 2592627 + 1 + 130 * 3 + get.Global(int,1312763) + 1,  type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash)
        SYSTEM.WAIT(20)
        _G.BoolOut = MEMORY.IS_BIT_SET(1590908 + 1 + PLAYER_ID() * 874 + 205 + 49, 0) --1590682 + 1 + PLAYER_ID() * 883 + 211 + 49, 0
        return BoolOut
    end,

    STAT_GET_NUMBER_OF_DAYS = function(Hash) --Global_1323678[iParam0 /*141*/].f_103 = func_9619(16, -1);
        set.global(int, 2555716 + 1 + 16 * 3 + get.Global(int,1312763) + 1, joaat(Hash))
        return get.Global(int, 1323678 + 1 + PLAYER_ID() * 141 + 103)
    end,

    STAT_SET_FLOAT = function(Hash, value) --default : 2011892998 Int : 1368203800 value : 48085750 Float Hash : 3070906141 133*3
        local ThreadFloat = function()
            balik = false --2587374
            set.global(int, 2591939 + 1 + 98 * 3 + get.Global(int,1312763) + 1, type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash) --func_12452(818, 1209, 86);
            SYSTEM.WAIT(1000)--1164
            set.global(int, 2555716 + 1 + 1165 * 3 + get.Global(int,1312763) + 1, joaat('MP'..MPX..'_CIGARETTES_BOUGHT'))
            --set.global(float,2426097 + 1 + PLAYER_ID() * 443 + 261, value) --iVar 0 = 967270483 iVar1 = 2500733732
            set.global(int, 1390343 + 1 * 3 + 0 + 1, joaat('MP'..MPX..'_CIGARETTES_BOUGHT'))
            SYSTEM.WAIT(120)
            set.global(int, 31345, 0)--30968
            set.global(int, 31346, 0)--30969
            set.locals(int, 'freemode', 2369, 23)--2274
            set.global(int, 1379108 + 1139, 3) --1377236
            set.global(int, 2554029 + 305, 3)--2550376 + 305
            SYSTEM.WAIT(100)
            set.global(int, 2554029 + 305, 2)--2550376 + 305
            set.global(int, 1379108 + 1136, 21)
            set.global(int, 939452 + 5526, value)
            balik = true
        end
        ExecuteThread(ThreadFloat)
    end,

    STAT_SET_INT = function(Hash, value) -- Set Stat From Hash Key As Int
        balik = false
        local RestorePoint = joaat("MPPLY_AWD_FM_CR_MISSION_SCORE")
        set.global(int, 1390343 + 1 * 3 + 0 + 1,  type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash)
        SYSTEM.WAIT(50)
        set.global(int, 1379108 + 1139, 3)
        set.global(int, 2554029 + 305, 3)--2550376
        set.global(int, 939452 + 5526, value)
        balik = true
    end,
    -- new bool Local_17191
    STAT_SET_BOOL = function(Hash, bool) -- Set Stat From Hash Key As Bool
        local QueueBool = function() --set.global(int, 2588062 + 617, joaat(Hash)) -- 2587834
            balik = false
            set.global(int, 2592627 + 1 + 205 * 3 + get.Global(int, 1312763) + 1,  type(Hash) == 'string' and joaat(Hash) or type(Hash) == 'number' and Hash)
            SYSTEM.WAIT(500)
            set.bool(STAT_BOOL, bool)
            balik = true
        end
        ExecuteThread(QueueBool);
    end,

    STAT_LOOP_INT = function(ArrayName) -- Set Stat Group In Loop
        loop_stat = true
        local start = function()
            local c = 0
            for _ in pairs(ArrayName) do
                c = c + 1
            end
            for i, v in pairs(ArrayName) do
                STATS.STAT_SET_INT(v[1], v[2])
                StatTab.ImportView.Text = string.format("Apply: %s/%s", i, c)
                StatTab.joaat.Text = string.format("%s", v[1])
                StatTab.stat_value.Text = string.format("%s", v[2])
                SystemLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                LuaEngineLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                SYSTEM.WAIT(550)
                if i == c then 
                    STATS.STAT_SET_INT("MPPLY_AWD_FM_CR_MISSION_SCORE", 0) 
                    loop_stat = false
                end
            end -- Coroutine has completed, it will be marked as dead after this print..
        end
        ExecuteThread(start)
    end,

    STAT_FAST_INT = function(ArrayName) -- Set Stat Group In Loop
        loop_stat = true
        local start = function()
            local c = 0
            for _ in pairs(ArrayName) do
                c = c + 1
            end
            for i, v in pairs(ArrayName) do
                STATS.STAT_SET_INT(v[1], v[2])
                StatTab.ImportView.Text = string.format("Apply: %s/%s", i, c)
                StatTab.joaat.Text = string.format("%s", v[1])
                StatTab.stat_value.Text = string.format("%s", v[2])
                SystemLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                LuaEngineLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                SYSTEM.WAIT(120)
                if i == c then 
                    STATS.STAT_SET_INT("MPPLY_AWD_FM_CR_MISSION_SCORE", 0) 
                    loop_stat = false
                end
                if ArrayName == CPHeist or ArrayName == CPHeist2 and i == c then RestartPCSubmarine() end
            end 
        end
        ExecuteThread(start)
    end,

    STAT_LOOP_BOOL = function(ArrayName) -- Set Stat Group In Loop
        loop_stat = true
        local start = function()
            local c = 0
            for _ in pairs(ArrayName) do
                c = c + 1
            end
            for i, v in pairs(ArrayName) do
                STATS.STAT_SET_BOOL(v[1], TRUE)
                StatTab.ImportView.Text = string.format("Apply: %s/%s", i, c)
                StatTab.joaat.Text = string.format("%s", v[1])
                StatTab.stat_value.Text = string.format("%s", v[2])
                SystemLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                LuaEngineLog(string.format("%s : %s [Hash : 0x%X]", v[1], v[2], joaat(v[1])))
                SYSTEM.WAIT(3000)
                if i == c then 
                    STATS.STAT_SET_BOOL("MP"..MPX.."IS_VISOR_UP", 0) 
                    loop_stat = false
                end
            end
        end
        ExecuteThread(start);
    end,

    STAT_LOADER_BOOL = function()
        local tbl_Stats = {}
        FileName = tostring(Protection.FileName.Text)
        if FileName == nil or FileName == '' then
            return
        end
        local fs = assert(io.open(string.format('%s/%s.txt', _MyFilePath, FileName), "r"));
        local k, bool = 1, false
        for c = 1, 200, 1 do
            local line = fs:read("*line")
            if line == nil or line == '' then
                goto continue
            end
            if line == "BOOL" then
                bool = true
                goto bool
            end
            if c % 2 == 1 and bool == false then
                tbl_Stats[k] = {line}
            elseif c % 2 == 0 and bool == true then
                tbl_Stats[k] = {line}
            else
                tbl_Stats[k][2] = line
                k = k + 1
            end
            ::bool::
        end
        ::continue::
        fs:close();
        return tbl_Stats
    end,

    RUN_LOADER_BOOL = function()
        loop_stat = true
        local start = function()
            local MPX = tostring(get.Global(int, 1312763))
            local tbl_Stats = STATS.STAT_LOADER_BOOL()
            if tbl_Stats == nil then
                goto continue
            end
            local i = 0
            for _ in pairs(tbl_Stats) do
                i = i + 1
            end
            for c, k in pairs(tbl_Stats) do
                if k[1]:match("$") then
                    k[1] = k[1]:match("$([^,]+)")
                end
                k[1] = k[1]:sub(1, 2) .. MPX .. k[1]:sub(4)
                Protection_ImportView.Text = string.format("Apply: %s/%s", c, i)
                Protection_joaat.Text = string.format("%s", k[1])
                Protection_stat_value.Text = string.format("%s", k[2])
                STATS.STAT_SET_BOOL(k[1], k[2])
                SYSTEM.WAIT(1000)
                if c == i then 
                    STATS.STAT_SET_BOOL("MP"..MPX.."IS_VISOR_UP", 0) 
                    loop_stat = false
                end
            end
            ::continue::
        end
        ExecuteThread(start);
    end,

    STAT_LOADER_INT = function()
        local tbl_Stats = {}
        FileName = tostring(Protection.FileName.Text)
        if FileName == nil or FileName == '' then
            return
        end
        local fs = assert(io.open(string.format('%s/%s.txt', _MyFilePath, FileName), "r"));
        local k, int32 = 1, false
        for c = 1, 200, 1 do
            local line = fs:read("*line")
            if line == nil or line == '' then
                goto continue
            end
            if line == "INT32" then
                int32 = true
                goto int
            end
            if c % 2 == 1 and int32 == false then
                tbl_Stats[k] = {line}
            elseif c % 2 == 0 and int32 == true then
                tbl_Stats[k] = {line}
            else
                tbl_Stats[k][2] = line
                k = k + 1
            end
            ::int::
        end
        ::continue::
        fs:close();
        return tbl_Stats
    end,

    RUN_LOADER_INT = function()
        loop_stat = true
        local start = function()
            local MPX = tostring(get.Global(int, 1312763))
            local tbl_Stats = STATS.STAT_LOADER_INT()
            if tbl_Stats == nil then
                goto continue
            end
            local i = 0
            for _ in pairs(tbl_Stats) do
                i = i + 1
            end
            for c, k in pairs(tbl_Stats) do
                if k[1]:match("$") then
                    k[1] = k[1]:match("$([^,]+)")
                end
                k[1] = k[1]:sub(1, 2) .. MPX .. k[1]:sub(4)
                Protection_ImportView.Text = string.format("Apply: %s/%s", c, i)
                Protection_joaat.Text = string.format("%s", k[1])
                Protection_stat_value.Text = string.format("%s", k[2])
                STATS.STAT_SET_INT(k[1], k[2])
                SYSTEM.WAIT(210)
                if c == i then 
                    STATS.STAT_SET_INT("MPPLY_AWD_FM_CR_MISSION_SCORE", 0) 
                    loop_stat = false 
                end
            end
            ::continue::
        end
        ExecuteThread(start);
    end
}

SCRIPT = {
    REQUEST_SCRIPT = function(ScriptName)
        ScriptName = ScriptName:lower()
        local script_address = GetLocalScript(ScriptName)
        -- print("Scanning Local Script: "..ScriptName)
        Protection.ScriptLoop.Caption = "Scanning Local Script: " .. ScriptName;
        if not script_address then
            Protection.RunningStatus.Caption = 'Not Running';
            unregisterSymbol(ScriptName .. "_ptr")
            return FALSE;
        else
            unregisterSymbol(ScriptName .. "_ptr")
            registerSymbol(ScriptName .. "_ptr", script_address, true)
            Protection.RunningStatus.Caption = 'Running';
            return TRUE;
        end
    end,

    HAS_SCRIPT_LOADED = function(Scriptname)
        Scriptname = Scriptname:lower()
        local get_script = GetLocalScript(Scriptname)
        return get_script and true or false
    end,

    DOES_SCRIPT_EXIST = function(Scriptname)
        Scriptname = Scriptname:lower()
        local DoesScriptExist = get.Memory(Scriptname .. "_ptr")
        return DoesScriptExist and true or false
    end,

    SET_SCRIPT_AS_NO_LONGER_NEEDED = function(Scriptname)
        Scriptname = Scriptname:lower()
        local script_address = GetLocalScript(Scriptname)
        if script_address then
            unregisterSymbol(Scriptname .. "_ptr")
        end
    end,

    REQUEST_SCRIPT_WITH_NAME_HASH = function(ScriptHash)
        local script_address = GetLocalScriptFromHash(ScriptHash)
        -- print("Scanning Local Script: "..ScriptName)
        Protection.ScriptLoop.Caption = "Scanning Local Script: " .. ScriptHash;
        if not script_address then
            Protection.RunningStatus.Caption = 'Not Running';
            unregisterSymbol(ScriptHash .. "_ptr")
        else
            unregisterSymbol(ScriptHash .. "_ptr")
            registerSymbol(ScriptHash .. "_ptr", script_address, true)
            Protection.RunningStatus.Caption = 'Running';
        end
    end,

    DOES_SCRIPT_WITH_NAME_HASH_EXIST = function(ScriptHash)
        local DoesScriptExist = get.Memory(ScriptHash .. "_ptr")
        return DoesScriptExist and true or false
    end,

    SET_SCRIPT_WITH_NAME_HASH_AS_NO_LONGER_NEEDED = function(ScriptHash)
        local script_address = GetLocalScriptFromHash(ScriptHash)
        if script_address then
            unregisterSymbol(ScriptHash .. "_ptr")
        end
    end,

    TRIGGER_SCRIPT_EVENT = function(Struct_3_param0, uParam3, iParam4, uParam5)
        set.global(int, 2405074 + 77, Struct_3_param0)
        set.global(int, 2405074 + 680, uParam3)
        iParam6 = get.Memory(Global_(2405074 + 692))
        set.int(iParam6, iParam4)
        set.global(int, 2405074 + 668, uParam5)
    end
}

PLAYER = {
    SET_PLAYER_WANTED_LEVEL = function(value)
        set.int(PLAYER_WANTED_LEVEL, value)
    end,

    SET_PLAYER_INVINCIBLE = function(PlayerActivation)
        if PlayerActivation then
            set.bool(PLAYER_GOD, true)
            set.float(DMG_TO_HP, FALSE)
            set.float(DMG_TO_ARMOR, FALSE)
            set.float(PLAYER_RUN_SPD, 1.2)
            set.float(PLAYER_SWIM_SPD, 1.2)
            set.float(PLAYER_SNEAK_SPD, 1.2)
        elseif not PlayerActivation then
            set.bool(PLAYER_GOD, false)
            set.float(DMG_TO_HP, TRUE)
            set.float(DMG_TO_ARMOR, TRUE)
            set.float(PLAYER_RUN_SPD, 1)
            set.float(PLAYER_SWIM_SPD, 1)
            set.float(PLAYER_SNEAK_SPD, 1)
        end
        set.float(PLAYER_HP, 328)
        set.float(PLAYER_ARMOR, 50)
    end,

    SET_PLAYER_INVISIBLE = function(Activation)
        local turn_off = 47
        if Activation then
            set.int(CPlayer + 0x2C, 1)
        elseif not Activation then
            set.int(CPlayer + 0x2C, turn_off)
        elseif (true == get.Bool(CPlayer + IN_VEH2)) and (Activation) then
            set.int(CVehicle + 0x2C, 1)
        elseif (true == get.Bool(CPlayer + IN_VEH2)) and (not Activation) then
            set.int(CVehicle + 0x2C, turn_off)
        end
    end,

    SET_PLAYER_NO_RAGDOLL = function(Trigger)
        if Trigger then
            set.int(CPlayer + 0x10B8, 1)
        elseif not Trigger then
            set.int(CPlayer + 0x10B8, 32)
        end
    end,

    GODMODE_RESISTANCE = function(Activation)
        if Activation then
            set.float(CPlayerInfo + 0xCAC, -999)
        elseif not Activation then
            set.float(CPlayerInfo + 0xCAC, 1)
        end
    end,

    PLAYER_PED_ID = function()
        local x = readFloat(PLAYER_CORDX)
        local y = readFloat(PLAYER_CORDY)
        local z = readFloat(PLAYER_CORDZ)
        return x, y, z
    end,

    -- PLAYER.PLAYER_INDEX_ID(selected_player)
    PLAYER_INDEX_ID = function(selected_player)
        local x = get.Float(target_x[selected_player])
        local y = get.Float(target_y[selected_player])
        local z = get.Float(target_z[selected_player])
        return x, y, z
    end,

    SET_PLAYER_MAX_HEALTH = function(health)
        set.int(CPlayer + 0x2A0, health)
    end,

    PLAYER_ID = function()
        return PLAYER_ID()
    end,

    GET_PLAYER_INVINCIBLE = function(Player)
        local Status = get.Bool(PLGod[Player])
        return Player == PLAYER.PLAYER_ID() and get.Bool(CPlayer + GOD) or Status
    end,

    GET_PLAYER_WANTED_LEVEL = function(Player)
        return get.Global(int, 1630317 + 1 + (Player * 595) + 11 + 186)
    end
}

VEHICLE = {
    SET_VEHICLE_ENGINE_HEALTH = function(FLOAT)
        set.float(CVehicle + VEH_HP1, FLOAT)
        set.float(CVehicle + VEH_HP2, FLOAT)
        set.float(CVehicle + VEH_HP3, FLOAT)
        set.float(CVehicle + HP, FLOAT)
    end,

    EXPLODE_LAST_VEHICLE = function()
        set.float(CVehicle + VEH_HP1, -999)
        set.float(CVehicle + VEH_HP2, -999)
        set.float(CVehicle + VEH_HP3, -999)
        set.float(CVehicle + HP, -999)
    end,
    IS_VEHICLE_MODEL = function(hash)
        local Hash = get.Ptr(CVehicle + 0x20)
        local Model = get.Int(Hash + 0x18)
        return hash == Model and true or false
    end,

    CREATE_VEHICLE = function(Dist, cord_x, cord_y, cord_z, Heading_X, Heading_Y, pegasus, Hash)
        local spawner_z = get.Float(cord_z)
        local head = get.Float(Heading_X)
        local head2 = get.Float(Heading_Y)
        local spawner_x = get.Float(cord_x) - (head2 * Dist)
        local spawner_y = get.Float(cord_y) + (head * Dist)

        set.global(float, 2463533 + 7 + 0, spawner_x)
        set.global(float, 2463533 + 7 + 1, spawner_y)
        set.global(float, 2463533 + 7 + 2, spawner_z)
        set.int(VEH_LIST, joaat(Hash))
        set.global(bool, 2463533 + 27 + 28, 1) -- weaponised ownerflag
        set.int(BYPASS_VEH_1, 14) -- ownerflag
        set.int(BYPASS_VEH_2, 2) -- personal car ownerflag
        set.global(bool, 2463533 + 5, true) ---SET('i',CarSpawn+0x1168, 1)  --can spawn flag must be odd
        set.global(bool, 2463533 + 2, true) ---SET('i',CarSpawn+0x1180, 1) --spawn toggle gets reset to 0 on car spawn
        set.global(bool, 2463533 + 3, pegasus)
        set.global(int, 2463533 + 27 + 74, 1) -- Red Neon Amount 1-255 100%-0%
        set.global(int, 2463533 + 27 + 75, 1) -- Green Neon Amount 1-255 100%-0%
        set.global(int, 2463533 + 27 + 76, 0) -- Blue Neon Amount 1-255 100%-0%
        set.global(int, 2463533 + 27 + 77, 4030726305) -- landinggear/vehstate
        -- set.global(int,2462514+27+5, -1)  --default paintjob primary -1 auto 120
        -- set.global(int,2462514+27+6, -1)  --default paintjob secondary -1 auto 120
        set.global(int, 2463533 + 27 + 7, -1)
        set.global(int, 2463533 + 27 + 8, -1)
        set.global(int, 2463533 + 27 + 19, 4)
        set.global(int, 2463533 + 27 + 60, 1)
        -- set.global(int,2462514+27+20,1)
        set.global(int, 2463533 + 27 + 21, 3)
        set.global(int, 2463533 + 27 + 22, 6)
        set.global(int, 2463533 + 27 + 23, 9)
        set.global(int, 2463533 + 27 + 24, 58)
        set.global(int, 2463533 + 27 + 25, 13)
        set.global(int, 2463533 + 27 + 26, 18)
        set.global(int, 2463533 + 27 + 27, 1)
        -- set.global(int,2462514+27+69,8) ---Wheel type
        -- set.global(int,2462514+27+33,217) --Wheel Selection
        -- 2462514+27+17 --Pokoknya depan mesin mobil (vent)
        -- 2462514+27+14 -- Exhaust
        -- 2462514+27+13 -- side skirt
        -- 2462514+27+12 -- Back Bumper
        return get.Global(int, 2544210+6610)--get.Global(int,2540612+6583);
    end,

    _SET_VEHICLE_UNK_DAMAGE_MULTIPLIER = function(Vehicle, Float)
        local damage = get.Ptr(CVehicle + 0x938)
        local Vehiclehash = VEHICLE.IS_VEHICLE_MODEL(Vehicle)
        if Vehiclehash == true then
            set.float(damage + 0xF0, Float)
            set.float(damage + 0xF4, Float)
            set.float(damage + 0xF8, Float)
            set.float(damage + 0xFC, Float)
        else
            return false
        end
    end,

    MODIFY_VEHICLE_TOP_SPEED = function(Value)
        Value = tonumber(Value)
        local m = (Value + 100) * 0.01
        set.float('[[[WorldPTR]+8]+D30]+AC0', Value) -- __EngineMultiplier

        local fInitialDragCoeff = get.Float('[[[[WorldPTR]+8]+D30]+938]+10')
        fInitialDragCoeff = fInitialDragCoeff / m
        if fInitialDragCoeff == nil or fInitialDragCoeff == 0.0 then
            return
        end
        fInitialDragCoeff = tonumber(string.format('%.5f', fInitialDragCoeff))
        set.float('[[[WorldPTR]+8]+D30]+A48', fInitialDragCoeff)

        local fInitialDriveForce = get.Float('[[[[WorldPTR]+8]+D30]+938]+60')
        fInitialDriveForce = fInitialDriveForce * m
        if fInitialDriveForce == nil or fInitialDriveForce == 0.0 then
            return
        end
        fInitialDriveForce = tonumber(string.format('%.5f', fInitialDriveForce))
        set.float('[[[WorldPTR]+8]+D30]+8A4', fInitialDriveForce)

        local fDriveMaxFlatVel = get.Float('[[[[WorldPTR]+8]+D30]+938]+64')
        fDriveMaxFlatVel = fDriveMaxFlatVel * m
        if fDriveMaxFlatVel == nil or fDriveMaxFlatVel == 0.0 then
            return
        end
        fDriveMaxFlatVel = tonumber(string.format('%.5f', fDriveMaxFlatVel))
        set.float('[[[WorldPTR]+8]+D30]+8AC', fDriveMaxFlatVel)

        local fInitialDriveMaxFlatVel = get.Float('[[[[WorldPTR]+8]+D30]+938]+68')
        fInitialDriveMaxFlatVel = fInitialDriveMaxFlatVel * m
        if fInitialDriveMaxFlatVel == nil or fInitialDriveMaxFlatVel == 0.0 then
            return
        end
        fInitialDriveMaxFlatVel = tonumber(string.format('%.5f', fInitialDriveMaxFlatVel))
        set.float('[[[WorldPTR]+8]+D30]+8A8', fInitialDriveMaxFlatVel)
    end,

    SET_VEHICLE_FIXED = function (VehID)
        set.global(2405074+2662,VehID)
    end,

    IS_THIS_MODEL_A_PLANE = function(Hash)
        for _,v in pairs(plane) do
            if Hash == joaat(v[2]) then
                return true
            end
        end
        return false
    end,

    IS_THIS_MODEL_A_HELI = function(Hash)
        for _,v in pairs(helicopter) do
            if Hash == joaat(v[2]) then
                return true
            end
        end
        return false
    end, 

    IS_THIS_MODEL_A_BOAT = function(Hash)
        for _,v in pairs(c_boat) do
            if Hash == joaat(v[2]) then
                return true
            end
        end
        return false
    end, 

    IS_THIS_MODEL_A_BIKE = function(Hash)
        for _,v in pairs(bikes) do
            if Hash == joaat(v[2]) then
                return true
            end
        end
        return false
    end, 

    IS_THIS_MODEL_A_FLYING = function (Hash)
        for _,v in pairs(FlyingVehicle) do
            if Hash == joaat(v[2]) then
                return true
            end
        end
        return false
    end, 
}

FORM = {
    ADD_LOCAL = function(formname, arrayname, Item1)
        formname.Items.clear()
        formname.items.add(Item1)
        for n, l in ipairs(arrayname) do
            local ScriptStatus = 'Killed'
            if SCRIPT.HAS_SCRIPT_LOADED(l) == true then
                ScriptStatus = 'Running'
            end
            formname.items.add(string.format('[%i]%s :%s', n, l, ScriptStatus))
        end
        formname.ItemIndex = 0
    end,

    ADD_STD = function(formname, arrayname)
        formname.Items.clear()
        for k, v in pairs(arrayname) do
            formname.items.add(v)
        end
        formname.ItemIndex = 0
    end,

    ADD_STD_2 = function(ObjeName, Arrayname, Item1)
        ObjeName.Items.clear()
        ObjeName.items.add(Item1)
        for k, v in pairs(Arrayname) do
            ObjeName.items.add(v)
        end
        ObjeName.ItemIndex = 0
    end,

    ADD_LOOP = function(ObjeName, Arrayname, iVar)
        ObjeName.Items.clear()
        for k, v in pairs(Arrayname) do
            ObjeName.items.add(v[iVar])
        end
        ObjeName.ItemIndex = 0
    end,

    ADD_LOOP_2 = function(ObjeName, Arrayname, iVar, Item1)
        ObjeName.Items.clear()
        ObjeName.items.add(Item1)
        for k, v in pairs(Arrayname) do
            ObjeName.items.add(v[iVar])
        end
        ObjeName.ItemIndex = 0
    end,

    ADD_LOOP_3 = function(ObjeName, Arrayname, Item1)
        ObjeName.Items.clear()
        ObjeName.items.add(Item1)
        for k, v in pairs(Arrayname) do
            ObjeName.items.add(string.format('%s (%s)', v[2], v[4]))
        end
        ObjeName.ItemIndex = 0
    end,

    ADD_ADDRESS = function(Address, Description)
        local list = getAddressList()
        local rec = list.createMemoryRecord()
        rec.setAddress(Address)
        rec.setDescription(Description)
    end

}

THREAD = {

    func_1 = function(funcName, boolean, interval)
        func_1_loop = boolean
        local func = AsyncBegin(function()
            while (func_1_loop) do
                funcName()
                if not func_1_loop then
                    break
                end
                Wait();
            end
        end);
        AsyncEnd(func, interval)
    end,

    YIELD = function(funcName, Trigger, Value, interval)
        YIELD_LOOP = Trigger
        local yielder = AsyncBegin(function()
            while (YIELD_LOOP) do
                funcName(Value)
                if not YIELD_LOOP then
                    funcName(Value)
                    break
                end
                Wait();
            end
        end)
        AsyncEnd(yielder, interval)
    end,

    YIELD2 = function(funcName, Trigger, Value1, Value2, interval)
        YIELD2_LOOP = Trigger
        local yielder2 = AsyncBegin(function()
            while (YIELD2_LOOP) do
                funcName(Value1, Value2)
                if not YIELD2_LOOP then
                    break
                end
                Wait();
            end
        end)
        AsyncEnd(yielder2, interval)
    end,

    LOOPING = function(funcName, Trigger, Value, interval)
        LOOPING_LOOP = Trigger
        local looping = AsyncBegin(function()
            while (LOOPING_LOOP) do
                funcName(Value)
                if not TriggLOOPING_LOOPer then
                    break
                end
                Wait();
            end
        end)
        AsyncEnd(looping, interval)
    end,

    FUNC_1 = function(funcName, Trigger, interval)
        loop_FUNC_1 = Trigger
        local co1 = AsyncBegin(function()
            while (loop_FUNC_1 == true) do
                funcName()
                if loop_FUNC_1 == false then
                    loop_FUNC_1 = false
                    break
                end
                Wait();
            end
        end)
        AsyncEnd(co1, interval)
    end,

    NATIVE_LOOP = function(funcName, Boolean, Interval)
        LoopStarter = Boolean
        LoopBreaker = Boolean
        function LoopRunner()
            while (LoopStarter == TRUE) do
                SYSTEM.WAIT(Interval);
                funcName()
                if LoopBreaker == FALSE then
                    LoopStarter = FALSE
                    break
                end
            end
        end
        ExecuteThread(LoopRunner);
    end,

    NATIVE_LOOP_2 = function(funcName, Value, Boolean, Interval)
        NATIVE_LOOP_2_Starter = Boolean
        NATIVE_LOOP_2_Breaker = Boolean
        local function NewThread()
            while (NATIVE_LOOP_2_Starter == TRUE) do
                SYSTEM.WAIT(Interval);
                funcName(Value)
                if NATIVE_LOOP_2_Breaker == FALSE then
                    NATIVE_LOOP_2_Starter = FALSE
                    break
                end
            end
        end
        ExecuteThread(NewThread);
    end,

    SPECIAL_NATIVE = function(func, Value, Boolean, Interval)
        local function ThreadStart()
            while (Boolean) do
                SYSTEM.WAIT(Interval);
                funcName(Value)
                if not Boolean then
                    break
                end
            end
        end
        ExecuteThread(ThreadStart)
    end,

    SPECIAL_YIELD = function(funcName, Value, Trigger, interval)
        loop_s = Trigger
        local co1 = AsyncBegin(function()
            while (loop_s == true) do
                funcName(Value)
                if loop_s == false then
                    loop_s = false
                    break
                end
                Wait();
            end
        end);
        AsyncEnd(co1, interval)
    end
};
-- local ntime = os.clock() + milisecond / 1000
        -- repeat
        -- until os.clock() > ntime
SYSTEM = {
    WAIT = function(milisecond)
        sleep(milisecond)
    end
}
UI = {
    GET_BLIP_COORD = function(Blip)
        a = get.Memory("BlipPTR")
        for i = 2000, 1, -1 do
            local n = get.Ptr(a + (i * 8))
            if (n > 0) and (Blip == get.Int(n + 0x40)) then
                local x = get.Float(n + 0x10)
                local y = get.Float(n + 0x14)
                local z = (Blip == 8 and get.Float(CurrentZGround) == 20) and 225 or get.Float(n + 0x18)
                return x,y,z
            end
        end
    end,
    DOES_BLIP_EXIST = function(Blip)
        a = get.Memory("BlipPTR")
        for i = 2000, 1, -1 do
            local n = get.Ptr(a + (i * 8))
            if (n > 0) and (Blip == get.Int(n + 0x40)) then
                local x = get.Float(n + 0x10)
                local y = get.Float(n + 0x14)
                local z = get.Float(n + 0x18)
                return (x ~= nil and y ~= nil and z ~= nil)
            end
        end
        return false
    end
}
ENTITY = {}
ENTITY.SET_ENTITY_HEALTH = function(health)
    set.float(CPlayer + 0x280, health)
end

ENTITY.GET_PLAYER_COORD = function()
    local x = readFloat(PLAYER_CORDX)
    local y = readFloat(PLAYER_CORDY)
    local z = readFloat(PLAYER_CORDZ)
    return x, y, z
end

ENTITY.SET_ENTITY_INVINCIBLE = function(activation)
    local FLOAT = (activation == TRUE and 0 or 1) or (activation == true and 0 or 1)
    local BELT = (activation == TRUE and 0xC9 or 0xC8) or (activation == true and 0xC9 or 0xC8)
    set.bool("[[[PED_FACTORY]+CPED]+VEH]+GOD", activation)
    set.byte(CPlayer + SEATBELT, BELT)
    set.float("[[[[PED_FACTORY]+CPED]+VEH]+HANDLING]+COL", FLOAT)
    set.float("[[[[PED_FACTORY]+CPED]+VEH]+HANDLING]+WEP_COL", FLOAT)
    set.float("[[[[PED_FACTORY]+CPED]+VEH]+HANDLING]+VEH_COL", FLOAT)
    set.float("[[[[PED_FACTORY]+CPED]+VEH]+HANDLING]+ENGINE_COL", FLOAT)
    set.float("[[[PED_FACTORY]+CPED]+VEH]+HP", "999")
    set.float("[[[PED_FACTORY]+CPED]+VEH]+VEH_HP1", "999")
    set.float("[[[PED_FACTORY]+CPED]+VEH]+VEH_HP2", "999")
    set.float("[[[PED_FACTORY]+CPED]+VEH]+VEH_HP3", "999")

end

ENTITY.f_Round = function(float, digits)
    return string.format("%." .. digits .. "f", float);
end

ENTITY.GET_ENTITY_COORD = function(digits)
    local coord = digits
    local arr_coord = {}
    if coord == PLAYER.PLAYER_PED_ID() then
        return ENTITY.GET_ENTITY_COORD(3)
    end
    local CPlayer = get.Ptr(get.Ptr("WorldPTR") + 0x8)
    local Nav = get.Ptr(CPlayer + 0x30)
    local x = ENTITY.f_Round(get.Float(Nav + 0x50), digits)
    local y = ENTITY.f_Round(get.Float(Nav + 0x54), digits)
    local z = ENTITY.f_Round(get.Float(Nav + 0x58), digits)
    return x, y, z
end --[[//print(f_GetCoords(2))]]

ENTITY.SET_ENTITY_COORD = function(x, y, z)
    if x and y and z then
        local CPlayer = get.Ptr(get.Ptr("WorldPTR") + 0x8)
        if PED.IS_PED_IN_ANY_VEHICLE() then
            CPlayer = get.Ptr(CPlayer + 0xD30)
        end
        local Nav = get.Ptr(CPlayer + 0x30)
        set.float(Nav + 0x50, x)
        set.float(Nav + 0x54, y)
        set.float(Nav + 0x58, z)
        set.float(CPlayer + 0x90, x)
        set.float(CPlayer + 0x94, y)
        set.float(CPlayer + 0x98, z)
    end
    LuaEngineLog(string.format("Set Coodinates To X : %.5f | Y : %.5f | Z : %.5f", x, y, z))
end

_MyFilePath = '';
if TrainerOrigin ~= nil then
    _MyFilePath = TrainerOrigin
else
    _MyFilePath = getCheatEngineDir();
end

ENTITY.SAVE_ENTITY_CORD = function()
    local x, y, z, LocationName, vtbl = '', '', '', '', ''
    LocationName = tostring(Struct.SaveTeleportName.Text)
    -- inputQuery('Save Teleport Location','Enter Location Name','')
    if LocationName == nil or LocationName == '' then
        return
    end
    x, y, z = ENTITY.GET_ENTITY_COORD(PLAYER.PLAYER_PED_ID())
    local fs = assert(io.open(string.format('%s/Teleport Locations.txt', _MyFilePath), "a+"));
    vtbl = string.format('%s x:%s, y:%s, z:%s\n', LocationName, x, y, z)
    fs:write(vtbl);
    fs:close();
end

function ENTITY.GET_LOCATION()
    local x, y, z, LocationName, vtbl, tbl_Locations = '', '', '', '', '', {}
    local fs = assert(io.open(string.format('%s/Teleport Locations.txt', _MyFilePath), "r"));
    for c = 1, 200, 1 do
        local line = fs:read("*line")
        if line == nil or line == '' then
            goto continue
        end
        local ls1, ls2 = string.find(line, ' x:')
        local ls3, ls4 = string.find(line, ', y:')
        local ls5, ls6 = string.find(line, ', z:')
        local sbn, sbx, sby, sbz = string.sub(line, 1, ls1 - 1), string.sub(line, ls2 + 1, ls3 - 1),
            string.sub(line, ls4 + 1, ls5 - 1), string.sub(line, ls6 + 1, string.len(line))
        table.insert(tbl_Locations, c, {sbn, sbx, sby, sbz})
    end
    ::continue::
    fs:close();
    return tbl_Locations
end

function READ_POS()
    local x, y, z, LocationName, vtbl, cord_arr = '', '', '', '', '', {}
    local tdata = assert(io.open(string.format('%s/coordinates.vpl', _MyFilePath), "r"));
    for c = 1, 200, 1 do
        local line = tdata:read("*line")
        if line == nil or line == '' then
            goto continue
        end
        local ls1, ls2 = string.find(line, ' x:')
        local ls3, ls4 = string.find(line, ', y:')
        local ls5, ls6 = string.find(line, ', z:')
        local sbn, sbx, sby, sbz = string.sub(line, 1, ls1 - 1), string.sub(line, ls2 + 1, ls3 - 1),
            string.sub(line, ls4 + 1, ls5 - 1), string.sub(line, ls6 + 1, string.len(line))
        table.insert(cord_arr, c, {sbn, sbx, sby, sbz})
    end
    ::continue::
    tdata:close();
    return cord_arr
end

function ENTITY.SET_CORD(to, x, y, z, yaw)
    local a = hook.GET("BlipPTR")
    -- Waypoint
    if to == 'w' then
        for i = 2000, 1, -1 do
            local n = get.Ptr(a + (i * 8))
            if (n > 0) and (8 == get.Int(n + 0x40)) and (84 == get.Int(n + 0x48)) then
                local x = get.Float(n + 0x10)
                local y = get.Float(n + 0x14)
                local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
                if PED.IS_PED_IN_ANY_VEHICLE() then
                    p = get.Ptr(p + VEH)
                end
                local v = get.Ptr(p + 0x30)
                set.float(v + 0x50, x)
                set.float(v + 0x54, y)
                set.float(v + 0x58, -255)
                set.float(p + 0x90, x)
                set.float(p + 0x94, y)
                set.float(p + 0x98, -255)
            end
        end
    end
    -- Objective
    if to == 'o' then
        for i = 2000, 1, -1 do
            local n = get.Ptr(a + (i * 8))
            if (n > 0) and (1 == get.Int(n + 0x40)) and
                ((5 == get.Int(n + 0x48)) or (60 == get.Int(n + 0x48)) or (66 == get.Int(n + 0x48))) then
                local x = get.Float(n + 0x10)
                local y = get.Float(n + 0x14)
                local z = get.Float(n + 0x18) + 0.5
                local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
                if (true == get.Bool(p + IN_VEH2)) then
                    set.int("[[[WorldPTR]+8]+D30]+C5C", 4290772992)
                    p = get.Ptr(p + VEH)
                end
                set.int("GTA5.exe+1E07E38", 4290772992)
                local v = get.Ptr(p + POS)
                set.float(v + CORDX, x)
                set.float(v + CORDY, y)
                set.float(v + CORDZ, z)
                set.float(p + VECX, x)
                set.float(p + VECY, y)
                set.float(p + VECZ, z)
                break
            end
        end
        SYSTEM.WAIT(200)
        if PED.IS_PED_IN_ANY_VEHICLE() then
            local CurrentCoord = get.Float(PLAYER_CORDZ)
            set.float("GTA5.exe+1E07E38", -9.8)
            set.float("[[[WorldPTR]+8]+D30]+C5C", 9.8)
            set.float("[[[[WorldPTR]+8]+D30]+30]+58",CurrentCoord + 3)
            set.float("[[[WorldPTR]+8]+D30]+98",CurrentCoord + 3)
        else
            set.float("GTA5.exe+1E07E38", -9.8)
            set.float(CPlayerPos + 0x58,CurrentCoord + 3)
            set.float(CPlayer + 0x98,CurrentCoord + 3)
        end
    end
    -- Blip NORTH = ENTITY.SET_CORD('i',7)
    if to == 'i' then
        for i = 2000, 1, -1 do
            local n = get.Ptr(a + (i * 8))
            if (n > 0) and (x == get.Int(n + 0x40)) then
                local x = get.Float(n + 0x10)
                local y = get.Float(n + 0x14)
                local z = get.Float(n + 0x18) + 0.1
                local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
                if (true == get.Bool(p + IN_VEH2)) then
                    p = get.Ptr(p + VEH)
                end
                local v = get.Ptr(p + POS)
                set.float(v + CORDX, x)
                set.float(v + CORDY, y)
                set.float(v + CORDZ, z)
                set.float(p + VECX, x)
                set.float(p + VECY, y)
                set.float(p + VECZ, z)
                break
            end
        end
    end
    -- Custom Coords
    if to == 'c' then
        local z = z + 0.03
        local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
        if (true == get.Bool(p + IN_VEH2)) then
            p = get.Ptr(p + VEH)
        end
        local v = get.Ptr(p + POS)
        set.float(v + CORDX, x)
        set.float(v + CORDY, y)
        set.float(v + CORDZ, z)
        set.float(p + VECX, x)
        set.float(p + VECY, y)
        set.float(p + VECZ, z)
    end
    -- Forward
    if to == 'f' then
        local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
        if (true == get.Bool(p + IN_VEH2)) then
            p = get.Ptr(p + VEH)
        end
        local v = get.Ptr(p + POS)
        local head = get.Float(v + HEADX)
        local head2 = get.Float(v + HEADY)
        local x = get.Float(v + CORDX)
        local y = get.Float(v + CORDY)
        local newx = x - (head2 * 3)
        local newy = y + (head * 3)
        set.float(v + CORDX, newx)
        set.float(v + CORDY, newy)
        set.float(p + VECX, newx)
        set.float(p + VECY, newy)
    end
    -- Last Vehicle
    if to == 'v' then
        local p = get.Ptr(get.Ptr(hook.GET("WorldPTR")) + CPED)
        local v = get.Ptr(p + POS)
        local CVehicle = get.Ptr(p + VEH)
        local CVNavigation = get.Ptr(CVehicle + POS)
        local x = get.Float(CVNavigation + CORDX)
        local y = get.Float(CVNavigation + CORDY)
        local z = get.Float(CVNavigation + CORDZ) + 0.5
        set.float(v + CORDX, x)
        set.float(v + CORDY, y)
        set.float(v + CORDZ, z)
        set.float(p + VECX, x)
        set.float(p + VECY, y)
        set.float(p + VECZ, z)
    end
end

MISC = {
    GET_GROUND_Z_FOR_3D_COORD = function(x,y,z,pointer_z)
        return get.Float(WaypointZCoord) ~= 0
    end,
}

function GetGroundZCoord()
    return get.Float(WaypointZCoord) ~= 0
end
-- {$lua}
-- local a = getAddress("BlipPTR")
-- for i = 2000, 1, -1
-- do
--   local n = readPointer(a + (i * 8))
--   if (n > 0) and (8 == readInteger(n + 0x40)) and (84 == readInteger(n + 0x48))
--   then
--     local x = readFloat(n + 0x10)
--     local y = readFloat(n + 0x14)
--     local p = readPointer(readPointer(getAddress("WorldPTR")) + 8)
--     if (2 == readInteger(p + 0x148C))
--     then
--       p = readPointer(p + 0xD30)
--       writeInteger ("[[[WorldPTR]+8]+D30]+C5C", 4290772992)
--       elseif (0 == readInteger(p + 0x148C))
--     then
--       p = readPointer(p + 0xD30)
--       writeInteger ("[[[WorldPTR]+8]+D30]+C5C", 4290772992)
--     end
--     local v = readPointer(p + 0x30)
--     writeFloat(v + 0x50, x)
--     writeFloat(v + 0x54, y)
--     writeFloat(v + 0x58, 150)
--     writeFloat(p + 0x90, x)
--     writeFloat(p + 0x94, y)
--     writeFloat(p + 0x98, 150)
--     writeInteger("GTA5.exe+1E07E38", 4290772992)
--   end
-- end
-- if (readInteger("[[WorldPTR]+8]148C") == 2) or (readInteger("[[WorldPTR]+8]148C") == 0)
-- then
--     writeFloat ("[[[[WorldPTR]+8]+D30]+30]+58", readFloat("GTA5.exe+26BF888")+1)
--     writeFloat ("[[[WorldPTR]+8]+D30]+98", readFloat("GTA5.exe+26BF888")+1)
--     sleep(32)
--     writeFloat ("GTA5.exe+1E07E38", -9.8)
--     writeFloat ("[[[WorldPTR]+8]+D30]+C5C", 9.8)
-- else
--     writeFloat ("[[[WorldPTR]+8]+30]+58", readFloat("GTA5.exe+26BF888")+1)
--     writeFloat ("[[WorldPTR]+8]+98", readFloat("GTA5.exe+26BF888")+1)
--     sleep(32)
--     writeFloat ("GTA5.exe+1E07E38", -9.8)
-- end

------------------ENTITY PART END---------------------------------------------------------------------------------

function CleanLocalScript(t)
    cleanedlocals = {}
    for k, v in pairs(t) do
        if (SCRIPT.DOES_SCRIPT_EXIST(v) == true) then
            table.insert(cleanedlocals, v)
        end
        SYSTEM.WAIT(15)
    end
    return cleanedlocals
end

-- return ReadMemory<DWORD64>(phandle, (Base + GlobalPTR) + (8 * (AtIndex >> 0x12 & 0x3F))) + (8 * (AtIndex & 0x3FFFF));

--[[
    it's my favorite array in my table
[[[[[WorldPTR]+8]+D30]+50]+50]+(0-100)
this a physical offset
for Vehicles

offset 0xD4 -> LinearSpeedlimit
offset 0xD8-> AgularSpeedlimit
offset 0x70,74,78 -> LinearVelocity x,y,z
offset 0x80,84,88 -> AgularVelocity x,y,z
/*
        *script_global(2462514).at(27).at(74).as<int *>() = 1;
        *script_global(2462514).at(27).at(75).as<int *>() = 1;
        *script_global(2462514).at(27).at(76).as<int *>() = 0;
        *script_global(2462514).at(27).at(77).as<int *>() = 4030726305;
        *script_global(2462514).at(27).at(5).as<int *>() = -1;
        *script_global(2462514).at(27).at(6).as<int *>() = -1;
        *script_global(2462514).at(27).at(7).as<int *>() = -1;
        *script_global(2462514).at(27).at(8).as<int *>() = -1;
        *script_global(2462514).at(27).at(19).as<int *>() = 4;
        *script_global(2462514).at(27).at(60).as<int *>() = 1;
        *script_global(2462514).at(27).at(20).as<int *>() = 1;
        *script_global(2462514).at(27).at(21).as<int *>() = 3;
        *script_global(2462514).at(27).at(22).as<int *>() = 6;
        *script_global(2462514).at(27).at(23).as<int *>() = 9;
        *script_global(2462514).at(27).at(24).as<int *>() = 58;
        *script_global(2462514).at(27).at(25).as<int *>() = 13;
        *script_global(2462514).at(27).at(26).as<int *>() = 18;
        *script_global(2462514).at(27).at(27).as<int *>() = 1;
        */
]]