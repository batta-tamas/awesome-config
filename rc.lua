------------------------------
-- Standard awesome library --
------------------------------
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Vicious widgets
require("vicious")
--require("obvious.umts")
-- Load Debian menu entries
--require("debian.menu")

-- Font
awesome.font = "terminus 8"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
					title = "Oops, there were errors during startup!",
					text = awesome.startup_errors })
					end

----------------------
-- Start compositor --
----------------------
--awful.util.spawn_with_shell("xcompmgr -n &")
--awful.util.spawn_with_shell("compton -CG &")

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.add_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
						title = "Oops, an error happened!",
						text = err })
		in_error = false
		end)
	end
-- }}}

------------------------------
-- {{{ Variable definitions --
------------------------------
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/usr/share/awesome/themes/strict/theme.lua")

-- This is used later as the default terminal and editor to run.
--terminal = "/usr/bin/urxvt -depth 32 -bg rgba:0000/0000/0000/dddd -fg grey"
terminal = "/usr/bin/urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
	awful.layout.suit.floating,			--1
	awful.layout.suit.tile,				--2
	awful.layout.suit.tile.left,			--3
	awful.layout.suit.tile.bottom,			--4
	awful.layout.suit.tile.top,			--5
	awful.layout.suit.fair,				--6
	awful.layout.suit.fair.horizontal,		--7
	awful.layout.suit.max,				--8
	awful.layout.suit.magnifier			--9
	--awful.layout.suit.spiral,			--10
	--awful.layout.suit.spiral.dwindle,		--11
	--awful.layout.suit.max.fullscreen,		--12
	}
-- }}}

-- {{{ Tags
-- Define a tag table which will hold all screen tags.
tags = {
  	--names  = { " đ ", " Đ ", " ł ", " Ł ", " ß ", " ¤ " },
  	names  = { "[1]", "[2]", "[3]", "[4]", "[5]", "[6]" },
  	--names  = { "main", "www", "mail", "work", "vpn", "media" },
	--names  = { "⚀", "⚁", "⚂", "⚃", "⚄", "⚅" },
	layout = { layouts[4], layouts[1], layouts[9], layouts[4], layouts[9], layouts[1]}
	}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag(tags.names, s, tags.layout)
	end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {{ "manual", terminal .. " -e man awesome" },
				{ "edit config", editor_cmd .. " " .. awesome.conffile },
				{ "restart", awesome.restart },
				{ "quit", awesome.quit }
				}

mymainmenu = awful.menu({ items = {{ "awesome", myawesomemenu, beautiful.awesome_icon },
									-- { "Debian", debian.menu.Debian_menu.Debian },
									{ "open terminal", terminal },
									--{ "conky", "conky -q" },
									{ "suspend", "sudo /etc/acpi/lid.sh" },
									{ "reboot", "sudo systemctl reboot" },
									{ "poweroff", "sudo systemctl poweroff" }}
									})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })
-- }}}

-- {{{ Wibox
spacer = widget({type = "textbox"})
separator = widget({type = "textbox"})
spacer.text = " "
separator.text = "│"

-------------
-- Widgets --
-------------
--CoolText widget
--ctwidget = widget ({ type = "imagebox" })
--ctwidget.image = image(awful.util.getdir("config") .. "/icons/cooltext2.png")
--ctwidget.resize = false
--CPU fan speed
fanicon = widget ({ type = "imagebox" })
fanicon.image = image(awful.util.getdir("config") .. "/icons/fan.png")
fanicon.resize = false
fanwidget = widget ({ type = "textbox"})
fanwidget.text = "#"
fantimer = timer({ timeout = 5 })
fantimer:add_signal("timeout",
	function()
		local fanspeed = awful.util.pread("cat /proc/acpi/ibm/fan | awk '/speed:/ {print$2}'")
		fanwidget.text = fanspeed
		end)
fantimer:start()
--CPU Temp widget
thermalicon = widget ({ type = "imagebox" })
thermalicon.image = image(awful.util.getdir("config") .. "/icons/temp.png")
thermalicon.resize = false
cputempwidget = widget ({ type = "textbox"})
cputempwidget.text = "#"
cputemptimer = timer({ timeout = 5 })
cputemptimer:add_signal("timeout",
	function()
		local cputemp = awful.util.pread("cat /proc/acpi/ibm/thermal | awk '/temperatures:/ {print$2}'")
		cputempwidget.text = cputemp
		end)
cputemptimer:start()
--Top mem widget
--topmemwidget = widget ({ type = "textbox"})
--topmemwidget.text = "#"
--topmemtimer = timer({ timeout = 1 })
--topmemtimer:add_signal("timeout",
--	function()
--		local topmem = awful.util.pread("ps -e --noheader --sort -%mem -o comm | head -1")
--		topmemwidget.text = topmem
--	end)
--topmemtimer:start()
--
--Top cpu widget
--topcpuwidget = widget ({ type = "textbox"})
--topcpuwidget.text = "#"
--topcputimer = timer({ timeout = 1 })
--topcputimer:add_signal("timeout",
--	function()
--		local topcpu = awful.util.pread("ps -e --noheader --sort -%cpu -o comm | head -1")
--		topcpuwidget.text = topcpu
--	end)
--topcputimer:start()
--
--Weather widget
--weathericon = widget ({type = "imagebox"})
--weathericon.image = image(awful.util.getdir("config") .. "/icons/dish.png")
--weathericon.resize = false
--weatherwidget = widget ({ type = "textbox" })
--weatherwidget.text = "#"
--weathertimer = timer({ timeout = 300 })
--weathertimer:add_signal("timeout",
--	function()
--		temp = assert(io.popen("~/.config/awesome/scripts/weather.py 3046916", "r"))
--		weatherwidget.text = temp:read("*l")
--		temp:close()
--	end)
--weathertimer:start()
--
-- Mail widget
mailicon = widget ({type = "imagebox" })
mailicon.image = image(awful.util.getdir("config") .. "/icons/mail_grey.png")
mailicon.resize = false
mailwidget = widget({ type = "textbox" })
mailwidget.text = "#"
mailtimer = timer({ timeout = 120 })
mailicon:buttons(
	awful.util.table.join(
		awful.button({ }, 1, function ()
			mailtimer.start(mailtimer)
			mailicon.image = image(awful.util.getdir("config") .. "/icons/mail.png")
			end),
		awful.button({ }, 3, function ()
			mailtimer.stop(mailtimer)
			mailicon.image = image(awful.util.getdir("config") .. "/icons/mail_grey.png")
			end)
		)
	)

mailtimer:add_signal("timeout",
	function() 
		os.execute("python /home/tom/.config/awesome/scripts/imap.py > /home/tom/.cache/awesome/mail")
		local f = io.open("/home/tom/.cache/awesome/mail")
		local count = f:read()
		f:close()
		if count == "!" then
			mailwidget.text = "!"
			mailicon.image = image(awful.util.getdir("config") .. "/icons/mail_red.png")
		else
			mailwidget.text = count
			count2num = tonumber(count)
			if (count2num > 0) then
				mailicon.image = image(awful.util.getdir("config") .. "/icons/mail_red.png")
			else
				mailicon.image = image(awful.util.getdir("config") .. "/icons/mail.png")
				end
			end
		end)

--
-- Memory widget
--memicon = widget ({type = "imagebox" })
--memicon.image = image(awful.util.getdir("config") .. "/icons/mem.png")
--memicon.resize = false
--memwidget = widget({ type = "textbox" })
--vicious.register(memwidget, vicious.widgets.mem, " $2MB ", 5)
--
-- CPU widget
--cpuicon = widget ({type = "imagebox" })
--cpuicon.image = image(awful.util.getdir("config") .. "/icons/cpu.png")
--cpuicon.resize = false
--cpuwidget = widget({ type = "textbox" })
--vicious.register(cpuwidget, vicious.widgets.cpu, " $1% ")
--
-- CPU freq widget
--cpufreq = widget({ type = "textbox" })
--vicious.register(cpufreq, vicious.widgets.cpufreq, " @ $1MHz ", 1, "cpu0")
--
-- CPU thermal widget
--thermalicon = widget ({ type = "imagebox" })
--thermalicon.image = image(awful.util.getdir("config") .. "/icons/temp.png")
--thermalicon.resize = false
--thermalwidget  = widget({ type = "textbox" })
--thermaltimer = timer({ timeout = 5 })
--thermaltimer:add_signal("timeout",
--	function()
--		thermalwidget.text = temp.getCpuTemp
--	end)
--thermaltimer:start()
--vicious.register(thermalwidget, vicious.widgets.thermal, " - $1°C", 20, { "coretemp.0", "core"} )
--
-- / widget
--fsroot = widget({ type = "textbox" })
--vicious.register(fsroot, vicious.widgets.fs, " /: ${/ used_gb}GB", 5)
--
-- /home widget
--fshome = widget({ type = "textbox" })
--vicious.register(fshome, vicious.widgets.fs, " /home: ${/home used_gb}GB ", 5)
--
-- net widget
--wifisignal = widget({type = "textbox" })
--function wifiInfo()
--	local wifiStrength = execute_command("awk 'NR==3 {print \$3 \"%\"} /proc/net/wireless | sed 's/\\\.//g'")
--	wifiwidget.text = wifiStrength
--end

neticon = widget ({ type = "imagebox" })
neticon.resize = false
neticontimer = timer({ timeout = 2 })
neticon.image = image(awful.util.getdir("config") .. "/icons/error1.png")
neticontimer:add_signal("timeout",
	function()
		if os.execute("grep eth0 /proc/net/route > /dev/null") == 0 then
			neticon.image = image(awful.util.getdir("config") .. "/icons/net_wired.png")
		elseif os.execute("grep wlan0 /proc/net/route > /dev/null") == 0 then
			neticon.image = image(awful.util.getdir("config") .. "/icons/wifi_01.png")
			--awful.hooks.timer.register(5, function()wifiInfo()end)
		elseif os.execute("grep ppp0 /proc/net/route > /dev/null") == 0 then
			neticon.image = image(awful.util.getdir("config") .. "/icons/wireless1.png")
		else neticon.image = image(awful.util.getdir("config") .. "/icons/error1.png")
			end
		end)

neticontimer:start()
eths = {'eth0', 'wlan0', 'ppp0', 'tun0'}
netwidget = widget({type='textbox'})
vicious.register( netwidget, vicious.widgets.net,
	function(widget,args)
		t=''
		for i = 1, #eths do
			e = eths[i]
			if args["{"..e.." carrier}"] == 1 then
				t=t..'|'..e..'(↑'..args['{'..e..' up_kb}']..' ↓'..args['{'..e..' down_kb}']..')'
			end
		end
		if string.len(t)>0 then -- remove leading '|'
			return string.sub(t,2,-1)
		end
		return 'No network'
		end, 1 )


--
-- bat0 widget
baticon = widget ({type = "imagebox" })
baticon.image = image(awful.util.getdir("config") .. "/icons/bat_full_02.png")
baticon.resize = false
batwidget = widget({ type = "textbox" })
	function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
		end

	function battery()
		local output = ''
		local batpath = "/sys/devices/platform/smapi/BAT0"

		file = io.open(batpath .. "/state", "r")
		local state = file:read()
		file:close()

		file = io.open(batpath .. "/remaining_percent", "r")
		local percent = file:read("*n")
		file:close()

		file = io.open(batpath .. "/remaining_running_time", "r")
		local time = file:read()
		if (time == "not_discharging") then
			rtime = time
		else
			rtime = round(time/60,1)
			end
		file:close()

		local file = io.open(batpath .. "/power_now", "r")
		local watt = round(file:read("*n")/1000,1)
		file:close()

		if(state == "discharging") then
			baticon.image = image(awful.util.getdir("config") .. "/icons/bat_full_02.png")
			output = percent .. "% " .. watt .. "W " .. rtime .. "h"
			if(percent < 5) then
				baticon.image = image(awful.util.getdir("config") .. "/icons/bat_empty_02_red.png")
				sexec("sudo pm-suspend")
			elseif(percent < 10) then
				baticon.image = image(awful.util.getdir("config") .. "/icons/bat_empty_02_red.png")
			elseif(percent < 25) then
				baticon.image = image(awful.util.getdir("config") .. "/icons/bat_low_02.png")
			else
				baticon.image = image(awful.util.getdir("config") .. "/icons/bat_full_02.png")
			end
		elseif (state == "charging") then
			baticon.image = image(awful.util.getdir("config") .. "/icons/ac_01.png")
			file = io.open(batpath .. "/remaining_charging_time", "r")
			local time = file:read()
			file:close()
			output = percent .. "% " .. time .. "m"
		elseif (state == "idle") then
			baticon.image = image(awful.util.getdir("config") .. "/icons/ac_01.png")
			output = "AC"
		else
			output = "N/A"
			end
		return output
		end

batwidget.text = battery()
battimer = timer({ timeout = 5 })
battimer:add_signal("timeout", function() batwidget.text = battery() end)
battimer:start()

--
-- Volume widget
volumecfgicon = widget ({type = "imagebox" })
volumecfgicon.resize = false
volumecfg = {}
volumecfg.cardid  = 0
volumecfg.channel = "Master"
volumecfg.widget = widget({ type = "textbox", name = "volumecfg.widget", align = "left" })
volumecfg.mixercommand = function (command)
	local fd = io.popen("amixer -c " .. volumecfg.cardid .. command)
	local status = fd:read("*all")
	fd:close()

	local volume = string.match(status, "(%d?%d?%d)%%")
	volume = string.format("% 3d", volume)
	status = string.match(status, "%[(o[^%]]*)%]")
		if string.find(status, "on", 1, true) then
			volume = volume .. "%"
			volumecfgicon.image = image(awful.util.getdir("config") .. "/icons/spkr_01_red.png")
		else
			volume = volume .. "%"
			volumecfgicon.image = image(awful.util.getdir("config") .. "/icons/spkr_02.png")
			end
	volumecfg.widget.text = volume
	end

volumecfg.update = function ()
	volumecfg.mixercommand(" sget " .. volumecfg.channel)
	end
volumecfg.up = function ()
	volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 10%+")
	end
volumecfg.down = function ()
	volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 10%-")
	end
volumecfg.toggle = function ()
	volumecfg.mixercommand(" sset " .. volumecfg.channel .. " toggle")
	end
volumecfg.widget:buttons({awful.util.table.join(
	awful.button({ }, 4, function () volumecfg.up() end),
	awful.button({ }, 5, function () volumecfg.down() end),
	awful.button({ }, 1, function () volumecfg.toggle() end)
	)})

volumecfg.update()

-- Create a textclock widget
--mytextclock = awful.widget.textclock({ align = "right" })
clockicon = widget ({type = "imagebox" })
clockicon.image = image(awful.util.getdir("config") .. "/icons/clock.png")
clockicon.resize = false
mytextclock = awful.widget.textclock({ align = "right"}, "%H:%M:%S", 1)
--calendar2.addCalendarToWidget(mytextclock, "<span color='red'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
	)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
			end
		end),
	awful.button({ }, 3, function ()
		if instance then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ width=250 })
			end
		end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then
			client.focus:raise()
			end
		end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then
			client.focus:raise()
			end
		end))

for s = 1, screen.count() do
-- Create a promptbox for each screen
mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox[s] = awful.widget.layoutbox(s)
mylayoutbox[s]:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
	awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
-- Create a taglist widget
mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

-- Create a tasklist widget
mytasklist[s] = awful.widget.tasklist(function(c)
	-- return awful.widget.tasklist.label.currenttags(c, s)
	-- Remove tasklist icon
	local tmptask = { awful.widget.tasklist.label.currenttags(c, s) } 
	return tmptask[1], tmptask[2], tmptask[3], nil
	end, mytasklist.buttons)

-- Create the wibox
mywibox[s] = awful.wibox({ position = "top", height = 14, screen = s })
-- Add widgets to the wibox - order matters
mywibox[s].widgets = {{
	mylauncher,
	separator,
	mytaglist[s],
	separator,
	mypromptbox[s],
	layout = awful.widget.layout.horizontal.leftright
	},

	mylayoutbox[s],
	--
	separator,
	mytextclock,
	spacer,
	clockicon,
	--
	separator,
	volumecfg.widget,
	volumecfgicon,
	--
	separator,
	mailwidget,
	spacer,
	mailicon,
	--
	separator,
	batwidget,
	spacer,
	baticon,
	--
	separator,
	cputempwidget,
	spacer,
	thermalicon,
	--
	separator,
	fanwidget,
	spacer,
	fanicon,
	--
	separator,
--	wifisignal,
	netwidget,
	spacer,
	neticon,
	--
	separator,
	--obvious.umts,
	--ctwidget,
	--spacer,
	--weatherwidget,
	--spacer,
	--weathericon,
	--
	--separator,

	s == 1 and mysystray or nil,
	mytasklist[s],
	layout = awful.widget.layout.horizontal.rightleft
	}end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
	))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ }, "XF86Back",   awful.tag.viewprev       ),
	awful.key({ }, "XF86Forward",  awful.tag.viewnext       ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then
				client.focus:raise()
				end
			end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
				end
			end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
		function ()
			-- awful.client.focus.history.previous()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
				end
			end),
	awful.key({ modkey, "Shift"   }, "Tab",
		function ()
			-- awful.client.focus.history.previous()
			awful.client.focus.byidx(1)
			if client.focus then
				client.focus:raise()
				end
			end),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),
	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- ThinkPad volume up/down/mute keys
	awful.key({ }, "XF86AudioRaiseVolume", function () volumecfg.up() end),
	awful.key({ }, "XF86AudioLowerVolume", function () volumecfg.down() end),
	awful.key({ }, "XF86AudioMute", function () volumecfg.toggle() end),
	awful.key({ }, "#198", function () awful.util.spawn("sh /etc/acpi/t510-thinkpad-mutemic.sh > /dev/null 2>&1") end),

	-- Disper
	awful.key({ modkey }, "XF86Forward", function () awful.util.spawn("disper -t right -e") end),
	awful.key({ modkey }, "XF86Back", function () awful.util.spawn("disper -s") end),

	-- Fn+F2,F3
	awful.key({ }, "XF86ScreenSaver", function () awful.util.spawn("sh /etc/acpi/t510-thinkpad-screenlock.sh > /dev/null 2>&1") end),
	awful.key({ }, "XF86Battery", function () awful.util.spawn("sh /etc/acpi/t510-thinkpad-lcdoff.sh > /dev/null 2>&1") end),

	-- Prompt
	awful.key({ modkey,           }, "r",     function () mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey,           }, "x",
			function ()
				awful.prompt.run({ prompt = "Run Lua code: " },
				mypromptbox[mouse.screen].widget,
				awful.util.eval, nil,
				awful.util.getdir("cache") .. "/history_eval")
				end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
			end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
			end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
	keynumber = math.min(9, math.max(#tags[s], keynumber));
	end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewonly(tags[screen][i])
					end
				end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewtoggle(tags[screen][i])
					end
				end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.movetotag(tags[client.focus.screen][i])
					end
				end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.toggletag(tags[client.focus.screen][i])
					end
				end))
			end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set root keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	properties = {
		border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = true,
		keys = clientkeys,
		maximized_vertical   = false,
		maximized_horizontal = false,
		size_hints_honor = false,
		buttons = clientbuttons } },
	{ rule = { class = "MPlayer" },		properties = { floating = true } },
	{ rule = { class = "Iceweasel" },	properties = { floating = false } },
	--{ rule = { class = "Iceweasel" },	properties = { maximized_vertical = true, maximized_horizontal = true } },
	{ rule = { class = "icedove" },		properties = { floating = true } },
	{ rule = { class = "geany" },		properties = { floating = true } },
	{ rule = { class = "gimp" },		properties = { floating = true } },
	{ rule = { class = "Xgps" },		properties = { floating = true },
		callback = function (c)
			--c:geometry({x=0, y=0})
			awful.placement.centered(c,nil)
		end},

-- Open on X screen Y tag
	{ rule = { class = "Iceweasel"},  				properties = { tag = tags[1][2] } },
	{ rule = { class = "URxvt",	instance = "mutt" },  		properties = { tag = tags[1][3] } },
	{ rule = { class = "Icedove",	instance = "Mail"},  		properties = { tag = tags[1][3] } },
	{ rule = { class = "Pcmanfm",	instance = "pcmanfm" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "URxvt",	instance = "vpn_iSAFE" },	properties = { tag = tags[1][5] } },
	{ rule = { class = "mplayer2",	instance = "xv" },		properties = { tag = tags[1][6] } },
	{ rule = { class = "URxvt",	instance = "moc" },		properties = { tag = tags[1][6] } },
	{ rule = { class = "MuPDF",	instance = "mupdf" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "xfreerdp",	instance = "xfreerdp" },	properties = { tag = tags[1][5] } },
	{ rule = { class = "Xgps",	instance = "xgps" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "URxvt",	instance = "mc" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "URxvt",	instance = "ranger" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "URxvt",	instance = "rtorrent" },	properties = { tag = tags[1][4] } },
	{ rule = { class = "Geany",	instance = "geany" },		properties = { tag = tags[1][4] } },
	{ rule = { class = "VirtualBox",	instance = "Qt-subapplication" },		properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	-- awful.titlebar.add(c, { modkey = modkey, height = 12 })

	-- Enable sloppy focus
	c:add_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
				client.focus = c
				end
			end)

-- Urgent window notify
	c:add_signal("property::urgent", function(c)
		if c.urgent then
			c.border_color = beautiful.border_urgent
			naughty.notify({text="!" .. c.name})
			end
		end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
			end
		end
	end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--client.connect_signal("tagged",function(c,new_tag)
--	if ( #(new_tag:clients())==1 ) then
--		c.maximized_horizontal = true
--		c.maximized_vertical = true
--		end
--	end)
--
--client.connect_signal("untagged",function(c,old_tag)
--	if ( #(old_tag:clients())==1 ) then
--		local myclients = old_tag:clients()
--		for _,cl in ipairs(myclients) do             
--			cl.maximized_horizontal = true
--			cl.maximized_vertical = true
--			end
--		end
--	end)

-- }}}

-- Autostart
awful.util.spawn_with_shell("xhost + > /dev/null")
awful.util.spawn_with_shell("xscreensaver -no-splash")
--awful.util.spawn_with_shell("xcalib -d :0 -s 0 -v .icc/thinkpadx201.icc")
--awful.util.spawn_with_shell("sudo /etc/init.d/acpid restart")
--awful.util.spawn_with_shell("conky -q")
--awful.util.spawn_with_shell("/usr/bin/urxvt -depth 32 -bg rgba:0000/0000/0000/cccc -fg grey")
