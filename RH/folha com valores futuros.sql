with SRK as
(
	select
		case SRK010.RK_STATUS
			when 1 then 'Solicitado'
			when 2 then 'Ativo'
			when 3 then 'Pago'
			when 4 then 'Suspenso'
			when 5 then 'Descontinuado'
		else 'outros' end as RK_STATUS,
		
		SRK010.RK_DTREF as ,
		SRK010.RK_NRCONTR as ,
		SRK010.RK_BCOCONS as COD_BANCO,
		trim(SA6010.A6_NOME) as BANCO
	from SRK010
		left join SA6010
			on SA6010.D_E_L_E_T_ = ''
			and SA6010.A6_COD = SRK010.RK_BCOCONS
	where SRK010.D_E_L_E_T_ = ''
)

select
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
    trim(SRA.RA_ESTADO) as UF,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    cast(SRA.RA_NASC as date) as NASCIMENTO,
    SRA.RA_SITFOLH as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
    trim(CTT.CTT_CUSTO) as CC,
    trim(CTT.CTT_DESC01) as CCUSTO,
    trim(CTD.CTD_ITEM) as AT,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
    trim(SRJ.RJ_CODCBO) as CBO,
    trim(SRA.RA_SEXO) as SEXO,
    trim(SRA.RA_CIC) as CPF,
    trim(SRA.RA_PIS) as PIS,
    trim(SRA.RA_NUMCP) as CTPS,
    trim(SRA.RA_CATFUNC) as COD_TRAB,
    concat(trim(SRA.RA_CATFUNC), ' - ', (select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_CATFUNC and SX5010.X5_TABELA = '28')) as DESC_TRAB,


	trim(SRD.RD_PERIODO) as PERIODO,
	trim(SRD.RD_PD) as VERBA,
	trim(SRD.RD_SEQ) as SEQ,
	trim(SRD.RD_ROTEIR) as ROTEIRO,

	case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
	
	trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
	trim(SRV.RV_DESCDET) as DESC_VERBA2,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,

	trim(RCN.RCN_CODIGO) as IDVERBA,
	trim(RCN.RCN_DESCRI) as IDVERBA_NOME,

	SRD.RD_VALOR as VALOR,
	SRD.RD_HORAS as HORAS,
	null as HORAS_PADRAO,
	concat(SRV.RV_COD, ' - ', case when (upper(SRV.RV_DESC) like '%ECONSIGNADO%' or upper(SRV.RV_DESC) like '%CONSIG%') and SRV.RV_TIPOCOD = '2' then 'VERBA ECONSIG DESCONTO' else isnull(nullif(trim(SRV.RV_DESCDET), ''), SRV.RV_DESC) end) as DESC_ECONS

from SRD010 SRD (nolock)
	inner join SRV010 SRV (nolock)
		on SRV.D_E_L_E_T_ = ''
		and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
		and SRD.RD_PD = SRV.RV_COD
			
		left join RCN010 RCN (nolock)
			on RCN.D_E_L_E_T_ = ''
			and RCN.RCN_CODIGO = SRV.RV_CODFOL
	
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SRD.RD_FILIAL
		and SRA.RA_MAT = SRD.RD_MAT
	
		left join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_DEPTO = isnull(SRD.RD_DEPTO, SRA.RA_DEPTO)
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO

	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SRD.RD_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SRD.RD_ITEM
where
		SRD.RD_DATARQ >=:PERIODO_INI
	and SRD.D_E_L_E_T_ = ''
