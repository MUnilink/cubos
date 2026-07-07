with
(
    select
        SPI010.PI_FILIAL,
        SPI010.PI_MAT,
        SPI010.PI_PD,
        SPI010.PI_CC,
        SPI010.PI_QUANT,
        SPI010.PI_QUANTV,
        case when SPI010.PI_PD in ('021', '022') then 0.0 else SPI010.PI_QUANT end as HORAS
    from SPI010 (nolock)
    where SPI010.D_E_L_E_T_ = ''
) as SPI
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

        cast(SPI.PI_DATA as date) as DATA,
        left(SPI.PI_DATA, 6) as PERIODO,

        cast(SPI.HORAS * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end as numeric(15, 2)) as 'Horas Calculadas',

        case SP9.P9_TIPOCOD
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_EVENTO,
        trim(SPI.PI_PD) as COD_EVENTO,
        trim(SP9.P9_DESC) as DESC_EVENTO

    from SPI (nolock)
        inner join SP9010 SP9 (nolock)
            on SP9.D_E_L_E_T_ = ''
            and SP9.P9_CODIGO = SPI.PI_PD
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SPI.PI_CC
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_MAT = SPI.PI_MAT
            and SRA.RA_FILIAL = SPI.PI_FILIAL
            
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
            
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM
    where SPI.D_E_L_E_T_ = ''