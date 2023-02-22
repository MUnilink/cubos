select
    ST9010.T9_CODBEM,
    SN1010.N1_CBASE,
    SN4010.N4_DATA,
    SN4010.N4_VLROC1
from SN4010
    left join SN1010 (nolock)
        on SN1010.D_E_L_E_T_ = ''
        and SN1010.N1_CBASE = SN4010.N4_CBASE
    
        inner join ST9010 (nolock)
            on ST9010.D_E_L_E_T_ = ''
            and ST9010.T9_CODBEM = SN1010.N1_CODBEM
where
        SN4010.D_E_L_E_T_ = ''
