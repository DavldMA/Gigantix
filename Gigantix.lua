local Gigantix = {}


local NOTATION = {
	'', 'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc', 
	'UD', 'DD', 'TD', 'QaD', 'QiD', 'SxD', 'SpD', 'OcD', 'NnD', 'Vi',
	'UVg', 'DVg', 'TVg', 'QaVg', 'QiVg', 'SxVg', 'SpVg', 'OcVg', 'NoVg', 'Tg',
	'Qag', 'Qig', 'Sxg', 'Spg', 'Ocg', 'Nog', 'Ce',
	'UCe', 'DCe', 'TCe', 'QaCe', 'QiCe', 'SxCe', 'SpCe', 'OtCe', 'NvCe', 'DcCe', 'UDcCe',
	'GP'
}


--[[<strong>Convert notation like "15K" to "15000"</strong><br>
    <em>Example:</em><br>
    <code>local result = Gigantix.convertNotationToNumber("15K")</code><br>
    <code>print(result) -- Output: "15000"</code>]]
function Gigantix.convertNotationToNumber(notation: string): string
	-- Remove commas or periods used as thousand separators
	notation = notation:gsub("[,.]", "")

	local number = tonumber(notation:match("[%d%.]+"))  -- Match digits and decimal points
	local suffix = notation:match("%a+")  -- Match suffix if present
	local multiplier = 1

	if suffix then
		suffix = suffix:lower()  -- Convert suffix to lowercase
		for i, v in ipairs(NOTATION) do
			if v:lower() == suffix then  -- Compare in lowercase
				multiplier = 10 ^ ((i - 1) * 3)
				break
			end
		end
	end

	return tostring(number * multiplier)
end


--[[<strong>Convert a string number to an array of numbers</strong><br>
    <em>Example:</em><br>
    <code>local total = Gigantix.convertStringToArrayNumber("15000")</code><br>
    <code>print(total) -- Output: {15, 0, 0}</code>]]
function Gigantix.convertStringToArrayNumber(num: string): {string}
	local arr = {}

	while num ~= "" do
		if #num < 3 then
			table.insert(arr, tonumber(num))
			num = ""
			break
		end

		table.insert(arr, tonumber(num:sub(-3)))
		num = num:sub(1, -4)
	end
	return arr
end


--[[<strong>Get short notation for the total number</strong><br>
    <em>Example:</em><br>
    <code>local total = Gigantix.convertStringToArrayNumber("15000")</code><br>
    <code>local result = Gigantix.getShortNotation(total)</code><br>
    <code>print(result) -- Output: "15K"</code>]]
function Gigantix.getShortNotation(total: {string}, ignoreDigits: number?): string
	local numString = Gigantix.getLongNotation(total)
	local num = tonumber(numString)
	local ignoreDigits = ignoreDigits or 0
	local suffixIndex = math.floor((#numString - 1 - ignoreDigits) / 3) + 1
	if suffixIndex <= 0 then
		return numString
	end

	local shortNum = num / (10 ^ ((suffixIndex - 1) * 3))
	local shortNumString = string.format("%.10f", shortNum)  -- Ensure enough precision
	local integerPart, decimalPart = shortNumString:match("(%d+)%.(%d)")
	if decimalPart == "0" then
		return integerPart .. NOTATION[suffixIndex]
	else
		return integerPart .. "." .. decimalPart .. NOTATION[suffixIndex]
	end

end



--[[<strong>Get long notation for the total number</strong><br>
    <em>Example:</em><br>
    <code>local total = Gigantix.convertStringToArrayNumber("15000")</code><br>
    <code>local result = Gigantix.getLongNotation(total)</code><br>
    <code>print(result) -- Output: "15000"</code>]]
function Gigantix.getLongNotation(total: {string}): string
	local temp = {table.unpack(total)}
	local numString = ""

	while #temp > 0 do
		local num = table.remove(temp)
		numString = numString .. string.format("%03d", num)
	end

	for i = 1, #numString do
		if numString:sub(i, i) ~= "0" then
			numString = numString:sub(i)
			break
		end
	end

	return numString
end


--[[<strong>Add two large numbers represented as arrays</strong><br>
    <em>Example:</em><br>
    <code>local total = Gigantix.convertStringToArrayNumber("15000")</code><br>
    <code>local num = Gigantix.convertStringToArrayNumber("5000")</code><br>
    <code>local resultCalc = Gigantix.addLargeNumbers(total, num)</code><br>
    <code>local result = Gigantix.getLongNotation(resultCalc)</code><br>
    <code>print(result) -- Output: "20000"</code>]]
function Gigantix.addLargeNumbers(total: {string}, num: {string}): {string}
	local result = {}
	local carry = 0

	local totalCopy = {table.unpack(total)}
	local numCopy = {table.unpack(num)}

	while #numCopy > 0 or #totalCopy > 0 do
		local sum = 0

		if #numCopy > 0 then
			sum = sum + table.remove(numCopy, 1)
		end

		if #totalCopy > 0 then
			sum = sum + table.remove(totalCopy, 1)
		end

		sum = sum + carry
		carry = 0

		table.insert(result, Gigantix.convertStringToArrayNumber(tostring(sum))[1])

		if #Gigantix.convertStringToArrayNumber(tostring(sum)) > 1 then
			carry = Gigantix.convertStringToArrayNumber(tostring(sum))[2]
		end
	end

	if carry ~= 0 then
		table.insert(result, carry)
	end

	return result
end


--[[<strong>Subtract one large number from another represented as arrays</strong><br>
    <em>Example:</em><br>
    <code>local total = Gigantix.convertStringToArrayNumber("15000")</code><br>
    <code>local num = Gigantix.convertStringToArrayNumber("5000")</code><br>
    <code>local resultCalc = Gigantix.subtractLargeNumbers(total, num)</code><br>
    <code>local result = Gigantix.getLongNotation(resultCalc)</code><br>
    <code>print(result) -- Output: "10000"</code>]]
function Gigantix.subtractLargeNumbers(total: {string}, num: {string}): {string}
	local result = {}
	local borrow = 0

	local totalCopy = {table.unpack(total)}
	local numCopy = {table.unpack(num)}

	while #numCopy > 0 or #totalCopy > 0 do
		local diff = 0

		if #totalCopy > 0 then
			diff = diff + table.remove(totalCopy, 1)
		end

		if #numCopy > 0 then
			diff = diff - table.remove(numCopy, 1)
		end

		diff = diff - borrow

		if diff < 0 then
			diff = diff + 1000
			borrow = 1
		else
			borrow = 0
		end

		table.insert(result, Gigantix.convertStringToArrayNumber(tostring(diff))[1])
	end

	while #result > 1 and result[#result] == 0 do
		table.remove(result)
	end

	return result
end


return Gigantix