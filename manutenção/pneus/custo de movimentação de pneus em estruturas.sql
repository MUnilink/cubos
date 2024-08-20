select
    ST9.T9_CODBEM as COD_PNEU,
    ST9.T9_NOME as NOME_PNEU,
    STZ.TZ_BEMPAI as COD_PAI,
    T92.T9_NOME as NOME_PAI,
    T92.T9_TEMCONT,
    STZ.TZ_LOCALIZ,
    STZ.TZ_DATAMOV,
    STZ.TZ_DATASAI,
    case when Substring(STZ.TZ_DATAMOV, 1, 6) < '202403' then '20240301' else STZ.TZ_DATAMOV end as DATA_INI,
    case when Substring(STZ.TZ_DATASAI, 1, 6) > '202403' or STZ.TZ_DATASAI = ' ' then '20240331' else STZ.TZ_DATASAI end as DATA_FIM
from ST9010 ST9
    inner join STZ010 STZ
        on TZ_FILIAL = ' '
        and TZ_CODBEM = ST9.T9_CODBEM
        and STZ.D_E_L_E_T_ = ' '
        and ('202403' between STZ.TZ_DATAMOV and STZ.TZ_DATASAI
            or (substring(STZ.TZ_DATAMOV, 1, 6) <= '202403'
                and STZ.TZ_DATASAI = ' '))
    inner join ST9010 T92 on T92.T9_FILIAL = ' '
    and T92.T9_CODBEM = STZ.TZ_BEMPAI
    and T92.D_E_L_E_T_ = ' '
    and T92.T9_TEMCONT = 'S'
    where ST9.T9_FILIAL = ' '
        and ST9.T9_CATBEM = '3'
        and ST9.D_E_L_E_T_ = ' '
union all
select
    TZ2.TZ_DATAMOV as DATA2,
    TZ2.TZ_BEMPAI as COD_PAI2,
    T93.T9_NOME as NOME_PAI2,
    case when Substring(TZ2.TZ_DATAMOV, 1, 6) < '202403' then '20240301' else TZ2.TZ_DATAMOV end as DATA_INI2,
    case when Substring(TZ2.TZ_DATASAI, 1, 6) > '202403' or TZ2.TZ_DATASAI = ' ' then '20240331' else TZ2.TZ_DATASAI end as DATA_FIM2,
    COD_PNEU,
    NOME_PNEU,
    COD_PAI,
    NOME_PAI,
    SR.T9_TEMCONT,
    SR.TZ_LOCALIZ,
    SR.TZ_DATAMOV,
    SR.TZ_DATASAI,
    DATA_INI,
    DATA_FIM
from
    (
        select
            ST9.T9_CODBEM as COD_PNEU,
            ST9.T9_NOME as NOME_PNEU,
            STZ.TZ_BEMPAI as COD_PAI,
            T92.T9_NOME as NOME_PAI,
            T92.T9_TEMCONT,
            STZ.TZ_LOCALIZ,
            STZ.TZ_DATAMOV,
            STZ.TZ_DATASAI,
            case when Substring(STZ.TZ_DATAMOV, 1, 6) < '202403' then '20240301' else TZ_DATAMOV end as DATA_INI,
            case when substring(STZ.TZ_DATASAI, 1, 6) > '202403' or STZ.TZ_DATASAI = ' ' then '20240331' else STZ.TZ_DATASAI end as DATA_FIM
        from ST9010 ST9
            inner join STZ010 STZ on STZ.TZ_FILIAL = ' '
                and STZ.TZ_CODBEM = ST9.T9_CODBEM
                and STZ.D_E_L_E_T_ = ' '
                and ('202403' between STZ.TZ_DATAMOV and STZ.TZ_DATASAI
                or (Substring(STZ.TZ_DATAMOV, 1, 6) <= '202403'
                    and STZ.TZ_DATASAI = ' '))
            inner join ST9010 T92
                on T92.T9_FILIAL = ' '
                and T92.T9_CODBEM = STZ.TZ_BEMPAI
                and T92.D_E_L_E_T_ = ' '
                and T92.T9_TEMCONT = 'P'
        where
            ST9.T9_FILIAL = ' '
        and ST9.T9_CATBEM = '3'
        and ST9.D_E_L_E_T_ = ' '
    ) SR
