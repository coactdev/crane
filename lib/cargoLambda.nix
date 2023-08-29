{ cargo-lambda
, mkCargoDerivation
}:

{ cmd ? "build"
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
  buildPhaseCargoCommand = "cargo lambda ${cmd} ${cargoExtraArgs} ${cargoLambdaExtraArgs}";

  pnameSuffix = "-lambda";

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cargo-lambda ];
})
