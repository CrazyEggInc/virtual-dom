{
  description = "CrazyEgg virtual DOM";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) glibcLocales;
        inherit (pkgs.stdenv) isLinux;
        inherit (pkgs.lib) optionalString;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs =
            [
              pkgs.nodejs_20

              # dev dependencies
              pkgs.glibcLocales
              pkgs.git
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              pkgs.inotify-tools
              pkgs.libnotify
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (
              with pkgs.darwin.apple_sdk.frameworks;
              [
                terminal-notifier
                CoreFoundation
                CoreServices
              ]
            );

          env = {
            LOCALE_ARCHIVE = optionalString isLinux "${glibcLocales}/lib/locale/locale-archive";
            LANG = "en_US.UTF-8";
          };
        };
      }
    );
}
