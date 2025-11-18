local iron = require("iron.core")

iron.setup({
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = false,
    -- Your repl definitions
    repl_definition = {
      python = {
        command = { "ipython" },
        -- Formatting support for bracketed paste mode
        format = require("iron.fts.common").bracketed_paste_python,
      },
    },
    -- How the repl window will be displayed
    repl_open_cmd = "vertical botright 80 split",
  },
  keymaps = {
    send_motion = "<space>rc",
    visual_send = "<space>rc",
    send_file = "<space>rf",
    send_line = "<space>rl",
    exit = "<space>rq",
  },
})
