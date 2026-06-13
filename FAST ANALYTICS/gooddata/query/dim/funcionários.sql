    select
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        concat(trim(SRA.RA_FILIAL), trim(SRA.RA_MAT)) as ID_FUNCIONARIO,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME
    from SRA010 SRA
    where SRA.D_E_L_E_T_ = ''
union select null, null, null, null
