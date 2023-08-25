    select /* benefícios atual */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as AT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        
        SR0.R0_PERIOD as PERIODO,
        
        case SR0.R0_TPBEN when 1 then 'TRANSPORTE' when 2 then 'ALIMENTAÇÃO' else null end as BENEFICIO,
        count(distinct SRA.RA_MAT) as contador

    from SR0010 SR0 (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SR0.R0_FILIAL
            and SRA.RA_MAT = SR0.R0_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM
        
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SR0.R0_CC        
        left join RFO010 RFO (nolock)
            on RFO.D_E_L_E_T_ = ''
            and RFO.RFO_TPVALE = SR0.R0_TPVALE
            and RFO.RFO_CODIGO = SR0.R0_CODIGO
        left join SRN010 SRN (nolock)
            on SRN.D_E_L_E_T_ = ''
            and SRN.RN_FILIAL = substring(SR0.R0_FILIAL, 1, 4)
            and SRN.RN_COD = SR0.R0_CODIGO
    where SR0.D_E_L_E_T_ = ''
    group by
        SRA.RA_FILIAL,
        SRA.RA_MAT,
        SRA.RA_NOME,
        SRJ.RJ_DESC,
        SRA.RA_MUNICIP,
        SRA.RA_ESTADO,
        SRA.RA_ADMISSA,
        SRA.RA_SITFOLH,
        CTT.CTT_CUSTO,
        CTT.CTT_DESC01,
        CTD.CTD_ITEM,
        CTD.CTD_DESC01,
        SQB.QB_DEPTO,
        SQB.QB_DESCRIC,
        SRJ.RJ_CODCBO,
        SRA.RA_SEXO,
        SRA.RA_CIC,
        SR0.R0_PERIOD,
        SR0.R0_TPBEN

union

    select /* outros benefícios atual */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as AT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

        RIQ.RIQ_PERIOD as PERIODO,

        case RIS.RIS_TPBENE when 81 then 'CESTA' when 84 then 'CESTA' else null end as BENEFICIO,
        count(distinct SRA.RA_MAT) as contador

    from RIQ010 RIQ (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = RIQ.RIQ_FILIAL
            and SRA.RA_MAT = RIQ.RIQ_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
            inner join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_CUSTO = SRA.RA_CC
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM
        
        inner join RIS010 RIS (nolock)
            on RIS.D_E_L_E_T_ = ''
            and RIS.RIS_TPBENE = RIQ.RIQ_TPBENE
            and RIS.RIS_COD = RIQ.RIQ_COD
    where RIQ.D_E_L_E_T_ = ''
    group by
        SRA.RA_FILIAL,
        SRA.RA_MAT,
        SRA.RA_NOME,
        SRJ.RJ_DESC,
        SRA.RA_MUNICIP,
        SRA.RA_ESTADO,
        SRA.RA_ADMISSA,
        SRA.RA_SITFOLH,
        CTT.CTT_CUSTO,
        CTT.CTT_DESC01,
        CTD.CTD_ITEM,
        CTD.CTD_DESC01,
        SQB.QB_DEPTO,
        SQB.QB_DESCRIC,
        SRJ.RJ_CODCBO,
        SRA.RA_SEXO,
        SRA.RA_CIC,
        RIQ.RIQ_PERIOD,
        RIS.RIS_TPBENE
