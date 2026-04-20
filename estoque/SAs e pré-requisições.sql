select
    SCP.CP_FILIAL as FILIAL,
    SCP.CP_LOCAL as ARMAZEM,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    cast(SCP.CP_EMISSAO as date) as DATA_SA,
    left(SCP.CP_EMISSAO, 6) as PERIODO,
    SCP.CP_USER as USR_SA,
    SCP.CP_CODSOLI,
    SCP.CP_PREREQU,
    SCP.CP_STATUS,
    SCP.CP_STATSA,
    SCP.CP_SALBLQ,

    case
        when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
        when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
        else 'OUTROS'
    end as SA_ATENDIDA,

    (
		select top 1 cast(SCR010.CR_DATALIB as date)
		from SCR010
		where
			    nullif(SCR010.CR_LIBAPRO, '') is not null
			and SCR010.CR_TIPO = 'SA'
			and SCR010.CR_FILIAL = SCP.CP_FILIAL
			and SCR010.CR_NUM = SCP.CP_NUM
            and SCR010.D_E_L_E_T_ = ''
	) as DATAAPROV_SA,
	
	datediff(day,
		SCP.CP_EMISSAO,
		(
			select top 1 cast(SCR010.CR_DATALIB as date)
			from SCR010
			where
				    nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SA'
				and SCR010.CR_FILIAL = SCP.CP_FILIAL
				and SCR010.CR_NUM = SCP.CP_NUM
                and SCR010.D_E_L_E_T_ = ''
		)
	) as DIASAPROV_SA,

    datediff(day,
		(
			select top 1 cast(SCR010.CR_DATALIB as date)
			from SCR010
			where
				    nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SA'
				and SCR010.CR_FILIAL = SCP.CP_FILIAL
				and SCR010.CR_NUM = SCP.CP_NUM
                and SCR010.D_E_L_E_T_ = ''
		),
        SD3.D3_EMISSAO
	) as DIASAPRSA_ATEND,

    left(SD3.D3_OP, 6) as OP,
    right(left(SD3.D3_OP, 8), 2) as TIPO_OP,
    SD3.D3_DOC as DOCUMENTO,
    SD3.D3_TM as TIPO_MOV,
    SD3.D3_CF as TIPO_CLAS,
    SD3.D3_CC as CC,
    SD3.D3_ITEMCTA as ATIVIDADE,
    cast(SD3.D3_EMISSAO as date) as D3_EMISSAO,
    SD3.D3_LOCALIZ as ENDERECO,
    upper(trim(SD3.D3_USUARIO)) as USR_ATEND,
    SD3.D3_NUMSEQ as NUMSEQ,
    SD3.D3_ESTORNO as ESTORNO,
        
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as PROD_DESC,
    trim(isnull(SB1.B1_GRUPO, '-')) as PROD_GRUPO,
    
    SCQ.CQ_NUMREQ as REQUISICAO,
    SCQ.CQ_ITEM as ITEM_REQ,
    SCQ.CQ_NUMSQ as SEQ_REQ,
    SCQ.CQ_QUANT as QTD_REQ,
    SCQ.CQ_QTDISP as QTD_DISPREQ,
    cast(SCQ.CQ_DATPRF as date) as DATA_REQ,
    SCP.CP_NUMSC as SC_NUM,
    SCP.CP_ITSC as SC_ITEM,
    
    case when SD3.D3_ESTORNO = 'S' then 'ATENDIMENTO ESTORNADO'
    else
        case when SCQ.CQ_NUMREQ != '' and SD3.D3_DOC != '' and SCP.CP_QUANT = SCP.CP_QUJE then 'ATENDIDA TOTAL' /* normal */
        else
            case when SCQ.CQ_NUMREQ != '' and SD3.D3_DOC != '' and SCP.CP_QUANT > SCP.CP_QUJE then 'ATENDIDA PARCIAL' /* normal */
            else
                case when SCQ.CQ_NUMREQ != '' and SD3.D3_DOC = '' then 'GERADA' /* incomum quando SCQ.CQ_NUMREQ = '' */
                else
                    case when SCQ.CQ_NUMREQ = '' and SCP.CP_PREREQU = '' then 'NÃO GERADA' /* SEMPRE quantidade nula SCQ, além de que sempre SD3.D3_DOC = '' */
                    else
                        case when SCQ.CQ_NUMREQ = '' and SCP.CP_STATUS = 'E' then 'ENCERRADA' /* se não gerada e encerrada, sempre SCP.CP_PREREQU = 'S' */
                        else
                            case when SCQ.CQ_NUMREQ = '' and SCP.CP_PREREQU = 'S' then 'EMPENHO' /* NUNCA quantidade nula SCQ */
                            else 'OUTROS'
                            end
                        end
                    end
                end
            end
        end
    end as STATUS_GERAL

from SCP010 SCP (nolock)
    left join SCQ010 SCQ (nolock)
        on SCQ.D_E_L_E_T_ = ''
        and SCQ.CQ_FILIAL = SCP.CP_FILIAL
        and SCQ.CQ_NUM = SCP.CP_NUM
        and SCQ.CQ_ITEM = SCP.CP_ITEM
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = SCP.CP_FILIAL
        and SD3.D3_NUMSA = SCP.CP_NUM
        and SD3.D3_ITEMSA = SCP.CP_ITEM
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO
where SCP.D_E_L_E_T_ = ''
