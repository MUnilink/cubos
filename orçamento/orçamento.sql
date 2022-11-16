select AKD.*
from AKD010 AKD (nolock)
    inner join AK1010 AK1 (nolock)
        on AK1.D_E_L_E_T_ = ''
        and AK1.AK1_CODIGO = AKD.AKD_CODPLA

        inner join AK3010 AK3 (nolock)
            on AK3.D_E_L_E_T_ = ''
            and AK3.AK3_ORCAME = AK1.AK1_CODIGO
            and AK3.AK3_VERSAO = AK1.AK1_VERSAO

            inner join AK5010 AK5 (nolock)
                on AK5.D_E_L_E_T_ = ''
                and AK5.AK5_CODIGO = AK3.AK3_CO

        inner join AK2010 AK2 (nolock)
            on AK2.D_E_L_E_T_ = ''
            and AK2.AK2_ORCAME = AK1.AK1_CODIGO
    
    inner join AK8010 AK8 (nolock)
        on AK8.D_E_L_E_T_ = ''
        and AK8.AK8_CODIGO = AKD.AKD_PROCES
where AKD.D_E_L_E_T_ = ''
