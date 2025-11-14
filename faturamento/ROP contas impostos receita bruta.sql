    select
        SD2.D2_FILIAL as FILIAL,
        SC6.C6_YOS as NUM,
        SC6.C6_CC as CC,
        SC6.C6_ITEMCTA as ITEM,
        null as ESPECIE,
        cast(coalesce(sum(SD2.D2_QUANT), 0) as decimal(13, 3)) AS QTD_FATURADA_ITEM,
        cast(coalesce(sum(SD2.D2_VALBRUT), 0) as decimal(14, 2)) as VL_FATURAMENTO_TOTAL,
        cast(coalesce(sum(SD2.D2_VALICM), 0) as decimal(14, 2)) as VL_ICMS_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALIPI), 0) as decimal(14, 2)) as VL_IPI_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALFRE), 0) as decimal(14, 2)) as VL_FRETE_NF,
        cast(coalesce(sum(SD2.D2_DESPESA), 0) as decimal(14, 2)) as VL_DESPESA,
        cast(coalesce(sum(SD2.D2_TOTAL), 0) as decimal(14, 2)) as VL_FATURAMENTO_MERCADORIA,
        cast(coalesce(sum(SD2.D2_VALIMP6), 0) as decimal(14, 2)) as VL_PIS_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALIMP5), 0) as decimal(14, 2)) as VL_COFINS_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALISS), 0) as decimal(14, 2)) as VL_ISS_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_ICMSRET), 0) as decimal(14, 2)) as VL_ICMS_SUBST_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_DESCON), 0) as decimal(12, 2)) as VL_DESCONTO_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALIRRF), 0) as decimal(14, 2)) as VL_IRF_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_VALINS), 0) as decimal(14, 2)) as VL_INSS_FATURAMENTO,
        cast(coalesce(sum(SD2.D2_PRUNIT), 0) as decimal(16, 4)) as VL_UNITARIO,
        cast(coalesce(sum(SD2.D2_SEGURO), 0) as decimal(14, 2)) as VL_SEGURO
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
        and left(SD2.D2_EMISSAO, 6) =:PERIODO
    group by SD2.D2_FILIAL, SC6.C6_YOS, SC6.C6_CC, SC6.C6_ITEMCTA
union
    select
        RECEITA_TMS.FILIAL,
        RECEITA_TMS.NUM,
        RECEITA_TMS.CC,
        RECEITA_TMS.ITEM,
        RECEITA_TMS.ESPECIE,
        cast(coalesce(sum(RECEITA_TMS.D2_QUANT), 0) as decimal(13, 3)) AS QTD_FATURADA_ITEM,
        cast(coalesce(sum(RECEITA_TMS.D2_VALBRUT), 0) as decimal(14, 2)) as VL_FATURAMENTO_TOTAL,
        cast(coalesce(sum(RECEITA_TMS.D2_VALICM), 0) as decimal(14, 2)) as VL_ICMS_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALIPI), 0) as decimal(14, 2)) as VL_IPI_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALFRE), 0) as decimal(14, 2)) as VL_FRETE_NF,
        cast(coalesce(sum(RECEITA_TMS.D2_DESPESA), 0) as decimal(14, 2)) as VL_DESPESA,
        cast(coalesce(sum(RECEITA_TMS.D2_TOTAL), 0) as decimal(14, 2)) as VL_FATURAMENTO_MERCADORIA,
        cast(coalesce(sum(RECEITA_TMS.D2_VALIMP6), 0) as decimal(14, 2)) as VL_PIS_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALIMP5), 0) as decimal(14, 2)) as VL_COFINS_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALISS), 0) as decimal(14, 2)) as VL_ISS_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_ICMSRET), 0) as decimal(14, 2)) as VL_ICMS_SUBST_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_DESCON), 0) as decimal(12, 2)) as VL_DESCONTO_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALIRRF), 0) as decimal(14, 2)) as VL_IRF_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_VALINS), 0) as decimal(14, 2)) as VL_INSS_FATURAMENTO,
        cast(coalesce(sum(RECEITA_TMS.D2_PRUNIT), 0) as decimal(16, 4)) as VL_UNITARIO,
        cast(coalesce(sum(RECEITA_TMS.D2_SEGURO), 0) as decimal(14, 2)) as VL_SEGURO
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
            SF2.F2_ESPECIE as ESPECIE,
            SD2.D2_QUANT,
            SD2.D2_VALBRUT,
            SD2.D2_VALICM,
            SD2.D2_VALIPI,
            SD2.D2_VALFRE,
            SD2.D2_DESPESA,
            SD2.D2_TOTAL,
            SD2.D2_VALIMP6,
            SD2.D2_VALIMP5,
            SD2.D2_VALISS,
            SD2.D2_ICMSRET,
            SD2.D2_DESCON,
            SD2.D2_VALIRRF,
            SD2.D2_VALINS,
            SD2.D2_PRUNIT,
            SD2.D2_SEGURO

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
                where DUD010.D_E_L_E_T_ = ''
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
            and left(SD2.D2_EMISSAO, 6) =:PERIODO
    ) RECEITA_TMS
    group by RECEITA_TMS.FILIAL, RECEITA_TMS.NUM, RECEITA_TMS.CC, RECEITA_TMS.ITEM, RECEITA_TMS.ESPECIE
