vim9script

# Puzzle generation and loading.

import autoload './types.vim' as Types
import autoload './puzzle.vim' as PuzzleMod
import autoload './glyphs.vim' as Glyphs
import autoload './puzzleio.vim' as PuzzleIO

export interface PuzzleSource
  def GetPuzzles(size: Types.GridSize): list<PuzzleMod.Puzzle>
endinterface

export class FilePuzzleSource implements PuzzleSource
  var path: string

  def new(path: string)
    this.path = path
  enddef

  def GetPuzzles(size: Types.GridSize): list<PuzzleMod.Puzzle>
    return PuzzleIO.LoadPuzzlesFromFile(this.path)
  enddef
endclass

export class GeneratedPuzzleSource implements PuzzleSource
  var count: number

  def new(count: number)
    this.count = count
  enddef

  def GetPuzzles(size: Types.GridSize): list<PuzzleMod.Puzzle>
    return GeneratedPuzzlesWithCount(size, this.count)
  enddef
endclass

def GeneratedPuzzlesWithCount(size: Types.GridSize, count: number): list<PuzzleMod.Puzzle>
  var puzzles: list<PuzzleMod.Puzzle> = []
  var nameLen = NameLengthForSize(size)
  var names = MakeLetterNames(count, nameLen)
  for name in names
    var solution = BuildLetterPuzzle(name, size)
    puzzles->add(PuzzleMod.Puzzle.new(name, solution))
  endfor
  return puzzles
enddef

def NameLengthForSize(size: Types.GridSize): number
  if size == 5
    return 1
  elseif size == 7
    return 2
  elseif size == 10
    return 3
  endif
  throw 'Letter puzzles only support size 5, 7, or 10'
enddef

def MakeLetterNames(count: number, nameLen: number): list<string>
  var names: list<string> = []
  var letters = Alphabet()
  var maxCount = 1
  for _ in range(nameLen)
    maxCount *= len(letters)
  endfor
  var targetCount = count
  if targetCount > maxCount
    targetCount = maxCount
  endif

  if nameLen == 1
    for a in letters
      names->add(a)
      if len(names) >= targetCount
        return names
      endif
    endfor
    return names
  elseif nameLen == 2
    for a in letters
      for b in letters
        names->add(a .. b)
        if len(names) >= targetCount
          return names
        endif
      endfor
    endfor
    return names
  endif

  for a in letters
    for b in letters
      for c in letters
        names->add(a .. b .. c)
        if len(names) >= targetCount
          return names
        endif
      endfor
    endfor
  endfor

  return names
enddef

def Alphabet(): list<string>
  var letters = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '\zs')
  letters->extend(GreekUppercaseLetters())
  return letters
enddef

def GreekUppercaseLetters(): list<string>
  return [
    nr2char(0x0391),
    nr2char(0x0392),
    nr2char(0x0393),
    nr2char(0x0394),
    nr2char(0x0395),
    nr2char(0x0396),
    nr2char(0x0397),
    nr2char(0x0398),
    nr2char(0x0399),
    nr2char(0x039A),
    nr2char(0x039B),
    nr2char(0x039C),
    nr2char(0x039D),
    nr2char(0x039E),
    nr2char(0x039F),
    nr2char(0x03A0),
    nr2char(0x03A1),
    nr2char(0x03A3),
    nr2char(0x03A4),
    nr2char(0x03A5),
    nr2char(0x03A6),
    nr2char(0x03A7),
    nr2char(0x03A8),
    nr2char(0x03A9),
  ]
enddef

def BuildLetterPuzzle(name: string, size: Types.GridSize): list<string>
  var font: dict<list<string>>
  var scale = 1
  if size == 5
    font = Glyphs.LetterFont5()
  elseif size == 7
    font = Glyphs.LetterFont7()
  elseif size == 10
    font = Glyphs.LetterFont5()
    scale = 2
  else
    throw 'Letter puzzles only support size 5, 7, or 10'
  endif

  var grid: list<list<number>> = []
  for _ in range(size)
    var row: list<number> = []
    for __ in range(size)
      row->add(0)
    endfor
    grid->add(row)
  endfor

  # Overlay multiple letters with small offsets to keep the grid square.
  var letters = split(name, '\zs')
  var index = 0
  for letter in letters
    if !has_key(font, letter)
      index += 1
      continue
    endif
    var glyph = font[letter]
    var offsetX = (index * 2) % size
    var offsetY = (index * 1) % size
    for r in range(len(glyph))
      var line = glyph[r]
      for c in range(len(line))
        if line[c] == '#'
          for sr in range(scale)
            for sc in range(scale)
              var rr = (r * scale + sr + offsetY) % size
              var cc = (c * scale + sc + offsetX) % size
              grid[rr][cc] = 1
            endfor
          endfor
        endif
      endfor
    endfor
    index += 1
  endfor

  var solution: list<string> = []
  for r in range(size)
    var line = ''
    for c in range(size)
      line ..= grid[r][c] == 1 ? '#' : '.'
    endfor
    solution->add(line)
  endfor

  return solution
enddef

