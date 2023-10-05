    select
        ZC2.ZC2_NUM + '-' + ZC2.ZC2_ITEM as OS_ITEM,
        case SRJ.RJ_FUNCAO
            when 726 then (
                select
                    RJ_DESC
                from SRJ010 (nolock)
                where RJ_FUNCAO = 725
            )
            when 511 then (
                select
                    RJ_DESC
                from SRJ010 (nolock)
                where RJ_FUNCAO = 749
            )
            when 334 then (
                select
                    RJ_DESC
                from SRJ010 (nolock)
                where RJ_FUNCAO = 725
            )
            when 066 then (
                select
                    RJ_DESC
                from SRJ010 (nolock)
                where RJ_FUNCAO = 556
            )
            else SRJ.RJ_DESC 
        end as RH,
        convert(date, ZC2.ZC2_COMPET) as PERIODO,
        ZC2.ZC2_CHVOS,
        case SRJ.RJ_FUNCAO 
            when 726 then 725
            when 511 then 749
            when 334 then 725
            when 066 then 556
            else SRJ.RJ_FUNCAO
        end as VERBA,
        case SRJ.RJ_FUNCAO
            when 726 then (
                select
                    SUM(ZC2.ZC2_TOTAL)
                from SRJ010 (nolock)
                    inner join ZC2010 ZC2 (nolock)
                        on ZC2.D_E_L_E_T_ = ''
                        and ZC2.ZC2_COD = SRJ010.RJ_FUNCAO
                where SRJ010.RJ_FUNCAO = 725
            )
            when 511 then (
                select
                    SUM(ZC2.ZC2_TOTAL)
                from SRJ010 (nolock)
                    inner join ZC2010 ZC2 (nolock)
                        on ZC2.D_E_L_E_T_ = ''
                        and ZC2.ZC2_COD = SRJ010.RJ_FUNCAO
                where SRJ010.RJ_FUNCAO = 725
            )
            when 334 then (
                select
                    SUM(ZC2.ZC2_TOTAL)
                from SRJ010 (nolock)
                    inner join ZC2010 ZC2 (nolock)
                        on ZC2.D_E_L_E_T_ = ''
                        and ZC2.ZC2_COD = SRJ010.RJ_FUNCAO
                where SRJ010.RJ_FUNCAO = 725
            )
            when 066 then (
                select
                    SUM(ZC2.ZC2_TOTAL)
                from SRJ010 (nolock)
                    inner join ZC2010 ZC2 (nolock)
                        on ZC2.D_E_L_E_T_ = ''
                        and ZC2.ZC2_COD = SRJ010.RJ_FUNCAO
                where SRJ010.RJ_FUNCAO = 725
            )
            else ZC2.ZC2_TOTAL
        end as TOTAL_OS,
        0 TOTAL_FOLHA,
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
        SRV.RV_DESC as RH,
        convert(date, SRD.RD_DATARQ+'01'),
        SRD.RD_YCHVOS as ZC2_CHVOS,
        SRD.RD_PD as VERBA,
        0 TOTAL_OS,
        SRD.RD_VALOR as TOTAL_FOLHA,
        SRD.R_E_C_N_O_
    from SRD010 SRD (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRD.RD_PD = SRV.RV_COD
    where
            SRD.RD_YCHVOS != ''
        and SRD.D_E_L_E_T_ = ''
