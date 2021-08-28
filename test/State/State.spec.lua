local Package = game:GetService("ReplicatedStorage").Fusion
local State = require(Package.State.State)

return function()
	it("should construct a State object", function()
		local state = State()

		expect(state).to.be.a("table")
		expect(state.type).to.equal("State")
		expect(state.kind).to.equal("State")
	end)

	it("should be able to store arbitrary values", function()
		local state = State(0)
		expect(state:get()).to.equal(0)

		state:set(10)
		expect(state:get()).to.equal(10)

		state:set(State)
		expect(state:get()).to.equal(State)
	end)

	it("should error if trying to use shorthand table methods on a non-table state", function()
		local state = State()

		expect(function()
			state:insert(1)
		end).to.throw()

		expect(function()
			state:remove(1)
		end).to.throw()

		expect(function()
			state:find(1)
		end).to.throw()

		expect(function()
			state:sort(1)
		end).to.throw()
	end)

	it("should be able to use shorthand table methods on a table state", function()
		local state = State({})

		state:insert(1)
		expect(state:get()[1]).to.equal(1)
		expect(state:find(1)).to.equal(1)

		state:remove(1)
		expect(state:get()[1]).to.equal(nil)
		expect(state:find(1)).to.equal(nil)

		state:set({1, 2, 3})
		state:sort(function(a, b)
			return a > b
		end)
		expect(state:get()[1]).to.equal(3)
		expect(state:get()[2]).to.equal(2)
		expect(state:get()[3]).to.equal(1)
	end)
end