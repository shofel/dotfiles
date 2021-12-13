{ config, pkgs, ... }:

# DOC: man home-configuration.nix

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "shovel";
  home.homeDirectory = "/home/shovel";

  # Home Manager
  # TODO kitty @see https://github.com/NixOS/nixpkgs/issues/80936
  home.packages = with pkgs; [
    htop neovim gh bat fd ripgrep
    nodePackages.vscode-langservers-extracted
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Slava";
    userEmail = "visla.vvi@gmail.com";

    extraConfig = {
      pull = { rebase = true; };
      core = {
        editor = "nvim";
        excludesfile = "/home/shovel/.config/git/gitignore_global";
      };
    };
  };

  programs.command-not-found.enable = true;

    # Fish

    home.file = {
      ".config/fish/functions" = {
        source = /home/shovel/workspaces/dotfiles/fish/functions;
        recursive = true;
      };
    };

    programs.fish.enable = true;

    # TODO another way to keep abbrs in sync is `home.file.<name>.onChange`.
    # TODO reorganize such a way that everything of git is staying together.
    programs.fish.shellAbbrs = {
      dc = "docker-compose";
      execlip = "fish -c (xclip -o)";
      # git
      gB = "git switch (git fetch --all 1>/dev/null ;and git branch --all | string replace 'remotes/origin/' '' | string trim | sort | uniq | fzf)";
      gb = "git switch (git branch | string trim | fzf)";
      gBFG = "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";
      ga = "git add";
      gamend = "git commit --amend --no-edit";
      gcb = "git switch -c";
      gcd = "cd (git rev-parse --show-toplevel)";
      gclean = "git clean -fd";
      gcom = "git commit";
      gd = "git diff";
      gdca = "git diff --cached";
      gfa = "git fetch --all --prune --tags";
      ghash = "git rev-parse --short HEAD";
      ginit = "git init ;and git commit -m 'root' --allow-empty";
      gl = "git pull";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "git push -u origin (git branch | grep '*' | awk '{print \$2}')";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbs = "git rebase --skip";
      gsm = "git switch master";
      gst = "git status --short --branch";
      gsw = "git switch";
      #
      nocaps = "setxkbmap -option ctrl:nocaps";
      suspend = "systemctl suspend";
      v = "nvim '+Term fish'";
      weather = "curl wttr.in/guangzhou";
    };

    services.redshift = {
      enable = true;
      latitude = 56.83;
      longitude = 60.60;
      temperature = { day = 6500; night = 3000; };
    };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
