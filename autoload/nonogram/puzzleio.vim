vim9script

# Puzzle JSON file loading helpers.

import autoload './puzzle.vim' as PuzzleMod

export def LoadPuzzlesFromFile(path: string): list<PuzzleMod.Puzzle>
  var raw = readfile(path)->join("\n")
  var data = json_decode(raw)
  if type(data) == v:t_dict
    return [LoadPuzzleFromDict(data, path)]
  elseif type(data) == v:t_list
    var puzzles: list<PuzzleMod.Puzzle> = []
    for item in data
      if type(item) != v:t_dict
        throw 'Puzzle list must contain objects'
      endif
      puzzles->add(LoadPuzzleFromDict(item, path))
    endfor
    return puzzles
  endif
  throw 'Invalid puzzle file format'
enddef

def LoadPuzzleFromDict(data: dict<any>, source: string): PuzzleMod.Puzzle
  if !has_key(data, 'name') || !has_key(data, 'solution')
    throw 'Puzzle file missing name or solution'
  endif
  var name = '' .. data.name
  if type(data.solution) != v:t_list
    throw 'Puzzle solution must be a list of strings'
  endif
  var solution: list<string> = []
  for item in data.solution
    solution->add('' .. item)
  endfor
  try
    ValidateSolutionSize(solution)
  catch
    throw 'Puzzle "' .. name .. '" in ' .. source .. ': ' .. v:exception
  endtry
  return PuzzleMod.Puzzle.new(name, solution)
enddef

def ValidateSolutionSize(solution: list<string>)
  var size = len(solution)
  if !(size == 5 || size == 7 || size == 10)
    throw 'Puzzle size must be 5x5, 7x7, or 10x10'
  endif
  for idx in range(size)
    var row = solution[idx]
    var rowLen = len(row)
    if rowLen != size
      throw 'Puzzle solution must be a square grid (size ' .. size .. ', row ' .. (idx + 1) .. ' length ' .. rowLen .. ')'
    endif
    if row =~ '[^#.]'
      throw 'Puzzle solution may only use # and .'
    endif
  endfor
enddef
