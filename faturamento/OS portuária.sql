select
    ZC1.ZC1_FILIAL as FILIAL,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
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
    
    ZC2.ZC2_ITEM as ITEM,
    SB1.B1_GRUPO as GRUPO,
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    ZC1.ZC1_TABPRC as TABELADEPRECO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        else 'OUTROS'
    end as TIPO_INSUMO,

    trim(ZC2.ZC2_COD) as INSUMO,
    case ZC2.ZC2_TIPO
        when 1 then trim(SB1.B1_DESC)
        when 2 then trim(SRV.RV_DESC)
        when 3 then 
        when 4 then trim(SB1.B1_DESC)
        when 6 then ''
        when 7 then ''
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 6 then 'FECHADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    ZC2.ZC2_MOTORI as COD_MOT,
    DA4.DA4_NOME as MOTORISTA,
    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    substring(ZC2.ZC2_DTINI, 1, 6) as PERIODO_APONT,
    ZC2.ZC2_DTINI as DATA_INIAPONT,
    ZC2.ZC2_DTFIM as DATA_FIMAPONT,
    convert(datetime, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), 103) as DTINI_APONT,
    convert(datetime, concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM), 103) as DTFIM_APONT,
    datediff(minute, convert(datetime, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), 103), convert(datetime, concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM), 103))/60.0 as HORAS_APONT,
    trim(ZC2.ZC2_NMUSU) as USUARIO

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        and substring(ZC1.ZC1_NUM, 1, 4) > 2022
        
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
    
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = ZC2.ZC2_COD
    left join SRV010 SRV (nolock)
        on SRV.D_E_L_E_T_ = ''
        and SRV.RV_COD = ZC2.ZC2_COD
    left join DA3010 DA3 (nolock)
        on DA3.D_E_L_E_T_ = ''
        and DA3.DA3_COD = ZC2.ZC2_VEICUL
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_INCLUS != 'C'
    and ZC2.ZC2_HRINI != '  :  '
    and ZC2.ZC2_HRFIM != '  :  '
    and year(ZC1.ZC1_EMISSA) > 2022
