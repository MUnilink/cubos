select
    ZG1.ZG1_FILORI as FILIAL_LOG,
    ZG1.ZG1_TABELA as TABELA_LOG,
    ZG1.ZG1_CODIGO as CODIGO_LOG,
    ZG1.ZG1_TIPO as TIPOCOD_LOG,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_HRPAD else 0 end as HORA_PADRAO,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_VLTOTL else 0 end as VALOR_TOTAL,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_VLHORA else 0 end as VALOR_HORA,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_HRPRO else 0 end as HORA_PRODT,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_VLPROD else 0 end as VALOR_PRODT,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_HRIMPR else 0 end as HORA_IMPRO,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_VLIMPR else 0 end as VALOR_IMPRO,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then ZG1.ZG1_VLPROD + ZG1.ZG1_VLIMPR else 0 end as SOMA_PROIMP,
    
    ZG1.ZG1_COMPET as PERIODO_LOG,
    ZG1.ZG1_DTCALC as CALCULO_CUSTO,
    ZG1.ZG1_USRCAL as USUARIO_CUSTO,
    ZG1.ZG1_ATIVO as LOG_ATIVO,

    ZC1.ZC1_FILIAL as FILIAL,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    
    ZC2.ZC2_COMPET,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 5 then 'CORTESIA'
        when 6 then 'ENCERRADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,
    
    case ZG1.ZG1_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'TAXAS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO,
    
    trim(ZC2.ZC2_COD) as INSUMO,
    ZC2.ZC2_ITEM as ITEM,

    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,

    ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as TOT_ITEMPRE,
    ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as TOT_ITEMREA,

    case cast(ZC2.ZC2_TIPO as int)
        when 1 then (select max(case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end) from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 1)
        when 11 then (select max(case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end) from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 11)
        when 2 then (select max(trim(SRJ010.RJ_DESC)) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 2)
        when 3 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 3)
        when 4 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 4)
        when 6 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 6)
        when 7 then (select max(trim(ZA7010.ZA7_DESC)) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
        when 9 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 9)
        when 10 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 10)
        when 12 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 12)
        when 13 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 13)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,

    isnull(nullif(concat(ZC2.ZC2_NUM, '-', ZC2.ZC2_ITEM), '-'), 'COMPARATIVO TIPO ' + ZC2.ZC2_TIPO) as OS_ITEM,

    (select sum(SD3010.D3_CUSTO1) from SD3010 (nolock) where SD3010.D_E_L_E_T_ = '' and SD3010.D3_FILIAL = ZC2.ZC2_FILIAL and SD3010.D3_YOS = ZC2.ZC2_NUM and SD3010.D3_COD = ZC2.ZC2_COD and eomonth(SD3010.D3_EMISSAO) = ZC2.ZC2_COMPET and SD3010.D3_ESTORNO != 'S' and ZC2.ZC2_TIPO = 4 and ZG1.ZG1_TABELA = 'SD3') as ESTOQUE,
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then (select sum(TQN010.TQN_VALTOT) from TQN010 (nolock) where TQN010.D_E_L_E_T_ = '' and TQN010.TQN_FROTA = ZC2.ZC2_COD and eomonth(TQN010.TQN_DTABAS) = ZC2.ZC2_COMPET and ZC2.ZC2_TIPO = 10 and ZG1.ZG1_TABELA = 'TQN') else 0 end as COMBUSTIVEL,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(STL010.TL_CUSTO)
        from STJ010 (nolock)
            left join STL010 (nolock)
                on STL010.D_E_L_E_T_ = ''
                and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                and STL010.TL_PLANO = STJ010.TJ_PLANO
                and STL010.TL_ORDEM = STJ010.TJ_ORDEM
        where
                STJ010.D_E_L_E_T_ = ''
            and STJ010.TJ_CODBEM = ZC2.ZC2_COD
            and eomonth(STL010.TL_DTFIM) = ZC2.ZC2_COMPET
            and STL010.TL_SEQRELA > 0
            and ZC2.ZC2_TIPO = 3
    ) else 0 end as MANUTENCAO,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(SN4010.N4_VLROC1)
        from SN4010 (nolock)
            inner join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and SN3010.N3_CBASE = SN4010.N4_CBASE
                and SN3010.N3_ITEM = SN4010.N4_ITEM

                inner join SN1010 (nolock)
                    on SN1010.D_E_L_E_T_ = ''
                    and SN1010.N1_CBASE = SN3010.N3_CBASE
                    and SN1010.N1_ITEM = SN3010.N3_ITEM
        where
                SN4010.D_E_L_E_T_ = ''
            and SN1010.N1_CODBEM = ZC2.ZC2_COD
            and eomonth(SN4010.N4_DATA) = ZC2.ZC2_COMPET
            and SN4010.N4_OCORR = 6
            and SN4010.N4_TIPOCNT = 3
            and ZC2.ZC2_TIPO = 6
    ) else 0 end as DEPRECIACAO,

    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(TS1.DOCTAX_VALOR)/12
        from
        (
            select
                TS1010.TS1_CODBEM,
                TS1010.TS1_DOCTO,
                max(TS1010.TS1_DTVENC) as DOCTAX_DTVENC,
                max(TS1010.TS1_VALOR) as DOCTAX_VALOR
            from TS1010 (nolock)
            where
                    TS1010.D_E_L_E_T_ = ''
                and TS1.TS1_DOCTO in (1, 2, 3, 7)
                and TS1010.TS1_CODBEM = ZC2.ZC2_COD
                and TS1010.TS1_DTVENC <= ZC2.ZC2_COMPET
            group by
                TS1010.TS1_CODBEM,
                TS1010.TS1_DOCTO
        ) TS1
        where
                ZC2.ZC2_TIPO = 9
    ) else 0 end as DOCUMENTACAO,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(case when CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2)) else case when CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end)
        from CT2010 (nolock)
            inner join ZA8010 (nolock)
                on ZA8010.D_E_L_E_T_ = ''
                and (CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM or CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM)
                and (CT2010.CT2_ITEMD between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM or CT2010.CT2_ITEMC between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM)
                and (CT2010.CT2_CCD between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM or CT2010.CT2_CCC between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM)

                inner join ZA7010 (nolock)
                    on ZA7010.D_E_L_E_T_ = ''
                    and ZA7010.ZA7_COD = ZA8010.ZA8_COD
        where
                CT2010.D_E_L_E_T_ = ''
            and ZA7010.ZA7_COD = ZC2.ZC2_COD
            and eomonth(CT2010.CT2_DATA) = ZC2.ZC2_COMPET
            and ZC2.ZC2_TIPO = 7
    ) else 0 end as CONTABILIDADE,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(ZC2010.ZC2_TOTAL)
        from ZC2010 (nolock)
        where
                ZC2010.D_E_L_E_T_ = ''
            and ZC2010.ZC2_TIPO = 12

            and ZC2010.ZC2_COD = ZC2.ZC2_COD
            and ZC2010.ZC2_COMPET = ZC2.ZC2_COMPET
    ) else 0 end as SEGURO,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(ZC2010.ZC2_TOTAL)
        from ZC2010 (nolock)
        where
                ZC2010.D_E_L_E_T_ = ''
            and ZC2010.ZC2_TIPO = 11
            
            and ZC2010.ZC2_COD = ZC2.ZC2_COD
            and ZC2010.ZC2_COMPET = ZC2.ZC2_COMPET
    ) else 0 end as TAXAS_CIPP,
    
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select sum(case when SRD010.RD_PD in (440, 445) then SRD010.RD_VALOR*-1 else SRD010.RD_VALOR end)
		from SRD010 (nolock)
			inner join SRA010 (nolock)
				on SRA010.D_E_L_E_T_ = ''
				and SRA010.RA_FILIAL = SRD010.RD_FILIAL
				and SRA010.RA_MAT = SRD010.RD_MAT
			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and SRV.RV_FILIAL = substring(SRD010.RD_FILIAL, 1, 4)
				and SRV.RV_COD = SRD010.RD_PD
		where
				SRD010.D_E_L_E_T_ = ''
			and SRD010.RD_FILIAL = ZC2.ZC2_FILIAL
			and SRD010.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
			and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
            and ZC2.ZC2_TIPO = 2
            and ZG1.ZG1_TABELA = 'SRJ'
	) else 0 end as VALOR_FOLHA,
	
    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
		select sum(SRT010.RT_VALOR)
		from SRT010 (nolock)
			inner join SRA010 (nolock)
				on SRA010.D_E_L_E_T_ = ''
				and SRA010.RA_FILIAL = SRT010.RT_FILIAL
				and SRA010.RA_MAT = SRT010.RT_MAT
				
				inner join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC

			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and SRV.RV_FILIAL = substring(SRT010.RT_FILIAL, 1, 4)
				and SRV.RV_COD = SRT010.RT_VERBA
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = ZC2.ZC2_FILIAL
			and SRT010.RT_DATACAL = ZC2.ZC2_COMPET
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
			and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
            and ZC2.ZC2_TIPO = 2
            and ZG1.ZG1_TABELA = 'SRJ'
	) else 0 end as VALOR_PROV,

    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
	(
		select sum(SRD010.RD_HORAS) * avg(cast(SRJ010.RJ_YHRPADR as int))
		from SRD010 (nolock)
			inner join SRA010 (nolock)
				on SRD010.D_E_L_E_T_ = ''
				and SRD010.RD_FILIAL = SRA010.RA_FILIAL
				and SRD010.RD_MAT = SRA010.RA_MAT
				
				inner join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC

			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and substring(SRD010.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
				and SRD010.RD_PD = SRV.RV_COD
		where
				SRD010.D_E_L_E_T_ = ''
			and SRD010.RD_FILIAL = ZC2.ZC2_FILIAL
			and SRD010.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
            and ZC2.ZC2_TIPO = 2
            and ZG1.ZG1_TABELA = 'SRJ'
			and SRD010.RD_PD in (20, 130, 51, 50, 200, 358) /* DIAS TRABALHADOS, FÉRIAS, AUX. DOENÇA, AUX. MATERNIDADE, VALOR DE AFASTAMENTO,  AUX. ACIDENTE*/
	)/30 else 0 end as DIAS_FOLHA,

    case when lag(ZG1.ZG1_CODIGO, 1, '-') over(partition by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_TIPO, ZG1.ZG1_TABELA, ZG1.ZG1_CODIGO order by ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO) = '-' then
    (
        select max(cast(ST6010.T6_YHRPADR as int))
        from ST9010 (nolock)
            inner join ST6010 (nolock)
                on ST6010.D_E_L_E_T_ = ''
                and ST6010.T6_CODFAMI = ST9010.T9_CODFAMI
        where
                ST9010.D_E_L_E_T_ = ''
            and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD)
            and ZC2.ZC2_TIPO = 3
    ) * datediff(day, dateadd(day, 1, dateadd(month, -1, ZC2.ZC2_DTFIM)), eomonth(ZC2.ZC2_DTFIM))
    else 0 end as DIAS_EQUIP

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    left join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
        and ZG1.ZG1_TIPO = ZC2.ZC2_TIPO
        and ZG1.ZG1_CODIGO = ZC2.ZC2_COD
        and ZG1.ZG1_COMPET = substring(ZC2.ZC2_COMPET, 1, 6)
        and ZG1.ZG1_ATIVO = 'S'
where
        ZC2.D_E_L_E_T_ = ''
