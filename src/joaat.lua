function UInt32(num)
  return num & 0xFFFFFFFF;
end

function Int32(num)
  local n = num & 0xFFFFFFFF;
  return 0 ~= (n & 0x80000000) and n - 0x100000000 or n;
end

function Signed32bit(num)
  return num | 0xffffffff00000000 
end

function Int64(num)
  local n = num & 0xFFFFFFFFFFFFFFFF;
  return 0 ~= (n & 0x8000000000000000) and n - 0x10000000000000000 or n;
end

function UInt8(num)
	return num & 0xff
end

function Int8(num)
  local n = num & 0xFF;
  return 0 ~= (n & 0x80) and n - 0x100 or n;
end

function UInt16(num)
	return num & 0xffff
end

function Int16(num)
  local n = num & 0xFFFF;
  return 0 ~= (n & 0x8000) and n - 0x10000 or n;
end

function UInt64(num)
  return num & 0xFFFFFFFFFFFFFFFF;
end

function Boolean_To_Num(var)
  return var and 1 or 0
end

function Num_To_Boolean(var)
  return var == 1 and true or false
end

function Hex(num)
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

function StrToBoolean(var)
  return var == 'true' and true or var == 'TRUE' and true or var == 'false' and false or var == 'FALSE' and false
end

function MAKEWORD(a,b)
  return (a & 0xff | b & 0xff) << 8
end

function MAKELONG(a,b)
  return (a & 0xffff | b & 0xffff) << 16
end

function Day(Milisecond)
  x = Milisecond / 1000
  seconds = x % 60
  x = x / 60
  minutes = x % 60
  x = x / 60
  hours = x % 24
  x = x / 24
  days = math.ceil(x)
  return days
end

function char(chr)
  return string.byte(chr)
end
--[[
  if (c >= char('A') and c <= char('Z')) then
    c = c + (char('a') - char('A'));
  else 
    c = c;
  end
  return c;
]]

--[[private static int joaat_to_lower(char c) {
return (c >= 'A' && c <= 'Z') ? c + ('a' - 'A') : c;
shifting : x = x * 2 ^ y
]]

--using joaat_t = std::uint32_t;
	--inline constexpr char joaat_to_lower(char c)
	--{
		--return (c >= 'A' && c <= 'Z') ? c + ('a' - 'A') : c;
	--}
--case insensitive for joaat hasher
function tolower(c)
  return (c >= char('A') and c <= char('Z')) and c + (char('a') - char('A')) or c
end

--Usage:joaat("Hash Name")
function joaat(str)
  hash, str = 0 or InitialHash, str or ''
  for i = 1, str:len() do
    hash = hash + tolower(str:byte(i));
    hash = hash + (hash << 10);
    hash = hash ~ (UInt32(hash) >> 6);
  end

  hash = hash + (hash << 3);
  hash = hash ~ (UInt32(hash) >> 11);
  hash = hash + (hash << 15);
  return UInt32(hash)
end
--auto to_upper = [](char c) -> char
		--{
			--return c >= 'a' && c <= 'z' ? static_cast<char>(c + ('A' - 'a')) : static_cast<char>(c);
		--};
function toupper(c)
  return (c >= char('a') and c <= char('z')) and c + (char('A') - char('a')) or c
end
--Usage:RAGE_JOAAT("Hash Name")
--define RAGE_JOAAT(str) (std::integral_constant<rage::joaat_t, RAGE_JOAAT_IMPL(str)>::value)
	--inline joaat_t joaat(const char *str)
	--{
		--joaat_t hash = 0;
		--while (*str)
		--{
			--hash += joaat_to_lower(*(str++));
			--hash += (hash << 10);
			--hash ^= (hash >> 6);
		--}
		--hash += (hash << 3);
		--hash ^= (hash >> 11);
		--hash += (hash << 15);
		--return hash;
	--}
--}
RAGE_JOAAT = function(str)
    local hash = 0;
    for i = 1, str:len() do
        hash = hash + tolower(str:byte(i));
        hash = hash + (hash << 10);
        hash = UInt32(hash);
        hash = hash ~ (hash >> 6);
    end
    hash = hash + (hash << 3);
    hash = UInt32(hash);
    hash = hash ~ (hash >> 11);
    hash = hash + (hash << 15);
    return UInt32(hash);
end

GAMEPLAY = 
{

  GetHashKeySubString = function(str, initialHash)
      local hash = initialHash or 0;
      for i = 1, str:len() do
          hash = hash + tolower(str:byte(i));
          hash = hash + (hash << 10);
          hash = hash ~ (UInt32(hash) >> 6)
      end
      return UInt32(hash)
  end;

  GetHashKeyFinalize = function(str, initialHash)
      local hash = initialHash or 0;
      local  hash = GAMEPLAY.GetHashKeySubString(str, initialHash);
      hash = hash + (hash << 3);
      hash = hash ~ (UInt32(hash) >> 11);
      hash = hash + (hash << 15);
      return UInt32(hash)
  end;
  ---usage GAMEPLAY.GET_HASH_KEY("hash here")
  GET_HASH_KEY = function(str, concat, initialHash)
      local hash = initialHash or 0;
      if type(concat) == "string" then
          return GAMEPLAY.GetHashKeyFinalize(concat, GAMEPLAY.GetHashKeySubString(str, initialHash));
      else
          return GAMEPLAY.GetHashKeyFinalize(str, initialHash);
      end
  end;
};

local xlat = {
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
        0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F,
        0x40, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F,
        0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x5B, 0x2F, 0x5D, 0x5E, 0x5F,
        0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F,
        0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F,
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F,
        0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F,
        0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF,
        0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF,
        0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF,
        0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF,
        0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF,
        0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF,
    }
 
local mask32 = 0xffffffff
function joaat_t(str, hash, XLAT, finishing)
  finishing = finishing~= false and true
  if type(str)=='table'then
    local ok, s = pcall(byteTableToString,str)
    if ok and #s == #str then str = s  else return nil,"can't convert byte table to str." end
  end
  hash, str = hash or 0, str or ''
  if XLAT then
    for i=1,#str do
      hash = hash + XLAT[str:byte(i)+1]
      hash = hash + (hash << 10 )
      hash = hash ~ (Int32(hash) >> 6)
    end
  else
    for i=1,#str do
      hash = hash + xlat[str:byte(i)+1]
      hash = hash + (hash  << 10 )
      hash = hash ~ (Int32(hash) >> 6)
    end
  end
  --print('>>',string.format('%X %d',hash,hash))
  if finishing then
    hash = hash + (hash  << 3)
    hash = hash ~ (Int32(hash) >> 11)
    hash = hash + (hash  << 15)
  end
  return Int32(hash)
end

function reverse_joaat(hash)
  hash = hash * 0x3FFF8001
  hash = hash ~ (UInt32(hash) >> 11) ~ (UInt32(hash) >> 22)
  hash = hash * 0x38E38E39
  hash = (hash ~ (UInt32(hash) >> 6)) ~ (UInt32(hash) >> 12) ~ (UInt32(hash) >> 18) ~ (UInt32(hash) >> 24) ~ (UInt32(hash) >> 30)
  hash = hash * 0xC00FFC01
  return UInt32(hash)
end

function findDuplicates()
  seen = {} --keep record of elements we've seen
  duplicated = {} --keep a record of duplicated elements
  actual_hash = {} --Cleaning Hash Map Data
  for i = 1, #Hash do
      element = Hash[i]
      --UInt64(element)
      if seen[element] then  --check if we've seen the element before
          duplicated[element] = true --if we have then it must be a duplicate! add to a table to keep track of this
      else
          seen[element] = true -- set the element to seen
          actual_hash[i] = element
          print(actual_hash[i])
      end
  end
  return duplicated
end
--createNativeThread(findDuplicates)
--[[for k, v in pairs(actual_hash) do

  print(seen)
end]]



































--[[

   --str = str:lower();
  local m_LookupTable = {
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
        0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F,
        0x40, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F,
        0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x5B, 0x2F, 0x5D, 0x5E, 0x5F,
        0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F,
        0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F,
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F,
        0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F,
        0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF,
        0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF,
        0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF,
        0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF,
        0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF,
        0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF,
    };]]
    --[[def getJenkinHash(ba : bytearray):
    hash : int = 0
    for i in range(len(ba)):
        hash = hash + ba[i]
        hash = hash & 0xFFFFFFFF
        hash = hash + (hash << 10)
        hash = hash & 0xFFFFFFFF
        hash ^= (hash >> 6)
        hash = hash & 0xFFFFFFFF
    hash = hash + (hash << 3)
    hash = hash & 0xFFFFFFFF
    hash ^= (hash >> 11)
    hash = hash & 0xFFFFFFFF
    hash = hash + (hash << 15)
    hash = hash & 0xFFFFFFFF
    return hash
]]

--[[
    local MethLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(0*12))
  local WeedLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(1*12))
  local CokeLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(2*12))
  local CashLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(3*12))
  local DocLocation = get.Global(int,1590682+1+(iVar0[selected_player]*883)+274+183+1+(4*12))
  PlayerMoney.Text = string.format('Bank: $ %s | Cash: $ %s | Organization:%s',ListBanked,ListCash,ListOrgName)
  PlayerDynamicIP.Text = string.format('IP : %s.%s.%s.%s:%s',IPR4,IPR3,IPR2,IPR1,PPort)
  PlayerStaticIP.Text  = string.format('IP Lan : %s.%s.%s.%s:%s',IPRL4,IPRL3,IPRL2,IPRL1,PPort)
  Player_Board_Status.Text = string.format('Board:%s | Key:%s | Duggan:%s',board_status,security_pass,duggan_level)
]]