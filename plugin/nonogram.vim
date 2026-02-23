vim9script
# Nonogram Game Plugin for Vim9
# Logic puzzle - use numeric clues to deduce which cells to fill
# Requires: Vim 9.0+

if exists('g:loaded_nonogram')
  finish
endif
g:loaded_nonogram = 1

import autoload '../autoload/nonogram.vim' as Nonogram

# Default configuration
if !exists('g:nonogram_default_size')
  g:nonogram_default_size = 5
endif

# Command to start the game
command! Nonogram call Nonogram.Start()
