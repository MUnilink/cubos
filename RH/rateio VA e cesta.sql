    select /* VA */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
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
            inner join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_CUSTO = SRA.RA_CC
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM
        
        inner join RFO010 RFO (nolock)
            on RFO.D_E_L_E_T_ = ''
            and RFO.RFO_TPVALE = SR0.R0_TPVALE
            and RFO.RFO_CODIGO = SR0.R0_CODIGO
    where SR0.D_E_L_E_T_ = ''

union

    select /* CESTA */
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
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

        RIS.RIS_TPBENE as ,
        RIS.RIS_COD as ,
        RIS.RIS_DESC as ,
        RIS.RIS_REF as ,
        RIS.RIS_FUNCP as ,
        RIS.RIS_TPDESC as ,
        RIS.RIS_FUNCD as ,
        RIS.RIS_EMP as ,
        RIS.RIS_MINIMO as ,
        RIS.RIS_MAXIMO as ,
        RIS.RIS_PD as ,
        RIS.RIS_PD1 as ,
        RIS.RIS_PD2 as ,

        RI1.RI1_MAT as CESTA_FUNC,
        RI1.RI1_TABELA as ,
        RI1.RI1_DINIPG as ,
        RI1.RI1_DFIMPG as 

    from RI1010 RI1 (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = RI1.RI1_FILIAL
            and SRA.RA_MAT = RI1.RI1_MAT

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
            and RIS.RIS_TPBENE = RI1.RI1_BENEF
            and RIS.RIS_COD = RI1.RI1_TABELA
    where RI1.D_E_L_E_T_ = ''
