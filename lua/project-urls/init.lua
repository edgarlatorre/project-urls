local Path = require("plenary.path")

local Menu = {}

function Menu:new()
  return setmetatable({
    window_id = nil,
    buffer = nil,
    content = Menu:get_content(),
  }, self)
end

function Menu:get_content(path)
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

function Menu:open_menu()
  if self.content == nil then
    self.content = Menu:get_content()
  end

  if self.buffer == nil then
    self.buffer = vim.api.nvim_create_buf(false, true)
  end

  vim.api.nvim_buf_set_keymap(
    self.buffer,
    "n",
    "<ESC>",
    "<Cmd>lua require('project-urls'):close()<CR>",
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    self.buffer,
    "n",
    "<CR>",
    "<Cmd>lua require('project-urls'):open_url()<CR>",
    { silent = true }
  )

  vim.api.nvim_buf_set_lines(self.buffer, 0, -1, true, self.content)
  vim.api.nvim_buf_set_option(self.buffer, "readonly", true)

  local height = 8
  local width = 69

  vim.api.nvim_open_win(self.buffer, true, {
    relative = "editor",
    row = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    border = "single",
  })
end

function Menu:close()
  if self.buffer ~= nil and vim.api.nvim_buf_is_valid(self.buffer) then
    vim.api.nvim_buf_delete(self.buffer, { force = true })
  end

  if self.window_id ~= nil and vim.api.nvim_win_is_valid(self.window_id) then
    vim.api.nvim_win_close(self.window_id, true)
  end

  self.window_id = nil
  self.buffer = nil
end

function Menu:open_url()
  local index = vim.fn.line(".")

  for content_idx, url in ipairs(self.content) do
    if index == content_idx then
      vim.cmd(":silent! !open " .. url)
      self:close()
      break
    end
  end
end

return Menu
