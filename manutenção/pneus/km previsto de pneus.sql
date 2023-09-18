select
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	ST9.T9_STATUS as STATUS,
	ST9.T9_CONTACU as CONT_ACUM,
	ST9.T9_VALCPA as T9_VALCPA,
	convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
    
    trim(isnull(TQT.TQT_DESMED, '-')) as MEDIDA,
    ST7.T7_NOME as FABRICANTE,
	ST9.T9_SITBEM as SITUACAO,
    TQR.TQR_TIPMOD,
    TQR.TQR_DESMOD as MODELO,
    TQX.TQX_KMESPO as km_ESPERADO

from TQS010 TQS (nolock)
    left join TQX010 TQX (nolock)
        on TQX.D_E_L_E_T_ = ''
        and TQX.TQX_MEDIDA = TQS.TQS_MEDIDA
        
        left join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQX.TQX_MEDIDA
        left join TQR010 TQR (nolock)
            on TQR.D_E_L_E_T_ = ''
            and TQR.TQR_TIPMOD = TQX.TQX_TIPMOD
            
            left join ST7010 ST7 (nolock)
                on ST7.D_E_L_E_T_ = ''
                and ST7.T7_FABRICA = TQR.TQR_FABRIC
	
    inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
where
		TQS.D_E_L_E_T_ = ''
