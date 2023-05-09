# USTCTHESIS with Docker

基于 [USTCTHESIS](https://github.com/ustctug/ustcthesis) 模板的 Docker 编译环境使用说明。

## 前置准备

请自行安装 [Docker](https://docs.docker.com/get-docker/) 环境，预先拉取所需镜像（可选）：

```sh
# official docker image is https://hub.docker.com/r/texlive/texlive but only for amd64
# use https://hub.docker.com/r/zydou/texlive for both amd64 and arm64
# optional: will be pulled automatically when first use
docker pull zydou/texlive:latest
```

## 使用说明

支持 make 命令和 vscode 插件两种方式使用 docker 进行编译，可根据个人喜好选择。

### make 命令

新增 docker 相关的 make 命令如下：

```sh
# 编译使用说明文件(ustcthesis-doc.tex)
make docker-doc
# 编译论文(main.tex)
make docker-main
# 清理编译中间文件(仅保留pdf)
make docker-clean
# 清理编译中间文件和输出文件
make docker-cleanall
```

### vscode

若不习惯使用命令行，可使用 vscode 进行可视化操作，需安装插件 [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)，相关配置已在 [.vscode/settings.json](https://github.com/Einsier/ustcthesis-docker/blob/master/.vscode/settings.json) 中给出。

插件栏 `TEX` 中 `Commands` 下已提供常用命令，如：

- `Recipe: latexmk (xelatex)`：编译 tex 文件，VSCode 会调起 Docker 容器执行编译过程（结束后会自动删除容器）
- `View in VSCode tab`：分栏查看编译生成的 PDF 文件
- `View Latex compiler log`：查看编译日志