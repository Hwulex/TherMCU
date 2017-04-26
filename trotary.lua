

tRotary = {
	pos	= 0
	, when = 0
	, channel = 0
	, debounce = 100
}

function tRotary.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tRotary })
	return o
end

function tRotary:init()
	rotary.setup( self.channel, self.config.pinA, self.config.pinB, self.config.switch )
	-- print( "Rotary position: " .. rotary.getpos( self.channel ) )

	-- Turn event
	rotary.on( self.channel, rotary.TURN, function( type, pos, when )
		-- print( "Position=" .. pos .. " event type=" .. type .. " time=" .. when )

		-- Read position from rotary to figure out if left or right
		pos = math.floor( rotary.getpos( self.channel ) / 4 )
		-- print( "Rotary cur: " .. self.pos )
		-- print( "Rotary pos: " .. pos )
		-- print( "Rotary when: " .. self.when )
		-- print( "Rotary now: " .. when )

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
			-- print( "Rotary turned but ended up where we started. Do nothing" )
			return
		end
		-- print( "else should not get here" )
		self.pos = pos
		self.when = when

		-- Send turn signal to app
		-- app:rotary( turn )
	end)

	-- Click event
	rotary.on( self.channel, rotary.CLICK, function( type )
		print( "Rotary clicked: event type (" .. type .. ")" )
		-- app:rotary( 0 )
	end)
end
