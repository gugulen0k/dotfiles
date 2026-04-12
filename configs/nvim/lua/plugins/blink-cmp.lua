require("blink.cmp").setup({
	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<C-y>"] = { "select_and_accept" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
	},

	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
			snippets = {
				opts = {
					extended_filetypes = {
						ruby = { "rails" },
						vue = { "vue" },
					},
				},
			},
			buffer = {
				opts = {
					get_bufnrs = function()
						return vim.iter(vim.api.nvim_list_wins())
							:map(function(win)
								return vim.api.nvim_win_get_buf(win)
							end)
							:filter(function(buf)
								return vim.bo[buf].buftype ~= "nofile"
							end)
							:totable()
					end,
				},
			},
		},
	},

	completion = {
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
		menu = {
			draw = {
				columns = {
					{ "kind_icon", "kind", gap = 1 },
					{ "label", "label_description", gap = 1 },
					{ "source_name" },
				},
				components = {
					source_name = {
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
					},
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
							end
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				border = "rounded",
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,BlinkCmpDocSeparator:FloatBorder",
			},
		},
	},

	signature = {
		enabled = true,
		window = {
			border = "rounded",
		},
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
		sorts = {
			"exact",
			"score",
			"sort_text",
		},
	},
})
