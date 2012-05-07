-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
	 properties = { border_width = beautiful.border_width,
					border_color = beautiful.border_normal,
					focus = true,
					keys = clientkeys,
					size_hints_honor = false,
					buttons = clientbuttons } },

   { rule = { class = "gimp" },
	 properties = { tag = tags[1][6],
					floating = true } },
   
   { rule = { class = "Firefox" },
	 properties = { tag = tags[1][2],
                    floating = false } },

   { rule = { class = "Firefox", instance = "Save Image" },
   	 properties = { floating = true } },
   
   { rule = { class = "Opera" },
	 properties = { tag = tags[1][2] } },
   
   { rule = { class = "Okular" },
	 properties = { tag = tags[1][5] } },

   { rule = { class = "URxvt" },
	 properties = { border_width = 2 } },

   { rule = { class = "URxvt", instance = "MAILTO" },
	 properties = { floating = true } },

	--{ rule = { _NET_WM_WINDOW_TYPE = "_NET_WM_WINDOW_TYPE_DIALOG" },
	--	properties = { floating = true } }
}
-- }}}

