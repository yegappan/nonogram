vim9script

# Puzzle model and clue computation.

import autoload './types.vim' as Types

export class Puzzle
  var name: string
  var size: number
  var solution: list<string>
  var rowClues: Types.Clues
  var colClues: Types.Clues

  def new(name: string, solution: list<string>)
    this.name = name
    this.size = len(solution)
    this.solution = solution
    this.rowClues = ComputeRowClues(solution)
    this.colClues = ComputeColClues(solution)
  enddef
endclass

def ComputeRowClues(solution: list<string>): Types.Clues
  var clues: Types.Clues = []
  for row in solution
    clues->add(ComputeLineClues(row))
  endfor
  return clues
enddef

def ComputeColClues(solution: list<string>): Types.Clues
  var size = len(solution)
  var clues: Types.Clues = []
  for c in range(size)
    var line = ''
    for r in range(size)
      line ..= solution[r][c]
    endfor
    clues->add(ComputeLineClues(line))
  endfor
  return clues
enddef

def ComputeLineClues(line: string): list<number>
  var out: list<number> = []
  var run = 0
  for ch in split(line, '\zs')
    if ch == '#'
      run += 1
    else
      if run > 0
        out->add(run)
        run = 0
      endif
    endif
  endfor
  if run > 0
    out->add(run)
  endif
  if out->empty()
    out->add(0)
  endif
  return out
enddef
