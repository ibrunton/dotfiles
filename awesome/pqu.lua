--------------------------------------------------------
-- Licensed under the GNU General Public License v3
-- * (c) 2012, Ian D. Brunton <iandbrunton at gmail.com>
--------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local tabel = { insert = table.insert }
--local string = { match = string.match }
--local helpers = require ("vicious.helpers")
-- }}}

-- PQU: provides number and list of Pacman updates available
module ("vicious.widgets.pqu")

local pacman_info = {
	["{count}"] = 0,
	["{packages}"] = {}
}

local function worker (format, warg)
	local f = io.popen ("pacman -Qu")
	local count = 0;
	
	for line in f:lines () do
		count = count + 1
--		table.insert (pacman_info["{packages}"], line)
	end
	f:close ()

	if count > 0 then
		pacman_info["{count}"] = "<span weight=\"bold\" color=\"" .. warg.colour .. "\">" .. count .. "</span>"
	else
		pacman_info["{count}"] = count
	end

	return pacman_info
end

setmetatable (_M, { __call = function (_, ...) return worker (...) end })
