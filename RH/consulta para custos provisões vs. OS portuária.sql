select *,
  case
    when PROV.RT_DFERVEN != 0 and PROV.RT_TIPPROV = '1' then PROV.VALOR / (PROV.RT_DFERVEN / 2.5)
    when PROV.RT_DFERPRO != 0 and PROV.RT_TIPPROV = '2' then PROV.VALOR / (PROV.RT_DFERPRO / 2.5)
    when PROV.RT_AVOS13S != 0 and PROV.RT_TIPPROV = '3' then PROV.VALOR / PROV.RT_AVOS13S
    else 0.0
  end as VALOR_AVO
from
(
  select
    RJ_CARGO,
    ZC7_CODIGO,
    ZC7_ORIGEM,
    ZC7_CC,
    ZC7_COMPET,
    ZC7_HRPAD,
    ZC7_HRPROD,
    ZC7_HRIMPR,
    SRT.RT_TIPPROV,
    RT2.RT_DFERVEN,
    RT2.RT_DFERPRO,
    RT2.RT_AVOS13S,
    SRT.RT_VERBA,
    SRT.RT_MAT,
    sum(SRT.RT_VALOR) as VALOR

  from SRT010 SRT
    
    inner join SRA010 SRA
      on RA_FILIAL = '010102'
      and RA_MAT = SRT.RT_MAT
      and SRA.D_E_L_E_T_ = ' '
    
    inner join SRJ010 RJ
      on RJ_FILIAL = Substring(RA_FILIAL, 1, 4)
      and RJ_FUNCAO = RA_CODFUNC
      and RJ_CARGO <> ' '
      and RJ.D_E_L_E_T_ = ' '
    
    inner join ZC7010 ZC7
      on ZC7_ORIGEM = 'SQ3'
      and ZC7.D_E_L_E_T_ = ' '
      and ZC7_CC = '305'
      and ZC7_CODIGO = RJ_CARGO
    
    inner join SRT010 RT2
      on RT2.RT_FILIAL = RA_FILIAL
      and RT2.RT_MAT = RA_MAT
      and RT2.RT_TIPPROV = '1'
      and RT2.RT_VERBA = '830'
      and RT2.RT_DATABAS <> ' '
      and RT2.D_E_L_E_T_ = ' '
      and RT2.RT_DATACAL = SRT.RT_DATACAL and RT2.RT_TIPPROV in ('1', '2')

  where
        SRT.RT_FILIAL = '010102'
    and SRT.RT_TIPPROV in ('2', '3')
    and substring(SRT.RT_DATACAL, 1, 6) =:ANOMES
    and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRT.RT_VERBA || '%')
    and SRT.D_E_L_E_T_ = ' '
    and SRT.RT_CC = '305'
    and SRA.D_E_L_E_T_ = ' '
  group by
    RJ_CARGO,
    ZC7_CODIGO,
    ZC7_ORIGEM,
    ZC7_CC,
    ZC7_COMPET,
    ZC7_HRPAD,
    ZC7_HRPROD,
    ZC7_HRIMPR,
    SRT.RT_TIPPROV,
    RT2.RT_DFERVEN,
    RT2.RT_DFERPRO,
    RT2.RT_AVOS13S,
    SRT.RT_VERBA,
    SRT.RT_MAT
) PROV