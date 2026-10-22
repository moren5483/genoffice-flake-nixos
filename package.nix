let
  version = "0.11.919";
in
{
  lib,
  appimageTools,
  fetchurl,
  appimageSrc ? fetchurl {
    url = "https://github.com/genspark-ai/genoffice/releases/download/v${version}/GenOffice-${version}.AppImage";
    hash = "sha256-Imj58VS5BTl4cjS/l9gpjaGZxKOvOLoJkFTK3/dlCFA=";
  },
}:

let
  pname = "genoffice";
  src = appimageSrc;

  # The AppImage ships the icons (and a MIME definition) we want to reuse.
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ libsecret nss ];

  extraInstallCommands = ''
    for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512 1024x1024; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/$size/apps/genoffice.png \
        $out/share/icons/hicolor/$size/apps/genoffice.png
    done

    install -Dm444 ${appimageContents}/usr/share/mime/packages/genoffice.xml \
      $out/share/mime/packages/genoffice.xml

    mkdir -p $out/share/applications
    cat > $out/share/applications/genoffice.desktop <<EOF
    [Desktop Entry]
    Name=GenOffice
    Exec=genoffice --no-sandbox %U
    Terminal=false
    Type=Application
    Icon=genoffice
    StartupWMClass=genoffice
    Comment=AI-native office suite
    Categories=Office;
    MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.ms-excel.sheet.macroEnabled.12;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/vnd.ms-excel;text/csv;text/tab-separated-values;application/vnd.oasis.opendocument.spreadsheet;application/vnd.oasis.opendocument.spreadsheet-template;application/vnd.oasis.opendocument.text;application/vnd.oasis.opendocument.text-template;application/vnd.oasis.opendocument.presentation;application/vnd.oasis.opendocument.presentation-template;application/pdf;text/markdown;text/plain;application/json;text/html;
    EOF
  '';

  meta = with lib; {
    description = "AI-native office suite";
    homepage = "https://github.com/genspark-ai/genoffice";
    license = licenses.asl20;
    mainProgram = "genoffice";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
