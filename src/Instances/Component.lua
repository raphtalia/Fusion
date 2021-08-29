local Package = script.Parent.Parent
local Events = require(script.Parent.Events)
local State = require(Package.State.State)
local None = require(Package.Utility.None)
local Signal = require(Package.Utility.Signal)
local logError = require(Package.Logging.logError)

local object = {}

local CLASS_METATABLE = {}
local OBJECT_METATABLE = {}

function CLASS_METATABLE:__newindex(i, v)
    local type = typeof(v)
    if type == "function" then
        if i == "init" then
            rawset(self, "_init", v)
        else
            self._methods[i] = v
        end
    else
        logError("componentInvalidKey", nil, i, type)
    end
end

-- Allows for component constructor to be called in a similar way as New
function CLASS_METATABLE.__call(class, propertyTable: {[string | Types.Symbol]: any})
    local self = setmetatable({
        type = "Component",
        kind = "Object",

        -- Provides a reference to the Roblox instance
        rbx = nil,

        _class = class,
        _props = {},
        _events = {},
    }, OBJECT_METATABLE)

    -- Create custom defined events
    local defaultProps = class._defaultProps
    local events = defaultProps[Events]
    if events then
        for _,eventName in ipairs(events) do
            self._events[eventName] = Signal.new()
        end
        defaultProps[Events] = nil
    end

    -- Set the properties
    for i,v in pairs(defaultProps) do
        if type(i) == "string" then
            self._props[i] = State(propertyTable[i] or v)
        end
    end

    -- Connect events using the symbol OnEvent
    for i,v in pairs(propertyTable) do
        if type(i) == "table" then
            if i.type == "Symbol" then
                if i.name == "OnEvent" then
                    local eventName = i.key

                    if not self._events[eventName] then
                        logError("componentNoEvent", nil, eventName)
                    end
                    local type = typeof(v)
                    if type ~= "function" then
                        logError("componentInvalidEventHandler", nil, eventName, type)
                    end

                    self._events[eventName]:Connect(v)
                end
            end
        end
    end

    -- Call the init function if defined, must return a Roblox Instance
    if class._init then
        local args = {}
        for _,v in ipairs(propertyTable) do
            table.insert(args, v)
        end

        local rbx = class._init(self, unpack(args))

        local type = typeof(rbx)
        if type == "Instance" then
            rawset(self, "rbx", rbx)
        else
            logError("componentInitInvalidReturn", nil, type)
        end
    end

    return self
end

-- Limit indexing to certain areas of the object
function OBJECT_METATABLE:__index(i)
    local v = rawget(self, "_props")[i] or rawget(self, "_events")[i] or rawget(self, "_class")._methods[i] or object[i]

    if v then
        if type(v) == "table" then
            if v.type == "State" then
                return v:get()
            elseif v == None then
                return nil
            end
        end
        return v
    end
    logError("strictReadError", nil, i, "Component")
end

-- Allow only writing to properties
function OBJECT_METATABLE:__newindex(i, v)
    local props = rawget(self, "_props")
    if props[i] then
        props[i]:set(v)
    else
        logError("strictReadError", nil, i, "Component")
    end
end

function object:Destroy()
    setmetatable(self, nil)

    for _,event in ipairs(self._events) do
        event:Destroy()
    end

    self.rbx:Destroy()
end

local function Component(propertyTable: {[string | Types.Symbol]: any})
    for i in pairs(propertyTable) do
        local type = typeof(i)
        if i ~= Events and type ~= "string" then
            logError("unrecognisedPropertyKey", nil, type, "Component")
        end
    end

    local self = setmetatable({
		type = "Component",
		kind = "Class",

        _init = nil,
        _defaultProps = propertyTable,
        _methods = {},
	}, CLASS_METATABLE)

    return self
end

return Component