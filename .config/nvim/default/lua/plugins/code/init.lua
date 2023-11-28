return {
  {
    "nat-418/boole.nvim",
    event = "BufRead",
    config = function ()
      require('boole').setup({
        mappings = {
          increment = '<c-a>', -- TODO: map to a proper key, because CTRL-A is mapped to TMUX
          decrement = '<c-x>'
        },
        -- User defined loops
        additions = {
          {'Foo', 'Bar'},
          {'tic', 'tac', 'toe'}
        },
        allow_caps_additions = {
          {'enable', 'disable'}
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        }
      })
    end
  }
}
