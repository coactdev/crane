{ cargo-lambda
, mkCargoDerivation
}:

{ cargoArtifacts
, cmd ? "build"
, cargoLambdaExtraArgs ? ""
, cargoExtraArgs ? ""
, cargoZigBuildCacheDir ? "/build/CACHE"
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
  buildPhaseCargoCommand = "CARGO_ZIGBUILD_CACHE_DIR=${cargoZigBuildCacheDir} cargo lambda ${cmd} ${cargoExtraArgs} ${cargoLambdaExtraArgs}";

  pnameSuffix = "-lambda";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lambda ];
})
