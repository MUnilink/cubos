select
    ZC2.ZC2_FILIAL as FILIAL,
    ZC2.ZC2_CC as CC,
    ZC2.ZC2_ATIVD as ITEM,
    ZC2.ZC2_TIPO as TIPO,
    ZC2.ZC2_COD as COD,
    ZC2.ZC2_NUM as NUM,

    sum(ZG1.ZG1_VLTOTL) as VLTOTL,
    sum(ZG1.ZG1_VLPROD) as VLPROD,
    sum(ZG1.ZG1_VLIMPR) as VLIMPR,
    sum(ZC2.ZC2_TOTAL) as VALOR_OS,
    avg(ZC2.VL_RECEITA) as VALOR_REC,
    
    case
        when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD = '32' and ZC2.ZC2_TIPO = '15' then sum(ZC2.ZC2_TOTAL * ZG1.RAT_IMP)
        when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD != '32' and ZC2.ZC2_TIPO != '15' then sum(ZG1.VL_IMPRRAT) * avg(ZC2.VL_RECEITA) / isnull((select sum(ZC2010.ZC2_TOTAL) from ZC2010 where ZC2010.D_E_L_E_T_ = '' and ZC2010.ZC2_TIPO = '1' and ZC2010.ZC2_FILIAL = ZC2.ZC2_FILIAL and left(ZC2010.ZC2_COMPET, 6) = ZC2.ZC2_COMPET), 999999999)
        else 0.0
    end as VALOR_IMPR,
    
    case
        when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD = '32' and ZC2.ZC2_TIPO = '15' then sum(ZC2.ZC2_TOTAL * ZG1.RAT_IMP)
        when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD != '32' and ZC2.ZC2_TIPO != '15' then sum(ZG1.VL_IMPRRAT)
        else 0.0
    end as TOTAL
from
(
    select
        ZC1010.ZC1_FILIAL as ZC2_FILIAL,
        ZC1010.ZC1_CC as ZC2_CC,
        ZC1010.ZC1_ATIVD as ZC2_ATIVD,
        left(Z2.ZC2_COMPET, 6) as ZC2_COMPET,
        Z2.ZC2_NUM,
        Z2.ZC2_COD,
        Z2.ZC2_TIPO,
        Z2.ZC2_TOTAL,
        (select sum(ZC2010.ZC2_TOTAL) from ZC2010 where ZC2010.D_E_L_E_T_ = '' and ZC2010.ZC2_TIPO = '1' and ZC2010.ZC2_FILIAL = Z2.ZC2_FILIAL and ZC2010.ZC2_NUM = Z2.ZC2_NUM and left(ZC2010.ZC2_COMPET, 6) = left(Z2.ZC2_COMPET, 6)) as VL_RECEITA

    from ZC2010 Z2
        inner join ZC1010
            on ZC1010.D_E_L_E_T_ = ''
            and ZC1010.ZC1_FILIAL = Z2.ZC2_FILIAL
            and ZC1010.ZC1_NUM = Z2.ZC2_NUM
    where Z2.D_E_L_E_T_ = '' and Z2.ZC2_TIPO in ('2', '14', '15')
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
            and G1.ZG1_TIPO in ('2', '14')
    ) ZG1
        on left(ZC2.ZC2_FILIAL, 4) = ZG1.ZG1_FILORI
        and ZC2.ZC2_COMPET = ZG1.ZG1_COMPET
        and ZC2.ZC2_COD = ZG1.ZG1_CODIGO
        and ZC2.ZC2_CC = ZG1.ZG1_CC
        and case when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD != '32' then '21' else ZC2.ZC2_ATIVD end = ZG1.ZG1_ITEMCT
where ZC2.ZC2_COMPET = '202503' and ZC2.ZC2_COD = '00005'
group by ZG1.ZG1_FILORI, ZC2.ZC2_COMPET, ZC2.ZC2_FILIAL, ZC2.ZC2_NUM, ZC2.ZC2_CC, ZC2.ZC2_ATIVD, ZC2.ZC2_TIPO, ZC2.ZC2_COD
