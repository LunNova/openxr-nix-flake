{ flakeArgs }:
system:
let
  inherit (flakeArgs.nixpkgs) lib;
  pkgs = flakeArgs.nixpkgs.legacyPackages.${system};
  localPackages = import ./packages { inherit pkgs; };
  perSystemSelf = {
    legacyPackages = localPackages;
    packages = lib.filterAttrs (_k: pkg: lib.isDerivation pkg && !((pkg.meta or { }).broken or false) && (!(pkg ? meta && pkg.meta ? platforms) || builtins.elem system pkg.meta.platforms)) localPackages;
    devShells = {
      default = flakeArgs.minimal-shell.lib.minimal-shell {
        inherit pkgs;
        shellHooks = perSystemSelf.checks.pre-commit-check.shellHook;
        shellPackages = [ pkgs.nixpkgs-fmt ];
      };
      monado-basic = flakeArgs.minimal-shell.lib.minimal-shell {
        inherit pkgs;
        shellHooks = ''
          export MONADO_PATH="${localPackages.monado-basic}"
          export XR_RUNTIME_JSON="$MONADO_PATH/etc/xdg/openxr/1/active_runtime.json"
          >&2 echo "If you want to use steamvr remember to run monado-steamvr-bodge"
        '';
        shellPackages = [
          localPackages.monado-basic
          localPackages.monado-steamvr-bodge
        ];
      };
      monado-slam-handtracking = flakeArgs.minimal-shell.lib.minimal-shell {
        inherit pkgs;
        shellHooks = ''
          export MONADO_PATH="${localPackages.monado-slam-handtracking}"
          export XR_RUNTIME_JSON="$MONADO_PATH/etc/xdg/openxr/1/active_runtime.json"
          if [ ! -d ~/.local/share/monado/hand-tracking-models ]; then
            >&2 echo "~/.local/share/monado/hand-tracking-models doesn't exist, run monado-get-ht-models to get it"
          fi
          >&2 echo "If you want to use steamvr remember to run monado-steamvr-bodge"
        '';
        shellPackages = [
          localPackages.monado-slam-handtracking
          localPackages.monado-steamvr-bodge
        ];
      };
    };
    formatter = pkgs.nixpkgs-fmt;

    checks = {
      pre-commit-check = flakeArgs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          statix.enable = true;
          nixpkgs-fmt.enable = true;
          shellcheck = {
            enable = true;
            files = "\\.sh$";
            types_or = lib.mkForce [ ];
          };
          shfmt = {
            enable = true;
            files = "\\.sh$";
          };
        };
      };
    };
  };
in
perSystemSelf
