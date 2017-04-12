

tRotary = {}

function tRotary.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tRotary })
	return o
end

function tRotary:init()
	rotary.setup( 0, self.config.pinA, self.config.pinB, self.config.switch )

	rotary.on( 0, rotary.ALL, function( type, pos, when )
		print "Position=" .. pos .. " event type=" .. type .. " time=" .. when
		app:
	end)
end
