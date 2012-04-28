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
   { "kpatience", "kpatience" },
   { "kBlackBox", "kblackbox" },
   { "kMahjongg", "kmahjongg" },
   { "kMines", "kmines" },
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


