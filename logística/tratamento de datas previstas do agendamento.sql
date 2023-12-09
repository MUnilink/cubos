select
    DF1010.DF1_NUMAGE,
    DF1010.DF1_ITEAGE,
    concat(DF1010.DF1_DATPRC, ' ', DF1010.DF1_HORPRC) as PREV_COL,
    concat(DF1010.DF1_DATPRE, ' ', DF1010.DF1_HORPRE) as PREV_ENT,
    coalesce
    (
        nullif(trim(concat(nullif(DF1010.DF1_DATPRC, ''), case DF1010.DF1_HORPRC when '' then null else concat(substring(DF1010.DF1_HORPRC, 1, 2), ' :', substring(DF1010.DF1_HORPRC, 3, 2), ':', substring(DF1010.DF1_HORPRC, 5, 2), '00') end)), ':  :00'),
        nullif(trim(concat(nullif(DF1010.DF1_DATPRE, ''), case DF1010.DF1_HORPRE when '' then null else concat(substring(DF1010.DF1_HORPRE, 1, 2), ' :', substring(DF1010.DF1_HORPRE, 3, 2), ':', substring(DF1010.DF1_HORPRE, 5, 2), '00') end)), ':  :00')
    ) as CHE_CLIDEV_PREV
from DF1010 (nolock)
where DF1010.D_E_L_E_T_ = ''
