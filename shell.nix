with import <nixpkgs> {};
let
  gems = bundlerEnv {
    name = "gems-for-some-project";
    gemdir = ./.;
  };
in mkShell { buildInputs = [
	gems
	gems.wrappedRuby
	go
	zlib
	libiconv
	gcc
	git
	sqlite
	libpcap
	postgresql
	libxml2
	libxslt
	pkgconfig
	bundix
	gnumake
	nodejs
	file
	libffi
 ];
 }
