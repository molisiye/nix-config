# 我的 Nix 配置

本仓库的初始配置基于 [ryan4yin/nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter) 模板。

该仓库包含了我的个人 Nix 配置，用于管理 macOS 环境。它通过 [Nix Flakes](https://nixos.wiki/wiki/Flakes)、[nix-darwin](https://github.com/LnL7/nix-darwin) 和 [home-manager](https://github.com/nix-community/home-manager) 进行管理。

## 目录结构

仓库围绕不同关注点进行了组织分离：

-   `flake.nix`: 整个配置的入口文件。它定义了所有的依赖（inputs）和最终的系统配置（outputs）。
-   `Justfile`: 提供了一组简单、易于记忆的命令，用于执行构建和应用配置等常见操作。
-   `modules/`: 包含用于 `nix-darwin` 的系统级配置模块。这里定义了系统范围的设置、应用程序和服务。
-   `home/`: 包含用于 `home-manager` 的用户级配置模块。这里管理着 Shell 环境、用户特定的软件包和 dotfiles。
-   `secrets/`: 存放加密后的密钥文件。这些文件由 `sops-nix` 管理，以确保 API 密钥和密码等敏感信息不会以明文形式存储。

## 工作流程

本配置使用 `just` (一个方便的命令运行器) 来进行管理。主要命令定义在 `Justfile` 中：

-   **`just switch`**: 最常用的命令。它会构建新配置并立即在当前系统上激活。
-   **`just build`**: 构建系统配置，但不会激活它。这在应用更改之前验证其有效性时非常有用。
-   **`just update`**: 将所有的 flake inputs (依赖项) 更新到最新版本，并更新 `flake.lock` 文件。
-   **`just clean`**: 从 Nix store 中清理旧的、未被使用的路径，以释放磁盘空间。

## 密钥管理

密钥通过 `sops-nix` 进行管理。加密后的密钥文件位于 `secrets/secrets.yaml`。在系统构建过程中，`sops-nix` 会在 Nix store 中自动解密此文件，使其内容可用于需要它们的各项服务。

要编辑密钥，您需要 `sops` 命令行工具以及对所配置的 `age` 私钥的访问权限。