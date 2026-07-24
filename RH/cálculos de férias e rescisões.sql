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

    case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
    
    SRV.RV_COD as VERBA,
    trim(SRV.RV_DESC) as DESC_VERBA1,
    case SRV.RV_COD
        when '183' then 'VALOR A RECEBER'
        when '999' then 'VALOR A RECEBER'
    else trim(SRV.RV_DESCDET) end as DESC_VERBA2,

    case trim(SRV.RV_TIPOCOD)
        when '1' then 'PROVENTO'
        when '2' then 'DESCONTO'
        when '3' then 'BASE PROVENTO'
        when '4' then 'BASE DESCONTO'
        else '-'
    end as TIPO_VERBA,

    cast(SRR.RR_DATAPAG as date) as DT_PAGAMENT,
    cast(SRG.RG_DTAVISO as date) as DT_AVISOPRE,
    cast(SRG.RG_DATAHOM as date) as DT_HOMOLOGA,
    cast(SRG.RG_DATADEM as date) as DT_DEMISSAO,
    cast(SRG.RG_DTPROAV as date) as DT_PROJAVIS,
    cast(SRG.RG_DTGERAR as date) as DT_GERAFOLH,
    cast(SRR.RR_DATA as date) as DT_GERACALC,
    SRG.RG_RESCDIS as FASE_RESCISAO,
    concat(trim(SRG.RG_TIPORES), ' - ', (select trim(substring(RCC010.RCC_CONTEU, 2, 32)) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S043' and left(RCC010.RCC_CONTEU, 2) = trim(SRG.RG_TIPORES))) as TIPO_RESCISAO,
    
    trim(SRG.RG_OBS) as OBS,
    SRG.RG_DAVCUM as DIAS_REC_CUMPRIDO,
    SRG.RG_DAVIND as DIAS_REC_INDENIZADO,
    SRG.RG_DAVISO as DIAS_REC,
    SRG.RG_DFERPRO as DIAS_FER_PROP,
    SRG.RG_DFERVEN as DIAS_FER_VENC,
    SRG.RG_DFERAVI as DIAS_FER_AVIS,
    
    case when SRV.RV_TIPOCOD = 2 then SRR.RR_VALOR*-1 else SRR.RR_VALOR end as VALOR,
    concat(trim(SRR.RR_ROTEIR), ' - ', (select trim(SRY010.RY_DESC) from SRY010 where SRY010.D_E_L_E_T_ = '' and SRY010.RY_CALCULO = SRR.RR_ROTEIR)) as ROTEIRO,
    trim(SRR.RR_CODB1T) as SEQ_LANC,
    SRR.RR_HORAS as HORAS,
    SRR.RR_PERIODO as PERIODO,
    SRR.RR_SEQ as SEQ
    
from SRR010 SRR (nolock)
    left join SRG010 SRG (nolock)
        on SRG.D_E_L_E_T_ = ''
        and SRG.RG_FILIAL = SRR.RR_FILIAL
        and SRG.RG_MAT = SRR.RR_MAT
        and SRG.RG_DTGERAR = SRR.RR_DATA
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRR.RR_FILIAL
        and SRA.RA_MAT = SRR.RR_MAT

        left join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        left join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

            left join SQ3010 SQ3 (nolock)
                on SQ3.D_E_L_E_T_ = ''
                and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRR.RR_CC
        left join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRR.RR_ITEM
    left join SRV010 SRV (nolock)
        on SRV.D_E_L_E_T_ = ''
        and SRR.RR_PD = SRV.RV_COD
where SRR.D_E_L_E_T_ = ''
