select
	trim(SRA010.RA_FILIAL) as FILIAL,
	trim(SRA010.RA_MAT) as MATRICULA,
	trim(SRA010.RA_NOME) as NOME,
	trim(SRJ010.RJ_DESC) as FUNCAO,
	cast(trim(SRA010.RA_ADMISSA) as date) as ADMISSAO,
	trim(CTT010.CTT_DESC01) as CENTRO_CUSTO,
	case when trim(SRA010.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
    substring(FOLHA.RD_PERIODO, 5, 2) as PERIODO_MES,

	(
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('738')
            and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
            and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
            and SRD010.RD_MAT = FOLHA.RD_MAT
            and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
            and SRD010.RD_PD = FOLHA.RD_PD 
            and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
            and SRD010.RD_SEQ = FOLHA.RD_SEQ 
            and SRD010.RD_CC = FOLHA.RD_CC
            and SRD010.RD_PROCES = FOLHA.RD_PROCES
    ) as EMPRESA,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('565')
            and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
            and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
            and SRD010.RD_MAT = FOLHA.RD_MAT
            and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
            and SRD010.RD_PD = FOLHA.RD_PD 
            and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
            and SRD010.RD_SEQ = FOLHA.RD_SEQ 
            and SRD010.RD_CC = FOLHA.RD_CC
            and SRD010.RD_PROCES = FOLHA.RD_PROCES
    ) as AGREGADO,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('565')
            and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
            and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
            and SRD010.RD_MAT = FOLHA.RD_MAT
            and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
            and SRD010.RD_PD = FOLHA.RD_PD 
            and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
            and SRD010.RD_SEQ = FOLHA.RD_SEQ 
            and SRD010.RD_CC = FOLHA.RD_CC
            and SRD010.RD_PROCES = FOLHA.RD_PROCES
    ) as FUNCIONARIO,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('565', '738')
            and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
            and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
            and SRD010.RD_MAT = FOLHA.RD_MAT
            and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
            and SRD010.RD_PD = FOLHA.RD_PD 
            and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
            and SRD010.RD_SEQ = FOLHA.RD_SEQ
            and SRD010.RD_CC = FOLHA.RD_CC
            and SRD010.RD_PROCES = FOLHA.RD_PROCES
    ) as TOTAL
from SRD010 as FOLHA (nolock)
	inner join SRA010 (nolock)
		on SRA010.D_E_L_E_T_ = ''
		and FOLHA.RD_FILIAL = SRA010.RA_FILIAL
		and FOLHA.RD_MAT = SRA010.RA_MAT
	inner join SRJ010 (nolock)
		on SRJ010.D_E_L_E_T_ = ''
		and substring(SRA010.RA_FILIAL, 1, 4) = SRJ010.RJ_FILIAL
        and SRA010.RA_CODFUNC = SRJ010.RJ_FUNCAO
    inner join CTT010 (nolock)
    	on CTT010.D_E_L_E_T_ = ''
    	and substring(SRA010.RA_FILIAL, 1, 4) = CTT010.CTT_FILIAL
    	and SRA010.RA_CC = CTT010.CTT_CUSTO
where
		FOLHA.D_E_L_E_T_ = ''