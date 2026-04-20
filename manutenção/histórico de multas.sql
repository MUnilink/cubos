select
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
	trim(ST9.T9_CHASSI) as CHASSI,
	trim(ST9.T9_ANOMOD) as ANOMODELO,
	trim(ST9.T9_ANOFAB) as ANOFABRIC,
	trim(ST9.T9_RENAVAM) as RENAVAM,
	(select TQ0010.TQ0_EIXOS from TQ0010 where TQ0010.D_E_L_E_T_ = '' and TQ0010.TQ0_DESENH = ST9.T9_CODFAMI and TQ0010.TQ0_TIPMOD = ST9.T9_TIPMOD) as EIXOS,
	case ST9.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as PROPRIO,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	
	cast(ST9.T9_DTCOMPR as date) as DTCOMPR,
	left(ST9.T9_DTCOMPR, 6) as PERIODO_COMPR,
	cast(ST9.T9_DTBAIXA as date) as DTBAIXA,
	left(ST9.T9_DTBAIXA, 6) as PERIODO_BAIXA,
	(select trim(TPJ010.TPJ_DESMOT) from TPJ010 (nolock) where TPJ010.D_E_L_E_T_ = '' and TPJ010.TPJ_CODMOT = ST9.T9_MTBAIXA) as DESC_BAIXA,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,
	
	trim(ST9.T9_CCUSTO) as CC_MNT,
	trim(ST9.T9_ITEMCTA) as ATIVIDADE_MNT,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = ST9.T9_CCUSTO) as DESC_CC_MNT,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = ST9.T9_ITEMCTA) as DESC_AT_MNT,

	case ST9.T9_TEMCONT
		when 'S' then 'PROPRIO'
		when 'N' then 'NAO'
		when 'P' then 'ESTRUTURA'
		when 'I' then 'IMEDIATO'
		else 'OUTROS'
	end as POSSUI_CONT,
	
	trim(TRX.TRX_PLACA) as PLACA,
	trim(TRX.TRX_MULTA) as 'Codigo da Multa',
	trim(TRX.TRX_TPMULT) as 'Tipo de Multa',
	trim(TRX.TRX_NUMAIT) as 'Numero da Infracao',
	trim(TRX.TRX_LOCAL) as 'Local exato da Infracao',
	trim(TRX.TRX_CIDINF) as 'Cidade Ocorreu a Infracao',
	trim(TRX.TRX_CODOR) as 'Codigo do Orgao autuado',
	trim(TRX.TRX_CODBEM) as 'Codigo do Veiculo',
	trim(TRX.TRX_NOME) as 'Nome do Motorista',

	TRX.TRX_REPON as 'Indicad. Responsabilidade' as 1=Motorista;2=Empresa;3=Pessoa Fisica;4=Pessoa Juridica e FIsica;5=Seguradora;6=Transportador;7=Expedidor,
	TRX.TRX_PAGTO as 'Houve o Pagamento?' as 1=Sim;2=Nao,
	TRX.TRX_INFRAC as 'Indica Condutor p/ Orgao' as 1=Sim;2=Nao,
	TRX.TRX_STATUS as 'Status Porecesso da Multa' as 1=Registrado;2=Em Andamento;3=Concluido,
	TRX.TRX_RECURS as 'Indica se possui Recurso' as 1=Sim;2=Nao,
	TRX.TRX_INDREC as 'Tipo do Recurso' as 1=Pela Empresa;2=Pelo Motorista,
	TRX.TRX_SITREC as 'Situacao do Recurso' as 1=Pendente;2=Recurso Deferido;3=Resurso Indeferido,
	TRX.TRX_SEGINS as 'Segunda Instancia Recurso' as 1=Sim;2=Nao,
	TRX.TRX_SITRE2 as 'Situacao do Recurso 2' as 1=Pendente;2=Recurso Deferido;3=Resurso Indeferido,
	TRX.TRX_ORIGEM as 'Origem da Multa' as 1=Auto Policial;2=Eletrônica,
	TRX.TRX_RECAUT as 'Recebeu Auto da Infracao' as 1=Sim;2=Nao,
	TRX.TRX_RECNOT as 'Recebeu Notificacao' as 1=Sim;2=Nao;3=Pendente,
	TRX.TRX_CABREC as 'Cabe Recurso?' as 1=Sim;2=Nao,
	TRX.TRX_ADVERT as 'Gerar Advertencia ?' as 1=Sim;2=Nao,

	cast(TRX.TRX_VALOR as numeric(15, 2)) as VALOR_MULTA,
	cast(TSH.TSH_VALOR as numeric(15, 2)) as VALOR_INFRA,
	cast(TSH.TSH_PONTOS as int) as PONTOS,
	trim(TSH.TSH_ARTIGO) as REF_ARTIGO,
	trim(TSH.TSH_DESART) as DESC_ARTIGO,

	trim(TRX.TRX_CCUSTO) as CC,
	trim(TRX.TRX_ITEMCT) as AT,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = TRX.TRX_CCUSTO) as CC_DESC,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = TRX.TRX_ITEMCT) as AT_DESC,
	
	TRX.TRX_PREFIX,
	TRX.TRX_TIPO,
	TRX.TRX_NUMSE2 as TITULO,
	TRX.TRX_NATURE as NAT_FINANC,
	TRX.TRX_CONPAG as CONDPAG,
	left(TRX.TRX_DTINFR, 6) as PERIODO_INFRA,
	left(TRX.TRX_DTDIGI, 6) as PERIODO_DIGIT,
	left(SE2.E2_VENCREA, 6) as PERIODO_VENCE,
	convert(datetime, concat(TRX.TRX_DTINFR, ' ', TRX.TRX_RHINFR), 113) as DT_INFRA,
	convert(datetime, concat(TRX.TRX_DTDIGI, ' ', TRX.TRX_HRDIGI), 113) as DT_DIGIT,
	cast(SE2.E2_VENCREA as date) as DT_VENCE,
	cast(SE2.E2_BAIXA as date) as DT_BAIXA

from TRX010 TRX (nolock)
	left join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_PLACA = TRX.TRX_PLACA
		
		left join TQR010 TQR (nolock)
			on TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
			
			left join ST7010 ST7 (nolock)
				on ST7.D_E_L_E_T_ = ''
				and ST7.T7_FABRICA = TQR.TQR_FABRIC
		
		left join TQY010 TQY (nolock)
			on TQY.D_E_L_E_T_ = ''
			and TQY.TQY_STATUS = ST9.T9_STATUS
	
	left join SE2010 SE2 (nolock)
        on SE2.D_E_L_E_T_ = ''
        and trim(SE2.E2_PREFIXO) = 'MNT'
        and SE2.E2_NUM = TRX.TRX_NUMSE2
	inner join TSH010 TSH (nolock)
		on TSH.D_E_L_E_T_ = ''
		and TSH.TSH_CODINF = TRX.TRX_CODINF
where
		TRX.D_E_L_E_T_ = ''
