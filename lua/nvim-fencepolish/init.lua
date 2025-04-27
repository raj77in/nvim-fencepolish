local M = {}

local formatters = {
  python = "black -q -",
  json = "jq .",
  sh = "shfmt",
  bash = "shfmt",
  javascript = "prettier --parser babel",
  lua = "stylua -",
}

-- Get language and lines of current fenced code block under cursor
local function get_fenced_block()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == "fenced_code_block" then
      local start_row, _, end_row, _ = node:range()
      local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
      local lang = lines[1]:match("^```(%S+)")
      return lang, lines, start_row, end_row
    end
    node = node:parent()
  end
  return nil, {}, 0, 0
end

-- Format the fenced block with appropriate formatter
function M.format_block_under_cursor()
  local lang, lines, start_row, end_row = get_fenced_block()
  if not lang then
    vim.notify("No fenced block under cursor", vim.log.levels.WARN)
    return
  end

  local formatter = formatters[lang]
  if not formatter then
    vim.notify("No formatter for language: " .. lang, vim.log.levels.WARN)
    return
  end

  table.remove(lines, 1)
  if lines[#lines]:match("^```") then
    table.remove(lines)
  end

  local text = table.concat(lines, "\n")
  local handle = io.popen("echo " .. vim.fn.shellescape(text) .. " | " .. formatter)
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  local formatted = {}
  table.insert(formatted, "```" .. lang)
  for line in result:gmatch("[^\r\n]+") do
    table.insert(formatted, line)
  end
  table.insert(formatted, "```")

  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, formatted)
  vim.notify("Formatted fenced block as " .. lang)
end

-- Setup function to attach keymaps
function M.setup(opts)
  opts = opts or {}

  -- Allow passing custom formatters and keymaps
  formatters = vim.tbl_extend("force", formatters, opts.formatters or {})

  local keymap = opts.keymap or "<leader>cf"

  vim.keymap.set("n", keymap, M.format_block_under_cursor, { desc = "Format fenced block under cursor" })
end


return M
