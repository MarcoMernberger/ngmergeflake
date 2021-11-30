{
  description = "Wrap NGmerge into a flake";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs?rev=7e9b0dff974c89e070da1ad85713ff3c20b0ca97"; # that's 21.05
    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, utils, }:
    utils.lib.eachDefaultSystem (system:
      let
        #pkgs = nixpkgs.legacyPackages."${system}";

        pkgs = import nixpkgs { inherit system; };
      in rec {
        # `nix build`
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "NGmerge";
          version = "0.01";
          src = pkgs.fetchFromGitHub {
            owner = "jsh58";
            repo = "NGmerge";
            rev = "bf260e591114fb1045e80ec5fa2cc3e663b2e19c";
            sha256 =
              "sha256-yuk5WP8B3itEQ5djS1FWNEpiXq1UbUWFMgFtwBqdgPI="; # muss zur rev passen
              #pkgs.lib.fakeSha256; # muss ersetzt werden nach dem eresten laufen
          };
          srcRoot = ./.; # wo sind bie quellen?
          nativeBuildInputs = [ pkgs.zlib ]; # make und gcc sind immer dabei...
          # make install kann das ding nicht, muessen wir selbs machen
          installPhase = ''
          mkdir $out/bin -p
          cp NGmerge $out/bin
          '';
        };
      });
}
