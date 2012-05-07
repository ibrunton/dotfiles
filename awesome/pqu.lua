--------------------------------------------------------
-- Licensed under the GNU General Public License v3
-- * (c) 2012, Ian D. Brunton <iandbrunton at gmail.com>
--------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local table = { insert = table.insert }
--local string = { match = string.match }
--local helpers = require ("vicious.helpers")
-- }}}

-- PQU: provides number and list of Pacman updates available
module ("vicious.widgets.pqu")

local pacman_info = {
	["{count}"] = 0,
	["{packages}"] = {"N/A"}
}

local function worker (format, warg)
	local f = io.popen ("pacman -Qu")
	local count = 0
	
	for line in f:lines () do
		count = count + 1
		pacman_info["{packages}"][count] = line
	end
	f:close ()

	pacman_info["{count}"] = count
	return pacman_info
end

setmetatable (_M, { __call = function (_, ...) return worker (...) end })
