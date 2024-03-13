select
    ZC1.ZC1_FILIAL as FILIAL,
    concat(trim(ZC1.ZC1_NUM), trim(ZC2.ZC2_ITEM)) as ID_OS,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_ITEM as ITEM,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
    
    ZC1.ZC1_PORTO as PORTO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    ZC1.ZC1_NAVIO as NAVIO,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,

    DEV.A1_COD as CLI_CODIGO,
    DEV.A1_LOJA as CLI_LOJA,
    DEV.A1_CGC as CLI_CNPJ,
    trim(DEV.A1_NOME) as CLIENTE,

    ARM.A1_COD as ARM_CODIGO,
    ARM.A1_LOJA as ARM_LOJA,
    ARM.A1_CGC as ARM_CNPJ,
    trim(DEV.A1_NOME) as ARMADORA,

    DES.A2_COD as DESP_CODIGO,
    DES.A2_LOJA as DESP_LOJA,
    DES.A2_CGC as DESP_CNPJ,
    trim(DES.A2_NOME) as DESPACHANTE,
    
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    ZC1.ZC1_TABPRC as TABELADEPRECO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,
    (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZA9.ZA9_CODTAX) /*and ZC2.ZC2_TIPO = 11*/) as TAXA_PORT,
    trim(AIB.AIB_CODPRO) as COD_TAXA,
    cast(AIB.AIB_PRCCOM as decimal(15, 2)) as TAXA_VALUNI,
    cast(AIB.AIB_PRCCOM * ZC2.ZC2_QTDPRV as decimal(15, 2)) as TAXA_VALPRV,
    cast(AIB.AIB_PRCCOM * ZC2.ZC2_QTDREA as decimal(15, 2)) as TAXA_VALREA,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'RH'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        else 'OUTROS'
    end as TIPO_INSUMO,

    trim(ZC2.ZC2_COD) as INSUMO,
    case ZC2.ZC2_TIPO
        when 1 then (select case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(trim(SB1010.B1_DESC), 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 1)
        when 2 then (select trim(SRJ010.RJ_DESC) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2)
        when 3 then trim(ST9.T9_CODBEM)
        when 4 then (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 4)
        when 6 then trim(ST9.T9_CODBEM)
        when 7 then trim(ZA7.ZA7_DESC)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 5 then 'ENCERRADA COMO CORTESIA'
        when 6 then 'FECHADA'
        when 9 then 'PEDIDO CRIADO'
        else 'OUTROS'
    end as STATUS_OS,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    ZC2.ZC2_MOTORI as COD_MOT,
    DA4.DA4_NOME as MOTORISTA,
    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    substring(ZC2.ZC2_DTFIM, 1, 6) as PERIODO_APONT,
    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    convert(datetime, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), 113) as DTINI_APONT,
    convert(datetime, concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM), 113) as DTFIM_APONT,
    datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as HORAS_APONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    (select count(*) from ZC3010 where ZC3010.D_E_L_E_T_ = '' and ZC3010.ZC3_FILIAL = ZC2.ZC2_FILIAL and ZC3010.ZC3_NUM = ZC2.ZC2_NUM and ZC3010.ZC3_ITEM = ZC2.ZC2_ITEM) as QTD_RATEIO

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
        left join SA1010 DEV (nolock)
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC1.ZC1_CODSA1
            and DEV.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA1010 ARM (nolock)
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC1.ZC1_ARMADO
            and ARM.A1_LOJA = ZC1.ZC1_LJARMA
        left join SA2010 DES (nolock)
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC1.ZC1_DESPA
            and DES.A2_LOJA = ZC1.ZC1_LJDESP

    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
    
    left join ZA9010 ZA9 (nolock)
        on ZA9.D_E_L_E_T_ = ''
        and ZA9.ZA9_FILIAL = ZC2.ZC2_FILIAL
        and ZA9.ZA9_SERVIC = ZC2.ZC2_COD

        left join AIB010 AIB (nolock)
            on AIB.D_E_L_E_T_ = ''
            and AIB.AIB_CODFOR = ZA9.ZA9_PORTO
            and AIB.AIB_LOJFOR = ZA9.ZA9_LJPORT
            and AIB.AIB_CODPRO = ZA9.ZA9_CODTAX
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_INCLUS != 'C'
    and ZC2.ZC2_HRINI != '  :  '
    and ZC2.ZC2_HRFIM != '  :  '
    and year(ZC1.ZC1_EMISSA) > 2022
