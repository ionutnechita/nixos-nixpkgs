{ squashfsTools, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "yandex-ffmpeg-codecs";
  version = "111306";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_34.snap";
    sha256 = "sha256-Dna9yFgP7JeQLAeZWvSZ+eSMX2yQbX2/+mX0QC22lYY=";
  };

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-${version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Yandex Web Browser";
    homepage    = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ dan4ik605743 ionutnechita ];
    platforms   = [ "x86_64-linux" ];
  };
}
