--[[
	Stores templates for different kinds of logging messages.
]]

return {
	cannotAssignProperty = "The class type '%s' has no assignable property '%s'.",
	cannotAssignAttribute = "The attribute '%s' could not be assigned to.",
	cannotConnectChange = "The %s class doesn't have a property called '%s'.",
	cannotConnectEvent = "The %s class doesn't have an event called '%s'.",
	cannotCreateClass = "Can't create a new instance of class '%s'.",
	computedCallbackError = "Computed callback error: ERROR_MESSAGE",
	invalidSpringDamping = "The damping ratio for a spring must be >= 0. (damping was %.2f)",
	invalidSpringSpeed = "The speed of a spring must be >= 0. (speed was %.2f)",
	pairsDestructorError = "ComputedPairs destructor error: ERROR_MESSAGE",
	pairsProcessorError = "ComputedPairs callback error: ERROR_MESSAGE",
	springTypeMismatch = "The type '%s' doesn't match the spring's type '%s'.",
	strictReadError = "'%s' is not a valid member of '%s'.",
	unknownMessage = "Unknown error: ERROR_MESSAGE",
	unrecognisedChildType = "'%s' type children aren't accepted as children in `New`.",
	unrecognisedPropertyKey = "'%s' keys aren't accepted in the property table of `%s`",
	stateNotATable = "The value of this state is not a table",
	stateNotANumber = "The value of this state is not a number",
	invalidArgument = "Invalid argument #%d to '%s' (%s expected, got %s)",
	componentInvalidKey = "Invalid key '%s' on Component (function expected, got %s)",
	componentInitInvalidReturn = "Invalid return type from Component initializer (Instance or table expected, got %s)",
	componentNoEvent = "Component has no event '%s'",
	componentInvalidEventHandler = "Invalid event handler for '%s' on Component (function expected, got %s)",
}