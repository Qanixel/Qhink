## 检查配置文件的命令

```bash
nix flake check --no-build 通过。
nix eval .#nixosConfigurations.qhink.config.system.build.toplevel.drvPath
```

# TODO
- [ ] nix文件夹是否有点冗余？
- [ ] vscode 文件夹自动收起？
- [ ] vscode markdown 插件