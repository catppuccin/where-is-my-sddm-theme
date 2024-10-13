{
  lib,
  writeText,
  runCommand,
  jc,
  where-is-my-sddm-theme,
  /*
    Here is how you can define extra settings for the theme and the flavor to use:

    environment.systemPackages = [
      (pkgs.catppuccin-where-is-my-sddm-theme.override {
        flavor = "macchiato";
        settings = {
          General = {
            hideCursor = false;
          };
        };
      })
    ];
  */
  settings ? null,
  flavor ? "mocha",
  variants ? [ "qt6" ],
}:
let
  theme = builtins.path {
    name = "catppuccin-where-is-my-sddm-theme";
    path = ./.;
  };
  validVariants = [
    "qt5"
    "qt6"
  ];
  validFlavors = [
    "frappe"
    "latte"
    "macchiato"
    "mocha"
  ];

  # Borrowed from catppuccin/nix
  fromINI =
    file:
    let
      json = runCommand "converted.json" { } ''${lib.getExe jc} --ini < ${file} > $out'';
    in
    builtins.fromJSON (builtins.readFile json);

  themeContent = fromINI "${theme}/themes/catppuccin-${flavor}.conf";
  customTheme = lib.recursiveUpdate themeContent (lib.optionalAttrs (settings != null) settings);
in
lib.throwIfNot (builtins.elem flavor validFlavors)
  "catppuccin-where-is-my-sddm-theme: flavor ${flavor} is not valid. Valid flavors are: ${builtins.concatStringsSep ", " validFlavors}"
  lib.checkListOfEnum
  "catppuccin-where-is-my-sddm-theme: variant"
  validVariants
  variants
  (where-is-my-sddm-theme.override {
    inherit variants;
    themeConfig = customTheme;
  }).overrideAttrs
  (oldAttrs: {
    pname = "catppuccin-where-is-my-sddm-theme";
    version = "1.0.0";

    meta = {
      description = "Soothing pastel theme for Where is my SDDM theme?";
      homepage = "https://github.com/catppuccin/where-is-my-sddm-theme";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ HeitorAugustoLN ];
      inherit (oldAttrs.meta) platforms;
    };
  })
