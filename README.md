# Nonogram Game in Vim9script

A Nonogram puzzle game (also known as Picross) played in Vim. Solve picture puzzles by determining which cells to fill based on row and column clues. Written in Vim9script to showcase classes, interfaces, type aliases, and enums.

## Features

- **Multiple Grid Sizes**: Choose from 5x5, 7x7, or 10x10 puzzles
- **Generated Puzzles**: Procedurally generated puzzles from letter glyphs
- **Custom Puzzles**: Load puzzles from JSON files
- **Visual Feedback**: Color highlights for filled and marked cells
- **Popup Window UI**: Non-intrusive gameplay in a centered window
- **Modern Vim9script**: Demonstrates OOP and type safety

## Requirements

- Vim 9.0 or later with `popup` and `textprop` support
- **NOT compatible with Neovim** (requires Vim9-specific features)

## Installation

### Using Git

**Unix/Linux/macOS:**
```bash
git clone https://github.com/yegappan/nonogram.git ~/.vim/pack/downloads/opt/nonogram
```

**Windows (cmd.exe):**
```cmd
git clone https://github.com/yegappan/nonogram.git %USERPROFILE%\vimfiles\pack\downloads\opt\nonogram
```

### Using a ZIP file

**Unix/Linux/macOS:**
```bash
mkdir -p ~/.vim/pack/downloads/opt/
```
Download the ZIP file from GitHub and extract it into the directory above. Rename the extracted folder (usually nonogram-main) to `nonogram` so the final path matches:

```plaintext
~/.vim/pack/downloads/opt/nonogram/
├── plugin/
├── autoload/
└── doc/
```

**Windows (cmd.exe):**
```cmd
if not exist "%USERPROFILE%\vimfiles\pack\downloads\opt" mkdir "%USERPROFILE%\vimfiles\pack\downloads\opt"
```
Download the ZIP file from GitHub and extract it into the directory above. Rename the extracted folder (usually nonogram-main) to `nonogram` so the final path matches:

```plaintext
%USERPROFILE%\vimfiles\pack\downloads\opt\nonogram\
├── plugin/
├── autoload/
└── doc/
```

### Finalizing Setup

Since the plugin is in the `opt` directory, add this to your `.vimrc` (Unix) or `_vimrc` (Windows):
```viml
packadd nonogram
```

Then restart Vim and run:
```viml
:helptags ALL
```

### Plugin Manager Installation

If using vim-plug, add to your config:
```viml
Plug 'path/to/nonogram'
```
Then run `:PlugInstall` and `:helptags ALL`.

For other plugin managers, follow their standard procedure for local plugins.

## Usage

### Starting the Game

```vim
:Nonogram
```

You will be prompted to select a grid size (5x5, 7x7, or 10x10).

### Controls

| Key | Action |
|-----|--------|
| `h` / `←` | Move cursor left |
| `j` / `↓` | Move cursor down |
| `k` / `↑` | Move cursor up |
| `l` / `→` | Move cursor right |
| `Space` | Fill or clear a cell |
| `x` | Mark/unmark a cell as uncertain |
| `r` | Reset current puzzle |
| `q` | Quit game |
| `0` / `Home` | Jump to row start |
| `$` / `End` | Jump to row end |
| `H` / `PageUp` | Jump to column start |
| `L` / `PageDown` | Jump to column end |

### Game Rules

- Numbers tell you how many consecutive filled cells are in each row/column
- For example "2 1" means: 2 filled cells, gap(s), 1 filled cell
- Fill the correct cells based on the clues to reveal the hidden picture
- Mark uncertain cells with `x` to track possibilities
- Complete the puzzle when all cells match the clue requirements

### Configuration

Set in your vimrc:
```vim
let g:nonogram_default_size = 7           " Default grid size (5/7/10)
let g:nonogram_generated_count = 52       " Number of generated puzzles
let g:nonogram_puzzle_file = '/path/file' " Load puzzles from JSON file
```

### Custom Puzzles

Load puzzles from a JSON file. Format:

```json
{
  "name": "MyPuzzle",
  "solution": [
    ".#.#.",
    "#####",
    "#####",
    ".###.",
    "..#.."
  ]
}
```

Use `#` for filled cells and `.` for empty cells. Grids must be 5x5, 7x7, or 10x10.

## Vim9 Language Features Demonstrated

- **Classes**: Puzzle logic, game state management, renderer
- **Interfaces**: Type-safe game component contracts
- **Enums**: Cell states (empty, filled, marked)
- **Type Aliases**: Semantic typing for puzzle data
- **Type Checking**: Full type annotations on all functions
- **Modular Architecture**: Separation of concerns across files
- **JSON Parsing**: Loading custom puzzle configurations

## License

This plugin is licensed under the MIT License. See the LICENSE file in the repository for details.

