select
    G1.ZG1_FILORI,
    G1.ZG1_COMPET,
    G1.ZG1_CODIGO,
    G1.ZG1_TIPO,
    G1.ZG1_CC,
    G1.ZG1_ITEMCT,
    G1.ZG1_VLTOTL,
    G1.ZG1_VLPROD,
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
    ) as RAT_IMP,

    case when G1.ZG1_TIPO in ('2', '14') and G1.ZG1_CC = '305' and G1.ZG1_ITEMCT != '32' /* ATIVIDADES NÃO CFS DA OPP SEM FOLHA */
        then G1.ZG1_VLTOTL - 
        (
            select isnull(sum(ZC2010.ZC2_TOTAL), 0.0) /* VALOR PROD DAS ATIVIDADES*/
            from ZC2010
                inner join ZC1010
                    on ZC1010.D_E_L_E_T_ = ''
                    and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
                    and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
            where
                    ZC2010.D_E_L_E_T_ = ''
                and ZC1010.ZC1_CC = G1.ZG1_CC
                and left(ZC2010.ZC2_COMPET, 6) = G1.ZG1_COMPET
                and ZC2010.ZC2_COD = G1.ZG1_CODIGO
                and ZC2010.ZC2_TIPO = G1.ZG1_TIPO
        )
        else 0.0
    end as VL_IMPRRAT

from ZG1010 G1 (nolock)
where
        G1.D_E_L_E_T_ = ''
    and G1.ZG1_TIPO = '2'
    and G1.ZG1_COMPET = '202501'
    and G1.ZG1_CODIGO = '00005'
