require("unlocker_array")
require("pickup_array")
require("block_phone_array")
require("prop_array")
require("AssemblyData")
require("ArrayData")
require("mobil")
require("EXP_TABLE")
require("PatternScanner")
require("FunctionController")
require("MemoryController")
require("StatController")
require("LocalScript")
require("CoordinatesStructure")
require("protection")
require("setting")
require("script_editor")
require("admin_command")
require("ObjectController")
require("Assembly")
require("ExternalEditor")
json = require("dkjson")
enum = require("enum")
local timer = require("Timer")


SetWindowName('Ellohim')
LIST_DATA = {0x84, 0x34, 0x44, 0x1C8+0x189, 0x1C8+0x280, 0x1C8+0x14E0,0x1C8+0xE52, 0x1C8+0x10C8+0x868}

function LocalLoads()
  local ScriptLoader = function()
    FORM.ADD_LOOP(MainTab.CheckListBox2,CT2,2); --Player.CheckListBox2.Checked[2] = true
    FORM.ADD_LOOP(MainTab.CheatMenu,CT,2);
    FORM.ADD_LOOP_2(VehicleTab.VehicleChanger,tbl_Vehicles,1,"Vehicle Changer");
    FORM.ADD_LOOP(MainTab.CEListBox1,CT3,1);
    FORM.ADD_LOOP(VehicleTab.LSC,tbl_Vehicles,1);
    FORM.ADD_LOOP(PlaylistTab.InstantRID,DATA_RID,1);
    FORM.ADD_LOOP(VehicleTab.Handling,handling_data,1);
    FORM.ADD_LOOP(PlaylistTab.VehList,tbl_Vehicles,1);
    FORM.ADD_LOOP(VehicleTab.SpawnPrimColour,tbl_Colors,1);
    FORM.ADD_STD(VehicleTab.S_WheelType,tbl_WheelType);
    FORM.ADD_LOOP(VehicleTab.WheelDesign,tbl_BennysDesign,1);
    FORM.ADD_LOCAL(StatTab.LocalScriptNames,LocalScriptList,"Local Script");
    EventLoader()
  end
  ExecuteThread(ScriptLoader)
end

LocalLoads()

function LoadRID()
  local LoadRIDList = async(function()
    FORM.ADD_LOOP(PlaylistTab.InstantRID,DATA_RID,1);
  end)
  LoadRIDList()
  task_schedule_all()
end

function DropVehicleList(sender)
  local LoadVehicleList = async(function()
    FORM.ADD_LOOP(PlaylistTab.VehList,tbl_Vehicles,1);
  end)
  LoadVehicleList()
  task_schedule_all()
end

function IsStoryMode()
  return get.Int(JOIN_STATUS) == 0 or get.Int(JOIN_STATUS) == 10 and SCRIPT.DOES_SCRIPT_EXIST('freemode') == false 
end

function LocalScripLoad()
  local LoadAllScript = async(function()
    FORM.ADD_LOCAL(Protection.LocalScriptNames,LocalScriptList,"Local Script");
  end)
  LoadAllScript()
  task_schedule_all()
end
-----------------------------------------------------JSON LIBRARY--------------------------------------------------------
--dofile([[config/setting.lua]]);
------------------------Other------------------------------------------------------------------------------------------------------------------------
function ShowMenuWhenLoaded()
  if IsStoryMode() then
    ShowNotification([[Menu Has Been Loaded To The Game 
Press Insert To Show or Hide Menu

-Signed Ellohim]], 10000)
  CompactMode(true)
  else
    CompactMode(true)
    NotificationPopUpMapRockstar("Ellohim",[[~a~~s~ ~s~Menu Telah Terhubung Dengan Game!]])
    ptr_string()
    Ptr_class()
  end
    local new = AsyncBegin(function()
      local Tampil = 10
      for i = Tampil,0,-1 do
        print(i)
        Wait()
        if i == 7 then 
          InfiniteLoop()
          print("Unlimited Loop Executed")
        end
        if i == 0 then 
          Notification.destroy() 
          ptr_string()
          Ptr_class()
          InfiniteLoop()
          if messageDialog("You Will Be Automatically Set Into Online Session",mtWarning, mbYes, mbNo) == mrYes then
            LoadSession(11)
          else
            showMessage("Press Insert To Open Menu and Set Session to Online, Thanks")
          end
          return caFree
        end
      end
    end)
    AsyncEnd(new,1000)
  end
ShowMenuWhenLoaded()
--------------------------------------------Timer Disabler-------------------------------------------------------------
function CheckForUpdate()
  if get.Int(CPlayerInfo) == nil or get.Int("GTA5.exe+24E5C20") == nil then
    showMessage("Pointer Outdated! Please,Update your Mod Application!")
  end
end
------------------------------------------------TAB CONTROLLER---------------------------------------------------------
function HideConsole(sender)
  DebugController.hide()
end

function DebugConsoleDrag(sender, button, x, y)
  DebugController.dragNow()
end

function VehicleOptionToMainMenu(sender)
  id_tab_control = 1
  Player.show()
  ptr_string()
  Ptr_class()
  VehOp.hide()
end

function VehicleOptionToPlayerList(sender)
  id_tab_control = 2
  VSpawn.show()
  VehOp.hide()
end

function VehicleOptionToStatEditor(sender)
  id_tab_control = 4
  Protection.show()
  VehOp.hide()
end

function MainMenuToVehicleOption(sender)
  id_tab_control = 3
  VehOp.show()
  Player.hide()
end

function MainMenuToStatEditor(sender)
  id_tab_control = 4
  Protection.show()
  Player.hide()
end


function PlayerListToMain()
  id_tab_control = 1
  Player.show()
  VSpawn.hide()
  Protection.hide()
  VehOp.hide()
end

function MainMenuToPlayerList(sender)
  id_tab_control = 2
  VSpawn.show()
  Player.hide()
  Protection.hide()
  VehOp.hide()
end

function Protection_CEButton4Click(sender)
  Protection.hide()
end

function StatEditorToMain()
  id_tab_control = 1
  Player.show()
  Protection.hide()
  VehOp.hide()
  VSpawn.hide()
end

function StatEditorToVehicleOption()
  id_tab_control = 3
  Player.hide()
  Protection.hide()
  VehOp.show()
  VSpawn.hide()
end

function StatEditorToPlayerList()
  id_tab_control = 2
  Player.hide()
  Protection.hide()
  VehOp.hide()
  VSpawn.show()
end

function MainMenuToIndicator(sender)
  id_tab_control = 5
  PlayerData.show()
  Player.hide()
end

function PlayerListToIndicator()
  id_tab_control = 5
  PlayerData.show()
  VSpawn.hide()
end

function VehicleOptionToIndicator(sender)
  id_tab_control = 5
  PlayerData.show()
  VehOp.hide()
end

function StatEditorToIndicator()
  id_tab_control = 5
  PlayerData.show()
  Protection.hide()
end

function PlayerListToStatEditor()
  id_tab_control = 4
  Protection.show()
  Player.hide()
  VehOp.hide()
  VSpawn.hide()
end

function PlayerListToVehicleOption(sender)
  id_tab_control = 3
  VehOp.show()
  Protection.hide()
  Player.hide()
  VSpawn.hide()
end


function GoToStruct()
  id_tab_control = 6
  Struct.show()
  Player.hide()
end

function GoToIndicator()
  id_tab_control = 5
  PlayerData.show()
  Struct.hide()
end

function GoToStatEditor()
  id_tab_control = 4
  Protection.show()
  Struct.hide()
end

function GoToVehicle()
  id_tab_control = 3
  VehOp.show()
  Struct.hide()
end

function GoToPlayerList()
  id_tab_control = 2
  VSpawn.show()
  Struct.hide()
end

function GoToMainMenu()
  id_tab_control = 1
  Player.show() 
  Struct.hide()
end

function SEToStruct()
  id_tab_control = 6
  Struct.show()
  Protection.hide()
end

function VehOpToStuct()
  id_tab_control = 6
  Struct.show()
  VehOp.hide()
end

function VSpawnToStruct()
  id_tab_control = 6
  Struct.show()
  VSpawn.hide()
end

function PlayerDataToMain()
  id_tab_control = 1
  Player.show()
  PlayerData.hide()
end

function PlayerDataToVeh()
  id_tab_control = 3
  VehOp.show()
  PlayerData.hide()
end

function PlayerDataToPlayerlist()
  id_tab_control = 2
  VSpawn.show()
  PlayerData.hide()
end

function PlayerDataToStatEditor()
  id_tab_control = 4
  Protection.show()
  PlayerData.hide()
end

function PlayerDataToMisc()--VehOp.
  id_tab_control = 6
  Struct.show()
  PlayerData.hide()
end

function MenuOpen(Execution)
  local Trigger = Execution
  Ptr_class()
  EXP_TABLE()
  MP_Auto()
  CPH_Arr()
  Unlocker_arr()
  CH_Arr()
  ptr_string()
  if Trigger == true then
    switch(id_tab_control,
    {
      [1] = function()
        MainTab.show()
      end,
      [2] = function()
        PlaylistTab.show()
      end,
      [3] = function()
        VehicleTab.show()
      end,
      [4] = function()
        StatTab.show()
      end,
      [5] = function()
        PlayerData.show()
      end,
      [6] = function()
        MiscTab.show()
      end,
      ['default'] = function()
        MainTab.show()
      end,
    })
  elseif Trigger == false then
    switch(id_tab_control,
    {
      [1] = function()
        MainTab.hide()
      end,
      [2] = function()
        PlaylistTab.hide()
      end,
      [3] = function()
        VehicleTab.hide()
      end,
      [4] = function()
        StatTab.hide()
      end,
      [5] = function()
        PlayerData.hide()
      end,
      [6] = function()
        MiscTab.hide()
      end,
      ['default'] = function()
        MainTab.hide()
      end,
    })
  end
end

function TabPosition()
  switch(id_tab_control,
    {
      [1] = function()
        PlaylistTab.Top = MainTab.Top
        VehicleTab.Top = MainTab.Top
        StatTab.Top = MainTab.Top
        PlayerData.Top = MainTab.Top
        MiscTab.Top = MainTab.Top

        PlaylistTab.Left = MainTab.Left
        VehicleTab.Left = MainTab.Left
        StatTab.Left = MainTab.Left
        PlayerData.Left = MainTab.Left
        MiscTab.Left = MainTab.Left
      end,
      [2] = function()
        MainTab.Top = PlaylistTab.Top
        VehicleTab.Top = PlaylistTab.Top
        StatTab.Top = PlaylistTab.Top
        PlayerData.Top = PlaylistTab.Top
        MiscTab.Top = PlaylistTab.Top

        MainTab.Left = PlaylistTab.Left
        VehicleTab.Left = PlaylistTab.Left
        StatTab.Left = PlaylistTab.Left
        PlayerData.Left = PlaylistTab.Left
        MiscTab.Left = PlaylistTab.Left
      end,
      [3] = function()
        MainTab.Top = VehicleTab.Top
        PlaylistTab.Top = VehicleTab.Top
        StatTab.Top = VehicleTab.Top
        PlayerData.Top = VehicleTab.Top
        MiscTab.Top = VehicleTab.Top

        MainTab.Left = VehicleTab.Left
        PlaylistTab.Left = VehicleTab.Left
        StatTab.Left = VehicleTab.Left
        PlayerData.Left = VehicleTab.Left
        MiscTab.Left = VehicleTab.Left
      end,
      [4] = function()
        MainTab.Top = StatTab.Top
        PlaylistTab.Top = StatTab.Top
        VehicleTab.Top = StatTab.Top
        PlayerData.Top = StatTab.Top
        MiscTab.Top = StatTab.Top

        MainTab.Left = StatTab.Left
        PlaylistTab.Left = StatTab.Left
        VehicleTab.Left = StatTab.Left
        PlayerData.Left = StatTab.Left
        MiscTab.Left = StatTab.Left
      end,
      [5] = function()
        MainTab.Top = PlayerData.Top
        PlaylistTab.Top = PlayerData.Top
        VehicleTab.Top = PlayerData.Top
        StatTab.Top = PlayerData.Top
        MiscTab.Top = PlayerData.Top

        MainTab.Left = PlayerData.Left
        PlaylistTab.Left = PlayerData.Left
        VehicleTab.Left = PlayerData.Left
        StatTab.Left = PlayerData.Left
        MiscTab.Left = PlayerData.Left
      end,
      [6] = function()
        MainTab.Top = MiscTab.Top
        PlaylistTab.Top = MiscTab.Top
        VehicleTab.Top = MiscTab.Top
        StatTab.Top = MiscTab.Top
        PlayerData.Top = MiscTab.Top

        MainTab.Left = MiscTab.Left
        PlaylistTab.Left = MiscTab.Left
        VehicleTab.Left = MiscTab.Left
        StatTab.Left = MiscTab.Left
        PlayerData.Left = MiscTab.Left
      end,
      ['default'] = function()
        PlaylistTab.Top = MainTab.Top
        VehicleTab.Top = MainTab.Top
        StatTab.Top = MainTab.Top
        PlayerData.Top = MainTab.Top
        MiscTab.Top = MainTab.Top

        PlaylistTab.Left = MainTab.Left
        VehicleTab.Left = MainTab.Left
        StatTab.Left = MainTab.Left
        PlayerData.Left = MainTab.Left
        MiscTab.Left = MainTab.Left
      end,
    })
end


THREAD.func_1(TabPosition,true,500)

-----------------------------------------------Structs----------------------------------------------------------------

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
    local VehicleCategoryID = VehicleTab.category
    local category_list = combobox_getItemIndex(VehicleTab.category) + 1;
    switch(C_LOAD[category_list],
    {
      ['Super'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,super,1,"Super Car")
      end,
    
      ['Sport'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,sport,1,"Sport")
      end,
    
      ['Sport Classic'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,sport_classic,1,"Sport Classic")
      end,
    
      ['Summer Update'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,summer_update,1,"Summer Update")
      end,
    
      ['Sedans'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,sedan,1,"Sedans")
      end,
    
      ['Service'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,service,1,"Services")
      end,
    
      ['SUVs'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,SUV,1,"SUVs")
      end,
    
      ['Planes'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,plane,1,"Planes")
      end,
    
      ['Helicopters'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,helicopter,1,"Helicopters")
      end,
    
      ['Off Road'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,off_road,1,"Planes")
      end,
    
      ['Muscles'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,muscle,1,"Muscles")
      end,
    
      ['Motorcycles'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,motorcycle,1,"Motorcycles")
      end,
    
      ['Military'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,military,1,"Military")
      end,
    
      ['Trailers'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,trailer,1,"Trailers")
      end,
    
      ['Trains'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,train,1,"Trains")
      end,
    
      ['Utility'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,utility,1,"Utility")
      end,
    
      ['Vans'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,van,1,"Vans")
      end,
    
      ['Arena Wars'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,arena_war,1,"Arena Wars")
      end,
    
      ['Casino Updates'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,casino1,1,"Casino Updates")
      end,
    
      ['Casino Heist'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,casino2,1,"Casino Heist")
      end,
    
      ['Emergency'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,emergency,1,"Emergency")
      end,
    
      ['Industrial'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,industrial,1,"Industrial")
      end,
    
      ['Coupes'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,coupes,1,"Coupes")
      end,
    
      ['Compacts'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,compact,1,"Compacts")
      end,
    
      ['Boats'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,c_boat,1,"Boats")
      end,
    
      ['Bikes'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,bikes,1,"Bikes")
      end,
    
      ['Commericals'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,commericals,1,"Commericals")
      end,
    
      ['Cayo Perico'] = function ()
        FORM.ADD_LOOP_2(VehicleTab.VehicleList,cayo_perico,1,"Cayo Perico")
      end,
    
      ['Personal Vehicle'] = function ()
        GetVehicleSlots()
        FORM.ADD_LOOP_3(VehicleTab.VehicleList,tbl_GSV,"Select Vehicle")
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
  local id2 = listbox_getItemIndex(VehicleListByCategory);
  local id = combobox_getItemIndex(VehicleSpawnerList);
  local id3 = VehicleTab.category.itemIndex + 1;
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
        set.global(int,2544210+965,tbl_GSV[id2][1])
        set.global(int,2540612+962,1)
        SYSTEM.WAIT(700)
        set.global(bool,2409299+8,true)
  end
end


    

------------------------------------------Vehicle Menu---------------------------------------------------------------------
function ExhaustSelect(sender)
  local id = VehicleTab.Exhaust.ItemIndex
  if id == nil then id = MAX_UINT end
  set.global(int,2462514+27+14,id)
end

function VentSelect(sender)
  local id = VehicleTab.Vent.ItemIndex
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
  local xenon_id = combobox_getItemIndex(VehicleTab.XenonSpawn) + 1;
  if xenon_id == nil then 
    set.global(int,2462514+27+32,255)
  else
    set.global(int,2462514+27+32,colour_id[xenon_id])
  end
end
spoiler_spawner = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ,11, 12, 13, 14, 15, 16, 17, 18
,19, 20, 21, 22}

function SpoilerSpawner()
  local spoiler_id = combobox_getItemIndex(VehicleTab.Spoiler) + 1;
  set.int(SPAWNER_SPOILER, spoiler_spawner[spoiler_id])
end

SESSION_ID = {1, 0, 10, 11, 2, 3, 12, 6, 9, -1, 13}

function SessionChanger()
  local session_id = combobox_getItemIndex(MainTab.Sessions) + 1;
  LoadSession(SESSION_ID[session_id])
  LuaEngineLog(string.format("Change Session To : ID[0x%X]",SESSION_ID[session_id]))
end

SEASON_ID = {1, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10 ,11, 12, 13, 14, -1}

function WeatherChanger()
  local weather_id = combobox_getItemIndex(MainTab.Cuaca) + 1;
  set.int(CUACA,SEASON_ID[weather_id])
  if index==14 then set.int(SALJU,1)
  elseif index==16 then set.int(SALJU,0)
  end
end

DATA_A = {
"DIAMOND", "GOLD", "ARTWORK", "CASH", "TAKE_ALL","TAKE_ALL_C","FLEECA", "PRISON_BREAK", "HUMANE_LAB", "A_SERIES",
"PASIFIC_STANDARD", "ACT_1", "ACT_2", "ACT_3","Panther","Madrazo_Files","Pink_DIAMOND","Bearer_Bonds",     
"Ruby","Tequila"
}
function PotentialAndTakeEditor()
  local id = combobox_getItemIndex(MainTab.PTAKE);
  set.int(DATA_A[id], tonumber(MainTab.Num.Text))
  LuaEngineLog(string.format("%s : %i",DATA_A[id],get.Int(DATA_A[id])))
  if SCRIPT.DOES_SCRIPT_EXIST('fm_mission_controller') then
    SetTimer.Enabled = SCRIPT.DOES_SCRIPT_EXIST('fm_mission_controller')
  elseif SCRIPT.DOES_SCRIPT_EXIST('fm_mission_controller_2020') then
    SetTimer.Enabled = SCRIPT.DOES_SCRIPT_EXIST('fm_mission_controller')
  else
    SetTimer.Enabled = false
  end
end
if SetTimer == nil then
  SetTimer = createTimer(nil, false)
  SetTimer.Interval = 100  --0.5 seconds
  SetTimer.setOnTimer(PotentialAndTakeEditor)
end

function SetPotentialToDefault()
  set.int(DIAMOND,3290000)
  set.int(GOLD,2585000)
  set.int(ARTWORK,2350000)
  set.int(CASH,2115000)
  set.int(FLEECA,115000)
  set.int(PRISON_BREAK,400000)
  set.int(HUMANE_LAB,540000)
  set.int(A_SERIES,404000)
  set.int(PASIFIC_STANDARD,1000000)
  set.int(ACT_1,650000)
  set.int(ACT_2,950000)
  set.int(ACT_3,1200000)
  set.int(Panther,1900000)
  set.int(Madrazo_Files,1100000)
  set.int(Pink_DIAMOND,1300000)
  set.int(Bearer_Bonds,1100000)
  set.int(Ruby,1000000)
  set.int(Tequila,900000)
  SetTimer.Enabled = false 
end 

function WantedLevelSlider(sender)
  PLAYER.SET_PLAYER_WANTED_LEVEL(sender.Position)
end

function WeaponSpawner()
  local Weapon_Hashes = combobox_getItemIndex(MainTab.Weapon) + 1;
  OBJECT.CREATE_AMBIENT_PICKUP(all_weapon_dropper[Weapon_Hashes][1],all_weapon_dropper[Weapon_Hashes][2],9999,PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],tonumber(PlaylistTab.Dist.Text),tonumber(PlaylistTab.Tinggi.Text))
end

function PrimaryWeapon(sender)
  local weapon_id = combobox_getItemIndex(VehicleTab.CEComboBox7);
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
  local weapon_id2 = combobox_getItemIndex(VehicleTab.CEComboBox8);
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

function AllHeistCutEditor()
  if SCRIPT.DOES_SCRIPT_EXIST('gb_casino_heist_planning') then
    set.int(CASINO_CUT_1,tonumber(MainTab.Persen.Text))
    set.int(CASINO_CUT_2,tonumber(MainTab.Cut2.Text))
    set.int(CASINO_CUT_3,tonumber(MainTab.Cut3.Text))
    set.int(CASINO_CUT_4,tonumber(MainTab.Cut4.Text))
  elseif SCRIPT.DOES_SCRIPT_EXIST('gb_gang_ops_planning') then
    set.int(DOOMSDAY_CUT_1,tonumber(MainTab.Persen.Text))
    set.int(DOOMSDAY_CUT_2,tonumber(MainTab.Cut2.Text))
    set.int(DOOMSDAY_CUT_3,tonumber(MainTab.Cut3.Text))
    set.int(DOOMSDAY_CUT_4,tonumber(MainTab.Cut4.Text))
  elseif SCRIPT.DOES_SCRIPT_EXIST('fmmc_launcher') then
    set.int(APT_CUT_1,tonumber(MainTab.Persen.Text))
    set.int(APT_CUT_2,tonumber(MainTab.Cut2.Text))
    set.int(APT_CUT_3,tonumber(MainTab.Cut3.Text))
    set.int(APT_CUT_4,tonumber(MainTab.Cut4.Text))
  elseif SCRIPT.DOES_SCRIPT_EXIST('heist_island_planning') then
    set.int(CPERICO_1,tonumber(MainTab.Persen.Text))
    set.int(CPERICO_2,tonumber(MainTab.Cut2.Text))
    set.int(CPERICO_3,tonumber(MainTab.Cut3.Text))
    set.int(CPERICO_4,tonumber(MainTab.Cut4.Text))
  end
end

SPAWNER_LIVERY = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
function LiverySpawner()
  local livery_id = combobox_getItemIndex(VehicleTab.Spawn_livery) + 1;
  set.int(SPW_LIVERY, SPAWNER_LIVERY[livery_id])
end

function Player_FormMouseDown(sender, button, x, y)
  Player.dragNow()
end

function Player_CEImage1MouseDown(sender, button, x, y)
  Player.dragNow()
end


function VSpawn_FormMouseDown(sender, button, x, y)
  VSpawn.dragNow()
end

function VSpawn_BGMouseDown(sender, button, x, y)
  VSpawn.dragNow()
end

function VehOp_FormMouseDown(sender, button, x, y)
  VehOp.dragNow()
end

function UDF1_FormMouseDown(sender, button, x, y)
  Protection.dragNow()
end

function VSpawn_ExitClick(sender)
  VSpawn.hide()
end

function Player_CEButton2Click(sender)
  Player.hide()
end

function VehOp_VehOPHideClick(sender)
  VehOp.hide()
end

function PlayerData_FormMouseDown(sender, button, x, y)
  PlayerData.dragNow()
end

function PlayerData_CEButton1Click(sender)
  PlayerData.hide()
end

function Player_FormActivate(sender)
  ptr_string()
  Ptr_class()
end

function Struct_FormMouseDown(sender, button, x, y)
  Struct.dragNow()
end

function Struct_Hide()
  Struct.hide()
end

function Protection_CEImage1MouseDown(sender, button, x, y)
  Protection.dragNow()
end


function PlayerData_CEImage1MouseDown(sender, button, x, y)
  PlayerData.dragNow()
end

list = {0x180, 0x188, 0x190, 0x198, 0x1A0, 0x1A8, 0x1B0, 0x1B8, 0x1C0, 0x1C8, 0x1D0, 0x1D8, 0x1E0, 0x1E8,
0x1F0, 0x1F8, 0x200, 0x208, 0x210, 0x218, 0x220, 0x228, 0x230, 0x238, 0x240, 0x248, 0x250, 0x258, 0x260,
0x268, 0x270}

function GlobalReader()
  local id = combobox_getItemIndex(StatTab.GlobalType);
  Protection_GlobalRead.Text = ReadMem(Global_Type[id])
end

function LocalReader()
  local id = combobox_getItemIndex(StatTab.LocalType);
  Protection_ReadLocal.Text = ReadMem(Local_Type[id])
end

function MemoryReader()
  local id = combobox_getItemIndex(MiscTab.AddressType);
  Struct_ReadAddress.Text = ReadMem(TypeOfAddress[id])
end

function ProcessCheck2()
  if get.Int("WorldPTR")==nil or get.Global(int,262145) == nil then 
    closeCE() 
    Process = false
    return caFree
  end
end

function returningValue()
  if Process == false then 
    writeBytes(tbl_SE[1],0x48)
    set.global(int,1391942+624,0) 
    set.global(int,1391942+625,0) 
    set.global(int,1391942+609,0)
    set.global(int,1391942+341,0)
    set.global(int,1391942+383,0)
    set.global(int,1391942+493,0)
    set.global(int,1391942+497,0)
    set.global(int,1391942+503,0)
    set.global(int,1391942+505,0)
    set.global(int,1391942+505,0)
    set.global(int,1391942+580,0)
    set.global(int,1391942+630,0)
    set.global(int,1391942+632,0)
    set.global(int,1391799+646,0)
    set.global(int,1391799+648,0)
    set.global(int,1391942+707,0)
    set.global(int,1391942+747,0)
    set.global(int,1391942+752,0)
    set.global(int,1391942+753,0)
    set.global(int,1391942+763,0)
    set.global(int,1391942+786,0)
    set.global(int,1391942+753,0)
    set.global(int,1391942+1276,0)
    set.global(int,1391942+606,0)
    set.global(int,1391942+547,0)
    set.global(int,1391942+584,0)
    set.global(int,1391942+64,0)
    set.global(int,1391942+722,0)
    set.global(int,1391942+596,0)
    set.global(int,1391942+649,0) 
  end
end

function ReportCheck()
  local sync = AsyncBegin(function()
    local Scanner = MainTab.PatternScan
    local c = 0
      for _ in pairs(ReportStat) do c = c + 1 end
      for k,v in pairs(ReportStat) do
        Wait()
        if k >= 1 and k <= 27 then
          cheating = STATS.STAT_GET_INT(v[1])
          SystemLog(string.format("%s : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_INT(v[1]),joaat(v[1])))
          LuaEngineLog(string.format("Stat : %s | Value : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_INT(v[1]),joaat(v[1])))
          Scanner.Text = string.format('%s : %s',v[1],cheating)
          if STATS.STAT_GET_INT(v[1]) >= v[2] then
            -- if messageDialog("You Got A Report By "..v[1],mtWarning, mbYes, mbNo) == mrYes then
            --   STATS.STAT_SET_INT(v[1],0)
            -- else
            --   messageDialog("Are You Sure Want Keep Your Report",mtWarning, mbYes, mbNo)
            -- end
          end
        elseif k >= 28 and k <= 29 then
          local floatStat = STATS.STAT_GET_FLOAT(v[1])
          Scanner.Text = string.format('%s : %s',v[1],floatStat)
          SystemLog(string.format("%s : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_FLOAT(v[1]),joaat(v[1])))
          LuaEngineLog(string.format("Stat : %s | Value : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_FLOAT(v[1]),joaat(v[1])))
        elseif k >= 30 and k <= 32 then
          local BoolStat = STATS.STAT_GET_BOOL(v[1]) 
          Scanner.Text = string.format('%s : %s',v[1],tostring(BoolStat))
          SystemLog(string.format("%s : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_BOOL(v[1]),joaat(v[1])))
          LuaEngineLog(string.format("Stat : %s | Value : %s [Hash : 0x%X]",v[1],STATS.STAT_GET_BOOL(v[1]),joaat(v[1])))
        end
      end
  end)
  AsyncEnd(sync,50)
end



  --[[local ListHP = get.Float(PListHP[index])
  local ListArmor = get.Float(PListArmor[index])
  local ListAmmo = get.Int(PCurAmmo[index])
  local ListExpl = get.Short(PExplo[index])]]
  return_tick = 0
  balik = true
  loop_stat = false
function PlayerCord()
  ZCoord = get.Float(WaypointZCoord)
  local ip1 = get.Byte(CPlayerInfo + 0x6C)
  local ip2 = get.Byte(CPlayerInfo + 0x6D)
  local ip3 = get.Byte(CPlayerInfo + 0x6E)
  local ip4 = get.Byte(CPlayerInfo + 0x6F)
  local ipl1 = get.Byte(CPlayerInfo + 0x74)
  local ipl2 = get.Byte(CPlayerInfo + 0x75)
  local ipl3 = get.Byte(CPlayerInfo + 0x76)
  local ipl4 = get.Byte(CPlayerInfo + 0x77)
  local pPosX = get.Float(target_x[selected_player])
  local pPosY = get.Float(target_y[selected_player])
  local pPosZ = get.Float(target_z[selected_player])

  local Session_Status = get.Global(int,2426097+PLAYER_ID()*443+1)
  MPX = get.Global(int,1312763)
  MPx = tostring('MP'..MPX..'_')
  local PlayerCash = get.Global(int,1590682+1+PLAYER_ID()*883+211+3)
  local PlayerTotalCash = get.Global(int,1590682+1+PLAYER_ID()*883+211+56)
  local PlayerLevel = get.Global(int,1590682+1+PLAYER_ID()*883+211+6)
  local Slots = get.Global(int,1312763)
  local PlayerPort = get.Short(PORT)
  local Banca = PlayerTotalCash - PlayerCash
  local player_pos_x = Player_CEEditX
  local player_pos_y = Player_CEEditY
  local player_pos_z = Player_CEEditZ
  local PlayerNickname = Player_NameChanger
  local CurrentPlayerLevel = Player_CEEdit3
  local CurrentVehicleNames = VehicleTab.VehicleName
  local PlayerIndicator1 = Player_CEEdit8
  local PlayerIndicator2 = Player_CEEdit6
  local PlayerCEONames = Player_CEEdit10
  local TotalPlayerInSession = VSpawn_Total
  local ReadStat = Protection_ReadStat
  local HashIndicator = Protection_HashIndicator
  local ValueStat = Protection_ReadValueStat
  local PlayerListCoordinates = VSpawn_PCoordinates
  local Label11  = Player_CEEdit9
  local TotalPlayer = NETWORK.NETWORK_GET_NUM_CONNECTED_PLAYERS()
  local PlayerJoin = NETWORK.NETWORK_GET_NUM_CONNECTED_PLAYERS()+1
  local Public = NETWORK.NETWORK_SESSION_IS_PRIVATE()
  local Opcodes = MemoryCheck("RIDTarget")
  local m_model_bypass = get.Short("GTA5.exe+0xA30206+8")
  local IsSessionStarted = (NETWORK.NETWORK_IS_SESSION_STARTED() == true and Session_Status ~= 4) and 'Connecting' or NETWORK.NETWORK_IS_SESSION_STARTED() == true and 'Connected' or 'Offline'
  _G.FloatOut = get.Global(float, 1590682 + 1 + PLAYER_ID() * 883 + 211 + 57)
  _G.IntOut = get.Global(int, 2551772 + 276) -- 2551544
  _G.BoolOut = MEMORY.IS_BIT_SET(1590682 + 1 + PLAYER_ID() * 883 + 211 + 49, 0)
  SelectedApproach = get.Global(int,1701669+1+PLAYER.PLAYER_ID()*68+22)
  TheGlobal = Protection_GlobalEditor.Text
  player_pos_x.Text = ENTITY.f_Round(get.Float("PLAYER_CORDX"),5)
  player_pos_y.Text = ENTITY.f_Round(get.Float("PLAYER_CORDY"),5)
  player_pos_z.Text = ENTITY.f_Round(get.Float("PLAYER_CORDZ"),5)
  PlayerNickname.TextHint = 'Name Changer'
  CurrentPlayerLevel.TextHint = 'Level Spoof'
  CurrentVehicleNames.Text = get.String("GTA5.exe+24ECC80")
  PlayerIndicator1.Text = string.format('CPU Core : %s | Session : %s | Bank : $ %s | MP%s | Level : %s',getCPUCount()
,IsSessionStarted,Banca,Slots,PlayerLevel)
  PlayerIndicator2.Text = string.format('IP : %s.%s.%s.%s:%s | IP LAN : %s.%s.%s.%s:%s | Bypass : 0x0%X | Cash : $ %s',ip4,ip3,ip2,ip1,PlayerPort,ipl4,ipl3,ipl2,ipl1,PlayerPort,m_model_bypass,get.Global(int,1590682+1+PLAYER_ID()*883+211+3))
  PlayerCEONames.Text = get.Global(str,1630317+1+PLAYER_ID()*595+11+104)
  TotalPlayerInSession.Text = string.format('Total Player : %s',TotalPlayer)
  MainTab.MemoryStatus.Text = string.format('RID Joiner : %s',tostring(Opcodes))
  local StatId = combobox_getItemIndex(StatTab.CEComboBox13) + 1;
  
  ReadStat.Text = StatId == 5 and get.Global(int,2551772+276) or StatId == 6 and get.Global(float, 1590682 + 1 + PLAYER_ID() * 883 + 211 + 57) or StatId == 7 and tostring(MEMORY.IS_BIT_SET(1590682 + 1 + PLAYER_ID() * 883 + 211 + 49, 0))
  
  local StatType = combobox_getItemIndex(StatTab.CEComboBox13) + 1;
  HashIndicator.Text = StatType == 2 and get.Global(int, 1388013 + 4) or StatType == 3 and get.Global(int, 2587374 + 1 + 98 * 3 + get.Global(int,1312763) + 1) or StatType == 4 and get.Global(int, 2588062 + 1 + 205 * 3 + get.Global(int, 1312763) + 1)or StatType == 5 and get.Global(int, 2552060 + 1 + 1089 * 3 + get.Global(int,1312763) + 1) or StatType == 6 and get.Global(int, 2587374 + 1 + 37 * 3 + get.Global(int,1312763) + 1) or StatType == 7 and get.Global(int, 2588062 + 1 + 130 * 3 + get.Global(int,1312763) + 1) or "null"
  
  StatTab.CEButton9.Caption = StatType == 2 and 'Set Integer' or StatType == 3 and 'Set Float' or StatType == 4 and 'Set Bool' or StatType == 5 and 'Get Int' or StatType == 6 and 'Get Float' or StatType == 7 and 'Get Bool' or StatType == 8 and 'Import int' or  StatType == 9 and 'Import Bool' or 'Set Stat'

  ValueStat.Text = get.Global(int,939452+5526)
  Player.DateAndTime.Text = os.date();

  if (pPosX ~= nil) and (pPosY ~= nil) and (pPosZ ~= nil) then
  PlayerListCoordinates.Text = string.format('X :%.5f  |  Y :%.5f  |  Z :%.5f ',pPosX,pPosY,pPosZ)
  end

  if TotalPlayer == TotalPlayer+1 then NotificationPopUpMapRockstar("Alert",[[~a~~s~Player Join Session]]) end

  MainTab.PlayerStatus.Text = Session_Status == 4 and string.format('Player Status : %s', 'Online')
  or Session_Status == 10 and string.format('Player Status : %s', 'Loading')
  or Session_Status == 0 and string.format('Player Status : %s','Offline')

  if (pPosX == nil) and (pPosY==nil) and (pPosZ==nil) then
    PlayerListCoordinates.Text = string.format('X :%s  |  Y :%s  |  Z :%s ','No Data','No Data','No Data')
  end

  if MainTab.Num.Text == 'MAX_INT' then MainTab.Num.Text = MAX_INT end
  if MainTab.MoneySpoof.Text == 'MAX_INT' then MainTab.MoneySpoof.Text = MAX_INT end
  if MainTab.Deliver2.Text == 'MAX_INT' then MainTab.Deliver2.Text = MAX_INT end
  CONVERTION = 'MAX_INT';
  if MAX_INT == 'MAX_INT' then MAX_INT = 2147483647 end
  if MainTab.MoneySpoof.Text == 'MAX_INT' then MainTab.MoneySpoof.Text = MAX_INT end
  MainTab.Transition.Text = NETWORK.NETWORK_IS_IN_TRANSITION() == true and 'In Transition' or 'Not In Transition'

  MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Unknown',Public)
  if GetCurrentSession() == 0 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Public',Public) 
  elseif GetCurrentSession() == 1 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','New Public',Public) 
  elseif GetCurrentSession() == 2 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Closed Crew Session',Public) 
  elseif GetCurrentSession() == 3 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Crew session',Public) 
  elseif GetCurrentSession() == 6 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Closed Friend Session',Public) 
  elseif GetCurrentSession() == 9 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Friend Session',Public) 
  elseif GetCurrentSession() == 10 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Solo Session',Public) 
  elseif GetCurrentSession() == 11 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Invited Session',Public) 
  elseif GetCurrentSession() == 12 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Join Crew Session',Public) 
  elseif GetCurrentSession() == 13 then MainTab.SessionID.Text = string.format('Session: %s| Private: %s','Spectator Box',Public) 
  end
  set.global(bool, 2440277 + 4110, true)
  return_tick = return_tick + 1
  local SetStatDefault = get.Global(int, 1388013 + 1 * 3 + 0 + 1)
  local DefaultStatBool = get.Global(int, 2588062 + 1 + 205 * 3 + get.Global(int, 1312763) + 1)
  local DefaultReadInt = get.Global(int, 2552060 + 1 + 1089 * 3 + get.Global(int, 1312763) + 1)

  if return_tick == 201 then return_tick = 0 end
  if not balik then
     if not loop_stat then
        StatTab.ImportView.Text = 'Applied : 1/1'
     end
  end
  if return_tick == 150 and not loop_stat then StatTab.ImportView.Text = 'Applied : 0/1' end
  if return_tick == 200 and balik and not loop_stat and SetStatDefault ~= joaat("MPPLY_AWD_FM_CR_MISSION_SCORE") then
     set.global(int, 1388013 + 1 * 3 + 0 + 1, joaat("MPPLY_AWD_FM_CR_MISSION_SCORE"))
  end
  if return_tick == 200 and balik and not loop_stat and DefaultStatBool ~= joaat("MP"..MPX.."_IS_VISOR_UP") then
     set.global(int, 2588062 + 1 + 205 * 3 + get.Global(int, 1312763) + 1, joaat("MP"..MPX.."_IS_VISOR_UP"))
  end
  if return_tick == 200 and balik and not loop_stat and DefaultReadInt ~= joaat("MP"..MPX.."_LAP_DANCED_BOUGHT") then
     set.global(int, 2552060 + 1 + 1089 * 3 + get.Global(int, 1312763) + 1,  joaat("MP"..MPX.."_LAP_DANCED_BOUGHT"))
  end
  if return_tick == 70 and balik and not loop_stat and DefaultFloat1 ~= 1047422498 then
    set.global(int,2587374 + 1 + 98 * 3 + 0 + 1, 1012561733)
  end
  if return_tick == 70 and balik and not loop_stat and DefaultFloat2 ~= 1047422498 then
     set.global(int, 2552060 + 1 + 1164 * 3 + get.Global(int, 1312763) + 1, 1047422498)
  end
  if return_tick == 70 and balik and not loop_stat and DefaultFloat3 ~= 1549279702 then
    set.global(int,2587374 + 1 + 98 * 3 + get.Global(int, 1312763) + 1, 1549279702)
  end


end
ReadTimer = createTimer(nil, true)
ReadTimer.Interval = 30  --0.5 seconds
ReadTimer.OnTimer = PlayerCord

function PlayerList()
  local indexing = VSpawn.CEListView1.Items
  indexing.Clear()
  for key,tabel in ipairs(CPLAYER_INDEX) do
    local GET_PLAYER_INDEX = indexing.Add()
    local host = get.Global(bool,1630317+1+(iVar0[key]*595)+10)
    local JoinStatus = get.Global(int,2426097+iVar0[key]*443+1)
    local PLG  = get.Bool(PLGod[key])
    local RID = get.Long(tabel[2])
    local SCID = tostring(RID)
    local NAME = get.String(tabel[1])
    local ID = tostring(NAME)
    local id = tostring("["..key.."]")
    local ped_id
    local id_param = PLAYER_ID() + 1
    --print(id_param.."/"..key)
    ped_id = key == id_param and "[S]" or ""
    if PLG == nil then PLG = 0 end
    PLG = (PLG == true and NAME ~= nil and PLG ~=nil) and "[G]" or ""
    host = host == true and NAME ~= nil and "[H]" or ""
    if JoinStatus == 0 and NAME ~= nil then 
      JoinStatus = "[T]" 
    elseif JoinStatus == 10 and NAME ~= nil then
      JoinStatus = "[T]"
    elseif JoinStatus == 4 and NAME ~= nil then
      JoinStatus = ""
    else
      JoinStatus = ""
    end
    if ID == "nil" then ID = "" elseif not NETWORK.NETWORK_IS_SESSION_STARTED() and ID == "nil" then ID = get.String(CPlayerInfo + 0xA4) end
    if not RID then SCID = "" end
    if not NAME then id = "" end
    GET_PLAYER_INDEX.Caption = string.format('%s%s%s%s%s%s',id,ID,host,PLG,ped_id,JoinStatus)
    GET_PLAYER_INDEX.SubItems.text = SCID
  end
end

function VSpawn_FormActivate(sender)
  PlayerList()
end

function VSpawn_FormDeactivate(sender)
  PlayerList()
end

function UpdatePlayerList(sender)
  PlayerList()
end

iVar0 = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32}
function Player_List_Info()
  local EntityState = VSpawn_PGod 
  local CurrentVehicles = VSpawn_PVehicle 
  local CurrentWeapon = VSpawn_PCWep
  local RadarState = VSpawn_PRadar
  local PlayerLevelState = VSpawn_PLevel 
  local IsNetworkHost = VSpawn_InfAmmo 
  local PlayerStaticIP = VSpawn_IPLan 
  local PlayerDynamicIP = VSpawn_IP 
  local PlayerMoney = VSpawn_PMoney
  local Player_Selected_Hacker = VSpawn_HeistHacker
  local Player_Selected_Target = VSpawn_HeistTarget
  local Player_Selected_Approach = VSpawn_HeistApproach
  local Player_Selected_Driver = VSpawn_HeistDriver
  local Player_Selected_Gunman = VSpawn_HeistGunman
  local Player_Board_Status = VSpawn_HeistBitset

  selected_approach = get.Global(int,1701669+1+iVar0[selected_player]*68+22)
  selected_target = get.Global(int,1701669+1+iVar0[selected_player]*68+18+7)
  selected_hacker = get.Global(int,1701669+1+iVar0[selected_player]*68+18+14)
  selected_driver = get.Global(int,1701669+1+iVar0[selected_player]*68+18+12)
  selected_gunman = get.Global(int,1701669+1+iVar0[selected_player]*68+18+10)
  board_status = get.Global(int,1701669+1+iVar0[selected_player]*68+18+1)
  security_pass = get.Global(int,1701669+1+iVar0[selected_player]*68+18+15)
  duggan_level = get.Global(int,1701669+1+iVar0[selected_player]*68+18+8)

  local IPR1 = get.Byte(IPs1[selected_player])
  local IPR2 = get.Byte(IPs2[selected_player])
  local IPR3 = get.Byte(IPs3[selected_player])
  local IPR4 = get.Byte(IPs4[selected_player])
  local IPRL1 = get.Byte(IPz1[selected_player])
  local IPRL2 = get.Byte(IPz2[selected_player])
  local IPRL3 = get.Byte(IPz3[selected_player])
  local IPRL4 = get.Byte(IPz4[selected_player])
  local PLG  = get.Byte(PLGod[selected_player])
  local PVG = get.Byte(PVehGod[selected_player])
  local host_id = get.Int("[GTA5.exe+028D6A50]+150")
  local ListInVeh = get.Bool(PInVeh[selected_player])
  local CurVeh= get.Int(PCurVeh[selected_player])
  local PPort  = get.Short(ListLPort[selected_player])
  local ListHost = get.Int(PHost[selected_player])
  local Pradars = get.Global(int,2425869+1+iVar0[selected_player]*443+204)
  local PReveal = get.Global(int,2425869+1+iVar0[selected_player]*443+207)
  local ListLevels = get.Global(int,1590682+1+iVar0[selected_player]*883+211+6)
  local ListTotalMoney = get.Global(int,1590682+1+iVar0[selected_player]*883+211+56)
  local ListCash = get.Global(int,1590682+1+iVar0[selected_player]*883+211+3)
  local ListOrgName = get.Global(str,1630317+1+(iVar0[selected_player]*595)+11+104)
  local CurWep = get.String(PCurWep[selected_player])
  local PTotalEXP = get.Global(int,1590682+1+iVar0[selected_player]*883+211+1)
  local PGlobalEXP = get.Global(int,1590682+1+iVar0[selected_player]*883+211+5)
  local ListWanted = get.Int(PWanted[selected_player])
  local IsHost = get.Global(bool,1630317+1+iVar0[selected_player]* 595+10)
  local ListBanked = ListTotalMoney - ListCash
  local HP = get.Float(PListHP[selected_player])
  local Armor = get.Float(PListArmor[selected_player])
  local Ragdoll = get.Byte(PRagdoll[selected_player])
  local SCID = get.Long(RID_LIST[selected_player])
  local biset0 = get.Global(int,1701669+1+iVar0[selected_player]*68+18)
  local Max_HP = get.Float(PLisMAXtHP[selected_player])
  local BunkerLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(5*12))
  local CurrentVehicle = get.String(PVehName[selected_player])
  local CurrentVehicleM = get.String(PVehMaker[selected_player])
  local PlayerName = get.String(CPLAYER_NAME[selected_player])
  local CurLevelStatus = TotalEXPIndex(selected_player)
  local KDRatio = get.Float(GA(1590682 + 1 + iVar0[selected_player] * 883 + 211 + 26))
  local TotalKill = get.Global(int,1590682+1+iVar0[selected_player]*883+211+28)
  local TotalDeath = get.Global(int,1590682+1+iVar0[selected_player]*883+211+29)
  local RaceWon = get.Global(int,1590682+1+iVar0[selected_player]*883+211+15)
  local RaceLost = get.Global(int,1590682+1+iVar0[selected_player]*883+211+16)
  local DMWin = get.Global(int,1590682+1+iVar0[selected_player]*883+211+20)
  local DMlost = get.Global(int,1590682+1+iVar0[selected_player]*883+211+21)
  

  local JoinStatus = get.Global(int,2426097+iVar0[selected_player]*443+1)
  local TransitionStatus = get.Global(int,2426097+1+iVar0[selected_player]*443+198) --2425869
  local SecondaryLootPaint = get.Global(int,1706031+1+iVar0[selected_player]*53+10+23)
  local SecondaryLootCashI = get.Global(int,1706031+1+iVar0[selected_player]*53+10+10)
  local SecondaryLootWeed = get.Global(int,1706031+1+iVar0[selected_player]*53+10+11)
  local SecondaryLootCoke = get.Global(int,1706031+1+iVar0[selected_player]*53+10+12)
  local SecondaryLootGoldI = get.Global(int,1706031+1+iVar0[selected_player]*53+10+13)
  local SecondaryLootCashC = get.Global(int,1706031+1+iVar0[selected_player]*53+10+18)
  local SecondaryLootWeedC = get.Global(int,1706031+1+iVar0[selected_player]*53+10+19)
  local SecondaryLootCokeC = get.Global(int,1706031+1+iVar0[selected_player]*53+10+20)
  local SecondaryLootGoldC = get.Global(int,1706031+1+iVar0[selected_player]*53+10+21)
  local PrimaryLoot = get.Global(int,1706031+1+iVar0[selected_player]*53+10+4)
  local ValueLootCash = get.Global(int,1706031+1+iVar0[selected_player]*53+5+10+19)
  local ValueLootWeed = get.Global(int,1706031+1+iVar0[selected_player]*53+5+10+20)
  local ValueLootCoke = get.Global(int,1706031+1+iVar0[selected_player]*53+5+10+21)
  local ValueLootGold = get.Global(int,1706031+1+iVar0[selected_player]*53+5+10+22)
  local ValueLootPaint = get.Global(int,1706031+1+iVar0[selected_player]*53+5+10+23)
  local CayoWeapon = get.Global(int,1706031+1+iVar0[selected_player]*53+5+35)
  local Grapple = get.Global(int,1706031+1+(iVar0[selected_player]*53)+5+3)
  local Uniform = get.Global(int,1706031+1+(iVar0[selected_player]*53)+5+4)
  local Boltcut = get.Global(int,1706031+1+(iVar0[selected_player]*53)+5+5)
  local DisruptWep = get.Global(int,1706031+1+iVar0[selected_player]*53+10+1)
  local DisruptArm = get.Global(int,1706031+1+iVar0[selected_player]*53+10+2)
  local DisruptHel = get.Global(int,1706031+1+iVar0[selected_player]*53+10+3)
  local Entrance = get.Global(int,1706031+1+iVar0[selected_player]*53+5+2)
  local MissionStatus = get.Global(int,1706031+1+iVar0[selected_player]*53+2)
  local MissionProgress = get.Global(int,1706031+1+iVar0[selected_player]*53+1)
  local TotalPOI = get.Global(int,1706031+1+iVar0[selected_player]*53+5)
  local PrepPrimary = PrepWajib(selected_player)
  local PrepOptional = PrepOptional(selected_player)
  local PrimaryTarget = "NULL"
  local TotalLootCash = LootIsLandCash(selected_player)
  local TotalLootWeed = LootIsLandWeed(selected_player)
  local TotalLootCoke = LootIsLandCoke(selected_player)
  local TotalLootGold = LootIsLandGold(selected_player)
  local CompoundLootCash = LootCompoundCash(selected_player)
  local CompoundLootWeed = LootCompoundWeed(selected_player)
  local CompoundLootCoke = LootCompoundCoke(selected_player)
  local CompoundLootGold = LootCompoundGold(selected_player)
  local CompoundLootPaint = LootCompoundPaint(selected_player)
  local TotalValueCash = ValueLootCash * (TotalLootCash + CompoundLootCash)
  local TotalValueWeed = ValueLootWeed * (TotalLootWeed + CompoundLootWeed)
  local TotalValueCoke = ValueLootCoke * (TotalLootCoke + CompoundLootCoke)
  local TotalValueGold = ValueLootGold * (TotalLootGold + CompoundLootGold)
  local TotalValuePaint = ValueLootPaint * (CompoundLootPaint)
  local TotalSecondaryLoot = TotalValueCash + TotalValueWeed + TotalValueCoke + TotalValueGold + TotalValuePaint;
  IsCharSpectating(selected_player)
  local IsCharSpect = MEMORY.IS_BIT_SET(1590682 + 1 + iVar0[selected_player] * 883 + 211 + 49, 1)
  local TotalValueMain = "Null"
  local TotalPrepWajib = "Unknown"
  local TotalPrepOptional = "Unknown"

  if PrimaryLoot == 0 then TotalValueMain = "$900.000"
  elseif PrimaryLoot == 1 then TotalValueMain = "$1.000.000"
  elseif PrimaryLoot == 2 then TotalValueMain = "$1.100.000"
  elseif PrimaryLoot == 3 then TotalValueMain = "$1.300.000"
  elseif PrimaryLoot == 4 then TotalValueMain = "$1.100.000"
  elseif PrimaryLoot == 5 then TotalValueMain = "$1.900.000"
  end

  if MissionStatus == 65535 then
    MissionStatus = "ID ["..MissionStatus.."] Complete"
  else
    MissionStatus = "ID ["..MissionStatus.."] Incomplete"
  end

  if DisruptWep == 1 and DisruptArm == 1 and DisruptHel == 1 then
    DisruptWep,DisruptArm,DisruptHel = "Level 1","Level 1","Level 1"
  elseif DisruptWep == 2 and DisruptArm == 2 and DisruptHel == 2 then
    DisruptWep,DisruptArm,DisruptHel = "Level 2","Level 2","Level 2"
  elseif DisruptWep == 3 and DisruptArm == 3 and DisruptHel == 3 then
    DisruptWep,DisruptArm,DisruptHel = "Level 3","Level 3","Level 3"
  else
    DisruptWep,DisruptArm,DisruptHel = "None","None","None"
  end

  switch(CayoWeapon,{
    [0] = function()
      CayoWeapon = "Not Selected"
    end,
    [1] = function()
      CayoWeapon = "Aggressor"
    end,
    [2] = function()
      CayoWeapon = "Conspirator"
    end,
    [3] = function()
      CayoWeapon = "Crackshot"
    end,
    [4] = function()
      CayoWeapon = "Saboteur"
    end,
    [5] = function()
      CayoWeapon = "Marksman"
    end,
  })

  switch(PrimaryLoot,{
    [0] = function()
      PrimaryTarget = "Tequila"
    end,
    [1] = function()
      PrimaryTarget = "Ruby Necklace"
    end,
    [2] = function()
      PrimaryTarget = "Bearer Bonds"
    end,
    [3] = function()
      PrimaryTarget = "Pink Diamond"
    end,
    [4] = function()
      PrimaryTarget = "Madrazo Files"
    end,
    [5] = function()
      PrimaryTarget = "Sapphire Panther"
    end,
  })
  
  if CurrentVehicle == nil then
    CurrentVehicle = "Not In Vehicle"
  end
  if CurrentVehicleM == nil then
    CurrentVehicleM = "None"
  end
  local MethLocation,WeedLocation,CokeLocation,CashLocation,DocLocation = "No Data","No Data","No Data","No Data","No Data"
  for i=0,4,1 do
    for k,v in pairs(tbl_BusinessLocations) do
      for k2,v2 in pairs(v) do
        if get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==1 and v2[1]==1 then
          MethLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==6 and v2[1]==6 then
          MethLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==11 and v2[1]==11 then
          MethLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==16 and v2[1]==16 then
          MethLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==2 and v2[1]==2 then
          WeedLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==7 and v2[1]==7 then
          WeedLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==12 and v2[1]==12 then
          WeedLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==17 and v2[1]==17 then
          WeedLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==3 and v2[1]==3 then
          CokeLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==8 and v2[1]==8 then
          CokeLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==13 and v2[1]==13 then
          CokeLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==18 and v2[1]==18 then
          CokeLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==4 and v2[1]==4 then
          CashLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==9 and v2[1]==9 then
          CashLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==14 and v2[1]==14 then
          CashLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==19 and v2[1]==19 then
          CashLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==5 and v2[1]==5 then
          DocLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==10 and v2[1]==10 then
          DocLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==15 and v2[1]==15 then
          DocLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==20 and v2[1]==20 then
          DocLocation = "["..v2[1].."] "..v2[2]
        elseif get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(i*12))==0 and v2[1]==nil then
          MethLocation,WeedLocation,CokeLocation,CashLocation,DocLocation = "Not Have","Not Have","Not Have","Not Have","Not Have"
        end
      end
    end
  end

  if BunkerLocation == 23 then 
    BunkerLocation = "["..BunkerLocation.."]".." Route86"
  elseif BunkerLocation == 24 then
    BunkerLocation = "["..BunkerLocation.."]".." Farmhouse"
  elseif BunkerLocation == 25 then
    BunkerLocation = "["..BunkerLocation.."]".." Smoke Tree Road"
  elseif BunkerLocation == 26 then
    BunkerLocation = "["..BunkerLocation.."]".." Thomson Scrapyard"
  elseif BunkerLocation == 27 then
    BunkerLocation = "["..BunkerLocation.."]".." Grapeseed"
  elseif BunkerLocation == 28 then
    BunkerLocation = "["..BunkerLocation.."]".." Paleto Forest"
  elseif BunkerLocation == 29 then
    BunkerLocation = "["..BunkerLocation.."]".." Ranton Canyon"
  elseif BunkerLocation == 30 then
    BunkerLocation = "["..BunkerLocation.."]".." Lago Zancudo"
  elseif BunkerLocation == 31 then
    BunkerLocation = "["..BunkerLocation.."]".." Chumash"
  else 
    BunkerLocation = "["..BunkerLocation.."]".." No Data"
  end

  if board_status == MAX_UINT then board_status = string.format('ID[0x%X] Skip Prep',board_status) end
  if selected_approach == 1 and board_status == 127 then board_status = string.format('ID[0x%X] Complete',board_status)
  elseif selected_approach == 2 and board_status == 159 then board_status = string.format('ID[0x%X] Complete',board_status)
  elseif selected_approach == 3 and board_status == 799 then board_status = string.format('ID[0x%X] Complete',board_status)
  else board_status = string.format('ID[0x%X] Not Complete',board_status)
  end

  
  if biset0 == MAX_UINT then biset0 = 'Skip Prep' end
  if selected_approach == 1 and biset0 == 62 then biset0 = 'Complete'
  elseif selected_approach == 2 and biset0 == 339990 then biset0 = 'Complete'
  elseif selected_approach == 3 and biset0 == 3670038 then biset0 = 'Complete'
  else biset0 = 'Not Complete'
  end

  if selected_approach == 1 then 
    PrepPrimary = PrepPrimary
    TotalPrepWajib = 7 
    TotalPrepOptional = 7
  elseif selected_approach == 2 then
    PrepPrimary = PrepPrimary - 2
    PrepOptional = PrepOptional - 4
    TotalPrepWajib = 6 
    TotalPrepOptional = 15
  elseif selected_approach == 3 then
    PrepPrimary = PrepPrimary - 3
    PrepOptional = PrepOptional - 13
    TotalPrepWajib = 7
    TotalPrepOptional = 6
  end

  if selected_driver == 0 then
    selected_driver = 'No Driver'
  elseif selected_driver == 1 then
    selected_driver = 'Karim Denz'
  elseif selected_driver == 2 then
    selected_driver = 'Taliana'
  elseif selected_driver == 3 then
    selected_driver = 'Eddie Toh'
  elseif selected_driver == 4 then
    selected_driver = 'Zach'
  elseif selected_driver == 5 then
    selected_driver = 'Chester'
  end

  if selected_gunman == 0 then
    selected_gunman = 'No Gunman'
  elseif selected_gunman == 1 then
    selected_gunman = 'Karl Alboraji'
  elseif selected_gunman == 2 then
    selected_gunman = 'Gustavo'
  elseif selected_gunman == 3 then
    selected_gunman = 'Charlie'
  elseif selected_gunman == 4 then
    selected_gunman = 'Chester'
  elseif selected_gunman == 5 then
    selected_gunman = 'Packie'
  end

  if selected_hacker == 0 then
    selected_hacker = 'No Hacker'
  elseif selected_hacker == 1 then
    selected_hacker = 'Rickie Luckens'
  elseif selected_hacker == 2 then
    selected_hacker = 'Christian'
  elseif selected_hacker == 3 then
    selected_hacker = 'Yohan'
  elseif selected_hacker == 4 then
    selected_hacker = 'Avi Schwartzman'
  elseif selected_hacker == 5 then
    selected_hacker = 'Paige Harris'
  end

  if selected_target == 0 then
    selected_target = 'Cash'
  elseif selected_target == 1 then
    selected_target = 'Gold'
  elseif selected_target == 2 then
    selected_target = 'Art'
  elseif selected_target == 3 then
    selected_target = 'Diamond'
  end

  if selected_approach == 0 then 
    selected_approach = 'No Approach'
  elseif selected_approach == 1 then
    selected_approach = 'Silent'
  elseif selected_approach == 2 then
    selected_approach = 'Bigcon'
  elseif selected_approach == 3 then
    selected_approach = 'Aggressive'
  end

  if not IsHost then IsHost = 'No Data' end
  PlayerLevelState = PTotalEXP > PGlobalEXP and 'Level Mod' or 'Real Level'
  Pradars = (Pradars == 1) and 'On' or 'Off'
  PReveal = (PReveal == 1) and 'On' or 'Off'

  if (PLG == 0) and (PVG == 0) then PLG,PVG = 'False','False'
    elseif (PLG == 1) and (PVG == 0) then PLG,PVG = 'True','False'
    elseif (PLG == 0) and (PVG == 1) then PLG,PVG = 'False','True'
    elseif (PLG == 1) and (PVG == 1) then PLG,PVG = 'True','True'
    elseif (PLG == 1) and (PVG == nil) then PLG,PVG = 'True','Not In Vehicle'
    elseif (PLG == 0) and (PVG == nil) then PLG,PVG = 'False','Not In Vehicle'
    elseif (PLG == nil) and (PVG == nil) then PLG,PVG = 'No Data','Not In Vehicle'
    elseif (PLG == 9) and (PVG == 1) then PLG,PVG = 'True',"True"
    elseif (PLG == 8) and (PVG == 1) then PLG,PVG = 'Inside Building','Inside Building'
    elseif (PLG == 9) and (PVG == 0) then PLG,PVG = 'True',"False"
    elseif (PLG == 8) and (PVG == 0) then PLG,PVG = 'Inside Building','False'
    elseif (PLG == 9) and (PVG == nil) then PLG,PVG = 'True',"Not In Vehicle"
    elseif (PLG == 8) and (PVG == nil) then PLG,PVG = 'Inside Building','Not In Vehicle'
    else PLG,PVG = 'True','True'
  end

  --[[for _,v in pairs(tbl_Vehicles) do
    if joaat(v[1]) == CurVeh then 
      CurVeh = v[1]
    end 
  end]]
  if JoinStatus == 4 then JoinStatus = 'Joined Session'
  elseif JoinStatus == 10 then JoinStatus = 'Loading'
  elseif JoinStatus == 0 then JoinStatus = 'In Transition'
  else JoinStatus = 'Offline'
  end

  TransitionStatus = TransitionStatus == 1 and 'Not In Transition' or TransitionStatus == 0 and 'In Transition'
  if (CurVeh == nil) or (ListInVeh==0) then CurVeh = 'Player not In Vehicle' end
  if CurWep == nil then CurWep = 'No Data' end
  Ragdoll = Ragdoll == 32 and 'False' or 'True'  
  if not IPR4 then IPR4 = "0" end
  if not IPR3 then IPR3 = "0" end
  if not IPR2 then IPR2 = "0" end
  if not IPR1 then IPR1 = "0" end
  if not PPort then PPort = "0" end

  if not IPRL4 then IPRL4 = "0" end
  if not IPRL3 then IPRL3 = "0" end
  if not IPRL2 then IPRL2 = "0" end
  if not IPRL1 then IPRL1 = "0" end
  if not PPort then PPort = "0" end

  if not PlayerName then PlayerName = "0" end
  if not SCID then SCID = "0" end
  if not HP then HP = "0" end
  if not Max_HP then Max_HP = "0" end
  if not Armor then Armor = "0" end
  if not ListWanted then ListWanted = "0" end

  PlaylistTab.PlayerInfo.Lines.Text = string.format([[Dynamic IP : %s.%s.%s.%s:%s
IP Lan : %s.%s.%s.%s:%s
Nickname : %s
SCID : %s
Spectating : %s
Godmode : %s
Vehicle Godmode : %s
Join Status : %s
Transisition Status : %s
No Ragdoll : %s
Off Radar : %s
Reveal Player : %s
Vehicle : %s:%s
Weapon : %s
Level : %s
Bank : $%s
Cash : $%s
Organization : %s
Current EXP : %s
Global EXP : %s
Level Status : %s
EXP : %s
Host : %s
HP : %s/%s
Armor : %s/50
Wanted Level : %s
Total Kill : %s  Total Death : %s Ratio : %s
=========BUSINESS LOCATION=========
Bunker Location : ID %s
Meth Location : ID %s
Weed Location : ID %s
Cocain Location : ID %s
Cash Location : ID %s
Document Location : ID %s
=========CASINO HEIST STAT==========
Casino Heist Primary Prep : %s
Primary Prep : %s/%s
Optional Prep : %s/%s
Casino Heist Gunman : %s
Casino Heist Driver : %s
Casino Heist Hacker : %s
Casino Heist Approach :%s
Casino Heist Target : %s
Security Pass Level : %s
Disrupted Level : %s
Casino Heist Optional Prep : %s
=============Match Status===========
Race Won : %s
Race Lost : %s
Death Match Win : %s
Death Match Lost : %s
==========CAYO PERICO HEIST=========
Mission Status : %s
Mission Progress : %s
Point Of Interest : %s
Primary Target : %s
Cayo Perico Weapon :%s
Boltcut : %s
Grapple : %s
Uniform : %s
Entrance : %s
Cash Island ID:[0x%X]
Loot Cash : %s/24
Cash Compound ID:[0x%X]
Compound Cash : %s/8
Weed Island ID :[0x%X]
Loot Weed : %s/24
Weed Compound ID:[0x%X]
Compound Weed : %s/8
Coke Island ID:[0x%X]
Loot Coke : %s/24
Coke Compound ID:[0x%X]
Compound Coke : %s/8
Gold Island ID:[0x%X]
Loot Gold : %s/24
Gold Compound ID:[0x%X]
Compound  Gold : %s/8
Compound Paint ID:[0x%X]
Loot Paint : %s/8 
Value Cash : $%s
Value Weed : $%s
Value Coke : $%s
Value Gold : $%s
Value Paint : $%s
Total Main Target : %s
Total Secondary Target : $%d
]],IPR4,IPR3,IPR2,IPR1,PPort,IPRL4,IPRL3,IPRL2,IPRL1,PPort,PlayerName,SCID,IsCharSpect,PLG,PVG,JoinStatus,TransitionStatus,Ragdoll,Pradars,PReveal,CurrentVehicleM,CurrentVehicle,CurWep,ListLevels,ListBanked,ListCash,ListOrgName,
PTotalEXP,PGlobalEXP,PlayerLevelState,CurLevelStatus,IsHost,HP,Max_HP,Armor,ListWanted,TotalKill,TotalDeath,KDRatio,BunkerLocation,MethLocation,WeedLocation,CokeLocation,CashLocation,DocLocation,
board_status,PrepPrimary,TotalPrepWajib,PrepOptional,TotalPrepOptional,selected_gunman,selected_driver,
selected_hacker,selected_approach,selected_target,security_pass,duggan_level,biset0,RaceWon,RaceLost,DMWin,DMlost,
MissionStatus,MissionProgress,TotalPOI,PrimaryTarget,CayoWeapon,Boltcut,Grapple,Uniform,Entrance,SecondaryLootCashI,
TotalLootCash,SecondaryLootCashC,CompoundLootCash,SecondaryLootWeed,TotalLootWeed,SecondaryLootWeedC,CompoundLootWeed,SecondaryLootCoke,TotalLootCoke,SecondaryLootCokeC,CompoundLootCoke,
SecondaryLootGoldI,TotalLootGold,SecondaryLootGoldC,CompoundLootGold,SecondaryLootPaint,CompoundLootPaint,ValueLootCash,ValueLootWeed,ValueLootCoke,ValueLootGold,
ValueLootPaint,TotalValueMain,TotalSecondaryLoot)
end

function Playerlist_Manipulator(sender)
  selected_player = listview_getItemIndex(PlaylistTab.CEListView1) + 1;
  local IDHash = combobox_getItemIndex(PlaylistTab.WeaponToPlayer)
  local id2 = combobox_getItemIndex(PlaylistTab.VehList) + 1
  local idc = PlaylistTab.ActionToPlayer.ItemIndex
  local id_prop = combobox_getItemIndex(PlaylistTab.prop_changer);
  local Intervals = tonumber(PlaylistTab.IntervalValue.Text)
  local PlayerNicknames = get.String(CPLAYER_NAME[selected_player]) ~= nil and get.String(CPLAYER_NAME[selected_player]) or "null"
  if not PlayeNicknames then PlayeNicknames = "" end
  switch(idc,{
    [0] = function()
      Player_List_Info()
      LuaEngineLog(PlaylistTab.PlayerInfo.Lines.Text)
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Selected Index'.." ["..selected_player.."] Name : "..PlayerNicknames
    end;
    [1] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Teleport To '.." ["..selected_player.."] "..
      teleport_to_player(target_x[selected_player],target_y[selected_player],target_z[selected_player])
    end;
    [2] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X | Vehicle : 0x%X ",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player]),tbl_Vehicles[id2][2]))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Spawn Vehicle To '.." ["..selected_player.."] "..get.Int(VEH_HANDLER).." "..PlayerNicknames
      VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),target_x[selected_player],target_y[selected_player],target_z[selected_player],theading_x[selected_player],theading_y[selected_player],deactivate,tbl_Vehicles[id2][1])
    end;
    [3] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Spawn Pickup To '.." ["..selected_player.."] "..' '..PlayerNicknames
      OBJECT.CREATE_AMBIENT_PICKUP(tbl_pickup_hash[IDHash],data_prop[id_prop],9999,target_x[selected_player],target_y[selected_player],target_z[selected_player],theading_x[selected_player],theading_y[selected_player],tonumber(PlaylistTab.Dist.Text),tonumber(PlaylistTab.Tinggi.Text))
    end;
    [4] = function()
      Player_List_Info()
      --ShowPlayerAvatar(selected_player,0)
      DropWeaponInQueue(selected_player,Intervals)
    end;
    [5] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Spawn Auto Health True To '.." ["..selected_player.."] "..PlayerNicknames
      AutoHealthPack(true,Intervals,selected_player)
      VSpawn.CEListView1.MultiSelect = true
    end;
    [6] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Spawn Auto Health False To '.." ["..selected_player.."] "..PlayerNicknames
      AutoHealthPack(false,Intervals,selected_player)
      VSpawn.CEListView1.MultiSelect = false
    end;
    [7] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      PlaylistTab.HashIndicator.Text = 'Teleport Ped To '.." ["..selected_player.."] "..PlayerNicknames
      PED.SET_PED_COORD(pos_x,pos_y,pos_z,PLAYER.PLAYER_INDEX_ID(selected_player))
    end;
    [8] = function()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      PlaylistTab.HashIndicator.Text = 'Spawn Object Loop To True'.." ["..selected_player.."] "..' '..PlayerNicknames
      Player_List_Info()
      --ShowPlayerAvatar(selected_player,0)
      DropItemLoop(selected_player,true,Intervals,IDHash,id_prop)
    end;
    [9] = function()
      PlaylistTab.HashIndicator.Text = 'Spawn Object Loop To False'.." ["..selected_player.."]"..PlayerNicknames
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      DropItemLoop(selected_player,false,Intervals,IDHash,id_prop)
    end;
    [10] = function()
      Player_List_Info()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))
      --ShowPlayerAvatar(selected_player,0)
      VehicleSpammer(selected_player,true,Intervals,tbl_Vehicles[id2][1])
    end;
    [11] = function()
      LuaEngineLog(string.format("Player Index [%s] | Player Name : %s | Memory Address 0x%X",selected_player,PlayerNicknames,get.Memory(CPLAYER_NAME[selected_player])))       
      Player_List_Info()
      --ShowPlayerAvatar(selected_player,0)
      VehicleSpammer(selected_player,false,Intervals,tbl_Vehicles[id2][1])
    end;
  }
)
end

function Panik()
  RIDJoiner(0,false)
end

function InceaseX()
  local cord_x=get.Float(PLAYER_CORDX)
  set.float(PLAYER_CORDX,cord_x+1)
  set.float(PLAYER_VECX,cord_x+1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE() then
    set.float(CVehiclePos + 0x50,cord_x+1)
    set.float(CVehicle + 0x90,cord_x+1)
  end
end

function DecreaseX()
  local cord_x=get.Float(PLAYER_CORDX)
  set.float(PLAYER_CORDX,cord_x-1)
  set.float(PLAYER_VECX,cord_x-1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE() then
    set.float(CVehiclePos + 0x50,cord_x-1)
    set.float(CVehicle + 0x90,cord_x-1)
  end
end

function IncreaseY()
  local cord_y=get.Float(PLAYER_CORDY)
  set.float(PLAYER_CORDY,cord_y+1)
  set.float(PLAYER_VECY,cord_y+1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE()
 then
    set.float(CVehiclePos + 0x54,cord_y+1)
    set.float(CVehicle + 0x94,cord_y+1)
   end
end

function DecreaseY()
  local cord_y=get.Float(PLAYER_CORDY)
  set.float(PLAYER_CORDY,cord_y-1)
  set.float(PLAYER_VECY,cord_y-1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE() then
    set.float(CVehiclePos + 0x54,cord_y-1)
    set.float(CVehicle + 0x94,cord_y-1)
  end
end

function IncreaseZ()
  local cord_z=get.Float(PLAYER_CORDZ)
  set.float(PLAYER_CORDZ,cord_z+1)
  set.float(PLAYER_VECZ,cord_z+1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE() then
    set.float(CVehiclePos + 0x58,cord_z+1)
    set.float(CVehicle + 0x98,cord_z+1)
  end
end

function DecreaseZ()
  local cord_z=get.Float(PLAYER_CORDZ)
  set.float(PLAYER_CORDZ,cord_z-1)
  set.float(PLAYER_VECZ,cord_z-1)
  local p = get.Ptr(get.Ptr(get.Memory("WorldPTR")) + 0x8)
  if PED.IS_PED_IN_ANY_VEHICLE() then
    set.float(CVehiclePos + 0x58,cord_z-1)
    set.float(CVehicle + 0x98,cord_z-1)
  end
end

function InstantDeliveryExecutor(sender)
  local DELIVER = {SpecialCargo,hangar,bunker_deliver,bkr}
  local index = combobox_getItemIndex(Player_Deliver) + 1;
  DELIVER[index](tonumber(Player.Deliver2.Text))
end

function ListMenuExecutor(sender, user)
  local id = listbox_getItemIndex(MainTab.CheatMenu) + 1;
  SetList(CT[id][1],true)
  SetList(CT[id][1],false)
  NotificationPopUpMap("Activate : %s"..CT[id][2])
  LuaEngineLog(string.format("Activate : %s",CT[id][2]))
end

function Player_CEListBox2SelectionChange(sender, user)
--[[Kosong, fungsi cadangan
]]
end

function MainMenuCheckBox(sender)
  local id = listbox_getItemIndex(MainTab.CheckListBox2) + 1;
  if ReadAct(CT2[id][1])==false then
    SetList(CT2[id][1],true)
    MainTab.CEEdit1.Text = CT2[id][2].." : "..tostring(ReadAct(CT2[id][1]))
    --MainTab.CheckListBox2.Checked[id] = true
    NotificationPopUpMap("Activate : "..CT2[id][2].." "..tostring(ReadAct(CT2[id][1])))
    LuaEngineLog(string.format("Activate : %s",CT2[id][2]))
  elseif ReadAct(CT2[id][1])==true then
    SetList(CT2[id][1],false)
    MainTab.CEEdit1.Text = CT2[id][2].." : "..tostring(ReadAct(CT2[id][1]))
    --MainTab.CheckListBox2.Checked[id] = false
    NotificationPopUpMap("Activate : "..CT2[id][2].." "..tostring(ReadAct(CT2[id][1])))
    LuaEngineLog(string.format("Deactivate : %s",CT2[id][2]))
  end
end
    
function SliderMenuExecutor(sender)
local index = listbox_getItemIndex(MainTab.CEListBox1) + 1;
local data = get.Float(CT3[index][2])
MainTab.SetSliderFloat.TextHint = get.Float(CT3[index][2])
LuaEngineLog(string.format("%s : %s",CT3[index][1],get.Float(CT3[index][2])))
  set.float(CT3[index][2],sender.Position)
end

function SliderMenuEditor()
  local index = listbox_getItemIndex(MainTab.CEListBox1) + 1;
  set.float(CT3[index][2],tonumber(MainTab.SetSliderFloat.Text))
end

function SliderMenuReader(sender, user)
  local index = listbox_getItemIndex(MainTab.CEListBox1) + 1;
  MainTab.SetSliderFloat.TextHint = get.Float(CT3[index][2])
  LuaEngineLog(string.format("%s : %s",CT3[index][1],get.Float(CT3[index][2])))
end

function NameChanger(sender)
  ChangePlayerName(tostring(MainTab.NameChanger.Text))
end

function AntiLevelHack()
  local TotalEXP = get.Global(int,1590682+1+PLAYER_ID()*883+211+1);
  local TotalGlobalXP = get.Global(int,1590682+1+PLAYER_ID()*883+211+5);
  local TotalEXP = CHAR_EXP_1 + CHAR_EXP_2
  set.global(int,1590682+1+PLAYER_ID()*883+211+5,TotalEXP)
end

function LevelSpoofer(sender)
  --LevelTimer.Enabled = false
  local LevelSpoofed = tonumber(MainTab.CEEdit3.Text);
  set.global(int,1590682+1+PLAYER_ID()*883+211+6,tonumber(MainTab.CEEdit3.Text))
  set.global(int,1590682+1+PLAYER_ID()*883+211+1,level_data[LevelSpoofed]);
  LevelTimer.Enabled = true
end
if LevelTimer == nil then
   LevelTimer = createTimer(nil, false)
   LevelTimer.Interval = 100
   LevelTimer.setOnTimer(LevelSpoofer)
end

function LoopSpoofMoney(Number)
  set.global(int,1590682+1+PLAYER_ID()*883+211+56,Number)
end

function MoneySpoof()
  local TotalMoney = get.Global(int,1590682+1+PLAYER_ID()*883+211+56);
  local Action = true
  THREAD.YIELD(LoopSpoofMoney,Action,tonumber(MainTab.MoneySpoof.Text),2500)
  if TotalMoney >= MAX_INT then Action = false end
end

function AutoSpoofRID()
  local check = checkbox_getState(PlaylistTab.AutoSpoofer)
  if check == cbChecked then
    SetList('RID SPOOF',true)
    LuaEngineLog(string.format("Activate SCID Spoof : %s",get.Scripts("RID SPOOF")))
  elseif check == cbUnchecked then
    SetList('RID SPOOF',false)
    LuaEngineLog(string.format("Deactivate SCID Spoof : %s",get.Scripts("RID SPOOF")))
  end
end

function RID_Spoofer_Manual(sender)
  local NewThread = function()
    if not RIDJoinerScriptStatus then
      RIDJoiner(tonumber(PlaylistTab.CEEdit8.Text),true)
    elseif RIDJoinerScriptStatus then
      RIDJoiner(tonumber(PlaylistTab.CEEdit8.Text),false)
      SYSTEM.WAIT(1500)
      RIDJoiner(tonumber(PlaylistTab.CEEdit8.Text),true)
    end
  end
  ExecuteThread(NewThread)
end

NEON_CR = {255,255,0,0,255,0,255}
NEON_CG = {255,0,255,0,255,255,0}
NEON_CB = {255,0,0,255,0,255,255}

function PrimaryColor(sender)
  local id = combobox_getItemIndex(VehicleTab.PrimCol) + 1;
  p_color(NEON_CR[id],NEON_CG[id],NEON_CB[id])
end

function SecondaryColor(sender)
  local id = combobox_getItemIndex(VehicleTab.SecondaryCol) + 1;
  s_color(NEON_CR[id],NEON_CG[id],NEON_CB[id])
end

function VehOp_NeonChange(sender)
  local id = combobox_getItemIndex(VehicleTab.Neon) + 1;
  neon_color(NEON_CR[id],NEON_CG[id],NEON_CB[id])
end

function TiresColor(sender)
  local id = combobox_getItemIndex(VehicleTab.Tires) + 1;
  tire_color(NEON_CR[id],NEON_CG[id],NEON_CB[id])
end

function Player_BurstChange(sender)
 if sender.Position == 0 then
   set.int(CAmmoType + 0x120,1)
  elseif sender.Position == 1 then
    set.int(CAmmoType + 0x120,2)
  elseif sender.Position == 2 then
    set.int(CAmmoType + 0x120,3)
  elseif sender.Position == 3 then
    set.int(CAmmoType + 0x120,4)
  elseif sender.Position == 4 then
    set.int(CAmmoType + 0x120,5)
  elseif sender.Position == 5 then
    set.int(CAmmoType + 0x120,6)
  elseif sender.Position == 6 then
    set.int(CAmmoType + 0x120,7)
  elseif sender.Position == 7 then
    set.int(CAmmoType + 0x120,8)
  elseif sender.Position == 8 then
    set.int(CAmmoType + 0x120,9)
  elseif sender.Position == 9 then
    set.int(CAmmoType + 0x120,10)
  elseif sender.Position == 10 then
    set.int(CAmmoType + 0x120,100)
  end
end

function BustSpread(Trigger)
  local Activator = Trigger
  if Activator == false then 
    set.float(CAmmoType + 0x124,0)
  elseif Activator == true then
    set.float(CAmmoType + 0x124,0.05)
  end
end

function InstantRID_Spoofer(sender)
  local id = combobox_getItemIndex(PlaylistTab.InstantRID) + 1;
  RID_SPOOF(DATA_RID[id][2])
  LuaEngineLog(string.format("Username : %s | SCID : %i",DATA_RID[id][1],DATA_RID[id][2]))
end

function NetwordScriptedEventBlock(sender)
  SCRIPT_EVENTS = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
  18, 19, 20, 21, 22, 23 ,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
  45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,
  75,76,77,78,79, 80, 81}
  local index = listbox_getItemIndex(StatTab.CheckListBox1) + 1;
  if EventStatus == false then
    v_ProtectEvent(SCRIPT_EVENTS[index])
  elseif EventStatus == true then
    v_ProtectEvent(SCRIPT_EVENTS[index])
  end
end

function TurnXenonON(sender)
  local boxstate = checkbox_getState(VehicleTab.TurnXenon)
    if boxstate == cbChecked then
      set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+XENON",true)
    elseif boxstate == cbUnchecked then
      set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+XENON",false)
  end
end

function NeonColorChange(sender)
  local id = combobox_getItemIndex(VehicleTab.Neons) + 1;
  neon_color(NEON_CR[id],NEON_CG[id],NEON_CB[id])
end
colorIDs = {255,0,1,2,3,4,5,6,7,8,9,10,11,12}
function XenonColorChange(sender)
  local index = combobox_getItemIndex(VehicleTab.XenonC) + 1;
  set.byte("[[[[WorldPTR]+CPED]+VEH]+TUNING]+XENON_COLOUR",colorIDs[index])
end

function TurnNeonON(sender)
  boxstate = checkbox_getState(VehicleTab.NeonA)
  if boxstate == cbChecked then
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+402",true)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+403",true)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+404",true)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+405",true)
  elseif boxstate == cbChecked then
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+402",false)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+403",false)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+404",false)
    set.bool("[[[[WorldPTR]+CPED]+VEH]+TUNING]+405",false)
  end
end

function VehicleHandlingSlider(sender)
  local id = listbox_getItemIndex(VehicleTab.Handling) + 1;
  VehicleTab.HandlingIndicator.TextHint = readFloat(handling_data[id][2])
   if sender.Position == 0 then
   set.float(handling_data[id][2],1)
   elseif sender.Position == 1 then
   set.float(handling_data[id][2],2)
   elseif sender.Position == 2 then
   set.float(handling_data[id][2],3)
   elseif sender.Position == 3 then
   set.float(handling_data[id][2],4)
   elseif sender.Position == 4 then
   set.float(handling_data[id][2],5)
   elseif sender.Position == 5 then
   set.float(handling_data[id][2],6)
   elseif sender.Position == 6 then
   set.float(handling_data[id][2],7)
   elseif sender.Position == 7 then
   set.float(handling_data[id][2],8)
   elseif sender.Position == 8 then
   set.float(handling_data[id][2],9)
   elseif sender.Position == 9 then
   set.float(handling_data[id][2],10)
   elseif sender.Position == 10 then
   set.float(handling_data[id][2],11)
   elseif sender.Position == 11 then
   set.float(handling_data[id][2],12)
   elseif sender.Position == 12 then
   set.float(handling_data[id][2],14)
   elseif sender.Position == 13 then
   set.float(handling_data[id][2],16)
   elseif sender.Position == 14 then
   set.float(handling_data[id][2],18)
   elseif sender.Position == 15 then
   set.float(handling_data[id][2],20)
   elseif sender.Position == 16 then
   set.float(handling_data[id][2],22)
   elseif sender.Position == 17 then
   set.float(handling_data[id][2],24)
   elseif sender.Position == 18 then
   set.float(handling_data[id][2],26)
   elseif sender.Position == 19 then
   set.float(handling_data[id][2],28)
   elseif sender.Position == 20 then
   set.float(handling_data[id][2],30)
   elseif sender.Position == 21 then
   set.float(handling_data[id][2],32)
   elseif sender.Position == 22 then
   set.float(handling_data[id][2],34)
   elseif sender.Position == 23 then
   set.float(handling_data[id][2],36)
   elseif sender.Position == 24 then
   set.float(handling_data[id][2],38)
   elseif sender.Position == 25 then
   set.float(handling_data[id][2],40)
   elseif sender.Position == 26 then
   set.float(handling_data[id][2],42)
   elseif sender.Position == 27 then
   set.float(handling_data[id][2],44)
   elseif sender.Position == 28 then
   set.float(handling_data[id][2],46)
   elseif sender.Position == 29 then
   set.float(handling_data[id][2],48)
   elseif sender.Position == 30 then
   set.float(handling_data[id][2],50)
   elseif sender.Position == 31 then
   set.float(handling_data[id][2],52)
   elseif sender.Position == 32 then
   set.float(handling_data[id][2],54)
   elseif sender.Position == 33 then
   set.float(handling_data[id][2],56)
   elseif sender.Position == 34 then
   set.float(handling_data[id][2],58)
   elseif sender.Position == 35 then
   set.float(handling_data[id][2],60)
   elseif sender.Position == 36 then
   set.float(handling_data[id][2],62)
   elseif sender.Position == 37 then
   set.float(handling_data[id][2],64)
   elseif sender.Position == 38 then
   set.float(handling_data[id][2],70)
   elseif sender.Position == 39 then
   set.float(handling_data[id][2],80)
   elseif sender.Position == 40 then
   set.float(handling_data[id][2],90)
   elseif sender.Position == 37 then
   set.float(handling_data[id][2],100)
   elseif sender.Position == 41 then
   set.float(handling_data[id][2],100)
   elseif sender.Position == 42 then
   set.float(handling_data[id][2],200)
   elseif sender.Position == 43 then
   set.float(handling_data[id][2],300)
   elseif sender.Position == 44 then
   set.float(handling_data[id][2],400)
   elseif sender.Position == 45 then
   set.float(handling_data[id][2],500)
   elseif sender.Position == 46 then
   set.float(handling_data[id][2],600)
   elseif sender.Position == 47 then
   set.float(handling_data[id][2],700)
   elseif sender.Position == 48 then
   set.float(handling_data[id][2],800)
   elseif sender.Position == 49 then
   set.float(handling_data[id][2],900)
   elseif sender.Position == 50 then
   set.float(handling_data[id][2],1000)
  end
end

function MaxUpgradeVehicle(sender)
  SetList("Max Upgrades",true)
  SetList("Max Upgrades",false)
end

function DestroyLastVehicle(sender)
  SetList("Destroy Last Veh",true)
  SetList("Destroy Last Veh",false)
end

function TeleportToLastVehicle(sender)
  SetList("Teleport To Last Vehicle",true)
  SetList("Teleport To Last Vehicle",false)
end

function HealVehicleHP(sender)
  SetList("Heal Vehicle",true)
  SetList("Heal Vehicle",false)
end

function ForgeModelLSC(sender)
  local id = combobox_getItemIndex(VehicleTab.LSC) + 1;
  set.int("[[[[WorldPTR]+CPED]+VEH]+20]+18", GAMEPLAY.GET_HASH_KEY(tbl_Vehicles[id][1]))
end

function TurnTiresColorON(sender)
  local boxstate = checkbox_getState(VehicleTab.TiresON)
  if boxstate == cbChecked then
    set.byte("[[[[WorldPTR]+CPED]+VEH]+TUNING]+3DF",1)
  elseif boxstate == cbChecked then
    set.byte("[[[[WorldPTR]+CPED]+VEH]+TUNING]+3DF",255)
  end
end

function VehicleMenuExecutor(sender)
  local index = listbox_getItemIndex(VehicleTab.VehiOP) + 1;
  if ReadAct(VehOption[index])==false then
    SetList(VehOption[index],true)
    NotificationPopUpMap(VehOption[index].." : "..tostring(VehicleTab.VehiOP.Checked[index-1]))
    LuaEngineLog(string.format("%s : %s",VehOption[index],VehicleTab.VehiOP.Checked[index-1]))
  elseif ReadAct(VehOption[index])==true then
    SetList(VehOption[index],false)
    NotificationPopUpMap(VehOption[index].." : "..tostring(VehicleTab.VehiOP.Checked[index-1]))
    LuaEngineLog(string.format("%s : %s",VehOption[index],VehicleTab.VehiOP.Checked[index-1]))
  end
end

function VehOp_HandlingSelectionChange(sender, user)
  local id = listbox_getItemIndex(VehicleTab.Handling) + 1;
  VehicleTab.HandlingIndicator.TextHint = get.Float(handling_data[id][2])
end

function VehicleHandlingSet(sender)
  local id = listbox_getItemIndex(VehicleTab.Handling) + 1;
  set.float(handling_data[id][2],tonumber(VehicleTab.HandlingIndicator.Text))
end

function SelectHeistType()
  local HeistApproach = StatTab.CEComboBox1
  local HeistTarget = StatTab.CEComboBox2
  local HeistDifficult = StatTab.CEComboBox3
  local HeistHelper = StatTab.CEComboBox4
  local HeistHelper2 = StatTab.CEComboBox5
  local HeistHelper3 = StatTab.CEComboBox6
  local HeistHelper4 = StatTab.CEComboBox7
  local HeistHelper5 = StatTab.CEComboBox8
  local HeistHelper6 = StatTab.CEComboBox9
  local HeistHelper7 = StatTab.CEComboBox10
  local HeistHelper8 = StatTab.CEComboBox11
  local MPX = get.Global(int,1312763)
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12)
	if mp_id==1 then
    FORM.ADD_LOOP(HeistApproach,MP0_Approach,1)
    sleep(10)
    FORM.ADD_LOOP(HeistTarget,MP0_TARGET,1)
    sleep(10)
    FORM.ADD_LOOP(HeistDifficult,MP0_LAST_AP,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper,MP0_HARD_AP,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper2,MP0_DUGGAN,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper3,MP0_PASS,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper4,MP0_WEP,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper5,MP0_DRIVER,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper6,MP0_HACKER,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper7,MP0_VEH,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper8,MP0_WEPS,1)
    StatTab.CEButton6.Caption = "SET BOARD 2"
    StatTab.CEButton8.Caption = "Cancel 2"
  elseif mp_id==2 then
    FORM.ADD_LOOP(HeistApproach,MP_Cayo_Approach,1)
    sleep(10)
    FORM.ADD_LOOP(HeistTarget,MP_Cayo_Target,1)
    sleep(10)
    FORM.ADD_LOOP(HeistDifficult,MP_Cayo_Diff,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper,MP_Cayo_Truck,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper2,MP_Cayo_Disrp,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper3,MP_Cayo_Weapon,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper4,MP_Cayo_Boltcut,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper5,MP_Cayo_Grap,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper6,MP_Cayo_Uniform,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper7,MP_Cayp_AI,1)
    sleep(10)
    FORM.ADD_LOOP(HeistHelper8,MP_Cayo_Target2,1)
    StatTab.CEButton6.Caption = "Set Cayo"
    StatTab.CEButton8.Caption = "Reset Cayo"
  end
end

ap_val = {1,2,3}
function HeistApproach()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local approach_id = combobox_getItemIndex(StatTab.CEComboBox1);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_APPROACH",ap_val[approach_id])
  elseif mp_id == 2 then
    local ap_id2 = combobox_getItemIndex(StatTab.CEComboBox1) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4_MISSIONS",MP_Cayo_Approach[ap_id2][2])
  end
end

tg_val = {0,1,2,3}
function HeistTarget()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local tg = combobox_getItemIndex(StatTab.CEComboBox2);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_TARGET",tg_val[tg])
  elseif mp_id == 2 then
    local tg2 = combobox_getItemIndex(StatTab.CEComboBox2) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_TARGET",MP_Cayo_Target[tg2][2])
  end
end

function HeistLastApproach()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local hid = combobox_getItemIndex(StatTab.CEComboBox3);
    STATS.STAT_SET_INT("MP"..MPX.."_H3_LAST_APPROACH",ap_val[hid])
  elseif mp_id == 2 then
    local hid2 = combobox_getItemIndex(StatTab.CEComboBox3) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4_PROGRESS",MP_Cayo_Diff[hid2][2])
  end
end

function HeistHardApproach()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local lid = combobox_getItemIndex(StatTab.CEComboBox4);
    STATS.STAT_SET_INT("MP"..MPX.."_H3_HARD_APPROACH",ap_val[lid])
  elseif mp_id == 2 then
    local lid2 = combobox_getItemIndex(StatTab.CEComboBox4);
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_TROJAN",MP_Cayo_Truck[lid2][2])
  end
end
--------------------------------------------------Mission List-------------------------------------------------------
function Mission_Vault_Content(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VaultContents
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Mission_Vault_Keys(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VaultKeys
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Mission_Weapon_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.WeaponsMissionFinished
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Mission_Vehicle_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VehicleMissionFinished
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Mission_Device_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.HackingDevice
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end
---------------------------------------------------Tergantung Approach------------------------------------------------
function Silent_Drone_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.NanoDrone
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Silent_Laser_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VaultLaser
  elseif checked == false then
    return bitset1.None
  else 
    return 0
  end
end

function Bigcon_Laser_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VaultDrill
  elseif checked == false then
    return bitset1.None
  else
    return 0
  end
end

function Loud_Explosive_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.VaultExplosives
  elseif checked == false then
    return bitset1.None
  else
    return 0
  end
end

function Loud_Thermal_Finished(Activate)
  local checked = Activate
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if checked == true then
    return bitset1.ThermalCharges
  elseif checked == false then
    return bitset1.None
  else
    return 0
  end
end
----------------------------------------------------Bitset One End----------------------------------------------------
function HeistSet1()
  local MPX = get.Global(int,1312763)
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if mp_id == 1 then
    switch((SelectedApproach),
{
    [1] = function ()--silent
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET1",127)
    end,
    [2] = function ()--bigcon
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET1",159)
    end,
    [3] = function ()--aggressive
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET1",799)
    end,
  }  
)
  elseif mp_id == 2 then
    LuaEngineLog("NULL")
  end
end

function HeistDistruptionLevel()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local did = combobox_getItemIndex(StatTab.CEComboBox5);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_DISRUPTSHIP",tg_val[did])
  elseif mp_id == 2 then
    local did2 = combobox_getItemIndex(StatTab.CEComboBox5) + 1;
    local disrupted =
      {
        {'MP'..MPX..'_H4CNF_WEP_DISRP',MP_Cayo_Disrp[did2][2]},
        {'MP'..MPX..'_H4CNF_HEL_DISRP',MP_Cayo_Disrp[did2][2]},
        {'MP'..MPX..'_H4CNF_ARM_DISRP',MP_Cayo_Disrp[did2][2]},
      }
    STATS.STAT_FAST_INT(disrupted)
  end
end

function EntranceKeyLevel()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local idp = combobox_getItemIndex(StatTab.CEComboBox6);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_KEYLEVELS",tg_val[idp])
  elseif mp_id == 2 then
    local idp2 = combobox_getItemIndex(StatTab.CEComboBox6) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_WEAPONS",MP_Cayo_Weapon[idp2][2])
  end
end

crew_val = {1,2,3,4,5}
function HeistWeaponCrew()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local idw = combobox_getItemIndex(StatTab.CEComboBox7);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_CREWWEAP",crew_val[idw])
  elseif mp_id == 2 then
    local idw2 = combobox_getItemIndex(StatTab.CEComboBox7) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_BOLTCUT",MP_Cayo_Boltcut[idw2][2])
  end
end

function HeistDriverSet()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local idd = combobox_getItemIndex(StatTab.CEComboBox8);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_CREWDRIVER",crew_val[idd])
  elseif mp_id == 2 then
    local idd2 = combobox_getItemIndex(StatTab.CEComboBox8) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_GRAPPEL",MP_Cayo_Grap[idd2][2])
  end
end

function HeistHackerSet()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
    local idh = combobox_getItemIndex(StatTab.CEComboBox9);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_CREWHACKER",crew_val[idh])
  elseif mp_id == 2 then
    local idh2 = combobox_getItemIndex(StatTab.CEComboBox9) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_UNIFORM",MP_Cayo_Uniform[idh2][2])
  end
end

function HeistVehicleSet()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
  local idv = combobox_getItemIndex(StatTab.CEComboBox10);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_VEHS",tg_val[idv])
  elseif mp_id == 2 then
    local idv2 = combobox_getItemIndex(StatTab.CEComboBox10) + 1;
    STATS.STAT_SET_INT("MP"..MPX.."_H4CNF_BS_ABIL",MP_Cayp_AI[idv2][2])
  end
end

function HeistWeaponSet()
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  local MPX = get.Global(int,1312763)
  if mp_id == 1 then
  local idws = combobox_getItemIndex(StatTab.CEComboBox11);
    STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_WEAPS",tg_val[idws])
  elseif mp_id == 2 then
    local idws2 = combobox_getItemIndex(StatTab.CEComboBox11) + 1;
    local secondary_target =
  {
    {'MP'..MPX..'_H4LOOT_CASH_I_SCOPED',MP_Cayo_Target2[idws2][2]},
    {'MP'..MPX..'_H4LOOT_CASH_C_SCOPED',MP_Cayo_Target2[idws2][3]},
    {'MP'..MPX..'_H4LOOT_WEED_I_SCOPED',MP_Cayo_Target2[idws2][4]},
    {'MP'..MPX..'_H4LOOT_COKE_I_SCOPED',MP_Cayo_Target2[idws2][5]},
    {'MP'..MPX..'_H4LOOT_GOLD_C_SCOPED',MP_Cayo_Target2[idws2][6]},
    {'MP'..MPX..'_H4LOOT_PAINT_SCOPED',MP_Cayo_Target2[idws2][7]},
  }
    STATS.STAT_FAST_INT(secondary_target)
  end
end

function HeistSet2()
  local MPX = get.Global(int,1312763)
  local cayo_set = 
  {
    {'MP'..MPX..'_H4CNF_BS_ENTR',63},
    {'MP'..MPX..'_H4CNF_VOLTAGE',3},
    {'MP'..MPX..'_H4CNF_BS_GEN',131071},
  }
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if mp_id == 1 then
    switch(SelectedApproach,
{
    [1] = function ()--silent
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET0",62)
    end,
    [2] = function ()--bigcon
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET0",339990)
    end,
    [3] = function ()--aggressive
      STATS.STAT_SET_INT("MP"..MPX.."_H3OPT_BITSET0",3670038)
    end,
  }  
)
  elseif mp_id == 2 then
    STATS.STAT_FAST_INT(cayo_set)
  end
end

function HeistReset1()
  local MPX = get.Global(int,1312763)
  STATS.STAT_SET_INT('MP'..MPX..'_H3OPT_BITSET1',0)
end

function HeistReset2()
  local cayo_reset = 
  {
    {'MP'..MPX..'_H4_MISSIONS',0},
    {'MP'..MPX..'_H4_PROGRESS',0},
    {'MP'..MPX..'_H4CNF_APPROACH',0},
    {'MP'..MPX..'_H4CNF_BS_ENTR',0},
    {'MP'..MPX..'_H4CNF_BS_GEN',0},
  }
  local MPX = get.Global(int,1312763)
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12);
  if mp_id == 1 then
    STATS.STAT_SET_INT('MP'..MPX..'_H3OPT_BITSET0',0)
  elseif mp_id == 2 then
    STATS.STAT_FAST_INT(cayo_set)
  end
end

function StatEditingOption()
  local types_stat = combobox_getItemIndex(StatTab.CEComboBox13) + 1;
  StatInputToString = tostring(Protection.joaat.Text)
  StatHash = StatInputToString:match('MPX([^,]+)')
  StatInput = StatInputToString:match('MPX([^,]+)') and 'MP' .. MPX .. StatHash or StatInputToString:match("^%-?%d+$") and tonumber(StatInputToString) or  StatInputToString
  if types_stat == 2 then
    StatTab.CEButton9.Caption = 'Set Integer'
    STATS.STAT_SET_INT(StatInput,tonumber(Protection.stat_value.Text))
    LuaEngineLog(string.format("Stat : %s | Value : %s | [Hash : 0x%X]",Protection.joaat.Text,Protection.stat_value.Text,joaat(tostring(Protection.joaat.Text))))
  elseif types_stat == 3 then
    StatTab.CEButton9.Caption = 'Set Float'
    STATS.STAT_SET_FLOAT(StatInput, tonumber(Protection.stat_value.Text))
    LuaEngineLog(string.format("Stat : %s | Value : %s | [Hash : 0x%X]",Protection.joaat.Text,Protection.stat_value.Text,joaat(tostring(Protection.joaat.Text))))
  elseif types_stat == 4 then
    StatTab.CEButton9.Caption = 'Set Boolean'
    STATS.STAT_SET_BOOL(StatInput,StrToBoolean(Protection.stat_value.Text) or tonumber(Protection.stat_value.Text))
    LuaEngineLog(string.format("Stat : %s | Value : %s | [Hash : 0x%X]",Protection.joaat.Text,Protection.stat_value.Text,joaat(tostring(Protection.joaat.Text))))
  elseif types_stat == 5 then
    STATS.STAT_GET_INT(StatInput)
    SYSTEM.WAIT(15)
    Protection.stat_value.Text = get.Global(int, 2551772 + 276)
    LuaEngineLog(string.format("Stat : %s | [Hash : 0x%X]", Protection.joaat.Text, joaat(tostring(Protection.joaat.Text))))
    StatTab.CEButton9.Caption = 'Get Value'
  elseif types_stat == 6 then
    local NewThread = function()
      STATS.STAT_GET_FLOAT(StatInput)
      SYSTEM.WAIT(1000)
	    Protection.stat_value.Text = get.Global(float, 1590682 + 1 + PLAYER_ID() * 883 + 211 + 57)
    end
    ExecuteThread(NewThread)
    LuaEngineLog(string.format("Stat : %s | [Hash : 0x%X]", Protection.joaat.Text, joaat(tostring(Protection.joaat.Text))))
    StatTab.CEButton9.Caption = 'Get Float'
  elseif types_stat == 7 then
    local NewThread = function()
      STATS.STAT_GET_BOOL(StatInput)
      SYSTEM.WAIT(1000)
	    Protection.stat_value.Text = tostring(MEMORY.IS_BIT_SET(1590682 + 1 + PLAYER_ID() * 883 + 211 + 49, 0))
    end
    ExecuteThread(NewThread)
    LuaEngineLog(string.format("Stat : %s | [Hash : 0x%X]", Protection.joaat.Text, joaat(tostring(Protection.joaat.Text))))
    StatTab.CEButton9.Caption = 'Get Bool'
  elseif types_stat == 8 then
    StatTab.CEButton9.Caption = 'Import Int'
    STATS.RUN_LOADER_INT()
  elseif types_stat == 9 then
    StatTab.CEButton9.Caption = 'Import Bool'
    STATS.RUN_LOADER_BOOL()
  end
end

function ResetAllHeistCooldown()
  local MPX = get.Global(int,1312763)
    if STATS.STAT_GET_INT("MP"..MPX.."_H3_COMPLETEDPOSIX") > 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN") == 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN_HARD") == 0 then
      STATS.STAT_SET_INT("MP"..MPX.."_H3_COMPLETEDPOSIX",-1)
    elseif STATS.STAT_GET_INT("MP"..MPX.."_H3_COMPLETEDPOSIX") == 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN") > 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN_HARD") > 0 then
      STATS.STAT_SET_INT("MP"..MPX.."_H4_COOLDOWN",-1)
    elseif STATS.STAT_GET_INT("MP"..MPX.."_H3_COMPLETEDPOSIX") == 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN") > 0 and STATS.STAT_GET_INT("MP"..MPX.."_H4_COOLDOWN_HARD") > 0 then
      STATS.STAT_SET_INT("MP"..MPX.."_H4_COOLDOWN_HARD",-1)
    end
    STATS.STAT_SET_INT("MPPLY_AWD_FM_CR_MISSION_SCORE", 0)
end

explosive_list = 
{
MAX_UINT, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 
26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 
56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 99
}

function CustomExplosiveAmmo()
  local explosive_id = combobox_getItemIndex(Player_CEComboBox1)
  local explosive_data = get.Memory("[[[[WorldPTR]+8]+10D8]+20]+24")
  set.int(explosive_data,explosive_list[explosive_id])
end

bullet_data = {
  0x27AF51ECA50ABB74,
  0x9A3207B767DD81F2,
  0x1A368BDFAF23EE0F,
  0xD05319F,
  0x743D4F54,
  0x6AA1343F,
  0x4C98087B,
  0x9FC5C882,
  0x1152354B3BD313B1,
  0x741FD3C43BCCA5EE,
  0xCB82F7CD5633F9D5,
  0xF5A94D45155663F8,
  0x6FD84B0AAF2208A7,
  0xBDD3A2FF5424B617,
  0x5EDD1FDAE60E08A6
}
function CustomBulletFunc()
  local bullet_id = combobox_getItemIndex(Player_CEComboBox2)
  local bullet_set = get.Memory("[[[[[WorldPTR]+8]+10D8]+20]+60]+10")
  set.long(bullet_set,bullet_data[bullet_id])
end

function TurnOnExp(sender)
  local activation = checkbox_getState(VehicleTab.BulletToExp);
  local vehicle_wep_id = get.Ptr(CWeapon + 0x70);
  if activation == cbChecked then
    set.short(vehicle_wep_id + 0x20,5);
  elseif activation == cbUnchecked then
    set.short(vehicle_wep_id + 0x20,3);
  end
end

function VehExpType(sender)
  local veh_exp_id = combobox_getItemIndex(VehicleTab.VehicleExplosive);
  local vehicle_wep_id = get.Ptr(CWeapon + 0x70);
  set.int(vehicle_wep_id + 0x24,explosive_list[veh_exp_id]);
end

function PlayerData_FormActivate(sender)
  PlayerList()
end

function PlayerData_FormDeactivate(sender)
  PlayerList()
end

function PlayerData_CEListBox1DblClick(sender)
  PlayerList()
end

function Player_CEComboBox3Select(sender)
--funcsi kosong
end

function SetPlayerLevel()
  local exp = combobox_getItemIndex(Player_CEComboBox3);
  local level = get.Global(int, 292403 + 1 + exp)
  local MPX = get.Global(int,1312763)
  STATS.STAT_SET_INT("MP"..MPX.."_CHAR_SET_RP_GIFT_ADMIN",level)
end

function Unlock_All_Stat()
  local selected = StatTab.CEComboBox14.itemIndex;
  switch(selected,
    {
      [1] = function ()
          MPX = get.Global(int,1312763)
          MPx = tostring('MP'..MPX..'_')
          STATS.STAT_LOOP_BOOL(Unlock_Boolean)
      end,
      [2] = function ()
          MPX = get.Global(int,1312763)
          MPx = tostring('MP'..MPX..'_')
          STATS.STAT_LOOP_INT(Unlock_Int)
      end,
      [3] = function ()
          MPX = get.Global(int,1312763)
          MPx = tostring('MP'..MPX..'_')
          STATS.STAT_LOOP_INT(Cayo_Perico_Award_Int)
      end,
      [4] = function ()
          MPX = get.Global(int,1312763)
          MPx = tostring('MP'..MPX..'_')
          STATS.STAT_LOOP_BOOL(Cayo_Perico_Award_Bool)
      end,
    }
  ) 
end

function InstantHeistSetupOption()
  local selected = StatTab.CEComboBox15.itemIndex;
  local mp_id = combobox_getItemIndex(StatTab.CEComboBox12) + 1;
  switch(selected,
    {
      [1] = function ()
      local MPX = tostring(get.Global(int,1312763))
      local MPx = tostring('MP'..MPX..'_')
      STATS.STAT_FAST_INT(silent)
      end,
      [2] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(bigcon)
      end,
      [3] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(aggressive)
      end,
      [4] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(doomsday)
      end,
      [5] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(apartment)
      end,
      [6] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(CPHeist)
      end,
      [7] = function ()
        local MPX = tostring(get.Global(int,1312763))
        local MPx = tostring('MP'..MPX..'_')
        STATS.STAT_FAST_INT(CPHeist2)
      end,
    }
  ) 
end

function VehicleSellingMethod(sender)
  set.global(int,99007+970,tonumber(VehicleTab.CEEdit1.Text))
end

function RouletteSet()
boxstate = checkbox_getState(StatTab.RouletteSet)
  if boxstate == cbChecked then
    RouletteTimer = createTimer()
    RouletteTimer.Interval = 2000 -- 1.5 seconds
    RouletteTimer.OnTimer = function()
    CRT.SL(1641,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1642,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1643,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1644,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1645,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1646,tonumber(StatTab.RouletteNum.Text))
    CRT.SL(1789+PLAYER_ID()*33,tonumber(StatTab.RouletteBet.Text))
    StatTab.RouletteSet.Caption = "ON"
  end
  elseif boxstate == cbUnchecked then
    RouletteTimer.destroy()
    StatTab.RouletteSet.Caption = "OFF"
  end
end

function CasOption()
  local id = listbox_getItemIndex(StatTab.CAS_OPTION) + 1;
  if ReadAct(CasinoOption[id])==false then
    SetList(CasinoOption[id],true)
  elseif ReadAct(CasinoOption[id])==true then
    SetList(CasinoOption[id],false)
  end
end

function PlatLisence(sender)
  set.global(str,2462514+27+1,tostring(VehicleTab.Plat.Text))
end

function CEONameChanger()
  SetListV('CEO Name',tostring(MainTab.CEEdit10.Text))
end

function EndTask()
  closeCE()
  return caFree
end

function GlobalEditor()
  local id = combobox_getItemIndex(StatTab.GlobalType);
  local GlobalVar = StatTab.GlobalEditor.Text
  local FirstStep = GlobalVar:match("Global_([^,]+).f_")
  if FirstStep then
    local SecondIndex = GlobalVar:match("f_([^,]+).f_")
    local NextIndexFirst = GlobalVar:match("f_([^,]+)")
    local NextIndexSecond = NextIndexFirst:match(".f_([^,]+)")
    local FirstIndex
    if not SecondIndex then
      FirstIndex = GlobalVar:match("Global_([^,]+).f_")
      GlobalVar = FirstIndex.."+"..NextIndexFirst
      AddressEditor(Global_Type[id],'GA('..GlobalVar..')')
    elseif SecondIndex then
      FirstIndex = GlobalVar:match("Global_([^,]+).f_([^,]+).f_")
      GlobalVar = FirstIndex.."+"..SecondIndex.."+"..NextIndexSecond
      AddressEditor(Global_Type[id],'GA('..GlobalVar..')')
    end
  else
    AddressEditor(Global_Type[id],'GA('..tostring(StatTab.GlobalEditor.Text)..')')
  end
  GlobalReader()
end

THREAD.FUNC_1(GlobalEditor,true,2000)

function SetGlobalEditor()
  local id = combobox_getItemIndex(StatTab.GlobalType);
  SetListV(Global_Type[id],tonumber(StatTab.GlobalValue.Text))
  GlobalReader()
end

function LocalAddress()
  local id = combobox_getItemIndex(StatTab.LocalType);
  local id2 = combobox_getItemIndex(StatTab.LocalScriptNames);
  local LocalVar = StatTab.LocalEditor.Text
  local FirstLocalStep = LocalVar:match("Local_([^,]+).f_");
  if FirstLocalStep then
    local SecondIndex = LocalVar:match("f_([^,]+).f_")
    local NextIndexFirst = LocalVar:match("f_([^,]+)")
    local NextIndexSecond = NextIndexFirst:match(".f_([^,]+)")
    local FirstIndex
    if not SecondIndex then
      FirstIndex = LocalVar:match("Local_([^,]+).f_")
      LocalVar = FirstIndex.."+"..NextIndexFirst
      AddressEditor(Local_Type[id],"LA("..LocalVar..",".."'"..LocalScriptList[id2].."'"..")")
    elseif SecondIndex then
      FirstIndex = LocalVar:match("Local_([^,]+).f_([^,]+).f_")
      LocalVar = FirstIndex.."+"..SecondIndex.."+"..NextIndexSecond
    end
    AddressEditor(Local_Type[id],"LA("..LocalVar..",".."'"..LocalScriptList[id2].."'"..")")
  else
    AddressEditor(Local_Type[id],"LA("..tostring(StatTab.LocalEditor.Text)..",".."'"..LocalScriptList[id2].."'"..")")
  end
  LocalReader()
end

THREAD.FUNC_1(LocalAddress,true,2000)

function WriteLocal()
  local id = combobox_getItemIndex(StatTab.LocalType);
  SetListV(Local_Type[id],tonumber(StatTab.LocalValue.Text))
  LocalReader()
end

function AddrEditor()
  local id = MiscTab.AddressType.itemIndex+1;
  switch((id),
  {
    [1]=function ()
      --ShowMessage("Choose Address Type")
    end,
    [2]=function ()
      AddressEditor('Addr Byte',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [3]=function ()
      AddressEditor('Addr Short',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [4]=function ()
      AddressEditor('Addr Int',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [5]=function ()
      AddressEditor('Addr Long',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [6]=function ()
      AddressEditor('Addr Float',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [7]=function ()
      AddressEditor('Addr Double',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [8]=function ()
      AddressEditor('Addr String',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
    [9]=function ()
      AddressEditor('Addr AOB',tostring(MiscTab.EditAddress.Text))
      MemoryReader()
    end,
  }
)
end

THREAD.FUNC_1(AddrEditor,true,2000)

function SetAddress()
  local id = MiscTab.AddressType.itemIndex+1;
  switch((id),
  {
    [1]=function ()
      ShowMessage("Choose Address Type")
    end,
    [2]=function ()
      SetListV('Addr Byte',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [3]=function ()
      SetListV('Addr Short',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [4]=function ()
      SetListV('Addr Int',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [5]=function ()
      SetListV('Addr Long',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [6]=function ()
      SetListV('Addr Float',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [7]=function ()
      SetListV('Addr Double',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [8]=function ()
      SetListV('Addr String',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
    [9]=function ()
      SetListV('Addr AOB',tonumber(MiscTab.ValueAddress.Text))
      MemoryReader()
    end,
  }
)
end

function Struct_CEImage1MouseDown(sender, button, x, y)
Struct.dragNow()
end

function ChooseTeleportOption()
  local id = MiscTab.TeleportType.itemIndex
  switch(id,
    {
      [0] = function ( ... )
        MiscTab.TeleportList.Items.clear()
      end,
      [1] = function ()
        tbl_Locations={};
        tbl_Locations=ENTITY.GET_LOCATION();
          if tbl_Locations==nil then return end
          MiscTab.TeleportList.Items.clear()
          for c,k in pairs(tbl_Locations) do MiscTab.TeleportList.items.add(k[1]);
            MiscTab.TeleportList.setItemIndex(c-1); 
        end
      end,
      [2] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,Property_ID,1)
      end,
      [3] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,coord,1)
      end,
      [4] = function ()
        cord_arr={};
        cord_arr=READ_POS();
          if cord_arr==nil then return end
          MiscTab.TeleportList.Items.clear()
          for c,k in pairs(cord_arr) do MiscTab.TeleportList.items.add(k[1]);
            MiscTab.TeleportList.setItemIndex(c-1); 
        end
      end,
      [5] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,Treasure_Hunt,1)
      end,
      [6] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,Navy_Revolver,1)
      end,
      [7] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,Playing_Card,1)
      end,
      [8] = function ()
        FORM.ADD_LOOP(MiscTab.TeleportList,Movie_Prop,1)
      end,
    }
  )
end

function SetTeleport()
  local id = MiscTab.TeleportType.itemIndex
  local id2 = listbox_getItemIndex(MiscTab.TeleportList) + 1;
  switch(id,
    {
      [1] = function ()
        ENTITY.SET_ENTITY_COORD(tbl_Locations[id2][2],tbl_Locations[id2][3],tbl_Locations[id2][4])
      end,
      [2] = function ()
        ENTITY.SET_ENTITY_COORD(UI.GET_BLIP_COORD(Property_ID[id2][2]))
      end,
      [3] = function ()
        ENTITY.SET_ENTITY_COORD(coord[id2][2],coord[id2][3],coord[id2][4])
      end,
      [4] = function ()
        ENTITY.SET_ENTITY_COORD(cord_arr[id2][2],cord_arr[id2][3],cord_arr[id2][4])
      end,
      [5] = function ()
        ENTITY.SET_ENTITY_COORD(Treasure_Hunt[id2][2],Treasure_Hunt[id2][3],Treasure_Hunt[id2][4])
      end,
      [6] = function ()
        ENTITY.SET_ENTITY_COORD(Navy_Revolver[id2][2],Navy_Revolver[id2][3],Navy_Revolver[id2][4])
      end,
      [7] = function ()
        ENTITY.SET_ENTITY_COORD(Playing_Card[id2][2],Playing_Card[id2][3],Playing_Card[id2][4])
      end,
      [8] = function ()
        ENTITY.SET_ENTITY_COORD(Movie_Prop[id2][2],Movie_Prop[id2][3],Movie_Prop[id2][4])
      end,
    }
  )
end

function SaveTeleport()
  ENTITY.SAVE_ENTITY_CORD()
end

function CheatLoader()
  local id = PlayerData.CheatLoader.itemIndex;
  switch(id,
    {
      [1] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,Lucky_Wheel,1)
      end,
      [2] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,NClub,1)
      end,
      [3] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,Special_Cargo,1)
      end,
      [4] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,Vehicle_Cargo,1)
      end,
      [5] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,Hangar_Mission,2)
      end,
      [6] = function()
        FORM.ADD_LOOP(PlayerData.CEListBox1,MCnBunker,1)
      end,
      [7] = function ( ... )
        FORM.ADD_LOOP(PlayerData.CEListBox1,ArenaWars,1)
      end,
      [8] = function ()
        f_PrintScriptEvent('all')
      end,
      [9] = function()
        local NewThread = function()
          PlayerData.CEListBox1.Items.clear()
          for _,v in pairs(LocalScriptList) do
            local script_condition = 'Killed'
            if SCRIPT.DOES_SCRIPT_EXIST(v) == true then 
              script_condition = 'Running' 
              PlayerData.CEListBox1.items.add(string.format('%s : %s',v,script_condition))
            end
          end
        end
        ExecuteThread(NewThread)
      end,
      [10] = function()
        local SelectedRID = PlayerData.CEListBox1.itemIndex
        BFriendListptr = get.Ptr("FriendPTR")
        local TotalFriend = get.Int("TotalFriendPTR")
        PlayerData.CEListBox1.Items.clear()
        for i = 0 ,TotalFriend, 1 do
          local FriendOnlineStat = Num_To_Boolean(get.Int(BFriendListptr + FriendsOnlineStat + 0x200*i))
          local IsInGTA = Num_To_Boolean(get.Int(BFriendListptr + 0xC4 + 0x200*i) >> 1 & 1)
          local IsOnline = Num_To_Boolean(get.Int(BFriendListptr + 0xC4 + 0x200*i) & 1)
          local Status = FriendOnlineStat and 'Multiplayer' or IsInGTA and 'In GTA' or IsOnline and 'Online' or 'Offline'
          local PlayerRID = get.Long(BFriendListptr  + FriendRID + (0x200*i))
          local PlayerName = get.String(BFriendListptr + FriendName + 0x200*i)
          local TotalNumFriend = i + 1
          PlayerData.CEListBox1.items.add(string.format('[%s]%s[%s] %s',TotalNumFriend, PlayerName, PlayerRID, Status));
        end
      end,
    }
  )
end

function CheatLoader_SET()
  local id = PlayerData.CheatLoader.itemIndex;
  local id2 = listbox_getItemIndex(PlayerData.CEListBox1) + 1;
  switch(id,
    {
      [1] = function()
        local CreateThread = function()
          while id == 1 do
            set.locals(casino_lucky_wheel,Lucky_Wheel[id2][3],Lucky_Wheel[id2][4])
            SYSTEM.WAIT(1000)
          end
        end
        ExecuteThread(CreateThread)
      end,
      [2] = function ()
        set.global(int,NClub[id2][2],tonumber(PlayerData.CheatValue.Text))
      end,
      [3] = function ()
        set.global(int,Special_Cargo[id2][2],tonumber(PlayerData.CheatValue.Text))
      end,
      [4] = function ()
        set.global(int,Vehicle_Cargo[id2][2],tonumber(PlayerData.CheatValue.Text))
      end,
      [5] = function ()
        set.global(int,2540384+5188+340,Hangar_Mission[id2][1])
          if get.Global(int,2540384+5188+340) == MAX_UINT then 
            SetList('Hangar Mission Selector (Sell/Source)',false)
          else
            SetList('Hangar Mission Selector (Sell/Source)',true)
        end
      end,
      [6] = function()
        set.global(int,MCnBunker[id2][2],tonumber(PlayerData.CheatValue.Text))
      end,
      [7] = function()
        set.global(int,ArenaWars[id2][2],tonumber(PlayerData.CheatValue.Text))
      end,
      [8] = function()
      end,
      [9] = function()
      end,
      [10] = function()
        local SelectedRID = PlayerData.CEListBox1.itemIndex
        local TargetRID = tonumber(PlayerData.CheatValue.Text)
        local FriendRID = BFriendListptr  + FriendRID + (0x200*SelectedRID)
        set.int(FriendRID, TargetRID)
      end,
    }
  )
end

function SC_RareItem()
  page_id = combobox_getItemIndex(PlayerData.CEComboBox1);
  if page_id == 1 then
    set.global(int,1677993,2)
    set.global(bool,1678147,true)
  elseif page_id == 2 then
    set.global(int,1677993,4)
    set.global(bool,1678147,true)
  elseif page_id == 3 then
    set.global(int,1677993,6)
    set.global(bool,1678147,true)
  elseif page_id == 4 then
    set.global(int,1677993,7)
    set.global(bool,1678147,true)
  elseif page_id == 5 then
    set.global(int,1677993,8)
    set.global(bool,1678147,true)
  elseif page_id == 6 then
    set.global(int,1677993,9)
    set.global(bool,1678147,true)
  end
end

function PlayerData_BusinessActClickCheck(sender)
  local id = listbox_getItemIndex(ManualTab.BusinessAct) + 1;
  if ReadAct(business_controller[id])==false then 
    SetList(business_controller[id],true)
  elseif ReadAct(business_controller[id])==true then 
    SetList(business_controller[id],false)
  end
end

function VehicleResetCooldown()
  if STATS.STAT_GET_INT('MPPLY_VEHICLE_SELL_TIME')>0 then 
    STATS.STAT_SET_INT('MPPLY_VEHICLE_SELL_TIME',0)
    get_current.yield();
    STATS.STAT_SET_INT('MPPLY_NUM_CARS_SOLD_TODAY',0)
  end
end

function TeleportForward()
  ENTITY.SET_CORD('f')
end

function ChangeVehicles()
  local id,id2=VehicleTab.VehicleList.ItemIndex,VehicleTab.VehicleChanger.ItemIndex
  if id==-1 or id==0 or id2==-1 or id2==0 then return end
  set.global(int,1323678+1+(tbl_GSV[id][1]*141)+66,joaat(tbl_Vehicles[id2][1]))
  LuaEngineLog(string.format("Vehicle Changed From %s To %s",tbl_GSV[id][1],tbl_Vehicles[id2][1]))
end

bag_value = {1800,3600,5600,6400,7400,8400,MAX_INT}
function BagLimit(sender)
  local id = combobox_getItemIndex(MainTab.BagLimit);
  set.global(int,262145+29000,bag_value[id])
end

function ImportFile(sender)
  STATS.RUN_LOADER_INT()
end

function IPSpoof() --Spoofing IP from CPlayerInfo
  local player_ip_index = combobox_getItemIndex(Player_IPSpoofer);
  if player_ip_index == 1 then 
    writeBytes(CPlayerInfo + 0x6C,89,122,111,180)
    writeBytes(CPlayerInfo + 0x74,89,122,111,180)
  elseif player_ip_index == 2 then 
    writeBytes(CPlayerInfo + 0x6C,69,131,222,82)
    writeBytes(CPlayerInfo + 0x74,69,131,222,82)
  elseif player_ip_index == 3 then 
    writeBytes(CPlayerInfo + 0x6C,69,69,69,69)
    writeBytes(CPlayerInfo + 0x74,69,69,69,69)
  elseif player_ip_index == 4 then 
    writeBytes(CPlayerInfo + 0x6C,0,0,0,0)
    writeBytes(CPlayerInfo + 0x74,0,0,0,0)
  elseif player_ip_index == 5 then 
    writeBytes(CPlayerInfo + 0x6C,255,255,255,255)
    writeBytes(CPlayerInfo + 0x74,255,255,255,255)
  elseif player_ip_index == 6 then 
    writeBytes(CPlayerInfo + 0x6C,30,162,211,74)
    writeBytes(CPlayerInfo + 0x74,30,162,211,74)
  end
end

function SpawnVehicleManual()
  VEHICLE.CREATE_VEHICLE(tonumber(VehicleTab.Dist.Text),PLAYER_CORDX,PLAYER_CORDY,PLAYER_CORDZ,PLAYER_HEADINGS[1],PLAYER_HEADINGS[2],false,tostring(VehOp.SpawnManual.Text))
end

function AutomateCut85() --Automatically set heist cut to 85%
  local check = checkbox_getState(MainTab.AutomateHeistCut);
    if check == cbChecked then
      autoHeistcut(true)
    elseif check == cbUnchecked then
      autoHeistcut(false)
    end
end

function Admin_Escape()
  local check = checkbox_getState(MainTab.EscapeRoutes);
  if check == cbChecked then
    blacklist_comparing(true)
    MainTab.EscapeRoutes.Caption = "Escape : ON"
  elseif check == cbUnchecked then
    blacklist_comparing(false)
    MainTab.EscapeRoutes.Caption = "Escape : OFF"
  end
end

function SpawnerPrimaryColour()
  local colour_id = combobox_getItemIndex(VehicleTab.SpawnPrimColour) + 1;
  if colour_id == nil then
    set.global(int,2462514+27+5, 255)
    set.global(int,2462514+27+6, 255)
  else
    set.global(int,2462514+27+5, tbl_Colors[colour_id][2])
    set.global(int,2462514+27+6, tbl_Colors[colour_id][2])
  end
end

function S_WheelType()
  local type_id = VehicleTab.S_WheelType.itemIndex;
  switch(type_id,{
    [1] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Sport_W,1)
    end,
    [2] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Muscle_W,1)
    end,
    [3] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Lowrider_W,1)
    end,
    [4] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,SUV_W,1)
    end,
    [5] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Offroad_W,1)
    end,
    [6] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Tuner_W,1)
    end,
    [7] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Bike_W,1)
    end,
    [8] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,HighEnd_W,1)
    end,
    [9] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Benny_o_W,1)
    end,
    [10] = function()
      FORM.ADD_LOOP(VehicleTab.WheelIndex,Benny_b_W,1)
    end,
  }
)
end

function WheelSelection()
  local id = VehicleTab.WheelIndex.itemIndex
  local b = VehicleTab.WheelDesign.itemIndex
  local type_id = combobox_getItemIndex(VehicleTab.S_WheelType);
  if b > 0 then b=VehicleTab.WheelDesign.Items[b]:match("([^,]+):") end
  set.global(int,2462514+27+33,id+b)
end

local function TotalScriptRunning()
  local NewThread = function()
    for i = 1,#LocalScriptList do
      local total = LocalScriptList[i]
      StatTab.TotalScript.Caption = string.format('File: %s',i)
    end
  end
  ExecuteThread(NewThread)
end

TotalScriptRunning()

local function local_script_handler()
  for k,v in pairs(LocalScriptList) do
    script_list_name = v
    SCRIPT.REQUEST_SCRIPT(v)
    Wait();
  end
end

local function RunOnTick()
  local id = VehicleTab.S_WheelType.itemIndex-1;
  set.global(int,2462514+27+69,id)
  set.global(bool,2440277+4110,true)
  WheelSelection()
  SpawnerPrimaryColour()
  SpawnerXenon()
  returningValue()
  frameFlagsOnTick(t)
  SpectatorCheck()
  AntiSpectate()
  SpoilerSpawner()
  LiverySpawner()
  ZCoord = get.Float(WaypointZCoord)
  local Godmode = ReadAct("God Modes")
  local InfiniteAmmo = ReadAct("Infinites Ammos")
  local AntiAfk = ReadAct("Anti Kick AFK")
  local NoCollision = ReadAct("Pass Through Wall")
  local SetCrewToZero = ReadAct("Crew Percent to Zero")
  local RemoveCrew = ReadAct("Remove Crew Cut")
  local NeverWanted = ReadAct("Never Wanted")
  local MissionLives = ReadAct("All Mission Lives")
  local AutoHeal = ReadAct("Auto Healing")
  local VehicleGodmode = ReadAct("Veh Godmodes")

  if global_tick == 50 then
    PLAYER.SET_PLAYER_INVINCIBLE(Godmode)
    AntiAFKLobby(AntiAfk)
    RemoveCrewCutToZero(SetCrewToZero)
    CasinoHeistCrewRemove(RemoveCrew)
    AllMissionLives(MissionLives)
    ENTITY.SET_ENTITY_INVINCIBLE(Boolean_To_Num(VehicleGodmode))
  end

  if NoCollision then set.float(PLAYER_COLLISION, -1) end
  if NeverWanted then PLAYER.SET_PLAYER_WANTED_LEVEL(0) end
  AutoHealPlayer(AutoHeal)

  if global_tick == 101 then global_tick = 0 end
  if global_tick == 100 then 
    WEAPON.SET_PED_INFINITE_AMMO(InfiniteAmmo)
    if get.Int("WorldPTR")==nil or get.Global(int,262145) == nil then closeCE() end
  end

end
-----------------------------------------------------NON STOP LOOP----------------------------------------------------
local start = AsyncBegin(function()
  while (true) do
    TRY_CLAUSE {
      function()
        set.global(bool, 2440277 + 4110, true)
        local_script_handler()
      end;
      EXCEPT_CLAUSE {
        function(Error)
          LuaEngineLog('Was Caught an Error on Line 3717')
          error("Was Caught an Error on Line 3717")
        end
      }
    }
    Wait();
  end
end)
AsyncEnd(start,20);
global_tick = 0
function InfiniteLoop()
  local start = function()
    while (false) do
      TRY_CLAUSE {
        function()
          RunOnTick()
          ProcessCheck2()
          global_tick = global_tick + 1
        end;
        EXCEPT_CLAUSE {
        }
      }
      SYSTEM.WAIT(100)
    end
  end
  createThread(start)
end
--------------------------------------------------NON STOP LOOP END-------------------------------------------------

function AutoClick()
  local check = checkbox_getState(MainTab.AutoClick)
  if check == cbChecked then
    Player.AutoClick.Checked = true
    THREAD.NATIVE_LOOP(AutoClicker,TRUE,100)
  elseif check == cbUnchecked then
    Player.AutoClick.Checked = false
    THREAD.NATIVE_LOOP(AutoClicker,FALSE,100)
  end
end

function SendCommandConsole(sender)
  getConsole = DebugController.CommandSend.Text
  DebugController.CommandSend.Text = console.mScript
  if getConsole == 'clear' then
    DebugController.ConsoleOutput.clear()
    console.mOutput.clear()
  elseif getConsole == 'LocalScript' then
    local function loadlocals()
      for _,v in pairs(LocalScriptList) do
        local script_condition = 'Killed'
        if SCRIPT.DOES_SCRIPT_EXIST(v) == true then 
          script_condition = 'Running' 
          LuaEngineLog(string.format('%s : %s',v,script_condition))
        end
      end
    end
    ExecuteThread(loadlocals)
  end
end

function OpenMP3()
  if (MiscTab.MusicAccess.Checked) then
    Mp3()
  else
    Mform.destroy()
  end
end
---------------------------------------------SCRIPT END-------------------------------------------------------------------