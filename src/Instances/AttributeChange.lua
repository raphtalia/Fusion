--[[
	Generates symbols used to denote attribute change handlers when working with
	the `New` function.
]]

local function AttributeChange(propertyName: string)
	return {
		type = "Symbol",
		name = "AttributeChange",
		key = propertyName
	}
end

return AttributeChange