vim9script

# Game controller: popup lifecycle, input handling, and highlights.

import autoload './types.vim' as Types
import autoload './puzzle.vim' as PuzzleMod
import autoload './board.vim' as BoardMod
import autoload './renderer.vim' as RendererMod
import autoload './util.vim' as Util

var hlReady = v:false

export class Game
  var puzzle: PuzzleMod.Puzzle
  var board: BoardMod.Board
  var cursor: Types.Pos
  var renderer: RendererMod.Renderer
  var winid: number
  var message: string

  def new(puzzle: PuzzleMod.Puzzle, renderer: RendererMod.Renderer)
    this.puzzle = puzzle
    this.board = BoardMod.Board.new(puzzle.size)
    this.cursor = {row: 0, col: 0}
    this.renderer = renderer
    this.winid = 0
    this.message = ''
  enddef

  def Open()
    var lines = this.renderer.Render(this.puzzle, this.board, this.cursor, this.message)
    var opts = {
      border: [1, 1, 1, 1],
      padding: [0, 1, 0, 1],
      mapping: v:false,
      filter: function('nonogram#PopupFilter'),
      title: 'Nonogram (' .. this.puzzle.size .. 'x' .. this.puzzle.size .. ')',
      title_pos: 'center',
    }
    this.winid = popup_create(lines, opts)
    ApplyHighlights(this.winid, this.puzzle, this.board, this.cursor)
  enddef

  def Close()
    if this.winid != 0
      popup_close(this.winid)
      this.winid = 0
    endif
  enddef

  def Redraw()
    if this.winid == 0
      return
    endif
    popup_settext(this.winid, this.renderer.Render(this.puzzle, this.board, this.cursor, this.message))
    ApplyHighlights(this.winid, this.puzzle, this.board, this.cursor)
  enddef

  def Move(dr: number, dc: number)
    this.cursor.row = Util.Clamp(this.cursor.row + dr, 0, this.puzzle.size - 1)
    this.cursor.col = Util.Clamp(this.cursor.col + dc, 0, this.puzzle.size - 1)
    this.Redraw()
  enddef

  def ToggleFill()
    this.board.ToggleFill(this.cursor.row, this.cursor.col)
    this.UpdateMessage()
    this.Redraw()
  enddef

  def ToggleMark()
    this.board.ToggleMark(this.cursor.row, this.cursor.col)
    this.UpdateMessage()
    this.Redraw()
  enddef

  def Reset()
    this.board.Reset()
    this.message = ''
    this.Redraw()
  enddef

  def UpdateMessage()
    if this.IsSolved()
      this.message = 'Solved: ' .. this.puzzle.name .. ' (q quit, r reset)'
    else
      this.message = ''
    endif
  enddef

  def IsSolved(): bool
    for r in range(this.puzzle.size)
      var row = this.puzzle.solution[r]
      for c in range(this.puzzle.size)
        var shouldFill = row[c] == '#'
        var isFill = this.board.cells[r][c] == Types.CellState.Filled
        if shouldFill != isFill
          return false
        endif
      endfor
    endfor
    return true
  enddef
endclass

def EnsureHighlights()
  if hlReady
    return
  endif

  highlight default link NonogramClue Type
  highlight default link NonogramFilled Statement
  highlight default link NonogramMarked Comment
  highlight default link NonogramCursor Search
  if empty(prop_type_get('NonogramClue'))
    prop_type_add('NonogramClue', {highlight: 'NonogramClue', priority: 10})
  endif
  if empty(prop_type_get('NonogramFilled'))
    prop_type_add('NonogramFilled', {highlight: 'NonogramFilled', priority: 20})
  endif
  if empty(prop_type_get('NonogramMarked'))
    prop_type_add('NonogramMarked', {highlight: 'NonogramMarked', priority: 20})
  endif
  if empty(prop_type_get('NonogramCursor'))
    prop_type_add('NonogramCursor', {highlight: 'NonogramCursor', priority: 30})
  endif
  hlReady = v:true
enddef

def PropAdd(winid: number, lnum: number, col: number, len: number, typeName: string)
  if len <= 0
    return
  endif
  var cmd = printf("call prop_add(%d, %d, {length: %d, type: '%s'})", lnum, col, len, typeName)
  win_execute(winid, cmd)
enddef

def ApplyHighlights(winid: number, puzzle: PuzzleMod.Puzzle, board: BoardMod.Board, cursor: Types.Pos)
  if winid == 0
    return
  endif
  EnsureHighlights()
  win_execute(winid, "call prop_clear(1, line('$'))")

  var size = puzzle.size
  var rowClues = puzzle.rowClues
  var colClues = puzzle.colClues
  var maxRow = Util.MaxClueLen(rowClues)
  var maxCol = Util.MaxClueLen(colClues)
  var cellWidth = 3
  var leftWidth = maxRow * cellWidth

  for lineIdx in range(maxCol)
    var lnum = lineIdx + 1
    for col in range(size)
      var clue = Util.ClueAt(colClues[col], maxCol, lineIdx)
      if clue != ''
        var clueLen = len(clue)
        var baseCol = leftWidth + (col * cellWidth) + 1
        var startCol = baseCol + (cellWidth - clueLen)
        PropAdd(winid, lnum, startCol, clueLen, 'NonogramClue')
      endif
    endfor
  endfor

  for row in range(size)
    var lnum = maxCol + row + 1
    var missing = maxRow - len(rowClues[row])
    for i in range(len(rowClues[row]))
      var clueText = string(rowClues[row][i])
      var clueLen = len(clueText)
      var slot = missing + i
      var baseCol = (slot * cellWidth) + 1
      var startCol = baseCol + (cellWidth - clueLen)
      PropAdd(winid, lnum, startCol, clueLen, 'NonogramClue')
    endfor

    for col in range(size)
      var state = board.cells[row][col]
      var stateCol = leftWidth + (col * 3) + 2
      if state == Types.CellState.Filled
        PropAdd(winid, lnum, stateCol, 1, 'NonogramFilled')
      elseif state == Types.CellState.Marked
        PropAdd(winid, lnum, stateCol, 1, 'NonogramMarked')
      endif
    endfor
  endfor

  var cursorLine = maxCol + cursor.row + 1
  var cursorCol = leftWidth + (cursor.col * 3) + 1
  PropAdd(winid, cursorLine, cursorCol, 1, 'NonogramCursor')
enddef
