    select
        ZC2.ZC2_NUM + '-' + ZC2.ZC2_ITEM as OS_ITEM,
        convert(date, ZC2.ZC2_COMPET) as PERIODO,
        ZC2.ZC2_CHVOS,
        
        case SRJ.RJ_FUNCAO
            when '726' then '725'
            when '511' then '749'
            when '334' then '725'
            when '066' then '556'
            else SRJ.RJ_FUNCAO
        end as FUNCAO,

        ZC2.ZC2_COD as CODIGO,
        
        ZC2.ZC2_TOTAL as TOTAL_OS,
        0 as TOTAL_FOLHA,
        ZC2.R_E_C_N_O_
    from ZC2010 ZC2 (nolock)
        inner join SRJ010 SRJ (nolock)
            on ZC2.D_E_L_E_T_=''
            and ZC2.ZC2_COD = SRJ.RJ_FUNCAO
        where 
                ZC2.ZC2_COMPET != ''
            and ZC2.ZC2_TIPO = 2
            and ZC2.ZC2_INCLUS = 'M'

union

    select
        'FOLHA',
        convert(date, SRD.RD_DATARQ+'01'),
        SRD.RD_YCHVOS as ZC2_CHVOS,
        SRV.RV_DESC as FUNCAO,
        SRD.RD_PD as CODIGO,
        0 as TOTAL_OS,
        SRD.RD_VALOR as TOTAL_FOLHA,
        SRD.R_E_C_N_O_
    from SRD010 SRD (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRD.RD_PD = SRV.RV_COD
    where
            SRD.RD_YCHVOS != ''
        and SRD.D_E_L_E_T_ = ''
