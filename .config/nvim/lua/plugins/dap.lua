return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "stevearc/overseer.nvim",
  },
  keys = {
    { "<F5>",       function() require("dap").continue() end,          desc = "DAP Continue" },
    { "<F10>",      function() require("dap").step_over() end,         desc = "DAP Step Over" },
    { "<F11>",      function() require("dap").step_into() end,         desc = "DAP Step Into" },
    { "<F12>",      function() require("dap").step_out() end,          desc = "DAP Step Out" },

    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "DAP Conditional Breakpoint",
    },
    { "<leader>du", function() require("dapui").toggle() end,  desc = "DAP UI Toggle" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
    {
      "<leader>dt",
      function()
        require("dap-python").test_method()
      end,
      desc = "DAP Python Test Method",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- debugpy を uv 経由で使う公式想定
    require("dap-python").setup("uv")

    -- Overseer の DAP 連携をここで有効化
    require("overseer").enable_dap()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- プロジェクトっぽい場所かざっくり判定
    local function is_project()
      local markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        ".git",
      }

      local cwd = vim.fn.getcwd()
      for _, marker in ipairs(markers) do
        if vim.fn.filereadable(cwd .. "/" .. marker) == 1
            or vim.fn.isdirectory(cwd .. "/" .. marker) == 1 then
          return true
        end
      end
      return false
    end

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Python: Launch current file",
        program = "${file}",
        cwd = "${fileDirname}",
        console = "integratedTerminal",
        justMyCode = true,
        preLaunchTask = "Python: ruff check",
      },
      {
        type = "python",
        request = "launch",
        name = "Python: Launch project module",
        -- 例: python -m app.main の形
        module = function()
          return vim.fn.input("Python module name: ")
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        justMyCode = true,
        preLaunchTask = "Python: ruff check",
      },
      {
        type = "python",
        request = "launch",
        name = "Python: Launch current file (project-aware)",
        program = "${file}",
        cwd = function()
          if is_project() then
            return vim.fn.getcwd()
          end
          return vim.fn.expand("%:p:h")
        end,
        console = "integratedTerminal",
        justMyCode = true,
        preLaunchTask = "Python: ruff check",
      },
    }
  end,
}
