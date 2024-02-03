local Path = require("plenary.path")

local M = {}

local buffer = nil
local window_id = nil
local content = nil

local function get_content(path)
  if path == nil then
    path = vim.loop.cwd() .. "/.project-urls"
  end

  local file_path = Path:new(path)

  if not file_path:exists() then
    return {}
  end

  local urls = {}
  for line in io.lines(path) do
    table.insert(urls, line)
  end

  return urls
end

function M.current_content()
  return content
end

function M.open_menu()
  if content == nil then
    content = get_content()
  end

  if buffer == nil then
    buffer = vim.api.nvim_create_buf(false, true)
  end

  vim.api.nvim_buf_set_keymap(buffer, "n", "<ESC>", "<Cmd>lua require('project-urls').close()<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "<CR>",
    "<Cmd>lua require('project-urls').open_url()<CR>",
    { silent = true }
  )

  vim.api.nvim_buf_set_lines(buffer, 0, -1, true, content)
  vim.api.nvim_buf_set_option(buffer, "readonly", true)

  local height = 8
  local width = 69

  vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    row = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    border = "single",
  })
end

function M.close()
  if buffer ~= nil and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer, { force = true })
  end

  if window_id ~= nil and vim.api.nvim_win_is_valid(window_id) then
    vim.api.nvim_win_close(window_id, true)
  end

  window_id = nil
  buffer = nil
end

function M.open_url()
  local index = vim.fn.line(".")

  for content_idx, url in ipairs(content) do
    if index == content_idx then
      vim.cmd(":silent! !open " .. url)
      M.close()
      break
    end
  end
end

return M
