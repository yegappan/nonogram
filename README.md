# Nonogram (Vim9 Popup Game)

A Vim9script nonogram game that runs in a popup window. It is designed to showcase modern Vim9 features: classes, interfaces, type aliases, enums, strict typing, and string interpolation. This plugin targets Vim only (not Neovim).

## Features
- Popup window UI with cursor navigation and color highlights
- Letter puzzles generated from glyphs (A-Z and Greek uppercase)
- Supports 5x5, 7x7, and 10x10 grids
- Random puzzle selection each start
- Optional puzzle loading from a JSON file

## Requirements
- Vim 9.0+ with `popup` and `textprop` support

## Installation

### Using Git
If you have git installed, run the following command in your terminal:

**Unix/Linux/macOS:**

```bash
git clone https://github.com/yegappan/nonogram.git ~/.vim/pack/downloads/opt/nonogram
```
**Windows (cmd.exe):**

```cmd
git clone https://github.com/yegappan/nonogram.git %USERPROFILE%\vimfiles\pack\downloads\opt\nonogram
```

### Using a ZIP file
If you prefer not to use Git:

**Unix/Linux/macOS:**

Create the destination directory:

```bash
mkdir -p ~/.vim/pack/downloads/opt/
```

Download the plugin ZIP file from GitHub and extract its contents into the directory created above.

*Note:* GitHub usually names the extracted folder nonogram-main. Rename it to nonogram so the final path looks like this:

```plaintext
~/.vim/pack/downloads/opt/nonogram/
├── plugin/
├── autoload/
└── doc/
```

**Windows (cmd.exe):**

Create the destination directory:

```cmd
if not exist "%USERPROFILE%\vimfiles\pack\downloads\opt" mkdir "%USERPROFILE%\vimfiles\pack\downloads\opt"
```

Download the plugin ZIP file from GitHub and extract its contents into that directory.

*Note:* Rename the extracted folder (usually nonogram-main) to nonogram so the path matches:

```plaintext
%USERPROFILE%\vimfiles\pack\downloads\opt\nonogram\
├── plugin/
├── autoload/
└── doc/
```

**Finalizing Setup**
Since this plugin is installed in the opt (optional) directory, it will not load automatically. Add the following line to your .vimrc (Unix) or _vimrc (Windows):

```viml
packadd nonogram
```

After adding the line, restart Vim and run the following command to enable the help documentation:

```viml
:helptags ALL
```

### Plugin Manager Installation

If using a plugin manager like vim-plug, add to your .vimrc or init.vim:

   ```viml
   Plug 'path/to/nonogram'
   ```

Then run `:PlugInstall` and `:helptags ALL`

For other plugin managers (Vundle, Pathogen, etc.), follow their standard
installation procedures for local plugins.

## Usage
Start the game:
```
:Nonogram
```

You will be prompted to pick a grid size (5x5, 7x7, 10x10).

## Controls
- Move: `h j k l` or arrow keys
- Fill: `space`
- Mark: `x`
- Reset: `r`
- Quit: `q`

Hidden jump keys (still supported):
- Row start/end: `0` / `$` (or Home/End)
- Column start/end: `H` / `L` (or PageUp/PageDown)

## Configuration
Set in your vimrc if desired:
- `g:nonogram_default_size` (5/7/10)
- `g:nonogram_generated_count` (how many generated puzzles to create)
- `g:nonogram_puzzle_index` (force a specific puzzle index)
- `g:nonogram_puzzle_file` (path to a JSON puzzle file)

Example:
```
let g:nonogram_default_size = 7
let g:nonogram_generated_count = 52
```

## Puzzle File Format
If `g:nonogram_puzzle_file` is set, the game loads puzzles from JSON. You can provide a single object or a list of objects.

Single puzzle:
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

Multiple puzzles:
```json
[
  {
    "name": "A",
    "solution": [
      ".#.#.",
      "#####",
      "#####",
      ".###.",
      "..#.."
    ]
  },
  {
    "name": "B",
    "solution": [
      "#####",
      "#...#",
      "#####",
      "#...#",
      "#####"
    ]
  }
]
```

`solution` is a list of strings, where `#` is a filled cell and `.` is empty.
Solutions must be square grids (5x5, 7x7, or 10x10) and may only use `#` and `.`.

## Glyph Data Files
Letter glyphs are now stored as JSON and loaded at runtime:
- `autoload/nonogram/glyphs5.json`
- `autoload/nonogram/glyphs7.json`

These files use the same puzzle JSON format shown above. Each glyph entry uses a single-character `name` (A-Z or Greek uppercase).

## Notes
- The solved symbol is revealed only after completion.
- The popup title shows the grid size.
- This plugin targets Vim only (not Neovim).

## License
MIT
