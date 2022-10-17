-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd clangd_extensions.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client

    -- Nice Go features
    use 'fatih/vim-go'

    -- Completion engine, uses nvim-lsp and installed LSPs
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- https://git.sr.ht/~p00f/clangd_extensions.nvim
    require("clangd_extensions").setup()
    require("clangd_extensions").setup {
        server = {
            -- options to pass to nvim-lspconfig
            -- i.e. the arguments to require("lspconfig").clangd.setup({})
        },
        extensions = {
            -- defaults:
            -- Automatically set inlay hints (type hints)
            autoSetHints = true,
            -- These apply to the default ClangdSetInlayHints command
            inlay_hints = {
                -- Only show inlay hints for the current line
                only_current_line = false,
                -- Event which triggers a refersh of the inlay hints.
                -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                -- not that this may cause  higher CPU usage.
                -- This option is only respected when only_current_line and
                -- autoSetHints both are true.
                only_current_line_autocmd = "CursorHold",
                -- whether to show parameter hints with the inlay hints or not
                show_parameter_hints = true,
                -- prefix for parameter hints
                parameter_hints_prefix = "<- ",
                -- prefix for all the other hints (type, chaining)
                other_hints_prefix = "=> ",
                -- whether to align to the length of the longest line in the file
                max_len_align = false,
                -- padding from the left if max_len_align is true
                max_len_align_padding = 1,
                -- whether to align to the extreme right or not
                right_align = false,
                -- padding from the right if right_align is true
                right_align_padding = 7,
                -- The color of the hints
                highlight = "Comment",
                -- The highlight group priority for extmark
                priority = 100,
            },
            ast = {
                -- These are unicode, should be available in any font
                role_icons = {
                    type = "🄣",
                    declaration = "🄓",
                    expression = "🄔",
                    statement = ";",
                    specifier = "🄢",
                    ["template argument"] = "🆃",
                },
                kind_icons = {
                    Compound = "🄲",
                    Recovery = "🅁",
                    TranslationUnit = "🅄",
                    PackExpansion = "🄿",
                    TemplateTypeParm = "🅃",
                    TemplateTemplateParm = "🅃",
                    TemplateParamObject = "🅃",
                },
                highlights = {
                    detail = "Comment",
                },
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            },
        },
    }

    -- autocomplete config
    local cmp = require'cmp'
    local luasnip = require'luasnip'
    cmp.setup {
        sources = {
            { name = 'path' },
            { name = 'nvim_lsp', keyword_length = 1 },
            { name = 'buffer', keyword_length = 1 },
            { name = 'luasnip', keyword_length = 1 },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.recently_used,
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
        mapping = {
            ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
            ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        },
    }

    -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    local lspconfig = require'lspconfig'
    -- go language server config
    lspconfig.gopls.setup {
        capabilities = capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        }
    }
end)
