select    
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    trim(SB1.B1_GRUPO) as GRUPO,
    trim(SB1.B1_UM) as UN,
    trim(SA2.A2_NOME) as FORNECEDOR,
    trim(TN3.TN3_NUMCAP) as CA,
    cast(TN3.TN3_DTVENC as date) as VENC_CA,
    case TN3.TN3_INDEVO when 1 then 'N' when 2 then 'S' else 'OUTROS' end as DEVOLVE,
    TN3.TN3_DURABI as DURABILIDADE,
    cast(TN3.TN3_DTVALI as date) as VALIDADE,
    trim(TN3.TN3_OBSAVA) as OBS,
    trim(TN3.TN3_TIPEPI) as TIPO_EPI,
    trim(TN3.TN3_AREEPI) as AREA_EPI,
    case TN3.TN3_GENERI when 1 then 'N' when 2 then 'S' else 'OUTROS' end as GENERICO
    
from TN3010 TN3 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = TN3.TN3_CODEPI
    inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = TN3.TN3_FORNEC
        and SA2.A2_LOJA = TN3.TN3_LOJA
where
        TN3.D_E_L_E_T_ = ''
