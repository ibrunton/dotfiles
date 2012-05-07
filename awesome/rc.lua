-- awesome wm config by Ian Brunton
-- inspired by intrntbrn
-- Thu 03 May 2012

-- standard libraries
require ("awful")
require ("awful.autofocus")
require ("awful.rules")
require ("beautiful")
require ("naughty")
require ("vicious")

-- custom libraries
require ("gmail")

if awesome.startup_errors then
	naughty.notify ({ preset = naughty.config.presets.critical,
					title = "Oops, there were errors during startup!",
					text = awesome.startup_errors })
end

do
	local in_error = false
	awesome.add_signal ("debug::error", function (err)
		if in_error then return end
		in_error = true

		naughty.notify ({ preset = naughty.config.presets.critical,
						title = "Oops, an error occurred!",
						text = err })
		in_error = false
	end)
end

-- theme
beautiful.init ("/home/ian/.config/awesome/themes/intrntbrn_green.lua")

-- misc
barheight = 16
--borderwidth = 0
space = 48
snap = 20

-- path
config = awful.util.getdir ("config")
icons = "/home/ian/.config/icons/newgreen/"
iconsmenu = icons .. "menu/"

-- programs
terminal = "urxvt"
editor = os.getenv ("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- alias
modkey = "Mod4"
--exec = awful.util.spawn
--sexec = awful.util.spawn_with_shell

-- layouts
layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.max
}

-- tags
tags = {
	names = { "term", "www", "xdr", "dev", "doc", "etc" },
	layout = { layouts[2], layouts[2], layouts[1], layouts[2], layouts[1], layouts[1] },
	icons = { nil, icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png" }
}

for s = 1, screen.count () do
	tags[s] = awful.tag (tags.names, s, tags.layout)
	awful.tag.setproperty (tags[s][2], "mwfact", 0.75)
	awful.tag.setproperty (tags[s][4], "mwfact", 0.55)

	for i, t in ipairs (tags[s]) do
		awful.tag.seticon (tags.icons[i], t)
	end
end

-- autostart
awful.util.spawn_with_shell ("nitrogen --restore")

-- autostop
awesome.add_signal ("exit", function () awful.util.spawn ("atexit.sh") end)

-- mouse bindings
root.buttons (awful.util.table.join (
	awful.button ({}, 3, function () mymainmenu:toggle () end),
	awful.button ({}, 4, awful.tag.viewnext),
	awful.button ({}, 5, awful.tag.viewprev)))

require ("menu")
require ("keys")
require ("rules")

-- wibox
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mysystray = widget ({ type = "systray" })

mytaglist = {}
mytaglist.buttons = awful.util.table.join (
	awful.button ({}, 1, awful.tag.viewonly),
	awful.button ({modkey}, 1, awful.client.movetotag),
	awful.button ({}, 3, awful.tag.viewtoggle),
	awful.button ({modkey}, 3, awful.client.toggletag)
	--awful.button ({}, 4, awful.tag.viewnext),
	--awful.button ({}, 5, awful.tag.viewprev)
	)

mytasklist = {}
mytasklist.buttons = awful.util.table.join (
	awful.button ({}, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			if not c:isvisible () then
				awful.tag.viewonly (c:tags ()[1])
			end
			-- This will also un-minimize the client, if needed
			client.focus = c
			c:raise ()
		end
	end),
	awful.button ({}, 3, function ()
		if instance then
			instance:hide ()
			instance = nil
		else
			instance = awful.menu.clients ({ width = 250 })
		end
	end),
	awful.button ({}, 4, function ()
		awful.client.focus.byidx (1)
		if client.focus then client.focus:raise () end
	end),
	awful.button ({}, 5, function ()
		awful.client.focus.byidx (-1)
		if client.focus then client.focus:raise () end
	end))

-- widgets
-- spacer
spacer = widget ({ type = "textbox" })
spacer.text = " "

-- separator
separator = widget ({ type = "imagebox" })
separator.image = image (icons .. "separator.png" )

-- clock
myclock = awful.widget.textclock ({ align = "right" }, "%a %d %b, <b>%H:%M</b>", 5)

-- memory load
mymem = widget ({ type = "textbox" })
vicious.register (mymem, vicious.widgets.mem, "$1%", 30)
mymem.width = space

mymemicon = widget ({ type = "imagebox" })
mymemicon.image = image (icons .. "mem.png")

-- cpu load
mycpu = widget ({ type = "textbox" })
vicious.register (mycpu, vicious.widgets.cpu, "$1%", 5)
mycpu.width = space

mycpuicon = widget ({ type = "imagebox" })
mycpuicon.image = image (icons .. "cpu.png")

-- file system
myfs = widget ({ type = "textbox" })
vicious.register (myfs, vicious.widgets.fs, "root ${/ used_p}% home ${/home used_p}%")
--myfs.width = space

myfsicon = widget ({ type = "imagebox" })
myfsicon.image = image (icons .. "diskette.png")

-- volume
myvolicon = widget ({ type = "imagebox" })
myvolicon.image = image (icons .. "spkr_01.png")

myvol = widget ({ type = "textbox" })
vicious.register (myvol, vicious.widgets.volume,
	function (widget, args)
		if ((args[1] < 1) or (args[2] == "off")) then
			myvolicon.image = image (icons .. "spkr_02.png")
			return "mute"
		else
			myvolicon.image = image (icons .. "spkr_01.png")
			return args[1] .. "%"
		end
	end, 2, "Master")
myvol.width = space

--myvolicon:buttons (awful.util.table.join (
	--awful.button ({}, 1, function () sexec ("sh ~/bin/vol.sh mute", false) end)))

-- pacman
mypacicon = widget ({ type = "imagebox" })
mypacicon.image = image (icons .. "pacman.png")

mypac = widget ({ type = "textbox" })
vicious.register (mypac, vicious.widgets.pkg,
	function (widget, args)
		if args[1] > 0 then
            return "<b><span color=\"" .. beautiful.fg_urgent .. "\">" .. args[1] .. "</span></b>"
        else
        	return args[1]
        end
	end, 900, "Arch")
mypac.width = space

-- gmail: wolf
mygmailicon_w = widget ({type = "imagebox" })
mygmailicon_w.image = image (icons .. "mail.png")

mygmail_w = widget ({ type = "textbox" })
vicious.register (mygmail_w, vicious.widgets.gmail_custom,
	function (widget, args)
		if args["{count}"] > 0 then
			mygmailicon_w.image = image (icons .. "mail_new.png")
			return "wolf <b><span color=\"" .. beautiful.fg_urgent .. "\">" .. args["{count}"] .. "</span></b>"
		else
			return "wolf 0"
		end
	end, 300, { netrcfile = "/home/ian/.config/netrc_wolfshift", inbox = "/home/ian/.local/share/inbox_wolfshift" })
mygmail_w.width = space

-- gmail: ian
mygmailicon_i = widget ({type = "imagebox" })
mygmailicon_i.image = image (icons .. "mail.png")

mygmail_i = widget ({ type = "textbox" })
vicious.register (mygmail_i, vicious.widgets.gmail_custom,
	function (widget, args)
		if args["{count}"] > 0 then
			mygmailicon_i.image = image (icons .. "mail_new.png")
			return "ian <b><span color=\"" .. beautiful.fg_urgent .. "\">" .. args["{count}"] .. "</span></b>"
		else
			return "ian 0"
		end
	end, 300, { netrcfile = "/home/ian/.config/netrc_iandbrunton", inbox = "/home/ian/.local/share/inbox_iandbrunton" })
mygmail_i.width = space



for s = 1, screen.count () do
	mypromptbox[s] = awful.widget.prompt ({ layout = awful.widget.layout.horizontal.leftright })
	mylayoutbox[s] = awful.widget.layoutbox (s)
	mylayoutbox[s]:buttons (awful.util.table.join (
		awful.button ({}, 1, function () awful.layout.inc (layouts, 1) end),
		awful.button ({}, 3, function () awful.layout.inc (layouts, -1) end)))
	
	mytaglist[s] = awful.widget.taglist (s, awful.widget.taglist.label.all, mytaglist.buttons)

	mytasklist[s] = awful.widget.tasklist (function (c)
		return awful.widget.tasklist.label.focused (c, s)
	end, mytasklist.buttons)

	mywibox[s] = awful.wibox ({ position = "top", screen = s })

	mywibox[s].widgets = {
		{
			mylauncher,
			spacer,
			mytaglist[s],
			spacer,
			mylayoutbox[s],
			spacer,
			spacer,
			spacer,
			mypromptbox[s],
			layout = awful.widget.layout.horizontal.leftright
		},

		spacer,
		myclock,
		spacer,
		mysystray,
		spacer,
		separator,
		spacer,
		mygmail_i,
		mygmailicon_i,
		spacer,
		mygmail_w,
		mygmailicon_w,
		spacer,
		mypac,
		mypacicon,
		spacer,
		myvol,
		myvolicon,
		spacer,
		myfs,
		myfsicon,
		spacer,
		mymem,
		mymemicon,
		spacer,
		mycpu,
		mycpuicon,
		spacer,
		mytasklist[s],
		layout = awful.widget.layout.horizontal.rightleft
	}
end

-- signals
client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	-- awful.titlebar.add(c, { modkey = modkey })

	-- Enable sloppy focus
	-- c:add_signal("mouse::enter", function(c)
	--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
	--         and awful.client.focus.filter(c) then
	--         client.focus = c
	--     end
	-- end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

