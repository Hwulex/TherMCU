creds = {

	-- WiFi Credentials
	wifi	= {
		ssid 	= "yourSSID"
		, pass	= "yourPASS"
		
		-- http://nodemcu.readthedocs.io/en/master/en/modules/wifi/#wifisetphymode
		-- wifi.PHYMODE_B 802.11b, More range, Low Transfer rate, More current draw
		-- wifi.PHYMODE_G 802.11g, Medium range, Medium transfer rate, Medium current draw
		-- wifi.PHYMODE_N 802.11n, Least range, Fast transfer rate, Least current draw 
		, smode		= wifi.PHYMODE_N

		-- If the settings below are filled out then the module connects 
		-- using a static ip address which is faster than DHCP and 
		-- better for battery life. Blank "" will use DHCP.
		, ipadr		= ""
		, nmask		= ""
		, gtway		= ""
	},

	-- MQTT server credentials
	mqtt	= {
		client	= "clientid"
		, user	= "username"
		, pass	= "password"
		, addr	= "192.168.1.20"
		, port	= 1883
		, tpcTx = "/home/floor/room/master/temp"
		, tpcRx = "/home/floor/room/master/temp/set"
	}

}
