

tOled = {
	lock = false
}

function tOled.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tOled })
	return o
end


function tOled:init()
	if self.config.oled.type == 2 then
		spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
		-- we won't be using the HSPI /CS line, so disable it again
		gpio.mode(8, gpio.INPUT, gpio.PULLUP)
		disp = u8g.ssd1306_128x64_hw_spi( self.config.spi.cs, self.config.spi.dc, self.config.spi.res)
	else
		i2c.setup( 0, self.config.i2c.sda, self.config.i2c.scl, i2c.SLOW )
		self.disp = u8g.ssd1306_128x64_i2c( self.config.i2c.sla )
	end

	disp:setFont( u8g.font_6x10 )
	disp:setFontRefHeightExtendedText()
	disp:setDefaultForegroundColor()
	disp:setFontPosTop()
end

function tOled:lock() {
	self.lock = true
}

function tOled:unlock() {
	self.lock = false
}

function tOled:isLocked() {
	return self.lock
}

function tOled:update() {
	-- do magic to write to screen
}
