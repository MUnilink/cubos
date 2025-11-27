    select
        SD2.D2_FILIAL as FILIAL,
        SC6.C6_YOS as NUM,
        SC6.C6_CC as CC,
        SC6.C6_ITEMCTA as ITEM,
        sum(cast(coalesce(SD2.D2_DESCON, 0) as decimal(14, 2))) as TOTAL
    from SD2010 SD2
        inner join SC6010 SC6
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = SD2.D2_FILIAL
            and SC6.C6_NUM = SD2.D2_PEDIDO
            and SC6.C6_ITEM = SD2.D2_ITEMPV
            
            inner join ZC2010 ZC2 (nolock)
                on ZC2.D_E_L_E_T_ = ''
                and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
                and ZC2.ZC2_NUM = SC6.C6_YOS
                and ZC2.ZC2_ITEM = SC6.C6_YITOS
    where
            SD2.D_E_L_E_T_ = ''
        and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by SD2.D2_FILIAL, SC6.C6_YOS, SC6.C6_CC, SC6.C6_ITEMCTA
union /* descontos */
    select
        RECEITA_TMS.FILIAL,
        RECEITA_TMS.NUM,
        RECEITA_TMS.CC,
        RECEITA_TMS.ITEM,
        sum(RECEITA_TMS.TOTAL) as TOTAL
    from
    (
        select
            SD2.D2_FILIAL as FILIAL,
            coalesce
            (
                DUD.DUD_VIAGEM,
                VGA2.DUD_VIAGEM,
                (
                    select distinct DUD010.DUD_VIAGEM
                    from DUD010 (nolock)
                        inner join SC5010 (nolock)
                            on SC5010.D_E_L_E_T_ = ' '
                            and nullif(SC5010.C5_YVIAGEM, '') = DUD010.DUD_VIAGEM
                    where
                            DUD010.D_E_L_E_T_ = ''
                        and SD2.D2_FILIAL = SC5010.C5_FILIAL
                        and SD2.D2_DOC = SC5010.C5_NOTA
                        and SD2.D2_SERIE = SC5010.C5_SERIE
                        and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                        and SD2.D2_LOJA = SC5010.C5_LOJACLI
                )
            ) as NUM,
            SD2.D2_CCUSTO as CC,
            SD2.D2_ITEMCC as ITEM,
            sum(cast(coalesce(SD2.D2_DESCON, 0) as decimal(14, 2))) as TOTAL

        from SD2010 SD2 (nolock)
            inner join SF2010 SF2 (nolock)
                on SF2.F2_FILIAL = SD2.D2_FILIAL
                and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                and SF2.F2_LOJA = SD2.D2_LOJA
                and SF2.F2_DOC = SD2.D2_DOC
                and SF2.F2_SERIE = SD2.D2_SERIE
                and SF2.D_E_L_E_T_= ' '
            left join
            (
                select distinct
                    DUD010.DUD_FILIAL,
                    DUD010.DUD_FILORI,
                    DUD010.DUD_VIAGEM,
                    DUD010.DUD_FILDOC,
                    DUD010.DUD_DOC,
                    DUD010.DUD_SERIE,
                    DUD010.DUD_STATUS,
                    DUA010.DUA_CODOCO, /* and DUA010.DUA_CODOCO != 'E004' */
                    DUA010.DUA_FILVTR,
                    DUA010.DUA_NUMVTR, /* and DUA010.DUA_NUMVTR = '' */
                    case when DUA010.DUA_CODOCO = 'E004' and concat(DUA010.DUA_FILVTR, DUA010.DUA_NUMVTR) != '' then 'SOC' else 'NOR' end as VGA_NORMAL
                from DUD010
                    left join DUA010
                        on DUA010.D_E_L_E_T_ = ''
                        and DUA010.DUA_FILIAL = DUD010.DUD_FILIAL
                        and DUA010.DUA_FILORI = DUD010.DUD_FILORI
                        and DUA010.DUA_VIAGEM = DUD010.DUD_VIAGEM
                        and DUA010.DUA_FILDOC = DUD010.DUD_FILDOC
                        and DUA010.DUA_DOC = DUD010.DUD_DOC
                        and DUA010.DUA_SERIE = DUD010.DUD_SERIE
                where
                        DUD010.D_E_L_E_T_ = ''
                    and DUD010.DUD_SERIE != 'COL'
            ) DUD
                on DUD.DUD_FILDOC = SD2.D2_FILIAL
                and DUD.DUD_DOC = SD2.D2_DOC
                and DUD.DUD_SERIE = SD2.D2_SERIE
                and DUD.DUD_STATUS != '9'
                and DUD.VGA_NORMAL != 'SOC'
            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_DOC = SD2.D2_NFORI
                and COMP.D2_SERIE = SD2.D2_SERIORI
                and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                and COMP.D2_LOJA = SD2.D2_LOJA

                left join DUD010 VGA2 (nolock)
                    on VGA2.D_E_L_E_T_ = ''
                    and VGA2.DUD_FILDOC = COMP.D2_FILIAL
                    and VGA2.DUD_DOC = COMP.D2_DOC
                    and VGA2.DUD_SERIE = COMP.D2_SERIE
        where
                SD2.D_E_L_E_T_ = ''
            and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
        group by
            SD2.D2_FILIAL,
            SD2.D2_CCUSTO,
            SD2.D2_ITEMCC,
            DUD.DUD_VIAGEM,
            VGA2.DUD_VIAGEM,
            SD2.D2_FILIAL,
            SD2.D2_DOC,
            SD2.D2_SERIE,
            SD2.D2_CLIENTE,
            SD2.D2_LOJA
    ) RECEITA_TMS
    group by RECEITA_TMS.FILIAL, RECEITA_TMS.NUM, RECEITA_TMS.CC, RECEITA_TMS.ITEM
