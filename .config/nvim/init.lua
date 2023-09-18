--[[
    _   __      _              ______            _____
   / | / _   __(_____ ___     / ________  ____  / __(_____ _
  /  |/ | | / / / __ `__ \   / /   / __ \/ __ \/ /_/ / __ `/
 / /|  /| |/ / / / / / / /  / /___/ /_/ / / / / __/ / /_/ /
/_/ |_/ |___/_/_/ /_/ /_/   \____/\____/_/ /_/_/ /_/\__, /
                                                   /____/
from https://patorjk.com/software/taag/#p=display&h=3&f=Slant
--]]

-- Do framebuffer detection
if vim.env.TERM == 'linux' then
    vim.g.isFramebuffer = true
else
    vim.g.isFramebuffer = false
end

require('sbp')
