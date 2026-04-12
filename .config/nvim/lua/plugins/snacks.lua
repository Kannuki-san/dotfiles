return {
  -- セッション管理
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
    },
  },

  -- Snacks 本体
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = function()
      -- 起動時にパスやファイルが指定されているなら dashboard を出さない
      -- 例:
      --   nvim
      --   nvim .
      --   nvim somefile.lua
      local dashboard_enabled = vim.fn.argc(-1) == 0

      return {
        dashboard = {
          enabled = dashboard_enabled,

          preset = {
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find Files",
                action = function()
                  Snacks.picker.files({
                    hidden = true,
                  })
                end,
              },
              {
                icon = " ",
                key = "o",
                desc = "Open Path",
                action = function()
                  vim.ui.input({
                    prompt = "Directory or file path: ",
                    completion = "file",
                  }, function(input)
                    if not input or input == "" then
                      return
                    end

                    local path = vim.fn.expand(input)

                    if vim.fn.isdirectory(path) == 1 then
                      Snacks.picker.files({
                        cwd = path,
                        hidden = true,
                      })
                      return
                    end

                    if vim.fn.filereadable(path) == 1 then
                      vim.cmd("edit " .. vim.fn.fnameescape(path))
                      return
                    end

                    local dir = vim.fn.fnamemodify(path, ":h")
                    if vim.fn.isdirectory(dir) == 1 then
                      Snacks.picker.files({
                        cwd = dir,
                        hidden = true,
                      })
                      return
                    end

                    vim.notify("Path not found: " .. path, vim.log.levels.WARN)
                  end)
                end,
              },
              {
                icon = " ",
                key = "g",
                desc = "Find Text",
                action = function()
                  Snacks.picker.grep()
                end,
              },
              {
                icon = " ",
                key = "r",
                desc = "Recent Files",
                action = function()
                  Snacks.picker.recent()
                end,
              },
              {
                icon = " ",
                key = "p",
                desc = "Projects",
                action = function()
                  Snacks.picker.projects()
                end,
              },
              {
                icon = " ",
                key = "s",
                desc = "Restore Session",
                action = function()
                  require("persistence").load()
                end,
              },
              {
                icon = " ",
                key = "n",
                desc = "New File",
                action = ":ene | startinsert",
              },
              {
                icon = "󰒲 ",
                key = "l",
                desc = "Lazy",
                action = ":Lazy",
              },
              {
                icon = " ",
                key = "q",
                desc = "Quit",
                action = ":qa",
              },
            },
          },

          sections = {
            {
              section = "header",
            },
            {
              section = "keys",
              gap = 1,
              padding = 1,
            },
            {
              section = "recent_files",
              limit = 8,
              padding = 1,
            },
            {
              section = "projects",
              limit = 6,
              padding = 1,
            },
            {
              section = "startup",
            },
          },
        },

        picker = {
          enabled = true,
          sources = {
            explorer = {
              layout = {
                preset = "sidebar",
                auto_hide = { "input" },
              },
              hidden = true,

              -- explorer を基本閉じない
              focus = "list",
              auto_close = false,
              jump = { close = false },
            },
          },
        },

        notifier = {
          enabled = true,
        },

        indent = {
          enabled = true,
        },

        lazygit = {
          enabled = true,
        },

        quickfile = {
          enabled = true,
        },

        explorer = {
          replace_netrw = true,
        },
      }
    end,

    keys = {
      -- Explorer
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
        nowait = true,
      },

      {
        "<leader>E",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            Snacks.explorer()
            return
          end

          local dir = vim.fn.fnamemodify(file, ":h")
          if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
            vim.cmd("tcd " .. vim.fn.fnameescape(dir))
          end

          Snacks.explorer({
            cwd = dir,
          })
        end,
        desc = "Explorer (current file dir)",
      },

      -- Finder系
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({
            hidden = true,
          })
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
    },

    config = function(_, opts)
      require("snacks").setup(opts)

      -- 透過系ハイライトをまとめて適用する関数
      -- colorscheme や snacks 側の再設定で上書きされやすいので、
      -- 必要なタイミングで何度でも呼べるようにしておく
      local function set_transparent_highlights()
        local groups = {
          -- 通常ウィンドウ系
          "Normal",
          "NormalNC",
          "SignColumn",
          "EndOfBuffer",
          "WinSeparator",

          -- Float系
          "NormalFloat",
          "FloatBorder",
          "FloatTitle",

          -- Snacks系
          "SnacksNormal",
          "SnacksExplorer",
          "SnacksPicker",
          "SnacksPickerBox",
          "SnacksPickerInput",
          "SnacksPickerList",
          "SnacksPickerPreview",
          "SnacksNotifier",
        }

        for _, group in ipairs(groups) do
          pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE" })
        end
      end

      -- 起動時に一度適用
      set_transparent_highlights()

      -- colorscheme を変えた時に再適用
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          set_transparent_highlights()
        end,
      })

      -- explorer を今のセッションで開いたかどうか
      local explorer_opened = false
      local explorer_root = nil

      local function should_open_explorer()
        local bt = vim.bo.buftype
        local ft = vim.bo.filetype
        local name = vim.api.nvim_buf_get_name(0)

        -- dashboard 中は開かない
        if ft == "snacks_dashboard" then
          return false
        end

        -- 特殊バッファでは開かない
        if bt ~= "" then
          return false
        end

        -- 無名バッファでは開かない
        if name == "" then
          return false
        end

        -- 実在する通常ファイルだけ対象
        if vim.fn.filereadable(name) ~= 1 then
          return false
        end

        return true
      end

      local function open_explorer_once_for_current_file()
        -- 最初の1回だけ開く
        if explorer_opened then
          return
        end

        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          return
        end

        local dir = vim.fn.fnamemodify(file, ":h")
        if dir == "" or vim.fn.isdirectory(dir) ~= 1 then
          return
        end

        explorer_root = dir

        -- Neovim 自体のルートディレクトリもこの場所に合わせる
        -- タブ単位で cwd を変更
        vim.cmd("tcd " .. vim.fn.fnameescape(explorer_root))

        -- explorer を開く直前にも再適用して、
        -- 黒背景になる確率を下げる
        set_transparent_highlights()

        Snacks.explorer({
          cwd = explorer_root,
        })

        explorer_opened = true
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
          vim.schedule(function()
            if should_open_explorer() then
              open_explorer_once_for_current_file()
            end
          end)
        end,
      })
    end,
  },
}
