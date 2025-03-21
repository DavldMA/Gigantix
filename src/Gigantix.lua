-- Made by Im_Panik and Contributors - https://github.com/DavldMA/Gigantix
-- Show me your games here - https://devforum.roblox.com/t/gigantix-%E2%80%94-infinite-size-numbers-module/3307153/1
-- Some of the code was inspired or even merged from the fork - https://github.com/Artheriax/Gigantix-Plus
-- (if u are the original author and don't want for your code to be used, please contact me)
local Gigantix = {}

-- Notation table for suffixes used in short notation
-- You can add more notation to make the numbers go higher
local NOTATION = {
	'',    -- 10^0 (1)
	'K',   -- 10^3 (Thousand)
	'M',   -- 10^6 (Million)
	'B',   -- 10^9 (Billion)
	'T',   -- 10^12 (Trillion)
	'Qa',  -- 10^15 (Quadrillion)
	'Qi',  -- 10^18 (Quintillion)
	'Sx',  -- 10^21 (Sextillion)
	'Sp',  -- 10^24 (Septillion)
	'Oc',  -- 10^27 (Octillion)
	'No',  -- 10^30 (Nonillion)
	'Dc',  -- 10^33 (Decillion)
	'UD',  -- 10^36 (Undecillion)
	'DD',  -- 10^39 (Duodecillion)
	'TD',  -- 10^42 (Tredecillion)
	'QaD', -- 10^45 (Quattuordecillion)
	'QiD', -- 10^48 (Quindecillion)
	'SxD', -- 10^51 (Sedecillion)
	'SpD', -- 10^54 (Septendecillion)
	'OcD', -- 10^57 (Octodecillion)
	'NnD', -- 10^60 (Novendecillion)
	'Vi',  -- 10^63 (Vigintillion)
	'UVg', -- 10^66 (Unvigintillion)
	'DVg', -- 10^69 (Duovigintillion)
	'TVg', -- 10^72 (Tresvigintillion)
	'QaVg',-- 10^75 (Quattuorvigintillion)
	'QiVg',-- 10^78 (Quinvigintillion)
	'SxVg',-- 10^81 (Sesvigintillion)
	'SpVg',-- 10^84 (Septemvigintillion)
	'OcVg',-- 10^87 (Octovigintillion)
	'NoVg',-- 10^90 (Novemvigintillion)
	'Tg',  -- 10^93 (Trigintillion)
	'Qag', -- 10^123 (Quadragintillion)
	'Qig', -- 10^153 (Quinquagintillion)
	'Sxg', -- 10^183 (Sexagintillion)
	'Spg', -- 10^213 (Septuagintillion)
	'Ocg', -- 10^243 (Octogintillion)
	'Nog', -- 10^273 (Nonagintillion)
	'Ce',  -- 10^303 (Centillion)
	'UCe', -- 10^306 (Uncentillion)
	'DCe', -- 10^309 (Duocentillion)
	'TCe', -- 10^312 (Trecentillion)
	'QaCe',-- 10^315 (Quattuorcentillion)
	'QiCe',-- 10^318 (Quincentillion)
	'SxCe',-- 10^321 (Sexcentillion)
	'SpCe',-- 10^324 (Septencentillion)
	'OtCe',-- 10^327 (Octocentillion)
	'NvCe',-- 10^330 (Novemcentillion)
	'DcCe',-- 10^333 (Decicentillion)
	'UDcCe',-- 10^336 (Undecicentillion)
	'TDcCe',-- 10^339 (Tredecicentillion)
	'QaDcCe',-- 10^342 (Quattuordecicentillion)
	'QiDcCe',-- 10^345 (Quindecicentillion)
	'SxDcCe',-- 10^348 (Sedecicentillion)
	'SpDcCe',-- 10^351 (Septendecicentillion)
	'OtDcCe',-- 10^354 (Octodecicentillion)
	'NvDcCe',-- 10^357 (Novemdecicentillion)
	'ViCe',-- 10^360 (Viginticentillion)
}

-- Possible feature
-- 	'8'    -- Infinity (for numbers beyond 10^360)

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

local base = #CHARACTERS
local numbers = {}
for i, character in ipairs(CHARACTERS) do 
	numbers[character] = i - 1 
end


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
-- Gets the sign of a block
local function getSign(blocks)
	return (blocks[#blocks] < 0) and -1 or 1
end

-- This is useful when you want to compare the
-- magnitude of numbers without considering their sign
local function absBlocks(blocks)
	local absArr = {}
	for i, v in ipairs(blocks) do
		absArr[i] = math.abs(v)
	end
	return absArr
end

-- This function helps determine which of two large numbers 
-- (ignoring their sign) is larger, or if they are equal
local function compareAbsolute(arr1, arr2)
	local maxLength = math.max(#arr1, #arr2)
	for i = maxLength, 1, -1 do
		local a = arr1[i] or 0
		local b = arr2[i] or 0
		if a > b then return 1 end
		if a < b then return -1 end	
	end
	return 0
end

-- Compares two numbers and returns 1 if the first number is greater
-- 0 if they are equal, and -1 if the second number is greater
local function compareNumbers(num1, num2)
	local sign1 = getSign(num1)
	local sign2 = getSign(num2)
	
	-- If the signs differ, the negative number is smaller
	if sign1 > sign2 then 
		return 1 
	elseif sign1 < sign2 then 
		return -1 
	end

	-- Both numbers have the same sign; compare their absolute values.
	local cmp = compareAbsolute(absBlocks(num1), absBlocks(num2))
	
	-- For negative numbers, reverse the comparison.
	if sign1 < 0 then 
		cmp = -cmp 
	end
	return cmp
end

-- It just adds two numbers together
local function addNumbers(num1, num2)
	local maxLength = math.max(#num1, #num2)
	local result = table_create(maxLength + 1)
	local carry = 0
	for i = 1, maxLength do
		local a = num1[i] or 0
		local b = num2[i] or 0
		local sum = a + b + carry
		result[i] = sum % 1000
		carry = math_floor(sum / 1000)
	end
	if carry > 0 then
		result[maxLength + 1] = carry
	end
	return result
end

-- It just subtracts two numbers
local function subtractNumbers(num1, num2)
	local maxLength = math.max(#num1, #num2)
	local result = table_create(maxLength)
	local borrow = 0
	for i = 1, maxLength do
		local a = num1[i] or 0
		local b = num2[i] or 0
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

-- divides a big number by a small number, 
-- returning the quotient and the remainder,
-- to help on the multiply function
function divideBySmall(num, divisor)
	local quotientRev = {} 
	local remainder = 0
	for i = #num, 1, -1 do
		local current = remainder * 1000 + num[i]
		local q = math.floor(current / divisor)
		remainder = current % divisor
		table.insert(quotientRev, q)
	end

	local quotient = {}
	for i = #quotientRev, 1, -1 do
		table.insert(quotient, quotientRev[i])
	end
	while #quotient > 1 and quotient[#quotient] == 0 do
		table.remove(quotient)
	end
	return quotient, remainder
end

-- Main Functions
--[[<strong>Convert notation to String</strong><br>
    <strong><em>Example:</em></strong>
    <code>local result = Gigantix.notationToString("15K", true)
    print(result) -- Output: "15000"</code>]]
function Gigantix.notationToString(notation, isEncoded)
	if isEncoded then
		notation = Gigantix.decodeNumber(notation)
	end
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
    <code>local num = Gigantix.stringToNumber("15000", true)
    print(num) -- Output: {0, 15}</code>]]
function Gigantix.stringToNumber(str, isEncoded)
	if isEncoded then
		str = Gigantix.decodeNumber(str)
	end
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

--[[<strong>Get long notation for the number</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num = Gigantix.stringToNumber("15000")
    local result = Gigantix.getLong(num, true)
    print(result) -- Output: "15000"</code>]]
function Gigantix.getLong(num, isEncoded)
	if isEncoded then
		-- Assume num is an encoded string that must be decoded and converted to an array
		num = Gigantix.stringToNumber(Gigantix.decodeNumber(num))
	end
	local n = #num
	local parts = table_create(n)
	for i = 1, n do
		local block = num[n - i + 1]
		parts[i] = (i == 1) and tostring(block) or string_format("%03d", block)
	end
	return table_concat(parts)
end

--[[<strong>Get short notation for the number</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num = Gigantix.stringToNumber("15000")
    local result = Gigantix.getShort(num, true)
    print(result) -- Output: "15K"</code>]]
function Gigantix.getShort(num, isEncoded)
	if isEncoded then
		num = Gigantix.stringToNumber(Gigantix.decodeNumber(num))
	end
	local numString = Gigantix.getLong(num)
	local numVal = tonumber(numString) or 0
	local suffixIndex = math_floor((#numString - 1) / 3) + 1
	if suffixIndex <= 0 or suffixIndex > #NOTATION then
		return numString
	end
	--[[ possible feature
	if suffixIndex > #NOTATION then
		return "8"
	end]]
	local divisor = powerCache[suffixIndex - 1] or 1
	local shortNum = numVal / divisor
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
    <code>local num1 = Gigantix.stringToNumber("15000", true)
    local num2 = Gigantix.stringToNumber("5000", true)
    local resultCalc = Gigantix.add(num1, num2, true)
    local result = Gigantix.getLong(resultCalc)
    print(result) -- Output: "20000"</code>]]
function Gigantix.add(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
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
    <code>local num1 = Gigantix.stringToNumber("15000", true)
    local num2 = Gigantix.stringToNumber("5000", true)
    local resultCalc = Gigantix.subtract(num1, num2, true)
    local result = Gigantix.getLong(resultCalc)
    print(result) -- Output: "10000"</code>]]
function Gigantix.subtract(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	local negated = {}
	table_move(num2, 1, #num2, 1, negated)
	negated[#negated] = -negated[#negated]
	return Gigantix.add(num1, negated)
end

--[[<strong>Multiplies two large numbers represented as arrays</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("5000", true)
    local num2 = Gigantix.stringToNumber("2", true)
    local resultCalc = Gigantix.multiply(num1, num2, true)
    local result = Gigantix.getLong(resultCalc)
    print(result) -- Output: "10000"</code>]]
function Gigantix.multiply(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		if type(num2) == "string" then
			num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
		end
	end
	
	if type(num2) == "table" then
		local sign1 = getSign(num1)
		local sign2 = getSign(num2)
		local resultSign = sign1 * sign2

		local abs1 = absBlocks(num1)
		local abs2 = absBlocks(num2)
		local resultLength = #abs1 + #abs2
		local result = table_create(resultLength)
		for i = 1, resultLength do
			result[i] = 0
		end

		for i = 1, #abs1 do
			for j = 1, #abs2 do
				result[i+j-1] = result[i+j-1] + abs1[i] * abs2[j]
			end
		end

		for i = 1, #result do
			local carry = math_floor(result[i] / 1000)
			result[i] = result[i] % 1000
			if carry > 0 then
				if i+1 <= #result then
					result[i+1] = result[i+1] + carry
				else
					table_insert(result, carry)
				end
			end
		end

		while #result > 1 and result[#result] == 0 do
			table_remove(result)
		end

		result[#result] = result[#result] * resultSign
		return result
		
	elseif type(num2) == "number" then
		local factor = num2
		local sign1 = getSign(num1)
		local resultSign = sign1 * (factor >= 0 and 1 or -1)
		local absFactor = math.abs(factor)

		local factorStr = tostring(absFactor)
		local integerPart, fractionalPart = factorStr:match("^(%d+)%.?(%d*)$")
		fractionalPart = fractionalPart or ""
		local d = #fractionalPart 
		local multiplierInt = tonumber(integerPart .. fractionalPart)
		local multiplierGig = Gigantix.stringToNumber(tostring(multiplierInt), false)
		local product = Gigantix.multiply(num1, multiplierGig, false)

		local divisor = 10^d
		local quotient, remainder = divideBySmall(product, divisor)

		if remainder * 2 >= divisor then
			local one = Gigantix.stringToNumber("1", false)
			quotient = Gigantix.add(quotient, one, false)
		end

		quotient[#quotient] = quotient[#quotient] * resultSign
		return quotient
	else
		error("Unsupported type for multiplication operand")
	end
end


--[[<strong>Compare one long number with another returns true if equal</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("15000", true)
    local isEquals = Gigantix.isEquals(num1, {0, 15}, true)
    print(isEquals) -- Output: true</code>]]
function Gigantix.isEquals(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	return compareNumbers(num1, num2) == 0
end

--[[<strong>Compare one long number with another returns true if lesser</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("5000", true)
    local isLesser = Gigantix.isLesser(num1, {0, 15}, true)
    print(isLesser) -- Output: true</code>]]
function Gigantix.isLesser(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	return compareNumbers(num1, num2) == -1
end

--[[<strong>Compare one long number with another returns true if greater</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("150000", true)
    local isGreater = Gigantix.isGreater(num1, {0, 15}, true)
    print(isGreater) -- Output: true</code>]]
function Gigantix.isGreater(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	return compareNumbers(num1, num2) == 1
end

--[[<strong>Compare one long number with another returns true if is greater or equals</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("150000", true)
    local isGreaterOrEquals = Gigantix.isGreaterOrEquals(num1, {0, 15}, true)
    print(isGreaterOrEquals) -- Output: true</code>]]
function Gigantix.isGreaterOrEquals(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	return (Gigantix.isGreater(num1, num2) or Gigantix.isEquals(num1, num2))
end

--[[<strong>Compare one long number with another returns true if is lesser or equals</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num1 = Gigantix.stringToNumber("15000", true)
    local isLesserOrEquals = Gigantix.isLesserOrEquals(num1, {0, 15}, true)
    print(isLesserOrEquals) -- Output: true</code>]]
function Gigantix.isLesserOrEquals(num1, num2, isEncoded)
	if isEncoded then
		num1 = Gigantix.stringToNumber(Gigantix.decodeNumber(num1))
		num2 = Gigantix.stringToNumber(Gigantix.decodeNumber(num2))
	end
	return (Gigantix.isLesser(num1, num2) or Gigantix.isEquals(num1, num2))
end

--[[<strong>Returns true if the number is negative</strong><br>
    <strong><em>Example:</em></strong>
    <code>local num = Gigantix.stringToNumber("-15000", true)
    local isNegative = Gigantix.isNegative(num, true)
    print(isNegative) -- Output: true</code>]]
function Gigantix.isNegative(num, isEncoded)
	if isEncoded then
		num = Gigantix.stringToNumber(Gigantix.decodeNumber(num))
	end
	return num[#num] < 0
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