vim9script

# Entry point: expose :Nonogram
import autoload '../autoload/nonogram.vim' as Nonogram

command! Nonogram Nonogram.Start()
