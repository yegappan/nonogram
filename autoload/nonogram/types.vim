vim9script

# Shared types used across modules.

export enum CellState
  Empty,
  Filled,
  Marked
endenum

export enum InputAction
  None,
  Quit,
  MoveLeft,
  MoveDown,
  MoveUp,
  MoveRight,
  Fill,
  Mark,
  Reset,
  JumpRowStart,
  JumpRowEnd,
  JumpColStart,
  JumpColEnd
endenum

export type Pos = dict<number>
export type Clues = list<list<number>>
export type Grid = list<list<CellState>>
export type GridSize = number
export type KeyInput = string
