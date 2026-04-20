declare @PERIODO as varchar(6);
set @PERIODO =:COMPETENCIA

    select
        ZC2.ZC2_FILIAL as FILIAL,
        ZC2.ZC2_NUM as NUM,
        ZC2.ZC2_CC as CC,
        ZC2.ZC2_ATIVD as ITEM,
        ZC2.ZC2_TIPO as TIPO_ZCE,
        ZC2.ZC2_COD as CODIGO,
        ZG1.*,
        ZC2.ZC2_TOTAL as TOTAL_OSVGA,
        ZC2.ZC2_TOTAL * ZG1.VL_RIMP as TOTAL_RAT
    from
    (
        select
            ZC1010.ZC1_FILIAL as ZC2_FILIAL,
            ZC1010.ZC1_CC as ZC2_CC,
            ZC1010.ZC1_ATIVD as ZC2_ATIVD,
            ZC2010.ZC2_NUM,
            left(ZC2010.ZC2_COMPET, 6) as ZC2_COMPET,
            ZC2010.ZC2_COD,
            ZC2010.ZC2_TIPO,
            ZC2010.ZC2_TOTAL
        from ZC2010
            inner join ZC1010
                on ZC1010.D_E_L_E_T_ = ''
                and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
                and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
        where ZC2010.D_E_L_E_T_ = ''
    ) ZC2
        inner join
        (
            select
                G1.ZG1_FILORI,
                G1.ZG1_COMPET,
                G1.ZG1_CODIGO,
                G1.ZG1_TIPO,
                G1.ZG1_CC,
                G1.ZG1_ITEMCT,
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
                    and ZG1010.ZG1_ITEMCT = G1.ZG1_ITEMCT
                ) as VL_RIMP
            from ZG1010 G1 (nolock)
            where G1.D_E_L_E_T_ = ''
        ) ZG1
            on left(ZC2.ZC2_FILIAL, 4) = ZG1.ZG1_FILORI
            and ZC2.ZC2_COMPET = ZG1.ZG1_COMPET
            and ZC2.ZC2_COD = ZG1.ZG1_CODIGO
            and ZC2.ZC2_CC = ZG1.ZG1_CC
            and ZC2.ZC2_ATIVD = ZG1.ZG1_ITEMCT
    where
            case when ZG1.ZG1_TIPO in (2, 14) then 15 when ZG1.ZG1_TIPO in (3, 6, 9, 12) then 16 else null end = ZC2.ZC2_TIPO
        and left(ZC2.ZC2_COMPET, 6) = @PERIODO
union
    select
        ZE1.ZE1_FILIAL as FILIAL,
        ZE1.ZE1_NUM as NUM,
        ZG1.ZG1_CC as CC,
        ZG1.ZG1_ITEMCT as ITEM,
        ZE1.ZE1_TIPO as TIPO_ZCE,
        ZE1.ZE1_COD as CODIGO,
        ZG1.*,
        ZE1.ZE1_TOTAL as TOTAL_OSVGA,
        ZE1.ZE1_TOTAL * ZG1.VL_RIMP as TOTAL_RAT
    from ZE1010 ZE1 (nolock)
        inner join
        (
            select
                G1.ZG1_FILORI,
                G1.ZG1_COMPET,
                G1.ZG1_CODIGO,
                G1.ZG1_TIPO,
                G1.ZG1_CC,
                G1.ZG1_ITEMCT,
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
                    and ZG1010.ZG1_ITEMCT = G1.ZG1_ITEMCT
                ) as VL_RIMP
            from ZG1010 G1 (nolock)
            where
                    G1.D_E_L_E_T_ = ''
                and G1.ZG1_FILORI = '0101'
                and G1.ZG1_CC = '304'
                and G1.ZG1_ITEMCT = '11'
        ) ZG1
            on left(ZE1.ZE1_COMPET, 6) = ZG1.ZG1_COMPET
            and left(ZE1.ZE1_FILIAL, 4) = ZG1.ZG1_FILORI
            and ZE1.ZE1_COD = ZG1.ZG1_CODIGO
    where
            ZE1.D_E_L_E_T_ = ''
        and case when ZG1.ZG1_TIPO in (2, 14) then 15 when ZG1.ZG1_TIPO in (3, 6, 9, 12) then 16 else null end = ZE1.ZE1_TIPO
        and left(ZE1.ZE1_COMPET, 6) = @PERIODO
