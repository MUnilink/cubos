select
    trim(ST9.T9_CODBEM) as EQUIPAMENTO,
    trim(ST9.T9_CCUSTO) as CC,
	trim(ST9.T9_ITEMCTA) as ATIVIDADE,
    trim(TTE.TTE_CODFAM) as FAMILIA,
    trim(TTE.TTE_TIPMOD) as MODELO,
    trim(TTE.TTE_SEQFAM) as SEQ_CHECKLIST,
    trim(ST4.T4_SERVICO) as SERVICO,
    trim(ST4.T4_NOME) as DESC_SERVICO,
    trim(TTE.TTE_ETAPA) as COD_ETAPA,
    trim(TPA.TPA_DESCRI) as DESC_ETAPA,
    cast((left(TPA.TPA_TEMPOM, 2) + right(trim(TPA.TPA_TEMPOM), 2)/60.0) as numeric(15, 2)) as TEMPO_ETAPA,
    'h' as UN_ETAPA,
    
    case TTE.TTE_ALTA
        when 'N' then 'Nenhum'
        when 'S' then 'Gera SS'
        when 'O' then 'Gera O.S'
    else 'outros' end as PRI_ALTA,
    case TTE.TTE_MEDIA
        when 'N' then 'Nenhum'
        when 'S' then 'Gera SS'
        when 'O' then 'Gera O.S'
    else 'outros' end as PRI_MEDIA,
    case TTE.TTE_BAIXA
        when 'N' then 'Nenhum'
        when 'S' then 'Gera SS'
        when 'O' then 'Gera O.S'
    else 'outros' end as PRI_BAIXA
from TTE010 TTE
    inner join TQR010 TQR
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = TTE.TTE_TIPMOD
		
		inner join ST7010 ST7
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC
        inner join ST9010 ST9
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_TIPMOD = TQR.TQR_TIPMOD
    
    left join TPA010 TPA
        on TPA.D_E_L_E_T_ = ''
        and TPA.TPA_ETAPA = TTE.TTE_ETAPA
    inner join ST4010 ST4
        on ST4.D_E_L_E_T_ = ''
        and ST4.T4_SERVICO = TTE.TTE_SERVIC
where TTE.D_E_L_E_T_ = ''
