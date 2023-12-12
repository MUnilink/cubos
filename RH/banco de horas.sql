select 
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    SRA.RA_NOME as NOME,
    SRJ.RJ_DESC as FUNCAO,
    trim(SPI.PI_CC) as CC,

    trim(SPI.PI_DATA) as DATA,
    substring(SPI.PI_DATA, 1, 6) as PERIODO,
    trim(SPI.PI_PD) as COD_EVENTO,

    case
        when month(SPI.PI_DATA) in (1, 2, 3) then '1º'
        when month(SPI.PI_DATA) in (4, 5, 6) then '2º'
        when month(SPI.PI_DATA) in (7, 8, 9) then '3º'
        when month(SPI.PI_DATA) in (10, 11, 12) then  '4º'
        else '-'
    end as TRIMESTRE,

    case SPI.PI_PD
        when 140 then (SPI.PI_QUANTV) 
        else (SPI.PI_QUANTV * -1)
    end as QUANT_HORAS,

    trim(SP9.P9_DESC) as DESC_EVENTO
from SPI010 as SPI (nolock)
    inner join SRA010 as SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_MAT = SPI.PI_MAT
        and SRA.RA_FILIAL = SPI.PI_FILIAL
        left join SRJ010 as SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

    inner join SP9010 as SP9 (nolock)
        on SP9.D_E_L_E_T_ = ''
        and SP9.P9_CODIGO = SPI.PI_PD
where SPI.D_E_L_E_T_ = ''