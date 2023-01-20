{ pkgs, ... }:
let
  self = {
    basalt = pkgs.callPackage ./basalt.nix { };
    monado-basic = pkgs.callPackage ./monado.nix {
      inherit (pkgs.gst_all_1) gstreamer gst-plugins-base;
      inherit (self) basalt;
    };
    monado-slam-handtracking = pkgs.callPackage ./monado.nix {
      inherit (pkgs.gst_all_1) gstreamer gst-plugins-base;
      inherit (self) basalt;
      slamSupport = true;
      handTrackingSupport = true;
    };
    monado-steamvr-bodge = pkgs.writeShellScriptBin "monado-steamvr-bodge" (builtins.readFile ./monado-steamvr-bodge.sh);
  };
in
self
