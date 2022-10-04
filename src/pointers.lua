require("MemoryController")
require("StatController")
require("ArrayData")
require("LocalScript")

hook = 
{
    GET = function (Address)
        return getAddress(Address)
    end,

    ptrs = function (Pointers)
        return readPointer(Pointers)
    end,

};


-----------------Auto Add----------------------------------------------------------------------------------------
function auto_add()
  MPX = get.Global(int,1312763)
  local mp_id = combobox_getItemIndex(Protection_CEComboBox12) + 1;
	if mp_id==1 then
    FORM.ADD_LOOP(Protection_CEComboBox1,MP0_Approach,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox2,MP0_TARGET,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox3,MP0_LAST_AP,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox4,MP0_HARD_AP,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox5,MP0_DUGGAN,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox6,MP0_PASS,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox7,MP0_WEP,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox8,MP0_DRIVER,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox9,MP0_HACKER,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox10,MP0_VEH,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox11,MP0_WEPS,1)
  elseif mp_id==2 then
    FORM.ADD_LOOP(Protection_CEComboBox1,MP_Cayo_Approach,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox2,MP_Cayo_Target,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox3,MP_Cayo_Diff,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox4,MP_Cayo_Truck,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox5,MP_Cayo_Disrp,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox6,MP_Cayo_Weapon,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox7,NULL_ARRAY,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox8,NULL_ARRAY,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox9,NULL_ARRAY,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox10,NULL_ARRAY,1)
    sleep(10)
    FORM.ADD_LOOP(Protection_CEComboBox11,NULL_ARRAY,1)
  end
end
---------------------------------------------------Pointer Struct-------------------------------------------------------
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
--auto_add()


