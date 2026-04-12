-- Podman 用のOverseerテンプレート集

-- 現在の作業ディレクトリをプロジェクトルートとして扱う
local function project_root()
  return vim.fn.getcwd()
end

-- ファイルの存在確認をする補助関数
local function has_file(path)
  return vim.fn.filereadable(path) == 1
end

-- compose ファイルがあるプロジェクトかどうかを判定
local function in_project_with_compose()
  local cwd = project_root()

  return has_file(cwd .. "/compose.yaml")
      or has_file(cwd .. "/compose.yml")
      or has_file(cwd .. "/docker-compose.yml")
      or has_file(cwd .. "/docker-compose.yaml")
end

return {
  {
    -- podman compose up
    name = "Podman: compose up",

    condition = {
      callback = function()
        return in_project_with_compose()
      end,
    },

    builder = function()
      return {
        cmd = { "podman", "compose", "up" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- podman compose up -d
    name = "Podman: compose up -d",

    condition = {
      callback = function()
        return in_project_with_compose()
      end,
    },

    builder = function()
      return {
        cmd = { "podman", "compose", "up", "-d" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- podman compose down
    name = "Podman: compose down",

    condition = {
      callback = function()
        return in_project_with_compose()
      end,
    },

    builder = function()
      return {
        cmd = { "podman", "compose", "down" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- podman compose logs -f
    name = "Podman: compose logs -f",

    condition = {
      callback = function()
        return in_project_with_compose()
      end,
    },

    builder = function()
      return {
        cmd = { "podman", "compose", "logs", "-f" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- 起動中のコンテナ一覧
    name = "Podman: ps",

    builder = function()
      return {
        cmd = { "podman", "ps" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- ローカルイメージ一覧
    name = "Podman: images",

    builder = function()
      return {
        cmd = { "podman", "images" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
