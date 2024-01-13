select ZG1.*
from ZC2010 ZC2 (nolock)
    inner join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_COD = ZC2.ZC2_COD
        and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
    
    /*left join SRD010 SRD (nolock)*/
    left join
    (   
        select
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
    
    left join
    (
        select
            SN1010.N1_CODBEM,
            SN4010.N4_VLROC1,
            convert(datetime, concat(SN4.N4_DATA, ' ', SN4.N4_HORA), 113) as DATA_MOV,
            substring(SN4010.N4_DATA, 1, 6) as PERIODO,
            trim(SN1010.N1_CBASE) as ATIVO,
            trim(SN1010.N1_DESCRIC) as DESC_ATIVO,
            trim(ST9010.T9_CODBEM) as T9_CODBEM
        from SN4010 (nolock)            
            inner join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and SN3010.N3_CBASE = SN4010.N4_CBASE
                and SN3010.N3_ITEM = SN4010.N4_ITEM

                inner join SN1010 (nolock)
                    on SN1010.D_E_L_E_T_ = ''
                    and SN1010.N1_CBASE = SN3010.N3_CBASE
                    and SN1010.N1_ITEM = SN3010.N3_ITEM

                    left join ST9010 (nolock)
                        on ST9010.D_E_L_E_T_ = ''
                        and ST9010.T9_CODBEM = SN1010.N1_CODBEM
        where
                SN4.D_E_L_E_T_ = ''
            and SN4.N4_OCORR = 6
    ) DEP
        on ZC2.ZC2_TIPO = 6
    /*left join CT2010 CT2 (nolock) and ZC2.ZC2_TIPO = 7*/
where
            ZC2.D_E_L_E_T_ = ''
