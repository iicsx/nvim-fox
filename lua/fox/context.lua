local window = require("utils.window")
local tables = require("utils.tables")

local M = {}

M.windows = {}
M.current_context = {}

function M.context(opts)
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

  local floating_buffer, floating_window, config = window.open_floating_window(lines, file_type, opts)
  -- M.save_window(parent_buf, floating_buffer, floating_window, config)
  M.current_context = {
    win = floating_window,
    buf = floating_buffer,
    config = config,
    sticky = true
  }
end

function M.toggle_sticky(opts)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)

  local buf = M.windows[current_buf]
  if not buf then
    M.windows[current_buf] = {}

    M.current_context.sticky = true
    M.current_context.config.title = "  Floating Context "

    if M.current_context.win and vim.api.nvim_win_is_valid(M.current_context.win) then
      vim.api.nvim_win_set_config(M.current_context.win, M.current_context.config)
    end

    table.insert(M.windows[current_buf], M.current_context)
    M.current_context = nil
  else
    buf = buf[1]
    if not buf then return end

    buf.sticky = false
    buf.config = buf.config or {}
    buf.config.title = " Floating Context "

    if buf.win and vim.api.nvim_win_is_valid(buf.win) then
      vim.api.nvim_win_set_config(buf.win, buf.config)
    end

    M.current_context = buf
  end
end

function M.nuke_window(opts)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)

  local buf = M.windows[current_buf]
  if buf then
    buf = buf[1]

    if buf.win and vim.api.nvim_win_is_valid(buf.win) and buf.sticky then
      vim.api.nvim_win_close(buf.win, true)
      M.windows[current_buf] = nil
      return
    end
  end

  local context = M.current_context
  if context and context.buf and context.win then
    vim.api.nvim_win_close(context.win, true)
    M.current_context = nil
    return
  end
end

function M.setup(opts)
  local cmd_opts = tables.merge_tables(
    opts.default or {},
    opts.context or {}
  )

  if opts.enable ~= false then
    vim.api.nvim_create_user_command('FoxOpen', function()
      M.context(cmd_opts or {})
    end, { range = true })

    vim.api.nvim_create_user_command('FoxSticky', function()
      M.toggle_sticky(cmd_opts or {})
    end, {})

    vim.api.nvim_create_user_command('FoxClose', function()
      M.nuke_window(cmd_opts or {})
    end, {})

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(args)
        window.show_windows_for_buf(args.buf, M.windows)
      end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      callback = function(args)
        window.hide_windows_for_buf(args.buf, M.windows)
      end,
    })
  end
end

return M
