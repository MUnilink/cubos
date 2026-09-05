select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
    trim(SB1.B1_COD) as B1_COD,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    ST9.T9_CODESTO,
    ST9.T9_LOCPAD,
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,

    trim(STJ.TJ_CCUSTO) as CC,
    trim(STJ.TJ_YITMCT) as ATIVIDADE,

    case STJ.TJ_TERMINO when 'S' then 'SIM' when 'N' then 'NÃO' end as TERMINO,
    case STJ.TJ_SITUACA 
        when 'C' then upper('Cancelado')
        when 'L' then upper('Liberado')
        when 'P' then upper('Pendente')
        else 'OUTROS'
    end as SITUACAO_OS,

    trim(upper(STJ.TJ_USUAFIM)) as USR_FIM,
    trim(upper(STJ.TJ_USUARIO)) as USR_INI,
    
    TR7.TR7_LOTE,
    TR7.TR7_SERVIC,
    TR7.TR7_NFE,
    TR7.TR7_SERIE,
    TR7.TR7_FORNEC,
    TR7.TR7_LOJA,
    trim(SA2.A2_NOME) as RAZAO_SOCIAL,
    trim(SA2.A2_NREDUZ) as NOME_FANTASIA,
    TR8.TR8_ORDEM,
    trim(TR8.TR8_MOTIVO) as TR8_MOTIVO,
    trim(ST8.T8_NOME) as MOTIVO,
    TR8.TR8_VALOR,
    case TR8.TR8_INDREL when 1 then 'SIM' when 2 then 'NAO' else null end as REALIZADO,
    
    convert(datetime, concat(TR7.TR7_DTLOTE, ' ', TR7.TR7_HRLOTE), 103) as DATA_LOTE,
    convert(datetime, concat(TR7.TR7_DTRECI, ' ', TR7.TR7_HRRECI), 103) as DATA_RECEBIMENTO,
    
    SC1.C1_NUM as NUM_SC,
    convert(date, SC1.C1_EMISSAO, 103) as DATA_SC,
    substring(SC1.C1_OP, 1, 6) as C1_OS,
    trim(SC1.C1_OBS) as OBS_SC,
    SC1.C1_USER,
    SC1.C1_CODCOMP,
    trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
    
    SC7.C7_NUM as NUM_PC,
    convert(date, SC7.C7_EMISSAO, 103) as DATA_PC,
    substring(SC7.C7_OP, 1, 6) as C7_OS,
    trim(SC7.C7_OBS) as OBS_PC,
    
    SD1.D1_DOC as NF_SERVICO,
    SD1.D1_SERIE as SER_SERVICO,
    SD1.D1_TOTAL as VALOR_SERVICO,
    SD1.D1_CUSTO as CUSTO_SERVICO,
    trim(SD1.D1_CC) as CC_NF,
    trim(SD1.D1_ITEMCTA) as AT_NF,
    cast(SD1.D1_DTDIGIT as date) as DT_NFS,

    TR4.TR4_NUMANA,
	TR4.TR4_ORDEM,
	TR4.TR4_DESTIN,
	TR4.TR4_MOTIVO,
	convert(datetime, concat(TR4.TR4_DTANAL, ' ', TR4.TR4_HRANAL), 103) as DATA_ANALISE,

    (
        select ST9010.T9_CODBEM
        from ST9010
        where
                ST9010.D_E_L_E_T_ = ''
            and ST9010.T9_PLACA = TQS.TQS_PLACA
            and TQS.TQS_PLACA != ''
    ) as EST_ATUAL,
    (
        select top 1 last_value(STZ010.TZ_BEMPAI) over (partition by STZ010.TZ_CODBEM order by STZ010.TZ_CODBEM)
        from STZ010 (nolock)
        where
                STZ010.D_E_L_E_T_ = ''
            and STZ010.TZ_CODBEM = TR8.TR8_CODBEM
            and STZ010.TZ_DATASAI + STZ010.TZ_HORASAI <= TR7.TR7_DTLOTE + TR7.TR7_HRLOTE
    ) as EST_ANTERIOR

from TQS010 TQS (nolock)
    inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join TR8010 TR8 (nolock)
        on TR8.D_E_L_E_T_ = ''
        and TR8.TR8_CODBEM = TQS.TQS_CODBEM

        inner join TR7010 TR7 (nolock)
            on TR7.D_E_L_E_T_ = ''
            and TR7.TR7_FILIAL = TR8.TR8_FILIAL
            and TR7.TR7_LOTE = TR8.TR8_LOTE

            inner join SA2010 SA2 (nolock)
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = TR7.TR7_FORNEC
                and SA2.A2_LOJA = TR7.TR7_LOJA
        
        left join STJ010 STJ (nolock)
            on STJ.TJ_FILIAL = TR8.TR8_FILIAL
            and STJ.TJ_ORDEM = TR8.TR8_ORDEM
            and STJ.TJ_PLANO = TR8.TR8_PLANO
        left join ST8010 ST8 (nolock)
            on ST8.D_E_L_E_T_ = ''
            and ST8.T8_CODOCOR = TR8.TR8_MOTIVO
        left join SC1010 SC1 (nolock)
            on SC1.D_E_L_E_T_ = ''
            and SC1.C1_FILIAL = TR8.TR8_FILIAL
            and SC1.C1_OP = TR8.TR8_ORDEM + 'OS' + '001'
        left join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = TR8.TR8_FILIAL
            and SC7.C7_OP = TR8.TR8_ORDEM + 'OS' + '001'
        left join SD1010 SD1 (nolock)
            on SD1.D_E_L_E_T_ = ''
            and SD1.D1_FILIAL = TR8.TR8_FILIAL
            and SD1.D1_OP = TR8.TR8_ORDEM + 'OS' + '001'
        left join TR4010 TR4 (nolock)
            on TR4.D_E_L_E_T_ = ''
            and TR4.TR4_CODBEM = TR8.TR8_CODBEM
            and TR4.TR4_ORDEM = TR8.TR8_ORDEM
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS
    inner join TQT010 TQT (nolock)
		on TQT.D_E_L_E_T_ = ''
		and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

		left join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
where
        TQS.D_E_L_E_T_ = ''
