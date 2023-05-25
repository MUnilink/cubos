select
    SD3.D3_FILIAL,
    SD3.D3_CC,
    SD3.D3_ITEMCTA,
    SD3.D3_LOCAL,
    SD3.D3_EMISSAO,
    SD3.D3_GRUPO,
    SD3.D3_COD,
	trim(SB1.B1_DESC) as B1_DESC,
    substring(SD3.D3_OP, 1, 6) as D3_OP,
    SD3.D3_CF,
    SD3.D3_TM + ' - ' + trim(isnull(SF5.F5_TEXTO, SF4.F4_TEXTO)) as D3_TM,
    SD1.D1_DOC,
    SD3.D3_DOC,
    SD1.D1_FORNECE,
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO_MOV

from SD3010 SD3 (nolock)
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SD3.D3_COD
    left join SF5010 SF5 (nolock)
        on SF5.D_E_L_E_T_ = ''
        and SF5.F5_CODIGO = case SD3.D3_TM when 499 then 498 when 999 then 998 else SD3.D3_TM end
    left join SD1010 SD1 (nolock)
        on SD1.D_E_L_E_T_ = ''
        and SD1.D1_FILIAL = SD3.D3_FILIAL
        and SD1.D1_DOC = SD3.D3_DOC
        and SD1.D1_COD = SD3.D3_COD

        left join SF4010 SF4 (nolock)
            on SF4.D_E_L_E_T_ = ''
            and SF4.F4_CODIGO = SD1.D1_TES
    
    left join SB9010 SB9 (nolock)
        on SB9.D_E_L_E_T_ = ''
        and SB9.B9_FILIAL = SD3.D3_FILIAL
        and SB9.B9_LOCAL = SD3.D3_LOCAL
        and SB9.B9_COD = SD3.D3_COD
where
        SD3.D_E_L_E_T_ = ''
    and year(SD3.D3_EMISSAO) > 2021
