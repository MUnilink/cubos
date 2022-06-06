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

    substring(FOLHA.RC_PERIODO, 1, 4) as PERIODO_ANO,
    substring(FOLHA.RC_PERIODO, 5, 2) as PERIODO_MES,
    cast(FOLHA.RC_DTREF as date) as DATA_REFERENCIA,
    FOLHA.RC_PERIODO as PERIODO,

    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('343')
            and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD 
            and SRC010.RC_SEMANA = FOLHA.RC_SEMANA 
            and SRC010.RC_SEQ = FOLHA.RC_SEQ 
            and SRC010.RC_CC = FOLHA.RC_CC
            and SRC010.RC_PROCES = FOLHA.RC_PROCES
    ) as CONT_1,
        (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('407')
            and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD 
            and SRC010.RC_SEMANA = FOLHA.RC_SEMANA 
            and SRC010.RC_SEQ = FOLHA.RC_SEQ 
            and SRC010.RC_CC = FOLHA.RC_CC
            and SRC010.RC_PROCES = FOLHA.RC_PROCES
    ) as CONT_2,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('980')
            and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD 
            and SRC010.RC_SEMANA = FOLHA.RC_SEMANA 
            and SRC010.RC_SEQ = FOLHA.RC_SEQ 
            and SRC010.RC_CC = FOLHA.RC_CC
            and SRC010.RC_PROCES = FOLHA.RC_PROCES
    ) as CONT_3
from SRA010 (nolock)
	inner join RCE010 (nolock)
		on RCE010.D_E_L_E_T_ = ''
		and RCE010.RCE_CODIGO = SRA010.RA_SINDICA
		and substring(SRA010.RA_FILIAL, 1, 4) = RCE010.RCE_FILIAL
	inner join SRC010 as FOLHA (nolock)
		on  FOLHA.D_E_L_E_T_ = ''
		and FOLHA.RC_FILIAL = SRA010.RA_FILIAL
		and FOLHA.RC_MAT = SRA010.RA_MAT
where
		SRA010.D_E_L_E_T_ = ''
