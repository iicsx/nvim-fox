local M = {}

function M.open_floating_window(content, file_type)
  local lines = type(content) == "string" and vim.split(content, "\n") or content
  if not lines or #lines == 0 then
    lines = { "" }
  end

  local max_width = 0
  for _, l in ipairs(lines) do
    max_width = math.max(max_width, vim.fn.strdisplaywidth(l))
  end

  local width = math.min(max_width, math.floor(vim.o.columns * 0.4))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.3))

  vim.notify(height)
  vim.notify(#lines)

  local win_config = {
    relative = "editor",
    row = 1,
    col = vim.o.columns - width - 2, -- top right
    width = width,
    height = #lines,
    style = "minimal",
    title = " Floating Context ",
    border = "rounded",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  if not buf then return end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  if file_type then
    vim.api.nvim_buf_set_option(buf, "filetype", file_type)
  end

  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "wrap", true)
  vim.api.nvim_buf_set_option(buf, "linebreak", true)

  local win = vim.api.nvim_open_win(buf, true, win_config)
end

return M
