    select
        SRC.RC_FILIAL as FILIAL,
        SRC.RC_PERIODO as PERIODO,
        substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
        SRC.RC_MAT as MATRICULA,
        SRC.RC_PD as VERBA,
        (select trim(coalesce(SRV010.RV_DESCDET, SRV010.RV_DESC)) from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRC.RC_PD) as DESC_VERBA,
        SRC.RC_SEQ as SEQ,
        SRC.RC_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        CTD010.CTD_DESC01 as ATIVIDADE,
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

        case
            when SRV.RV_COD in ('029', '111', '112', '113', '344') then 'HORAS_EXTRAS'
            when SRV.RV_COD in ('113', '451', '452') then 'DOBRAS_PROVENTOS'
            when SRV.RV_COD in ('623') then 'DOBRAS_DESCONTOS'
            when SRV.RV_COD in ('030', '041', '371', '372') then 'ADICIONAL_NOTURNO'
            when SRV.RV_COD in ('039', '096', '097', '215', '356', '013') then 'PERICULOSIDADES'
            when SRV.RV_COD in ('285', '561', '796') then 'VALE_TRANSPORTE'
            when SRV.RV_COD in ('410', '560', '563', '719') then 'VALE_ALIMENTACAO'
            when SRV.RV_COD in ('562', '749') then 'VALE_CESTA'
            when SRV.RV_COD in ('738') then 'PLANO_SAUDE'
            when SRV.RV_COD in ('056', '570', '574', '575', '576', '577', '711') then 'PLANO_ODONTOLOGICO'
            when SRV.RV_COD in ('057') then 'DIARIAS_VIAGEM'
            when SRV.RV_COD in ('132', '133') then 'FERIAS_COMPRADAS'
            when SRV.RV_COD in ('001', '147', '450') then 'ADIANTAMENTO'
            when SRV.RV_COD in ('147') then 'ARR_ADIANTAMENTO'
            when SRV.RV_COD in ('421') then 'IR_ADIANTAMENTO'
            when SRV.RV_COD in ('306') then 'SEGUNDA_13_MEDIA_DSR_ADRISCO'
            when SRV.RV_COD in ('307') then 'SEGUNDA_13_MEDIA_VAL_ADRISCO'
            when SRV.RV_COD in ('208') then 'SEGUNDA_13_ADICRISCO'
            /* acima resumo, abaixo aberta */
            when SRV.RV_COD in ('796', '560', '563', '719', '749', '056', '570', '574', '575', '576', '577', '711', '738', '057', '008', '132', '133', '113', '029', '111', '112', '113', '344', '030', '041', '039', '096', '097', '215', '356', '054', '113', '407', '001', '000', '999') then 'Custo_pessoal'
            when SRV.RV_COD in ('796') then 'TOTAL_VT'
            when SRV.RV_COD in ('560', '563', '719') then 'Vale_Alimentação_Total'
            when SRV.RV_COD in ('749') then 'Cesta_Básica'
            when SRV.RV_COD in ('056', '570', '574', '575', '576', '577', '711') then 'Plano_Odontológico_Empresa'
            when SRV.RV_COD in ('738') then 'Hapvida_Empresa'
            when SRV.RV_COD in ('057') then 'Diárias_Motoristas'
            when SRV.RV_COD in ('020', '025') then 'Dias_Trabalhados'
            when SRV.RV_COD in ('020', '025') then 'Salário_Base_Pro_ratamês'
            when SRV.RV_COD in ('008') then 'PTS_premio_tempo_serviço'
            when SRV.RV_COD in ('132', '152') then 'Férias_Qtde_de_dias_comprados'
            when SRV.RV_COD in ('132', '133') then 'Pgto_de_férias_compradas'
            when SRV.RV_COD in ('113', '451', '452') then 'Dobras_DomingosFeriados_provento'
            when SRV.RV_COD in ('623') then 'Dobras_DomingosFeriados_desconto'
            when SRV.RV_COD in ('623') then 'Dobras_DomingosFeriados'
            when SRV.RV_COD in ('029', '111', '112', '113', '344') then 'Hora_Extra_Eventual_mês'
            when SRV.RV_COD in ('030', '041', '371', '372') then 'Adicional_Noturno_FIXO'
            when SRV.RV_COD in ('039', '096', '097', '215', '356', '013') then 'Pericul_FIXA'
            when SRV.RV_COD in ('054') then 'Sal_Família'
            when SRV.RV_COD in ('001') then 'Pgto_1a_Q_créd_em_folha_PROVENTO'
            when SRV.RV_COD in ('450') then 'Pgto_1a_Q_créd_em_folha_DESCONTO'
            when SRV.RV_COD in ('461') then 'Arredond_1'
            when SRV.RV_COD in ('091') then 'Arredond_2'
            when SRV.RV_COD in ('000') then 'Pgto_1a_Q_espécie'
            when SRV.RV_COD in ('183') then 'Saldo_Folha_Pgto_1a_Q'
            when SRV.RV_COD in ('999') then 'Pgto_2a_Q_créd_em_folha'
            when SRV.RV_COD in ('567') then 'BV_Financ'
            when SRV.RV_COD in ('474') then 'Santander_Financ'
            when SRV.RV_COD in ('566') then 'BioRC_Financ'
            when SRV.RV_COD in ('113') then 'Dia_do_Motorista'
            when SRV.RV_COD in ('147') then 'Arredond_3'
            when SRV.RV_COD in ('140') then 'Arredond_4'
            when SRV.RV_COD in ('000') then 'Pgto_2a_Q_espécie'
            when SRV.RV_COD in ('999') then 'Saldo_Folha_Pgto_2a_Q'
            when SRV.RV_COD in ('402') then 'INSS_ferias'
            when SRV.RV_COD in ('569', '570', '574', '575', '576', '577') then 'Plano_Odontológico_funcionario'
            when SRV.RV_COD in ('565', '571') then 'Hapvida_funcionario'
            when SRV.RV_COD in ('420', '421', '422') then 'ImpRenda'
            when SRV.RV_COD in ('421') then 'ImpRendaAdd'
            when SRV.RV_COD in ('530', '535', '414') then 'Pens_Alim'
            when SRV.RV_COD in ('407') then 'Mensal_Sind_Patronal'
            when SRV.RV_COD in ('980') then 'Cont_Sindical_Funcionario'
            when SRV.RV_COD in ('622') then 'ContAssist'
            when SRV.RV_COD in ('440') then 'Faltas_DSR'
            when SRV.RV_COD in ('440', '445') then 'Atrasos_Suspensao_Faltas_em_Horas'
            when SRV.RV_COD in ('410') then 'Desconto_VA'
            when SRV.RV_COD in ('597') then 'Descontos_autorizados'
            when SRV.RV_COD in ('561') then 'DescontoVT'
            
            when SRV.RV_COD in ('300') then 'Segunda_13_avos'
            when SRV.RV_COD in ('015') then 'Segunda_13_valor_insalubridade'
            when SRV.RV_COD in ('304') then 'Segunda_13_valor_arredondamento'
            when SRV.RV_COD in ('013') then 'Segunda_13_media_periculosidade'
            when SRV.RV_COD in ('306') then 'Segunda_13_media_horas'
            when SRV.RV_COD in ('307') then 'Segunda_13_media_valor'
            when SRV.RV_COD in ('000') then 'Segunda_13_media_outros'
            when SRV.RV_COD in ('247') then 'Segunda_13_valor_ATS'
            when SRV.RV_COD in ('203', '206') then 'Segunda_13_valor_maternidade'
            when SRV.RV_COD in ('208') then 'Segunda_13_valor_periculosidades'
            when SRV.RV_COD in ('000') then 'Segunda_13_valor_totaismedia'
            when SRV.RV_COD in ('403') then 'Segunda_13_valor_INSS'
            when SRV.RV_COD in ('423') then 'Segunda_13_valor_IR'
            when SRV.RV_COD in ('530', '535', '373', '374') then 'Segunda_13_valor_pensao_alim'
            when SRV.RV_COD in ('167') then 'Primeira_13_valor_insalubridade'
            when SRV.RV_COD in ('009') then 'Primeira_13_media_PericsAdicNoturnoDSR'
            when SRV.RV_COD in ('010') then 'Primeira_13_media_PericsAdicNoturno'
            when SRV.RV_COD in ('011') then 'Primeira_13_valor_ATS'
            when SRV.RV_COD in ('202') then 'Primeira_13_valor_maternidade'
            when SRV.RV_COD in ('373', '414', '533') then 'Primeira_13_valor_alimenticia'
            when SRV.RV_COD in ('746') then 'Primeira_13_valor_baseFGTS'
            when SRV.RV_COD in ('756') then 'Primeira_13_valor_FGTS'
            when SRV.RV_COD in ('009', '010', '768', '769', '770') then 'Primeira_13_valor_totaismedia'
            when SRV.RV_COD in ('182') then 'Primeira_13_valor_liquido_bas'
            when SRV.RV_COD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772') then 'Primeira_13'
            when SRV.RV_COD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770') then 'Primeira_13_avos'
            
            when SRV.RV_COD in ('000') then 'Observações_da_Folha_de_Adiantamento_1a_QUINZENA'
            when SRV.RV_COD in ('000') then 'Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA'

        else trim(coalesce(SRV.RV_DESCDET, SRV.RV_DESC, '')) end as NOME_VERBA

    from SRC010 SRC (nolock)
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
        left join SRV010 SRV (nolock)
            on SRV.RV_COD = SRC.RC_PD
    where SRC.D_E_L_E_T_ = ''
union
    select
        SRD.RD_FILIAL as FILIAL,
        SRD.RD_PERIODO as PERIODO,
        substring(SRD.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRD.RD_PERIODO, 1, 4) as PERIODO_ANO,
        SRD.RD_MAT as MATRICULA,
        SRD.RD_PD as VERBA,
        (select trim(coalesce(SRV010.RV_DESCDET, SRV010.RV_DESC)) from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD) as DESC_VERBA,
        SRD.RD_SEQ as SEQ,
        SRD.RD_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        CTD010.CTD_DESC01 as ATIVIDADE,
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

        case
            when SRV.RV_COD in ('029', '111', '112', '113', '344') then 'HORAS_EXTRAS'
            when SRV.RV_COD in ('113', '451', '452') then 'DOBRAS_PROVENTOS'
            when SRV.RV_COD in ('623') then 'DOBRAS_DESCONTOS'
            when SRV.RV_COD in ('030', '041', '371', '372') then 'ADICIONAL_NOTURNO'
            when SRV.RV_COD in ('039', '096', '097', '215', '356', '013') then 'PERICULOSIDADES'
            when SRV.RV_COD in ('285', '561', '796') then 'VALE_TRANSPORTE'
            when SRV.RV_COD in ('410', '560', '563', '719') then 'VALE_ALIMENTACAO'
            when SRV.RV_COD in ('562', '749') then 'VALE_CESTA'
            when SRV.RV_COD in ('738') then 'PLANO_SAUDE'
            when SRV.RV_COD in ('056', '570', '574', '575', '576', '577', '711') then 'PLANO_ODONTOLOGICO'
            when SRV.RV_COD in ('057') then 'DIARIAS_VIAGEM'
            when SRV.RV_COD in ('132', '133') then 'FERIAS_COMPRADAS'
            when SRV.RV_COD in ('001', '147', '450') then 'ADIANTAMENTO'
            when SRV.RV_COD in ('147') then 'ARR_ADIANTAMENTO'
            when SRV.RV_COD in ('421') then 'IR_ADIANTAMENTO'
            when SRV.RV_COD in ('306') then 'SEGUNDA_13_MEDIA_DSR_ADRISCO'
            when SRV.RV_COD in ('307') then 'SEGUNDA_13_MEDIA_VAL_ADRISCO'
            when SRV.RV_COD in ('208') then 'SEGUNDA_13_ADICRISCO'
            /* acima resumo, abaixo aberta */
            when SRV.RV_COD in ('796', '560', '563', '719', '749', '056', '570', '574', '575', '576', '577', '711', '738', '057', '008', '132', '133', '113', '029', '111', '112', '113', '344', '030', '041', '039', '096', '097', '215', '356', '054', '113', '407', '001', '000', '999') then 'Custo_pessoal'
            when SRV.RV_COD in ('796') then 'TOTAL_VT'
            when SRV.RV_COD in ('560', '563', '719') then 'Vale_Alimentação_Total'
            when SRV.RV_COD in ('749') then 'Cesta_Básica'
            when SRV.RV_COD in ('056', '570', '574', '575', '576', '577', '711') then 'Plano_Odontológico_Empresa'
            when SRV.RV_COD in ('738') then 'Hapvida_Empresa'
            when SRV.RV_COD in ('057') then 'Diárias_Motoristas'
            when SRV.RV_COD in ('020', '025') then 'Dias_Trabalhados'
            when SRV.RV_COD in ('020', '025') then 'Salário_Base_Pro_ratamês'
            when SRV.RV_COD in ('008') then 'PTS_premio_tempo_serviço'
            when SRV.RV_COD in ('132', '152') then 'Férias_Qtde_de_dias_comprados'
            when SRV.RV_COD in ('132', '133') then 'Pgto_de_férias_compradas'
            when SRV.RV_COD in ('113', '451', '452') then 'Dobras_DomingosFeriados_provento'
            when SRV.RV_COD in ('623') then 'Dobras_DomingosFeriados_desconto'
            when SRV.RV_COD in ('623') then 'Dobras_DomingosFeriados'
            when SRV.RV_COD in ('029', '111', '112', '113', '344') then 'Hora_Extra_Eventual_mês'
            when SRV.RV_COD in ('030', '041', '371', '372') then 'Adicional_Noturno_FIXO'
            when SRV.RV_COD in ('039', '096', '097', '215', '356', '013') then 'Pericul_FIXA'
            when SRV.RV_COD in ('054') then 'Sal_Família'
            when SRV.RV_COD in ('001') then 'Pgto_1a_Q_créd_em_folha_PROVENTO'
            when SRV.RV_COD in ('450') then 'Pgto_1a_Q_créd_em_folha_DESCONTO'
            when SRV.RV_COD in ('461') then 'Arredond_1'
            when SRV.RV_COD in ('091') then 'Arredond_2'
            when SRV.RV_COD in ('000') then 'Pgto_1a_Q_espécie'
            when SRV.RV_COD in ('183') then 'Saldo_Folha_Pgto_1a_Q'
            when SRV.RV_COD in ('999') then 'Pgto_2a_Q_créd_em_folha'
            when SRV.RV_COD in ('567') then 'BV_Financ'
            when SRV.RV_COD in ('474') then 'Santander_Financ'
            when SRV.RV_COD in ('566') then 'BioRD_Financ'
            when SRV.RV_COD in ('113') then 'Dia_do_Motorista'
            when SRV.RV_COD in ('147') then 'Arredond_3'
            when SRV.RV_COD in ('140') then 'Arredond_4'
            when SRV.RV_COD in ('000') then 'Pgto_2a_Q_espécie'
            when SRV.RV_COD in ('999') then 'Saldo_Folha_Pgto_2a_Q'
            when SRV.RV_COD in ('402') then 'INSS_ferias'
            when SRV.RV_COD in ('569', '570', '574', '575', '576', '577') then 'Plano_Odontológico_funcionario'
            when SRV.RV_COD in ('565', '571') then 'Hapvida_funcionario'
            when SRV.RV_COD in ('420', '421', '422') then 'ImpRenda'
            when SRV.RV_COD in ('421') then 'ImpRendaAdd'
            when SRV.RV_COD in ('530', '535', '414') then 'Pens_Alim'
            when SRV.RV_COD in ('407') then 'Mensal_Sind_Patronal'
            when SRV.RV_COD in ('980') then 'Cont_Sindical_Funcionario'
            when SRV.RV_COD in ('622') then 'ContAssist'
            when SRV.RV_COD in ('440') then 'Faltas_DSR'
            when SRV.RV_COD in ('440', '445') then 'Atrasos_Suspensao_Faltas_em_Horas'
            when SRV.RV_COD in ('410') then 'Desconto_VA'
            when SRV.RV_COD in ('597') then 'Descontos_autorizados'
            when SRV.RV_COD in ('561') then 'DescontoVT'
            
            when SRV.RV_COD in ('300') then 'Segunda_13_avos'
            when SRV.RV_COD in ('015') then 'Segunda_13_valor_insalubridade'
            when SRV.RV_COD in ('304') then 'Segunda_13_valor_arredondamento'
            when SRV.RV_COD in ('013') then 'Segunda_13_media_periculosidade'
            when SRV.RV_COD in ('306') then 'Segunda_13_media_horas'
            when SRV.RV_COD in ('307') then 'Segunda_13_media_valor'
            when SRV.RV_COD in ('000') then 'Segunda_13_media_outros'
            when SRV.RV_COD in ('247') then 'Segunda_13_valor_ATS'
            when SRV.RV_COD in ('203', '206') then 'Segunda_13_valor_maternidade'
            when SRV.RV_COD in ('208') then 'Segunda_13_valor_periculosidades'
            when SRV.RV_COD in ('000') then 'Segunda_13_valor_totaismedia'
            when SRV.RV_COD in ('403') then 'Segunda_13_valor_INSS'
            when SRV.RV_COD in ('423') then 'Segunda_13_valor_IR'
            when SRV.RV_COD in ('530', '535', '373', '374') then 'Segunda_13_valor_pensao_alim'
            when SRV.RV_COD in ('167') then 'Primeira_13_valor_insalubridade'
            when SRV.RV_COD in ('009') then 'Primeira_13_media_PericsAdicNoturnoDSR'
            when SRV.RV_COD in ('010') then 'Primeira_13_media_PericsAdicNoturno'
            when SRV.RV_COD in ('011') then 'Primeira_13_valor_ATS'
            when SRV.RV_COD in ('202') then 'Primeira_13_valor_maternidade'
            when SRV.RV_COD in ('373', '414', '533') then 'Primeira_13_valor_alimenticia'
            when SRV.RV_COD in ('746') then 'Primeira_13_valor_baseFGTS'
            when SRV.RV_COD in ('756') then 'Primeira_13_valor_FGTS'
            when SRV.RV_COD in ('009', '010', '768', '769', '770') then 'Primeira_13_valor_totaismedia'
            when SRV.RV_COD in ('182') then 'Primeira_13_valor_liquido_bas'
            when SRV.RV_COD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772') then 'Primeira_13'
            when SRV.RV_COD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770') then 'Primeira_13_avos'
            
            when SRV.RV_COD in ('000') then 'Observações_da_Folha_de_Adiantamento_1a_QUINZENA'
            when SRV.RV_COD in ('000') then 'Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA'

        else trim(coalesce(SRV.RV_DESCDET, SRV.RV_DESC, '')) end as NOME_VERBA

    from SRD010 SRD (nolock)
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
        left join SRV010 SRV (nolock)
            on SRV.RV_COD = SRD.RD_PD
    where
            datediff(month, concat(SRD.RD_DATARQ, '01'), getdate()) < 7
        and SRD.D_E_L_E_T_ = ''
