    select
        ZG1.ZG1_FILORI as FILIAL,
        ZC2.ZC2_NUM as NUM,
        trim(ZG1.ZG1_CC) as CC,
        sum(ZC2.ZC2_TOTAL * ZG1.VL_RIMP) as TOTAL
    from ZC2010 ZC2 (nolock)
        inner join
        (
            select
                G1.ZG1_FILORI,
                G1.ZG1_COMPET,
                G1.ZG1_CODIGO,
                G1.ZG1_TIPO,
                G1.ZG1_CC,
                G1.ZG1_VLIMPR,
                G1.ZG1_VLIMPR/
                (
                    select sum(ZG1010.ZG1_VLIMPR)
                    from ZG1010
                    where
                        ZG1010.D_E_L_E_T_ = ''
                    and ZG1010.ZG1_VLIMPR != 0
                    and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                    and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                    and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
                    and ZG1010.ZG1_CC = G1.ZG1_CC
                ) as VL_RIMP
            from ZG1010 G1 (nolock)
            where
                    G1.D_E_L_E_T_ = ''
                and G1.ZG1_TIPO = '9'
        ) ZG1
            on left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
            and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
    where
            ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_TIPO = '16'
        and left(ZC2.ZC2_COMPET, 6) = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZG1.ZG1_FILORI, ZC2.ZC2_NUM, ZG1.ZG1_CC
union
    select
        ZG1.ZG1_FILORI as FILIAL,
        ZE1.ZE1_NUM as NUM,
        '304' as CC,
        sum(ZE1.ZE1_TOTAL * ZG1.VL_RIMP) as TOTAL
    from ZE1010 ZE1 (nolock)
        inner join
        (
            select
                G1.ZG1_FILORI,
                G1.ZG1_COMPET,
                G1.ZG1_CODIGO,
                G1.ZG1_TIPO,
                G1.ZG1_CC,
                G1.ZG1_VLIMPR,
                G1.ZG1_VLIMPR/
                (
                    select sum(ZG1010.ZG1_VLIMPR)
                    from ZG1010
                    where
                        ZG1010.D_E_L_E_T_ = ''
                    and ZG1010.ZG1_VLIMPR != 0
                    and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                    and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                    and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
                    and ZG1010.ZG1_CC = G1.ZG1_CC
                ) as VL_RIMP
            from ZG1010 G1 (nolock)
            where
                    G1.D_E_L_E_T_ = ''
                and G1.ZG1_CC = '304'
                and G1.ZG1_TIPO = '9'
        ) ZG1
            on left(ZE1.ZE1_COMPET, 6) = ZG1.ZG1_COMPET
            and ZE1.ZE1_COD = trim(ZG1.ZG1_CODIGO)
    where
            ZE1.D_E_L_E_T_ = ''
        and ZE1.ZE1_TIPO = '16'
        and left(ZE1.ZE1_COMPET, 6) = '"+cCompt+"' and ZE1.ZE1_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZG1.ZG1_FILORI, ZE1.ZE1_NUM
