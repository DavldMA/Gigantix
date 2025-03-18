# Gigantix - Roblox Big Numbers Handler

**Gigantix** is a Roblox Lua module designed specifically to handle INFINITELY large numbers. It doesn’t do magic—it’s just a handler for big numbers. Whether you're dealing with trillions, quadrillions, or even beyond, Gigantix provides you with the tools to convert, format, and perform arithmetic on these massive numbers with ease.

---

## Why Use Gigantix?

Roblox’s native number handling can be limited when dealing with exponentially large values. Gigantix addresses this gap by offering a simple, yet powerful, set of functions to manage and operate on big numbers efficiently, ensuring your game logic remains both clear and performant.

---

## Features
- **Handle Large Numbers**: Manage numbers up to a [Googolplex](https://units.fandom.com/wiki/Prefix_Of_Numbers) and beyond theorically. (I think)
- **Convert Notations**: Transform shorthand notations (e.g., "15K", "1.2M") into full numeric values using `notationToString`.
- **Format Numbers**:
  - **Short Notation**: Convert full number arrays to a compact representation with `getShort`.
  - **Long Notation**: Retrieve the complete numeric value from a shorthand string using `getLong`.
- **Arithmetic Operations**:
  - **Addition**: Add large numbers with `add`.
  - **Subtraction**: Subtract large numbers with `subtract`.
  - **Multiplication**: Multiply large numbers with `multiply`.
- **Encoding/Decoding**:
  - **Encode Numbers**: Get an encoded string representation using `encodeNumber`.
  - **Decode Numbers**: Convert an encoded string back to a full number with `decodeNumber`.
- **Comparison Operations**:
  - Compare numbers using `isEquals`, `isGreater`, `isLesser`, `isGreaterOrEquals`, and `isLesserOrEquals`.
  - Check negativity using `isNegative`.

---

## Installation

1. Copy the `Gigantix` module into your Roblox project and place it in **ReplicatedStorage** or **ServerScriptService**.
2. Include the module in your scripts using `require()`.

---

## How to Use

### 1. Import the Module
```lua
local Gigantix = require(ReplicatedStorage.Gigantix)
```

### 2. Convert Shorthand Notation to Full Numbers
```lua
local fullNumber = Gigantix.notationToString("15K")
print("Full number from notation '15K':", fullNumber) -- Output: "15000"
```

### 3. Format Numbers

- **Convert a Full Number String to a Long Number Representation**
  ```lua
  local numberArray = Gigantix.stringToNumber("15000")
  ```

- **Get Short Notation**
  ```lua
  local shortNotation = Gigantix.getShort(numberArray)
  print("Short notation for 15000:", shortNotation) -- Output: "15K"
  ```

- **Get Long Notation**
  ```lua
  local longNotation = Gigantix.getLong(numberArray)
  print("Long notation for 15000:", longNotation) -- Output: "15000"
  ```

### 4. Perform Arithmetic Operations

- **Addition**
  ```lua
  local num1 = Gigantix.stringToNumber("15000")
  local num2 = Gigantix.stringToNumber("-5000")
  local sum = Gigantix.add(num1, num2)
  print("15000 + (-5000) =", Gigantix.getLong(sum)) -- Output: "10000"
  ```

- **Subtraction**
  ```lua
  local difference = Gigantix.subtract(num1, num2)
  print("15000 - (-5000) =", Gigantix.getLong(difference)) -- Output: "20000"
  ```

- **Multiplication**
  ```lua
  local product = Gigantix.multiply(num1, Gigantix.stringToNumber("-2"))
  print("15000 * (-2) =", Gigantix.getLong(product)) -- Output: "-30000"
  ```

### 5. Compare Numbers
```lua
local isEqual = Gigantix.isEquals(num1, {0, 15})
print("Does 15000 equal {0, 15}?", isEqual)

local isGreater = Gigantix.isGreater(num1, num2)
print("Is 15000 greater than -5000?", isGreater)

local isLesser = Gigantix.isLesser(num1, num2)
print("Is 15000 lesser than -5000?", isLesser)
```

### 6. Encode and Decode Numbers

- **Encoding a Number**
  ```lua
  local encoded = Gigantix.encodeNumber("1000000")
  print("Encoded representation of '1000000':", encoded)
  ```

- **Decoding a Number**
  ```lua
  local decoded = Gigantix.decodeNumber(encoded)
  print("Decoded number from", encoded, "(this returns a string):", decoded)
  ```

---

For issues, feature requests, contributions, or recommendations, feel free to [open an issue on GitHub](https://github.com/DavldMA/Gigantix/issues).

Join the discussion on the [Roblox Developer Forum](devforum.roblox.com/t/gigantix-—-infinite-size-numbers-module/3307153/27) to stay updated and contribute to the community!

