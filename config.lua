
config = {

	display = {
		type = 1, -- 1=i2c, 2=spi

		i2c = {
			sda = 1,
			sdb = 2,
			sla = 0x3c
		},

		spi = {
			cs  = 8, -- pull-down 10k to GND
			dc  = 4,
			res = 0
		}
	},

	temp = {
		pin = 2
		, unit	= 0 -- 0=C, 1=F
		-- User restricted min and max
		, min	= 5
		, max	= 20
		-- Thermostat physical actual min and max
		, minA	= 0
		, maxA	= 30
		-- Degrees from 0 (horizontal) for temp.minA and temp.maxA values
		, minD	= 0
		, maxD	= 125
	},

	rotary = {
		pinA = 5,
		pinB = 6,
		switch = 7
	},

	servo = {
		pin = 2
		, frq = 50		-- Hz
		, min = 400		-- 0deg posn value
		, max = 2400	-- 180deg posn value
	},

	menu = {
		default = 7 -- bitwise
			-- 1	= current temp
			-- 2	= select temp
			-- 4	= humid
			-- 8	= date
			-- 16	= time
		, timeout = 5 -- seconds, menu display timeout (before revert to default)
	},

 	message = {
		clnt:	"clientid"
		, poll: 120
		, scur: 0
		, rcon: 1
		, user: "username"
		, pass: "password"
		, addr: "192.168.1.20"
		, port: 1883
		, qoss:	0
		, qosp: 0
		, retn: 1
	}
}
