--[[
  require ("config.setting")
  @Credit : Shirabrixx82,ApacheTech,DarkByte,Corroder,mgr.inz.Player
  Special Thanks to UC in Reversal Thread especially to Kiddion and ScriptKiddy1337
  Compiler : Ellohim a.k.a vladi023
  ]]

function ProcessChecks()
    if not openProcess('GTA5.exe') then
        sleep(250)
        if getOpenedProcessID() == 0 then
            getAutoAttachList().add('GTA5.exe')
            sleep(250)
        else
            closeCE()
        end
    end
end
ProcessChecks()

function ConsoleLog(Message)
    console = getLuaEngine()
    console.GroupBox1.Caption = 'This Is Console Log Output'
    LogOutput = console.mOutput
    console.Color = '0x000000'
    LogOutput.Color = '0x000000'
    LogOutput.Font.Color = '1030655'
    console.show()
    print(Message)
end

function sendMsg(cmd, msg, fpath)
    local output = cmd .. " " .. msg .. " > " .. fpath
    print(output)
    os.execute(output)
end

function getAppsPath()
    FilePath = '';
    if TrainerOrigin ~= nil then
        FilePath = TrainerOrigin
    else
        FilePath = getCheatEngineDir();
    end
    return FilePath
end

function SystemLog(Message)
    local new = function()
        LogMessage = Message
        if getAppsPath() then
            f = io.open(string.format("%s/Log-System.log", FilePath), "a+")
            f:write("[" .. os.date("%x") .. "]" .. " [" .. os.date("%X") .. "] " .. LogMessage .. "\n")
            f:close()
        end
    end
    createNativeThread(new)
end

function LuaEngineLog(Message) -- console.mOutput.Lines.Text
    PlayerInformationLog = Message
    DebugController.ConsoleOutput.append(Message)
    if getAppsPath() then
        LuaLogs = io.open(string.format("%s/Lua-Log.log", FilePath), "a+")
        LuaLogs:write("[" .. os.date("%x") .. "]" .. " [" .. os.date("%X") .. "] " .. PlayerInformationLog .. "\n")
        LuaLogs:close()
    end
end

function Pointer(options)
    local _ptr = {
        Options = options,
        Scan = function()
            -- DEBUG: 
            ConsoleLog(string.format("Register Pointer : %s", options.Name))
            ConsoleLog(string.format("Pattern Scan : %s", options.Pattern))
            ConsoleLog(string.format('Scan Method:%s | Sig Offset:%s | Target Offset:%s', options.ScanMethod,
                           options.SigOffset, options.TargetOffset))
            LuaEngineLog("Signature Scanning:  " .. options.Pattern);
            LuaEngineLog("Registering Pointer: " .. options.Name);
            LuaEngineLog(string.format('Scan Method:%s | Sig Offset:%s | Target Offset:%s', options.ScanMethod,
                             options.SigOffset, options.TargetOffset));

            autoAssemble([[
                aobscanmodule(]] .. options.Name .. [[,]] .. process .. [[,]] .. options.Pattern .. [[)
                registersymbol(]] .. options.Name .. [[)
            ]]);

            if (options.ScanMethod == 1) then
                local _addr = getAddress(options.Name) + options.SigOffset;
                _addr = _addr + readInteger(_addr) + options.TargetOffset;
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            elseif (options.ScanMethod == 2) then
                local _addr = getAddress(options.Name) + options.SigOffset;
                _addr = getAddress(process) + readInteger(_addr);
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            elseif (options.ScanMethod == 3) then
                local _addr = getAddress(options.Name) - options.SigOffset;
                _addr = _addr + readInteger(_addr);
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            elseif (options.ScanMethod == 4) then
                local _addr = getAddress(options.Name) + options.SigOffset;
                _addr = _addr + readInteger(_addr);
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            elseif (options.ScanMethod == 5) then
                local _addr = getAddress(options.Name) - options.SigOffset;
                _addr = _addr + readInteger(_addr) + options.TargetOffset;
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            elseif (options.ScanMethod == 0) then
                unregisterSymbol(options.Name);
                registerSymbol(options.Name, _addr, true);
            end
            LuaEngineLog(string.format("Address: 0x%X", getAddressSafe(options.Name) == nil and 0 or getAddressSafe(options.Name)));
            SystemLog(string.format(
                          "Registered Pointer : %s | Address : 0x%X | Scan Method:%s | Sig Offset:%s | Target Offset:%s",
                          options.Name, getAddressSafe(options.Name) == nil and 0 or getAddressSafe(options.Name), options.ScanMethod, options.SigOffset,
                          options.TargetOffset))
            createNativeThread(autoAssemble)
            return _ptr;
        end,
        
        Release = function()
            -- DEBUG: print("Unregistering "..options.Name.." Symbol");
            unregisterSymbol(options.Name);
            return _ptr;
        end,

        BaseAddress = function()
            return getAddress(options.Name);
        end,

        HeapAddress = function()
            return readPointer(options.Name);
        end,

        Exists = function()
            local _exists, err = pcall(function()
                local a = getAddress(options.Name)
            end);
            return _exists;
        end
    };
    table.insert(Pointers, _ptr);
    return _ptr;
end

Pointers = {};
WorldPTR = Pointer({
    Name = 'WorldPTR',
    Pattern = '48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
WorldPTR.Scan();

GlobalPTR = Pointer({
    Name = 'GlobalPTR',
    Pattern = '4C 8D 05 ? ? ? ? 4D 8B 08 4D 85 C9 74 11',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
GlobalPTR.Scan();

BlipPTR = Pointer({
    Name = 'BlipPTR',
    Pattern = '4C 8D 05 ? ? ? ? 0F B7 C1',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
BlipPTR.Scan();

PlayerCountPTR = Pointer({
    Name = 'PlayerCountPTR',
    Pattern = '48 8B 0D ? ? ? ? E8 ? ? ? ? 48 8B C8 E8 ? ? ? ? 48 8B CF',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
PlayerCountPTR.Scan();
--[[
GetPointerAddressA = Pointer({
    Name = 'GetPointerAddressA',
    Pattern = '4D 89 B4 F7 xx xx xx xx 48 8B 74 24',
    ScanMethod = 2,
    SigOffset = 4,
    TargetOffset = 6
});
GetPointerAddressA.Scan();
]]
LocalScriptsPTR = Pointer({
    Name = 'LocalScriptsPTR',
    Pattern = '48 8B 05 ? ? ? ? 8B CF 48 8B 0C C8 39 59 68',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
LocalScriptsPTR.Scan();

PlayerNamePTR_1 = Pointer({
    Name = 'PlayerNamePTR_1',
    Pattern = '48 8D 0D ? ? ? ? E8 ? ? ? ? 48 8D 0D ? ? ? ? 83',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0x88
});
PlayerNamePTR_1.Scan();

PlayerNamePTR_2 = Pointer({
    Name = 'PlayerNamePTR_2',
    Pattern = '48 8D ? ? ? ? ? 48 8D ? ? ? 8B 04 ? 89 44 ? ? 48 8D ? ? ? ? ? E8 ? ? ? ? 48 83 C4 ? 5B C3 40',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = -0x1BBF4
});
PlayerNamePTR_2.Scan();

PlayerNamePTR_3 = Pointer({
    Name = 'PlayerNamePTR_3',
    Pattern = '48 8D 0D ? ? ? ? E8 ? ? ? ? 48 8D 0D ? ? ? ? 83',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0xB090
});
PlayerNamePTR_3.Scan();

WaypointPTR = Pointer({
    Name = 'WaypointPTR',
    Pattern = '48 8D 0D ? ? ? ? 39 01 74 12 41 FF C7',--'48 8B 0D ? ? ? ? 8B 10 E9 ? ? ? ? E8 ? ? ? ? 90 E9 ? ? ? ? C6 C8',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4--0xD784
});
WaypointPTR.Scan();

PlayerGravityPTR = Pointer({
    Name = 'PlayerGravityPTR',
    Pattern = 'F3 0F ? ? ? ? ? ? F3 0F ? ? ? ? ? ? 8A 05 ? ? ? ? 88 82',
    ScanMethod = 1,
    SigOffset = 4,
    TargetOffset = 4
});
PlayerGravityPTR.Scan();

CleanWaterPTR = Pointer({
    Name = 'CleanWaterPTR',
    Pattern = '48 8B 0D ? ? ? ? 48 03 ? F6 41 18',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0x67304
});
CleanWaterPTR.Scan();

BlackoutPTR = Pointer({
    Name = 'BlackoutPTR',
    Pattern = '48 8B D7 48 8B CB E8 ? ? ? ? 40 38 35 ? ? ? ? 74 40',
    ScanMethod = 1,
    SigOffset = 14,
    TargetOffset = 4
});
BlackoutPTR.Scan();

NightvisionPTR = Pointer({
    Name = 'NightvisionPTR',
    Pattern = '48 8B 0D ? ? ? ? 44 8B ? ? ? ? ? 45 33 ? 48 8B ? 48 8B ? ? E8 ? ? ? ? 48 8B ? ? ? ? ? 33 DB',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = -0x31
});
NightvisionPTR.Scan();
--[[
ThermalVisionPTR = Pointer({
    Name = 'ThermalVisionPTR',
    Pattern = '3B 1D ? ? ? ? 72 ? 83 25 52 95 CB 01',
    ScanMethod = 1,
    SigOffset = 2,
    TargetOffset = -0x12
});
ThermalVisionPTR.Scan();
]]
DeliverCargoPTR = Pointer({
    Name = 'DeliverCargoPTR',
    Pattern = '48 8B 05 ? ? ? ? 48 8D ? ? 48 8D ? ? ? ? ? FF 50 ? 48 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0x27700
});
DeliverCargoPTR.Scan();

MoneyInBunkerPTR = Pointer({
    Name = 'MoneyInBunkerPTR',
    Pattern = '48 8D 05 ? ? ? ? 48 C1 E1 ? 48 03 C8 E8 ? ? ? ? 48 8B 5C',--'48 8B 05 ? ? ? ? 48 8D ? ? 48 8D ? ? ? ? ? FF 50 ? 48 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 52--0xA314
});
MoneyInBunkerPTR.Scan();
--LA(900,'gb_biker_contraband_sell')
MoneyInBunkerPTR_2 = Pointer({
    Name = 'MoneyInBunkerPTR_2',
    Pattern = '48 8B 05 ? ? ? ? 48 8D ? ? 48 8D ? ? ? ? ? FF 50 ? 48 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0xA344
});
MoneyInBunkerPTR_2.Scan();

ZCoordPTR = Pointer({
    Name = 'ZCoordPTR',
    Pattern = '48 8D 0D ? ? ? ? E8 ? ? ? ? 48 8D 15 ? ? ? ? 48 8D 0D ? ? ? ? F3 0F 10 15',--'48 8D 0D ? ? ? ? F3 0F ? ? ? ? ? ? 44 8A ? E8 ? ? ? ? 48 8B',
    ScanMethod = 1,
    SigOffset = 9,
    TargetOffset = 0x5
});
ZCoordPTR.Scan();

GroundCheckPTR = Pointer({
    Name = 'GroundCheckPTR',
    Pattern = '48 8D 0D ? ? ? ? E8 ? ? ? ? 48 8D 15 ? ? ? ? 48 8D 0D ? ? ? ? F3 0F 10 15',--'48 8D 0D ? ? ? ? F3 0F ? ? ? ? ? ? 44 8A ? E8 ? ? ? ? 48 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
GroundCheckPTR.Scan();

PlayerCrewPTR = Pointer({
    Name = 'PlayerCrewPTR',
    Pattern = '48 89 05 ? ? ? ? B0 ? 48 83 C4 ? C3 48 89',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 0x4 + 0x6488--0x6890
});
PlayerCrewPTR.Scan();--PLAYERCREWPTR - 0x3FF + 0x56 + 0xB7 * 0
--[[
    --offsets
    oRID_3 =  0x0008
    oCrewID = 0x0028
    oCrewTag = 0x0057
    oisPrimary =0x00D0
     
    -- 0x00B8 index offset between the 5 crews
     
    function getMyPrimaryCrew() --Call these once and before you change anything
    --GTA5.exe+2BEB3C0 Crews Base Address
    PlayerCrewAdderss = getAddress("GTA5.exe+2BEB3C0")--too noob to find the sig XDD
         for i = 0,4,1 do
               if readBytes(PlayerCrewAdderss + oisPrimary + 0xB8*i) == 1 then
                   CrewTagAdderss = PlayerCrewAdderss + oCrewTag + 0xB8*i
                   myPrimaryCrewTag = readString(CrewTagAdderss) --Save The Original Active Crew Tag
                   return
               end
         end
    end

Code:

    function CrewTagChanger(_Tag)
    local ByteTable = stringToByteTable(_Tag:upper())
       if #ByteTable > 4 then
           print("too many characters")
           return
       elseif #ByteTable == 4 then
           goto continue
       end
       for i = 1,4-(#ByteTable),1 do
           ByteTable[#ByteTable+i] = 0x00
       end
       ::continue::
       writeBytes(CrewTagAdderss,ByteTable)
    end


]]
GameSettingPTR = Pointer({
    Name = 'GameSettingPTR',
    Pattern = '44 39 0D ? ? ? ? 74 0C',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4 -0x99
});
GameSettingPTR.Scan();

WeatherPTR = Pointer({
    Name = 'WeatherPTR',
    Pattern = '48 8B 15 ? ? ? ? 8B 4A ? C1 E1 ? C1 F9 ? 39 4A ? 74 ? 48 8B ? E8 ? ? ? ? 48 85 ? 74 ? 48 8B ? ? ? ? ? 48 8B ? E8 ? ? ? ? EB ? 49 8B ? 48 89 ? ? ? ? ? 48 8B ? ? ? ? ? 45 33 ? 48 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4 -0x1568
});
WeatherPTR.Scan();

CutsceneManagerPTR = Pointer({
    Name = 'CutsceneManagerPTR',
    Pattern = '48 8B 0D ? ? ? ? 48 8B 01 48 FF 60 28',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
CutsceneManagerPTR.Scan();
--[[
Address of signature = GTA5.exe + 0x00E6A6A5
"\x48\x8B\x00\x00\x00\x00\x00\xBA\x00\x00\x00\x00\x41\xB8\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x85\x00\x0F\x84\x00\x00\x00\x00\xF3\x0F\x00\x00\x00\x00\x00\x00\x48\x8D\x00\x00\x45\x33\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\x48\x8B", "xx?????x????xx????x????xx?xx????xx??????xx??xx?xx?x????xx"
"48 8B ? ? ? ? ? BA ? ? ? ? 41 B8 ? ? ? ? E8 ? ? ? ? 48 85 ? 0F 84 ? ? ? ? F3 0F ? ? ? ? ? ? 48 8D ? ? 45 33 ? 48 8B ? E8 ? ? ? ? 48 8B"

Address of signature = GTA5.exe + 0x00DB4368
"\x48\x8B\x00\x00\x00\x00\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\x4C\x8B\x00\x00\x00\x00\x00\xEB", "xx?????xx?x????xx?????x"
"48 8B ? ? ? ? ? 48 8B ? E8 ? ? ? ? 4C 8B ? ? ? ? ? EB"
225 address

Address of signature = GTA5.exe + 0x00DBFD44
"\x48\x8B\x00\x00\x00\x00\x00\x4C\x8D\x00\x00\x00\x00\x00\xEB\x00\x4C\x8B\x00\x48\x8B", "xx?????xx?????x?xx?xx"
"48 8B ? ? ? ? ? 4C 8D ? ? ? ? ? EB ? 4C 8B ? 48 8B"
267

Address of signature = GTA5.exe + 0x00221EB1
"\x48\x8D\x00\x00\x00\x00\x00\xE8\x00\x00\x00\x00\xEB\x00\x48\x8D\x00\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x8B\x05\x00\x00\x00\x00\x48\x8B", "xx?????x????x?xx?????x????xx????xx"
"48 8D ? ? ? ? ? E8 ? ? ? ? EB ? 48 8D ? ? ? ? ? E8 ? ? ? ? 8B 05 ? ? ? ? 48 8B"
221 address

Address of signature = GTA5.exe + 0x0024DD90
"\x4C\x8D\x00\x00\x00\x00\x00\x41\xB8\x00\x00\x00\x00\xE9\x00\x00\x00\x00\x90", "xx?????xx????x????x"
"4C 8D ? ? ? ? ? 41 B8 ? ? ? ? E9 ? ? ? ? 90"
220 address

Address of signature = GTA5.exe + 0x00990F49
"\x48\x8B\x00\x00\x00\x00\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\xF3\x44", "xx?????xx?x????xx"
"48 8B ? ? ? ? ? 48 8B ? E8 ? ? ? ? F3 44" 
addr 260

Address of signature = GTA5.exe + 0x018F160C
"\x48\x8B\x00\x00\x00\x00\x00\x48\x8B\x00\x00\x00\x00\x00\x48\x85\x00\x75\x00\x48\x83\xC4\x00\xC3\x48\x8D\x00\x00\x00\x00\x00\xE9\x00\x00\x00\x00\x48\x8D", "xx?????xx?????xx?x?xxx?xxx?????x????xx"
"48 8B ? ? ? ? ? 48 8B ? ? ? ? ? 48 85 ? 75 ? 48 83 C4 ? C3 48 8D ? ? ? ? ? E9 ? ? ? ? 48 8D"
2C0

Address of signature = GTA5.exe + 0x018F0272
"\x48\x89\x00\x00\x00\x00\x00\x89\x05\x00\x00\x00\x00\x48\x83\xC4\x00\xC3\x48\x8D\x00\x00\x00\x00\x00\xE9", "xx?????xx????xxx?xxx?????x"
"48 89 ? ? ? ? ? 89 05 ? ? ? ? 48 83 C4 ? C3 48 8D ? ? ? ? ? E9"
2BFE

Address of signature = GTA5.exe + 0x018F00AD
"\x48\x8D\x00\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x80\x25\xF3\x9C\x30\x01", "xx?????x????xxxxxx"
"48 8D ? ? ? ? ? E8 ? ? ? ? 80 25 F3 9C 30 01"
2BF9

Address of signature = GTA5.exe + 0x0105024C
"\x48\x8D\x00\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x8D\x00\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x83\x25\xBC\xC8\x8B\x01", "xx?????x????xx?????x????xxxxxxx"
"48 8D ? ? ? ? ? E8 ? ? ? ? 48 8D ? ? ? ? ? E8 ? ? ? ? 48 83 25 BC C8 8B 01"
2948
]]
-- Pointers = { };
-- PlayerNamePTR_2 = Pointer({
-- Name = 'PlayerNamePTR_2',
-- Pattern = '48 8D 05 ? ? ? ? 48 8D 54 24 28 49 8B FE',
-- ScanMethod = 1,
-- SigOffset = 3,
-- TargetOffset = 0x68
-- });
-- PlayerNamePTR_2.Scan();

-- Pointers = { };
-- PlayerNamePTR_2 = Pointer({
-- Name = 'PlayerNamePTR_2',
-- Pattern = '48 8D ? ? ? ? ? 48 8D ? ? ? 48 8D ? ? 41 B8 ? ? ? ? 48 89 ? ? ? 48 89',
-- ScanMethod = 1,
-- SigOffset = 3,
-- TargetOffset = 0x68
-- });
-- PlayerNamePTR_2.Scan();

-- Pointers = { };
-- PlayerNamePTR_3 = Pointer({
-- Name = 'PlayerNamePTR_3',
-- Pattern = '4C 8B 05 ? ? ? ? 4D 85 C0 74 E4',
-- ScanMethod = 1,
-- SigOffset = 3,
-- TargetOffset = 0x68
-- });
-- PlayerNamePTR_3.Scan();

LampPTR = Pointer({
    Name = 'LampPTR',
    Pattern = '8B 0D ? ? ? ? E8 ? ? ? ? 48 8B ? E8 ? ? ? ? B2'
});
LampPTR.Scan();

SubGlobalPTR = Pointer({
    Name = 'SubGlobalPTR',
    Pattern = '48 8D ? ? ? ? ? E8 ? ? ? ? 0F B7 ? ? ? ? ? 33 FF 8B DF',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
SubGlobalPTR.Scan();

UnknownPatternPTR = Pointer({
    Name = 'UnknownPatternPTR',
    Pattern = '48 8B ? ? ? ? ? 48 89 ? 0F B7 ? ? ? ? ? FF 05 ? ? ? ? 48 89 ? ? ? ? ? 3B F8',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
UnknownPatternPTR.Scan();
--[[
GunLockerPTR = Pointer({
    Name = 'GunLockerPTR',
    Pattern = '4C 8D ? ? ? ? ? 48 8D ? ? ? 49 8B ? E9 ? ? ? ? 48 89',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
GunLockerPTR.Scan();

SubWorldPTR = Pointer({
    Name = 'SubWorldPTR',
    Pattern = '48 8B ? ? ? ? ? E9 ? ? ? ? F3 44 ? ? ? ? F3 0F',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
SubWorldPTR.Scan();
]]
ReplayInterfacePTR = Pointer({
    Name = 'ReplayInterfacePTR',
    Pattern = '48 8D 0D ? ? ? ? 48 8B D7 E8 ? ? ? ? 48 8D 0D ? ? ? ? 8A D8 E8 ? ? ? ? 84 DB 75 13 48 8D 0D ? ? ? ?',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
ReplayInterfacePTR.Scan();
--[[
GetEventDataPTR = Pointer({
    Name = 'GetEventDataPTR',
    Pattern = '48 89 5C 24 ? 57 48 83 EC ? 49 8B F8 4C 8D 05',
    ScanMethod = 1,
    SigOffset = 16,
    TargetOffset = 4
});
GetEventDataPTR.Scan();
Get Event Data : 48 85 C0 74 14 4C 8B 10 -> sub 28
48 89 5C 24 ? 57 48 83 EC ? 48 8B F9 48 8B 0D ? ? ? ? 8A DA B2 ? E8 ? ? ? ? 48 8B ? ? ? ? ? E8 ? ? ? ? 4C 8B
Increment Event : 48 89 5C 24 ? 48 89 74 24 ? 55 57 41 55 41 56 41 57 48 8B EC 48 83 EC 60 8B 79 30

Address of signature = GTA5.exe + 0x01188A64
"\x48\x8B\x00\x48\x89\x00\x00\x48\x89\x00\x00\x48\x89\x00\x00\x57\x48\x81\xEC\x00\x00\x00\x00\x48\x8B\x00\x48\x8D\x00\x00\x41\x0F\x00\x00\x49\x8B\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x48\x8B\x00\x00\x00\x00\x00\x48\x8D\x00\x00\x00\x89\x44\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x4C\x8B\x00\x89\x44\x00\x00\x4C\x8B\x00\x66\x89\x00\x00\x00\x48\x89\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x8D\x00\x00\x00\xE8\x00\x00\x00\x00\x4C\x8D\x00\x00\x00\x00\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x5F\xC3\x90\x48\x8B\x00\x48\x89\x00\x00\x48\x89\x00\x00\x48\x89\x00\x00\x57\x48\x81\xEC\x00\x00\x00\x00\x48\x8B\x00\x48\x8D\x00\x00\x41\x0F\x00\x00\x49\x8B\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x48\x8B\x00\x00\x00\x00\x00\x48\x8D\x00\x00\x00\x89\x44\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x4C\x8B\x00\x89\x44\x00\x00\x4C\x8B\x00\x66\x89\x00\x00\x00\x48\x89\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x8D\x00\x00\x00\xE8\x00\x00\x00\x00\x4C\x8D\x00\x00\x00\x00\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x00\x49\x8B\x00\x5F\xC3\xCC\x48\x89\x00\x00\x00\x48\x89\x00\x00\x00\x48\x89\x00\x00\x00\x57\x48\x81\xEC\x00\x00\x00\x00\x48\x8B\x00\x48\x8D\x00\x00\x00\x41\x0F\x00\x00\x49\x8B\x00\x48\x8B\x00\xE8\x00\x00\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x48\x8B\x00\x00\x00\x00\x00\x48\x8D\x00\x00\x00\x89\x44\x00\x00\x8B\x84\x00\x00\x00\x00\x00\x4C\x8B\x00\x89\x44\x00\x00\x4C\x8B\x00\x66\x89\x00\x00\x00\x48\x89\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x8D\x00\x00\x00\xE8", "xx?xx??xx??xx??xxxx????xx?xx??xx??xx?xx?x????xx?????xx?????xx???xx??xx?????xx?xx??xx?xx???xx???x????xx???x????xx??????xx??xx??xx??xx?xxxxx?xx??xx??xx??xxxx????xx?xx??xx??xx?xx?x????xx?????xx?????xx???xx??xx?????xx?xx??xx?xx???xx???x????xx???x????xx??????xx??xx??xx??xx?xxxxx???xx???xx???xxxx????xx?xx???xx??xx?xx?x????xx?????xx?????xx???xx??xx?????xx?xx??xx?xx???xx???x????xx???x"
"48 8B ? 48 89 ? ? 48 89 ? ? 48 89 ? ? 57 48 81 EC ? ? ? ? 48 8B ? 48 8D ? ? 41 0F ? ? 49 8B ? 48 8B ? E8 ? ? ? ? 8B 84 ? ? ? ? ? 48 8B ? ? ? ? ? 48 8D ? ? ? 89 44 ? ? 8B 84 ? ? ? ? ? 4C 8B ? 89 44 ? ? 4C 8B ? 66 89 ? ? ? 48 89 ? ? ? E8 ? ? ? ? 48 8D ? ? ? E8 ? ? ? ? 4C 8D ? ? ? ? ? ? 49 8B ? ? 49 8B ? ? 49 8B ? ? 49 8B ? 5F C3 90 48 8B ? 48 89 ? ? 48 89 ? ? 48 89 ? ? 57 48 81 EC ? ? ? ? 48 8B ? 48 8D ? ? 41 0F ? ? 49 8B ? 48 8B ? E8 ? ? ? ? 8B 84 ? ? ? ? ? 48 8B ? ? ? ? ? 48 8D ? ? ? 89 44 ? ? 8B 84 ? ? ? ? ? 4C 8B ? 89 44 ? ? 4C 8B ? 66 89 ? ? ? 48 89 ? ? ? E8 ? ? ? ? 48 8D ? ? ? E8 ? ? ? ? 4C 8D ? ? ? ? ? ? 49 8B ? ? 49 8B ? ? 49 8B ? ? 49 8B ? 5F C3 CC 48 89 ? ? ? 48 89 ? ? ? 48 89 ? ? ? 57 48 81 EC ? ? ? ? 48 8B ? 48 8D ? ? ? 41 0F ? ? 49 8B ? 48 8B ? E8 ? ? ? ? 8B 84 ? ? ? ? ? 48 8B ? ? ? ? ? 48 8D ? ? ? 89 44 ? ? 8B 84 ? ? ? ? ? 4C 8B ? 89 44 ? ? 4C 8B ? 66 89 ? ? ? 48 89 ? ? ? E8 ? ? ? ? 48 8D ? ? ? E8"
]]
--[[
SendNetToLobby = Pointer({
    Name = 'SendNetToLobby',
    Pattern = '44 8D 47 70 48 8D 54 24 ? 48 8B CB E8',
    ScanMethod = 1,
    SigOffset = -0xC4,
});--44 8D 47 70 48 8D 54 24 ? 48 8B CB E8
SendNetToLobby.Scan();
]]
Clock = Pointer({
    Name = 'ClockPTR',
    Pattern = 'E9 ? ? ? ? 48 83 EC ? E8 ? ? ? ? 48 83 C4 ? E9',
    ScanMethod = 1,
    SigOffset = 10,
    TargetOffset = 4
})

ScriptEventPTR = Pointer({
    Name = 'ScriptEventPTR',
    Pattern = '48 83 EC 28 E8 ? ? ? ? 48 8B 0D ? ? ? ? 4C 8D 0D ? ? ? ? 4C 8D 05 ? ? ? ? BA 03'
});
ScriptEventPTR.Scan();

RIDJoinerPTR = Pointer({
    Name = 'RIDJoinerPTR',
    Pattern = '48 8D BE ? ? ? ? 48 8B CF 0F 10 ? 41 8B C4'
});
RIDJoinerPTR.Scan();

IS_DLC_PRESENT = Pointer({
    Name = 'IS_DLC_PRESENT',
    Pattern = '48 89 5C 24 08 57 48 83 EC 20 81 F9'
});
IS_DLC_PRESENT.Scan();

-- Pointers = { };
-- ModelHashPTR = Pointer({
-- Name = 'ModelHashPTR',
-- Pattern = '4C 8B 15 ? ? ? ? 49 8B 04 D2 44 39 40 08',
-- ScanMethod = 1,
-- SigOffset = 3,
-- TargetOffset = 4
-- });
-- ModelHashPTR.Scan();

VehPTR = Pointer({
    Name = 'VehPTR',
    Pattern = '48 39 3D ? ? ? ? 75 2D',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
VehPTR.Scan();

PickupDataPTR = Pointer({
    Name = 'PickupDataPTR',
    Pattern = '48 8B 05 ? ? ? ? 48 8B 1C F8 8B',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
PickupDataPTR.Scan();

GamestatePTR = Pointer({
    Name = 'GamestatePTR',
    Pattern = '48 85 C9 74 4B 83 3D',--'83 3D ? ? ? ? ? 75 17 8B 42 20 25',
    ScanMethod = 1,
    SigOffset = 7,--2,
    TargetOffset = 4--4
});
GamestatePTR.Scan();

NativeHandlersPTR = Pointer({
    Name = 'NativeHandlersPTR',
    Pattern = '48 8D 0D ? ? ? ? 48 8B 14 FA E8 ? ? ? ? 48 85 C0 75 0A',
    ScanMethod = 1,
    SigOffset = 12,
    TargetOffset = 4
});
NativeHandlersPTR.Scan();

NativeRegistrationPTR = Pointer({
    Name = 'NativeRegistrationPTR',
    Pattern = '48 8D 0D ? ? ? ? 48 8B 14 FA E8 ? ? ? ? 48 85 C0 75 0A',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
NativeRegistrationPTR.Scan();

IsSessionStartedPTR = Pointer({
    Name = 'IsSessionStartedPTR',
    Pattern = '40 38 35 ? ? ? ? 75 0E 4C 8B C3 49 8B D7 49 8B CE',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
IsSessionStartedPTR.Scan();

ScriptProgramsPTR = Pointer({
    Name = 'ScriptProgramsPTR',
    Pattern = '44 8B 0D ? ? ? ? 4C 8B 1D ? ? ? ? 48 8B 1D ? ? ? ? 41 83 F8 FF 74 3F 49 63 C0 42 0F B6 0C 18 81 E1',
    ScanMethod = 1,
    SigOffset = 17,
    TargetOffset = 4
});
ScriptProgramsPTR.Scan();

ScriptThreadPTR = Pointer({
    Name = 'ScriptThreadPTR',
    Pattern = '45 33 F6 8B E9 85 C9 B8',
    ScanMethod = 5,
    SigOffset = 4,
    TargetOffset = 4 - 8
});
ScriptThreadPTR.Scan();

RunScriptThreadPTR = Pointer({
    Name = 'RunScriptThreadPTR',
    Pattern = '45 33 F6 8B E9 85 C9 B8',
    ScanMethod = 3,
    SigOffset = 0x1F
});
RunScriptThreadPTR.Scan();

Pointers = {};
FriendPTR = Pointer({
    Name = 'FriendPTR',
    Pattern = '48 03 0D ? ? ? ? E9 ? ? ? ? 48 8D 05',
    ScanMethod = 1,
    SigOffset = 3,
    TargetOffset = 4
});
FriendPTR.Scan();

Pointers = {};
TotalFriendPTR = Pointer({
    Name = 'TotalFriendPTR',
    Pattern = '3B 0D ? ? ? ? 73 13 48 63 C9',
    ScanMethod = 1,
    SigOffset = 2,
    TargetOffset = 4
});
TotalFriendPTR.Scan();

-- LabelTextPTR = Pointer({
--     Name = 'LabelTextPTR',
--     Pattern = '48 8D 0D ? ? ? ? 44 8B F2',
--     ScanMethod = 1,
--     SigOffset = 2,
--     TargetOffset = 4
-- });
-- LabelTextPTR.Scan();
-- Pointers = { };
-- LabelTextAddress = Pointer({
-- Name = 'LabelTextAddress',
-- Pattern = '59 6F 75 20 68 61 76 65 20 62 65 65 6E 20 61 77 61 72 64 65 64 20 74 68 65 20 66 6F 6C 6C 6F 77 69 6E 67 20 6C 69 76 65 72 69 65 73 20 66 6F 72 20 74 68 65 20 7E 61 7E 3A',

-- });
-- LabelTextAddress.Scan();

-- autoAssemble([[
-- aobScan(LabelTextAddress,59 6F 75 20 68 61 76 65 20 62 65 65 6E 20 61 77 61 72 64 65 64 20 74 68 65 20 66 6F 6C 6C 6F 77 69 6E 67 20 6C 69 76 65 72 69 65 73 20 66 6F 72 20 74 68 65 20 7E 61 7E 3A)
-- registerSymbol(LabelTextAddress)
-- ]])

Global_ = function(index, ...)
    local GlobalScript = get.Memory("GlobalPTR");
    if not GlobalScript then
        return
    end
    local StringIndex = type(index)
    if StringIndex == "string" then
        StringIndex = index
        local SecondIndex = StringIndex:match("f_([^,]+).f_")
        local NextIndexFirst = StringIndex:match("f_([^,]+)")
        local NextIndexSecond = NextIndexFirst:match(".f_([^,]+)")
        local FirstIndex
        if not SecondIndex then
            FirstIndex = StringIndex:match("Global_([^,]+).f_")
            ConcatIndex = tonumber(FirstIndex) + tonumber(NextIndexFirst)
            index = ConcatIndex
        elseif SecondIndex then
            FirstIndex = StringIndex:match("Global_([^,]+).f_([^,]+).f_")
            ConcatIndex = tonumber(FirstIndex) + tonumber(SecondIndex) + tonumber(NextIndexSecond)
            index = ConcatIndex
        end
    end
    for i = 1, select('#', ...) do
        index = index + select(i, ...);
    end
    local Handler = get.Long
    local ScriptHandle = get.Ptr(GlobalScript + (8 * (index >> 0x12 & 0x3F))) + (8 * (index & 0x3FFFF));
    return ScriptHandle, Handler(ScriptHandle);
end 

function GA(Index)
    local p = getAddress('GlobalPTR')
    if not p then
        return
    end
    return readQword(p + (8 * (Index >> 0x12 & 0x3F))) + (8 * (Index & 0x3FFFF));
end

script_handler = function (Index, ...)
    return Global_(Index, ...)
end

LA = function(Index, ScriptName)
    return readQword(getAddress(ScriptName .. "_ptr")) + (8 * Index)
end

function PLAYER_ID()
    return readInteger(GA(2441237))
end

function SetWindowName(Name)
    getMainForm().Caption = tostring(Name)
    getApplication().Title = tostring(Name)
end

function AsyncBegin(func)
    return coroutine.create(func)
end

function AsyncEnd(thread, interval)
    local timer = createTimer();
    timer.Interval = interval;
    timer.OnTimer = function(t)
        local status = coroutine.status(thread);
        if (thread ~= nil and status ~= 'dead') then
            coroutine.resume(thread);
        else
            t.destroy();
        end
    end
end

function Wait()
    return coroutine.yield()
end

function GG(Type, Index) -- // Get Global
    local case = {}

    case["i"] = function() -- case 1 :
        return readInteger(GA(Index)) -- code block
    end -- break statement

    case["f"] = function() -- case 'add' :
        return readFloat(GA(Index)) -- code block
    end -- break statement

    case["s"] = function() -- case '+' :
        return readString(GA(Index)) -- code block
    end -- break statement

    case["b"] = function() -- case '+' :
        return readBytes(GA(Index)) -- code block
    end -- break statement

    case["int64"] = function() -- case '+' :
        return readQword(GA(Index)) -- code block
    end -- break statement

    case["d"] = function() -- case '+' :
        return readDouble(GA(Index)) -- code block
    end -- break statement

    case["w"] = function() -- case '+' :
        return readSmallInteger(GA(Index)) -- code block
    end -- break statement

    case["default"] = function() -- default case
        return ShowMessage("NULL")
    end -- u cant exclude end hear :-P
    -- execution section
    if case[Type] then
        return case[Type]()
    else
        case["default"]()
    end
end

function SG(Type, Index, Value)
    switch(Type, {
        ["i"] = function() -- case 1 :
            return writeInteger(GA(Index), Value) -- code block
        end,
        ["f"] = function() -- case 'add' :
            return writeFloat(GA(Index), Value) -- code block
        end,
        ["s"] = function() -- case '+' :
            return writeString(GA(Index), Value) -- code block
        end,
        ["b"] = function() -- case '+' :
            return writeBytes(GA(Index), Value) -- code block
        end,
        ["int64"] = function() -- case '+' :
            return writeQword(GA(Index), Value) -- code block
        end,
        ["d"] = function() -- case '+' :
            return writeDouble(GA(Index), Value) -- code block
        end,
        ["w"] = function() -- case '+' :
            return writeSmallInteger(GA(Index), Value) -- code block
        end,
        ["default"] = function() -- default case
            return ShowMessage("NULL")
        end
    })
end

SET = function(Type, Address, Value)
    local case = {}

    case["i"] = function() -- case 1 :
        return writeInteger(Address, Value) -- code block
    end -- break statement

    case["f"] = function() -- case 'add' :
        return writeFloat(Address, Value) -- code block
    end -- break statement

    case["s"] = function() -- case '+' :
        return writeString(Address, Value) -- code block
    end -- break statement

    case["b"] = function() -- case '+' :
        return writeBytes(Address, Value) -- code block
    end -- break statement

    case["int64"] = function() -- case '+' :
        return writeQword(Address, Value) -- code block
    end -- break statement

    case["d"] = function() -- case '+' :
        return writeDouble(Address, Value) -- code block
    end -- break statement

    case["w"] = function() -- case '+' :
        return writeSmallInteger(Address, Value) -- code block
    end
    -- break statement
    case["p"] = function() -- case '+' :
        return writePointer(Address, Value) -- code block
    end -- break statement

    case["default"] = function() -- default case
        return ShowMessage("NULL")
    end -- u cant exclude end hear :-P
    -- execution section
    if case[Type] then
        case[Type]()
    else
        case["default"]()
    end
end

function set_global(Index, Type, Value) -- // Set Global
    if Type == int32 then
        return writeInteger(GA(Index), Value)
    elseif Type == float then
        return writeFloat(GA(Index), Value)
    elseif Type == str then
        return writeString(GA(Index), Value)
    elseif Type == bool then
        return writeBytes(GA(Index), Value)
    elseif Type == int64 then
        return writeQword(GA(Index), Value)
    elseif Type == double then
        return writeDouble(GA(Index), Value)
    elseif Type == int16 then
        return writeSmallInteger(GA(Index), Value)
    else
        return NULL
    end
end

Get = function(Type, Address)
    if Type == "i" then
        return readInteger(Address)
    elseif Type == "f" then
        return readFloat(Address)
    elseif Type == "s" then
        return readString(Address)
    elseif Type == "b" then
        return readBytes(Address)
    elseif Type == "int64" then
        return readQword(Address)
    elseif Type == "d" then
        return readDouble(Address)
    elseif Type == "ptr" then
        return readPointer(Address)
    elseif Type == "w" then
        return readSmallInteger(Address)
    elseif Type == "p" then
        return readPointer(Address)
    elseif Type == "a" then
        return getAddress(Address)
    else
        return "NULL"
    end
end

function const(Variable, value)
    local key = tostring(Variable)
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
            if protected[key] then
                error("attempting to overwrite constant " .. tostring(key) .. " to " .. tostring(value), 2)
            end
            rawset(tbl, key, value)
        end
    }
    setmetatable(_G, meta)
end



------------------------DATA WRITING CHANGER-----------------------------
SET_FLOAT = function(Address, Value)
    writeFloat(Address, Value)
end
SET_BOOL = function(Address, Value)
    writeBytes(Address, Value)
end
SET_BYTE = function(Address, Value)
    writeBytes(Address, Value)
end
SET_INT = function(Address, Value)
    writeInteger(Address, Value)
end
SET_INT64 = function(Address, Value)
    writeQword(Address, Value)
end
SET_STR = function(Address, Value)
    writeString(Address, Value)
end
set_float = function(Address, Value)
    writeFloat(Address, Value)
end
set_bool = function(Address, Value)
    writeBytes(Address, Value)
end
set_byte = function(Address, Value)
    writeBytes(Address, Value)
end
set_int = function(Address, Value)
    writeInteger(Address, Value)
end
set_int64 = function(Address, Value)
    writeQword(Address, Value)
end
set_str = function(Address, Value)
    writeString(Address, Value)
end
-- function int(address, value)
--     return writeInteger(address, value)
-- end
-- function float(address, value)
--     return readFloat(address, value)
-- end
-- function bool(address, value)
--     return writeBytes(address, value)
-- end
-- function str(address, value)
--     return writeString(address, value)
-- end

sptr = writePointer
activate = 1
deactivate = 0
-------------------------GET_VALUE-------------------------------------------------------------
function get_float(Address)
    return readFloat(Address)
end
function get_bool(Address)
    return readBytes(Address)
end
function get_byte(Address)
    return readBytes(Address)
end
function get_int(Address)
    return readInteger(Address)
end
function get_int64(Address)
    return readQword(Address)
end
function get_str(Address)
    return readString(Address)
end
function GET_FLOAT(Address)
    return readFloat(Address)
end
function GET_BOOL(Address)
    return readBytes(Address)
end
function GET_BYTE(Address)
    return readBytes(Address)
end
function GET_INT(Address)
    return readInteger(Address)
end
function GET_INT64(Address)
    return readQword(Address)
end
function GET_STR(Address)
    return readString(Address)
end
POINTERS = function(address)
    return readPointer(address)
end
function ExecuteThread(func)
    createNativeThread(func)
end

function EXCEPT_CLAUSE(what)
    return what[1]
end

function TRY_CLAUSE(what)
    status, result = pcall(what[1])
    if not status then
        what[2](result)
    end
    return result
end

_G.switch = function(param, case_table)
    local case = case_table[param]
    if case then
        return case()
    end
    local def = case_table['default']
    return def and def() or nil
end

function PlayerLog(Message)
    PlayerInformationLog = Message
    if getAppsPath() then
        f = io.open(string.format("%s/Log-Player.log", FilePath), "a+")
        f:write("[" .. os.date("%x") .. "]" .. " [" .. os.date("%X") .. "] " .. PlayerInformationLog .. "\n")
        f:close()
    end
end

function Hexadecimal(num)
    if num == 0 then
        return '0'
    end
    local neg = false
    if num < 0 then
        neg = true
        num = num * -1
    end
    local hexstr = "0123456789ABCDEF"
    local result = ""
    while num > 0 do
        local n = math.mod(num, 16)
        result = string.sub(hexstr, n + 1, n + 1) .. result
        num = math.floor(num / 16)
    end
    if neg then
        result = '-' .. result
    end
    return result
end

function MemoryCopy(MemoryAllocation, Memory)
    local Types = type(Memory)
    local MemoryAllocation
    if Types == 'table' then
        MemoryAllocation = {}
        for k, v in next, Memory, nil do
            MemoryAllocation[MemoryCopy(k)] = MemoryCopy(v)
        end
        setmetatable(MemoryAllocation, MemoryCopy(getmetatable(Memory)))
    else -- number, string, boolean, etc
        MemoryAllocation = Memory
    end
    return MemoryAllocation
end

function isBitSet(value,  bitnumber)
print(bAnd(value,  bShl(1,bitnumber)))
  return bAnd(value,  bShl(1,bitnumber)) ~= 0
end

function wait(seconds, start)
    local t = (start or os.clock()) + seconds/1000
    coroutine.yield(function()
        return os.clock() >= t
    end)
end

yield_delay = 100

get_current = {
    tick = yield_delay;
    yield = function ()
        Wait()
    end;
}

QUEUE_JOB_BEGIN_CLAUSE = function(functions)
    return AsyncBegin(functions)
end

QUEUE_JOB_END_CLAUSE = function(functions)
    AsyncEnd(functions, yield_delay)
end

__stdcall = executeCode
__stdcallLocal = executeCodeLocal
call = executeCodeEx





function CleanNils(t)
    local ans = {}
    for _, v in pairs(t) do
        ans[#ans + 1] = v
    end
    return ans
end

function show(t)
    for _, v in ipairs(t) do
        print(v)
    end
    print(('='):rep(20))
end

function GDMClean(t)
    Tbl_GDM = {}
    for k, v in ipairs(t) do
        if (get.Byte(v) ~= nil) then
            table.insert(Tbl_GDM, v)
        end
    end
    return Tbl_GDM
end

function cleaner(t)
    cleanTable = {}
    for k, v in ipairs(t) do
        if (get.String(v[1]) ~= nil) and (get.Long(v[2]) ~= nil) then
            table.insert(cleanTable, {v[1], v[2]})
        end
    end
    return cleanTable
end

function CleanFloat(t)
    cleanedfloat = {}
    for k, v in ipairs(t) do
        if (get.Float(v[1]) ~= nil) and (get.Float(v[2]) ~= nil) and (get.Float(v[3]) ~= nil) then
            table.insert(cleanedfloat, {v[1], v[2], v[3]})
        end
    end
    return cleanedfloat
end

createTimer_old = createTimer_old or createTimer

timer_hook_mt = {
    __index = function(self, k)
        return self.rawtimer[k];
    end,
    __newindex = function(self, k, v)
        if string.lower(k) == 'ontimer' then
            self.rawtimer.OnTimer = function(...)
                local success, msg = pcall(v, ...);
                if not success then
                    self.rawtimer.Enabled = false;
                    -- error(msg);
                end
            end
        else
            self.rawtimer[k] = v;
        end
    end
};

createTimer = function(...)
    return setmetatable({
        rawtimer = createTimer_old(...)
    }, timer_hook_mt);
end

--[[try {
   function()
      error('oops')
   end,

   catch {
      function(error)
         print('caught error: ' .. error)
      end
   }
}]]
--[[executeCode(address, parameter OPTIONAL, timeout OPTIONAL) : address - Executes a stdcall function with 1 parameter at the given address in the target process  and wait for it to return. The return value is the result of the function that was called
executeCodeLocal(addres, parameter OPTIONAL): address -  Executes a stdcall function with 1 parameter at the given address in the target process. The return value is the result of the function that was called

executeCodeEx(callmethod, timeout, address, {type=x,value=param1} or param1,{type=x,value=param2} or param2,...)
callmethod: 0=stdcall, 1=cdecl
  timeout: Number of milliseconds to wait for a result. nil or -1, infitely. 0 is no wait (will not free the call memory, so beware of it's memory leak)
  address: Address to execute
  {type,value} : Table containing the value type, and the value
    {
    type: 0=integer (32/64bit) can also be a pointer
          1=float (32-bit float)
          2=double (64-bit float)
          3=ascii string (will get converted to a pointer to that string)
          4=wide string (will get converted to a pointer to that string)
     
    value: anything base type that lua can interpret
    }
  if just param is provided CE will guess the type based on the provided type

executeMethod(callmethod, timeout, address, {regnr=0..15,classinstance=xxxxxxxx} or classinstance, {type=x,value=param1} or param1, {type=x,value=param2} or param2,...) - Executes a method.
  regnr can be:
    0: R/EAX
    1: R/ECX
    2: R/EDX
    3: R/EBX
    4: R/ESP
    5: R/EBP
    6: R/ESI
    7: R/EDI
    8: R8
    9: R9
    10: R10
    11: R11
    12: R12
    13: R13
    14: R14
    15: R15
  ]]