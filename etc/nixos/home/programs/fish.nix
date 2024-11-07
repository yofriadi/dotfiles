{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Set vi mode
      fish_vi_key_bindings
      
      # Remove welcome message
      set -U fish_greeting

      # Golang
      set -x GOMODCACHE $HOME/.cache/go
      set -x GOPATH $HOME/.local/share/go
      set -x GOBIN $GOPATH/bin
      set -x PATH $GOBIN $PATH

      # completion
      eval (zellij setup --generate-auto-start fish | string collect)

      zoxide init fish --cmd z | source
      #starship init fish | source
      atuin init fish | source
    '';

    shellAliases = {
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";

      l = "eza";
      ll = "eza -l";
      la = "eza -a";
      lla = "eza -la";

      n = "NVIM_APPNAME=nvim/n nvim";
      zl="zellij";
    };

    # Fish plugins
    plugins = [
      # Example plugin (uncomment if you want to use it):
      # {
      #   name = "tide";
      #   src = pkgs.fishPlugins.tide.src;
      # }
    ];

    # Shell abbreviations (expand while typing)
    shellAbbrs = {
      #g = "git";
      #gs = "git status";
      #gc = "git commit";
      #gp = "git push";
    };

    # Custom functions
    functions = {
      # Create and cd into a directory
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";

      #fish_prompt = ''
        #set_color brblue
        #echo -n "["(whoami)@(hostname)"] "
        #set_color $fish_color_cwd
        #echo -n (prompt_pwd)
        #set_color normal
        #echo -n " > "
      #'';
    };
  };
}
