return {
    "OXY2DEV/markview.nvim",
    enabled = true,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },

    opts = {
        preview = {
            hybrid_modes = { "n" },
        },
    },

    -- If we use `opts` then we should not use setup() or we need to pass it to the setup func
    -- config = function ()
    --     require("markview").setup();
    -- end
}
