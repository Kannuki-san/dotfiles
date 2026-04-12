-- Java / Gradle / Maven 用のOverseerテンプレート集

-- 現在の作業ディレクトリをプロジェクトルートとして扱う
local function project_root()
  return vim.fn.getcwd()
end

-- Java系で使いそうな filetype
local java_filetypes = {
  "java",
  "kotlin",
  "groovy",
}

return {
  {
    -- gradle build
    name = "Java: gradle build",

    condition = {
      filetype = java_filetypes,
    },

    builder = function()
      local cwd = project_root()
      local gradlew = cwd .. "/gradlew"
      local cmd

      -- gradlew がプロジェクトにあるならそれを優先
      if vim.fn.filereadable(gradlew) == 1 then
        cmd = { "./gradlew", "build" }
      else
        cmd = { "gradle", "build" }
      end

      return {
        cmd = cmd,
        cwd = cwd,
        components = { "default" },
      }
    end,
  },

  {
    -- gradle test
    name = "Java: gradle test",

    condition = {
      filetype = java_filetypes,
    },

    builder = function()
      local cwd = project_root()
      local gradlew = cwd .. "/gradlew"
      local cmd

      -- gradlew がプロジェクトにあるならそれを優先
      if vim.fn.filereadable(gradlew) == 1 then
        cmd = { "./gradlew", "test" }
      else
        cmd = { "gradle", "test" }
      end

      return {
        cmd = cmd,
        cwd = cwd,
        components = { "default" },
      }
    end,
  },

  {
    -- mvn package
    name = "Java: mvn package",

    condition = {
      filetype = java_filetypes,
    },

    builder = function()
      return {
        cmd = { "mvn", "package" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },

  {
    -- mvn test
    name = "Java: mvn test",

    condition = {
      filetype = java_filetypes,
    },

    builder = function()
      return {
        cmd = { "mvn", "test" },
        cwd = project_root(),
        components = { "default" },
      }
    end,
  },
}
