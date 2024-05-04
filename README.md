# latex-docker

Docker hub: https://hub.docker.com/r/am009/latex

## Introduction

A docker image for latex compilation. Aims to provide out-of-box compilation environment for most of the latex projects like overleaf. **If you have found any compilation issue using this image, please raise an issue here.**

- Contains most of the common fonts and packages.

Details:
- Base image: Ubuntu 24.04
- Install location: /usr/local/texlive/2024
- Work directory: /root

## Usage

Mount your workspace under /root/, and compile your project. You can also add dev-container or connect vscode into the container.

```
docker run -it -v  $PWD:/root/ am009/latex
```

## Alternatives

- [overleaf base image](https://github.com/overleaf/overleaf/blob/main/server-ce/Dockerfile-base)
- [mingchen/docker-latex](https://github.com/mingchen/docker-latex)
- [blang/docker-latex](https://github.com/blang/latex-docker)
