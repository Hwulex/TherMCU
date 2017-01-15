

tRotary = {}

function tRotary.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tRotary })
	return o
end


function tRotary:init()
	rotary.setup( 0, self.config.pinA, self.config.pinB, self.config.switch )
end
