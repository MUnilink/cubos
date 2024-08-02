SELECT
    SRT.RT_FILIAL,
    substring(SRT.RT_DATACAL, 1, 6) as PERIODO,
    SRT.RT_MAT,
    RJ_CARGO,
    SRT.RT_TIPPROV,
    RT2.RT_DFERVEN,
    RT2.RT_DFERPRO,
    RT2.RT_AVOS13S,
    SRT.RT_VALOR AS VALOR
FROM SRT010 SRT
    INNER JOIN SRA010 SRA
        ON RA_FILIAL='010102'
        AND RA_MAT=SRT.RT_MAT
        AND SRA.D_E_L_E_T_=' '
        
        INNER JOIN SRJ010 RJ
            ON RJ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
            AND RJ_FUNCAO = RA_CODFUNC
            AND RJ_CARGO <> ' '
            AND RJ.D_E_L_E_T_ = ' '

            INNER JOIN SRT010 RT2
                ON RT2.RT_FILIAL = RA_FILIAL
                AND RT2.RT_MAT = RA_MAT
                AND RT2.RT_TIPPROV = '1'
                AND RT2.RT_VERBA = '830'
                AND RT2.RT_DATABAS <> ' '
                AND RT2.D_E_L_E_T_ = ' '
                AND RT2.RT_DATACAL = SRT.RT_DATACAL

WHERE
        SRT.RT_VERBA IN ('224', '255', '336', '371', '020', '113', '344', '039', '030', '029', '749', '719', '796', '738', '800', '962', '950', '955', '960', '961', '817', '830', '845', '442', '440', '441', '444', '446', '591', '038', '025', '051', '134', '170', '171', '172', '173', '371', '445', '739', '831', '832', '833', '834', '846', '847', '848')
    AND SRT.D_E_L_E_T_=' '
    AND SRT.RT_CC = '305'
    AND SRA.D_E_L_E_T_=' '
