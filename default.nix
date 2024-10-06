{
  lib,
  writeText,
  where-is-my-sddm-theme,
  /*
     NOTE: Don't write a key that is already defined in the theme's configuration file.
           The key will not be overwritten, and it will be defined twice in the configuration file.

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
  theme = ./.;
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

  themeContent = builtins.readFile "${theme}/themes/catppuccin-${flavor}.conf";
  customThemeContent =
    let
      removeDuplicates =
        string: builtins.concatStringsSep "\n" (lib.unique (lib.strings.splitString "\n" string));
    in
    if settings == null then
      themeContent
    else
      removeDuplicates (themeContent + lib.generators.toINI { } settings);
  customTheme = writeText "theme.conf.user" customThemeContent;
in
lib.throwIfNot (builtins.elem flavor validFlavors)
  "catppuccin-where-is-my-sddm-theme: flavor ${flavor} is not valid. Valid flavors are: ${builtins.concatStringsSep ", " validFlavors}"
  lib.checkListOfEnum
  "catppuccin-where-is-my-sddm-theme: variant"
  validVariants
  variants
  (where-is-my-sddm-theme.override { inherit variants; }).overrideAttrs
  (
    finalAttrs: oldAttrs: {
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
        homepage = "https://github.com/HeitorAugustoLN/catppuccin-where-is-my-sddm-theme";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ HeitorAugustoLN ];
        inherit (oldAttrs.meta) platforms;
      };
    }
  )
