select distinct
    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    convert(date, STL.TL_DTINICI, 103) as TL_DTINICI,
    convert(date, STJ.TJ_DTORIGI, 103) as TJ_DTORIGI,
    convert(date, STJ.TJ_DTMRFIM, 103) as TJ_DTMRFIM,
    STL.TL_QUANTID,
    STL.TL_LOCAL,
    STL.TL_SEQRELA,
    STJ.TJ_CCUSTO,

    case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then 'MÃO-DE-OBRA'
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then 'PEÇAS'
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then 'TERCEIROS'
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then 'FERRAMENTA'
				else 'OUTROS'
				end
			end
		end
	end as NATUREZA_CUSTO,

    case when STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_CODFUNC, isnull(ST0.T0_ESPECIA, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_COD)
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then isnull(trim(SA2.A2_COD) + '-' + trim(SA2.A2_LOJA), '-')
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_CODIGO)
				else 'OUTROS'
				end
			end
		end
	end as INSUMO,

	case when STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
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

    year(STL.TL_DTINICI) as ano_APP,
    month(STL.TL_DTINICI) as mes_APP,

    case when STJ.TJ_SERVICO = 'PNEMOV' then 'PNEU' else 'MANUTENÇÃO' end as TIPO_CUSTO,

    case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
    else
        case when trim(STL.TL_CODIGO) in ('T05', 'T12', 'T15', 'T16', 'T17') then ST1.T1_SALARIO * STL.TL_QUANTID
        else
            case when trim(STL.TL_CODIGO) like ('1130%') then PNEU_CUSTO.B9_CM * STL.TL_QUANTID
            else
                STL.TL_CUSTO
            end
        end
    end as TL_CUSTO
from STJ010 STJ (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STJ.TJ_CODBEM

        left join TQR010 TQR (nolock)
            on TQR.D_E_L_E_T_ = ''
            and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

    inner join ST4010 ST4 (nolock)
        on ST4.D_E_L_E_T_ = ''
        and ST4.T4_SERVICO = STJ.TJ_SERVICO
    inner join STL010 STL (nolock)
        on STL.D_E_L_E_T_ = ''
        and STL.TL_ORDEM = STJ.TJ_ORDEM
        and STL.TL_PLANO = STJ.TJ_PLANO
        and STL.TL_FILIAL = STJ.TJ_FILIAL

        left join ST5010 ST5 (nolock)
            on ST5.D_E_L_E_T_ = ''
            and ST5.T5_CODBEM = STL.TL_CODBEM
            and ST5.T5_TAREFA = STL.TL_TAREFA
        left join SF1010 SF1 (nolock)
            on SF1.D_E_L_E_T_ = ''
            and SF1.F1_DOC + SF1.F1_SERIE = STL.TL_DOC + STL.TL_SDOC
        left join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = STL.TL_CODIGO
        left join
        (
            select
                SB9010.B9_COD,
                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                min(SB9010.B9_DATA) as B9_DATA
            from SB9010 (nolock)
            where
                    SB9010.D_E_L_E_T_ = ''
                and SB9010.B9_LOCAL = '01'
                and SB9010.B9_COD in ('11380003', '11380004', '11380005')
                and SB9010.B9_QINI != 0
            group by
                SB9010.B9_COD
        ) ADESIVO_CUSTO
            on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO
        left join
        (
            select
                SB9010.B9_COD,
                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                min(SB9010.B9_DATA) as B9_DATA
            from SB9010 (nolock)
            where
                    SB9010.D_E_L_E_T_ = ''
                and SB9010.B9_LOCAL = '20'
                and SB9010.B9_COD like '1130%'
                and SB9010.B9_QINI != 0
            group by
                SB9010.B9_COD
        ) PNEU_CUSTO
            on PNEU_CUSTO.B9_COD = STL.TL_CODIGO
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
where
        STJ.D_E_L_E_T_ = ''
    and STL.TL_SEQRELA > 0
    and STL.TL_DTINICI > 20211231
    and ST9.T9_CODFAMI in ('VP', 'VM')
