-- pi terminal integration
-- <leader>ap (normal)  - toggle pi side pane
-- <leader>ap (visual)  - send selection to pi and open pane if needed

local pi_term = nil

local function get_visual_selection()
  local mode = vim.fn.visualmode()
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s[2] - 1, e[2], false)
  if #lines == 0 then
    return ""
  end
  if mode == "v" then
    lines[#lines] = lines[#lines]:sub(1, e[3])
    lines[1] = lines[1]:sub(s[3])
  end
  return table.concat(lines, "\n")
end

local function open_pi()
  pi_term = Snacks.terminal.open("pi", {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    win = {
      position = "right",
      width = 0.35,
    },
  })
  pi_term:on("BufWipeout", function()
    pi_term = nil
  end, { buf = true })
  return pi_term
end

local function toggle_pi()
  if pi_term and pi_term.buf and vim.api.nvim_buf_is_valid(pi_term.buf) then
    pi_term:toggle()
  else
    open_pi()
  end
end

local function send_to_pi(text)
  if not pi_term or not pi_term.buf or not vim.api.nvim_buf_is_valid(pi_term.buf) then
    open_pi()
    -- wait one tick for the terminal process to start before sending
    vim.defer_fn(function()
      local chan = vim.b[pi_term.buf].terminal_job_id
      if chan then
        vim.fn.chansend(chan, text)
      end
    end, 150)
  else
    -- make sure the pane is visible
    if not pi_term:win_valid() then
      pi_term:show()
    end
    local chan = vim.b[pi_term.buf].terminal_job_id
    if chan then
      vim.fn.chansend(chan, text)
    end
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ap",
        toggle_pi,
        desc = "Toggle pi",
      },
      {
        "<leader>ap",
        function()
          local text = get_visual_selection()
          if text ~= "" then
            send_to_pi(text)
          end
        end,
        mode = "v",
        desc = "Send selection to pi",
      },
    },
  },
}
