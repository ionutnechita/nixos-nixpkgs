{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "planus";
  version = "1.0.0";

  src = fetchCrate {
    pname = "planus-cli";
    inherit version;
    hash = "sha256-HbnuLu1yCpwouDVBH/vcFVLDMZWeqHH6qHFJoTbaS9Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0xKx3VO4bquC3syBhCf4h3CRWSmhhRk2kCEJeC1ZTTc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd planus \
      --bash <($out/bin/planus generate-completions bash) \
      --fish <($out/bin/planus generate-completions fish) \
      --zsh <($out/bin/planus generate-completions zsh)
  '';

  meta = with lib; {
    description = "Alternative compiler for flatbuffers";
    mainProgram = "planus";
    homepage = "https://github.com/planus-org/planus";
    changelog = "https://github.com/planus-org/planus/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
