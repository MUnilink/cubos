select *
from ZG1010 ZG1 (nolock)
    inner join ZC2010 ZC2 (nolock)
        on ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COD = ZG1.ZG1_COD
        and ZC2.ZC2_FILIAL = ZG1.ZG1_FILORI
    
        /*left join SRD010 SRD (nolock)*/
        left join
        (   select
                STJ010.TJ_FILIAL,
                STJ010.TJ_ORDEM,
                STJ010.TJ_CODBEM,
                STL010.TL_CODIGO,
                STL010.TL_SEQRELA,
                STL010.TL_CUSTO,
                STL010.TL_INI
            from STJ010 (nolock)
                left join STL010 (nolock)
                    on STL010.D_E_L_E_T_ = ''
                    and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                    and STL010.TL_PLANO = STJ010.TJ_PLANO
                    and STL010.TL_ORDEM = STJ010.TJ_ORDEM
            where STJ010.D_E_L_E_T_ = ''
        ) MNT
            on ZC2.ZC2_TIPO = 3
            and MNT.TJ_CODBEM = ZC2.ZC2_COD
            and MNT.TL_INI = ZC2.ZC2_COMPET
        
        left join SD3010 SD3 (nolock)
            on SD3.D_E_L_E_T_ = ''
            and SD3.D3_FILIAL = ZC2.ZC2_FILIAL
            and SD3.D3_YOS = ZC2.ZC2_NUM
            and ZC2.ZC2_TIPO = 4
        left join SN4010 SN4 (nolock)
        left join CT2010 CT2 (nolock)
where
            ZG1.D_E_L_E_T_ = ''
