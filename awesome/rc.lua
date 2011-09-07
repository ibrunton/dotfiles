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

-- {{{ Variable definitions
-- get hostname so can use same git repo for multiple machines
desktop_hostname = "green"
laptop_hostname = "hakkoz"

-- n = os.tmpname()
-- os.execute("uname -n > " .. n)
-- for line in io.lines (n) do
--     hostname = line
-- end
-- os.remove(n)
hostname = "green"

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/ian/.config/awesome/themes/" .. hostname .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
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
if hostname == desktop_hostname then
    tags = {
	names = { "term", "www", "xedr", "dev", "doc", "etc" },
	layout = { layouts[2], layouts[2], layouts[1], layouts[2], layouts[1], layouts[1] }
    }
elseif hostname == laptop_hostname then
    tags = {
	names = { "1", "2", "3", "4" },
	layout = { layouts[2], layouts[2], layouts[1], layouts[1] }
    }
end

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
   awful.tag.setproperty(tags[s][2], "mwfact", 0.75)
   awful.tag.setproperty(tags[s][4], "mwfact", 0.55)
end
-- }}}

-- {{{ Autostart
awful.util.spawn_with_shell("nitrogen --restore")
-- }}}
-- {{{ Autostop
awesome.add_signal("exit", function() awful.util.spawn("atexit.sh") end)
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

myofficemenu = {
   { "writer", "lowriter" },
   { "calc", "localc" },
   { "okular", "okular" }
}

mymediamenu = {
   { "gimp", "gimp" },
   { "k3b", "k3b" },
   { "vlc", "vlc" }
}

mygamesmenu = {
   { "minecraft", "minecraft" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "terminal", terminal },
				    { "emacsclient", terminal .. " -e emacsclient -nw -e \"(transbg)\"" },
					-- { "opera", "opera" },
					{ "firefox", "firefox" },
				    { "dolphin", "dolphin" },
				    { "nitrogen", "nitrogen" },
				    { "office", myofficemenu },
				    { "media", mymediamenu },
				    { "games", mygamesmenu },
					--{ "Suspend", "kdialog --yesno 'Are you sure you want to suspend?' && sudo pm-suspend" },
				    { "Log out", '/home/ian/bin/slrh.sh' }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %d %b, %H:%M ", 5)

-- Gmail widgets 
-- NB: passing nil as 4th argument results in instantaneous updating,
-- but at a performance penalty for awesome overall.
mygmail1 = widget({ type = "textbox" })
vicious.register(mygmail1, vicious.widgets.gmail_custom, " ian ${count} ", 300, "/home/ian/.config/gmail_i_rc")

-- customised version of the above widget to use a specified netrc file:
mygmail2 = widget({ type = "textbox" })
vicious.register(mygmail2, vicious.widgets.gmail_custom, " wolf ${count} ", 300, "/home/ian/.config/gmail_w_rc")

-- CPU meter
mycpu = widget({ type = "textbox" })
vicious.register(mycpu, vicious.widgets.cpu, " cpu $1% ")

-- file system
myfs = widget({ type = "textbox" })
vicious.register(myfs, vicious.widgets.fs, " root ${/ used_p}% home ${/home used_p}% ")

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
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            --mylauncher,
            mytaglist[s],
            mylayoutbox[s],
	    spacer,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        mytextclock,
	separator,
	mygmail1,
	mygmail2,
	--netwidget,
	hostname == laptop_hostname and batterywidget or nil,
	myfs,
	mycpu,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Move Mouse Cursor out of the way
--local safeCoords = {x=1680, y=1050}
--local safeCoords = {x=840, y=0}
local safeCoords = {x=210, y=0}
--local moveMouseOnStartup = true
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
for s = 1, screen.count() do
   tags[1][1]:add_signal("property::selected", function (tag)
						  moveMouse(safeCoords.x,safeCoords.y)
					       end)
   tags[1][4]:add_signal("property::selected", function (tag)
						  moveMouse(safeCoords.x, safeCoords.y)
					       end)
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    --awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
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

    awful.key({ modkey, "Control" }, "m", function() moveMouse(safeCoords.x, safeCoords.y) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- dmenu prompt:
    awful.key({ modkey },	     "p",     function () 
	awful.util.spawn("dmenu_run -i -p 'Run:' -nb '" ..
		string.sub(beautiful.bg_normal, 1, 7) ..
		"' -nf '" .. beautiful.fg_normal ..
		"' -sb '" .. string.sub(beautiful.bg_focus, 1, 7) ..
		"' -sf '" .. beautiful.fg_focus .. "'")
    end),
    -- Lua prompt:
    awful.key({ modkey }, "x",
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

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
      properties = { border_width = beautiful.border_width,
	 border_color = beautiful.border_normal,
	 focus = true,
	 keys = clientkeys,
	 buttons = clientbuttons } },
   { rule = { class = "gimp" },
      properties = { tag = tags[1][6],
	floating = true } },
   
   { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },

   { rule = { class = "Opera" },
      properties = { tag = tags[1][2] } },
   
   { rule = { class = "okular" },
      properties = { tag = tags[1][5] } }
}
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
