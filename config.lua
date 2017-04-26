-- For full functionality, NodeMCU should be flashed with custom
-- firmware build with following modules:
-- 		bit, dht, file, gpio, i2c, mqtt, net, node,
-- 		rotary, spi, tmr, u8g, uart, wifi, ws2812
-- Suggest using float firmware
-- Built and tested on 1.5.4.1 final, custom from nodemcu-build.com
-- http://nodemcu-build.com/builds/nodemcu-1.5.4.1-final-15-modules-2017-04-25-01-54-14-float.bin
-- http://nodemcu-build.com/builds/nodemcu-1.5.4.1-final-15-modules-2017-04-25-01-54-14-integer.bin

-- NodeMCU custom build by frightanic.com
-- 	branch: 1.5.4.1-final
-- 	commit: 1885a30bd99aec338479aaed77c992dfd97fa8e2
-- 	SSL: false
-- 	modules: bit,dht,file,gpio,i2c,mqtt,net,node,rotary,spi,tmr,u8g,uart,wifi,ws2812
--  build 	built on: 2017-04-25 01:53
--  powered by Lua 5.1.4 on SDK 1.5.4.1(39cb9a32)

config = {

	display = {
		-- ssd1306_128x64_i2c
		-- ssd1306_128x64_hw_spi
		-- oled
		type = 1, -- 1=i2c, 2=spi

		i2c = {
			sda = 1,
			scl = 2,
			sla = 0x3c
		},

		spi = {
			cs  = 8, -- pull-down 10k to GND
			dc  = 4,
			res = 0
		}
	},

	temp = {
		pin = 3
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
		pinA	= 5,
		pinB	= 6,
		switch	= 7,
		-- See http://nodemcu.readthedocs.io/en/master/en/modules/rotary/#rotaryon
		-- Some switches have 4 steps per detent. This means that, in practice,
		-- the application should divide the position by 4 and use that to
		-- determine the number of clicks
		steps	= 4
	},

	servo = {
		pin = 8
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
		poll = 120	-- Keep alive timer (seconds)
		, scur = 0	-- Secure connection
		, rcon = 1	-- auto-reconnect
		, qoss = 0	-- Sub QoS
		, qosp = 0	-- Pub QoS
		, retn = 1	-- Retain
	}
}
