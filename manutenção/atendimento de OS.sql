select
    STL.TL_FILIAL as FILIAL,
    STL.TL_ORDEM as OS,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST7.T7_NOME) as FABRICANTE,
    cast(STJ.TJ_DTORIGI as date) as DATA_OS,
    left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
    trim(ST9.T9_CODFAMI) as FAMILIA,
    cast(ST9.T9_DTBAIXA as date) as DT_BAIXA,
	trim(upper(STJ.TJ_USUAFIM)) as USR_FIM,
    trim(upper(STJ.TJ_USUARIO)) as USR_INI,
    cast(STI.TI_DATAPLA as date) as DATA_PLANO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,
    trim(STI.TI_PLANO) as NUM_PLANO,

    case STJ.TJ_TERMINO when 'S' then 'SIM' when 'N' then 'NÃO' end as TERMINO,
    case STJ.TJ_TERCEIR when '2' then 'SIM' when '1' then 'NÃO' when 'N' then 'NÃO' end as EXTERNA,
    case STJ.TJ_SITUACA 
        when 'C' then upper('Cancelado')
        when 'L' then upper('Liberado')
        when 'P' then upper('Pendente')
        else 'OUTROS'
    end as SITUACAO_OS,

    case
        when trim(SB1.B1_COD) in ('11010013', '11030072', '11040035', '11140183', '11150193', '11160355', '11190270', '11220137', '11251271', '11350030', '11370005', '11010014', '11010017', '11010069', '11010106', '11010153', '11020038', '11030054', '11040012', '11040176', '11040269', '11060018', '11060039', '11060056', '11060308', '11060344', '11060346', '11060408', '11060410', '11060480', '11060501', '11060712', '11060724', '11061135', '11070015', '11090014', '11130053', '11140021', '11140027', '11140028', '11140029', '11140030', '11140031', '11140032', '11140033', '11140034', '11140035', '11140036', '11150089', '11150130', '11150155', '11150159', '11150194', '11150198', '11150199', '11150213', '11150227', '11150406', '11150579', '11150718', '11160005', '11160006', '11160007', '11160011', '11160013', '11160039', '11160132', '11160169', '11160234', '11160275', '11180003', '11180006', '11180007', '11180061', '11180063', '11180065', '11180068', '11190016', '11190050', '11190052', '11190234', '11190326', '11190362', '11190380', '11190456', '11220031', '11220094', '11220469', '11220610', '11250149', '11250351', '11250454', '11250928', '11250999', '11251018', '11251272', '11350026', '11350032', '11350034', '11350036', '11350037', '11350039', '11350042', '11350046', '11350050', '11350051', '11350061', '11350065', '11350096', '11350097', '11350129', '11350149')
        then 'RS'
        when trim(SB1.B1_COD) in ('11390210', '11390062', '11370041', '11370023', '11370017', '11370011', '11370009', '11370005', '11360140', '11360115', '11360027', '11360013', '11360012', '11350299', '11350180', '11350122', '11350081', '11350061', '11350030', '11260039', '11260010', '11251018', '11250928', '11250756', '11250456', '11250455', '11250454', '11250383', '11250351', '11250313', '11250284', '11250225', '11250202', '11250149', '11250142', '11220987', '11220962', '11220868', '11220071', '11220009', '11190371', '11190368', '11190323', '11190270', '11190246', '11190233', '11190052', '11190041', '11190018', '11190016', '11180063', '11180061', '11180007', '11180006', '11180004', '11180003', '11160343', '11160311', '11160238', '11160234', '11160207', '11160205', '11160169', '11160039', '11160019', '11150227', '11150213', '11150199', '11150159', '11150155', '11150089', '11150086', '11150008', '11140183', '11140182', '11130090', '11130076', '11120007', '11120006', '11120005', '11100220', '11070015', '11060565', '11060480', '11060471', '11060410', '11060408', '11060056', '11060018', '11040068', '11040065', '11040035', '11040030', '11020038', '11010153', '11010069')
        then 'KAL'
        when trim(SB1.B1_COD) in ('11190464', '11020098', '11160338', '11190465', '11251319', '11251320', '11251321', '11251322', '11251323', '11260055', '11010013', '11010017', '11010069', '11060941', '11060942', '11110037', '11130101', '11130102', '11130103', '11140163', '11140164', '11140168', '11140169', '11151084', '11151085', '11151106', '11180102', '11180103', '11180128', '11190041', '11250202', '11250351', '11251234', '11330442', '11350164', '11350325', '11350335', '11360065', '11360094', '11360139', '11370005', '11370027', '11390078')
        then 'HYSTER'
        when trim(SB1.B1_COD) in ('11020001', '11020095', '11040069', '11040203', '11040211', '11070175', '11100157', '11140132', '11140133', '11140134', '11140135', '11140221', '11140222', '11150191', '11150198', '11150204', '11150288', '11150397', '11150502', '11150967', '11160133', '11160170', '11160176', '11160319', '11190319', '11250165', '11250168', '11250170', '11250175', '11250178', '11250303', '11250304', '11250305', '11250306', '11250371', '11250494', '11250540', '11250747', '11250789', '11250790', '11250791', '11250795', '11250797', '11250806', '11250810', '11250811', '11260001')
        then 'EP'
    else 'SEM ESTOQUE' end as PECA_ESTOQUE,
    
    case STE.TE_CARACTE
        when 'P' then 'PREVENTIVA'
        when 'C' then 'CORRETIVA'
        else 'OUTROS'
    end as TIPO_MNT,
    
    case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV,
    
    left(STL.TL_DTFIM, 6) as PERIODO_APP,
    cast(STL.TL_DTFIM as date) as DATA_APP,
    case when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 120) else null end as DTHINI_APP,
	case when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 120) else null end as DTHFIM_APP,
	
    STL.TL_SEQRELA as ITEM_OS,
    STL.TL_LOCAL as ARMAZEM,
	STJ.TJ_POSCONT as CONTADOR,
    STL.TL_CUSTO as CUSTO_INSUMO,
    STL.TL_QUANTID as QTD_INSUMO,
    STJ.TJ_CCUSTO as CC,
    coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STL.TL_DTINICI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,

    case STL.TL_SEQRELA when 0 then 'PREVISTO' else 'REALIZADO' end as APP_INSUMO,
    
    case
        when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
        when SCP.CP_QUANT > SCP.CP_QUJE then 'PARC. ATENDIDA'
        when cast(SCP.CP_QUJE as numeric(15, 2)) = 0.00 then 'PENDENTE'
        else 'OUTROS'
    end as APP_PRODUTO,

    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    trim(SB1.B1_GRUPO) as B1_GRUPO,

    case
        when STL.TL_TIPOREG = 'P' and STL.TL_DOC = '' then 'NÃO ATENDIDA'
        when STL.TL_TIPOREG = 'P' and STL.TL_DOC != '' then 'ATENDIDA'
        when STL.TL_TIPOREG = 'M' then 'MDO REALIZADA'
        when STL.TL_TIPOREG = 'T' then 'EXTERNO'
        when STL.TL_TIPOREG = 'E' then 'MDO PREVISTA'
        else 'OUTROS'
    end as ATENDIMENTO,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		when 'P' then case when SB1.B1_GRUPO = '2201' then 'TERCEIROS' when STL.TL_ORIGNFE = 'SD1' then 'PEÇAS DIRETAS' else 'PEÇAS' end
		when 'T' then 'TERCEIROS'
		else 'OUTROS'
	end as TIPO_CUSTO,

    trim(STL.TL_CODIGO) as INSUMO,
	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then coalesce(trim(SA2.A2_NOME), (select trim(SA2010.A2_NOME) from SA2010 (nolock) where SA2010.D_E_L_E_T_ = '' and SA2010.A2_COD + SA2010.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA))
		else 'OUTROS'
	end as DESC_INSUMO,

    concat(trim(SH7.H7_CODIGO), ' - ', trim(SH7.H7_DESCRI)) as TURNO_MDO,
    cast(ST1.T1_DTFIMDI as date) as FIM_DISP,
    trim(ST1.T1_CCUSTO) as CC_FUNC,
    
    trim(STJ.TJ_TIPO) as COD_CTIPO,
    trim(STE.TE_TIPOMAN) as TE_TIPOMAN,
	trim(STE.TE_NOME) as CARAC_TIPO,
    trim(ST4.T4_SERVICO) as COD_SERVICO,
	trim(ST4.T4_NOME) as SERVICO,
    trim(STL.TL_TAREFA) as COD_TAREFA,
	trim(TT9.TT9_DESCRI) as TAREFA,
    trim(SH4.H4_CODIGO) as H4_CODIGO,
	trim(ST0.T0_ESPECIA) as T0_ESPECIA,
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	trim(SB1.B1_COD) as COD_PRODUTO,
	trim(SB1.B1_DESC) as PRODUTO,
	trim(SA2.A2_COD) as COD_FORNECEDOR,
	trim(SA2.A2_NOME) as FORNECEDOR,
    
    trim(STL.TL_DOC) as NFE_NUM,
    trim(STL.TL_ITEM) as NFE_ITEM,
    trim(SD1.D1_PEDIDO) as PC_NUM,
    trim(SD1.D1_ITEMPC) as PC_ITEM

from STL010 STL (nolock)
    inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL

        inner join ST4010 ST4 (nolock)
            on ST4.D_E_L_E_T_ = ''
            and ST4.T4_SERVICO = STJ.TJ_SERVICO
            and ST4.T4_SERVICO not in ('PNEMOV', 'CONSEP', 'REFORP', 'PNEROD')
        inner join ST9010 ST9 (nolock)
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = STJ.TJ_CODBEM

            inner join TQR010 TQR (nolock)
                on TQR.D_E_L_E_T_ = ''
                and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
                
                inner join ST7010 ST7 (nolock)
                    on ST7.D_E_L_E_T_ = ''
                    and ST7.T7_FABRICA = TQR.TQR_FABRIC

        left join STI010 STI (nolock)
            on STI.D_E_L_E_T_ = ''
            and STI.TI_FILIAL = STJ.TJ_FILIAL
            and STI.TI_PLANO = STJ.TJ_PLANO
        left join STE010 STE (nolock)
            on STE.D_E_L_E_T_ = ''
            and STE.TE_TIPOMAN = STJ.TJ_TIPO
    
    left join TT9010 TT9 (nolock)
        on TT9.D_E_L_E_T_ = ''
        and TT9.TT9_TAREFA = STL.TL_TAREFA
    left join SH4010 SH4 (nolock)
        on SH4.D_E_L_E_T_ = ''
        and SH4.H4_CODIGO = STL.TL_CODIGO
    left join ST0010 ST0 (nolock)
        on ST0.D_E_L_E_T_ = ''
        and ST0.T0_ESPECIA = STL.TL_CODIGO
    left join ST1010 ST1 (nolock)
        on ST1.D_E_L_E_T_ = ''
        and ST1.T1_FILIAL = STL.TL_FILIAL
        and ST1.T1_CODFUNC = STL.TL_CODIGO

        left join SH7010 SH7 (nolock)
            on SH7.D_E_L_E_T_ = ''
            and SH7.H7_CODIGO = ST1.T1_TURNO
    
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = STL.TL_FILIAL
        and SCP.CP_NUM = STL.TL_NUMSA
        and SCP.CP_ITEM = STL.TL_ITEMSA
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = STL.TL_CODIGO

    left join SD1010 SD1 (nolock)
        on STL.TL_ORIGNFE = 'SD1'
        and SD1.D_E_L_E_T_ = ''
        and SD1.D1_FILIAL = STL.TL_FILIAL
        and left(SD1.D1_OP, 6) = STL.TL_ORDEM
        and SD1.D1_DOC = STL.TL_NOTFIS
        and SD1.D1_SERIE = STL.TL_SERIE
        and SD1.D1_ITEM = STL.TL_ITEM
        and SD1.D1_FORNECE = STL.TL_FORNEC
        and SD1.D1_LOJA = STL.TL_LOJA

        left join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = SD1.D1_FILIAL
            and SC7.C7_NUM = SD1.D1_PEDIDO
            and SC7.C7_ITEM = SD1.D1_ITEMPC

            left join SA2010 SA2 (nolock)
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = SC7.C7_FORNECE
                and SA2.A2_LOJA = SC7.C7_LOJA
where STL.D_E_L_E_T_ = ''
