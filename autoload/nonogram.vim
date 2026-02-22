vim9script

# Public entrypoint and popup key handling.

import autoload './nonogram/game.vim' as GameMod
import autoload './nonogram/renderer.vim' as RendererMod
import autoload './nonogram/puzzles.vim' as Puzzles
import autoload './nonogram/puzzle.vim' as PuzzleMod
import autoload './nonogram/types.vim' as Types

var rngReady = v:false

var game: GameMod.Game

export def Start()
  var size = SelectGridSize()
  var puzzle = PickPuzzle(size)
  var renderer = RendererMod.PopupRenderer.new()
  game = GameMod.Game.new(puzzle, renderer)
  game.Open()
enddef

def EnsureRng()
  if rngReady
    return
  endif
  srand(float2nr(reltimefloat(reltime()) * 1000000.0))
  rngReady = v:true
enddef

def SelectGridSize(): Types.GridSize
  var defaultSize = 7
  if exists('g:nonogram_default_size')
    defaultSize = g:nonogram_default_size
  endif

  var prompt = [
    'Select grid size:',
    '1. 5x5',
    '2. 7x7',
    '3. 10x10',
  ]
  var choice = inputlist(prompt)
  if choice == 1
    return 5
  elseif choice == 2
    return 7
  elseif choice == 3
    return 10
  endif

  if defaultSize == 5 || defaultSize == 7 || defaultSize == 10
    return defaultSize
  endif
  return 7
enddef

export def PopupFilter(winid: number, key: string): bool
  if game.winid == 0
    return v:true
  endif

  var action = ActionFromKey(key)
  if action == Types.InputAction.Quit
    game.Close()
    return v:true
  elseif action == Types.InputAction.MoveLeft
    game.Move(0, -1)
  elseif action == Types.InputAction.MoveDown
    game.Move(1, 0)
  elseif action == Types.InputAction.MoveUp
    game.Move(-1, 0)
  elseif action == Types.InputAction.MoveRight
    game.Move(0, 1)
  elseif action == Types.InputAction.Fill
    game.ToggleFill()
  elseif action == Types.InputAction.Mark
    game.ToggleMark()
  elseif action == Types.InputAction.Reset
    game.Reset()
  elseif action == Types.InputAction.JumpRowStart
    game.Move(0, -game.cursor.col)
  elseif action == Types.InputAction.JumpRowEnd
    game.Move(0, game.puzzle.size - 1 - game.cursor.col)
  elseif action == Types.InputAction.JumpColStart
    game.Move(-game.cursor.row, 0)
  elseif action == Types.InputAction.JumpColEnd
    game.Move(game.puzzle.size - 1 - game.cursor.row, 0)
  else
    return v:false
  endif

  return v:true
enddef

def ActionFromKey(key: Types.KeyInput): Types.InputAction
  if key == 'q'
    return Types.InputAction.Quit
  elseif key == 'h' || key == "\<Left>"
    return Types.InputAction.MoveLeft
  elseif key == 'j' || key == "\<Down>"
    return Types.InputAction.MoveDown
  elseif key == 'k' || key == "\<Up>"
    return Types.InputAction.MoveUp
  elseif key == 'l' || key == "\<Right>"
    return Types.InputAction.MoveRight
  elseif key == ' '
    return Types.InputAction.Fill
  elseif key == 'x'
    return Types.InputAction.Mark
  elseif key == 'r'
    return Types.InputAction.Reset
  elseif key == '0' || key == "\<Home>"
    return Types.InputAction.JumpRowStart
  elseif key == '$' || key == "\<End>"
    return Types.InputAction.JumpRowEnd
  elseif key == 'H' || key == "\<PageUp>"
    return Types.InputAction.JumpColStart
  elseif key == 'L' || key == "\<PageDown>"
    return Types.InputAction.JumpColEnd
  endif
  return Types.InputAction.None
enddef

def PickPuzzle(size: Types.GridSize): PuzzleMod.Puzzle
  if exists('g:nonogram_puzzle_file') && filereadable(g:nonogram_puzzle_file)
    var fileSource = Puzzles.FilePuzzleSource.new(g:nonogram_puzzle_file)
    var filePuzzles = fileSource.GetPuzzles(size)
    if filePuzzles->empty()
      throw 'Puzzle file did not contain any puzzles'
    endif
    EnsureRng()
    var fileIndex = rand() % len(filePuzzles)
    if exists('g:nonogram_puzzle_index')
      fileIndex = g:nonogram_puzzle_index
    endif
    if fileIndex < 0 || fileIndex >= len(filePuzzles)
      fileIndex = rand() % len(filePuzzles)
    endif
    return filePuzzles[fileIndex]
  endif

  var count = 52
  if exists('g:nonogram_generated_count')
    count = g:nonogram_generated_count
  endif
  var source: Puzzles.PuzzleSource = Puzzles.GeneratedPuzzleSource.new(count)
  var puzzles = source.GetPuzzles(size)
  EnsureRng()
  var index = rand() % len(puzzles)
  if exists('g:nonogram_puzzle_index')
    index = g:nonogram_puzzle_index
  endif
  if index < 0 || index >= len(puzzles)
    index = rand() % len(puzzles)
  endif
  return puzzles[index]
enddef
