with SPI as
(
    select
        SPI010.PI_FILIAL,
        SPI010.PI_MAT,
        SPI010.PI_PD,
        SPI010.PI_CC,
        SPI010.PI_QUANTV,
        cast(SPI010.PI_DATA as date) as DATA,
        left(SPI010.PI_DATA, 6) as PERIODO,
        SPI010.PI_QUANT as VALOR,
        lag(SPI010.PI_QUANT, 1, 0.0) over(partition by SPI010.PI_FILIAL, SPI010.PI_MAT order by SPI010.PI_DATA) as VALOR_ANT,
        row_number() over(partition by SPI010.PI_FILIAL, SPI010.PI_MAT, SPI010.PI_DATA order by SPI010.PI_DATA) as SEQ,
        row_number() over(partition by SPI010.PI_FILIAL, SPI010.PI_MAT, SPI010.PI_DATA order by SPI010.PI_DATA) as QTD_EVENTOS,
        cast(SPI010.PI_QUANT * case SP9010.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end as numeric(15, 2)) as HORAS,
        case when SPI010.PI_PD in ('021', '022') then 1 else 0 end as RESET,

        case SP9010.P9_TIPOCOD
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_EVENTO,
        trim(SP9010.P9_DESC) as DESC_EVENTO
    from SPI010
        inner join SP9010
            on SP9010.D_E_L_E_T_ = ''
            and SP9010.P9_CODIGO = SPI010.PI_PD
    where SPI010.D_E_L_E_T_ = ''
)
select
    trim(SRA.RA_FILIAL) as FILIAL,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
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

    SPI.DATA,
    SPI.PERIODO,
    as 'Horas Calculadas',
    SPI.VALOR,
    SPI.VALOR_ANT,
    SPI.SEQ,

    SP9.TIPO_EVENTO,
    SPI.DESC_EVENTO

from SPI
    inner join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SPI.PI_CC
    inner join SRA010 SRA
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_MAT = SPI.PI_MAT
        and SRA.RA_FILIAL = SPI.PI_FILIAL
        
        inner join SQB010 SQB
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        inner join SRJ010 SRJ
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

            left join SQ3010 SQ3
                on SQ3.D_E_L_E_T_ = ''
                and SQ3.Q3_CARGO = SRJ.RJ_CARGO
        
        inner join CTD010 CTD
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM
