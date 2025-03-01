local Gigantix = {}

-- Notation table for suffixes used in short notation
local NOTATION = {
	'', 'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc',
	'UD', 'DD', 'TD', 'QaD', 'QiD', 'SxD', 'SpD', 'OcD', 'NnD', 'Vi',
	'UVg', 'DVg', 'TVg', 'QaVg', 'QiVg', 'SxVg', 'SpVg', 'OcVg', 'NoVg', 'Tg',
	'Qag', 'Qig', 'Sxg', 'Spg', 'Ocg', 'Nog', 'Ce',
	'UCe', 'DCe', 'TCe', 'QaCe', 'QiCe', 'SxCe', 'SpCe', 'OtCe', 'NvCe', 'DcCe', 'UDcCe',
	'GP'
}

-- Lookup table for suffix multipliers
local suffixLookup = {}
for i = 1, #NOTATION do
	local v = NOTATION[i]
	suffixLookup[v:lower()] = (i - 1) * 3
end


-- Caching global functions for performance optimization
local math_floor = math.floor
local string_rep = string.rep
local string_format = string.format
local table_concat = table.concat
local table_create = table.create

-- Precompute power values to avoid repeated calculations
local powerCache = {}
for i = 1, #NOTATION do
	powerCache[i] = 10 ^ (i * 3)
end

--[[ 
    Convert notation like "15K" to "15000"
    Example:
    local result = Gigantix.convertNotationToNumber("15K")
    print(result) -- Output: "15000"
]]
function Gigantix.convertNotationToNumber(notation: string): string
	-- Remove commas or periods used as thousand separators
	notation = notation:gsub("[,.]", "")

	-- Extract numeric and suffix parts
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

--[[ 
    Convert a string number to an array of numbers
    Example:
    local total = Gigantix.convertStringToArrayNumber("15000")
    print(total) -- Output: {15, 0, 0}
]]
function Gigantix.convertStringToArrayNumber(num: string): {number}
	local len = #num
	local blocksCount = math.ceil(len / 3)
	local arr = table_create(blocksCount)
	local index = 1

	for i = len, 1, -3 do
		local start = math.max(1, i - 2)
		arr[index] = tonumber(num:sub(start, i))
		index = index + 1
	end

	return arr
end

--[[ 
    Get short notation for a large number
    Example:
    local total = Gigantix.convertStringToArrayNumber("15000")
    local result = Gigantix.getShortNotation(total)
    print(result) -- Output: "15K"
]]
function Gigantix.getShortNotation(total: {number}): string
	local numString = Gigantix.getLongNotation(total)
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

--[[ 
    Get long notation for a large number
    Example:
    local total = Gigantix.convertStringToArrayNumber("15000")
    local result = Gigantix.getLongNotation(total)
    print(result) -- Output: "15000"
]]
function Gigantix.getLongNotation(total: {number}): string
	local n = #total
	local parts = table_create(n)

	for i = 1, n do
		local block = total[n - i + 1]
		parts[i] = (i == 1) and tostring(block) or string_format("%03d", block)
	end

	return table_concat(parts)
end

--[[ 
    Add two large numbers represented as arrays
    Example:
    local total = Gigantix.convertStringToArrayNumber("15000")
    local num = Gigantix.convertStringToArrayNumber("5000")
    local resultCalc = Gigantix.addLargeNumbers(total, num)
    local result = Gigantix.getLongNotation(resultCalc)
    print(result) -- Output: "20000"
]]
function Gigantix.addLargeNumbers(total: {number}, num: {number}): {number}
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

--[[ 
    Subtract one large number from another represented as arrays
    Example:
    local total = Gigantix.convertStringToArrayNumber("15000")
    local num = Gigantix.convertStringToArrayNumber("5000")
    local resultCalc = Gigantix.subtractLargeNumbers(total, num)
    local result = Gigantix.getLongNotation(resultCalc)
    print(result) -- Output: "10000"
]]
function Gigantix.subtractLargeNumbers(total: {number}, num: {number}): {number}
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

return Gigantix
