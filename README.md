# genoffice-flake-nixos

本项目把 [GenOffice](https://github.com/genspark-ai/genoffice) 的上游 AppImage 封装成 Nix 包，
可以直接作为 flake 输入使用。

## 使用方法

在 `flake.nix` 中加入：

```nix
inputs.genoffice.url = "github:moren5483/genoffice-flake-nixos";
```

然后在需要的地方引用：

```nix
inputs.genoffice.packages.${pkgs.system}.default
```

例如配合 home-manager：

```nix
home.packages = [
  inputs.genoffice.packages.${pkgs.system}.default
];
```

也可以不安装，直接运行：

```bash
nix run github:moren5483/genoffice-flake-nixos
```

在 NixOS 上，Nix store 是 nosuid 挂载，Chromium 的 setuid sandbox 无法使用。如果启动时报错，
加上 `--no-sandbox`：

```bash
nix run github:moren5483/genoffice-flake-nixos -- --no-sandbox
```

包内安装的桌面启动项已经带上 `--no-sandbox`，所以从应用菜单启动可以直接使用。

目前只支持 `x86_64-linux`，与上游提供的 AppImage 一致。

## 桌面集成

安装后会提供：

- `genoffice` 命令
- `genoffice.desktop` 桌面启动项
- 多尺寸图标（16×16 到 1024×1024）
- GenOffice 相关文件类型的 MIME 定义

## 自动更新

`.github/workflows/update.yml` 会在每周日（以及手动触发 `workflow_dispatch` 时）运行
`nix-update`，自动修改 `package.nix` 中的版本号和哈希，然后提交并推送。

## 已知问题

Nix store 是 nosuid 挂载，Chromium sandbox 可能启动失败。从命令行启动如果报错，加
`--no-sandbox`：

```bash
genoffice --no-sandbox
```

上游只提供 x86_64 的 AppImage，所以目前不支持 `aarch64-linux`。
