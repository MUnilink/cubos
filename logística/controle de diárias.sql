select
    DYV.DYV_VIAGEM as VIAGEM,
    DYV.DYV_CODMOT as MOT_COD,
    DA4.DA4_MAT as MOT_MATRICULA,
    DA4.DA4_NOME as MOTORISTA,
    DA4.DA4_FORNEC as MOT_FORNECE,
    DYV.DYV_IDCDIA as DIARIA,
    DYX.DYX_ITEM as ITEM,
    
    concat(DYX.DYX_TIPVAL, ' - ', (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'MS' and SX5010.X5_CHAVE = DYX.DYX_TIPVAL)) as TIPO_DIARIA,
    DYX.DYX_STATUS,
    case DYX.DYX_STATUS
        when 1 then upper('Pendente sem Restricao')
        when 2 then upper('Pendente com Restricao')
        when 3 then upper('Aprovado')
        when 4 then upper('Reprovado')
        when 5 then upper('Cancelado')
    else 'OUTROS' end as STATUS_DIARIA,

    cast(DYX.DYX_QTDE as int) as QTD,
    cast(DYX.DYX_VLRUNI as numeric(15, 2)) as VL_UNI,
    upper(DYX.DYX_USRAPR) as APROVADORA,
    trim(SE2.E2_NUM) as TITULO,
    cast(SE2.E2_VALOR as numeric(15, 2)) as VL_TITULO,
    cast(SE2.E2_SALDO as numeric(15, 2)) as SALDO,
    cast(SE2.E2_DESCONT as numeric(15, 2)) as DESCONT,
    cast(SE2.E2_MULTA as numeric(15, 2)) as MULTA,
    cast(SE2.E2_JUROS as numeric(15, 2)) as JUROS,
    cast(SE2.E2_CORREC as numeric(15, 2)) as CORREC,
    cast(SE2.E2_VALLIQ as numeric(15, 2)) as VALOR_LIQ,
    trim(SE2.E2_ORIGEM) as ORIGEM,
    left(DYX.DYX_DATDIA, 6) as PERIODO_DIARIA,
    cast(DYX.DYX_DATDIA as date) as DATA_DIARIA,
    cast(DYX.DYX_DATAPR as date) as DATA_APROVA,
    
    cast(SE2.E2_EMISSAO as date) as DATA_TITULO,
    left(SE2.E2_EMISSAO, 6) as PERIODO_TITULO,
	cast(SE2.E2_VENCTO as date) as VENCIMENTO,
	left(SE2.E2_VENCTO, 6) as PERIODO_VENCIMENTO,
	cast(SE2.E2_VENCREA as date) as VENCREAL,
	left(SE2.E2_VENCREA, 6) as PERIODO_VENCREAL,
	cast(SE2.E2_BAIXA as date) as BAIXA,
    trim(SE2.E2_HIST) as HISTORICO

from DYV010 DYV (nolock)
    inner join DYX010 DYX (nolock)
        on DYX.D_E_L_E_T_ = ''
        and DYX.DYX_IDCDIA = DYV.DYV_IDCDIA
        
        left join SE2010 SE2 (nolock)
            on SE2.D_E_L_E_T_ = ''
            and SE2.E2_PREFIXO = DYX.DYX_PRETIT
            and SE2.E2_NUM = DYX.DYX_NUMTIT

    inner join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = DYV.DYV_CODMOT
where
        DYV.D_E_L_E_T_ = ''
