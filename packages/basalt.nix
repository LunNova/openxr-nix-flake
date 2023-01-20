{ lib
, stdenv
, fetchFromGitLab
, writeText
, cmake
, pkg-config
, python3
, ninja
, eigen
, tbb
, opencv
, fmt
, boost
, bzip2
, pangolin
, libGL
, glew
, lz4
}:

stdenv.mkDerivation {
  pname = "monado-basalt";
  version = "unstable-2023-01-14";

  separateDebugInfo = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mateosss";
    repo = "basalt";
    rev = "632e1aab52d4054adf574fc7cb8f29d92575679a";
    fetchSubmodules = true;
    sha256 = "sha256-976bWdESd9tAk4o8W4RpeiMj0hF3n7qCcciZ+BOeHa4=";
  };

  nativeBuildInputs = [
    ninja
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    eigen
    tbb
    opencv
    fmt
    boost
    bzip2
    pangolin
    libGL
    glew
    lz4
  ];

  cmakeFlags = [
    "-DBASALT_INSTANTIATIONS_DOUBLE=OFF"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-GNinja"
  ];
}
