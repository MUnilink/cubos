    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
        trim(SRA.RA_ESTADO) as UF,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        SRA.RA_SALARIO as SALARIO,

        SRE.RE_TRFUNID as ID_TRANSF,
        left(SRE.RE_DATA, 6) as PERIODO,
        cast(SRE.RE_DATA as date) as DATA,
        SRE.RE_EMPD as EMPRESA,
        SRE.RE_CCD as CC,
        SRE.RE_ITEMD as ITEM,
        SRE.RE_DEPTOD AS DEPTO,
        SRE.RE_PROCESD as PROCESSO,
        trim(CTT.CTT_DESC01) as DESC_CC,
        trim(CTD.CTD_DESC01) as DESC_ITEM,
        trim(SQB.QB_DESCRIC) as DESC_DEPTO
    from SRE010 SRE (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and left(SRA.RA_FILIAL, 2) = SRE.RE_EMPD
            and SRA.RA_FILIAL = SRE.RE_FILIALD
            and SRA.RA_MAT = SRE.RE_MATD
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRE.RE_CCD
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRE.RE_ITEMD
        inner join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_DEPTO = SRE.RE_DEPTOD
    where SRE.D_E_L_E_T_ = ''
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
        trim(SRA.RA_ESTADO) as UF,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        SRA.RA_SALARIO as SALARIO,

        SRE.RE_TRFUNID as ID_TRANSF,
        left(SRE.RE_DATA, 6) as PERIODO,
        cast(SRE.RE_DATA as date) as DATA,
        SRE.RE_EMPP as EMPRESA,
        SRE.RE_CCP as CC,
        SRE.RE_ITEMP as ITEM,
        SRE.RE_DEPTOP AS DEPTO,
        SRE.RE_PROCESP as PROCESSO,
        trim(CTT.CTT_DESC01) as DESC_CC,
        trim(CTD.CTD_DESC01) as DESC_ITEM,
        trim(SQB.QB_DESCRIC) as DESC_DEPTO
    from SRE010 SRE (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and left(SRA.RA_FILIAL, 2) = SRE.RE_EMPP
            and SRA.RA_FILIAL = SRE.RE_FILIALP
            and SRA.RA_MAT = SRE.RE_MATP
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRE.RE_CCP
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRE.RE_ITEMP
        inner join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_DEPTO = SRE.RE_DEPTOP
    where SRE.D_E_L_E_T_ = ''
