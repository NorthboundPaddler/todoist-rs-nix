{
  description = "Todoist CLI Client";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells.${system}.default =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
          packages = with pkgs;  [
            cargo
            rustc
            pkg-config
            openssl
          ];
          shellHook = ''
            echo "Developing with Rust!"
          '';
        };
      packages.${system}.default =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.rustPlatform.buildRustPackage
          rec {
            pname = "todoist-rs";
            version = "0.0.7";

            src = pkgs.fetchFromGitHub {
              owner = "illiteratewriter";
              repo = "todoist-rs";
              rev = "v0.0.7";
              sha256 = "sha256-AXywlwAPETUA1SlRvJsX8CEhjXqzebF5zWUOwPD/pbQ=";
            };

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            nativeBuildInputs = [ pkgs.pkg-config ];
            buildInputs = [ pkgs.openssl ];

            meta = with pkgs.lib; {
              description = "Todoist CLI Client";
              homepage = "https://github.com/illiteratewriter/todoist-rs";
              license = licenses.mit; # Replace with the actual license
              maintainers = [ maintainers.NorthboundPaddler ];
            };
          };
    };
}
