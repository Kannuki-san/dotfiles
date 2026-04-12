local config_path = vim.fn.stdpath("config") .. "/lua/config"
local files = vim.fn.readdir(config_path)

for _, file in ipairs(files) do
  if file ~= "init.lua" and file:sub(-4) == ".lua" then
    local module = "config." .. file:gsub("%.lua$", "")
    pcall(require, module)
  end
end
