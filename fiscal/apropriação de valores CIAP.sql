select
    trim(SF9.F9_CODIGO) as 'Codigo do Ativo',
    trim(SF9.F9_DOCNFE) as 'Nota Fiscal de Entrada',
    trim(SF9.F9_SERNFE) as 'Serie a Nota de Entrada',
    trim(SF9.F9_ITEMNFE) as 'Item da Nota de Entrada',
    cast(SF9.F9_DTENTNE as date) as 'Dt.Digitacao da NFE',
    cast(SF9.F9_DTEMINE as date) as 'Dt.Emissao da NFE',
    cast(SF9.F9_VALICMS as numeric(15, 2)) as 'Valor do ICMS',
    cast(SF9.F9_QTDPARC as int) as 'Num. Parc.',
    cast(SF9.F9_SLDPARC as int) as 'Saldo Parc.',
    cast(SF9.F9_VLDBATV as numeric(15, 2)) as 'Valor Debito Ativo',
    cast(case when SF9.F9_QTDPARC = 0 or SF9.F9_SLDPARC = 0 then 0 else SF9.F9_VALICMS/SF9.F9_QTDPARC end as numeric(15, 2)) as VL_PARCELA,
    datediff()
from SF9010 SF9
where SF9.D_E_L_E_T_ = ''
