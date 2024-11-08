{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;

    ignores = [
      ".build/"
    ];

    settings = {
      theme = "nightfox_dayfox";
      editor = {
        line-number = "relative";
        mouse = false;
        true-color = true;
      };
      #keys.normal = {
        #space.space = "file_picker";
        #space.w = ":w";
        #space.q = ":q";
        #esc = [ "collapse_selection" "keep_primary_selection" ];
      #};
    };

    themes = {
      nightfox_dayfox = let
        black          = "#352c24";
        red            = "#a5222f";
        red-dim        = "#8c1d28";
        green          = "#396847";
        green-dim      = "#30583c";
        yellow         = "#ac5402";
        yellow-bright  = "#b86e28";
        blue           = "#2848a9";
        blue-bright    = "#4863b6";
        blue-dim       = "#223d90";
        magenta        = "#6e33ce";
        magenta-bright = "#8452d5";
        cyan           = "#287980";
        cyan-bright    = "#488d93";
        cyan-dim       = "#22676d";
        white          = "#f2e9e1";
        orange         = "#955f61";
        orange-bright  = "#ab6D70";
        pink           = "#a440b5";
        pink-bright    = "#bd4ad0";
        comment        = "#837a72";
        bg0            = "#e4dcd4"; # Dark bg (status line and float)
        bg1            = "#f6f2ee"; # Default bg
        bg2            = "#dbd1dd"; # Lighter bg (colorcolm folds)
        bg3            = "#d3c7bb"; # Lighter bg (cursor line)
        bg4            = "#aab0ad"; # Conceal, border fg
        fg0            = "#302b5d"; # Lighter fg
        fg1            = "#3d2b5a"; # Default fg
        fg2            = "#643f61"; # Darker fg (status line)
        fg3            = "#824d5b"; # Darker fg (line numbers, fold colums)
        sel0           = "#e7d2be"; # Popup bg, visual selection bg
        sel1           = "#a4c1c2"; # Popup sel bg, search bg
      in {
        # INTERFACE
        # These scopes are used for theming the editor interface.

        "ui.background" = { bg = bg1; }; # Default background color.
        "ui.window" = { fg = bg0; }; # Window border between splits.
        "ui.gutter" = { fg = fg3; }; # Left gutter for diagnostics and breakpoints.

        "ui.text" = { fg = fg1; }; # Default text color.
        "ui.text.focus" = { bg = sel1; fg = fg1; }; # Selection highlight in buffer-picker or file-picker.
        "ui.text.info" = { fg = fg2; bg = sel0; }; # Info popup contents (space mode menu).

        "ui.cursor" = { bg = fg3; fg = bg1; }; # Fallback cursor colour, non-primary cursors when there are multiple (shift-c).
        "ui.cursor.primary" = { bg = fg1; fg = bg1; }; # The primary cursor when there are multiple (shift-c).
        "ui.cursor.match" = { fg = yellow; modifiers = ["bold"]; }; # The matching parentheses of that under the cursor.

        "ui.selection" = { bg = bg3; }; # All currently selected text.
        "ui.selection.primary" = { bg = bg4; }; # The primary selection when there are multiple.
        "ui.cursorline.primary" = { bg = bg3; }; # The line of the primary cursor (if cursorline is enabled)
        # "ui.cursorline.secondary" = { }; #	The lines of any other cursors (if cursorline is enabled)
        # "ui.cursorcolumn.primary" = { }; #	The column of the primary cursor (if cursorcolumn is enabled)
        # "ui.cursorcolumn.secondary" = { }; #	The columns of any other cursors (if cursorcolumn is enabled)

        "ui.linenr" = { fg = "fg3"; }; # Line numbers.
        "ui.linenr.selected" = { fg = "yellow"; modifiers = ["bold"]; }; # Current line number.

        # "ui.virtual" = { }; # Namespace for additions to the editing area.
        "ui.virtual.ruler" = { bg = bg3; }; # Vertical rulers (colored columns in editing area).
        "ui.virtual.whitespace" = { fg = bg3; }; # Whitespace markers in editing area.
        "ui.virtual.indent-guide" = { fg = black; }; # Vertical indent width guides

        "ui.statusline" = { fg = fg2; bg = bg0; }; # Status line.
        "ui.statusline.inactive" = { fg = fg3; bg = bg0; }; # Status line in unfocused windows.
        "ui.statusline.normal" = { bg = blue; fg = bg0; modifiers = ["bold"]; }; # Statusline mode during normal mode (only if editor.color-modes is enabled)
        "ui.statusline.insert" = { bg = green; fg = bg0; modifiers = ["bold"]; }; # Statusline mode during insert mode (only if editor.color-modes is enabled)
        "ui.statusline.select" = { bg = magenta; fg = bg0; modifiers = ["bold"]; }; # Statusline mode during select mode (only if editor.color-modes is enabled)

        "ui.help" = { bg = sel0; fg = fg1; }; # Description box for commands.

        "ui.menu" = { bg = sel0; fg = fg1; }; # Code and command completion menus.
        "ui.menu.selected" = { bg = fg3; }; # Selected autocomplete item.
        "ui.menu.scroll" = { fg = fg3; }; # fg sets thumb color, bg sets track color of scrollbar.

        "ui.popup" = { bg = bg0; fg = fg1; }; # Documentation popups (space-k).
        "ui.popup.info" = { bg = sel0; fg = fg1; }; # Info popups box (space mode menu).

        "markup.raw" = { fg = magenta; }; # Code block in Markdown.
        "markup.raw.inline" = { fg = orange; }; # `Inline code block` in Markdown.
        "markup.heading" = { fg = yellow; modifiers = ["bold"]; };
        "markup.list" = { fg = magenta; modifiers = ["bold"]; };
        "markup.bold" = { fg = orange; modifiers = ["bold"]; };
        "markup.italic" = { fg = pink; };
        "markup.link" = { fg = yellow-bright; modifiers = ["bold"]; };
        "markup.quote" = { fg = blue; };


        # DIAGNOSTICS
        "warning" = { fg =yellow; bg = bg1; }; # Diagnostics warning (gutter)
        "error" = { fg = red; bg = bg1; }; # Diagnostics error (gutter)
        "info" = { fg = blue; bg = bg1; }; # Diagnostics info (gutter)
        "hint" = { fg = green; bg = bg1; }; # Diagnostics hint (gutter)
        "diagnostic" = { modifiers = ["underlined"]; }; # Diagnostics fallback style (editing area)
        "diagnostic.error" = { fg = red; }; # Diagnostics error (editing area)
        "diagnostic.warning" = { fg = yellow; }; # Diagnostics warning (editing area)
        "diagnostic.info" = { fg = blue; }; # Diagnostics info (editing area)
        "diagnostic.hint" = { fg = green; }; # Diagnostics hint (editing area)


        # SYNTAX HIGHLIGHTING
        # These keys match tree-sitter scopes.

        "special" = { fg = fg2; }; # Special symbols e.g `?` in Rust, `...` in Hare.
        "attribute" = { fg = yellow; }; # Class attributes, html tag attributes.

        "type" = { fg = yellow; }; # Variable type, like integer or string, including program defined classes, structs etc..
        "type.builtin" = { fg = cyan-bright; }; # Primitive types of the language (string, int, float).
        "type.enum.variant" = { fg = orange-bright; };

        "constructor" = { fg = magenta; }; # Constructor method for a class or struct.

        "constant" = { fg = orange-bright; }; # Constant value
        "constant.builtin" = { fg = orange-bright; }; # Special constants like `true`, `false`, `none`, etc.
        "constant.builtin.boolean" = { fg = orange; }; # True or False.
        "constant.character" = { fg = green; }; # Constant of character type.
        "constant.character.escape" = { fg = yellow-bright; modifiers = ["bold"]; }; # escape codes like \n.
        "constant.numeric" = { fg = orange; }; # constant integer or float value.

        "string" = { fg = green; }; # String literal.
        "string.regexp" = { fg = yellow-bright; }; # Regular expression literal.
        "string.special" = { fg = yellow-bright; modifiers = ["bold"]; }; # Strings containing a path, URL, etc.
        "string.special.url" = { fg = cyan; modifiers = ["bold"]; }; # String containing a web URL.

        "comment" = { fg = comment; }; # This is a comment.
        "comment.block.documentation" = { fg = comment; modifiers = ["bold"]; }; # Doc comments, e.g '///' in rust.

        "variable" = { fg = black; }; # Variable names.
        "variable.builtin" = { fg = red; }; # Language reserved variables: `this`, `self`, `super`, etc.
        "variable.parameter" = { fg = cyan-bright; }; # Function parameters.
        "variable.other.member" = { fg = fg2; }; # Fields of composite data types (e.g. structs, unions).

        "label" = { fg = magenta-bright; }; # lifetimes - Loop labels, among other things.

        "punctuation" = { fg = fg2; }; # Any punctuation symbol.
        # "punctuation.delimiter" = { fg = fg2; }; # Commas, colons or other delimiter depending on the language.
        # "punctuation.bracket" = { fg = fg2; }; # Parentheses, angle brackets, etc.
        # "punctuation.special" = { fg = fg2; }; # String interpolation brackets

        "keyword" = { fg = magenta; }; # Language reserved keywords.
        "keyword.control" = { fg = pink; }; # Control keywords.
        "keyword.control.conditional" = { fg = magenta-bright; }; # `if`, `else`, `elif`.
        "keyword.control.repeat" = { fg = magenta-bright; }; # `for`, `while`, `loop`.
        "keyword.control.import" = { fg = pink-bright; }; # `import`, `export` `use`.
        "keyword.control.return" = { fg = magenta; }; # `return` in most languages.
        "keyword.control.exception" = { fg = magenta; }; # `try`, `catch`, `raise`/`throw` and related.
        "keyword.operator" = { fg = fg2; modifiers = ["bold"]; }; # 'or', 'and', 'in'.
        "keyword.directive" = { fg = pink-bright; }; # Preprocessor directives (#if in C...).
        "keyword.function" = { fg = red; }; # The keyword to define a funtion: 'def', 'fun', 'fn'.
        "keyword.storage" = { fg = magenta; }; # Keywords describing how things are stored
        "keyword.storage.type" = { fg = magenta; }; # The type of something, class, function, var, let, etc.
        "keyword.storage.modifier" = { fg = yellow; }; # Storage modifiers like static, mut, const, ref, etc.

        "operator" = {  fg = fg2; }; # Logical, mathematical, and other operators.

        "function" = { fg = blue-bright; };
        "function.builtin" = { fg = red; };
        "function.macro" = { fg = red; };
        # "function.special" = { fg = blue-bright; }; # Preprocessor function in C.
        # "function.method" = { fg = blue-bright; }; # Class / Struct methods.

        "tag" = { fg = blue-bright; }; # As in <body> for html, css tags.

        "namespace" = { fg = cyan-bright; }; # Namespace or module identifier.


        # Diff ==============================
        # Version control changes.

        "diff.plus" = green-dim; # Additions.
        "diff.minus" = red-dim; # Deletions.
        "diff.delta" = blue-dim; # Modifications.
        "diff.delta.moved" = cyan-dim; # Renamed or moved files.
      };
    };
  };
}
