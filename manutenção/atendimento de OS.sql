select
    substring(STL.TL_DTINICI, 1, 6) as PERIODO_OS,
    convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as TL_DTINICI,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as TL_DTINFIM,

	STL.TL_LOCAL,
	STJ.TJ_POSCONT,
    STL.TL_QUANTID,
    STJ.TJ_CCUSTO,
	
    convert(date, STJ.TJ_DTORIGI, 103) as TJ_DTORIGI,
	trim(isnull(STJ.TJ_USUAFIM, '-')) as TJ_USUAFIM,
	trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_DESC)
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then trim(SA2.A2_NOME)
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_DESCRI)
				else 'OUTROS'
				end
			end
		end
	end as DESC_INSUMO,

	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(STL.TL_TAREFA, '-')) as TL_TAREFA,
	trim(isnull(ST5.T5_DESCRIC, isnull(TT9.TT9_DESCRI, '-'))) as T5_TAREFA,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(SH4.H4_CODIGO, '-')) as H4_CODIGO,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,
	trim(isnull(STI.TI_PLANO, '-')) as TI_PLANO,
    case STI.TI_PLANO when 0 then 'CORRETIVA' else trim(STI.TI_DESCRIC) end as PLANO,
	trim(isnull(STJ.TJ_FILIAL, '-')) as COD_FILIAL,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,
	trim(isnull(SA2.A2_COD, '-')) as A2_COD,
	trim(isnull(SA2.A2_NOME, '-')) as A2_NOME,

	trim(isnull(SF1.F1_DOC, '-')) as F1_DOC,
	trim(isnull(SF1.F1_SERIE, '-')) as F1_SERIE

from STL010 STL (nolock)
    inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and STL.TL_FILIAL = SCP.CP_FILIAL
        and STL.TL_ORDEM = substring(SCP.CP_OP, 1, 6)
        and STL.TL_CODIGO = SCP.CP_PRODUTO
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = STL.TL_CODIGO
            
    left join ST5010 ST5 (nolock)
        on ST5.D_E_L_E_T_ = ''
        and ST5.T5_TAREFA = STL.TL_TAREFA
    left join TT9010 TT9 (nolock)
        on TT9.D_E_L_E_T_ = ''
        and TT9.TT9_TAREFA = STL.TL_TAREFA
    left join SF1010 SF1 (nolock)
        on SF1.D_E_L_E_T_ = ''
        and SF1.F1_DOC + SF1.F1_SERIE = STL.TL_DOC + STL.TL_SDOC
    left join SA2010 SA2 (nolock)
        on SA2.D_E_L_E_T_ = ''
        and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
    left join SH4010 SH4 (nolock)
        on SH4.D_E_L_E_T_ = ''
        and SH4.H4_CODIGO = STL.TL_CODIGO
    left join ST0010 ST0 (nolock)
        on ST0.D_E_L_E_T_ = ''
        and ST0.T0_ESPECIA = STL.TL_CODIGO
    left join ST1010 ST1 (nolock)
        on ST1.D_E_L_E_T_ = ''
        and ST1.T1_FILIAL = STL.TL_FILIAL
        and ST1.T1_CODFUNC = STL.TL_CODIGO
    left join STI010 STI (nolock)
        on STI.D_E_L_E_T_ = ''
        and STI.TI_FILIAL = STL.TL_FILIAL
        and STI.TI_PLANO = STL.TL_PLANO
where STL.D_E_L_E_T_ = ''