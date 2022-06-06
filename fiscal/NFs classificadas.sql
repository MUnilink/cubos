select
	SD1.D1_FILIAL,
	SF1.F1_DOC,
	SF1.F1_SERIE,
	SF1.F1_FORNECE,
	SF1.F1_LOJA,
	SD1.D1_COD,
	SF1.F1_TIPO,
	SF1.F1_STATUS,
	cast(convert(date, SF1.F1_RECBMTO, 105) as varchar) as F1_RECBMTO,
	cast(convert(date, SF1.F1_DTDIGIT, 105) as varchar) as F1_DTDIGIT,
	cast(convert(date, SF1.F1_EMISSAO, 105) as varchar) as F1_EMISSAO,
	SF1.F1_VALBRUT,
	SA2.A2_NOME,
	SD1.D1_TES,
	SF1.F1_CHVNFE,

	case SF1.F1_STATUS
		when ' ' then 'NF NAO-CLASSIFICADA' /*'ENABLE'*/
		when '' then 'NF NAO-CLASSIFICADA' /*'ENABLE'*/
		when null then 'NF NAO-CLASSIFICADA' /*'ENABLE'*/

		when 'B' then 'NF BLOQUEADA' /*'BR_LARANJA '*/
		when 'C' then 'NF BLOQUEADA S/CLASSF.' /*'BR_VIOLETA '*/
		else
			case SF1.F1_TIPO
				when 'N' then 'NF CLASSIFICADA' /*'DISABLE '*/
				when 'P' then 'NF DE COMPL. IPI' /*'BR_AZUL '*/
				when 'I' then 'NF DE COMPL. ICMS' /*'BR_MARROM '*/
				when 'C' then 'NF DE COMPL. PRECO/FRETE' /*'BR_PINK '*/
				when 'B' then 'NF DE BENEFICIAMENTO' /*'BR_CINZA '*/
				when 'D' then 'NF DE DEVOLUCAO' /*'BR_AMARELO '*/
				else 'INDEFINIDO' end
	end as LEGENDA,

	year(SF1.F1_EMISSAO) as EMISSAO_ANO,
	month(SF1.F1_EMISSAO) as EMISSAO_MES

from SF1010 as SF1 (nolock)
	inner join SD1010 as SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SF1.F1_FILIAL
		and SD1.D1_DOC = SF1.F1_DOC
		and SD1.D1_SERIE = SF1.F1_SERIE
		and SD1.D1_FORNECE = SF1.F1_FORNECE
		and SD1.D1_LOJA = SF1.F1_LOJA
	inner join SA2010 as SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SD1.D1_FORNECE
		and SA2.A2_LOJA = SD1.D1_LOJA
where SF1.D_E_L_E_T_ = ''