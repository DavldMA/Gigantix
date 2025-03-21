local Gigantix = require(script.Parent.Modules.Gigantix)	

local num1 = Gigantix.stringToNumber("15000")
local num2 = Gigantix.stringToNumber("-5000")
local num3 = Gigantix.stringToNumber("15500")

-- Perform arithmetic operations
local additionResult = Gigantix.add(num1, num2)
print("15000 + (-5000) =", Gigantix.getLong(additionResult))

local subtractionResult = Gigantix.subtract(num1, num2)
print("15000 - (-5000) =", Gigantix.getLong(subtractionResult))

local multiplicationResult = Gigantix.multiply(num1, Gigantix.stringToNumber("-2"))
print("15000 * (-2) =", Gigantix.getLong(multiplicationResult))

local negativeSum = Gigantix.add(num2, num2)
print("(-5000) + (-5000) =", Gigantix.getLong(negativeSum))

local subtractToZero = Gigantix.subtract(num2, num2)
print("(-5000) - (-5000) =", Gigantix.getLong(subtractToZero))

local multiplicationNegativeNumbers = Gigantix.multiply(num2, num2)
print("(-5000) * (-5000) =", Gigantix.getLong(multiplicationNegativeNumbers))

local multiplicationResultWithNumber = Gigantix.multiply(num1, 1.5)
print("15000 * 1.5 (not a table) =", Gigantix.getLong(multiplicationResultWithNumber))

local multiplicationResultWithNumberlower = Gigantix.multiply(Gigantix.stringToNumber("1"), 1.5)
print("1 * 1.5 (not a table) =", Gigantix.getLong(multiplicationResultWithNumberlower))

local multiplicationResultWithNumberLowerLower = Gigantix.multiply(Gigantix.stringToNumber("1"), -1.4)
print("1 * (-1.4) (not a table) =", Gigantix.getLong(multiplicationResultWithNumberLowerLower))

local multiplicationResultWithNumberLowerLowerLower = Gigantix.multiply(Gigantix.stringToNumber("1"), -2)
print("1 * (-2) (not a table) =", Gigantix.getLong(multiplicationResultWithNumberLowerLowerLower))

print("-------------------------------------------------------------")

-- Notation conversion: convert short notation "15k" to its full number string
local fullNumberFromNotation = Gigantix.notationToString("15k")
print("Full number from notation '15k':", fullNumberFromNotation)

-- Compare Operations
local isEqual = Gigantix.isEquals(num1, {0, 15})
print("Does 15000 (num1) equal {0, 15}? ", isEqual)
local isGreater = Gigantix.isGreater(num1, num2)
print("Does 15000 (num1) greater than -5000 (num2)? ", isGreater)
local isLesser = Gigantix.isLesser(num1, num2)
print("Does 15000 (num1) lesser than -5000 (num2)? ", isLesser)
local isGreaterOrEquals = Gigantix.isGreaterOrEquals(num1, num1)
print("Does 15000 (num1) greater or equals to 15000 (num1)? ", isGreaterOrEquals)
local isLesserOrEquals = Gigantix.isLesserOrEquals(num1, num2)
print("Does 15000 (num1) lesser or equals -5000 (num2)? ", isLesserOrEquals)
local isNegative = Gigantix.isNegative(num2)
print("Is -5000 (num2) negative? ", isNegative)
print("-------------------------------------------------------------")

-- Get short and long notations for numbers
local shortNum1 = Gigantix.getShort(num1)
print("Short notation for num1 (15000):", shortNum1)

local shortNum2 = Gigantix.getShort(num2)
print("Short notation for num2 (-5000):", shortNum2)

local longNum1 = Gigantix.getLong(num1)
print("Long notation for num1:", longNum1)

local longNum3 = Gigantix.getLong(num3)
print("Long notation for num3:", longNum3)
print("-------------------------------------------------------------")

-- Encoding and decoding a number
local encoded = Gigantix.encodeNumber("1000000")
print("Encoded representation of '1000000':", encoded)

local decoded = Gigantix.decodeNumber(encoded)
print("Decoded number from", encoded, "(this returns a string):", decoded)