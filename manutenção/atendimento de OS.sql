select
    STL.TL_FILIAL as FIL_OS,
    STL.TL_ORDEM as OS,
    trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
    cast(STI.TI_PLANO as int) as PLANO,
    case STI.TI_PLANO when 0 then 'CORRETIVA' else trim(STI.TI_DESCRIC) end as NOME_PLANO,
    
    convert(date, STJ.TJ_DTORIGI, 103) as DATA_OS,
	trim(isnull(STJ.TJ_USUAFIM, '-')) as USR_FIM_OS,
    trim(isnull(STJ.TJ_TERMINO, '-')) as TERMINO,
    substring(STL.TL_DTINICI, 1, 6) as PERIODO_OS,
    convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as DATA_INI,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as DATA_FIM,
    datediff(minute, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0))/60.0 as HORAS_APONT,
	
    STL.TL_LOCAL as ARMAZEM,
	STJ.TJ_POSCONT as CONTADOR,
    STL.TL_QUANTID as QTD_INSUMO,
    STJ.TJ_CCUSTO as CC,
    STJ.TJ_YITMCT as ATIVIDADE,
    
    case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
    else
        case when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        else
            case when SCP.CP_QUANT > SCP.CP_QUJE then 'PARC. ATENDIDA'
            else 'OUTROS'
            end
        end
    end as APP_INSUMO,

    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,

    case when STL.TL_TIPOREG = 'P' and STL.TL_DOC = '' then 'NÃO ATENDIDA'
    else
        case when STL.TL_TIPOREG = 'P' and STL.TL_DOC != '' then 'ATENDIDA'
        else
            case when STL.TL_TIPOREG = 'M' then 'MDO'
            else
                case when STL.TL_TIPOREG = 'T' then 'EXTERNO'
                else
                    case when STL.TL_TIPOREG = 'E' then 'FUNÇÃO PREVISTA'
                    else 'OUTROS'
                    end
                end
            end
        end
    end as ATENDIMENTO,

    last_value(STL.TL_SEQRELA) over(partition by STJ.TJ_FILIAL, STJ.TJ_ORDEM, STL.TL_CODIGO order by STJ.TJ_FILIAL, STJ.TJ_ORDEM, STL.TL_CODIGO, STL.TL_SEQRELA) as SEQ_INSUMO,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		when 'P' then 'PEÇAS'
		when 'T' then 'TERCEIROS'
		else 'OUTROS'
	end as TIPO_CUSTO,

    trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,
	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then trim(SA2.A2_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,
    
    trim(isnull(ST4.T4_SERVICO, '-')) as COD_SERVICO,
	trim(isnull(ST4.T4_NOME, '-')) as SERVICO,
    trim(isnull(STL.TL_TAREFA, '-')) as COD_TAREFA,
	trim(isnull(TT9.TT9_DESCRI, '-')) as TAREFA,
	
    trim(isnull(SH4.H4_CODIGO, '-')) as H4_CODIGO,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,
	trim(isnull(SB1.B1_COD, '-')) as COD_PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as PRODUTO,
	trim(isnull(SA2.A2_COD, '-')) as COD_FORNECEDOR,
	trim(isnull(SA2.A2_NOME, '-')) as FORNECEDOR

from STL010 STL (nolock)
    inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL
        and STJ.TJ_SERVICO not in ('CONSEP', 'REFORP', 'PNEMOV')
        and year(STJ.TJ_DTORIGI) > 2021

        inner join ST4010 ST4 (nolock)
            on ST4.D_E_L_E_T_ = ''
            and ST4.T4_SERVICO = STJ.TJ_SERVICO
    
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = STL.TL_FILIAL
        and SCP.CP_NUM = STL.TL_NUMSA
        and SCP.CP_ITEM = STL.TL_ITEMSA
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = STL.TL_CODIGO            
    left join TT9010 TT9 (nolock)
        on TT9.D_E_L_E_T_ = ''
        and TT9.TT9_TAREFA = STL.TL_TAREFA
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
