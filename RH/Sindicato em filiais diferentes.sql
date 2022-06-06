select
	SRA010.RA_FILIAL,
	SRA010.RA_MAT,
	SRA010.RA_NOME,
	SRA010.RA_SINDICA,
	SRA010.RA_PGCTSIN,
	SRA010.RA_MENSIND,
	RCE010.RCE_DESCRI,
	RCE010.RCE_ENDER,
	RCE010.RCE_BAIRRO,

	cast(FOLHA.RD_DATPGT as date) as DATA_PAGAMENTO,
    substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
    substring(FOLHA.RD_PERIODO, 5, 2) as PERIODO_MES,
    cast(FOLHA.RD_DTREF as date) as DATA_REFERENCIA,
    FOLHA.RD_PERIODO as PERIODO,

    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('343')
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
    ) as CONT_1,
        (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('407')
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
    ) as CONT_2,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRD010.RD_PD = SRV010.RV_COD
        where
                SRD010.RD_PD in ('980')
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
    ) as CONT_3
from SRA010 (nolock)
	inner join RCE010 (nolock)
		on RCE010.D_E_L_E_T_ = ''
		and RCE010.RCE_CODIGO = SRA010.RA_SINDICA
		and substring(SRA010.RA_FILIAL, 1, 4) = RCE010.RCE_FILIAL
	inner join SRD010 as FOLHA (nolock)
		on  FOLHA.D_E_L_E_T_ = ''
		and FOLHA.RD_FILIAL = SRA010.RA_FILIAL
		and FOLHA.RD_MAT = SRA010.RA_MAT
where
		SRA010.D_E_L_E_T_ = ''
