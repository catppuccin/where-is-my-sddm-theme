{
  fetchFromGitHub,
  lib,
  where-is-my-sddm-theme,
  catppuccin-whiskers,
  nix-update-script,
  /*
    An example of how you can override the default values of the theme and change the flavor.

    environment.systemPackages = [
      (pkgs.catppuccin-where-is-my-sddm-theme.override {
        flavor = "macchiato";
        themeOverrides = {
          blurRadius = 10;
          hideCursor = true;
        };
      })
    ];
  */
  themeOverrides ? null,
  flavor ? "mocha",
  variants ? [ "qt6" ],
}:
let
  theme = fetchFromGitHub {
    owner = "HeitorAugustoLN";
    repo = "catppuccin-where-is-my-sddm-theme";
    rev = "main";
    hash = "sha256-Cj1zrqBk45KxSG9MDOs3zDrEB5TMbqeT6RINFD1Lj6c=";
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

      nativeBuildInputs = [ catppuccin-whiskers ];

      installPhase =
        oldAttrs.installPhase
        + ''
          cd $out
          whiskers ${theme}/where-is-my-sddm-theme.tera ${
            lib.optionalString (themeOverrides != null) "--overrides '${builtins.toJSON themeOverrides}'"
          }
        ''
        + lib.optionalString (builtins.elem "qt6" variants) ''
          mv $out/themes/catppuccin-${flavor}.conf $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
        ''
        + lib.optionalString (builtins.elem "qt5" variants) ''
          mv $out/themes/catppuccin-${flavor}.conf $out/share/sddm/themes/where_is_my_sddm_theme_qt5/theme.conf.user
        ''
        + ''
          rm -rf $out/themes
        '';

      passthru.updateScript = nix-update-script { };

      meta = {
        description = "Soothing pastel theme for Where is my SDDM theme?";
        homepage = "https://github.com/HeitorAugustoLN/catppuccin-where-is-my-sddm-theme";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ HeitorAugustoLN ];
        inherit (oldAttrs.meta) platforms;
      };
    }
  )
