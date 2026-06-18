{lib, ...}: {
  home.activation.linkOpencodeSkills = lib.hm.dag.entryAfter ["writeBoundary"] ''
    skills_source="$HOME/.codex/skills"
    skills_target="$HOME/.config/opencode/skills"

    mkdir -p "$(dirname "$skills_target")"

    if [[ -d "$skills_source" ]]; then
      rm -rf "$skills_target"
      ln -s "$skills_source" "$skills_target"
    fi
  '';

  programs = {
    mcp.servers = {
      linear = {
        type = "remote";
        url = "https://mcp.linear.app/mcp";
        enabled = true;
      };
      github = {
        type = "remote";
        url = "https://api.githubcopilot.com/mcp/";
        enabled = true;
        oauth = false;
        headers = {
          Authorization = "Bearer {env:GITHUB_PAT_TOKEN}";
        };
      };
      "datadog-mcp" = {
        type = "remote";
        url = "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp";
        enabled = true;
      };
    };

    opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        model = "gpt-5.4";
      };
    };
  };
}
