

tTemp = {}

function tTemp.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tTemp })
	return o
end


function tTemp:init()

end

