select
    RH_FILIAL,
    RH_MAT,
    RH_DATABAS,
    RH_DBASEAT,
    RH_DFERVEN,
    RH_DFERIAS,
    RH_DABONPE,
    RH_DFALTAS,
    RH_ABOPEC,
    RH_PERC13S,
    RH_DATAINI,
    RH_DATAFIM,
    RH_DTAVISO,
    RH_DTRECIB

from SRH010 SRH (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRH.RH_FILIAL
        and SRA.RA_MAT = SRH.RH_MAT

        inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and substring(SRA.RA_FILIAL, 1, 4) = SRJ.RJ_FILIAL
            and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and SRA.RA_CC = CTT.CTT_CUSTO
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
    	    and SRA.RA_ITEM = CTD.CTD_ITEM
where SRH.D_E_L_E_T_ = ''
