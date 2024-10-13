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
  customThemeContent = lib.generators.toINI { } (
    lib.recursiveUpdate themeContent (lib.optionalAttrs (settings != null) settings)
  );
  customTheme = writeText "theme.conf.user" customThemeContent;
in
lib.throwIfNot (builtins.elem flavor validFlavors)
  "catppuccin-where-is-my-sddm-theme: flavor ${flavor} is not valid. Valid flavors are: ${builtins.concatStringsSep ", " validFlavors}"
  lib.checkListOfEnum
  "catppuccin-where-is-my-sddm-theme: variant"
  validVariants
  variants
  (where-is-my-sddm-theme.override { inherit variants; }).overrideAttrs
  (oldAttrs: {
    pname = "catppuccin-where-is-my-sddm-theme";
    version = "1.0.0";

    installPhase =
      oldAttrs.installPhase
      + lib.optionalString (builtins.elem "qt6" variants) ''
        ln -sf ${customTheme} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
      ''
      + lib.optionalString (builtins.elem "qt5" variants) ''
        ln -sf ${customTheme} $out/share/sddm/themes/where_is_my_sddm_theme_qt5/theme.conf.user
      '';

    meta = {
      description = "Soothing pastel theme for Where is my SDDM theme?";
      homepage = "https://github.com/catppuccin/where-is-my-sddm-theme";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ HeitorAugustoLN ];
      inherit (oldAttrs.meta) platforms;
    };
  })
