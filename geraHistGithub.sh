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
    --pretty=format:"%ad | %h | %s" \
    --date=format:"%d/%m/%Y %H:%M:%S" \
    >> relatorio.md

echo "Relatório criado."
