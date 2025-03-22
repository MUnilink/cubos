select
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE3.ZE3_ORIGEM) as CC,
    (
        select min('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|'))
        from SC6010
            inner join CTD010
                on CTD010.CTD_FILIAL = ''
                and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                and CTD010.D_E_L_E_T_ = ''

                inner join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
        where
                SC6010.D_E_L_E_T_ = ''
            and concat(SC6010.C6_FILIAL, SC6010.C6_YOS) = ZE3.ZE3_NUM
            and left(SD2010.D2_EMISSAO, 6) = ZE3.ZE3_COMPET
    ) as ATIVIDADE,
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    ZE3.ZE3_COMPET as PERIODO,
    ZE3.ZE3_NUM,
    trim(ZE2.ZE2_CONTA) as CONTA,
    left(ZE3.ZE3_NUM, 6) as FILORI,
    right(trim(ZE3.ZE3_NUM), 11) as NUM_OS,
    
    case
        when len(trim(ZE2.ZE2_COD)) = 8 then left(trim(ZE2.ZE2_COD), 5)
        when len(trim(ZE2.ZE2_COD)) = 5 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP,
    
    ZE3.ZE3_VALOR as VL_ORIGINAL,
    case
        when ZE2.ZE2_ORIGEM = 'F' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '11' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 2) like '[0-9][2-9]' then ZE3.ZE3_VALOR*-1
    else 0.0 end as VALOR

from ZE3010 ZE3 (nolock)
    inner join ZE2010 ZE2 (nolock)
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
where
        ZE3.D_E_L_E_T_ = ''
    and ZE3.ZE3_COMPET=:COMPETENCIA