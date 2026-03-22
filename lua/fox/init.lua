local modules = {
  context = require("fox.context")
}
local args = require("utils.args")

local M = {}

M.modules = modules

function M.setup(opts)
  opts = args.verify(opts)

  for table, opt in pairs(opts) do
    if opt.enable ~= false then
      if table == "default" then goto continue end

      local field = modules[table]
      if field then
        field.setup(opts)
      end

      ::continue::
    end
  end
end

return M
