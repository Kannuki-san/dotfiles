-- Git などの雑用系Overseerテンプレート集

-- 現在の作業ディレクトリをプロジェクトルートとして扱う
local function project_root()
  return vim.fn.getcwd()
end

return {
  {
    -- git status
    name = "Git: status",

    builder = function()
      return {
        cmd = { "git", "status" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- git pull
    name = "Git: pull",

    builder = function()
      return {
        cmd = { "git", "pull" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
