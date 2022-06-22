@echo off

rem Escolha da JRE a ser executado o Agent (Nativa do servidor / Padrão do Agent).
set FAST_ANALYTICS="%cd%"
if exist %FAST_ANALYTICS%\jre\bin\java.exe (
	set FAST_JAVA=%FAST_ANALYTICS%\jre\bin\java.exe
	ECHO Usando JRE Local
) else (
	set FAST_JAVA="%JAVA_HOME%\bin\java.exe"
	ECHO Usando JRE do JAVA_HOME
)

rem Informa ao usuário a versão do Java utilizada.
%FAST_JAVA% -version

rem Extrai as queries da tabela I01 do Protheus.
echo Início do processo: %time%
java -cp agent-analytics-1.6.2.jar com.gooddata.agent.jdbc.JdbcExport config.properties
echo Fim do processo: %time%
