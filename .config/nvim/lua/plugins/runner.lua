return {
  "stevearc/overseer.nvim",

  keys = {
    { "<space>o", "<CMD>OverseerRun<CR>" },
    { "<space>O", "<CMD>OverseerToggle<CR>" },
  },

  opts = {
    dap = true,
    templates = { "builtin" }
  },

  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    -- user テンプレートを全部自動登録する関数
    local function register_user_templates()
      -- runtimepath 上から user 配下の lua ファイルを全部探す
      local files = vim.api.nvim_get_runtime_file("lua/overseer/template/user/*.lua", true)

      for _, file in ipairs(files) do
        -- ファイルパスを Lua の require 形式に変換する
        -- 例:
        -- /home/user/.config/nvim/lua/overseer/template/user/python.lua
        -- -> overseer.template.user.python
        local module = file
            :gsub("\\", "/")          -- Windows系対策。普段Linuxでも入れておくと無難
            :match("/lua/(.*)%.lua$") -- lua/ 以降を取り出す
        if module then
          module = module:gsub("/", ".")

          -- require に失敗しても全体が落ちないように pcall を使う
          local ok, templates = pcall(require, module)
          if ok then
            -- 戻り値が「複数テンプレートの配列」か
            -- 「単体テンプレートのテーブル」かを判定する

            -- 単体テンプレート:
            -- { name = "...", builder = function() ... end }
            if templates.name ~= nil then
              overseer.register_template(templates)

              -- 複数テンプレート:
              -- { { name = "..." }, { name = "..." } }
            elseif vim.islist(templates) then
              for _, template in ipairs(templates) do
                overseer.register_template(template)
              end
            end
          else
            vim.notify(
              "Overseer template load failed: " .. module,
              vim.log.levels.WARN
            )
          end
        end
      end
    end

    register_user_templates()
  end,
}
