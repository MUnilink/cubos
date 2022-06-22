#!/bin/bash

echo'
 ___ _   _ ____ _____  _    _        _    ____    _    ___
|_ _| \ | / ___|_   _|/ \  | |      / \  / ___|  / \  / _ \
 | ||  \| \___ \ | | / _ \ | |     / _ \| |     / _ \| | | |
 | || |\  |___) || |/ ___ \| |___ / ___ \ |___ / ___ \ |_| |
|___|_| \_|____/ |_/_/   \_\_____/_/   \_\____/_/   \_\___/

     ____  ___   ___  ____    ____    _  _____  _
    / ___|/ _ \ / _ \|  _ \  |  _ \  / \|_   _|/ \
   | |  _| | | | | | | | | | | | | |/ _ \ | | / _ \
   | |_| | |_| | |_| | |_| | | |_| / ___ \| |/ ___ \
    \____|\___/ \___/|____/  |____/_/   \_\_/_/   \_\

'

#Conversao do arquivo de formato windows para formato unix
mv config.properties config.properties_win
awk '{ sub("\r$", ""); print }' config.properties_win > config.properties
rm -rf config.properties_win


############### Variaveis ######################

user_cred=$(grep 'gdc.username' /outsourcing/totvs/protheus_data/gooddata/config.properties | cut -c 14-100)
pass_cred=$(grep 'gdc.password' /outsourcing/totvs/protheus_data/gooddata/config.properties | cut -c 14-100)
inst_db=$(grep 'Server=' /etc/odbc.ini | cut -c 8-100)
name_db=$(grep 'Database=' /etc/odbc.ini | cut -c 10-100)
agent=$(ls /outsourcing/totvs/protheus_data/gooddata/  | grep agen*)
user_db=
pass_db=

#Substituindo a , por : da instancia de banco de dados
inst_db=${inst_db/,/:}

#Variavel de montagem da string de conexão ao banco
url_db=("jdbc.url=jdbc:sqlserver:\/\/"$inst_db";DatabaseName="$name_db)


#Verificando se credencial GoodData do arquivo esta correta
if [ -z $user_cred  ]
        then
        read -p "Insira o Usuário do GoodData:  " user_cred
fi
if [ -z $pass_cred  ]
        then
        read -p "Insira a Senha do GoodData:  " pass_cred
fi


#Digitar usuário e senha do Banco de Dados 
read -p "Insira o Usuário do Banco de Dados: " user_db
read -p "Insira a Senha do Banco de Dados: " pass_db

#Encriptando a senha de login do GoodData
pass_cred=$(java -cp $agent com.gooddata.agent.util.Encrypt $pass_cred)

#Encriptando a senha do Banco de dados
pass_db=$(java -cp $agent com.gooddata.agent.util.Encrypt $pass_db)

#alterando as credenciais do gooddata
sed -i 's/gdc.username=.*/gdc.username='$user_cred'/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'
sed -i 's/gdc.password=.*/gdc.password='$pass_cred'/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'


#Inserindo instancia, banco de dados, usuario e senha no arquivo config.properties..."
sed -i 's/jdbc.url.*/'$url_db'/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'
sed -i 's/jdbc.username=.*/jdbc.username='$user_db'/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'
sed -i 's/jdbc.password=.*/jdbc.password='$pass_db'/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'

#Verificando e alterando o parâmetro de criptografia
sed -i 's/.*gdc.crypto=.*/gdc.crypto=TRUE/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'
#sed -i 's/#gdc.crypto=TRUE/gdc.crypto=TRUE/g' '/outsourcing/totvs/protheus_data/gooddata/config.properties'

#Criando arquivo run.sh
cria_run="java -jar"" "$agent" ""./config.properties"
echo $cria_run  > /outsourcing/totvs/protheus_data/gooddata/run.sh

#Ajustando permissôes da pasta gooddata
chmod 770 -R /outsourcing/totvs/protheus_data/gooddata/ && chown -R protheus.totvs /outsourcing/totvs/protheus_data/gooddata/

#Criando agendamento no cron
echo '00 05 * * * bash -l -c "cd /outsourcing/totvs/protheus_data/gooddata/ && ./run.sh"' >> /var/spool/cron/protheus

echo '######################################################################'
echo '#                       AÇÕES REALIZADAS:                            #'
echo '#                 INCLUSÃO DO PARAMETRO DE CRIPTOGRAFIA              #'
echo '#             CONVERSÃO DO ARQUIVO CONFIG PARA FORMATO UNIX          #'
echo '#           AJUSTE DE CREDENCIAIS DE LOGIN E SENHA DO GOODDATA       #'
echo '#              CRIPTOGRAFIA DE SENHA DO GD E BANCO DE DADOS          #'
echo '#             INSERÇÃO DE INSTACIA,USUARIO E SENHA DE BD             #'
echo '#                    CRIACAO DE ARQUIVO RUN.SH                       #' 
echo '#               AJUSTE DE PERMISSÃO NA PASTA DO GD                   #'
echo '#INSERÇÃO DE AGENDAMENTO NO CRON PARA TODOS OS DIAS AS 5HRS DA MANHA #' 
echo '######################################################################'

echo '######################################################################'
echo '#                                                                    #'
echo '#                    CONFIGURAÇÃO FINALIZADA                         #'
echo '#                                                                    #'
echo '######################################################################'

