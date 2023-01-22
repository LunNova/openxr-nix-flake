{ fetchFromGitLab
, stdenv
, python3
}:

stdenv.mkDerivation {
  pname = "xr-hardware";
  version = "unstable";

  nativeBuildInputs = [
    python3
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "utilities/xr-hardware";
    rev = "8618eed28a3401ae1c657cb6cddfb1ff67155e80";
    hash = "sha256-w6O5X9O0OfTsg0wllEEszpFbVpn5Rvey9i66sGW4+aM=";
  };

  doCheck = true;
  strictDeps = true;

  buildPhase = ''
    make
  '';
  checkPhase = ''
    make test
  '';
  installPhase = ''
    PREFIX=$out make install_package
  '';
}
