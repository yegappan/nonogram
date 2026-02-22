vim9script

# Glyph font loading from JSON data.

import autoload './puzzleio.vim' as PuzzleIO

var font5: dict<list<string>> = {}
var font7: dict<list<string>> = {}
var script_dir = expand('<script>:p:h')

def FontPath(file: string): string
  return script_dir .. '/' .. file
enddef

def LoadFont(path: string): dict<list<string>>
  var puzzles = PuzzleIO.LoadPuzzlesFromFile(path)
  var font: dict<list<string>> = {}
  for puzzle in puzzles
    font[puzzle.name] = puzzle.solution
  endfor
  return font
enddef

export def LetterFont5(): dict<list<string>>
  if empty(font5)
    font5 = LoadFont(FontPath('glyphs5.json'))
  endif
  return font5
enddef

export def LetterFont7(): dict<list<string>>
  if empty(font7)
    font7 = LoadFont(FontPath('glyphs7.json'))
  endif
  return font7
enddef
