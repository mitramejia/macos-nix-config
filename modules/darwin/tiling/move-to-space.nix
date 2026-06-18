{
  runCommandCC,
  swift,
  writeText,
  yabai,
}: let
  src = writeText "yabai-move-to-space.swift" (
    builtins.replaceStrings
    ["@YABAI@"]
    ["${yabai}/bin/yabai"]
    (builtins.readFile ./move-to-space.swift)
  );
in
  runCommandCC "yabai-move-to-space" {
    nativeBuildInputs = [swift];
  } ''
    mkdir -p $out/bin
    swiftc -O ${src} -o $out/bin/yabai-move-to-space
  ''
