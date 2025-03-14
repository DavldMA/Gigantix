-- Made by Im_Panik and Contributors - https://github.com/DavldMA/Gigantix
-- Show me your games here - https://devforum.roblox.com/t/gigantix-%E2%80%94-infinite-size-numbers-module/3307153/1

local Gigantix = {}

-- Notation table for suffixes used in short notation
-- You can add more notation to make the numbers go higher
local NOTATION = {
	'', 'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc',
	'UD', 'DD', 'TD', 'QaD', 'QiD', 'SxD', 'SpD', 'OcD', 'NnD', 'Vi',
	'UVg', 'DVg', 'TVg', 'QaVg', 'QiVg', 'SxVg', 'SpVg', 'OcVg', 'NoVg', 'Tg',
	'Qag', 'Qig', 'Sxg', 'Spg', 'Ocg', 'Nog', 'Ce',
	'UCe', 'DCe', 'TCe', 'QaCe', 'QiCe', 'SxCe', 'SpCe', 'OtCe', 'NvCe', 'DcCe', 'UDcCe',
	'GP'
}

local CHARACTERS = {
	"0","1","2","3","4","5","6","7","8","9",
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"!","#","$","%","&","'","(",")","","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
}


-- Lookup table for suffix multipliers
local suffixLookup = {}
for i = 1, #NOTATION do
	local v = NOTATION[i]
	suffixLookup[v:lower()] = (i - 1) * 3
end

local numbers = {}
for i, character in ipairs(CHARACTERS) do 
	numbers[character] = i - 1 
end
local base = #CHARACTERS

-- Caching global functions for performance optimization
local math_floor = math.floor
local string_rep = string.rep
local string_format = string.format
local table_concat = table.concat
local table_create = table.create
local table_insert = table.insert
local table_remove = table.remove
local table_move = table.move

-- Precompute power values to avoid repeated calculations
local powerCache = {}
for i = 1, #NOTATION do
	powerCache[i] = 10 ^ (i * 3)
end

-- Helper functions
local function getSign(blocks)
	return (blocks[#blocks] < 0) and -1 or 1
end

local function absBlocks(blocks)
	local absArr = {}
	for i, v in ipairs(blocks) do
		absArr[i] = math.abs(v)
	end
	return absArr
end

function compareAbsolute(arr1, arr2)
	local n = math.max(#arr1, #arr2)
	for i = n, 1, -1 do
		local a = arr1[i] or 0
		local b = arr2[i] or 0
		if a > b then return 1 end
		if a < b then return -1 end
	end
	return 0
end

function addNumbers(total, num)
	local maxLength = math.max(#total, #num)
	local result = table_create(maxLength + 1)
	local carry = 0
	for i = 1, maxLength do
		local a = total[i] or 0
		local b = num[i] or 0
		local sum = a + b + carry
		result[i] = sum % 1000
		carry = math_floor(sum / 1000)
	end
	if carry > 0 then
		result[maxLength + 1] = carry
	end
	return result
end

function subtractNumbers(total, num)
	local maxLength = math.max(#total, #num)
	local result = table_create(maxLength)
	local borrow = 0
	for i = 1, maxLength do
		local a = total[i] or 0
		local b = num[i] or 0
		local diff = a - b - borrow
		if diff < 0 then
			diff = diff + 1000
			borrow = 1
		else
			borrow = 0
		end
		result[i] = diff
	end
	while #result > 1 and result[#result] == 0 do
		result[#result] = nil
	end
	return result
end

-- Main Functions
--[[<strong>Convert notation like "15K" to "15000"</strong><br>
    <strong><em>Example:</em></strong>
    <code>local result = Gigantix.notationToString("15K")
    print(result) -- Output: "15000"</code>]]
function Gigantix.notationToString(notation)
	notation = notation:gsub("[,.]", "")
	local number = notation:match("[%d%.]+")
	local suffix = notation:match("%a+")
	if suffix then
		suffix = suffix:lower()
		local zerosCount = suffixLookup[suffix]
		if zerosCount then
			number = number .. string_rep("0", zerosCount)
		end
	end
	return number
end

--[[<strong>Convert a string number to an array of numbers</strong><br>
    <strong><em>Example:</em></strong>
    <code>local total = Gigantix.stringToNumber("15000")
    print(total) -- Output: {0, 15}</code>]]
function Gigantix.stringToNumber(str)
	local len = #str
	local blocksCount = math.ceil(len / 3)
	local arr = table_create(blocksCount)
	local index = 1
	for i = len, 1, -3 do
		local start = math.max(1, i - 2)
		arr[index] = tonumber(str:sub(start, i))
		index = index + 1
	end
	return arr
end

--[[<strong>Get long notation for the total number</strong><br>
    <strong><em>Example:</em></strong>
    <code>local total = Gigantix.stringToNumber("15000")
    local result = Gigantix.getLong(total)
    print(result) -- Output: "15000"</code>]]
function Gigantix.getLong(total)
	local n = #total
	local parts = table_create(n)
	for i = 1, n do
		local block = total[n - i + 1]
		parts[i] = (i == 1) and tostring(block) or string_format("%03d", block)
	end
	return table_concat(parts)
end

--[[<strong>Get short notation for the total number</strong><br>
    <strong><em>Example:</em></strong>
    <code>local total = Gigantix.stringToNumber("15000")
    local result = Gigantix.getShort(total)
    print(result) -- Output: "15K"</code>]]
function Gigantix.getShort(total)
	local numString = Gigantix.getLong(total)
	local num = tonumber(numString) or 0
	local suffixIndex = math_floor((#numString - 1) / 3) + 1
	if suffixIndex <= 0 or suffixIndex > #NOTATION then
		return numString
	end
	local divisor = powerCache[suffixIndex - 1] or 1
	local shortNum = num / divisor
	local rounded = math_floor(shortNum * 10 + 0.5) / 10
	local integerPart = math_floor(rounded)
	local fraction = rounded - integerPart
	if fraction == 0 then
		return tostring(integerPart) .. NOTATION[suffixIndex]
	else
		local firstDecimal = math_floor(fraction * 10)
		return tostring(integerPart) .. "." .. tostring(firstDecimal) .. NOTATION[suffixIndex]
	end
end

--[[<strong>Add two large numbers represented as arrays</strong><br>
    <strong><em>Example:</em></strong>
    <code>local total = Gigantix.stringToNumber("15000")
    local num = Gigantix.stringToNumber("5000")
    local resultCalc = Gigantix.add(total, num)
    local result = Gigantix.getLong(resultCalc)
    print(result) -- Output: "20000"</code>]]
function Gigantix.add(num1, num2)
	local sign1 = getSign(num1)
	local sign2 = getSign(num2)
	local abs1 = absBlocks(num1)
	local abs2 = absBlocks(num2)
	local resultAbs
	if sign1 == sign2 then
		resultAbs = addNumbers(abs1, abs2)
		resultAbs[#resultAbs] = resultAbs[#resultAbs] * sign1
	else
		if compareAbsolute(abs1, abs2) >= 0 then
			resultAbs = subtractNumbers(abs1, abs2)
			resultAbs[#resultAbs] = resultAbs[#resultAbs] * sign1
		else
			resultAbs = subtractNumbers(abs2, abs1)
			resultAbs[#resultAbs] = resultAbs[#resultAbs] * sign2
		end
	end

	if resultAbs[#resultAbs] == -0 then
		resultAbs[#resultAbs] = 0
	end

	return resultAbs
end

--[[<strong>Subtract one large number from another represented as arrays</strong><br>
    <strong><em>Example:</em></strong>
    <code>local total = Gigantix.stringToNumber("15000")
    local num = Gigantix.stringToNumber("5000")
    local resultCalc = Gigantix.subtract(total, num)
    local result = Gigantix.getLong(resultCalc)
    print(result) -- Output: "10000"</code>]]
function Gigantix.subtract(num1, num2)
	local negated = {}
	table_move(num2, 1, #num2, 1, negated)
	negated[#negated] = -negated[#negated]
	return Gigantix.add(num1, negated)
end


--[[<strong>Compare one long number with another</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("15000") 
	local isEquals = Gigantix.compareLongNumbers(num1, {0, 15})
    print(isEquals) -- Output: true</code>]]
function Gigantix.compare(num1, num2)
	if #num1 ~= #num2 then
		return false
	end

	for i = 1, #num1 do
		if num1[i] ~= num2[i] then
			return false
		end
	end

	return true
end


--[[<strong>Encode a string of numbers, to reduce the character length size</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num = Gigantix.encodeNumber("1000000")
    print(num) -- Output: "1xFa"</code>]]
function Gigantix.encodeNumber(value)
	local sign = ""
	if value:sub(1, 1) == "-" then
		sign = "-"
		value = value:sub(2)
	end

	local text = ""
	local carry = 0
	local digits = {}

	for i = 1, #value do
		table_insert(digits, tonumber(value:sub(i, i)))
	end

	while #digits > 0 do
		carry = 0
		local newDigits = {}
		for _, digit in ipairs(digits) do
			local num = carry * 10 + digit
			table_insert(newDigits, math.floor(num / base))
			carry = num % base
		end
		text = CHARACTERS[carry + 1] .. text

		while #newDigits > 0 and newDigits[1] == 0 do
			table_remove(newDigits, 1)
		end
		digits = newDigits
	end

	return sign .. text
end


--[[<strong>Decode a string of characters that was encoded by Gigantix.encodeNumber()</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num = Gigantix.decodeNumber("1xFa")
    print(num) -- Output: "1000000"</code>]]
function Gigantix.decodeNumber(value)
	local sign = ""
	if value:sub(1, 1) == "-" then
		sign = "-"
		value = value:sub(2)
	end

	local text = ""
	local number = {0}

	for i = 1, #value do
		local character = value:sub(i, i)
		local digitValue = numbers[character]
		local carry = digitValue

		for j = #number, 1, -1 do
			local num = number[j] * base + carry
			number[j] = num % 10
			carry = math.floor(num / 10)
		end

		while carry > 0 do
			table_insert(number, 1, carry % 10)
			carry = math.floor(carry / 10)
		end
	end

	for _, digit in ipairs(number) do
		text = text .. digit
	end

	return sign .. text
end

return Gigantix
