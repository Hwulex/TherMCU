

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
	-- Safety check to prevent divide-by-zero error
	if 1 > self.config.steps then
		print( "You have not defined rotary step divisor in config. Defaulting to: 1" )
		self.config.steps = 1
	end

	-- Initialize the nodemcu to talk to a rotary encoder switch
	rotary.setup( self.channel, self.config.pinA, self.config.pinB, self.config.switch )

	-- Turn event
	rotary.on( self.channel, rotary.TURN, function( type, pos, when )
		-- Read position from rotary to figure out if left or right
		pos = math.floor( rotary.getpos( self.channel ) / self.config.steps )

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
			return
		end
		-- Save new position
		self.pos = pos

		-- Send turn signal to app
		-- app:rotary( turn )
	end)

	-- Click event
	rotary.on( self.channel, rotary.CLICK, function( type )
		print( "Rotary clicked: event type (" .. type .. ")" )
		-- app:rotary( 0 )
	end)
end
