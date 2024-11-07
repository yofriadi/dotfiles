{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      simplified_ui = true;
      pane_frames = false;
      mouse_mode = false;
      copy_on_select = false;
      copy_command = "pbcopy";
      serialize_pane_viewport = true;
      default_mode = "locked";
      default_layout = "compact";
      theme = "nightfox_dayfox";
      themes = {
        nightfox_dayfox = {
          bg = "#f6f2ee";
          fg = "#3d2b5a";
          red = "#a5222f";
          green = "#396847";
          blue = "#2848a9";
          yellow = "#ac5402";
          magenta = "#6e33ce";
          orange = "#955f61";
          cyan = "#287980";
          black = "#d3c7bb";
          white = "#643f61";
        };
        cyberdream-light = {
          bg = "#ffffff";
          fg = "#16181a";
          black = "#7b8496";
          red = "#d11500";
          green = "#008b0c";
          yellow = "#997b00";
          blue = "#0057d1";
          magenta = "#d100bf";
          cyan = "#008c99";
          white = "#16181a";
          orange = "#d17c00";
        };
        cyberdream-dark = {
          bg = "#16181a";
          fg = "#ffffff";
          black = "#7b8496";
          red = "#ff6e5e";
          green = "#5eff6c";
          yellow = "#f1ff5e";
          blue = "#5ea1ff";
          magenta = "#ff5ef1";
          cyan = "#5ef1ff";
          white = "#ffffff";
          orange = "#ffbd5e";
        };
      };
      #keybinds = {
      #  normal = {
      #    # Uncomment this and adjust key if using copy_on_select=false
      #    # Copy = "Alt c";
      #  };
      #  locked = {
      #    SwitchToMode = { "Ctrl g" = "Normal"; };
      #  };
      #  resize = {
      #    SwitchToMode = { "Ctrl n" = "Normal"; };
      #    Resize = {
      #      "h" = "Increase Left";
      #      "j" = "Increase Down";
      #      "k" = "Increase Up";
      #      "l" = "Increase Right";
      #      "H" = "Decrease Left";
      #      "J" = "Decrease Down";
      #      "K" = "Decrease Up";
      #      "L" = "Decrease Right";
      #      "=" = "Increase";
      #      "-" = "Decrease";
      #    };
      #  };
      #  pane = {
      #    SwitchToMode = { "Ctrl p" = "Normal"; };
      #    MoveFocus = {
      #      "h" = "Left";
      #      "l" = "Right";
      #      "j" = "Down";
      #      "k" = "Up";
      #    };
      #    NewPane = {
      #      "n" = "Normal";
      #      "d" = "Down";
      #      "r" = "Right";
      #    };
      #    CloseFocus = { "x" = "Normal"; };
      #    ToggleFocusFullscreen = { "f" = "Normal"; };
      #    TogglePaneFrames = { "z" = "Normal"; };
      #    ToggleFloatingPanes = { "w" = "Normal"; };
      #    TogglePaneEmbedOrFloating = { "e" = "Normal"; };
      #    SwitchToMode = { "c" = "RenamePane"; };
      #    PaneNameInput = 0;
      #  };
      #  # Continue the pattern for other modes...
      #};
      #
      #plugins = {
      #  tab-bar = { location = "zellij:tab-bar"; };
      #  status-bar = { location = "zellij:status-bar"; };
      #  strider = { location = "zellij:strider"; };
      #  compact-bar = { location = "zellij:compact-bar"; };
      #  session-manager = { location = "zellij:session-manager"; };
      #  welcome-screen = { location = "zellij:session-manager"; welcome_screen = true; };
      #  filepicker = { location = "zellij:strider"; cwd = "/"; };
      #  configuration = { location = "zellij:configuration"; };
      #  plugin-manager = { location = "zellij:plugin-manager"; };
      #};
      #
      #load_plugins = [
      #  # "file:/path/to/my-plugin.wasm"
      #  # "https://example.com/my-plugin.wasm"
      #];
    };
  };
}
