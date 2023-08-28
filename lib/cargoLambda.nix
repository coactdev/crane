{ cargo-lambda
, lib
, mkCargoDerivation
}:

{ cmd ? "build"
, cargoLamdaxtraArgs ? ""
, cargoExtraArgs ? ""
, src
, ...
}@origArgs:
let
  args = builtins.removeAttrs origArgs [
    "cargoLambdaExtraArgs"
    "cargoExtraArgs"
  ];
in
mkCargoDerivation (args // {
  buildPhaseCargoCommand = "cargo lambda ${cmd} ${cargoExtraArgs} ${cargoAuditExtraArgs}";

  pnameSuffix = "-lambda";

  # Avoid trying to introspect the Cargo.toml file as it won't exist in the
  # filtered source (it also might not exist in the original source either).
  # So just use some placeholders here in case the caller did not set them.
  pname = args.pname or "crate";
  version = args.version or "0.0.0";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lamda ];
})
