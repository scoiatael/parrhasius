{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    nodejs-16_x
    ruby_3_0.devEnv
    bundix
    rubyPackages_3_0.pry-byebug
    rubyPackages_3_0.sqlite3
    sqlite
    sass
  ];

  NIX_CFLAGS_COMPILE = "-fdeclspec";
}
