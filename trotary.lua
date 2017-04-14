

tRotary = {
	pos	= 0
}

function tRotary.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tRotary })
	return o
end

function tRotary:init()
	rotary.setup( 0, self.config.pinA, self.config.pinB, self.config.switch )

	rotary.on( 0, rotary.TURN, function( type, pos, when )
		print "Position=" .. pos .. " event type=" .. type .. " time=" .. when

		-- Read position from rotary
		pos = rotary.getpos( 0 )
		print( pos, press )

		-- check rotation
		if pos < self.pos then
			-- left turn
			turn = -1
		elseif pos > self.pos then
			-- right turn
			turn = 1
		else
			-- no turn (or end in same place as start)
			break
		end
		self.pos = pos

		app:rotary( turn )
	end)

	rotary.on( 0, rotary.CLICK, function( type )
		print "Event type=" .. type
		app:rotary( 0 )
	end)
end
