@echo off

rem Informa ao usuário a versão do Java utilizada.
java -version

rem Execução do Agent.
echo Início do processo: %time%
java -Xmx2048m -Djava.io.tmpdir="./tmp" -jar agent-analytics-1.6.2.jar config.properties
echo Fim do processo: %time%

rem ####################################################################
rem ###               COMANDOS ADICIONAIS DO JAVA                    ###
rem ####################################################################
rem Definição do diretório temporário utilizado pelo Agent.
rem -Djava.io.tmpdir="./tmp"

rem Definição da alocação de memória inicial (Xms) e máxima (Xmx) da jvm
rem -Xms1024m -Xmx2048m
rem ####################################################################
