    select /* benefícios atual */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
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

        SR0.R0_TPBEN as TIPO_BENEFICIO,
        SR0.R0_CODIGO as COD_BENEFICIO,
        isnull(RFO.RFO_DESCR, SRN.RN_DESC) as DESC_BENEFICIO,
        SR0.R0_VALCAL as REFERENCIA,
        RFO.RFO_PERC as PERC_FUNC,
        SR0.R0_VLRFUNC as VALOR_FUNC,
        null as TIPO_DESC,
        null as PERC_EMPR,
        null as DESC_MINIMO,
        RFO.RFO_TETO as DESC_MAXIMO,
        null as VERBA,
        null as VERBA_DESC,
        null as VERBA_EMPR,

        null as INI_PGTO,
        null as FIM_PGTO,

        SR0.R0_DIASPRO as DIAS_CALCULO,
        SR0.R0_DPROPIN as DIAS_PROPORC,
        SR0.R0_QDIAINF as QTDVALE_DIASUTEIS,
        SR0.R0_QDNUTIL as QTDVALE_DIASNUTEIS,
        SR0.R0_DUTILM as DIAS_UTEISMES,
        SR0.R0_DNUTIM as DIAS_NUTEISMES,
        SR0.R0_QDIACAL as DIAS_CALCULADA,
        SR0.R0_QDIADIF as DIAS_DIFERENCA,
        SR0.R0_VLRVALE as VALOR_UNIT,
        SR0.R0_VLREMP as VALOR_EMPR,
        SR0.R0_FERIAS as FERIAS,
        
        SR0.R0_MAT as contador_lanc,
        case when lag(SR0.R0_MAT, 1, 0) over (partition by SR0.R0_FILIAL, SR0.R0_PERIOD, SR0.R0_MAT order by SR0.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

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

union

    select /* outros benefícios atual */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
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

        case RIQ.RIQ_TPBENE when 81 then 'CESTA' when 84 then 'CESTA' else null end as BENEFICIO,

        RIS.RIS_TPBENE as TIPO_BENEFICIO,
        RIS.RIS_COD as COD_BENEFICIO,
        RIS.RIS_DESC as DESC_BENEFICIO,
        RIS.RIS_REF as REFERENCIA,
        RIS.RIS_FUNCP as PERC_FUNC,
        RIS.RIS_FUNCD as VALOR_FUNC,

        RIS.RIS_TPDESC as TIPO_DESC,
        RIS.RIS_EMP as PERC_EMPR,
        RIS.RIS_MINIMO as DESC_MINIMO,
        RIS.RIS_MAXIMO as DESC_MAXIMO,
        RIS.RIS_PD as VERBA,
        RIS.RIS_PD1 as VERBA_DESC,
        RIS.RIS_PD2 as VERBA_EMPR,
        null as INI_PGTO,
        null as FIM_PGTO,

        null as DIAS_CALCULO,
        null as DIAS_PROPORC,
        null as QTDVALE_DIASUTEIS,
        null as QTDVALE_DIASNUTEIS,
        null as DIAS_UTEISMES,
        null as DIAS_NUTEISMES,
        null as DIAS_CALCULADA,
        null as DIAS_DIFERENCA,
        null as VALOR_UNIT,
        null as VALOR_EMPR,
        null as FERIAS,
        
        RIQ.RIQ_MAT as contador_lanc,
        case when lag(RIQ.RIQ_MAT, 1, 0) over (partition by RIQ.RIQ_FILIAL, RIQ.RIQ_PERIOD, RIQ.RIQ_MAT order by RIQ.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

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

union

    select /* benefícios histórico */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
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
        
        RG2.RG2_PERIOD as PERIODO,
        
        case RG2.RG2_TPBEN when 1 then 'TRANSPORTE' when 2 then 'ALIMENTAÇÃO' else null end as BENEFICIO,

        RG2.RG2_TPBEN as TIPO_BENEFICIO,
        RG2.RG2_CODIGO as COD_BENEFICIO,
        isnull(RFO.RFO_DESCR, SRN.RN_DESC) as DESC_BENEFICIO,
        RG2.RG2_VALCAL as REFERENCIA,
        RFO.RFO_PERC as PERC_FUNC,
        RG2.RG2_CUSFUN as VALOR_FUNC,
        null as TIPO_DESC,
        null as PERC_EMPR,
        null as DESC_MINIMO,
        RFO.RFO_TETO as DESC_MAXIMO,
        null as VERBA,
        null as VERBA_DESC,
        null as VERBA_EMPR,

        null as INI_PGTO,
        null as FIM_PGTO,

        null as DIAS_CALCULO,
        RG2.RG2_DIAPRO as DIAS_PROPORC,
        RG2.RG2_VTDUTE as QTDVALE_DIASUTEIS,
        RG2.RG2_VTDNUT as QTDVALE_DIASNUTEIS,
        RG2.RG2_DUTILM as DIAS_UTEISMES,
        RG2.RG2_DNUTIM as DIAS_NUTEISMES,
        RG2.RG2_DIACAL as DIAS_CALCULADA,
        null as DIAS_DIFERENCA,
        RG2.RG2_CUSUNI as VALOR_UNIT,
        RG2.RG2_CUSEMP as VALOR_EMPR,
        null as FERIAS,
        
        RG2.RG2_MAT as contador_lanc,
        case when lag(RG2.RG2_MAT, 1, 0) over (partition by RG2.RG2_FILIAL, RG2.RG2_PERIOD, RG2.RG2_MAT order by RG2.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

    from RG2010 RG2 (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = RG2.RG2_FILIAL
            and SRA.RA_MAT = RG2.RG2_MAT

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
            and CTT.CTT_CUSTO = RG2.RG2_CC
        left join RFO010 RFO (nolock)
            on RFO.D_E_L_E_T_ = ''
            and RFO.RFO_TPVALE = RG2.RG2_TPVALE
            and RFO.RFO_CODIGO = RG2.RG2_CODIGO
        left join SRN010 SRN (nolock)
            on SRN.D_E_L_E_T_ = ''
            and SRN.RN_FILIAL = substring(RG2.RG2_FILIAL, 1, 4)
            and SRN.RN_COD = RG2.RG2_CODIGO
    where RG2.D_E_L_E_T_ = ''
