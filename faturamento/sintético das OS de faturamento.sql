select
    ZG1.ZG1_FILORI as FILIAL,
    ZG1.ZG1_COMPET as PERIODO,
    trim(ZG1.ZG1_CODIGO) as RECURSO,
    
    case ZG1.ZG1_TABELA
        when 'ST9' then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (3, 6, 9, 12))
        when 'SQ3' then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (2, 14))
    else null end as DESC_RECURSO,
    
    ZG1.ZG1_TIPO as TIPO,
    ZG1.ZG1_HRPAD as HORA_PAD,
    ZG1.ZG1_HRPRO as HORA_PRO,
    ZG1.ZG1_HRIMPR as HORA_IMP,
    ZG1.ZG1_VLTOTL as VL_TOTAL,
    ZG1.ZG1_VLHORA as VL_HORA,
    ZG1.ZG1_VLIMPR as VL_IMP,
    ZG1.ZG1_VLPROD as VL_PRO,
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
