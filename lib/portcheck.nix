{ lib, catalog, pkgs }:
let
  types = [ "string" "list" ];
  problemsOf = kind: name: port:
    let
      at = "${kind}/${name}";
      argNames = lib.attrNames port.args;
      buildArgs = lib.attrNames (lib.functionArgs port.build);
      argProblems = lib.concatLists (lib.mapAttrsToList
        (arg: spec:
          lib.optional (!(builtins.elem (spec.type or null) types)) "${at}: arg ${arg} has no type, one of: ${lib.concatStringsSep ", " types}"
          ++ lib.optional (!(spec ? description)) "${at}: arg ${arg} has no description"
          ++ lib.optional (!(spec ? default || spec ? example)) "${at}: arg ${arg} has neither default nor example")
        port.args);
      listParams = lib.optionals (kind == "adapters")
        (builtins.filter (param: param.kind == "list")
          (lib.concatMap (capability: capability.params) ((port.call port.example) pkgs).capabilities));
    in
    lib.optional ((port.description or "") == "") "${at}: no description"
    ++ lib.optional (!builtins.pathExists (port.dir + "/README.md")) "${at}: no README.md"
    ++ lib.optional (argNames != buildArgs) "${at}: args (${toString argNames}) differ from what build takes (${toString buildArgs})"
    ++ argProblems
    ++ lib.optional (listParams != [ ] && !port.open) "${at}: a list param passes anything to the tool; narrow it or set open = true";
in
lib.concatLists (lib.mapAttrsToList (kind: ports: lib.concatLists (lib.mapAttrsToList (problemsOf kind) ports)) catalog)
