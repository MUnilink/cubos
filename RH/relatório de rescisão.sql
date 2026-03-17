select
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
    trim(SRA.RA_ESTADO) as UF,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    cast(SRA.RA_NASC as date) as NASCIMENTO,
    SRA.RA_SITFOLH as SITUACAO,
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
    trim(SRA.RA_PIS) as PIS,
    trim(SRA.RA_NUMCP) as CTPS,
    trim(SRA.RA_CATFUNC) as COD_TRAB,
    concat(trim(SRA.RA_CATFUNC), ' - ', (select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_CATFUNC and SX5010.X5_TABELA = '28')) as DESC_TRAB,

    cast(SRR.RR_DATAPAG as date) as DT_PAGAMENT,
    cast(SRG.RG_DTAVISO as date) as DT_AVISOPRE,
    cast(SRG.RG_DATAHOM as date) as DT_HOMOLOGA,
    cast(SRG.RG_DATADEM as date) as DT_DEMISSAO,
    cast(SRG.RG_DTGERAR as date) as DT_GERACAOF,
    cast(SRG.RG_DTPROAV as date) as DT_PROJAVIS,
    
    trim(SRG.RG_TIPORES) as COD_RESCISAO,
    (select trim(substring(RCC010.RCC_CONTEU, 3, 32)) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S043' and left(RCC010.RCC_CONTEU, 2) = trim(SRG.RG_TIPORES)) as DESC_RESCISAO,
    trim(RCE.RCE_DESCRI) as SINDICATO,
    trim(SRG.RG_OBS) as OBS,
    
    SRG.RG_DAVCUM as DIAS_REC_CUMPRIDO,
    SRG.RG_DAVIND as DIAS_REC_INDENIZADO,
    SRG.RG_DAVISO as DIAS_REC,
    SRG.RG_DFERPRO as DIAS_FER_PROP,
    SRG.RG_DFERVEN as DIAS_FER_VENC,
    SRG.RG_DFERAVI as DIAS_FER_AVIS,
    
    SRA.RA_SALARIO as SALARIO,
    case when SRV.RV_COD = '490' then SRR.RR_VALOR end as VALOR_LIQ,
    case when SRV.RV_TIPOCOD = '1' then SRR.RR_VALOR end as VALOR_PROV,
    case when SRV.RV_TIPOCOD = '2' and SRV.RV_COD != '490' then SRR.RR_VALOR end as VALOR_DESC,
    case when SRV.RV_TIPOCOD = '3' then SRR.RR_VALOR end as VALOR_BASEPROV,
    case when SRV.RV_TIPOCOD = '4' then SRR.RR_VALOR end as VALOR_BASEDESC,
    
    case when SRV.RV_TIPOCOD = '1' then trim(SRV.RV_DESC) end as DESC_PROV,
    case when SRV.RV_TIPOCOD = '2' and SRV.RV_COD != '490' then trim(SRV.RV_DESC) end as DESC_DESC,
    case when SRV.RV_TIPOCOD = '3' then trim(SRV.RV_DESC) end as DESC_BASEPROV,
    case when SRV.RV_TIPOCOD = '4' then trim(SRV.RV_DESC) end as DESC_BASEDESC,

    case when SRV.RV_TIPOCOD = '1' then trim(SRV.RV_COD) end as COD_PROV,
    case when SRV.RV_TIPOCOD = '2' and SRV.RV_COD != '490' then trim(SRV.RV_COD) end as COD_DESC,
    case when SRV.RV_TIPOCOD = '3' then trim(SRV.RV_COD) end as COD_BASEPROV,
    case when SRV.RV_TIPOCOD = '4' then trim(SRV.RV_COD) end as COD_BASEDESC,
    
    SRR.RR_HORAS as HORAS,
    SRR.RR_PERIODO as PERIODO,
    SRR.RR_SEQ as SEQ,
    case SRV.RV_COD when '490' then 'ZZZZ' else concat(SRV.RV_TIPOCOD, SRV.RV_COD) end as ID_VERBA
    
from SRR010 SRR (nolock)
    left join SRG010 SRG (nolock)
        on SRG.D_E_L_E_T_ = ''
        and SRG.RG_FILIAL = SRR.RR_FILIAL
        and SRG.RG_MAT = SRR.RR_MAT
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRR.RR_FILIAL
        and SRA.RA_MAT = SRR.RR_MAT

        left join RCE010 RCE (nolock)
            on RCE.D_E_L_E_T_ = ''
            and RCE.RCE_CODIGO = SRA.RA_SINDICA
            and RCE.RCE_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
        left join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        left join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
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
        and substring(SRR.RR_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRR.RR_PD = SRV.RV_COD
where
        SRR.D_E_L_E_T_ = ''
    and SRR.RR_ROTEIR = 'RES'
    and SRR.RR_MAT =:FILTROPARAMETRO
order by ID_VERBA
