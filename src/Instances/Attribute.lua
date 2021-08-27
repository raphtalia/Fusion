--[[
	The symbol used to denote an attribute of an instance when working with the
	`New` function.
]]

local function Attribute(attributeName: string)
	return {
		type = "Symbol",
		name = "Attribute",
		key = attributeName
	}
end

return Attribute