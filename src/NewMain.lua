--[[
  require ("config.setting")
  @Credit : Shirabrixx82,ApacheTech,DarkByte,Corroder,mgr.inz.Player
  Special Thanks to UC in Reversal Thread especially to Kiddion and ScriptKiddy1337
  Compiler : Ellohim a.k.a vladi023
  ]]
  require("joaat")
  require ("EXP_TABLE")
  require ("LocalScript")
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
  
  GetPointerAddressA = Pointer({
      Name = 'GetPointerAddressA',
      Pattern = '4D 89 B4 F7 xx xx xx xx 48 8B 74 24',
      ScanMethod = 2,
      SigOffset = 4,
      TargetOffset = 6
  });
  GetPointerAddressA.Scan();
  
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
  
  ReplayInterfacePTR = Pointer({
      Name = 'ReplayInterfacePTR',
      Pattern = '48 8D 0D ? ? ? ? 48 8B D7 E8 ? ? ? ? 48 8D 0D ? ? ? ? 8A D8 E8 ? ? ? ? 84 DB 75 13 48 8D 0D ? ? ? ?',
      ScanMethod = 1,
      SigOffset = 3,
      TargetOffset = 4
  });
  ReplayInterfacePTR.Scan();
  
  --[[GetEventDataPTR = Pointer({
      Name = 'GetEventDataPTR',
      Pattern = '48 89 5C 24 ? 57 48 83 EC ? 49 8B F8 4C 8D 05',
      ScanMethod = 1,
      SigOffset = 16,
      TargetOffset = 4
  });
  GetEventDataPTR.Scan();]]
  
  SendNetToLobby = Pointer({
      Name = 'SendNetToLobby',
      Pattern = '44 8D 47 70 48 8D 54 24 ? 48 8B CB E8',
      ScanMethod = 1,
      SigOffset = 0xD,
      TargetOffset = 4
  });
  SendNetToLobby.Scan();
  
  ScriptEventPTR = Pointer({
      Name = 'ScriptEventPTR',
      Pattern = '48 83 EC 28 E8 ? ? ? ? 48 8B 0D ? ? ? ? 4C 8D 0D ? ? ? ? 4C 8D 05 ? ? ? ? BA 03'
  });
  ScriptEventPTR.Scan();
  
  RIDJoinerPTR = Pointer({
      Name = 'RIDJoinerPTR',
      Pattern = '48 8D BE ? ? ? ? 48 8B CF 0F 10 00 41 8B C4'
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
      Pattern = '83 3D ? ? ? ? ? 75 17 8B 42 20 25',
      ScanMethod = 1,
      SigOffset = 2,
      TargetOffset = 4
  });
  GamestatePTR.Scan();
  
  NativeHandlersPTR = Pointer({
      Name = 'NativeHandlersPTR',
      Pattern = '83 3D ? ? ? ? ? 75 17 8B 42 20 25',
      ScanMethod = 1,
      SigOffset = 12,
      TargetOffset = 4
  });
  NativeHandlersPTR.Scan();
  
  NativeRegistrationPTR = Pointer({
      Name = 'NativeRegistrationPTR',
      Pattern = '83 3D ? ? ? ? ? 75 17 8B 42 20 25',
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
  
  -- Pointers = { };
  -- LabelTextAddress = Pointer({
  -- Name = 'LabelTextAddress',
  -- Pattern = '59 6F 75 20 68 61 76 65 20 62 65 65 6E 20 61 77 61 72 64 65 64 20 74 68 65 20 66 6F 6C 6C 6F 77 69 6E 67 20 6C 69 76 65 72 69 65 73 20 66 6F 72 20 74 68 65 20 7E 61 7E 3A',
  
  -- });
  -- LabelTextAddress.Scan();
  
  autoAssemble([[
  aobScan(LabelTextAddress,59 6F 75 20 68 61 76 65 20 62 65 65 6E 20 61 77 61 72 64 65 64 20 74 68 65 20 66 6F 6C 6C 6F 77 69 6E 67 20 6C 69 76 65 72 69 65 73 20 66 6F 72 20 74 68 65 20 7E 61 7E 3A)
  registerSymbol(LabelTextAddress)
  ]])
  
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
      return readInteger(GA(2440277))
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
  
  function await()
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
  
  ---------------------------------------------Pointer--------------------------------------
  function SecondaryLoot(Location) -- (1 << 24) - 1
      local x = (1 << Location) - 1
      return x
  end
  
  function ptr_string() -- Pointer or Address To String
      gptr = readPointer
      gadr = getAddress
      T_GET = getAddressList()
      L_GET = getAddressList
      getLuaEngine().cbShowOnPrint.Checked = false
      getLuaEngine().hide()
  
      ------------------------ClassOffsets--------------------------------------------------------------
      vtByte = 0
      vtWord = 1
      vtDword = 2
      vtQword = 3
      vtSingle = 4
      vtDouble = 5
      vtString = 6
      vtUnicodeString = 7 -- Only used by autoguess
      vtByteArray = 8
      vtBinary = 9
      vtAutoAssembler = 11
      vtPointer = 12 -- Only used by autoguess and structures
      vtCustom = 13
      vtGrouped = 14
      MAX_INT8 = 127 or "127"
      MIN_INT8 = -127 or "-127"
  
      MAX_SHORT = 32767 or "32767"
      MIN_SHORT = -32767 or "-32767"
  
      MAX_INT = 2147483647 or "2147483647"
      MIN_INT = -2147483647 or "-2147483647"
  
      MIN_LONG = -9223372036854775807 or "-9223372036854775807"
      MAX_LONG = 9223372036854775807 or "9223372036854775807"
  
      MAX_UINT8 = 0xff
      MAX_USHORT = 0xffff
      MAX_UINT = 0xffffffff or "4294967295"
      MAX_ULONG = 0xffffffffffffffff or "18446744073709551615"
  
      _G.TRUE = 1
      _G.FALSE = 0
  
      LOOT_LOC_A = SecondaryLoot(1)
      LOOT_LOC_B = SecondaryLoot(2)
      LOOT_LOC_C = SecondaryLoot(3)
      LOOT_LOC_D = SecondaryLoot(4)
      LOOT_LOC_E = SecondaryLoot(5)
      LOOT_LOC_F = SecondaryLoot(6)
      LOOT_LOC_G = SecondaryLoot(7)
      LOOT_LOC_H = SecondaryLoot(8)
      LOOT_LOC_I = SecondaryLoot(9)
      LOOT_LOC_J = SecondaryLoot(10)
      LOOT_LOC_K = SecondaryLoot(11)
      LOOT_LOC_L = SecondaryLoot(12)
      LOOT_LOC_M = SecondaryLoot(13)
      LOOT_LOC_N = SecondaryLoot(14)
      LOOT_LOC_O = SecondaryLoot(15)
      LOOT_LOC_P = SecondaryLoot(16)
      LOOT_LOC_Q = SecondaryLoot(17)
      LOOT_LOC_R = SecondaryLoot(18)
      LOOT_LOC_S = SecondaryLoot(19)
      LOOT_LOC_T = SecondaryLoot(20)
      LOOT_LOC_U = SecondaryLoot(21)
      LOOT_LOC_V = SecondaryLoot(22)
      LOOT_LOC_W = SecondaryLoot(23)
      LOOT_LOC_X = SecondaryLoot(24)
  
      FLYING_HANDLING = 0x158
  
      sfh = {
          Thrust = 0x8,
          ThrustFallOff = 0xC,
          ThrustVectoring = 0x10,
          YawMult = 0x1C,
          YawStabilise = 0x20,
          RollMult = 0x2C,
          RllStabilise = 0x30,
          PitchMult = 0x38,
          PitchStabilise = 0x3C,
          SideSlipMult = 0x24,
          FrmLiftMult = 0x44,
          AttackLiftMult = 0x48,
          AttackDiveMult = 0x4C,
          GearDwnDragV = 0x50,
          GearDwnLiftMult = 0x54,
          WindMult = 0x58,
          MveRes = 0x5C,
          TurnResX = 0x60,
          TurnResY = 0x64,
          TurnResZ = 0x68,
          SpeedResX = 0x70,
          SpeedResY = 0x74,
          SpeedResZ = 0x78,
          GearDrFrntpen = 0x80,
          GearDrRearpen = 0x84,
          GearDrRearpen2 = 0x88,
          GearDrRearMpen = 0x8C,
          TurublenceMagnitudeMax = 0x90,
          TurublenceFrceMulti = 0x94,
          TurublenceRllTrqueMulti = 0x98,
          TurublencePitchTrqueMulti = 0x9C,
          BdyDamageCntrlEffectMult = 0xA0,
          InputSensitivityFrDifficulty = 0xA4,
          nGrundYawBstSpeedCap = 0xAC,
          nGrundYawBstSpeedPeak = 0xA8,
          EngineffGlideMulti = 0xB0
      }
  
      CPED = 0x8
      POS = 0x30
      GOD = 0x189
      HP = 0X280
      ARMOR = 0X14E0
      RAGDOLL = 0X10B8
      CORDX = 0x50
      CORDY = 0x54
      CORDZ = 0x58
      HEADX = 0X20
      HEADY = 0x24
      IN_VEH = 0X148C
      IN_VEH2 = 0XE52
      IN_VEH3 = 0x1477
  
      MAX_HP = 0X2A0
  
      VEH = 0XD30
      VECX = 0X90
      VECY = 0X94
      VECZ = 0X98
      SEATBELT = 0X140C
      VEH_HP1 = 0X908
      VEH_HP2 = 0X840
      VEH_HP3 = 0X844
      HANDLING = 0X938
      COL = 0XF0
      WEP_COL = 0XF4
      VEH_COL = 0XF8
      ENGINE_COL = 0XFC
      VEH_BODY = 0x824
      VEH_ENGINE = 0x8E8
      VEH_DIRT = 0x9D8
  
      PLAYER_INFO = 0X10C8
      WANTED_LEVEL = 0X888
      STAM = 0XCF4
      STAM_MAX = 0XCF8
      RUN_SPD = 0XCF0
      SWIM_SPD = 0X170
      SNEAK_SPD = 0X18C
      HP_DMG = 0XD10
      ARMOR_DMG = 0XD14
  
      TUNING = 0x48
      COLOR = 0X20
      -------------------------------VEHICLE MOD----------------------------------------------
      ---PRIMARY COLOUR---
      VEH_P_COLOUR_R = 0xA6
      VEH_P_COLOUR_B = 0xA4
      VEH_P_COLOUR_G = 0xA5
      P_COLOUR_TYPE = 0x3F6
      ---SECONDARY COLOUR---
      VEH_S_COLOUR_R = 0xAA
      VEH_S_COLOUR_G = 0xA9
      VEH_S_COLOUR_B = 0xA8
      S_COLOUR_TYPE = 0x3F7
      ----NEON COLOUR--------
      NEON_R = 0x3A2
      NEON_G = 0x3A1
      NEON_B = 0x3A0
      NEON_L = 0x402
      NEON_R = 0x403
      NEON_B = 0x404
      NEON_F = 0x405
      -----TIRES COLOR--------
      TIRES_R = 0x3FC
      TIRES_G = 0x3FD
      TIRES_B = 0x3FE
      -----PEARL COLOUR--------
      PE_COLOUR_TYPE = 0x3F8
      PE_COLOUR_R = 0xC2
      PE_COLOUR_G = 0xC1
      PE_COLOUR_B = 0xC0
      ------XENON---------------
      XENON = 0x3E1
      XENON_COLOUR = 0x406
      -------PERFORMANCE UPGRADE---
      SUSPENSION = 0x3DA
      ARMOUR = 0x3DB
      TURBO = 0x3DD
      EMS = 0x3D6
      BRAKE = 0x3D7
      TRANSMISSION = 0x3D8
  
      FriendName = 0x080         --offset 0x080 Friend name
      FriendRID  = 0x0B8           --offset 0x0B8 Friend RID
      FriendsOnlineStat = 0x1f8  --offset 0x1f8 value 1 or 0 "1 is online and in session"
  
      --------------------------Signature Definition Changer-------------------------------
      PED_FACTORY = get.Memory("WorldPTR")
      GLOBAL_SCRIPT = get.Memory("GlobalPTR")
      PLAYER_LIST = get.Memory("PlayerCountPTR")
      CarSpawn = get.Memory("[GlobalPTR+48]+C5000")
      -------------------------global script-------------------------------------------------
      CharSlot = get.Memory(Global_(1312763))
      NETWORK_HANDLER = get.Memory(Global_(2462514 + 5))
      VEH_HANDLER = get.Memory(Global_(2462514 + 2))
      -- SPAWNER_CORD_X    = get.Memory("CarSpawn+1190")
      -- SPAWNER_CORD_Y    = get.Memory("CarSpawn+1198")
      -- SPAWNER_CORD_Z    = get.Memory("CarSpawn+11A0")
      SPAWNER_SPOILER = get.Memory(Global_(2462514 + 27 + 10))
      BYPASS_VEH_1 = get.Memory(Global_(2462514 + 27 + 95))
      BYPASS_VEH_2 = get.Memory(Global_(2462514 + 27 + 94))
      VEH_LIST = get.Memory(Global_(2462514 + 27 + 66))
      AS_PEGASUS = get.Memory(Global_(2462514 + 3))
      SPW_LIVERY = get.Memory(Global_(2462514 + 27 + 58))
  
      SPAWNER_CORD_X = get.Memory(Global_(2462514 + 7 + 0))
      SPAWNER_CORD_Y = get.Memory(Global_(2462514 + 7 + 1))
      SPAWNER_CORD_Z = get.Memory(Global_(2462514 + 7 + 2))
      AFK1 = get.Memory(Global_(262145 + 87))
      AFK2 = get.Memory(Global_(262145 + 88))
      AFK3 = get.Memory(Global_(262145 + 89))
      AFK4 = get.Memory(Global_(262145 + 90))
      PLATE_LISENCE = get.Memory(Global_(2462514 + 27 + 1))
      TAKE_VISUAL = get.Memory(Global_(1377909 + 4714))
      CASH = get.Memory(Global_(262145 + 28088))
      ARTWORK = get.Memory(Global_(262145 + 28089))
      GOLD = get.Memory(Global_(262145 + 28090))
      DIAMOND = get.Memory(Global_(262145 + 28091))
      LESTER_CUT = get.Memory(Global_(262145 + 28074))
      SALJU = get.Memory(Global_(262145 + 4724))
      JOIN_STATUS = get.Memory(Global_(2426097 + PLAYER_ID() * 443 + 1))
      CHAR_EXP_1 = get.Memory(Global_(1378319 + 9851 + 28))
      CHAR_EXP_2 = get.Memory(Global_(1378319 + 9851 + 29))
      PLAYER_LEVEL = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 6))
      PLAYER_GLOBAL_RP = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 5))
      PLAYER_TOTAL_MONEY = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 56))
      PLAYER_TOTAL_CASH = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 3))
      PLAYER_CURRENT_EXP = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 1))
      PLAYER_TOTAL_KILL = get.Memory(Global_(1590682 + 1 + PLAYER_ID() * 883 + 211 + 28))
      SET_TO_PV = get.Memory(Global_(2409291 + 8))
      RESEACH_TEMP = get.Memory(Global_(262145 + 21389))
      P_DOC = get.Memory(Global_(262145 + 16964))
      P_CASH = get.Memory(Global_(262145 + 16965))
      P_COKE = get.Memory(Global_(262145 + 16966))
      P_METH = get.Memory(Global_(262145 + 16967))
      P_WEED = get.Memory(Global_(262145 + 16968))
      IS_SESSION_PUBLIC = get.Memory(Global_(2452015 + 742))
      TIMER_CARGO = get.Memory(Global_(262145 + 15116))
      CURRENT_SESSION = get.Memory(Global_(1312855))
      CASINO_CUT_1 = get.Memory(Global_(1697306 + 2326))
      CASINO_CUT_2 = get.Memory(Global_(1697306 + 2327))
      CASINO_CUT_3 = get.Memory(Global_(1697306 + 2328))
      CASINO_CUT_4 = get.Memory(Global_(1697306 + 2329))
      DOOMSDAY_CUT_1 = get.Memory(Global_(1693568 + 812 + 50 + 1))
      DOOMSDAY_CUT_2 = get.Memory(Global_(1693568 + 812 + 50 + 2))
      DOOMSDAY_CUT_3 = get.Memory(Global_(1693568 + 812 + 50 + 3))
      DOOMSDAY_CUT_4 = get.Memory(Global_(1693568 + 812 + 50 + 4))
      APT_CUT_1 = get.Memory(Global_(1666211 + 3008 + 1))
      APT_CUT_2 = get.Memory(Global_(1666211 + 3008 + 2))
      APT_CUT_3 = get.Memory(Global_(1666211 + 3008 + 3))
      APT_CUT_4 = get.Memory(Global_(1666211 + 3008 + 4))
      CPERICO_1 = get.Memory(Global_(1704130 + 823 + 56 + 1))
      CPERICO_2 = get.Memory(Global_(1704130 + 823 + 56 + 2))
      CPERICO_3 = get.Memory(Global_(1704130 + 823 + 56 + 3))
      CPERICO_4 = get.Memory(Global_(1704130 + 823 + 56 + 4))
      CAYO_PERICO_BAG = get.Memory(Global_(262145 + 29000))
      BUNKER_MONEY = get.Memory(Global_(262145 + 21070))
      DOC_MONEY = get.Memory(Global_(262145 + 16964))
      CASH_MONEY = get.Memory(Global_(262145 + 16965))
      COCAIN_MONEY = get.Memory(Global_(262145 + 16966))
      WEED_MONEY = get.Memory(Global_(262145 + 16968))
      METH_MONEY = get.Memory(Global_(262145 + 16967))
      S_CARGO_1 = get.Memory(Global_(262145 + 15337))
      FLEECA = get.Memory(Global_(262145 + 8664))
      PRISON_BREAK = get.Memory(Global_(262145 + 8665))
      HUMANE_LAB = get.Memory(Global_(262145 + 8666))
      A_SERIES = get.Memory(Global_(262145 + 8667))
      PASIFIC_STANDARD = get.Memory(Global_(262145 + 8668))
      ACT_1 = get.Memory(Global_(262145 + 8669))
      ACT_2 = get.Memory(Global_(262145 + 8670))
      ACT_3 = get.Memory(Global_(262145 + 8671))
      Panther = get.Memory(Global_(262145 + 29239))
      Madrazo_Files = get.Memory(Global_(262145 + 29238))
      Pink_DIAMOND = get.Memory(Global_(262145 + 29237))
      Bearer_Bonds = get.Memory(Global_(262145 + 29236))
      Ruby = get.Memory(Global_(262145 + 29235))
      Tequila = get.Memory(Global_(262145 + 29234))
      TransitionStatus = get.Memory(Global_(1312792))
      CheatNum = get.Memory(Global_(1388057))
      OffensiveLang = get.Memory(Global_(1388059))
      Griefing = get.Memory(Global_(1388060))
      TagPlate = get.Memory(Global_(1388062))
      OffensiveUGC = get.Memory(Global_(1388063))
      AntiDespawn = get.Memory(Global_(4269479))
      --------------------------Address Definition--------------------------------------------------
      PLAYER_CORDX = get.Memory(CPlayerPos + 0x50, true)
      PLAYER_CORDY = get.Memory(CPlayerPos + 0x54)
      PLAYER_CORDZ = get.Memory(CPlayerPos + 0x58)
  
      PLAYER_VECX = get.Memory(CPlayer + 0x90)
      PLAYER_VECY = get.Memory(CPlayer + 0x94)
      PLAYER_VECZ = get.Memory(CPlayer + 0x98)
  
      PLAYER_HEADING_X = get.Memory(CPlayerPos + 20)
      PLAYER_HEADING_Y = get.Memory(CPlayerPos + 24)
  
      -- PLAYER_VEHX = get.Memory("[[[[WorldPTR]+8]+D28]+30]+50")
      -- PLAYER_VEHY = get.Memory("[[[[WorldPTR]+8]+D28]+30]+54")
      -- PLAYER_VEHZ = get.Memory("[[[[WorldPTR]+8]+D28]+30]+58")
  
      -- PLAYER_VEH_VECX  = get.Memory("[[[WorldPTR]+8]+D28]+90")
      -- PLAYER_VEH_VECY  = get.Memory("[[[WorldPTR]+8]+D28]+94")
      -- PLAYER_VEH_VECZ  = get.Memory("[[[WorldPTR]+8]+D28]+98")
  
      PLAYER_GOD = get.Memory(CPlayer + GOD)
      PLAYER_HP = get.Memory(CPlayer + 0x280)
      PLAYER_ARMOR = get.Memory(CPlayer + 0x14E0)
      DMG_TO_HP = get.Memory(CPlayerInfo + HP_DMG)
      DMG_TO_ARMOR = get.Memory(CPlayerInfo + ARMOR_DMG)
      PLAYER_RUN_SPD = get.Memory(CPlayerInfo + RUN_SPD)
      PLAYER_SWIM_SPD = get.Memory(CPlayerInfo + SWIM_SPD)
      PLAYER_SNEAK_SPD = get.Memory(CPlayerInfo + SNEAK_SPD)
      SUPER_PUNCH = get.Memory(CPlayerInfo + 0xD1C)
      PLAYER_MAX_HP = get.Memory(CPlayer + 0x2A0)
  
      PLAYER_WANTED_LEVEL = get.Memory(CPlayerInfo + 0x888)
      IS_PLAYER_WANTED_LEVEL = get.Memory(CPlayerInfo + 0x880)
      PLAYER_DMG_MULT_MELEE = get.Memory(CPlayerInfo + 0xD14) -- CEC CF8
      PLAYER_DMG_MULT_WEP = get.Memory(CPlayerInfo + 0xD18)
      -- TAKE_ALL        = get.Memory("[[GlobalPTR-128]+1180]+2A578")
      TAKE_ALL = get.Memory(Indicators + 0x2A610)
      TAKE_ALL_C = get.Memory(Indicators + 0x4B500)
      VAULT_DOOR_ARCADE = get.Memory(get.Ptr(GetGlobal + 0xFD0) + 0x3B50)
      VAULT_DOOR = get.Memory(Indicators + 0x127B8)
      TOTAL_PLAYER = get.Memory("[PlayerCountPTR]+178")
      TOTAL_SESSION = get.Memory("[[[PlayerCountPTR]+11*8]+B0]")
      -- CUACA           = get.Memory("GTA5.exe+24C7720") GTA5.exe+24EDC70
      CUACA = get.Memory("GTA5.exe+2500D20")
      RID = get.Memory(CPlayerInfo + 0x90)
      IP_ONLINE = get.Memory(CPlayerInfo + 0x6C)
      IP_LAN = get.Memory(CPlayerInfo + 0x74)
      PORT = get.Memory(CPlayerInfo + 0x78)
      PLAYER_NAME = get.Memory(CPlayerInfo + 0xA4)
      DEL_CASH = get.Memory("[[GlobalPTR-128]+EE0]+19E8")
      DEL_COKE = get.Memory("[[GlobalPTR-128]+F40]+19E8")
      DEL_DOC = get.Memory("[[GlobalPTR-128]+E98]+19E8")
      DEL_WEED = get.Memory("[[GlobalPTR-128]+F10]+19E8")
      DEL_FLY = get.Memory("[[GlobalPTR-128]+EB0]+19E8")
      DEL_BKR = get.Memory("[[GlobalPTR-128]+1180]+3F68")
      DEL_CARGO = get.Memory("[[GlobalPTR-128]+E38]+1268")
      REQ_DEL_CARGO = get.Memory("GTA5.exe+262B3CC")
      -- REQ_DEL_CARGO   = get.Memory("GTA5.exe+26102EC")
      DEL_HANGAR = get.Memory("[[GlobalPTR-128]+1180]+5E38")
      FRAME_FLAG = get.Memory(CPlayerInfo + 0x219)
      INVISIBLE = get.Memory(CPlayer + 0x2C)
      PROP_HASH = get.Memory("[[[[[ReplayInterfacePTR]+20]+B0]+0]+490]+E80")
      PROP_HASH2 = get.Memory("[[[[[ReplayInterfacePTR]+20]+B0]+0]+490]+40")
      -- STAT_BOOL       = get.Memory("[[[GTA5.exe+02D9C378]+498]+220]+218")
      -- STAT_BOOL		= get.Memory("[[[[[GTA5.exe+02D9C378]+DC8]+3F0]+B8]+390]+218")
      -- STAT_BOOL		= get.Memory("[[[[[GTA5.exe+025E8C50]+1B8]+8]+B8]+390]+218")
      STAT_BOOL = get.Memory("[[GlobalPTR-128]+ 0x10C0]+ 0x4AC8")
      PLAYER_COLLISION = get.Memory("[[[[[[[WorldPTR]+8]+30]+10]+20]+70]+0]+2C")
      RID_ASLI = get.Memory("GTA5.exe+29240E8")
      dev_mode = get.Memory("GTA5.exe+A738B4")
      auto_aim = get.Memory("GTA5.exe+1F805CC")
      -- IsTaking        = get.Memory("[[[[[GTA5.exe+01EE18A8]+0]+3B0]+918]+2A0]+318")
      AIM_STATUS = get.Memory("GTA5.exe+1F8BD6C", true)
      JAM = get.Memory("GTA5.exe+1CEE608")
      MENIT = get.Memory("GTA5.exe+1CEE60C")
      DETIK = get.Memory("GTA5.exe+1CEE610")
      Thermalvision = get.Memory("GTA5.exe+22544FA")
      Nightvision = get.Memory("GTA5.exe+225548E")
      Playername1 = get.Memory("GTA5.exe+1F8BD48")
      Playername2 = get.Memory("GTA5.exe+2916514")
      Playername3 = get.Memory("GTA5.exe+2924164")
      Playername4 = get.Memory("GTA5.exe+292F16C")
      Playername5 = get.Memory("GTA5.exe+292F2FC")
      Playername6 = get.Memory("GTA5.exe+2BDF504")
      Playername7 = get.Memory("GTA5.exe+2BE24DF")
      Playername8 = get.Memory("GTA5.exe+2BE58AF")
      Playername9 = get.Memory("GTA5.exe+2BE5B44")
      PublicPlayerID = get.Memory(GA(1312846+1+PLAYER_ID()*883+106658))
      --PrivatePlayerID = get.Memory("[GlobalPTR+0x30]+00*1B98+24788")
      CurrentPlayerID = get.Memory("[GlobalPTR+0x48]+9E2A8")
      Lightning = get.Memory("GTA5.exe+2BA5B48")
      MatiLampu = get.Memory("GTA5.exe+2256FF8")
      CurrentZGround = get.Memory('GTA5.exe+1FAF568')
      WaypointZCoord = get.Memory("GTA5.exe+26BF888")
      PlayerGravity = get.Memory("GTA5.exe+1E07E38")
  end
  function Ptr_class()
    local ptr = readPointer
    -- BaseModelPTR = ptr(ptr("ModelHashPTR") + 0x0)
    -- ModelHash = ptr(BaseModelPTR + 0x2640)
    world = {
      base = 0x8;
      invincible = 0x189;
      health = 0X280;
      armour = 0x14E0;
      in_vehicle = 0xE52;
      ragdoll = 0X10B8;
      navigation = {
        base = 0x30;
      }
    }
    CPlayer     = ptr(ptr("WorldPTR") + 0x8)
    CPlayerInfo = ptr(CPlayer + 0x10C8)
    CPlayerPos  = ptr(CPlayer + 0x30)
    CVehicle    = ptr(CPlayer + 0xD30)
    CUpgrade    = ptr(CVehicle + 0x48)
    CVehiclePos = ptr(CVehicle + 0x30)
    CHandling   = ptr(CVehicle + 0x938)
    CWeapon     = ptr(CPlayer + 0x10D8)
    CInventory  = ptr(CPlayer + 0x10D0)
    CPInventory = ptr(CInventory + 0x48)
    CAmmoType   = ptr(CWeapon + 0x20)
    GetGlobal   = ptr("GlobalPTR-128")
    Indicators  = ptr(ptr("GlobalPTR-128") + 0x1180)
  end
  Ptr_class()
  ptr_string()
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
  
      SET_BIT = function(Address, Offset)
          local Var = get.Int(Address)
          set.int(Address, Var | (1 << Offset));
      end,
  
      IS_BIT_SET = function(Address, Offset)
          return get.Global(int, Address) & (1 << Offset) ~= 0
      end,
  
      CLEAR_BIT = function (Address, Offset)
          local Var = get.Int(Address)
          set.int(Var, Address & ~(1 << Offset))
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
  
  
  
  ----------------------------------------------------------------------------------------------
  C_LOAD = {
    ('Super'),
    ('Sport'),
    ('Sport Classic'),
    ('Summer Update'),
    ('Sedans'),
    ('Service'),
    ('SUVs'),
    ('Planes'),
    ('Helicopters'),
    ('Off Road'),
    ('Muscles'),
    ('Motorcycles'),
    ('Military'),
    ('Trailers'),
    ('Trains'),
    ('Utility'),
    ('Vans'),
    ('Arena Wars'),
    ('Casino Updates'),
    ('Casino Heist'),
    ('Emergency'),
    ('Industrial'),
    ('Coupes'),
    ('Compacts'),
    ('Boats'),
    ('Bikes'),
    ('Commericals'),
    ('Cayo Perico'),
    ('Personal Vehicle')
  }
  function VehicleCategory()
    local new_thread = function()
      local category_list = combobox_getItemIndex(Ellohim.VehicleTypes) + 1;
      switch(C_LOAD[category_list],
      {
        ['Super'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,super,1,"Super Car")
        end,
  
        ['Sport'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,sport,1,"Sport")
        end,
  
        ['Sport Classic'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,sport_classic,1,"Sport Classic")
        end,
  
        ['Summer Update'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,summer_update,1,"Summer Update")
        end,
  
        ['Sedans'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,sedan,1,"Sedans")
        end,
  
        ['Service'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,service,1,"Services")
        end,
  
        ['SUVs'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,SUV,1,"SUVs")
        end,
  
        ['Planes'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,plane,1,"Planes")
        end,
  
        ['Helicopters'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,helicopter,1,"Helicopters")
        end,
  
        ['Off Road'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,off_road,1,"Planes")
        end,
  
        ['Muscles'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,muscle,1,"Muscles")
        end,
  
        ['Motorcycles'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,motorcycle,1,"Motorcycles")
        end,
  
        ['Military'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,military,1,"Military")
        end,
  
        ['Trailers'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,trailer,1,"Trailers")
        end,
  
        ['Trains'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,train,1,"Trains")
        end,
  
        ['Utility'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,utility,1,"Utility")
        end,
  
        ['Vans'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,van,1,"Vans")
        end,
  
        ['Arena Wars'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,arena_war,1,"Arena Wars")
        end,
  
        ['Casino Updates'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,casino1,1,"Casino Updates")
        end,
  
        ['Casino Heist'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,casino2,1,"Casino Heist")
        end,
  
        ['Emergency'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,emergency,1,"Emergency")
        end,
  
        ['Industrial'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,industrial,1,"Industrial")
        end,
  
        ['Coupes'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,coupes,1,"Coupes")
        end,
  
        ['Compacts'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,compact,1,"Compacts")
        end,
  
        ['Boats'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,c_boat,1,"Boats")
        end,
  
        ['Bikes'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,bikes,1,"Bikes")
        end,
  
        ['Commericals'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,commericals,1,"Commericals")
        end,
  
        ['Cayo Perico'] = function ()
          FORM.ADD_LOOP_2(Ellohim.VehicleList,cayo_perico,1,"Cayo Perico")
        end,
  
        ['Personal Vehicle'] = function ()
          GetVehicleSlots()
          FORM.ADD_LOOP_3(Ellohim.VehicleList,tbl_GSV,"Select Vehicle")
        end,
  
        ['default'] = function ()
          return ShowMessage("NULL")
        end,
      }
    )
    end
  ExecuteThread(new_thread)
  end
  switcher={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28}
  function VehicleSpawner()
    --local VehicleCategoryID = VehicleTab.category.itemIndex+1
    local VehicleSpawnerList = VehicleTab.CEComboBox9
    local VehicleListByCategory = VehicleTab.VehicleList
    local id2 = listbox_getItemIndex(Ellohim.VehicleList);
    local id = combobox_getItemIndex(Ellohim.SpawnTypes);
    local id3 = Ellohim.VehicleTypes.itemIndex + 1;
  if id == 1 then
    switch(id3,
          {
        [1] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,super[id2][2])
        end,
  
        [2] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,sport[id2][2])
        end,
  
        [3] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,sport_classic[id2][2])
        end,
  
        [4] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,summer_update[id2][2])
        end,
  
        [5] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,sedan[id2][2])
        end,
  
        [6] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,service[id2][2])
        end,
  
        [7] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,SUV[id2][2])
        end,
  
        [8] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,plane[id2][2])
        end,
  
        [9] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,helicopter[id2][2])
        end,
  
        [10] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,off_road[id2][2])
        end,
  
        [11] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,muscle[id2][2])
        end,
  
        [12] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,motorcycle[id2][2])
        end,
  
        [13] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,military[id2][2])
        end,
  
        [14] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,trailer[id2][2])
        end,
  
        [15] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,train[id2][2])
        end,
  
        [16] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,utility[id2][2])
        end,
  
        [17] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,van[id2][2])
        end,
  
        [18] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,arena_war[id2][2])
        end,
  
        [19] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,casino1[id2][2])
        end,
  
        [20] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,casino2[id2][2])
        end,
  
        [21] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,emergency[id2][2])
        end,
  
        [22] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,industrial[id2][2])
        end,
  
        [23] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,coupes[id2][2])
        end,
  
        [24] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,compact[id2][2])
        end,
  
        [25] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,c_boat[id2][2])
        end,
  
        [26] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,bikes[id2][2])
        end,
  
        [27] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,commericals[id2][2])
        end,
  
        [28] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],deactivate,cayo_perico[id2][2])
        end
      }
    )
  elseif id == 2 then
    switch(id3,{
        [1] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,super[id2][2])
        end,
  
        [2] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,sport[id2][2])
        end,
  
        [3] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,sport_classic[id2][2])
        end,
  
        [4] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,summer_update[id2][2])
        end,
  
        [5] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,sedan[id2][2])
        end,
  
        [6] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,service[id2][2])
        end,
  
        [7] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,SUV[id2][2])
        end,
  
        [8] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,plane[id2][2])
        end,
  
        [9] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,helicopter[id2][2])
        end,
  
        [10] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,off_road[id2][2])
        end,
  
        [11] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,muscle[id2][2])
        end,
  
        [12] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,motorcycle[id2][2])
        end,
  
        [13] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,military[id2][2])
        end,
  
        [14] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,trailer[id2][2])
        end,
  
        [15] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,train[id2][2])
        end,
  
        [16] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,utility[id2][2])
        end,
  
        [17] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,van[id2][2])
        end,
  
        [18] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,arena_war[id2][2])
        end,
  
        [19] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,casino1[id2][2])
        end,
  
        [20] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,casino2[id2][2])
        end,
  
        [21] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,emergency[id2][2])
        end,
  
        [22] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,industrial[id2][2])
        end,
  
        [23] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,coupes[id2][2])
        end,
  
        [24] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,compact[id2][2])
        end,
  
        [25] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,c_boat[id2][2])
        end,
  
        [26] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,bikes[id2][2])
        end,
  
        [27] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,commericals[id2][2])
        end,
  
        [28] = function()
          VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],TRUE,cayo_perico[id2][2])
        end
      }
    )
    elseif id == 3 then
          if id2==-1 or id2==0 then return end
          set.global(int,2540612+962,tbl_GSV[id2][1])
          set.global(int,2540612+959,1)
          SYSTEM.WAIT(700)
          set.global(bool,2409291+8,true)
    end
  end
  
  function ExhaustSelect(sender)
    local id = Ellohim.ExhaustSpawner.ItemIndex
    if id == nil then id = MAX_UINT end
    set.global(int,2462514+27+14,id)
  end
  
  function VentSelect(sender)
    local id = Ellohim.VentSpawner.ItemIndex
    if id == nil then id = MAX_UINT end
    set.global(int,2462514+27+17,id)
  end
  
  function SideSkirtSelect()
    local id = VehicleTab.SideSkirt.ItemIndex
    if id == nil then id = MAX_UINT end
    set.global(int,2462514+27+13,id)
  end
  
  function RearBumperSelect()
    local id = VehicleTab.BackBumper.ItemIndex
    if id == nil then id = MAX_UINT end
    set.global(int,2462514+27+12,id)
  end
  
  function SpawnerXenon()
    local colour_id = {255,3,4,5,6,7,8,9,10,11,12,13,14}
    local xenon_id = combobox_getItemIndex(Ellohim.XenonColorSpawner) + 1;
    if xenon_id == nil then
      set.global(int,2462514+27+32,255)
    else
      set.global(int,2462514+27+32,colour_id[xenon_id])
    end
  end
  spoiler_spawner = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ,11, 12, 13, 14, 15, 16, 17, 18
  ,19, 20, 21, 22}
  
  function SpoilerSpawner()
    local spoiler_id = combobox_getItemIndex(Ellohim.SpoilerSpawner);
    set.int(SPAWNER_SPOILER, spoiler_spawner[spoiler_id])
  end
  
  function PrimaryWeapon(sender)
    local weapon_id = combobox_getItemIndex(Ellohim.PrimaryWeaponSpawner);
    if weapon_id==0 then
      SetListV("Primary Weapon",0)
    elseif weapon_id==1 then
      SetListV("Primary Weapon",1)
    elseif weapon_id==2 then
      SetListV("Primary Weapon",2)
    elseif weapon_id==3 then
      SetListV("Primary Weapon",3)
    elseif weapon_id==4 then
      SetListV("Primary Weapon",4)
    end
  end
  
  function SecondaryWeapon(sender)
    local weapon_id2 = combobox_getItemIndex(Ellohim.SecondaryWeaponSpawner);
    if weapon_id2==0 then
      SetListV("Secondary Weapon",0)
    elseif weapon_id2==1 then
      SetListV("Secondary Weapon",1)
    elseif weapon_id2==2 then
      SetListV("Secondary Weapon",2)
    elseif weapon_id2==3 then
      SetListV("Secondary Weapon",3)
    elseif weapon_id2==4 then
      SetListV("Secondary Weapon",4)
    end
  end
  -----------------------------------------Group Function-----------------------------------
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
  
          set.global(float, 2462514 + 7 + 0, spawner_x)
          set.global(float, 2462514 + 7 + 1, spawner_y)
          set.global(float, 2462514 + 7 + 2, spawner_z)
          set.int(VEH_LIST, joaat(Hash))
          set.global(bool, 2462514 + 27 + 28, 1) -- weaponised ownerflag
          set.int(BYPASS_VEH_1, 14) -- ownerflag
          set.int(BYPASS_VEH_2, 2) -- personal car ownerflag
          set.global(bool, 2462514 + 5, true) ---SET('i',CarSpawn+0x1168, 1)  --can spawn flag must be odd
          set.global(bool, 2462514 + 2, true) ---SET('i',CarSpawn+0x1180, 1) --spawn toggle gets reset to 0 on car spawn
          set.global(bool, 2462514 + 3, pegasus)
          set.global(int, 2462514 + 27 + 74, 1) -- Red Neon Amount 1-255 100%-0%
          set.global(int, 2462514 + 27 + 75, 1) -- Green Neon Amount 1-255 100%-0%
          set.global(int, 2462514 + 27 + 76, 0) -- Blue Neon Amount 1-255 100%-0%
          set.global(int, 2462514 + 27 + 77, 4030726305) -- landinggear/vehstate
          -- set.global(int,2462514+27+5, -1)  --default paintjob primary -1 auto 120
          -- set.global(int,2462514+27+6, -1)  --default paintjob secondary -1 auto 120
          set.global(int, 2462514 + 27 + 7, -1)
          set.global(int, 2462514 + 27 + 8, -1)
          set.global(int, 2462514 + 27 + 19, 4)
          set.global(int, 2462514 + 27 + 60, 1)
          -- set.global(int,2462514+27+20,1)
          set.global(int, 2462514 + 27 + 21, 3)
          set.global(int, 2462514 + 27 + 22, 6)
          set.global(int, 2462514 + 27 + 23, 9)
          set.global(int, 2462514 + 27 + 24, 58)
          set.global(int, 2462514 + 27 + 25, 13)
          set.global(int, 2462514 + 27 + 26, 18)
          set.global(int, 2462514 + 27 + 27, 1)
          -- set.global(int,2462514+27+69,8) ---Wheel type
          -- set.global(int,2462514+27+33,217) --Wheel Selection
          -- 2462514+27+17 --Pokoknya depan mesin mobil (vent)
          -- 2462514+27+14 -- Exhaust
          -- 2462514+27+13 -- side skirt
          -- 2462514+27+12 -- Back Bumper
          return get.Global(int,2540612+6583);
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
  -----------------------------------------Function-----------------------------------------
  function frameFlagsOnTick(t)
      local SetFrame = 0
      if g_superJump then
          SetFrame = 1 << 14
      end
      if g_flamingFists then
          SetFrame = 1 << 13
      end
      if g_flamingAmmo then
          SetFrame = 1 << 12
      end
      if g_explosiveAmmo then
          SetFrame = 1 << 11
      end
      set.int(CPlayerInfo + 0x218, SetFrame) -- 0x1F8
  end
  if g_frameTimer == nil then
      g_frameTimer = createTimer(nil, false)
      g_frameTimer.Interval = 1
      g_frameTimer.setOnTimer(frameFlagsOnTick)
  end
  
  function VehicleGodmode(Activation)
      VehicleGodmodeRun = Activation
      local VehGodQueue = function()
          while (VehicleGodmodeRun) do
              ENTITY.SET_ENTITY_INVINCIBLE(TRUE)
              if not VehicleGodmodeRun then
                  ENTITY.SET_ENTITY_INVINCIBLE(FALSE)
                  break
              end
              SYSTEM.WAIT(2000)
          end
      end
      ExecuteThread(VehGodQueue)
  end
  
  function PlayerGodmode(Activation)
      PlayerGodmodeActivator = Activation
      local PlayerGodmod = AsyncBegin(function()
          while (PlayerGodmodeActivator) do
              print('test')
              PLAYER.SET_PLAYER_INVINCIBLE(true)
              if not PlayerGodmodeActivator then
                  PLAYER.SET_PLAYER_INVINCIBLE(false)
                  break
              end
              await()
          end
      end)
      AsyncEnd(PlayerGodmod,1000)
  end
  function AutoHealPlayer(Activation)
      AutoHealActivator = Activation
      local AutoHealRun = AsyncBegin(function()
          while AutoHealActivator do
              local health = get.Float(PLAYER_HP)
              local Maximum_Health = get.Float(PLAYER_MAX_HP)
              if health >= 1 and health <= 200 then
                  set.float(PLAYER_HP, Maximum_Health)
                  set.float(PLAYER_ARMOR, 50)
                  set.float(DMG_TO_HP, 0.5)
              else
                  set.float(DMG_TO_HP, 1)
              end
              if not AutoHealActivator then break end
              await()
          end
      end)
      AsyncEnd(AutoHealRun,100)
  end
  
  function NeverWanted(Activation)
      NeverWantedActivator = Activation
      local NeverWantedRun = AsyncBegin(function()
          while NeverWantedActivator do
              PLAYER.SET_PLAYER_WANTED_LEVEL(0)
              if not NeverWantedActivator then break end
              await()
          end
      end)
      AsyncEnd(AutoHealRun,100)
  end
  
  function NoIdleKick(Activation)
      NoIdleKickActivator = Activation
      local NoIdleKickRun = AsyncBegin(function()
          while NoIdleKickActivator do
              set.int(AFK1, MAX_INT)
              set.int(AFK2, MAX_INT)
              set.int(AFK3, MAX_INT)
              set.int(AFK4, MAX_INT)
              if not NoIdleKickActivator then
                  set.int(AFK1, 120000)
                  set.int(AFK2, 300000)
                  set.int(AFK3, 600000)
                  set.int(AFK4, 900000)
                  break
              end
          await()
          end
      end)
      AsyncEnd(NoIdleKickRun, 1500)
  end
  
  function NoCollision(Activation)
      NoCollisionActivation = Activation
      local NoCollisionRun = function()
          while (NoCollisionRun) do
              set.float(PLAYER_COLLISION, -1)
              if not NoCollisionRun then
                  set.float(PLAYER_COLLISION, 0.25)
                  break
              end
              SYSTEM.WAIT(1000)
          end
      end
      ExecuteThread(NoCollisionRun)
  end
  
  function NightVision(Boolean)
      if Boolean then
          set.bool(PublicPlayerID, true)
          set.bool(Nightvision, true)
      else
          set.bool(PublicPlayerID, false)
          set.bool(Nightvision, false)
      end
  end
  
  function ThermalVision(Boolean)
      if Boolean then
          set.bool(PublicPlayerID, true)
          set.bool(Thermalvision, true)
      else
          set.bool(PublicPlayerID, false)
          set.bool(Thermalvision, false)
      end
  end
  
  function NoDamageToPlayer(Activation)
      NoDamageActivator = Activation
      local MaxHealth = get.Float(CPlayer + 0x2A0)
      local Bulletproof = AsyncBegin(function()
          while NoDamageActivator do
              set.float(PLAYER_HP, MaxHealth)
              set.float(PLAYER_ARMOR, 50)
              set.float(CPlayerInfo + HP_DMG, FALSE)
              set.float(CPlayerInfo + ARMOR_DMG, FALSE)
              set.float(PLAYER_RUN_SPD, 1.2)
              set.float(PLAYER_SWIM_SPD, 1.2)
              set.float(PLAYER_SNEAK_SPD, 1.2)
              if not NoDamageActivator then
                  set.float(CPlayerInfo + HP_DMG, TRUE)
                  set.float(CPlayerInfo + ARMOR_DMG, TRUE)
                  set.float(PLAYER_RUN_SPD, 1)
                  set.float(PLAYER_SWIM_SPD, 1)
                  set.float(PLAYER_SNEAK_SPD, 1)
                  break
              end
              await()
          end
      end)
      AsyncEnd(Bulletproof,2000)
  end
  -----------------------------------------Action/Event Control-----------------------------
  function MenuGodmode(sender)
     if Ellohim.GodmodeCheckbox.wordwrap then
        PlayerGodmode(true)
     else
        PlayerGodmode(false)
     end
  end
  
  function MenuAutoHeal(sender)
     if Ellohim.AutoHealCheckbox.wordwrap then
        AutoHealPlayer(true)
     else
        AutoHealPlayer(false)
     end
  end
  
  function MenuNeverWanted(sender)
     if Ellohim.NeverWantedCheckbox.wordwrap then
        NeverWanted(true)
     else
        NeverWanted(false)
     end
  end
  
  function MenuNoIdleKick(sender)
     if Ellohim.AntiAfkCheckbox.wrap then
        NoIdleKick(true)
     else
        NoIdleKick(false)
     end
  end
  
  function MenuPassThroughWall(sender)
     if Ellohim.NoCollisionCheckbox.wordwrap then
        NoCollision(true)
     else
        NoCollision(false)
     end
  end
  
  function MenuNightVision(sender)
     if Ellohim.NightvisionCheckbox.wordwrap then
        NightVision(true)
     else
        NightVision(false)
     end
  end
  
  function MenuSuperJump(sender)
     if Ellohim.SuperJumpCheckbox.wordwrap then
        g_frameTimer.Enabled = true
        g_superJump = true
     else
        g_frameTimer.Enabled = false
        g_superJump = false
     end
  end
  
  function MenuWalkInWater(sender)
  
  end
  
  function MenuThermalVision(sender)
     if Ellohim.ThermalVisionCheckbox.wordwrap then
        ThermalVision(true)
     else
        ThermalVision(false)
     end
  end
  
  function MenuInfiniteHealth(sender)
     if Ellohim.InfiniteHealthCheckbox.wordwrap then
        NoDamageToPlayer(true)
     else
        NoDamageToPlayer(false)
     end
  end
  
  function MenuFastHealthRegen(sender)
  
  end
  
  function MenuExplosiveFist(sender)
  
  end
  
  function MenuInfiniteAmmo(sender)
  
  end
  ------------------------------------------------------------------------------------------
  function formdrag2d4663()
      Ellohim.dragNow()
  end
  
  function closeform2d4663()
      os.exit()
  end
  
  function Minimizer(sender, button, x, y)
      Ellohim.WindowState = "wsMinimized"
  end
  
  function MinimizerColor(sender, button, x, y)
  end
  
  function hexToRGB(hex)
      local r, g, b
      b = tonumber("0x" .. hex:sub(1, 2))
      g = tonumber("0x" .. hex:sub(3, 4))
      r = tonumber("0x" .. hex:sub(5, 6))
      return {r, g, b}
  end
  
  function rgbToHex(rgb)
      return rgb ~= nil and string.format("%02X", rgb[3]) .. string.format("%02X", rgb[2]) ..
                 string.format("%02X", rgb[1]) or 0
  end
  
  function round(num)
      return math.floor(num + .5)
  end
  local fromColor1 = {};
  local toColor1 = {};
  local colorSpeed1 = {r, g, b};
  local transitionTarget1;
  local speeeeeeed1 = 0;
  local speedc1 = 0;
  local transitionOption1 = {
      completeOldColor = true
  }
  function transitionTimer1(sender)
      transitionTarget1.bevelcolor = "0x" .. rgbToHex(fromColor1);
      fromColor1[1] = fromColor1[1] + colorSpeed1.r;
      fromColor1[2] = fromColor1[2] + colorSpeed1.g;
      fromColor1[3] = fromColor1[3] + colorSpeed1.b;
      speedc1 = speedc1 + 1;
      if speedc1 >= speeeeeeed1 then
          transitionTarget1.bevelcolor = "0x" .. rgbToHex(toColor1)
          speedc1 = 0
          transitionColor1.enabled = false
          return
      end
  end
  if transitionColor1 == nil then
      transitionColor1 = createTimer(nil)
  end
  transitionColor1.interval = 1;
  transitionColor1.ontimer = transitionTimer1;
  transitionColor1.enabled = false;
  function gotoColor1(object, color, speed)
      speedc1 = 0;
      speeeeeeed1 = speed;
      if transitionOption1.completeOldColor then
          if transitionTarget1 ~= nil then
              transitionTarget1.bevelcolor = "0x" .. rgbToHex(toColor1)
          end
      end
      transitionTarget1 = object;
      fromColor1 = hexToRGB(string.format("%06X", object.bevelcolor));
      toColor1 = color;
      colorSpeed1.r = round((toColor1[1] - fromColor1[1]) / speed);
      colorSpeed1.g = round((toColor1[2] - fromColor1[2]) / speed);
      colorSpeed1.b = round((toColor1[3] - fromColor1[3]) / speed);
      transitionColor1.enabled = true;
  end
  
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
  
  function formdrag4d4663()
      Ellohim.dragNow()
  end
  
  function closeform4d4663()
      os.exit()
  end
  
  function PageMenu1(sender, button, x, y)
      Ellohim.Page_Button_1.color = 0xEC8C71
      Ellohim.Page_Button_1.font.color = 0xFFFFFF
      Ellohim.Page_Button_2.color = 0x282828
      Ellohim.Page_Button_2.font.color = 0xC0C0C0
      Ellohim.Page_Button_3.color = 0x282828
      Ellohim.Page_Button_3.font.color = 0xC0C0C0
      Ellohim.Page_Button_4.color = 0x282828
      Ellohim.Page_Button_4.font.color = 0xC0C0C0
      Ellohim.Page_Button_5.color = 0x282828
      Ellohim.Page_Button_5.font.color = 0xC0C0C0
      Ellohim.Page_Button_6.color = 0x282828
      Ellohim.Page_Button_6.font.color = 0xC0C0C0
      Ellohim.Page_1.bringToFront()
      Ellohim.Page_3.bringToFront()
      Ellohim.Page_1.visible = true
      Ellohim.Page_2.visible = false
      Ellohim.Page_3.visible = false
      Ellohim.Page_4.visible = false
      Ellohim.Page_5.visible = false
      Ellohim.Page_6.visible = false
  end
  
  function PageMenu2(sender, button, x, y)
      Ellohim.Page_Button_2.color = 0xEC8C71
      Ellohim.Page_Button_2.font.color = 0xFFFFFF
      Ellohim.Page_Button_1.color = 0x282828
      Ellohim.Page_Button_1.font.color = 0xC0C0C0
      Ellohim.Page_Button_3.color = 0x282828
      Ellohim.Page_Button_3.font.color = 0xC0C0C0
      Ellohim.Page_Button_4.color = 0x282828
      Ellohim.Page_Button_4.font.color = 0xC0C0C0
      Ellohim.Page_Button_5.color = 0x282828
      Ellohim.Page_Button_5.font.color = 0xC0C0C0
      Ellohim.Page_Button_6.color = 0x282828
      Ellohim.Page_Button_6.font.color = 0xC0C0C0
      Ellohim.Page_2.bringToFront()
      Ellohim.Page_3.bringToFront()
      Ellohim.Page_1.visible = false
      Ellohim.Page_2.visible = true
      Ellohim.Page_3.visible = false
      Ellohim.Page_4.visible = false
      Ellohim.Page_5.visible = false
      Ellohim.Page_6.visible = false
  end
  
  function PageMenu3(sender, button, x, y)
      Ellohim.Page_Button_3.color = 0xEC8C71
      Ellohim.Page_Button_3.font.color = 0xFFFFFF
      Ellohim.Page_Button_1.color = 0x282828
      Ellohim.Page_Button_1.font.color = 0xC0C0C0
      Ellohim.Page_Button_2.color = 0x282828
      Ellohim.Page_Button_2.font.color = 0xC0C0C0
      Ellohim.Page_Button_4.color = 0x282828
      Ellohim.Page_Button_4.font.color = 0xC0C0C0
      Ellohim.Page_Button_5.color = 0x282828
      Ellohim.Page_Button_5.font.color = 0xC0C0C0
      Ellohim.Page_Button_6.color = 0x282828
      Ellohim.Page_Button_6.font.color = 0xC0C0C0
      Ellohim.Page_3.bringToFront()
      Ellohim.Page_1.visible = false
      Ellohim.Page_2.visible = false
      Ellohim.Page_3.visible = true
      Ellohim.Page_4.visible = false
      Ellohim.Page_5.visible = false
      Ellohim.Page_6.visible = false
  end
  
  function PageMenu4(sender, button, x, y)
      Ellohim.Page_Button_4.color = 0xEC8C71
      Ellohim.Page_Button_4.font.color = 0xFFFFFF
  
      Ellohim.Page_Button_3.color = 0x282828
      Ellohim.Page_Button_3.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_1.color = 0x282828
      Ellohim.Page_Button_1.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_2.color = 0x282828
      Ellohim.Page_Button_2.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_5.color = 0x282828
      Ellohim.Page_Button_5.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_6.color = 0x282828
      Ellohim.Page_Button_6.font.color = 0xC0C0C0
  
      Ellohim.Page_4.bringToFront()
      Ellohim.Page_1.visible = false
      Ellohim.Page_2.visible = false
      Ellohim.Page_3.visible = false
      Ellohim.Page_4.visible = true
      Ellohim.Page_5.visible = false
      Ellohim.Page_6.visible = false
  end
  
  function PageMenu5(sender, button, x, y)
      Ellohim.Page_Button_5.color = 0xEC8C71
      Ellohim.Page_Button_5.font.color = 0xFFFFFF
  
      Ellohim.Page_Button_3.color = 0x282828
      Ellohim.Page_Button_3.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_1.color = 0x282828
      Ellohim.Page_Button_1.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_2.color = 0x282828
      Ellohim.Page_Button_2.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_4.color = 0x282828
      Ellohim.Page_Button_4.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_6.color = 0x282828
      Ellohim.Page_Button_6.font.color = 0xC0C0C0
  
      Ellohim.Page_5.bringToFront()
      Ellohim.Page_4.bringToFront()
      Ellohim.Page_1.visible = false
      Ellohim.Page_2.visible = false
      Ellohim.Page_3.visible = false
      Ellohim.Page_4.visible = false
      Ellohim.Page_5.visible = true
      Ellohim.Page_6.visible = false
  end
  
  function PageMenu6(sender, button, x, y)
      Ellohim.Page_Button_6.color = 0xEC8C71
      Ellohim.Page_Button_6.font.color = 0xFFFFFF
  
      Ellohim.Page_Button_3.color = 0x282828
      Ellohim.Page_Button_3.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_1.color = 0x282828
      Ellohim.Page_Button_1.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_2.color = 0x282828
      Ellohim.Page_Button_2.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_4.color = 0x282828
      Ellohim.Page_Button_4.font.color = 0xC0C0C0
  
      Ellohim.Page_Button_5.color = 0x282828
      Ellohim.Page_Button_5.font.color = 0xC0C0C0
  
      Ellohim.Page_5.bringToFront()
      Ellohim.Page_1.visible = false
      Ellohim.Page_2.visible = false
      Ellohim.Page_3.visible = false
      Ellohim.Page_4.visible = false
      Ellohim.Page_5.visible = false
      Ellohim.Page_6.visible = true
  end
  
  function cbmousedownsdb6d4663(sender, button, x, y)
      if Ellohim.GodmodeCheckbox.wordwrap == false then
          Ellohim.GodmodeCheckbox.wordwrap = true
          gotoColor2(Ellohim.GodmodeCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.GodmodeCheckbox.wordwrap = false
          gotoColor2(Ellohim.GodmodeCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb7d4663(sender, button, x, y)
      if Ellohim.AutoHealCheckbox.wordwrap == false then
          Ellohim.AutoHealCheckbox.wordwrap = true
          gotoColor2(Ellohim.AutoHealCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.AutoHealCheckbox.wordwrap = false
          gotoColor2(Ellohim.AutoHealCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function enterlbsdb9d4663()
      gotoColor1(Ellohim.PlayerListPanel, {113, 140, 236}, 15)
  end
  function exitlbsdb9d4663()
      gotoColor1(Ellohim.PlayerListPanel, {15, 15, 15}, 15)
  end
  
  function entermemosdb10d4663()
      gotoColor1(Ellohim.PlayerInfoPanel, {113, 140, 236}, 15)
  end
  function exitmemosdb10d4663()
      gotoColor1(Ellohim.PlayerInfoPanel, {15, 15, 15}, 15)
  end
  
  function ceeditsdb_enter1d1099(sender)
      gotoColor1(Ellohim.StatHashPanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit1d1099(sender)
      gotoColor1(Ellohim.StatHashPanel, {15, 15, 15}, 15)
  end
  
  function ceeditsdb_enter2d1099(sender)
      gotoColor1(Ellohim.StatValuePanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit2d1099(sender)
      gotoColor1(Ellohim.StatValuePanel, {15, 15, 15}, 15)
  end
  
  function btnsdb_mousedown3d1099(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup3d1099(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function cbmousedownsdb4d1099(sender, button, x, y)
      if Ellohim.NeverWantedCheckbox.wordwrap == false then
          Ellohim.NeverWantedCheckbox.wordwrap = true
          gotoColor2(Ellohim.NeverWantedCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.NeverWantedCheckbox.wordwrap = false
          gotoColor2(Ellohim.NeverWantedCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb5d1099(sender, button, x, y)
      if Ellohim.AntiAfkCheckbox.wordwrap == false then
          Ellohim.AntiAfkCheckbox.wordwrap = true
          gotoColor2(Ellohim.AntiAfkCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.AntiAfkCheckbox.wordwrap = false
          gotoColor2(Ellohim.AntiAfkCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb6d1099(sender, button, x, y)
      if Ellohim.NoCollisionCheckbox.wordwrap == false then
          Ellohim.NoCollisionCheckbox.wordwrap = true
          gotoColor2(Ellohim.NoCollisionCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.NoCollisionCheckbox.wordwrap = false
          gotoColor2(Ellohim.NoCollisionCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb7d1099(sender, button, x, y)
      if Ellohim.NightVisionCheckbox.wordwrap == false then
          Ellohim.NightVisionCheckbox.wordwrap = true
          gotoColor2(Ellohim.NightVisionCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.NightVisionCheckbox.wordwrap = false
          gotoColor2(Ellohim.NightVisionCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb8d1099(sender, button, x, y)
      if Ellohim.SuperJumpCheckbox.wordwrap == false then
          Ellohim.SuperJumpCheckbox.wordwrap = true
          gotoColor2(Ellohim.SuperJumpCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.SuperJumpCheckbox.wordwrap = false
          gotoColor2(Ellohim.SuperJumpCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb9d1099(sender, button, x, y)
      if Ellohim.WaterProofCheckbox.wordwrap == false then
          Ellohim.WaterProofCheckbox.wordwrap = true
          gotoColor2(Ellohim.WaterProofCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.WaterProofCheckbox.wordwrap = false
          gotoColor2(Ellohim.WaterProofCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb10d1099(sender, button, x, y)
      if Ellohim.ThermalVisionCheckbox.wordwrap == false then
          Ellohim.ThermalVisionCheckbox.wordwrap = true
          gotoColor2(Ellohim.ThermalVisionCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ThermalVisionCheckbox.wordwrap = false
          gotoColor2(Ellohim.ThermalVisionCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb11d1099(sender, button, x, y)
      if Ellohim.InfiniteHealthCheckbox.wordwrap == false then
          Ellohim.InfiniteHealthCheckbox.wordwrap = true
          gotoColor2(Ellohim.InfiniteHealthCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.InfiniteHealthCheckbox.wordwrap = false
          gotoColor2(Ellohim.InfiniteHealthCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb12d1099(sender, button, x, y)
      if Ellohim.HealthRegenCheckbox.wordwrap == false then
          Ellohim.HealthRegenCheckbox.wordwrap = true
          gotoColor2(Ellohim.HealthRegenCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.HealthRegenCheckbox.wordwrap = false
          gotoColor2(Ellohim.HealthRegenCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb13d1099(sender, button, x, y)
      if Ellohim.ExplosiveFistCheckbox.wordwrap == false then
          Ellohim.ExplosiveFistCheckbox.wordwrap = true
          gotoColor2(Ellohim.ExplosiveFistCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ExplosiveFistCheckbox.wordwrap = false
          gotoColor2(Ellohim.ExplosiveFistCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb14d1099(sender, button, x, y)
      if Ellohim.InfiniteAmmoCheckbox.wordwrap == false then
          Ellohim.InfiniteAmmoCheckbox.wordwrap = true
          gotoColor2(Ellohim.InfiniteAmmoCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.InfiniteAmmoCheckbox.wordwrap = false
          gotoColor2(Ellohim.InfiniteAmmoCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function btnsdb_mousedown15d1099(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
      if not Ellohim.LevelCombo.wordwrap then
          gotoColor2(Ellohim.LevelCombo, {113, 140, 236}, 20)
          Ellohim.LevelCombo.wordwrap = true
          Ellohim.LevelPanel.visible = true
      else
          Ellohim.LevelCombo.wordwrap = false
          Ellohim.LevelPanel.visible = false
          gotoColor2(Ellohim.LevelCombo, {30, 30, 30}, 20)
      end
  end
  
  function btnsdb_mouseup15d1099(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function enterlbsdb16d1099()
      gotoColor1(Ellohim.LevelPanel, {113, 140, 236}, 15)
  end
  function exitlbsdb16d1099()
      gotoColor1(Ellohim.LevelPanel, {15, 15, 15}, 15)
  end
  
  function HealPlayerEvent(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function HealPlayerColor(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function KillPlayerEvent(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function KillPlayerColor(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function btnsdb_mousedown22d1099(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup22d1099(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function btnsdb_mousedown23d1099(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup23d1099(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function enterlbsdb5d7307()
      gotoColor1(Ellohim.WeaponPanel, {113, 140, 236}, 15)
  end
  
  function exitlbsdb5d7307()
      gotoColor1(Ellohim.WeaponPanel, {15, 15, 15}, 15)
  end
  
  function btnsdb_mousedown24d1099(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
      if not Ellohim.WeaponCombo.wordwrap then
          gotoColor2(Ellohim.WeaponCombo, {113, 140, 236}, 20)
          Ellohim.WeaponCombo.wordwrap = true
          Ellohim.WeaponPanel.visible = true
      else
          Ellohim.WeaponCombo.wordwrap = false
          Ellohim.WeaponPanel.visible = false
          gotoColor2(Ellohim.WeaponCombo, {30, 30, 30}, 20)
      end
  end
  
  function btnsdb_mouseup24d1099(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function btnsdb_mousedown1d8115(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
      Ellohim.PlayerSubPage_1.visible = true
  end
  
  function btnsdb_mouseup1d8115(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function btnsdb_mousedown9d8115(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
      Ellohim.PlayerSubPage_1.visible = false
  end
  
  function btnsdb_mouseup9d8115(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function cbmousedownsdb2d8115(sender, button, x, y)
      if Ellohim.FlameAmmoCheckbox.wordwrap == false then
          Ellohim.FlameAmmoCheckbox.wordwrap = true
          gotoColor2(Ellohim.FlameAmmoCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.FlameAmmoCheckbox.wordwrap = false
          gotoColor2(Ellohim.FlameAmmoCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb3d8115(sender, button, x, y)
      if Ellohim.ExplosiveAmmoCheckbox.wordwrap == false then
          Ellohim.ExplosiveAmmoCheckbox.wordwrap = true
          gotoColor2(Ellohim.ExplosiveAmmoCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ExplosiveAmmoCheckbox.wordwrap = false
          gotoColor2(Ellohim.ExplosiveAmmoCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb4d8115(sender, button, x, y)
      if Ellohim.NoRecoil.wordwrap == false then
          Ellohim.NoRecoil.wordwrap = true
          gotoColor2(Ellohim.NoRecoil, {113, 140, 236}, 20)
      else
          Ellohim.NoRecoil.wordwrap = false
          gotoColor2(Ellohim.NoRecoil, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb5d8115(sender, button, x, y)
      if Ellohim.NoSpread.wordwrap == false then
          Ellohim.NoSpread.wordwrap = true
          gotoColor2(Ellohim.NoSpread, {113, 140, 236}, 20)
      else
          Ellohim.NoSpread.wordwrap = false
          gotoColor2(Ellohim.NoSpread, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb6d8115(sender, button, x, y)
      if Ellohim.cbboxsdb6d8115.wordwrap == false then
          Ellohim.cbboxsdb6d8115.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb6d8115, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb6d8115.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb6d8115, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb7d8115(sender, button, x, y)
      if Ellohim.cbboxsdb7d8115.wordwrap == false then
          Ellohim.cbboxsdb7d8115.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb7d8115, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb7d8115.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb7d8115, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb8d8115(sender, button, x, y)
      if Ellohim.cbboxsdb8d8115.wordwrap == false then
          Ellohim.cbboxsdb8d8115.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb8d8115, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb8d8115.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb8d8115, {30, 30, 30}, 20)
      end
  end
  
  function ceeditsdb_enter10d8115(sender)
      gotoColor1(Ellohim.ReadHashPanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit10d8115(sender)
      gotoColor1(Ellohim.ReadHashPanel, {15, 15, 15}, 15)
  end
  
  function ceeditsdb_enter11d8115(sender)
      gotoColor1(Ellohim.ReadValuePanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit11d8115(sender)
      gotoColor1(Ellohim.ReadValuePanel, {15, 15, 15}, 15)
  end
  
  function btnsdb_mousedown12d8115(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup12d8115(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function cbmousedownsdb13d8115(sender, button, x, y)
      if Ellohim.WriteIntegerCheckbox.wordwrap == false then
          Ellohim.WriteIntegerCheckbox.wordwrap = true
          gotoColor2(Ellohim.WriteIntegerCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.WriteIntegerCheckbox.wordwrap = false
          gotoColor2(Ellohim.WriteIntegerCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb14d8115(sender, button, x, y)
      if Ellohim.WriteFloatCheckbox.wordwrap == false then
          Ellohim.WriteFloatCheckbox.wordwrap = true
          gotoColor2(Ellohim.WriteFloatCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.WriteFloatCheckbox.wordwrap = false
          gotoColor2(Ellohim.WriteFloatCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb15d8115(sender, button, x, y)
      if Ellohim.WriteBoolCheckbox.wordwrap == false then
          Ellohim.WriteBoolCheckbox.wordwrap = true
          gotoColor2(Ellohim.WriteBoolCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.WriteBoolCheckbox.wordwrap = false
          gotoColor2(Ellohim.WriteBoolCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb16d8115(sender, button, x, y)
      if Ellohim.ReadIntegerCheckbox.wordwrap == false then
          Ellohim.ReadIntegerCheckbox.wordwrap = true
          gotoColor2(Ellohim.ReadIntegerCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ReadIntegerCheckbox.wordwrap = false
          gotoColor2(Ellohim.ReadIntegerCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb17d8115(sender, button, x, y)
      if Ellohim.ReadFloatCheckbox.wordwrap == false then
          Ellohim.ReadFloatCheckbox.wordwrap = true
          gotoColor2(Ellohim.ReadFloatCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ReadFloatCheckbox.wordwrap = false
          gotoColor2(Ellohim.ReadFloatCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb18d8115(sender, button, x, y)
      if Ellohim.ReadBoolCheckbox.wordwrap == false then
          Ellohim.ReadBoolCheckbox.wordwrap = true
          gotoColor2(Ellohim.ReadBoolCheckbox, {113, 140, 236}, 20)
      else
          Ellohim.ReadBoolCheckbox.wordwrap = false
          gotoColor2(Ellohim.ReadBoolCheckbox, {30, 30, 30}, 20)
      end
  end
  
  function ceeditsdb_enter1d7307(sender)
      gotoColor1(Ellohim.GlobalVarPanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit1d7307(sender)
      gotoColor1(Ellohim.GlobalVarPanel, {15, 15, 15}, 15)
  end
  
  function ceeditsdb_enter2d7307(sender)
      gotoColor1(Ellohim.GlobalValueIndicatorPanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit2d7307(sender)
      gotoColor1(Ellohim.GlobalValueIndicatorPanel, {15, 15, 15}, 15)
  end
  
  function ceeditsdb_enter3d7307(sender)
      gotoColor1(Ellohim.GlobalValuePanel, {113, 140, 236}, 15)
  end
  
  function ceeditsdb_exit3d7307(sender)
      gotoColor1(Ellohim.GlobalValuePanel, {15, 15, 15}, 15)
  end
  
  function btnsdb_mousedown4d7307(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup4d7307(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function GiveAmmo(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function GiveAmmoColor(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function enterlbsdb7d7307()
      gotoColor1(Ellohim.VehicleListPanel, {113, 140, 236}, 15)
  end
  function exitlbsdb7d7307()
      gotoColor1(Ellohim.VehicleListPanel, {15, 15, 15}, 15)
  end
  
  function enterlbsdb8d7307()
      gotoColor1(Ellohim.lbpanelsdb8d7307, {113, 140, 236}, 15)
  end
  function exitlbsdb8d7307()
      gotoColor1(Ellohim.lbpanelsdb8d7307, {15, 15, 15}, 15)
  end
  
  function btnsdb_mousedown9d7307(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup9d7307(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  function enterlbsdb10d7307()
      gotoColor1(Ellohim.lbpanelsdb10d7307, {113, 140, 236}, 15)
  end
  function exitlbsdb10d7307()
      gotoColor1(Ellohim.lbpanelsdb10d7307, {15, 15, 15}, 15)
  end
  
  function cbmousedownsdb11d7307(sender, button, x, y)
      if Ellohim.cbboxsdb11d7307.wordwrap == false then
          Ellohim.cbboxsdb11d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb11d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb11d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb11d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb12d7307(sender, button, x, y)
      if Ellohim.cbboxsdb12d7307.wordwrap == false then
          Ellohim.cbboxsdb12d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb12d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb12d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb12d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb13d7307(sender, button, x, y)
      if Ellohim.cbboxsdb13d7307.wordwrap == false then
          Ellohim.cbboxsdb13d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb13d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb13d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb13d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb14d7307(sender, button, x, y)
      if Ellohim.cbboxsdb14d7307.wordwrap == false then
          Ellohim.cbboxsdb14d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb14d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb14d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb14d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb15d7307(sender, button, x, y)
      if Ellohim.cbboxsdb15d7307.wordwrap == false then
          Ellohim.cbboxsdb15d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb15d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb15d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb15d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb16d7307(sender, button, x, y)
      if Ellohim.cbboxsdb16d7307.wordwrap == false then
          Ellohim.cbboxsdb16d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb16d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb16d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb16d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb17d7307(sender, button, x, y)
      if Ellohim.cbboxsdb17d7307.wordwrap == false then
          Ellohim.cbboxsdb17d7307.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb17d7307, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb17d7307.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb17d7307, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb1d4009(sender, button, x, y)
      if Ellohim.cbboxsdb1d4009.wordwrap == false then
          Ellohim.cbboxsdb1d4009.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb1d4009, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb1d4009.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb1d4009, {30, 30, 30}, 20)
      end
  end
  
  function cbmousedownsdb2d4009(sender, button, x, y)
      if Ellohim.cbboxsdb2d4009.wordwrap == false then
          Ellohim.cbboxsdb2d4009.wordwrap = true
          gotoColor2(Ellohim.cbboxsdb2d4009, {113, 140, 236}, 20)
      else
          Ellohim.cbboxsdb2d4009.wordwrap = false
          gotoColor2(Ellohim.cbboxsdb2d4009, {30, 30, 30}, 20)
      end
  end
  
  function btnsdb_mousedown3d4009(sender, button, x, y)
      gotoColor1(sender, {113, 140, 236}, 20)
      sender.font.color = "0x" .. rgbToHex({113, 140, 236})
  end
  
  function btnsdb_mouseup3d4009(sender, button, x, y)
      gotoColor1(sender, {15, 15, 15}, 20)
      sender.font.color = "0x" .. rgbToHex({192, 192, 192})
  end
  
  
  function btnsdb_mousedown1d7602(sender,button,x,y)
           gotoColor1(sender,{113,140,236},20)
           sender.font.color = "0x"..rgbToHex({113,140,236})
  end
  
  function btnsdb_mouseup1d7602(sender,button,x,y)
           gotoColor1(sender,{15,15,15},20)
           sender.font.color = "0x"..rgbToHex({192,192,192})
  end
  
  function ceeditsdb_enter1d9899(sender)
           gotoColor1(Ellohim.editpanelsdb1d9899,{113,140,236},15)
  end
  
  function ceeditsdb_exit1d9899(sender)
           gotoColor1(Ellohim.editpanelsdb1d9899,{15,15,15},15)
  end
  
  function btnsdb_mousedown2d9899(sender,button,x,y)
           gotoColor1(sender,{113,140,236},20)
           sender.font.color = "0x"..rgbToHex({113,140,236})
  end
  
  function btnsdb_mouseup2d9899(sender,button,x,y)
           gotoColor1(sender,{15,15,15},20)
           sender.font.color = "0x"..rgbToHex({192,192,192})
  end
  
  
  
  