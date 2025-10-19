{ inputs, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.nvchad;
in
{
  options.modules.nvchad = {
    enable = mkEnableOption "NvChad with Claude Code integration";
  };

  config = mkIf cfg.enable {
    programs.nvchad = {
      enable = true;

      extraPackages = with pkgs; [
        nodePackages.bash-language-server
        docker-compose-language-service
        dockerfile-language-server
        emmet-language-server
        nixd
        neovim
        (python3.withPackages(ps: with ps; [
          python-lsp-server
          flake8
        ]))
      ];

      extraPlugins = ''
        return {
          {
            "greggh/claude-code.nvim",
            lazy = false,
            dependencies = {
              "nvim-lua/plenary.nvim",
            },
            config = function()
              require("claude-code").setup({
                window = {
                  position = "botright",
                  split_ratio = 0.3,
                  enter_insert = true,
                },
                keymaps = {
                  toggle = {
                    normal = "<leader>cc",
                    terminal = "<C-,>",
                    variants = {
                      continue = "<leader>cC",
                      verbose = "<leader>cV",
                    },
                  },
                  window_navigation = true,
                  scrolling = true,
                },
              })
            end,
          },
        }
      '';

      extraConfig = ''
        -- Transparency toggle functionality
        local transparency_enabled = true  -- Start with transparency enabled by default

        -- Function to apply transparency and color customizations
        local function apply_transparency()
          vim.cmd([[
            " Transparency
            highlight Normal guibg=NONE ctermbg=NONE
            highlight NormalFloat guibg=NONE ctermbg=NONE
            highlight NormalNC guibg=NONE ctermbg=NONE
            highlight SignColumn guibg=NONE ctermbg=NONE
            highlight NvimTreeNormal guibg=NONE ctermbg=NONE
            highlight NvimTreeNormalNC guibg=NONE ctermbg=NONE
            highlight NvimTreeVertSplit guibg=NONE ctermbg=NONE
            highlight NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE
            highlight TelescopeNormal guibg=NONE ctermbg=NONE
            highlight TelescopeBorder guibg=NONE ctermbg=NONE
            highlight StatusLine guibg=NONE ctermbg=NONE
            highlight StatusLineNC guibg=NONE ctermbg=NONE
            highlight TabLine guibg=NONE ctermbg=NONE
            highlight TabLineFill guibg=NONE ctermbg=NONE
            highlight VertSplit guibg=NONE ctermbg=NONE
            highlight WinSeparator guibg=NONE ctermbg=NONE

            " Tokyo Night Storm colors for better readability
            " Line numbers - brighter blue-gray for visibility
            highlight LineNr guifg=#787C99 guibg=NONE
            highlight CursorLineNr guifg=#2AC3DE gui=bold guibg=NONE

            " Comments - purple tone for better contrast
            highlight Comment guifg=#9D7CD8 gui=italic

            " Visual selection
            highlight Visual guibg=#343A52

            " Search highlighting
            highlight Search guibg=#444B6A guifg=#0DB9D7
            highlight IncSearch guibg=#F7768E guifg=#24283B

            " NvimTree colors matching Tokyo Night Storm
            highlight NvimTreeNormalText guifg=#A9B1D6 guibg=NONE
            highlight NvimTreeEndOfBuffer guibg=NONE guifg=#444B6A
            highlight NvimTreeFolderName guifg=#2AC3DE guibg=NONE
            highlight NvimTreeOpenedFolderName guifg=#0DB9D7 gui=bold guibg=NONE
            highlight NvimTreeEmptyFolderName guifg=#444B6A guibg=NONE
            highlight NvimTreeFolderIcon guifg=#2AC3DE guibg=NONE
            highlight NvimTreeRootFolder guifg=#BB9AF7 gui=bold guibg=NONE
            highlight NvimTreeIndentMarker guifg=#444B6A guibg=NONE
            highlight NvimTreeGitDirty guifg=#F7768E guibg=NONE
            highlight NvimTreeGitStaged guifg=#9ECE6A guibg=NONE
            highlight NvimTreeGitMerge guifg=#BB9AF7 guibg=NONE
            highlight NvimTreeGitRenamed guifg=#0DB9D7 guibg=NONE
            highlight NvimTreeGitNew guifg=#9ECE6A guibg=NONE
            highlight NvimTreeGitDeleted guifg=#F7768E guibg=NONE
            highlight NvimTreeSpecialFile guifg=#BB9AF7 gui=underline guibg=NONE
            highlight NvimTreeExecFile guifg=#9ECE6A gui=bold guibg=NONE
            highlight NvimTreeImageFile guifg=#BB9AF7 guibg=NONE
            highlight NvimTreeMarkdownFile guifg=#0DB9D7 guibg=NONE
            highlight NvimTreeSymlink guifg=#B4F9F8 guibg=NONE
            highlight NvimTreeWindowPicker guifg=#24283B guibg=#2AC3DE gui=bold
            highlight NvimTreeCursorLine guibg=#343A52
            highlight NvimTreeWinSeparator guifg=#444B6A guibg=NONE
            highlight NvimTreeStatusLine guifg=#787C99 guibg=NONE
            highlight NvimTreeStatusLineNC guifg=#444B6A guibg=NONE
            highlight NvimTreePopup guibg=NONE guifg=#A9B1D6
            highlight NvimTreeSignColumn guibg=NONE
          ]])
        end

        -- Function to toggle transparency
        local function toggle_transparency()
          transparency_enabled = not transparency_enabled

          if transparency_enabled then
            -- Enable transparency
            apply_transparency()
            print("Transparency enabled")
          else
            -- Disable transparency (reload colorscheme to restore)
            vim.cmd([[colorscheme nvchad]])
            print("Transparency disabled")
          end
        end

        -- Apply transparency on startup
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            apply_transparency()
          end,
        })

        -- Reapply transparency after colorscheme changes (if enabled)
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            if transparency_enabled then
              apply_transparency()
            end
          end,
        })

        -- Reapply transparency when NvimTree opens
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "NvimTree",
          callback = function()
            if transparency_enabled then
              vim.defer_fn(function()
                apply_transparency()
              end, 50)
            end
          end,
        })

        -- Reapply transparency after buffer changes
        vim.api.nvim_create_autocmd("BufWinEnter", {
          callback = function()
            if transparency_enabled and vim.bo.filetype == "NvimTree" then
              apply_transparency()
            end
          end,
        })

        -- Create command and keymap for toggling transparency
        vim.api.nvim_create_user_command('ToggleTransparency', toggle_transparency, {})
        vim.keymap.set('n', '<leader>tt', toggle_transparency, { desc = 'Toggle transparency', noremap = true, silent = true })
      '';

      hm-activation = true;
      backup = false;
    };
  };
}
