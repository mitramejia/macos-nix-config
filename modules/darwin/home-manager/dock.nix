{
  config,
  username,
  ...
}: {
  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    {path = "/Applications/Slack.app/";}
    {path = "/Applications/1Password.app/";}
    {path = "/System/Applications/Messages.app/";}
    {path = "/System/Applications/FaceTime.app/";}
    {path = "/Applications/iTerm.app/";}
    {path = "/System/Applications/Notes.app/";}
    {path = "/Applications/WhatsApp.app/";}
    {path = "/Applications/Obsidian.app/";}
    {path = "/Applications/Notion.app/";}
    {path = "/Applications/Notion\ Calendar.app/";}
    {path = "/Users/mitramejia/Applications/WebStorm.app";}
    {path = "/Users/mitramejia/Applications/Android\ Studio.app/";}
    {path = "/System/Applications/Music.app/";}
    {path = "/Applications/Linear.app/";}
    {path = "/Applications/Arc.app/";}
    {path = "/System/Applications/iPhone\ Mirroring.app/";}
    {path = "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/";}
    {
      path = "/Applications/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "${config.users.users.${username}.home}/Downloads/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "${config.users.users.${username}.home}/Desktop/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
  ];
}
