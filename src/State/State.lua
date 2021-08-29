--[[
	Constructs and returns objects which can be used to model independent
	reactive state.
]]

local Package = script.Parent.Parent
local useDependency = require(Package.Dependencies.useDependency)
local initDependency = require(Package.Dependencies.initDependency)
local updateAll = require(Package.Dependencies.updateAll)
local logError = require(Package.Logging.logError)

local class = {}

local CLASS_METATABLE = {__index = class}
local WEAK_KEYS_METATABLE = {__mode = "k"}

function CLASS_METATABLE:__unm()
	if type(self._value) == "number" then
		return -self._value
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__add(x)
	if type(self._value) == "number" then
		return self._value + x
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__sub(x)
	if type(self._value) == "number" then
		return self._value - x
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__mul(x)
	if type(self._value) == "number" then
		return self._value * x
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__div(x)
	if type(self._value) == "number" then
		return self._value / x
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__mod(x)
	if type(self._value) == "number" then
		return self._value % x
	else
		logError("stateNotANumber")
	end
end

function CLASS_METATABLE:__pow(x)
	if type(self._value) == "number" then
		return self._value ^ x
	else
		logError("stateNotANumber")
	end
end

-- Inserts a new value into this state object if its value is a table.
function class:insert(newValue: any, index: number?)
	if type(self._value) == "table" then
		if newValue ~= nil then
			if index then
				table.insert(self._value, index, newValue)
			else
				table.insert(self._value, newValue)
			end
			updateAll(self)
		else
			-- Slightly misleading error due to allowing any can't insert nil
			logError("invalidArgument", nil, 1, "insert", "any", "nil")
		end
	else
		logError("stateNotATable")
	end
end

-- Removes a value from this state object if its value is a table.
function class:remove(index: number)
	if type(self._value) == "table" then
		local value = table.remove(self._value, index)
		if value then
			updateAll(self)
			return value
		end
	else
		logError("stateNotATable")
	end
end

-- Finds the index of a value in this state object if its value is a table.
function class:find(value: any)
	if type(self._value) == "table" then
		local index = table.find(self._value, value)
		if index then
			return index
		end
	else
		logError("stateNotATable")
	end
end

-- Sorts the values in the value of this state object if its value is a table.
function class:sort(sorter: any)
	local sorterType = typeof(sorter)
	if sorterType ~= "function" then
		logError("invalidArgument", nil, 1, "insert", "function", sorterType)
	end

	if type(self._value) == "table" then
		table.sort(self._value, sorter)

		-- Unsure of best way to determine if sorter changed order
		updateAll(self)
	else
		logError("stateNotATable")
	end
end

--[[
	Returns the value currently stored in this State object.
	The state object will be registered as a dependency unless `asDependency` is
	false.
]]
function class:get(asDependency: boolean?)
	if asDependency ~= false then
		useDependency(self)
	end
	return self._value
end

--[[
	Updates the value stored in this State object.

	If `force` is enabled, this will skip equality checks and always update the
	state object and any dependents - use this with care as this can lead to
	unnecessary updates.
]]
function class:set(newValue: any, force: boolean?)
	-- if the value hasn't changed, no need to perform extra work here
	if self._value == newValue and not force then
		return
	end

	self._value = newValue

	-- update any derived state objects if necessary
	updateAll(self)
end

local function State(initialValue: any)
	if type(initialValue) == "table" and initialValue.type == "State" then
		-- Simplifies passing a State down chains of components
		return initialValue
	end

	local self = setmetatable({
		type = "State",
		kind = "State",
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_value = initialValue
	}, CLASS_METATABLE)

	initDependency(self)

	return self
end

return State