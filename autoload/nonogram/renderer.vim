vim9script

# Popup renderer for puzzles and legend text.

import autoload './types.vim' as Types
import autoload './puzzle.vim' as PuzzleMod
import autoload './board.vim' as BoardMod
import autoload './util.vim' as Util

export interface Renderer
  def Render(puzzle: PuzzleMod.Puzzle, board: BoardMod.Board, cursor: Types.Pos, message: string): list<string>
endinterface

export class PopupRenderer implements Renderer
  var cellWidth: number

  def new()
    this.cellWidth = 3
  enddef

  def Render(puzzle: PuzzleMod.Puzzle, board: BoardMod.Board, cursor: Types.Pos, message: string): list<string>
    var size = puzzle.size
    var rowClues = puzzle.rowClues
    var colClues = puzzle.colClues
    var maxRow = Util.MaxClueLen(rowClues)
    var maxCol = Util.MaxClueLen(colClues)
    var leftWidth = maxRow * this.cellWidth
    var lines: list<string> = []

    for lineIdx in range(maxCol)
      var text = repeat(' ', leftWidth)
      for col in range(size)
        var clue = Util.ClueAt(colClues[col], maxCol, lineIdx)
        text ..= Util.FormatClue(clue, this.cellWidth)
      endfor
      lines->add(text)
    endfor

    for row in range(size)
      var text = ''
      var missing = maxRow - len(rowClues[row])
      for i in range(maxRow)
        var clueText = ''
        if i >= missing
          clueText = string(rowClues[row][i - missing])
        endif
        text ..= Util.PadLeft(clueText, this.cellWidth)
      endfor

      for col in range(size)
        var isCursor = cursor.row == row && cursor.col == col
        var stateChar = Util.StateChar(board.cells[row][col])
        var prefix = isCursor ? '>' : ' '
        text ..= prefix .. stateChar .. ' '
      endfor
      lines->add(text)
    endfor

    lines->add('')
    if message != ''
      lines->add(message)
    endif
    lines->add('Keys:')
    lines->add('  h j k l or arrows move')
    lines->add('  space fill | x mark | q quit')
    return lines
  enddef
endclass
