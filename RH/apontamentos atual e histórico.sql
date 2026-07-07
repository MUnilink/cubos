    select
        trim(SRA.RA_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        SRA.RA_SITFOLH as SITUACAO,
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

        case SP9.P9_TIPOCOD
            when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_EVENTO,
        null as IDVERBA,
        null as IDVERBA_NOME,
        
        (select top 1 last_value(trim(SR6010.R6_DESC)) over(partition by SPF010.PF_FILIAL, SPF010.PF_MAT order by SPF010.PF_DATA) from SR6010 inner join SPF010 on SPF010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF010.PF_TURNOPA where SR6010.D_E_L_E_T_ = '' and SPF010.PF_FILIAL = SPH.PH_FILIAL and SPF010.PF_MAT = SPH.PH_MAT and SPF010.PF_DATA <= SPH.PH_DATA) as TURNO_DES,
        trim(SPH.PH_PD) as COD_EVENTO,
        trim(SP9.P9_DESC) as DESC_EVENTO,
        trim(SPH.PH_ABONO) as COD_MOTIVO,
        (select trim(SP6010.P6_DESC) from SP6010 where SP6010.D_E_L_E_T_ = '' and SP6010.P6_CODIGO = SPH.PH_ABONO) as DESC_MOTIVO,
        cast(SPH.PH_QUANTC as numeric(15, 2)) as QTD_EVENTO,
        cast(SPH.PH_QTABONO as numeric(15, 2)) as QTD_ABONO,
        cast(SPH.PH_DATA as date) as DATA,
        left(SPH.PH_DATA, 6) as PERIODO,
        cast(floor(SPH.PH_QUANTC) as int) as HORAS,
        cast((SPH.PH_QUANTC - floor(SPH.PH_QUANTC))*60.0 as numeric(15,2)) as MINUTOS,
        cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end as QTD,
        'PONTO HIST' as TIPO_PONTO
    from SPH010 SPH (nolock)
        inner join SP9010 SP9 (nolock)
            on SP9.D_E_L_E_T_ = ''
            and SP9.P9_CODIGO = SPH.PH_PD
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
    where
            datediff(month, SPH.PH_DATA, getdate()) < 4
        and SPH.D_E_L_E_T_ = ''
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        SRA.RA_SITFOLH as SITUACAO,
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

        case SP9.P9_TIPOCOD
            when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_EVENTO,
        null as IDVERBA,
        null as IDVERBA_NOME,
        
        (select top 1 last_value(trim(SR6010.R6_DESC)) over(partition by SPF010.PF_FILIAL, SPF010.PF_MAT order by SPF010.PF_DATA) from SR6010 inner join SPF010 on SPF010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF010.PF_TURNOPA where SR6010.D_E_L_E_T_ = '' and SPF010.PF_FILIAL = SPC.PC_FILIAL and SPF010.PF_MAT = SPC.PC_MAT and SPF010.PF_DATA <= SPC.PC_DATA) as TURNO_DES,
        trim(SPC.PC_PD) as COD_EVENTO,
        trim(SP9.P9_DESC) as DESC_EVENTO,
        trim(SPC.PC_ABONO) as COD_MOTIVO,
        (select trim(SP6010.P6_DESC) from SP6010 where SP6010.D_E_L_E_T_ = '' and SP6010.P6_CODIGO = SPC.PC_ABONO) as DESC_MOTIVO,
        cast(SPC.PC_QUANTC as numeric(15, 2)) as QTD_EVENTO,
        cast(SPC.PC_QTABONO as numeric(15, 2)) as QTD_ABONO,
        cast(SPC.PC_DATA as date) as DATA,
        left(SPC.PC_DATA, 6) as PERIODO,
        cast(floor(SPC.PC_QUANTC) as int) as HORAS,
        cast((SPC.PC_QUANTC - floor(SPC.PC_QUANTC))*60.0 as numeric(15,2)) as MINUTOS,
        cast(SPC.PC_QUANTC - SPC.PC_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end as QTD,
        'PONTO ATUAL' as TIPO_PONTO
    from SPC010 SPC (nolock)
        inner join SP9010 SP9 (nolock)
            on SP9.D_E_L_E_T_ = ''
            and SP9.P9_CODIGO = SPC.PC_PD
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
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SQ3.Q3_DESCSUM) as CARGO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        SRA.RA_SITFOLH as SITUACAO,
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

        case SRV.RV_TIPOCOD
            when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_EVENTO,
        trim(RCN.RCN_CODIGO) as IDVERBA,
        trim(RCN.RCN_DESCRI) as IDVERBA_NOME,
        
        (select top 1 last_value(trim(SR6010.R6_DESC)) over(partition by SPF010.PF_FILIAL, SPF010.PF_MAT order by SPF010.PF_DATA) from SR6010 inner join SPF010 on SPF010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF010.PF_TURNOPA where SR6010.D_E_L_E_T_ = '' and SPF010.PF_FILIAL = SRD.RD_FILIAL and SPF010.PF_MAT = SRD.RD_MAT and PF_DATA <= concat(SRD.RD_DATARQ, '01')) as TURNO_DES,
        trim(SRD.RD_PD) as COD_EVENTO,
        coalesce(nullif(trim(SRV.RV_DESCDET), ''), trim(SRV.RV_DESC)) as DESC_EVENTO,
        null as COD_MOTIVO,
        null as DESC_MOTIVO,
        null as QTD_EVENTO,
        null as QTD_ABONO,
        cast(concat(SRD.RD_DATARQ, '01') as date) as DATA,
        SRD.RD_DATARQ as PERIODO,
        0.0 as HORAS,
        0.0 as MINUTOS,
        cast(case when SRD.RD_PD = '990' then SRA.RA_HRSMES else SRD.RD_HORAS * SRA.RA_HRSMES/30.0 end as numeric(15 ,2)) * case when SRV.RV_TIPOCOD = 2 or exists(select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD) then -1 else 1 end as QTD,
        'FOLHA' as TIPO_PONTO
    from SRD010 SRD (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = SRD.RD_PD
            and
            (
                SRV.RV_COD = '990'
                or SRV.RV_COD in (select SP9010.P9_CODFOL from SP9010 where SP9010.D_E_L_E_T_ = '')
                or SRV.RV_COD in (select RCM010.RCM_PD from RCM010 where RCM010.D_E_L_E_T_ = '')
            )

            left join RCN010 RCN (nolock)
				on RCN.D_E_L_E_T_ = ''
				and RCN.RCN_CODIGO = SRV.RV_CODFOL

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
            datediff(month, concat(SRD.RD_DATARQ, '01'), getdate()) < 4
        and SRD.D_E_L_E_T_ = ''
