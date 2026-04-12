-- Make / shell / 雑な実行系のOverseerテンプレート集

-- 現在のファイルの絶対パスを返す
local function current_file()
  return vim.fn.expand("%:p")
end

-- 現在のファイルがあるディレクトリを返す
local function current_dir()
  return vim.fn.expand("%:p:h")
end

-- 現在の作業ディレクトリをプロジェクトルートとして扱う
local function project_root()
  return vim.fn.getcwd()
end

return {
  {
    -- make
    name = "Build: make",

    builder = function()
      return {
        cmd = { "make" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- make test
    name = "Build: make test",

    builder = function()
      return {
        cmd = { "make", "test" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- 現在開いているシェルスクリプトを bash で実行
    name = "Shell: run current file",

    condition = {
      filetype = { "sh", "bash", "zsh" },
    },

    builder = function()
      local file = current_file()

      return {
        cmd = { "bash", file },
        cwd = current_dir(),
        components = { "default" },
        name = "bash " .. vim.fn.expand("%:t"),
      }
    end,
  },

  {
    -- filetype に応じて現在のファイルを雑に実行
    name = "Run: current file",

    builder = function()
      local ft = vim.bo.filetype
      local file = current_file()
      local cwd = current_dir()

      -- filetype ごとの実行コマンド
      local cmd_map = {
        python = { "uv", "run", file },
        lua = { "lua", file },
        sh = { "bash", file },
        bash = { "bash", file },
        zsh = { "zsh", file },
        javascript = { "node", file },
      }

      local cmd = cmd_map[ft]

      -- 未対応 filetype のときは候補に出さない
      if not cmd then
        return nil
      end

      return {
        cmd = cmd,
        cwd = cwd,
        components = { "default" },
        name = "Run " .. vim.fn.expand("%:t"),
      }
    end,
  },
}
