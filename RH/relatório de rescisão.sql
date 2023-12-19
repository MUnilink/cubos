select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
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

    SRR.RR_PERIODO,
    SRR.RR_PD,

    trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
    case SRV.RV_COD
        when '183' then 'VALOR A RECEBER'
        when '999' then 'VALOR A RECEBER'
        when '490' then 'VALOR A RECEBER'
    else trim(SRV.RV_DESCDET) end as DESC_VERBA2,

    case trim(SRV.RV_TIPOCOD)
        when '1' then 'PROVENTO'
        when '2' then 'DESCONTO'
        when '3' then 'BASE PROVENTO'
        when '4' then 'BASE DESCONTO'
        else 'OUTROS'
    end as RV_TIPOCOD,

    convert(date, SRG.RG_DTAVISO, 103) as DT_AVISOPRE,
    convert(date, SRG.RG_DATAHOM, 103) as DT_HOMOLOGA,
    convert(date, SRG.RG_DATADEM, 103) as DT_DEMISSAO,
    convert(date, SRG.RG_DTGERAR, 103) as DT_GERACAOF,
    convert(date, SRG.RG_DTPROAV, 103) as DT_PROJAVIS,
    
    SRG.RG_DAVCUM as DIAS_AVISO_CUMPRIDO,
    SRG.RG_DAVIND as DIAS_AVISO_INDENIZADO,
    SRG.RG_DAVISO as DIAS_AVISO,
    SRG.RG_DFERPRO as DIAS_FER_PROPOR,
    SRG.RG_DFERVEN as DIAS_FER_VENCID,
    SRG.RG_DFERAVI as DIAS_FER_AVISO,
    
    SRG.RG_TIPORES,
    SRG.RG_OBS,
    SRR.RR_VALOR

from SRG010 SRG (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRG.RG_FILIAL
        and SRA.RA_MAT = SRG.RG_MAT

        inner join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
    
    inner join SRR010 SRR (nolock)
        on SRR.D_E_L_E_T_ = ''
        and SRR.RR_FILIAL = SRG.RG_FILIAL
        and SRR.RR_MAT = SRG.RG_MAT
        and SRR.RR_ROTEIR = 'RES'

        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRR.RR_CC
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
    	    and CTD.CTD_ITEM = SRR.RR_ITEM
        inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and SRV.RV_FILIAL = substring(SRR.RR_FILIAL, 1, 4)
			and SRV.RV_COD = SRR.RR_PD
where SRG.D_E_L_E_T_ = ''
