{
  lib,
  stdenvNoCC,
  fetchurl,
  openjdk,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wildfly";
  version = "24.0.1";

  src = fetchurl {
    url = "https://download.jboss.org/wildfly/${finalAttrs.version}.Final/wildfly-${finalAttrs.version}.Final.tar.gz";
    hash = "sha256-eD88L5gHeYc6vHC8lRdRHWUGk2wbYRwCjnc+6R5U7o8=";
  };

  buildCommand = ''
    mkdir -p "$out/opt"
    tar xf "$src" -C "$out/opt"
    mv "$out/opt/${finalAttrs.pname}-${finalAttrs.version}.Final" "$out/opt/${finalAttrs.pname}"
    find "$out/opt/${finalAttrs.pname}" -name \*.sh -print0 | xargs -0 sed -i -e '/#!\/bin\/sh/aJAVA_HOME=${openjdk}'
  '';

  meta = {
    description = "WildFly Application Server";
    homepage = "https://www.wildfly.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ionutnechita
    ];
    platforms = lib.platforms.unix;
  };
})
