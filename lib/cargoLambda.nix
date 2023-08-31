{ cargo-lambda
, mkCargoDerivation
}:

{ cargoArtifacts
, cmd ? "build"
, cargoLambdaExtraArgs ? ""
, cargoExtraArgs ? ""
, cargoZigBuildCacheDir ? "$TMPDIR/CACHE"
, preCargoArgs ? ""
, ...
}@origArgs:
let
  args = builtins.removeAttrs origArgs [
    "cmd"
    "cargoLambdaExtraArgs"
    "cargoExtraArgs"
    "preCargoArgs"
  ];
in
mkCargoDerivation (args // {
  inherit cargoArtifacts;
  buildPhaseCargoCommand = "CARGO_ZIGBUILD_CACHE_DIR=${cargoZigBuildCacheDir} ${preCargoArgs} cargo ${cargoExtraArgs} lambda ${cmd} ${cargoLambdaExtraArgs}";

  pnameSuffix = "-lambda";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lambda ];
})
