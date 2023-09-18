select    
    trim(isnull(TQT.TQT_DESMED, '-')) as MEDIDA,
    ST7.T7_NOME as FABRICANTE,
    TQR.TQR_TIPMOD,
    TQR.TQR_DESMOD as MODELO,
    TQX.TQX_KMESPO as km_ESPERADO

from TQX010 TQX (nolock)
    left join TQT010 TQT (nolock)
        on TQT.D_E_L_E_T_ = ''
        and TQT.TQT_MEDIDA = TQX.TQX_MEDIDA
    left join TQR010 TQR (nolock)
        on TQR.D_E_L_E_T_ = ''
        and TQR.TQR_TIPMOD = TQX.TQX_TIPMOD
        
        left join ST7010 ST7 (nolock)
            on ST7.D_E_L_E_T_ = ''
            and ST7.T7_FABRICA = TQR.TQR_FABRIC
where
		TQX.D_E_L_E_T_ = ''
