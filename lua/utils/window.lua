local M = {}

function M.open_floating_window(content, file_type, opts)
  local lines = type(content) == "string" and vim.split(content, "\n") or content
  if not lines or #lines == 0 then
    lines = { "" }
  end

  local max_width = 0
  for _, l in ipairs(lines) do
    max_width = math.max(max_width, vim.fn.strdisplaywidth(l))
  end

  local width = opts.max_width or math.min(max_width, math.floor(vim.o.columns * 0.4))
  local height = math.min(#lines, opts.max_height or #lines)

  local win_config = {
    relative = "editor",
    row = opts.padding_top or 1,
    col = vim.o.columns - width - (opts.padding_right or 2),
    width = width,
    height = height,
    style = "minimal",
    title = opts.title or " Floating Context ",
    border = opts.border or "rounded",
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

  local win = vim.api.nvim_open_win(buf, false, win_config)

  return buf, win, win_config
end

function M.show_windows_for_buf(buf, windows)
  local entries = windows[buf]
  if not entries then return end

  for _, entry in ipairs(entries) do
    if entry.buf then
      if entry.win and vim.api.nvim_win_is_valid(entry.win) then
        vim.api.nvim_win_close(entry.win, true)
      end

      local new_buf = vim.api.nvim_create_buf(false, true)

      entry.win = vim.api.nvim_open_win(new_buf, false, entry.config or {})

      vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, entry.content)
      vim.api.nvim_buf_set_option(new_buf, "filetype", entry.file_type)
    end
  end
end

function M.hide_windows_for_buf(buf, windows)
  local entries = windows[buf]
  if not entries then return end

  for _, entry in ipairs(entries) do
    if entry.win and vim.api.nvim_win_is_valid(entry.win) and entry.sticky then
      vim.api.nvim_win_close(entry.win, true)
      entry.win = nil
    end
  end
end

return M
