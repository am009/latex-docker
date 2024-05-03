#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e
cp -r $SCRIPTPATH/* /tmp
cd /tmp

# compile the file main.tex to pdf
# pdflatex -shell-escape main.tex -output-directory=/tmp -aux-directory=/tmp
latexmk -pdf -interaction=nonstopmode -shell-escape main.tex
