select
	cast(SRA.RA_NASC as date) as NASCIMENTO,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	cast(SRA.RA_DEMISSA as date) as DEMISSAO,
	cast(SRA.RA_DTFIMCT as date) as FIM_CONTRATO,
    
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
    trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_CARGO) as COD_CARGO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	
	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
    
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
    trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
    trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
    trim(isnull(SB1.B1_UM, '-')) as UN,

    TNF.TNF_FILIAL as FILIAL,
    substring(TNF.TNF_DTENTR, 1, 6) as PERIODO,
    convert(datetime, concat(TNF.TNF_DTENTR, ' ', TNF.TNF_HRENTR), 113) as DATA_ENTREGA,
    TNF.TNF_QTDENT as QTD_ENTREGUE,
    TNF.TNF_QTDEVO as QTD_DEVOLVID,
    TNF.TNF_MOTIVO,
    TNF.TNF_INDDEV,
    TNF.TNF_DTDEVO,
    TNF.TNF_LOCDV,
    TNF.TNF_TIPODV,
    TNF.TNF_EPIEFI,
    
    cast(SD3.D3_EMISSAO as date) as DATA_BAIXA,
    SD3.D3_NUMSA as SA,
    SD3.D3_CC as CC_SA,
    SD3.D3_ITEMCTA as IC_SA,
    SD3.D3_TM as TM,
    SD3.D3_CF as CF,
    SD3.D3_DOC as DOC,
    SD3.D3_NUMSEQ as SEQ,
    SD3.D3_ESTORNO as ESTORNO,
    SD3.D3_CUSTO1 as CUSTO_MOV,
    SD3.D3_QUANT as QTD_MOV,

    convert(date, SCP.CP_EMISSAO, 103) as DATA_SA,
    SCP.CP_USER,
    SCP.CP_CODSOLI,
    SCP.CP_LOCAL as ARMAZEM,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    
    case
        when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
        when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
        else 'OUTROS'
    end as SA_ATENDIDA
    
from TNF010 TNF
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = TNF.TNF_FILIAL
        and SCP.CP_NUM = TNF.TNF_NUMSA
        and SCP.CP_ITEM = TNF.TNF_ITEMSA
        
        left join SD3010 SD3 (nolock)
            on SD3.D_E_L_E_T_ = ''
            and SD3.D3_FILIAL = SCP.CP_FILIAL
            and SD3.D3_NUMSA = SCP.CP_NUM
            and SD3.D3_ITEMSA = SCP.CP_ITEM
    
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = TNF.TNF_CODEPI
    inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = TNF.TNF_FILIAL
		and SRA.RA_MAT = TNF.TNF_MAT

        inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

            left join SQ3010 SQ3 (nolock)
                on SQ3.D_E_L_E_T_ = ''
                and SQ3.Q3_CARGO = SRJ.RJ_CARGO
        
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRA.RA_CC
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM
        inner join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
where
        TNF.D_E_L_E_T_ = ''
