return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    keys = function()
      local gs = require "gitsigns"
      return {
        { "]g", gs.next_hunk, "Git next hunk" },
        { "[g", gs.prev_hunk, "Git previous hunk" },
        { "<Leader>gs", gs.stage_hunk, desc = "Git stage hunk" },
        { "<Leader>gS", gs.stage_buffer, desc = "Git stage buffer" },
        { "<Leader>gu", gs.undo_stage_hunk, desc = "Git undo stage hunk" },
        { "<Leader>gr", gs.reset_hunk, desc = "Git reset hunk" },
        { "<Leader>gR", gs.reset_buffer, desc = "Git reset buffer" },
        { "<Leader>gp", gs.preview_hunk, desc = "Git preview hunk" },
        { "<Leader>gb", function() gs.blame_line { full = true } end, desc = "Git blame line" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    keys = function()
      local todo_comments = require "todo-comments"
      return {
        { "]T", todo_comments.jump_next, desc = "Next TODO comment" },
        { "[T", todo_comments.jump_prev, desc = "Previous TODO comment" },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    keys = function()
      local illuminate = require "illuminate"
      return {
        { "]]", desc = "Next reference" },
        { "[[", desc = "Previous reference" },
        { "<Leader>tr", illuminate.toggle_buf, desc = "Toggle reference highlighting" },
      }
    end,
    config = function(plugin, opts)
      require "astronvim.plugins.configs.vim-illuminate"(plugin, opts)
      local function map(key, dir, buffer)
        vim.keymap.set(
          "n",
          key,
          function() require("illuminate")["goto_" .. dir .. "_reference"](false) end,
          { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer }
        )
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },
  {
    "rmagatti/goto-preview",
    keys = function()
      local gtp = require "goto-preview"
      return {
        { "gpd", gtp.goto_preview_definition, desc = "LSP definition of current symbol", noremap = true },
        { "gpt", gtp.goto_preview_type_definition, desc = "LSP references of current symbol", noremap = true },
        { "gpi", gtp.goto_preview_implementation, desc = "LSP type definition of current symbol", noremap = true },
        { "gpD", gtp.goto_preview_declaration, desc = "LSP implementations of current symbol", noremap = true },
        { "gP", gtp.close_all_win, desc = "LSP implementations of current symbol", noremap = true },
        { "gpr", gtp.goto_preview_references, desc = "LSP implementations of current symbol", noremap = true },
      }
    end,
    opts = {},
  },
  { -- TODO: this conflicting use case with NeoComposer, only useful because it can use defined macro
    "kr40/nvim-macros",
    cmd = { "MacroSave", "MacroYank", "MacroSelect", "MacroDelete" },
    keys = {
      { "<Leader>sm", "MacroSelect", desc = "Select macro" },
    },
    opts = {
      json_file_path = vim.fs.normalize(vim.fn.stdpath "config" .. "/macros.json"),
      default_macro_register = "q",
      json_formatter = "jaq",
    },
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
  },
  {
    "vidocqh/auto-indent.nvim",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua", enabled = not jit.os:find "Windows" },
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>sy"] = { "<Cmd>Telescope yank_history<CR>", desc = "Find yanks" },
              ["y"] = { "<Plug>(YankyYank)", desc = "Yank text" },
              ["p"] = { "<Plug>(YankyPutAfter)", desc = "Put yanked text after cursor" },
              ["P"] = { "<Plug>(YankyPutBefore)", desc = "Put yanked text before cursor" },
              ["gp"] = { "<Plug>(YankyGPutAfter)", desc = "Put yanked text after selection" },
              ["gP"] = { "<Plug>(YankyGPutBefore)", desc = "Put yanked text before selection" },
              ["[y"] = { "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
              ["]y"] = { "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
              ["]p"] = { "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
              ["[p"] = { "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
              ["]P"] = { "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
              ["[P"] = { "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
              [">p"] = { "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
              ["<p"] = { "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
              [">P"] = { "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
              ["<P"] = { "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
              ["=p"] = { "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
              ["=P"] = { "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
            },
            x = {
              ["y"] = { "<Plug>(YankyYank)", desc = "Yank text" },
              ["p"] = { "<Plug>(YankyPutAfter)", desc = "Put yanked text after cursor" },
              ["P"] = { "<Plug>(YankyPutBefore)", desc = "Put yanked text before cursor" },
              ["gp"] = { "<Plug>(YankyGPutAfter)", desc = "Put yanked text after selection" },
              ["gP"] = { "<Plug>(YankyGPutBefore)", desc = "Put yanked text before selection" },
            },
          },
        },
      },
    },
    opts = function()
      local mapping = require "yanky.telescope.mapping"
      local mappings = mapping.get_defaults()
      mappings.i["<c-p>"] = nil
      return {
        highlight = { timer = 200 },
        ring = { storage = jit.os:find "Windows" and "shada" or "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            mappings = mappings,
          },
        },
      }
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has "nvim-0.10.0" == 1,
  },
  { "lukas-reineke/virt-column.nvim", opts = {} },
  {
    "David-Kunz/gen.nvim",
    --[[ opts = {
      model = "deepseek-coder-v2", -- The default model to use.
      no_auto_close = false, -- Never closes the window automatically.
      display_mode = "split",
      init = function() pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
    }, ]]
    config = function()
      local use_local = false

      local get_api_key = function(path)
        local expanded_path = vim.fn.expand(path)
        local file = io.open(expanded_path, "r")
        if file then
          local content = file:read("*all"):gsub("\n", "")
          file:close()
          return content
        else
          error "Could not open file!"
        end
      end

      local base_configs = {
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = false, -- Shows the prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        debug = false, -- Prints errors and the command which is run.
      }

      local groq_configs = {
        model = "llama3-70b-8192",
        -- model = "mixtral-8x7b-32768",
        body = { max_tokens = nil, temperature = 1, top_p = 1, stop = nil },
        command = function()
          local api_url = "https://api.groq.com"
          local api_endpoint = api_url .. "/openai/v1/chat/completions"
          local api_key_path = "~/.groq/creds"
          local api_key = get_api_key(api_key_path)
          local curl_cmd = "curl --silent --no-buffer -X POST"
          local header_options = "-H 'Authorization: Bearer " .. api_key .. "'"
          return curl_cmd .. " " .. header_options .. " " .. api_endpoint .. " -d $body"
        end,
        init = nil,
      }

      local ollama_configs = {
        model = "llama3",
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        command = function(options)
          return "curl --silent --no-buffer -X POST http://"
            .. options.host
            .. ":"
            .. options.port
            .. "/api/chat -d $body"
        end,
        -- Function to initialize Ollama
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        init = function() pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      }

      if use_local then
        require("gen").setup(vim.tbl_deep_extend("force", ollama_configs, base_configs))
      else
        require("gen").setup(vim.tbl_deep_extend("force", groq_configs, base_configs))
      end
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<C-l>",
          --clear_suggestion = "<C-]>",
          accept_word = "<C-k>",
        },
        disable_inline_completion = false,
      }
    end,
  },
  --[[ { -- not working
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {},
  }, ]]
  --[[ {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("codeium").setup {
        enable_chat = true,
      }
    end,
  }, ]]
}
