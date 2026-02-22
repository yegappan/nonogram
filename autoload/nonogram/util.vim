vim9script

# Rendering helpers shared by the popup UI.

import autoload './types.vim' as Types

export def MaxClueLen(clues: Types.Clues): number
  var maxLen = 0
  for line in clues
    if len(line) > maxLen
      maxLen = len(line)
    endif
  endfor
  return maxLen
enddef

export def ClueAt(clues: list<number>, maxLines: number, lineIdx: number): string
  var offset = maxLines - len(clues)
  var idx = lineIdx - offset
  if idx < 0
    return ''
  endif
  return string(clues[idx])
enddef

export def PadLeft(text: string, width: number): string
  if len(text) >= width
    return text
  endif
  return repeat(' ', width - len(text)) .. text
enddef

export def FormatClue(text: string, width: number): string
  return PadLeft(text, width)
enddef

export def StateChar(state: Types.CellState): string
  if state == Types.CellState.Filled
    return '#'
  elseif state == Types.CellState.Marked
    return 'x'
  endif
  return '.'
enddef

export def Clamp(value: number, low: number, high: number): number
  if value < low
    return low
  endif
  if value > high
    return high
  endif
  return value
enddef
