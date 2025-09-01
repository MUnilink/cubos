select
    ZG1.ZG1_FILORI as FILIAL,
    ZG1.ZG1_COMPET as PERIODO,
    ZG1.ZG1_TABELA as TABELA,
    trim(ZG1.ZG1_CODIGO) as RECURSO,
    
    case ZG1.ZG1_TABELA
        when 'ST9' then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (3, 6, 9, 12))
        when 'SQ3' then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (2, 14))
    else null end as DESC_RECURSO,

    case cast(ZG1.ZG1_TIPO as int)
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO EQUIPAMENTO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        else 'OUTROS'
    end as TIPO_INSUMO,

    case
        when ZG1.ZG1_FILORI = '010101' and trim(ZG1.ZG1_CC) = '304' then 'TMS'
        when ZG1.ZG1_FILORI = '010101' and trim(ZG1.ZG1_CC) = '305' then 'OPP MATRIZ'
        when ZG1.ZG1_FILORI = '010102' and trim(ZG1.ZG1_CC) = '304' then 'TMS PECEM'
        when ZG1.ZG1_FILORI = '010102' and trim(ZG1.ZG1_CC) = '305' then 'OPP'
    else 'OUTROS' end as TIPO_RODA,
    
    ZG1.ZG1_TIPO as TIPO,
    ZG1.ZG1_VLTOTL as VL_TOTAL,
    ZG1.ZG1_VLHORA as VL_HORA,
    ZG1.ZG1_VLIMPR as VL_IMP,
    ZG1.ZG1_VLPROD as VL_PRO,

    ZG1.ZG1_HRPAD as HORA_PAD,
    ZG1.ZG1_HRPRO as HORA_PRO,
    ZG1.ZG1_HRIMPR as HORA_IMP,
    ZG1.ZG1_IMPR1 as HIMP_AFAMNT,
    ZG1.ZG1_IMPR2 as HIMP_FER,
    ZG1.ZG1_IMPR3 as HIMP_PON,

    ZG1.ZG1_VLIMPR/
    (
        select sum(ZG1010.ZG1_VLIMPR)
        from ZG1010
        where
            ZG1010.D_E_L_E_T_ = ''
        and ZG1010.ZG1_VLIMPR != 0
        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
    ) as VL_RIMP

from ZG1010 ZG1 (nolock)
where ZG1.D_E_L_E_T_ = ''
