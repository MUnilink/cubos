with SR8 as
(
	select
		SR8010.R8_MAT as MATRICULA,
		SR8010.R8_FILIAL as FILIAL,
		floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) as AFASTA_MESES,
		
		cast
		(
			case
				when SR8010.R8_TIPOAFA = '001' then SR8010.R8_DATAINI
				when SR8010.R8_DURACAO > 15 and datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM)) = 0 then SR8010.R8_DATAINI /* afastamento no mês */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAINI)) > 14 then eomonth(SR8010.R8_DATAINI)
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAINI)) <= 14 then dateadd(day, 1, eomonth(SR8010.R8_DATAINI))
			end as date
		) as DATA_INI,

		cast
		(
			case
				when SR8010.R8_TIPOAFA = '001' then SR8010.R8_DATAFIM
				when SR8010.R8_DURACAO > 15 and datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM)) = 0 then SR8010.R8_DATAFIM /* afastamento no mês */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, concat(left(SR8010.R8_DATAFIM, 6), '01'), SR8010.R8_DATAFIM) > 14 then eomonth(SR8010.R8_DATAFIM)
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, concat(left(SR8010.R8_DATAFIM, 6), '01'), SR8010.R8_DATAFIM) <= 14 then dateadd(day, -1, concat(left(SR8010.R8_DATAFIM, 6), '01'))
			end as date
		) as DATA_FIM,

		SR8010.R8_TIPOAFA,
		case when SR8010.R8_TIPOAFA = '001' then 'F' when SR8010.R8_DURACAO > 15 then 'A' end as SITUACAO,
		cast(SR8010.R8_DATA as date) as DATA_ALTER,
		cast(SR8010.R8_DATAINI as date) as DATA_INIAFA,
		cast(SR8010.R8_DATAFIM as date) as DATA_FIMAFA,
		cast(SR8010.R8_DURACAO as numeric(15, 2)) as DURACAO,
		left(SR8010.R8_PER, 6) as PERIODO_AFASTA

	from SR8010 (nolock)
	where SR8010.D_E_L_E_T_ = ''
),

SRV as
(
    select
        SRV010.RV_COD,
        isnull(nullif(trim(SRV010.RV_DESCDET), ''), SRV010.RV_DESC) as DESC_VERBA,
        SRV010.RV_TIPOCOD,
        case when SRV010.RV_COD in ('290', '300', '990') then 1 else 0 end as SALARIO_BASE,
        case when SRV010.RV_COD in ('182', '183', '995', '999') then 1 else 0 end as VALOR_LIQUIDO,
        
        /* proventos */
        case when SRV010.RV_COD in ('020') then 1 else 0 end as DIAS_TRABALHADOS,
        case when SRV010.RV_COD in ('013', '017', '039', '215') then 1 else 0 end as ADIC_RISCO,
        case when SRV010.RV_COD in ('030', '041', '371') then 1 else 0 end as ADIC_NOTURNO,
        case when SRV010.RV_COD in ('451', '452') then 1 else 0 end as DOBRAS_DOMINGOS,
        case when SRV010.RV_COD in ('011', '247', '353') then 1 else 0 end as ADIC_TEMPOSERVICO,
        case when SRV010.RV_COD in ('029', '061', '062', '063', '064', '112', '113', '116', '344', '370') then 1 else 0 end as HREXTRA_APROVADA,
        case when SRV010.RV_COD in ('091', '140', '147', '304') then 1 else 0 end as ARRED_PROV,
        
        /* descontos */
        case when SRV010.RV_COD in ('420', '421', '422', '423') then 1 else 0 end as IR,
        case when SRV010.RV_COD in ('401', '402', '403') then 1 else 0 end as INSS,
        case when SRV010.RV_COD in ('373', '374', '414', '530', '532', '533', '535') then 1 else 0 end as PENSAO_ALIM,
        case when SRV010.RV_COD in ('407') then 1 else 0 end as MENS_SINDICAL,
        case when SRV010.RV_COD in ('738') then 1 else 0 end as PLANO_SAUDE,
        case when SRV010.RV_COD in ('461') then 1 else 0 end as ARRED_DESC,
        case when SRV010.RV_COD in ('562') then 1 else 0 end as VLCESTA_DESC,
        case when SRV010.RV_COD in ('561') then 1 else 0 end as VLTRANP_DESC,

        /* base provento */
        case when SRV010.RV_COD in ('057') then 1 else 0 end as DIARIAS,
        case when SRV010.RV_COD in ('456', '457') then 1 else 0 end as PROV_ECONSIG,
        case when SRV010.RV_COD in ('796') then 1 else 0 end as VLTRANP_BASE,
        case when SRV010.RV_COD in ('749') then 1 else 0 end as VLCESTA_BASE,
        case when SRV010.RV_COD in ('719') then 1 else 0 end as VLALIM_BASE,
        case when SRV010.RV_COD in ('998') then 1 else 0 end as VLCOMB_BASE,

        /* base desconto */
        case when SRV010.RV_COD in ('290', '300') then 1 else 0 end as AVOS_13,
        case when SRV010.RV_COD in ('015', '167') then 1 else 0 end as INSALUBRIDADE_13,
        case when SRV010.RV_COD in ('208', '772') then 1 else 0 end as ADRISCO_MATER_13,
        case when SRV010.RV_COD in ('009', '204', '307', '768') then 1 else 0 end as MEDIA_VL_13,
        case when SRV010.RV_COD in ('010', '205', '306', '769') then 1 else 0 end as MEDIA_HR_13,
        case when SRV010.RV_COD in ('35A') then 1 else 0 end as VLEX_TEMPOCASA,

        /* bases encargos */
        case when SRV010.RV_COD in ('701', '702') then 1 else 0 end as BASE_IR,
        case when SRV010.RV_COD in ('725', '726') then 1 else 0 end as BASE_INSS,
        case when SRV010.RV_COD in ('745', '747') then 1 else 0 end as BASE_FGTS,
        
        /* valores encargos */
        case when SRV010.RV_COD in ('759', '760', '761', '800') then 1 else 0 end as FGTS,
        case when SRV010.RV_COD in ('950', '955', '960', '961', '962') then 1 else 0 end as INCRA_SISTEMA_S,
        case when SRV010.RV_COD in ('815', '817') then 1 else 0 end as INSS_ACIDPATR,
        /* valores benefícios */
        /* econsignado provento */
        case when SRV010.RV_COD in ('454', '457') then 1 else 0 end as ECONSIGNADO_PROV,

        case SRV010.RV_TIPOCOD
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA
    from SRV010
    where SRV010.D_E_L_E_T_ = ''
)

    select
        SRC.RC_FILIAL as FILIAL,
        SRC.RC_PERIODO as PERIODO,
        substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
        SRC.RC_MAT as MATRICULA,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        SRC.RC_PD as VERBA,
        SRV.DESC_VERBA,
        SRC.RC_SEQ as SEQ,
        SRC.RC_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,
        case when trim(SRV.RV_TIPOCOD) = '1' and SRV.RV_COD not in ('454', '457') then SRC.RC_VALOR else 0.0 end as PROVENTOS,
        case when trim(SRV.RV_TIPOCOD) != '1' then 0.0 when trim(SRV.RV_TIPOCOD) = '1' and SRC.RC_PD not in ('020', '039', '215', '041', '030', '371', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '039', '215', '041', '030', '371', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '009', '010', '011', '017', '768', '769', '772', '029', '457') then SRC.RC_VALOR else 0.0 end as OUTROS_PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRC.RC_VALOR else 0.0 end as DESCONTOS,
        case when trim(SRV.RV_TIPOCOD) != '2' then 0.0 when trim(SRV.RV_TIPOCOD) = '2' and SRC.RC_PD not in ('420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '456', '420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '045', '414', '533') then SRC.RC_VALOR else 0.0 end as OUTROS_DESCONTOS,
        
        SRA.RA_SALARIO * SRV.SALARIO_BASE as SALARIO_BASE,
        SRC.RC_VALOR * SRV.VALOR_LIQUIDO as VALOR_LIQUIDO,
        
        SRC.RC_VALOR * SRV.DIAS_TRABALHADOS as DIAS_TRABALHADOS,
        SRC.RC_VALOR * SRV.ADIC_RISCO as ADIC_RISCO,
        SRC.RC_VALOR * SRV.ADIC_NOTURNO as ADIC_NOTURNO,
        SRC.RC_VALOR * SRV.DOBRAS_DOMINGOS as DOBRAS_DOMINGOS,
        SRC.RC_VALOR * SRV.ADIC_TEMPOSERVICO as ADIC_TEMPOSERVICO,
        SRC.RC_VALOR * SRV.HREXTRA_APROVADA as HREXTRA_APROVADA,
        SRC.RC_VALOR * SRV.ARRED_PROV as ARRED_PROV,
        /**/
        SRC.RC_VALOR * SRV.IR as IR,
        SRC.RC_VALOR * SRV.INSS as INSS,
        SRC.RC_VALOR * SRV.PENSAO_ALIM as PENSAO_ALIM,
        SRC.RC_VALOR * SRV.MENS_SINDICAL as MENS_SINDICAL,
        SRC.RC_VALOR * SRV.PLANO_SAUDE as PLANO_SAUDE,
        SRC.RC_VALOR * SRV.ARRED_DESC as ARRED_DESC,
        SRC.RC_VALOR * SRV.VLCESTA_DESC as VLCESTA_DESC,
        SRC.RC_VALOR * SRV.VLTRANP_DESC as VLTRANP_DESC,
        /**/
        SRC.RC_VALOR * SRV.DIARIAS as DIARIAS,
        SRC.RC_VALOR * SRV.PROV_ECONSIG as PROV_ECONSIG,
        SRC.RC_VALOR * SRV.VLTRANP_BASE as VLTRANP_BASE,
        SRC.RC_VALOR * SRV.VLCESTA_BASE as VLCESTA_BASE,
        SRC.RC_VALOR * SRV.VLALIM_BASE as VLALIM_BASE,
        SRC.RC_VALOR * SRV.VLCOMB_BASE as VLCOMB_BASE,
        
        /* 13º SALÁRIO */
        SRC.RC_HORAS * SRV.AVOS_13 as AVOS_13,
        SRC.RC_VALOR * SRV.INSALUBRIDADE_13 as INSALUBRIDADE_13,
        SRC.RC_VALOR * SRV.ADRISCO_MATER_13 as ADRISCO_MATER_13,
        SRC.RC_VALOR * SRV.MEDIA_VL_13 as MEDIA_VL_13,
        SRC.RC_VALOR * SRV.MEDIA_HR_13 as MEDIA_HR_13,
        SRC.RC_VALOR * SRV.VLEX_TEMPOCASA as VLEX_TEMPOCASA,

        SRC.RC_VALOR * SRV.BASE_IR as BASE_IR,
        SRC.RC_VALOR * SRV.BASE_INSS as BASE_INSS,
        SRC.RC_VALOR * SRV.BASE_FGTS as BASE_FGTS,
        SRC.RC_VALOR * SRV.FGTS as FGTS,
        SRC.RC_VALOR * SRV.INCRA_SISTEMA_S as INCRA_SISTEMA_S,
        SRC.RC_VALOR * SRV.INSS_ACIDPATR as INSS_ACIDPATR,
        SRC.RC_VALOR * SRV.ECONSIGNADO_PROV as ECONSIGNADO_PROV,

        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(CTT010.CTT_DESC01) as CENTRO_CUSTO,
        trim(SRA.RA_NOMECMP) as NOME,
        SRA.RA_SITFOLH as SITUACAO,
        trim(SQ3.Q3_CARGO) as CARGO,
        trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
        trim(SRJ.RJ_FUNCAO) as FUNCAO,
        trim(SRJ.RJ_DESC) as DESC_FUNCAO,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,

        SRC.RC_VALOR as VALOR,
        SRC.RC_HORAS as HORAS,
        SR8.SITUACAO as SITUACAO_FOLHA

    from SRC010 SRC (nolock)
        left join SRV
            on SRV.RV_COD = SRC.RC_PD
        left join SR8
            on eomonth(concat(SRC.RC_PERIODO, '01')) between eomonth(SR8.DATA_INI) and eomonth(SR8.DATA_FIM)
            and SR8.MATRICULA = SRC.RC_MAT
            and SR8.FILIAL = SRC.RC_FILIAL
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRC.RC_FILIAL
            and SRA.RA_MAT = SRC.RC_MAT
            and trim(SRC.RC_MAT) not in ('003264', '003263')

            left join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and CTD010.CTD_ITEM = SRC.RC_ITEM
        left join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and CTT010.CTT_CUSTO = SRC.RC_CC
    where SRC.D_E_L_E_T_ = ''
union
    select
        SRD.RD_FILIAL as FILIAL,
        SRD.RD_PERIODO as PERIODO,
        substring(SRD.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRD.RD_PERIODO, 1, 4) as PERIODO_ANO,
        SRD.RD_MAT as MATRICULA,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        SRD.RD_PD as VERBA,
        SRV.DESC_VERBA,
        SRD.RD_SEQ as SEQ,
        SRD.RD_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,
        case when trim(SRV.RV_TIPOCOD) = '1' and SRV.RV_COD not in ('454', '457') then SRD.RD_VALOR else 0.0 end as PROVENTOS,
        case when trim(SRV.RV_TIPOCOD) != '1' then 0.0 when trim(SRV.RV_TIPOCOD) = '1' and SRD.RD_PD not in ('020', '039', '215', '041', '030', '371', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '039', '215', '041', '030', '371', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '009', '010', '011', '017', '768', '769', '772', '029', '457') then SRD.RD_VALOR else 0.0 end as OUTROS_PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRD.RD_VALOR else 0.0 end as DESCONTOS,
        case when trim(SRV.RV_TIPOCOD) != '2' then 0.0 when trim(SRV.RV_TIPOCOD) = '2' and SRD.RD_PD not in ('420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '456', '420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '045', '414', '533') then SRD.RD_VALOR else 0.0 end as OUTROS_DESCONTOS,
        
        SRA.RA_SALARIO * SRV.SALARIO_BASE as SALARIO_BASE,
        SRD.RD_VALOR * SRV.VALOR_LIQUIDO as VALOR_LIQUIDO,
        
        SRD.RD_VALOR * SRV.DIAS_TRABALHADOS as DIAS_TRABALHADOS,
        SRD.RD_VALOR * SRV.ADIC_RISCO as ADIC_RISCO,
        SRD.RD_VALOR * SRV.ADIC_NOTURNO as ADIC_NOTURNO,
        SRD.RD_VALOR * SRV.DOBRAS_DOMINGOS as DOBRAS_DOMINGOS,
        SRD.RD_VALOR * SRV.ADIC_TEMPOSERVICO as ADIC_TEMPOSERVICO,
        SRD.RD_VALOR * SRV.HREXTRA_APROVADA as HREXTRA_APROVADA,
        SRD.RD_VALOR * SRV.ARRED_PROV as ARRED_PROV,
        /**/
        SRD.RD_VALOR * SRV.IR as IR,
        SRD.RD_VALOR * SRV.INSS as INSS,
        SRD.RD_VALOR * SRV.PENSAO_ALIM as PENSAO_ALIM,
        SRD.RD_VALOR * SRV.MENS_SINDICAL as MENS_SINDICAL,
        SRD.RD_VALOR * SRV.PLANO_SAUDE as PLANO_SAUDE,
        SRD.RD_VALOR * SRV.ARRED_DESC as ARRED_DESC,
        SRD.RD_VALOR * SRV.VLCESTA_DESC as VLCESTA_DESC,
        SRD.RD_VALOR * SRV.VLTRANP_DESC as VLTRANP_DESC,
        /**/
        SRD.RD_VALOR * SRV.DIARIAS as DIARIAS,
        SRD.RD_VALOR * SRV.PROV_ECONSIG as PROV_ECONSIG,
        SRD.RD_VALOR * SRV.VLTRANP_BASE as VLTRANP_BASE,
        SRD.RD_VALOR * SRV.VLCESTA_BASE as VLCESTA_BASE,
        SRD.RD_VALOR * SRV.VLALIM_BASE as VLALIM_BASE,
        SRD.RD_VALOR * SRV.VLCOMB_BASE as VLCOMB_BASE,
        
        /* 13º SALÁRIO */
        SRD.RD_HORAS * SRV.AVOS_13 as AVOS_13,
        SRD.RD_VALOR * SRV.INSALUBRIDADE_13 as INSALUBRIDADE_13,
        SRD.RD_VALOR * SRV.ADRISCO_MATER_13 as ADRISCO_MATER_13,
        SRD.RD_VALOR * SRV.MEDIA_VL_13 as MEDIA_VL_13,
        SRD.RD_VALOR * SRV.MEDIA_HR_13 as MEDIA_HR_13,
        SRD.RD_VALOR * SRV.VLEX_TEMPOCASA as VLEX_TEMPOCASA,

        /* bases encargos */
        SRD.RD_VALOR * SRV.BASE_IR as BASE_IR,
        SRD.RD_VALOR * SRV.BASE_INSS as BASE_INSS,
        SRD.RD_VALOR * SRV.BASE_FGTS as BASE_FGTS,
        SRD.RD_VALOR * SRV.FGTS as FGTS,
        SRD.RD_VALOR * SRV.INCRA_SISTEMA_S as INCRA_SISTEMA_S,
        SRD.RD_VALOR * SRV.INSS_ACIDPATR as INSS_ACIDPATR,
        SRD.RD_VALOR * SRV.ECONSIGNADO_PROV as ECONSIGNADO_PROV,

        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(CTT010.CTT_DESC01) as CENTRO_CUSTO,
        trim(SRA.RA_NOMECMP) as NOME,
        SRA.RA_SITFOLH as SITUACAO,
        trim(SQ3.Q3_CARGO) as CARGO,
        trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
        trim(SRJ.RJ_FUNCAO) as FUNCAO,
        trim(SRJ.RJ_DESC) as DESC_FUNCAO,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,

        SRD.RD_VALOR as VALOR,
        SRD.RD_HORAS as HORAS,
        SR8.SITUACAO as SITUACAO_FOLHA

    from SRD010 SRD (nolock)
        left join SRV
            on SRV.RV_COD = SRD.RD_PD
        left join SR8
            on eomonth(concat(SRD.RD_DATARQ, '01')) between eomonth(SR8.DATA_INI) and eomonth(SR8.DATA_FIM)
            and SR8.MATRICULA = SRD.RD_MAT
            and SR8.FILIAL = SRD.RD_FILIAL
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT
            and trim(SRD.RD_MAT) not in ('003264', '003263')

            left join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and CTD010.CTD_ITEM = SRD.RD_ITEM
        left join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and CTT010.CTT_CUSTO = SRD.RD_CC
    where
            SRD.RD_DATARQ > '202501'
        and SRD.D_E_L_E_T_ = ''
