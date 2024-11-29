### Gigantix - Roblox Big Numbers Module  

**Gigantix** is a powerful Roblox Lua module designed to handle extremely large numbers seamlessly. Whether you're dealing with trillions, quadrillions, or beyond, Gigantix provides tools to convert, format, add, and subtract massive numbers with precision.

---

### Why Use Gigantix?  
Handling large numbers in Roblox can be tricky, especially when dealing with exponential values or formatted notations. Gigantix simplifies the process, ensuring that your games remain performant while managing complex arithmetic operations.  

---

### Features  
- **Handle Large Number**: Handle Large Numbers, up to [Googolplex](https://units.fandom.com/wiki/Prefix_Of_Numbers). 
- **Convert Notations**: Transform shorthand notation (e.g., "15K", "1.2M") into full numeric values.  
- **Format Numbers**: Convert large numbers into compact short notation or detailed long notation.  
- **Add and Subtract Large Numbers**: Perform arithmetic operations on large numbers represented as arrays.  


---

### Installation  
1. Copy the `Gigantix` module into your Roblox project and add it to the ReplicatedStorage or ServerScriptService.  
2. Use `require()` to include the module in your scripts whenever you want to use it.  

---

### How to Use  

#### 1. **Import the Module**
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gigantix = require(ReplicatedStorage.Gigantix)
```

#### 2. **Convert Shorthand Notation to Full Numbers**
```lua
local fullNumber = Gigantix.convertNotationToNumber("15K") -- Setting a default value to our fullNumber
print(fullNumber) -- Output: 15000
```

#### 3. **Format Numbers**
- **Short Notation**:
```lua
local numberArray = Gigantix.convertStringToArrayNumber("15000") -- Setting a default value to our numberArray
local shortNotation = Gigantix.getShortNotation(numberArray)
print(shortNotation) -- Output: "15K"
```

- **Long Notation**:
```lua
local longNotation = Gigantix.getLongNotation(shortNotation)
print(longNotation) -- Output: "15000"
```

#### 4. **Add and Subtract Large Numbers**
- **Addition**:
```lua
local num1 = Gigantix.convertStringToArrayNumber("15000")
local num2 = Gigantix.convertStringToArrayNumber("5000")
local result = Gigantix.addLargeNumbers(num1, num2)
print(Gigantix.getLongNotation(result)) -- Output: "20000"
```

- **Subtraction**:
```lua
local result = Gigantix.subtractLargeNumbers(num1, num2)
print(Gigantix.getLongNotation(result)) -- Output: "10000"
```

--- 

For issues, feature requests, or contributions, feel free to [open an issue on GitHub]([https://github.com/your-repo-link](https://github.com/DavldMA/Gigantix)).  
