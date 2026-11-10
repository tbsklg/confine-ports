{ lib, zandy }:
let
  portsIn = kind: lib.mapAttrs
    (name: _:
      let
        dir = ../${kind}/${name};
        port = { args = { }; open = false; } // import (dir + "/port.nix") zandy.lib;
        defaults = lib.mapAttrs (_: arg: arg.default) (lib.filterAttrs (_: arg: arg ? default) port.args);
      in
      port // {
        inherit dir;
        call = given: port.build (defaults // given);
        example = lib.mapAttrs (_: arg: arg.example or arg.default) port.args;
      })
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../${kind}));
in
{
  presets = portsIn "presets";
  gateways = portsIn "gateways";
  adapters = portsIn "adapters";
}
