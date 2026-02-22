vim9script

# Board state and cell toggling logic.

import autoload './types.vim' as Types

export class Board
  var size: number
  var cells: Types.Grid

  def new(size: number)
    this.size = size
    this.cells = NewGrid(size)
  enddef

  def Reset()
    this.cells = NewGrid(this.size)
  enddef

  def ToggleFill(row: number, col: number)
    var cur = this.cells[row][col]
    if cur == Types.CellState.Filled
      this.cells[row][col] = Types.CellState.Empty
    else
      this.cells[row][col] = Types.CellState.Filled
    endif
  enddef

  def ToggleMark(row: number, col: number)
    var cur = this.cells[row][col]
    if cur == Types.CellState.Marked
      this.cells[row][col] = Types.CellState.Empty
    else
      if cur == Types.CellState.Filled
        this.cells[row][col] = Types.CellState.Empty
      else
        this.cells[row][col] = Types.CellState.Marked
      endif
    endif
  enddef
endclass

def NewGrid(size: number): Types.Grid
  var grid: Types.Grid = []
  for _ in range(size)
    var row: list<Types.CellState> = []
    for __ in range(size)
      row->add(Types.CellState.Empty)
    endfor
    grid->add(row)
  endfor
  return grid
enddef
