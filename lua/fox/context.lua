local window = require("utils.window")
local tables = require("utils.tables")

local M = {}

function M.context()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]


  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  if #lines == 0 then return end

  local start_col = start_pos[3]
  local end_col = end_pos[3]

  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  local file_type = vim.bo.filetype

  window.open_floating_window(lines, file_type)
end

function M.setup(opts)
  local cmd_opts = tables.merge_tables(
    opts.default or {},
    opts.commit or {}
  )

  if opts.enable ~= false then
    vim.api.nvim_create_user_command('FloatingContext', function()
      M.context()
    end, { range = true })
  end
end

return M
