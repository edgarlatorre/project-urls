local context_manager = require("plenary.context_manager")

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

  local urls = {}
  for line in io.lines(path) do
    table.insert(urls, line)
  end

  return urls
end

function Menu:toggle()
  Menu:open_menu()
end

function Menu:open_menu()
  if self.content == nil then
    self.content = Menu:get_content()
  end

  self.buffer = vim.api.nvim_create_buf(false, true)
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

return Menu
