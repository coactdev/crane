{ cargo-lambda
, mkCargoDerivation
}:

{ cargoArtifacts
, cmd ? "build"
, cargoLambdaExtraArgs ? ""
, cargoExtraArgs ? ""
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
  buildPhaseCargoCommand = "cargo lambda ${cmd} ${cargoExtraArgs} ${cargoLambdaExtraArgs}";

  pnameSuffix = "-lambda";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lambda ];
})
