{
  description = "GenOffice Nix packaging";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      genoffice = pkgs.callPackage ./package.nix { };
    in
    {
      packages.${system} = {
        default = genoffice;
        # Keep a named output so `nix-update --flake genoffice` can find it.
        genoffice = genoffice;
      };
    };
}
