select
    ST9.T9_CODBEM as PNEU,
    ST9.T9_SITBEM as SITUACAO,
    ST9.T9_STATUS as STATUS,
    trim(isnull(TQT.TQT_DESMED, '-')) as MEDIDA,
    ST7.T7_NOME as FABRICANTE,
    TQR.TQR_TIPMOD,
    TQR.TQR_DESMOD as MODELO,
    TQX.TQX_KMESPO as km_ESPERADO

from TQT010 TQT (nolock)  
    left join TQS010 TQS (nolock)
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_MEDIDA = TQT.TQT_MEDIDA

        left join TQX010 TQX (nolock)
            on TQX.D_E_L_E_T_ = ''
            and TQX.TQX_MEDIDA = TQS.TQS_MEDIDA
        
            left join TQR010 TQR (nolock)
                on TQR.D_E_L_E_T_ = ''
                and TQR.TQR_TIPMOD = TQX.TQX_TIPMOD
                
                left join ST7010 ST7 (nolock)
                    on ST7.D_E_L_E_T_ = ''
                    and ST7.T7_FABRICA = TQR.TQR_FABRIC

        left join ST9010 ST9 (nolock)
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = TQS.TQS_CODBEM
where
		TQT.D_E_L_E_T_ = ''
