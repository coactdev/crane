{ cargo-lambda
, mkCargoDerivation
}:

{ cargoArtifacts
, cmd ? "build"
, cargoLambdaExtraArgs ? ""
, cargoExtraArgs ? ""
, cargoZigBuildCacheDir ? "$TMPDIR/CACHE"
, ...
}@origArgs:
let
  args = builtins.removeAttrs origArgs [
    "cmd"
    "cargoLambdaExtraArgs"
    "cargoExtraArgs"
  ];
in
mkCargoDerivation (args // {
  inherit cargoArtifacts;
  buildPhaseCargoCommand = "CARGO_ZIGBUILD_CACHE_DIR=${cargoZigBuildCacheDir} cargoWithProfile lambda ${cmd} ${cargoExtraArgs} ${cargoLambdaExtraArgs}";

  pnameSuffix = "-lambda";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lambda ];
})
