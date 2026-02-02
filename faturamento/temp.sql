select
    trim(ZE3.ZE3_FILIAL) as ZE3_FILIAL,
    trim(ZE3.ZE3_ORIGEM) as ZE3_ORIGEM,
    trim(ZE3.ZE3_NUM) as ZE3_NUM,
    trim(ZE3.ZE3_COMPET) as ZE3_COMPET,
    trim(ZE3.ZE3_ITORIG) as ZE3_ITORIG,
    ZE3.ZE3_ITEMPL as CONTA,
    R_E_C_N_O_
    cast(sum(ZE3.ZE3_VALOR) as numeric(15, 2)) as VALOR
from ZE3010 ZE3
where ZE3.D_E_L_E_T_ = '' and ZE3.ZE3_COMPET like '20250[1-3]%' and trim(ZE3.ZE3_ITEMPL) like '012%'
group by rollup(ZE3.ZE3_FILIAL, ZE3.ZE3_ITEMPL, ZE3.ZE3_ORIGEM, ZE3.ZE3_NUM, ZE3.ZE3_COMPET, ZE3.ZE3_ITORIG)
