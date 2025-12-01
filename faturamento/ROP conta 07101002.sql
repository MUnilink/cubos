select
    RATEIO_PESSOAL.FILIAL,
    RATEIO_PESSOAL.NUM,
    RATEIO_PESSOAL.CC,
    RATEIO_PESSOAL.ITEM,
    sum(RATEIO_PESSOAL.VALOR_IMPROS) as TOTAL
from
(
    select
        ZC2.ZC2_FILIAL as FILIAL,
        ZC2.ZC2_NUM as NUM,
        ZC2.ZC2_CC as CC,
        ZC2.ZC2_ATIVD as ITEM,
        
        case
            when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD = '32' and ZC2.ZC2_TIPO = '15' then sum(ZC2.ZC2_TOTAL * ZG1.RAT_IMP)
            when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD != '32' and ZC2.ZC2_TIPO != '15' then sum(ZG1.VALOR_IMPRAT) * avg(ZC2.VL_RECEITA) /
                coalesce
                (
                    (
                        select sum(ZC2010.ZC2_TOTAL)
                        from ZC2010
                            inner join ZC1010
                                on ZC1010.D_E_L_E_T_ = ''
                                and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
                                and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
                        where
                                ZC2010.D_E_L_E_T_ = ''
                            and ZC2010.ZC2_TIPO = '1'
                            and ZC2010.ZC2_FILIAL = ZC2.ZC2_FILIAL
                            and ZC1010.ZC1_CC = ZC2.ZC2_CC
                            and ZC1010.ZC1_ATIVD = ZC2.ZC2_ATIVD
                            and left(ZC2010.ZC2_COMPET, 6) = ZC2.ZC2_COMPET
                    ), 999999999
                )
            else 0.0
        end as VALOR_IMPROS
    from
    (
        select
            Z1.ZC1_FILIAL as ZC2_FILIAL,
            Z1.ZC1_CC as ZC2_CC,
            Z1.ZC1_ATIVD as ZC2_ATIVD,
            left(Z2.ZC2_COMPET, 6) as ZC2_COMPET,
            Z2.ZC2_NUM,
            Z2.ZC2_COD,
            Z2.ZC2_TIPO,
            sum(Z2.ZC2_TOTAL) as ZC2_TOTAL,
            row_number() over(partition by Z2.ZC2_COMPET, Z2.ZC2_NUM, Z2.ZC2_TIPO, Z1.ZC1_FILIAL, Z1.ZC1_CC, Z1.ZC1_ATIVD, Z2.ZC2_FILIAL order by Z2.ZC2_COD) as qtd,
            (select sum(ZC2010.ZC2_TOTAL) from ZC2010 where ZC2010.D_E_L_E_T_ = '' and ZC2010.ZC2_TIPO = '1' and ZC2010.ZC2_FILIAL = Z2.ZC2_FILIAL and ZC2010.ZC2_NUM = Z2.ZC2_NUM and left(ZC2010.ZC2_COMPET, 6) = left(Z2.ZC2_COMPET, 6)) as VL_RECEITA

        from ZC2010 Z2
            inner join ZC1010 Z1
                on Z1.D_E_L_E_T_ = ''
                and Z1.ZC1_FILIAL = Z2.ZC2_FILIAL
                and Z1.ZC1_NUM = Z2.ZC2_NUM
        where Z2.D_E_L_E_T_ = '' and Z2.ZC2_TIPO in ('14', '15')
        group by Z2.ZC2_COMPET, Z2.ZC2_NUM, Z2.ZC2_TIPO, Z2.ZC2_COD, Z1.ZC1_FILIAL, Z1.ZC1_CC, Z1.ZC1_ATIVD, Z2.ZC2_FILIAL
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
                G1.ZG1_VLIMPR as VALOR_IMPRAT,
                
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
                and G1.ZG1_TIPO in ('14')
                and exists (select 1 from SRD010 where SRD010.D_E_L_E_T_ = '' and left(SRD010.RD_DATARQ, 6) = left(G1.ZG1_COMPET, 6) and SRD010.RD_CC = G1.ZG1_CC and SRD010.RD_ITEM = G1.ZG1_ITEMCT)
        ) ZG1
            on left(ZC2.ZC2_FILIAL, 4) = ZG1.ZG1_FILORI
            and ZC2.ZC2_COMPET = ZG1.ZG1_COMPET
            and ZC2.ZC2_COD = ZG1.ZG1_CODIGO
            and ZC2.ZC2_CC = ZG1.ZG1_CC
            and case when ZC2.ZC2_CC = '305' and ZC2.ZC2_ATIVD != '32' then '21' else ZC2.ZC2_ATIVD end = ZG1.ZG1_ITEMCT
    where ZC2.ZC2_COMPET = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZC2.ZC2_FILIAL, ZC2.ZC2_CC, ZC2.ZC2_ATIVD, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_TIPO
    ) RATEIO_PESSOAL
    group by RATEIO_PESSOAL.FILIAL, RATEIO_PESSOAL.NUM, RATEIO_PESSOAL.CC, RATEIO_PESSOAL.ITEM
union
    select
        ZE1.ZE1_FILIAL as FILIAL,
        ZE1.ZE1_NUM as NUM,
        ZG1.ZG1_CC as CC,
        ZG1.ZG1_ITEMCT as ITEM,
        sum(ZE1.ZE1_TOTAL * ZG1.VL_RIMP) as TOTAL
    from ZE1010 ZE1
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
                and G1.ZG1_TIPO = '2'
                and G1.ZG1_FILORI = '0101'
                and G1.ZG1_CC = '304'
                and G1.ZG1_ITEMCT = '11'
        ) ZG1
            on left(ZE1.ZE1_COMPET, 6) = ZG1.ZG1_COMPET
            and left(ZE1.ZE1_FILIAL, 4) = ZG1.ZG1_FILORI
            and ZE1.ZE1_COD = ZG1.ZG1_CODIGO
    where
            ZE1.D_E_L_E_T_ = ''
        and ZE1.ZE1_TIPO = '15'
        and left(ZE1.ZE1_COMPET, 6) = '"+cCompt+"' and ZE1.ZE1_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZE1.ZE1_FILIAL, ZE1.ZE1_NUM, ZG1.ZG1_CC, ZG1.ZG1_ITEMCT
