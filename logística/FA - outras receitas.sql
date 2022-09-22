select
    DTQ.DTQ_VIAGEM,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
            and DTW010.DTW_DATREA > '20211231'
    ) as COMPETENCIA,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    convert(date, RPS.D2_EMISSAO, 103) as RPS_EMISSAO

from DTQ010 DTQ (nolock)
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and trim(SC5.C5_YVIAGEM) = DTQ.DTQ_VIAGEM

        left join SD2010 RPS (nolock)
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI
where
        DTQ.D_E_L_E_T_ = ''
