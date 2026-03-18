local tables = require("utils.tables")

local M = {}

local defaults = {
  default = {},
}

function M.verify(opts)
  if opts == nil then
    opts = defaults
  else
    opts = tables.merge_tables(defaults, opts) or defaults
  end

  return opts
end

return M
