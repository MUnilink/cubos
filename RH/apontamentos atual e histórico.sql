    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

        SPH.PH_PD as EVENTO,
        concat(SPH.PH_PD, ' - ', (select trim(SP9010.P9_DESC) from SP9010 (nolock) where SP9010.D_E_L_E_T_ = '' and SP9010.P9_CODIGO = SPH.PH_PD)) as DESC_EVENTO,
        cast(SPH.PH_DATA as date) as DATA,
        left(SPH.PH_DATA, 6) as PERIODO,
        cast(floor(SPH.PH_QUANTC) as int) as HORAS,
        cast((SPH.PH_QUANTC - floor(SPH.PH_QUANTC))*6,0.0 as numeric(15,2)) as MINUTOS
        cast(SPH.PH_QUANTC as numeric(15, 2)) as QTD
    from SPH010 SPH (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SPH.PH_FILIAL
            and SRA.RA_MAT = SPH.PH_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
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
    where SPH.D_E_L_E_T_ = ''
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

        SPC.PC_PD as EVENTO,
        concat(SPC.PC_PD, ' - ', (select trim(SP9010.P9_DESC) from SP9010 (nolock) where SP9010.D_E_L_E_T_ = '' and SP9010.P9_CODIGO = SPC.PC_PD)) as DESC_EVENTO,
        cast(SPC.PC_DATA as date) as DATA,
        left(SPC.PC_DATA, 6) as PERIODO,
        cast(floor(SPC.PC_QUANTC) as int) as HORAS,
        cast((SPC.PC_QUANTC - floor(SPC.PC_QUANTC))*6,0.0 as numeric(15,2)) as MINUTOS
        cast(SPC.PC_QUANTC as numeric(15, 2)) as QTD
    from SPC010 SPC (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SPC.PC_FILIAL
            and SRA.RA_MAT = SPC.PC_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
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
    where SPC.D_E_L_E_T_ = ''
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

        SRD.RD_PD as EVENTO,
        concat(SRD.RD_PD, ' - ', (select coalesce(nullif(trim(SRV010.RV_DESCDET), ''), trim(SRV010.RV_DESC)) from SRV010 (nolock) where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD)) as DESC_EVENTO,
        null as DATA,
        SRD.RD_DATARQ as PERIODO,
        0.0 as HORAS,
        0.0 as MINUTOS,
        case when SRD.RD_PD = '990' then SRA.RA_HRSMES else cast(SRD.RD_HORAS as numeric(15, 2)) end as QTD
    from SRD010 SRD (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
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
    where
            SRD.RD_PD in ('990', '051')
        and SRD.D_E_L_E_T_ = ''
