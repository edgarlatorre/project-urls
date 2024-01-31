local Menu = {}

function Menu:new()
  return setmetatable({
    window_id = nil,
    buffer = nil,
  }, self)
end

function Menu:toggle()
  Menu:open_menu()
end

function Menu:open_menu()
  self.buffer = vim.api.nvim_create_buf(false, true)
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
