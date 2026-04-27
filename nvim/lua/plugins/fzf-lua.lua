return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      fd_opts = table.concat({
        "--color=never",
        "--type f",
        "--hidden",
        "--follow",
        "--exclude .git",
        "--exclude node_modules",
        "--exclude storybook-static",
      }, " "),
    },
  },
}
