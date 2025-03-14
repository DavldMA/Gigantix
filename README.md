# Gigantix - Roblox Big Numbers Handler

**Gigantix** is a Roblox Lua module designed specifically to handle INFINITELY large numbers. It doesn’t do magic—it’s just a handler for big numbers. Whether you're dealing with trillions, quadrillions, or even beyond, Gigantix provides you with the tools to convert, format, and perform arithmetic on these massive numbers with ease.

---

## Why Use Gigantix?

Roblox’s native number handling can be limited when dealing with exponentially large values. Gigantix addresses this gap by offering a simple, yet powerful, set of functions to manage and operate on big numbers efficiently, ensuring your game logic remains both clear and performant.

---

## Features
- **Handle Large Numbers**: Manage numbers up to a [Googolplex](https://units.fandom.com/wiki/Prefix_Of_Numbers) and beyond.
- **Convert Notations**: Transform shorthand notations (e.g., "15K", "1.2M") into full numeric values using `notationToString`.
- **Format Numbers**:
  - **Short Notation**: Convert full number arrays to a compact representation with `getShort`.
  - **Long Notation**: Retrieve the complete numeric value from a shorthand string using `getLong`.
- **Arithmetic Operations**:
  - **Addition**: Add large numbers with `add`.
  - **Subtraction**: Subtract large numbers with `subtract`.
- **Encoding/Decoding**:
  - **Encode Numbers**: Get an encoded string representation using `encodeNumber`.
  - **Decode Numbers**: Convert an encoded string back to a full number with `decodeNumber`.

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
print(fullNumber) -- Output: "15000"
```

### 3. Format Numbers

- **Convert a Full Number String to a Long Number Representation**
  ```lua
  local numberArray = Gigantix.stringToNumber("15000")
  ```

- **Get Short Notation**
  ```lua
  local shortNotation = Gigantix.getShort(numberArray)
  print(shortNotation) -- Output: "15K"
  ```

- **Get Long Notation**
  ```lua
  local longNotation = Gigantix.getLong(numberArray)
  print(longNotation) -- Output: "15000"
  ```

### 4. Add and Subtract Large Numbers

- **Addition**
  ```lua
  local num1 = Gigantix.stringToNumber("15000")
  local num2 = Gigantix.stringToNumber("5000")
  local sum = Gigantix.add(num1, num2)
  print(Gigantix.getLong(sum)) -- Output: "20000"
  ```

- **Subtraction**
  ```lua
  local result = Gigantix.subtract(num1, num2)
  print(Gigantix.getLong(result)) -- Output: "10000"
  ```

### 5. Encode and Decode Numbers

- **Encoding a Number**
  ```lua
  local encoded = Gigantix.encodeNumber("1000000")
  print(encoded) -- Output: "1xFa"
  ```

- **Decoding a Number**
  ```lua
  local decoded = Gigantix.decodeNumber(encoded)
  print(decoded) -- Output: "1000000"
  ```

---

For issues, feature requests, contributions, or recommendations, feel free to [open an issue on GitHub](https://github.com/DavldMA/Gigantix/issues).

