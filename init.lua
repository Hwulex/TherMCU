-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile( "credentials.lua" )

function startup()
    if file.open( "init.lua" ) == nil then
        print( "init.lua deleted or renamed" )
    else
        print( "Running application" )
        file.close( "init.lua" )
        -- the actual application is stored in 'application.lua'
        -- dofile( "application.lua" )
    end
end

print( "Connecting to WiFi access point..." )
wifi.setmode( wifi.STATION )
wifi.setphymode( creds.wifi.smode )
wifi.sta.config( creds.wifi.ssid, creds.wifi.pass )
-- wifi.sta.connect() not necessary because config() uses auto-connect=true by default
if creds.wifi.ipadr ~= "" then
    wifi.sta.setip( {
		ip = creds.wifi.ipadr
		, netmask = creds.wifi.nmask
		, gateway = creds.wifi.gtway
	})
end

tmr.alarm( 1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print( "Waiting for IP address..." )
    else
        tmr.stop( 1 )
        print( "WiFi connection established, IP address: " .. wifi.sta.getip() )
        print( "You have 3 seconds to abort application load" )
        print( "Waiting..." )
        tmr.alarm( 0, 3000, 0, startup )
    end
end)
