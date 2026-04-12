-- Node / frontend 系のOverseerテンプレート集

-- 現在の作業ディレクトリをプロジェクトルートとして扱う
local function project_root()
  return vim.fn.getcwd()
end

-- JS/TS/フロント系で共通利用する filetype 一覧
local node_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "json",
}

return {
  {
    -- npm run dev
    name = "Node: npm run dev",

    condition = {
      filetype = node_filetypes,
    },

    builder = function()
      return {
        cmd = { "npm", "run", "dev" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- npm run build
    name = "Node: npm run build",

    condition = {
      filetype = node_filetypes,
    },

    builder = function()
      return {
        cmd = { "npm", "run", "build" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- npm run lint
    name = "Node: npm run lint",

    condition = {
      filetype = node_filetypes,
    },

    builder = function()
      return {
        cmd = { "npm", "run", "lint" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- npm test
    name = "Node: npm test",

    condition = {
      filetype = node_filetypes,
    },

    builder = function()
      return {
        cmd = { "npm", "test" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
