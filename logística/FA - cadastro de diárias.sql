select
    concat(DYV.DYV_FILIAL, DYV.DYV_FILORI, DYV.DYV_IDCDIA, DYX.DYX_ITEM, SE2.E2_NUM) as ID_DIARIA,
    DYV.DYV_IDCDIA as DIARIA,
    DYX.DYX_ITEM as ITEM,
    trim(upper(TP_DIA.X5_DESCRI)) as TIPO_DIARIA,
    case DYX.DYX_STATUS
        when 1 then upper('Pendente sem Restricao')
        when 2 then upper('Pendente com Restricao')
        when 3 then upper('Aprovada')
        when 4 then upper('Reprovada')
        when 5 then upper('Cancelada')
    else 'OUTROS' end as STATUS_DIARIA, 
    upper(trim(SYS_USR.USR_CODIGO)) as LIBERADA_POR,
    trim(SE2.E2_NUM) as TITULO,
    upper(trim(SE2.E2_HIST)) as HISTORICO
from DYX010 DYX
    left join SE2010 SE2
        on SE2.D_E_L_E_T_ = ''
        and SE2.E2_PREFIXO = DYX.DYX_PRETIT
        and SE2.E2_NUM = DYX.DYX_NUMTIT
    left join SX5010 TP_DIA
        on TP_DIA.D_E_L_E_T_ = ''
        and TP_DIA.X5_TABELA = 'MS'
        and TP_DIA.X5_CHAVE = DYX.DYX_TIPVAL
    left join SYS_USR
        on SYS_USR.D_E_L_E_T_ = ''
        and SYS_USR.USR_ID = DYX.DYX_USRAPR
    inner join DYV010 DYV
        on DYV.D_E_L_E_T_ = ''
        and DYV.DYV_IDCDIA = DYX.DYX_IDCDIA
where DYX.D_E_L_E_T_ = ''
