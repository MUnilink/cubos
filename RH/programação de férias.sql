select
    trim(SRA.RA_FILIAL) as FILIAL,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    cast(SRA.RA_DEMISSA as date) as DEMISSAO,
    cast(SRA.RA_NASC as date) as NASCIMENTO,
    cast(SRA.RA_DTFIMCT as date) as FIM_CONTRATO,
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
    
    SRF.RF_STATUS as STATUS,
    cast(SRF.RF_DATABAS as date) as DTINI_PERAQUIS,
    cast(SRF.RF_DATAFIM as date) as DTFIM_PERAQUIS,
    left(SRF.RF_DATABAS, 6) as INI_PERAQUIS,
    left(SRF.RF_DATAFIM, 6) as FIM_PERAQUIS,
    trim(SRF.RF_TEMABPE) as ABONOPEC,
    trim(SRF.RF_ABOPEC) as PERABONO,
    SRF.RF_DFERAAT as DIAS_PROPORC,
    SRF.RF_DFERVAT as DIAS_VENCIDAS,
    SRF.RF_DVENPEN as DIAS_VENCPEND,
    SRF.RF_DFERANT as DIAS_PAGOS,

    cast(SRF.RF_DATAINI as date) as INI_FERIAS_1,
    SRF.RF_DFEPRO1 as DIAS_FERIAS_1,
    SRF.RF_DABPRO1 as ABONO_FERIAS_1,
    cast(SRF.RF_DATINI2 as date) as INI_FERIAS_2,
    SRF.RF_DFEPRO2 as DIAS_FERIAS_2,
    SRF.RF_DABPRO2 as ABONO_FERIAS_2,
    cast(SRF.RF_DATINI3 as date) as INI_FERIAS_3,
    SRF.RF_DFEPRO3 as DIAS_FERIAS_3,
    SRF.RF_DABPRO3 as ABONO_FERIAS_3,

    case when right(SRF.RF_FILIAL, 1) = 1 then dateadd(month, 21, SRF.RF_DATABAS) else dateadd(month, 22, SRF.RF_DATABAS) end as DATA_MAXIMA,
    coalesce(nullif(trim(SRF.RF_OBSERVA), ''), nullif(trim(SRF.RF_OBS), '')) as OBS

from SRF010 SRF (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRF.RF_FILIAL
        and SRA.RA_MAT = SRF.RF_MAT

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
        SRF.D_E_L_E_T_ = ''
    and SRF.RF_DATAFIM > '20201231'
