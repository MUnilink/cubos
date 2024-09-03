select
    ZC7.ZC7_CODIGO as ENTIDADE,
    ZC7.ZC7_CC as CC,
    ZC7.ZC7_COMPET as COMPETENCIA,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'SQ3') else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'ST9') else null end as COD_SRJ,
    cast(ZC7.ZC7_HRPAD as numeric(15, 2)) as HORA_PAD,
    cast(ZC7.ZC7_HRPROD as numeric(15, 2)) as HORA_PROD,
    cast(ZC7.ZC7_HRIMPR as numeric(15, 2)) as HORA_IMPR,
    cast(ZC7.ZC7_CUSTO as numeric(15, 2)) as CUSTO_TOTAL,
    ZC2.TIPO,
    ZC2.QTD_REAL_ITEM,
    ZC2.VAL_REAL_ITEM,
    ZC2.QTD_RECURSO,
    ZC2.VALOR_TOTAL,

    case ZC2.TIPO
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'OUTROS CUSTOS - TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        else 'OUTROS'
    end as TIPO_INSUMO

from ZC7010 ZC7
    left join
    (
        select
            sum(ZC2010.ZC2_QTDREA) as QTD_REAL_ITEM,
            sum(ZC2010.ZC2_VLUREA) as VAL_REAL_ITEM,
            sum(ZC2010.ZC2_QTDREC) as QTD_RECURSO,
            sum(ZC2010.ZC2_TOTAL) as VALOR_TOTAL,

            substring(ZC2010.ZC2_COMPET, 1, 6) as PERIODO,
            ZC2010.ZC2_COD as ENTIDADE,
            cast(ZC2010.ZC2_TIPO as int) as TIPO
        from ZC2010
        where 
                ZC2010.ZC2_COMPET > '20231231'
            and cast(ZC2010.ZC2_TIPO as int) != 1
            and ZC2010.D_E_L_E_T_ = ''
        group by ZC2010.ZC2_COD, ZC2010.ZC2_TIPO, ZC2010.ZC2_COMPET
    ) ZC2
    on ZC2.PERIODO = ZC7.ZC7_COMPET
    and ZC2.ENTIDADE = ZC7.ZC7_CODIGO
where
        concat(ZC7.ZC7_COMPET, '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC7.D_E_L_E_T_ = ''
