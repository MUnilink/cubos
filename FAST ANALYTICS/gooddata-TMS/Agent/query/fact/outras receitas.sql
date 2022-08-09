select
    SE1.E1_NUM as ND_NUM,
    SE1.E1_PREFIXO as ND_PREFIXO,
    SE1.E1_TIPO as ND_TIPO,
    SE1.E1_VALOR as ND_VALOR,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    convert(date, RPS.D2_EMISSAO, 103) as RPS_EMISSAO,

    DOC_ANU.DTC_DOC as DOCAV_DOC,
    DOC_ANU.DTC_SERIE as DOCAV_SERIE,
    convert(date, DOC_ANU.DTC_DATENT, 103) as DOCAV_DATEMI

from DTQ010 DTQ (nolock)
    left join SE1010 SE1 (nolock)
            on SE1.D_E_L_E_T_ = ''
            and SE1.E1_YVIAGEM = DTQ.DTQ_VIAGEM
        left join SC5010 SC5 (nolock)
            on SC5.D_E_L_E_T_ = ''
            and SC5.C5_YVIAGEM = DTQ.DTQ_VIAGEM

            left join SD2010 RPS (nolock)
                on RPS.D_E_L_E_T_ = ''
                and RPS.D2_FILIAL = SC5.C5_FILIAL
                and RPS.D2_DOC = SC5.C5_NOTA
                and RPS.D2_SERIE = SC5.C5_SERIE
                and RPS.D2_CLIENTE = SC5.C5_CLIENTE
                and RPS.D2_LOJA = SC5.C5_LOJACLI

        left join DTC010 DOC_ANU (nolock)
            on DOC_ANU.D_E_L_E_T_ = ''
            and DOC_ANU.DTC_YVIAGE = DTQ.DTQ_VIAGEM
where DTQ.D_E_L_E_T_ = ''
