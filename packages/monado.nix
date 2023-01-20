{ lib
, stdenv
, fetchFromGitLab
, writeText
, cmake
, doxygen
, glslang
, pkg-config
, python3
, SDL2
, dbus
, eigen
, ffmpeg
, gst-plugins-base
, gstreamer
, hidapi
, libGL
, libXau
, libXdmcp
, libXrandr
, libbsd
, libffi
, libjpeg
  # , librealsense
, libsurvive
, libusb1
, libuv
, libuvc
, libv4l
, libxcb
, onnxruntime
, opencv4
, openhmd
, udev
, vulkan-headers
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, libdrm
, zlib
, basalt
  # Set as 'false' to build monado without service support, i.e. allow VR
  # applications linking against libopenxr_monado.so to use OpenXR standalone
  # instead of via the monado-service program. For more information see:
  # https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
, serviceSupport ? true
, slamSupport ? true
, handTrackingSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "monado";
  version = "unstable-2023-01-14";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    rev = "1ef49b92f2d6cb519039edd7ba7f70e8073fbe88";
    sha256 = "sha256-zieJmI6BKHpYyCPOOUora9qoWn+NXehbHKvoi4h81UA=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    glslang
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DXRT_FEATURE_SERVICE=${if serviceSupport then "ON" else "OFF"}"
    "-DXRT_FEATURE_WINDOW_PEEK=ON"
    "-DXRT_BUILD_DRIVER_WMR=ON"
    "-DXRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH=ON"
  ] ++ lib.optionals handTrackingSupport [
    "-DXRT_BUILD_DRIVER_HANDTRACKING=ON"
  ] ++ lib.optionals slamSupport [
    "-DXRT_FEATURE_SLAM=ON"
  ];

  buildInputs = [
    SDL2
    dbus
    eigen
    ffmpeg
    gst-plugins-base
    gstreamer
    hidapi
    libGL
    libXau
    libXdmcp
    libXrandr
    libbsd
    libjpeg
    libffi
    # librealsense.dev - see below
    libsurvive
    libusb1
    libuv
    libuvc
    libv4l
    libxcb
    opencv4
    openhmd
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-scanner
    wayland-protocols
    libdrm
    zlib
  ] ++ lib.optionals handTrackingSupport [
    basalt
  ] ++ lib.optionals slamSupport [
    onnxruntime
  ];

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  postInstall = lib.optionalString handTrackingSupport ''
    cp ../scripts/get-ht-models.sh $out/bin/monado-get-ht-models
    cp ../scripts/update-ht-models.sh $out/bin/monado-update-ht-models
  '';

  meta = with lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
    mainProgram = "monado-cli";
  };
}
