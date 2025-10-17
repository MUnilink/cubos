select
    ZE1.ZE1_FILIAL as FILIAL,
    ZE1.ZE1_NUM as NUM,
    coalesce(nullif(SD2.D2_CCUSTO, ''), nullif(COMP.D2_CCUSTO, ''), nullif(RPS.D2_CCUSTO, ''), nullif(SE1.E1_CCUSTO, '')) as CC,
    coalesce(nullif(SD2.D2_ITEMCC, ''), nullif(COMP.D2_ITEMCC, ''), nullif(RPS.D2_ITEMCC, ''), nullif(SE1.E1_ITEMCTA, '')) as ATIVIDADE,

    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    cast(DT6.DT6_DATEMI as date) as DT6_DATEMI,
    DUD.DUD_DOC,
    DUD.DUD_SERIE,
    
    COMP.D2_DOC as COMP_DOC,
    COMP.D2_SERIE as COMP_SERIE,
    COMP.D2_TOTAL as COMP_TOTAL,
    cast(COMP.D2_EMISSAO as date) as COMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    cast(RPS.D2_EMISSAO as date) as RPS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    cast(SE1.E1_EMISSAO as date) as ND_EMISSAO,
    
    cast(coalesce(ZE1.ZE1_TOTAL, 0) as decimal (14, 2)) as TOTAL
from ZE1010 ZE1
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILIAL = left(ZE1.ZE1_FILIAL, 4)
        and DUD.DUD_FILORI = ZE1.ZE1_FILIAL
        and DUD.DUD_VIAGEM = ZE1.ZE1_NUM

        left join DT6010 DT6
            on DT6.D_E_L_E_T_ = ''
            and DT6.DT6_FILDOC = DUD.DUD_FILDOC
            and DT6.DT6_DOC = DUD.DUD_DOC
            and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join SD2010 SD2
                on SD2.D_E_L_E_T_ = ''
                and SD2.D2_DOC = DT6.DT6_DOC
                and SD2.D2_SERIE = DT6.DT6_SERIE
                and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
                and SD2.D2_LOJA = DT6.DT6_LOJDEV
                
                left join SD2010 COMP
                    on COMP.D_E_L_E_T_ = ''
                    and COMP.D2_DOC = SD2.D2_NFORI
                    and COMP.D2_SERIE = SD2.D2_SERIORI
                    and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                    and COMP.D2_LOJA = SD2.D2_LOJA
    
    left join SC5010 SC5
        on SC5.D_E_L_E_T_ = ''
        and SC5.C5_FILIAL = ZE1.ZE1_FILIAL
        and trim(SC5.C5_YVIAGEM) = ZE1.ZE1_NUM

        left join SD2010 RPS
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI

    left join SE1010 SE1
        on SE1.D_E_L_E_T_ = ''
        and (trim(SE1.E1_YVIATMS) = DUD.DUD_VIAGEM or SE1.E1_YVIAGEM = DUD.DUD_VIAGEM)

where
        ZE1.D_E_L_E_T_ = ''
    and ZE1.ZE1_TIPO in (3)
    and ZE1.ZE1_COMPET between '20250331' and '20250430'
