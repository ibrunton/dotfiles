---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
--  * (c) 2011, Ian Brunton <iandbrunton at gmail. com>
---------------------------------------------------

-- {{{ Grab environment
local type = type
local tonumber = tonumber
local io = { popen = io.popen, open = io.open }
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
local string = {
    find = string.find,
    match = string.match
}
-- }}}


-- Gmail: provides count of new and subject of last e-mail on Gmail
module("vicious.widgets.gmail_custom")


-- {{{ Variable definitions
local rss = {
  inbox   = {
    "https://mail.google.com/mail/feed/atom",
    "Gmail %- Inbox"
  },
  unread  = {
    "https://mail.google.com/mail/feed/atom/unread",
    "Gmail %- Label"
  },
  --labelname = {
  --  "https://mail.google.com/mail/feed/atom/labelname",
  --  "Gmail %- Label"
  --},
}

-- Default is just Inbox
local feed = rss.inbox
local mail = {
    ["{count}"]   = 0,
    ["{subject}"] = "N/A",
    ["{inbox}"] = {"N/A"}
}
-- }}}


-- {{{ Gmail widget type
local function worker(format, warg)
    -- Get info from the Gmail atom feed
    local f = io.popen("curl --connect-timeout 1 -m 3 -fs --netrc-file " .. warg.netrcfile .. " " .. feed[1])
    local count = 0

    -- Could be huge don't read it all at once, info we are after is at the top
    for line in f:lines() do
        mail["{count}"] = -- Count comes before messages and matches at least 0
          tonumber(string.match(line, "<fullcount>([%d]+)</fullcount>")) or mail["{count}"]

        -- Find subject tags
        local title = string.match(line, "<title>(.*)</title>")

        if title ~= nil and not string.find(title, feed[2]) then
            count = count + 1
            -- Spam sanitize the subject and store
            mail["{inbox}"][count] = helpers.escape (title)
        end
    end
    
    local fout = io.open (warg.inbox)
    fout:write (f:read ("*a"), "w+")
    fout:close ()

    f:close()

    return mail
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
