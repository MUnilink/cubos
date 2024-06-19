select
    ZC7.ZC7_CODIGO as RECURSO,
    ZC7.ZC7_ORIGEM as TABELA,
    ZC7.ZC7_CC as CC,
    ZC7.ZC7_COMPET as PERIODO,
    
    case when lag(ZC7.ZC7_HRPAD, 1, 0) over(partition by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO order by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO) = 0 then cast(ZC7.ZC7_HRPAD as numeric(15, 2)) else 0 end as HORA_PADRAO,
    case when lag(ZC7.ZC7_HRPROD, 1, 0) over(partition by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO order by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO) = 0 then cast(ZC7.ZC7_HRPROD as numeric(15, 2)) else 0 end as HORA_PRODU,
    case when lag(ZC7.ZC7_HRIMPR, 1, 0) over(partition by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO order by ZC7.ZC7_FILIAL, ZC7.ZC7_COMPET, ZC7.ZC7_CC, ZC7.ZC7_CODIGO) = 0 then cast(ZC7.ZC7_HRIMPR as numeric(15, 2)) else 0 end as HORA_IMPRO,

    ZC1.ZC1_FILIAL as FILIAL,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    
    ZC2.ZC2_COMPET,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 5 then 'CORTESIA'
        when 6 then 'ENCERRADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'TAXAS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO,

    case ZC7.ZC7_ORIGEM
        when 'SQ3' then 'PESSOAL'
        when 'ST9' then 'MANUTENÇÃO'
    else 'OUTROS' end as TIPO,
    
    trim(ZC2.ZC2_COD) as INSUMO,
    ZC2.ZC2_ITEM as ITEM,

    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,

    ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as TOT_ITEMPRE,
    ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as TOT_ITEMREA,

    case cast(ZC2.ZC2_TIPO as int)
        when 1 then (select max(case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end) from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 1)
        when 5 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 5)
        when 11 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 11)
        when 2 then (select max(trim(SRJ010.RJ_DESC)) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 2)
        when 3 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 3)
        when 4 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 4)
        when 6 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 6)
        when 7 then (select max(trim(ZA7010.ZA7_DESC)) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
        when 9 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 9)
        when 10 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 10)
        when 12 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 12)
        when 13 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 13)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,

    case when ZC2.ZC2_QTDREC > 9999999 then 9999999 else ZC2.ZC2_QTDREC end as QTD_RECURSO,
    
    case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_APONT,
	case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_TOTAIS

from ZC7010 ZC7 (nolock)
    left join ZC2010 ZC2 (nolock)
        on ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COD = ZC7.ZC7_CODIGO
        and substring(ZC2.ZC2_COMPET, 1, 6) = ZC7.ZC7_COMPET
        and ZC2.ZC2_TIPO in (2, 3)

        left join ZC1010 ZC1 (nolock)
            on ZC1.D_E_L_E_T_ = ''
            and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
            and ZC1.ZC1_NUM = ZC2.ZC2_NUM
where
        ZC7.D_E_L_E_T_ = ''
