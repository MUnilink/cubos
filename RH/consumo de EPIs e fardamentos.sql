select
    substring(TNF.TNF_DTENTR, 1, 6) as PERIODO,
    convert(datetime, concat(TNF.TNF_DTENTR, ' ', TNF.TNF_HRENTR), 113) as DATA_ENTREGA,
    TNF.TNF_QTDENT as QTD_ENTREGUE,
    TNF.TNF_QTDEVO as QTD_DEVOLVID,
    
    trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
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

    SCP.CP_FILIAL as FILIAL,
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
    end as SA_ATENDIDA,

    SD3.D3_OP,
    SD3.D3_ORDEM,
    SD3.D3_DOC,
    SD3.D3_TM,
    SD3.D3_CF,
    trim(SD3.D3_LOCALIZ) as ENDERECO,
    trim(SD3.D3_CC) as CC,
    trim(SD3.D3_ITEMCTA) as ATIVIDADE,
    cast(SD3.D3_EMISSAO as date) as DT_ATENDIMENTO,
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO_ATENDIMENTO,
    upper(trim(SD3.D3_USUARIO)) as ATENDIDA_POR,
    SD3.D3_NUMSEQ,
    SD3.D3_ESTORNO AS ESTORNO,

    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as DESC_PRODUTO,
    trim(SB1.B1_GRUPO) as GRUPO,
    (select trim(SBM010.BM_DESC) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO) as DESC_GRUPO,
    
    cast(SCP.CP_EMISSAO as date) as DATA_SA,
    left(SCP.CP_EMISSAO, 6) as PERIODO_SA,
    (select upper(trim(SYS_USR.USR_CODIGO)) from SYS_USR where SYS_USR.D_E_L_E_T_ = '' and SYS_USR.USR_ID = SCP.CP_CODSOLI) as SOLICITANTE,
    SCP.CP_NUMSC as SC,
    SCP.CP_ITSC as SC_ITEM,
    trim(SCP.CP_OBS) as OBS

from SCP010 SCP (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = SCP.CP_FILIAL
        and SD3.D3_NUMSA = SCP.CP_NUM
        and SD3.D3_ITEMSA = SCP.CP_ITEM
    left join TNF010 TNF (nolock)
        on TNF.D_E_L_E_T_ = ''
        and TNF.TNF_FILIAL = SCP.CP_FILIAL
        and TNF.TNF_NUMSA = SCP.CP_NUM
        and TNF.TNF_ITEMSA = SCP.CP_ITEM
        
        left join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = TNF.TNF_FILIAL
            and SRA.RA_MAT = TNF.TNF_MAT

            left join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = left(SRA.RA_FILIAL, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO
            
            left join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_CUSTO = SRA.RA_CC
            left join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM
            left join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = left(SRA.RA_FILIAL, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
where
        SB1.B1_GRUPO in ('1208', '1209') 
    and SCP.D_E_L_E_T_ = ''
