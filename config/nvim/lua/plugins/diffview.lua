return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      -- Optional: nvim-web-devicons is used for file icons in the diff view
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggle", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      -- Keybinding to toggle the Diffview window
      {
        "<leader>dv",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle Diffview window",
      },
      -- You can add more keybindings here for other Diffview commands
    },
  },
}
