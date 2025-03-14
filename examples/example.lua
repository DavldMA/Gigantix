local Gigantix = require(script.Parent.Gigantix)

-- Convert number strings into long number representations
local num1 = Gigantix.stringToNumber("15000")
local num2 = Gigantix.stringToNumber("-5000")
local num3 = Gigantix.stringToNumber("15500")

-- Perform arithmetic operations:
local additionResult = Gigantix.add(num1, num2)
print("15000 + (-5000) =", Gigantix.getLongNumber(additionResult))

local subtractionResult = Gigantix.subtract(num1, num2)
print("15000 - (-5000) =", Gigantix.getLongNumber(subtractionResult))

local negativeSum = Gigantix.add(num2, num2)
print("(-5000) + (-5000) =", Gigantix.getLongNumber(negativeSum))

local subtractToZero = Gigantix.subtract(num2, num2)
print("(-5000) - (-5000) =", Gigantix.getLongNumber(subtractToZero))
print("-------------------------------------------------------------")

-- Notation conversion: convert short notation "15k" to its full number string
local fullNumberFromNotation = Gigantix.notationToString("15k")
print("Full number from notation '15k':", fullNumberFromNotation)

-- Compare a long number to a given value (represented as an array {0, 15})
local isEqual = Gigantix.compare(num1, {0, 15})
print("Does 15000 (num1) equal {0, 15}? ", isEqual)
print("-------------------------------------------------------------")

-- Get short and long notations for numbers:
local shortNum1 = Gigantix.getShort(num1)
print("Short notation for num1 (15000):", shortNum1)

local shortNum3 = Gigantix.getShort(num3)
print("Short notation for num3 (15500):", shortNum3)

local longNum1 = Gigantix.getLong(num1)
print("Long notation for num1:", longNum1)

local longNum3 = Gigantix.getLong(num3)
print("Long notation for num3:", longNum3)
print("-------------------------------------------------------------")

-- Encoding and decoding a number:
local encoded = Gigantix.encodeNumber("1000000")
print("Encoded representation of '1000000':", encoded)

local decoded = Gigantix.decodeNumber(encoded)
print("Decoded number from", encoded, "(this returns a string):", decoded)
