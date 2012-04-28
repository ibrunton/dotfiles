-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widget library
require("vicious")
-- customised version of vicious gmail widget
require("gmail")
require("pqu")

if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
					title = "Oops, there were errors during startup!",
					text = awesome.startup_errors })
end

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

-- {{{ Variable definitions
theme = "green"
snap = 20

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/ian/.config/awesome/themes/" .. theme .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.max
   --awful.layout.suit.fair,
   --awful.layout.suit.fair.horizontal,
   --awful.layout.suit.spiral,
   --awful.layout.suit.spiral.dwindle,
   --awful.layout.suit.max.fullscreen,
   --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
   names = { "term", "www", "xdr", "dev", "doc", "etc" },
   layout = { layouts[2], layouts[2], layouts[1], layouts[2], layouts[1], layouts[1] }
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
   awful.tag.setproperty(tags[s][2], "mwfact", 0.75)
   awful.tag.setproperty(tags[s][4], "mwfact", 0.55)
end
-- }}}

-- {{{ Autostart
awful.util.spawn_with_shell("nitrogen --restore")
--awful.util.spawn_with_shell("/home/ian/bin/awesomeconky.sh")
-- }}}
-- {{{ Autostop
awesome.add_signal("exit", function() awful.util.spawn("atexit.sh") end)
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
				awful.button({ }, 3, function () mymainmenu:toggle() end),
				awful.button({ }, 4, awful.tag.viewnext),
				awful.button({ }, 5, awful.tag.viewprev)
								  ))
-- }}}

-- {{{ Move Mouse Cursor out of the way
--local moveMouseOnStartup = true
--local moveMouseOnTiled = true
local safeCoords = {x=210, y=0}
local function moveMouse(x_co, y_co)
   mouse.coords({ x=x_co, y=y_co })
end
-- }}}


-- Optionally move the mouse when rc.lua is read (startup)
if moveMouseOnStartup then
   moveMouse(safeCoords.x, safeCoords.y)
end

-- Move the mouse out of the way when switching to tiled
-- terminal/emacs tags
if moveMouseOnTiled then
   for s = 1, screen.count() do
	  tags[1][1]:add_signal("property::selected", function (tag)
							   moveMouse(safeCoords.x,safeCoords.y)
												  end)
	  tags[1][4]:add_signal("property::selected", function (tag)
							   moveMouse(safeCoords.x, safeCoords.y)
												  end)
   end
end

-- The order of these 3 is important, and they must come before the wibox
require ("menu")

require ("keys")

require ("rules")


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %d %b, <span weight=\"bold\">%H:%M</span> ", 5)

-- Gmail widgets 
mygmail1 = widget({ type = "textbox" })
vicious.register(mygmail1, vicious.widgets.gmail_custom, " ian ${count} ", 300, { colour = beautiful.fg_focus, netrcfile = "/home/ian/.config/gmail_i_rc" })

mygmail2 = widget({ type = "textbox" })
vicious.register(mygmail2, vicious.widgets.gmail_custom, " wolf ${count} ", 300, { colour = beautiful.fg_focus, netrcfile = "/home/ian/.config/gmail_w_rc" })

-- CPU meter
mycpu = widget({ type = "textbox" })
vicious.register(mycpu, vicious.widgets.cpu, " cpu $1% ")

-- file system
myfs = widget({ type = "textbox" })
vicious.register(myfs, vicious.widgets.fs, " root ${/ used_p}% home ${/home used_p}% ")

-- pacman updates
mypqu = widget({ type = "textbox" })
vicious.register(mypqu, vicious.widgets.pqu, " pac ${count} ", 600, { colour = beautiful.fg_focus })

-- network traffic
--netwidget = widget({ type = "textbox" })
--vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)

-- battery monitor
--batterywidget = widget({ type = "textbox" })
--vicious.register(batterywidget, vicious.widgets.bat, " $1 $2 ($3) ", "BAT0")

-- separator
separator = widget({ type = "textbox" })
separator.text = " :: "

-- spacer
spacer = widget({ type = "textbox" })
spacer.text = "  "

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
                    awful.button({ modkey }, 3, awful.client.toggletag)
                    -- awful.button({ }, 4, awful.tag.viewnext),
                    -- awful.button({ }, 5, awful.tag.viewprev)
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
				   if client.focus then client.focus:raise() end
						end),
   awful.button({ }, 5, function ()
				   awful.client.focus.byidx(-1)
				   if client.focus then client.focus:raise() end
						end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
							 awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
							 awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)))
   -- awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
   -- awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
   
   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(function(c)
											--return awful.widget.tasklist.label.currenttags(c, s)
											return awful.widget.tasklist.label.focused(c,s)
										 end, mytasklist.buttons)
   
   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s })
   -- Add widgets to the wibox - order matters
   mywibox[s].widgets = {
	  {
		 mylauncher,
		 mytaglist[s],
		 mylayoutbox[s],
		 spacer,
		 mypromptbox[s],
		 layout = awful.widget.layout.horizontal.leftright
	  },
	  mytextclock,
	  separator,
	  s == 1 and mysystray or nil,
	  separator,
	  mygmail1,
	  mygmail2,
	  mypqu,
	  myfs,
	  mycpu,
	  mytasklist[s],
	  layout = awful.widget.layout.horizontal.rightleft
   }
end
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
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
-- }}}
--
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=4:softtabstop=4:textwidth=80
