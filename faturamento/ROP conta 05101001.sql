    select
        ZC2.ZC2_FILIAL as FILIAL,
        ZC2.ZC2_NUM as NUM,
        ZC1.ZC1_CC as CC,
        ZC1.ZC1_ATIVD as ITEM,
        sum(cast(coalesce(ZC2.ZC2_TOTAL, 0) as decimal (14, 2))) as TOTAL
    from ZC2010 ZC2
        left join ZC1010 ZC1
            on ZC1.D_E_L_E_T_ = ''
            and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
            and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    where
            ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_TIPO = 2
        and left(ZC2.ZC2_COMPET, 6) = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZC2.ZC2_FILIAL, ZC2.ZC2_NUM, ZC1.ZC1_CC, ZC1.ZC1_ATIVD
union
    select
        ZE1.ZE1_FILIAL as FILIAL,
        ZE1.ZE1_NUM as NUM,
        coalesce
        (
            (
                select distinct coalesce(SD2.D2_CCUSTO, COMP.D2_CCUSTO)
                from DUD010
                    left join DT6010
                        on DT6010.D_E_L_E_T_ = ''
                        and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                        and DT6010.DT6_DOC = DUD010.DUD_DOC
                        and DT6010.DT6_SERIE = DUD010.DUD_SERIE

                        left join SD2010 SD2
                            on SD2.D_E_L_E_T_ = ''
                            and SD2.D2_DOC = DT6010.DT6_DOC
                            and SD2.D2_SERIE = DT6010.DT6_SERIE
                            and SD2.D2_CLIENTE = DT6010.DT6_CLIDEV
                            and SD2.D2_LOJA = DT6010.DT6_LOJDEV
                            
                            left join SD2010 COMP
                                on COMP.D_E_L_E_T_ = ''
                                and COMP.D2_DOC = SD2.D2_NFORI
                                and COMP.D2_SERIE = SD2.D2_SERIORI
                                and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                                and COMP.D2_LOJA = SD2.D2_LOJA
                where
                        DUD010.D_E_L_E_T_ = ''
                    and DUD010.DUD_FILIAL = left(ZE1.ZE1_FILIAL, 4)
                    and DUD010.DUD_FILORI = ZE1.ZE1_FILIAL
                    and DUD010.DUD_VIAGEM = ZE1.ZE1_NUM
                    and DUD010.DUD_SERIE != 'COL'
            ),
            (
                select distinct RPS.D2_CCUSTO
                from SC5010
                    left join SD2010 RPS
                        on RPS.D_E_L_E_T_ = ''
                        and RPS.D2_FILIAL = SC5010.C5_FILIAL
                        and RPS.D2_DOC = SC5010.C5_NOTA
                        and RPS.D2_SERIE = SC5010.C5_SERIE
                        and RPS.D2_CLIENTE = SC5010.C5_CLIENTE
                        and RPS.D2_LOJA = SC5010.C5_LOJACLI
                where
                        SC5010.D_E_L_E_T_ = ''
                    and SC5010.C5_FILIAL = ZE1.ZE1_FILIAL
                    and trim(SC5010.C5_YVIAGEM) = ZE1.ZE1_NUM
            )
        ) as CC,
        coalesce
        (
            (
                select distinct coalesce(SD2.D2_ITEMCC, COMP.D2_ITEMCC)
                from DUD010
                    left join DT6010
                        on DT6010.D_E_L_E_T_ = ''
                        and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                        and DT6010.DT6_DOC = DUD010.DUD_DOC
                        and DT6010.DT6_SERIE = DUD010.DUD_SERIE

                        left join SD2010 SD2
                            on SD2.D_E_L_E_T_ = ''
                            and SD2.D2_DOC = DT6010.DT6_DOC
                            and SD2.D2_SERIE = DT6010.DT6_SERIE
                            and SD2.D2_CLIENTE = DT6010.DT6_CLIDEV
                            and SD2.D2_LOJA = DT6010.DT6_LOJDEV
                            
                            left join SD2010 COMP
                                on COMP.D_E_L_E_T_ = ''
                                and COMP.D2_DOC = SD2.D2_NFORI
                                and COMP.D2_SERIE = SD2.D2_SERIORI
                                and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                                and COMP.D2_LOJA = SD2.D2_LOJA
                where
                        DUD010.D_E_L_E_T_ = ''
                    and DUD010.DUD_FILIAL = left(ZE1.ZE1_FILIAL, 4)
                    and DUD010.DUD_FILORI = ZE1.ZE1_FILIAL
                    and DUD010.DUD_VIAGEM = ZE1.ZE1_NUM
                    and DUD010.DUD_SERIE != 'COL'
            ),
            (
                select distinct RPS.D2_ITEMCC
                from SC5010
                    left join SD2010 RPS
                        on RPS.D_E_L_E_T_ = ''
                        and RPS.D2_FILIAL = SC5010.C5_FILIAL
                        and RPS.D2_DOC = SC5010.C5_NOTA
                        and RPS.D2_SERIE = SC5010.C5_SERIE
                        and RPS.D2_CLIENTE = SC5010.C5_CLIENTE
                        and RPS.D2_LOJA = SC5010.C5_LOJACLI
                where
                        SC5010.D_E_L_E_T_ = ''
                    and SC5010.C5_FILIAL = ZE1.ZE1_FILIAL
                    and trim(SC5010.C5_YVIAGEM) = ZE1.ZE1_NUM
            )
        ) as ITEM,
        sum(cast(coalesce(ZE1.ZE1_TOTAL, 0) as decimal (14, 2))) as TOTAL
    from ZE1010 ZE1
    where
            ZE1.D_E_L_E_T_ = ''
        and ZE1.ZE1_TIPO = '2'
        and left(ZE1.ZE1_COMPET, 6) = '"+cCompt+"' and ZE1.ZE1_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZE1.ZE1_FILIAL, ZE1.ZE1_NUM
