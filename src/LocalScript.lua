require("PatternScanner")
require("MemoryController")

function GetLocalScript(Name)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return p+0xB0 end
        ::continue::
    end
    return false
end

function GetLocalScriptFromHash(ScriptHash)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptHash = get.Int(p+0xB0), get.Int(p+0xC)
        if LocalScriptHash==nil then goto continue
        elseif LocalScriptHash == ScriptHash and LocalScriptPointer ~= 0 then return p+0xB0 end
        ::continue::
    end
    return false
end

function GetLocalScriptStackSize(LocalScriptName)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return get.Int(p+0x58) end
        ::continue::
    end
    return false
end

function InstructionPointer(LocalScriptName)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return get.Int(p+0x14) end
        ::continue::
    end
    return false
end

function FramePointer(LocalScriptName)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return get.Int(p+0x18) end
        ::continue::
    end
    return false
end

function StackPointer(LocalScriptName)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return get.Int(p+0x1C) end
        ::continue::
    end
    return false
end

function ScriptState(LocalScriptName)
    local a=getAddress('LocalScriptsPTR')
    for i=0,52,1 do
        local p = get.Ptr(get.Ptr(a)+(i*0x8))
        local LocalScriptPointer, LocalScriptName = get.Int(p+0xB0), get.String(p+0xD0)
        if LocalScriptName==nil then goto continue
        elseif LocalScriptName == Name and LocalScriptPointer ~= 0 then return get.Int(p+0x10) end
        ::continue::
    end
    return false
end
Local = 
{

LocalScript = function(Index,ScriptName) return readQword(getAddress(ScriptName))+(8*Index) end,
GetLocal = function(ScriptName,Index) return readInteger(Local.LocalScript(ScriptName,Index)) end,
SetLocal = function(ScriptName,Index,Value) writeInteger(Local.LocalScript(ScriptName,Index),Value) end,


}



Cayo={}
function Cayo.LA(Index) return readQword(getAddress('fm_mission_controller_2020_ptr'))+(8*Index) end
function Cayo.GL(Index) return readInteger(Cayo.LA(Index)) end
function Cayo.SL(Index,Value) writeInteger(Cayo.LA(Index),Value) end

-- Casino
LWP={} -- Lucky Wheel
    function LWP.LA(Index) return readQword(getAddress('casino_lucky_wheel_ptr'))+(8*Index) end
    function LWP.GL(Index) return readInteger(LWP.LA(Index))end
    function LWP.SL(Index,Value) writeInteger(LWP.LA(Index),Value)end

    CBJ={} -- Casino Blackjack
    function CBJ.LA(Index) return readQword(getAddress('blackjack_ptr'))+(8*Index) end
    function CBJ.GL(Index) return readInteger(CBJ.LA(Index)) end
    function CBJ.SL(Index,Value) writeInteger(CBJ.LA(Index),Value) end

    function CBJ.Blackjack()
        local l_address=GetLocalScript("blackjack")
        if not l_address then print("No Local Address found for blackjack") return end
        unregisterSymbol('blackjack_ptr') registerSymbol('blackjack_ptr',l_address,true)
        local current_table=CBJ.GL(1776+1+(PLAYER_ID()*8)+4)
        local i=116+1+1+(current_table*211)
        CBJ.SL(i+1,40) CBJ.SL(2036,40)  -- 1st Card (Your Card)
        CBJ.SL(i+3,52) CBJ.SL(2038,52)  -- 3rd Card (Your Card)
    end
CHP={} -- CasinoHeistPlanning
    function CHP.LA(Index) return readQword(getAddress('gb_casino_heist_planning_ptr'))+(8*Index) end
    function CHP.GL(Index) return readInteger(CHP.LA(Index)) end --// get local
    function CHP.SL(Index,Value) writeInteger(CHP.LA(Index),Value) end --// set local

CST={} -- Casino Slots
    function CST.LA(Index) return readQword(getAddress('casino_slots_ptr'))+(8*Index) end
    function CST.GL(Index) return readInteger(CST.LA(Index))end
    function CST.SL(Index,Value) writeInteger(CST.LA(Index),Value)end

    function CST.Set_Jackpot_On_All_Slots(ID) --// ID 0-7 need only to be set once
        local l_address=GetLocalScript('casino_slots')
        if not l_address then return end
        unregisterSymbol('casino_slots_ptr') registerSymbol('casino_slots_ptr',l_address,true)
        for f=0,2,1 do
            for i=0,63,1 do CST.SL(1354+1+1+(f*65)+1+i,ID)end
        end
    end
CH={} -- CasinoHeist
    function CH.LA(Index) return readQword(getAddress('gb_casino_heist_ptr'))+(8*Index) end
    function CH.GL(Index) return readInteger(CH.LA(Index)) end --// get local
    function CH.SL(Index,Value) writeInteger(CH.LA(Index),Value) end --// set local

CRT={} -- CasinoRoulette
    function CRT.LA(Index) return readQword(getAddress('casinoroulette_ptr'))+(8*Index) end
    function CRT.GL(Index) return readInteger(CRT.LA(Index)) end --// get local
    function CRT.SL(Index,Value) writeInteger(CRT.LA(Index),Value) end --// set local

    CTCP={} -- Casino Three Card Poker
    function CTCP.LA(Index) return readQword(getAddress('three_card_poker_ptr'))+(8*Index) end
    function CTCP.GL(Index) return readInteger(CTCP.LA(Index)) end
    function CTCP.SL(Index,Value) writeInteger(CTCP.LA(Index),Value) end

function CTCP.Straight_Flush()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,50) CTCP.SL(1846,50)  -- 1st Card
    CTCP.SL(i+2,51) CTCP.SL(1847,51)  -- 2nd Card
    CTCP.SL(i+3,52) CTCP.SL(1848,52)  -- 3rd Card
end
function CTCP.Three_of_a_Kind()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,23) CTCP.SL(1846,23)  -- 1st Card
    CTCP.SL(i+2,36) CTCP.SL(1847,36)  -- 2nd Card
    CTCP.SL(i+3,49) CTCP.SL(1848,49)  -- 3rd Card
end
function CTCP.Straight()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,21) CTCP.SL(1846,21)  -- 1st Card
    CTCP.SL(i+2,35) CTCP.SL(1847,35)  -- 2nd Card
    CTCP.SL(i+3,49) CTCP.SL(1848,49)  -- 3rd Card
end
function CTCP.Flush()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,40) CTCP.SL(1846,40)  -- 1st Card
    CTCP.SL(i+2,48) CTCP.SL(1847,48)  -- 2nd Card
    CTCP.SL(i+3,51) CTCP.SL(1848,51)  -- 3rd Card
end
function CTCP.Pair()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,27) CTCP.SL(1846,27)  -- 1st Card
    CTCP.SL(i+2,40) CTCP.SL(1847,40)  -- 2nd Card
    CTCP.SL(i+3,52) CTCP.SL(1848,52)  -- 3rd Card
end
function CTCP.High_Card()
    local current_table=CTCP.GL(755+1+(PLAYER_ID()*9)+2)
    local i=122+168+1+(current_table*55)+2
    CTCP.SL(i+1,30) CTCP.SL(1846,30)  -- 1st Card
    CTCP.SL(i+2,51) CTCP.SL(1847,51)  -- 2nd Card
    CTCP.SL(i+3,40) CTCP.SL(1848,40)  -- 3rd Card
end


--[[l_perico = function()
    local l_address=GetLocalScript("fm_mission_controller_2020")
    if not l_address then  return end
    unregisterSymbol('fm_mission_controller_2020_ptr') registerSymbol('fm_mission_controller_2020_ptr',l_address,true)
  end,
  
  l_roulette = function ()
      local l_address=GetLocalScript("casinoroulette")
      if not l_address then return end
      unregisterSymbol('casinoroulette_ptr') registerSymbol('casinoroulette_ptr',l_address,true)
  end,
  
  l_three_card = function ()
      local l_address=GetLocalScript("three_card_poker")
      if not l_address then return end
      unregisterSymbol('three_card_poker_ptr') registerSymbol('three_card_poker_ptr',l_address,true)
  end,
  
  l_rig_slot = function ()
      local l_address=GetLocalScript('casino_slots')
      if not l_address then return end
      unregisterSymbol('casino_slots_ptr') registerSymbol('casino_slots_ptr',l_address,true)
  end,
  
  l_black_jack = function ()
      local l_address=GetLocalScript("blackjack")
      if not l_address then  return end
      unregisterSymbol('blackjack_ptr') registerSymbol('blackjack_ptr',l_address,true)
  end,
  
  
  l_lucky_wheel = function ()
      local l_address=GetLocalScript("casino_lucky_wheel")
      if not l_address then  return end
      unregisterSymbol('casino_lucky_wheel_ptr') registerSymbol('casino_lucky_wheel_ptr',l_address,true)
  end,
  
  l_freemode = function ()
      local l_address=GetLocalScript("freemode")
      if not l_address then  return end
      unregisterSymbol('freemode_ptr') registerSymbol('freemode_ptr',l_address,true)
  end,
  
  l_mission = function()
    local l_address=GetLocalScript("fm_mission_controller")
    if not l_address then  return end
    unregisterSymbol('fm_mission_controller_ptr') registerSymbol('fm_mission_controller_ptr',l_address,true)
  end,
  
  l_selector = function()
    local l_address=GetLocalScript("selector")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('selector_ptr') registerSymbol('selector_ptr',l_address,true)
  end,
  
  l_social_controller = function()
    local l_address=GetLocalScript("social_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('social_controller_ptr') registerSymbol('social_controller_ptr',l_address,true)
  end,
  
  l_stats_controller = function()
    local l_address=GetLocalScript("stats_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('stats_controller_ptr') registerSymbol('stats_controller_ptr',l_address,true)
  end,
  
  l_achievment_controller = function()
    local l_address=GetLocalScript("achievment_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('achievment_controller_ptr') registerSymbol('achievment_controller_ptr',l_address,true)
  end,
  
  l_shop_controller = function()
    local l_address=GetLocalScript("shop_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('shop_controller_ptr') registerSymbol('shop_controller_ptr',l_address,true)
  end,
  
  l_code_controller = function()
    local l_address=GetLocalScript("code_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('code_controller_ptr') registerSymbol('code_controller_ptr',l_address,true)
  end,
  
  
  l_building_controller = function()
    local l_address=GetLocalScript("building_controller")
    if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
    else Protection_RunningStatus.Caption = 'Running' end
    unregisterSymbol('building_controller_ptr') registerSymbol('building_controller_ptr',l_address,true)
  end,
  
  l_am_mp_bunker = function()
      local l_address=GetLocalScript("am_mp_bunker")
      if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
      else Protection_RunningStatus.Caption = 'Running' end
      unregisterSymbol('am_mp_bunker_ptr') registerSymbol('am_mp_bunker_ptr',l_address,true)
    end,
  
  l_gb_contraband_sell = function()
  local l_address=GetLocalScript("gb_contraband_sell")
  if not l_address then Protection_RunningStatus.Caption = 'Not Running' return 
  else Protection_RunningStatus.Caption = 'Running' end
  unregisterSymbol('gb_contraband_sell_ptr') registerSymbol('gb_contraband_sell_ptr',l_address,true)
  end,
  
  ]]  