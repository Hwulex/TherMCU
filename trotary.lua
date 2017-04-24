

tRotary = {
	pos	= 0
	, channel = 0
}

function tRotary.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tRotary })
	return o
end

function tRotary:init()
	rotary.setup( self.channel, self.config.pinA, self.config.pinB, self.config.switch )

	-- Turn event
	rotary.on( self.channel, rotary.TURN, function( type, pos, when )
		print( "Position=" .. pos .. " event type=" .. type .. " time=" .. when )

		-- Read position from rotary to figure out if left or right
		pos = rotary.getpos( self.channel )
		print( "Rotary cur: " .. self.pos )
		print( "Rotary pos: " .. pos )

		-- check rotation
		if pos < self.pos then
			-- left turn
			turn = -1
			print( "Rotary turned left" )
		elseif pos > self.pos then
			-- right turn
			turn = 1
			print( "Rotary turned right" )
		else
			-- no turn (or end in same place as start)
			print( "Rotry turned but ended up where we started. Do nothing" )
			return
		end
		self.pos = pos

		-- Send turn signal to app
		app:rotary( turn )
	end)

	-- Click event
	rotary.on( self.channel, rotary.CLICK, function( type )
		print( "Rotary clicked: event type (" .. type .. ")" )
		app:rotary( 0 )
	end)
end
