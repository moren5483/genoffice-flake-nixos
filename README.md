# genoffice-flake-nixos

Nix packaging for [GenOffice](https://github.com/genspark-ai/genoffice), wrapping the upstream AppImage.

## Usage

Add it as a flake input:

```nix
inputs.genoffice.url = "github:moren5483/genoffice-flake-nixos";
```

Then reference the package:

```nix
inputs.genoffice.packages.${pkgs.system}.default
```

With `home-manager`:

```nix
home.packages = [
  inputs.genoffice.packages.${pkgs.system}.default
];
```

Or run it directly:

```bash
nix run github:moren5483/genoffice-flake-nixos
```

On NixOS the Chromium sandbox cannot use a setuid helper from the Nix store, so if
the app fails to start, pass `--no-sandbox`:

```bash
nix run github:moren5483/genoffice-flake-nixos -- --no-sandbox
```

The desktop entry installed by the package already includes `--no-sandbox`, so
launching GenOffice from the application menu works out of the box.

The package is `x86_64-linux` only, matching the upstream AppImage.

## Updates

`.github/workflows/update.yml` runs `nix-update` every Sunday (and on manual
`workflow_dispatch`) to bump the version and hash in `package.nix`, then commits
and pushes the change.

## 已知问题

Nix store 是 nosuid 挂载，Chromium sandbox 可能启动失败。首次启动如果报错，加
`--no-sandbox`：

```bash
genoffice --no-sandbox
```

上游只提供 x86_64 的 AppImage，所以目前不支持 `aarch64-linux`。
