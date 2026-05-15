{ pkgs, lib, ... }: let
  claudeDeps = [
    pkgs.nodejs_24
    pkgs.python3
    pkgs.sox        # voice input
    pkgs.bun        # gstack dep
    pkgs.codex      # cross-check
    pkgs.bubblewrap # for codex sandbox
  ];

  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.claude-code ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${lib.makeBinPath claudeDeps}
    '';
  };
in {
  home.packages = [ claude-wrapped ];

  programs.git.ignores = [
    # Claude Code: machine-local settings (not project config)
    ".claude/settings.local.json"

    # oh-my-claudecode: all content is AI-generated state, not source
    # If you want to track project-level omc artifacts (e.g. custom skills),
    # add a negation in the project's .gitignore: !.omc/skills/
    ".omc"

    # SpecKit run artifacts
    ".speckit"
  ];
}
