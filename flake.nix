{
  description = "flaKe️";

  inputs = {
      utils.url = "github:kreisys/flake-utils";
      nixpkgs.url = "github:NixOS/nixpkgs/16b3b1eef03e6fb8211b095079aba5059f26081e";

      haskell-backend = {
          submodules = true;
          type = "git";
          url = "https://github.com/nrdxp/kore";
          flake = false;
      };
      llvm-backend = {
          submodules = true;
          type = "git";
          url = "https://github.com/kreisys/llvm-backend";
          flake = false;
          rev = "dc7eebd37782204e1988483269a34a70bf1a697c";
      };
      k-web-theme = {
          submodules = true;
          url = "https://github.com/runtimeverification/k-web-theme";
          type = "git";
          flake = false;
          rev = "189fe6650488f8f04dc89d25a61cdfd888cd9dd8";
      };
  };

  outputs = { self, nixpkgs, utils, haskell-backend, llvm-backend, k-web-theme }:
  utils.lib.simpleFlake {
    inherit nixpkgs;
    systems = [ "x86_64-darwin" "x86_64-linux" ];
    overlay = final: prev: let
        src = final.runCommand "src" {} ''
          cp -r ${self} $out
          chmod -R +w $_

          cp -r "${haskell-backend}" $out/haskell-backend/src/main/native/haskell-backend
          cp -r "${llvm-backend}" $out/llvm-backend/src/main/native/llvm-backend
          cp -r "${k-web-theme}" $out/web/k-web-theme
        '';
    in {
      inherit (import src { inherit (final) system; })
        k clang llvm-backend haskell-backend mavenix mkShell;
    };

    packages = {
        k, clang, llvm-backend, haskell-backend, mavenix, mkShell
    }: {
      inherit k clang llvm-backend haskell-backend mavenix mkShell;
      defaultPackage = k;
    };
  };
}
