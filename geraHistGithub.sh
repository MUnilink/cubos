#!/bin/bash
echo "# RELATÓRIO GIT" > relatorio.md
echo "" >> relatorio.md
echo "Período: $1 a $2" >> relatorio.md
echo "" >> relatorio.md

git -c core.quotepath=false log \
    --since="$1" \
    --until="$2" \
    --date=short \
    --name-only \
    --pretty=format:"##Commit %h%nAutor: %an%nData: %ad%nDescrição: %s%n" \
    >> relatorio.md

echo "Relatório criado."
