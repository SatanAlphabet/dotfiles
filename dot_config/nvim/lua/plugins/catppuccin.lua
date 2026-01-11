return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  priority = 1000,
  enabled = true,
  opts = {
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true, -- Enables main editor transparency
    show_end_of_buffer = false,
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    ---@param colors table: The palette colors for the current flavour
    custom_highlights = function(colors)
      return {
        -- 1. General UI Transparency
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        Pmenu = { bg = "none" },      -- Completion menu
        PmenuSbar = { bg = "none" },
        PmenuThumb = { bg = "none" },
        
        -- 2. Sidebar & Explorer Transparency (Neo-tree)
        NormalSB = { bg = "none" },      -- Sidebar background
        SignColumnSB = { bg = "none" },  -- Sidebar sign column
        NeoTreeNormal = { bg = "none" },
        NeoTreeNormalNC = { bg = "none" },
        NeoTreeWinSeparator = { fg = colors.surface1, bg = "none" },
        
        -- 3. Window Dividers
        WinSeparator = { fg = colors.surface1, bg = "none" },
        
        -- 4. Line Numbers
        LineNr = { bg = "none" },
        CursorLineNr = { bg = "none" },
      }
    end,
    default_integrations = true,
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "NONE" }, -- Set to "NONE" for transparency
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      telescope = {
        enabled = true,
        -- Optional: set style to "nvchad" or "bordered" if you like outlines
      },
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
}