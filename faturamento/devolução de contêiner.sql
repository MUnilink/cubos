select
    ZC1.ZC1_FILIAL,
    ZC1.ZC1_NUM,
    substring(ZC1.ZC1_NUM, 6, 10) as OS,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
    
    ZC1.ZC1_PORTO,
    ZC1.ZC1_NAVIO,
    trim(ZC1.ZC1_VIAGEM) as ZC1_VIAGEM,
    
    ZC2.ZC2_ITEM as ITEM,
    SB1.B1_GRUPO as GRUPO,
    trim(ZC2.ZC2_COD) as INSUMO,
    trim(ZC2.ZC2_DESC) as DESC_INSUMO,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 6 then 'APROPRIAÇÃO DE CUSTO'
        else 'OUTROS'
    end as TIPO_INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 6 then 'FECHADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    ZC2.ZC2_QTDPRV,
    ZC2.ZC2_QTDREA,
    ZC2.ZC2_VLUPRV,
    ZC2.ZC2_VLUREA,
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    
    substring(ZC2.ZC2_DTINI, 1, 6) as PERIODO_APONT,
    convert(datetime, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), 103) as DTINI_APONT,
    convert(datetime, concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM), 103) as DTFIM_APONT,
    trim(ZC2.ZC2_NMUSU) as USUARIO

from ZC1010 ZC1 (nolock)
    left join ZC2010 ZC2 (nolock)
        on ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_FILIAL = ZC1.ZC1_FILIAL
        and ZC2.ZC2_NUM = ZC1.ZC1_NUM
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = ZC2.ZC2_COD
    
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
where
        ZC2.D_E_L_E_T_ = ''
    /*and ZC2.ZC2_NUM = :NUMERO_OS*/
