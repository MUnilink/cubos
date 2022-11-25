select
    trim(FOLHA_ABERTA.FILIAL) as FILIAL,
    trim(FOLHA_ABERTA.DATA_ADMISSAO) as DATA_ADMISSAO,
    trim(FOLHA_ABERTA.MATRICULA) as MATRICULA,
    trim(FOLHA_ABERTA.NOME) as NOME,
    trim(FOLHA_ABERTA.CENTRO_DE_CUSTO) as CENTRO_DE_CUSTO,
    trim(FOLHA_ABERTA.SITUACAO_FOLHA) as SITUACAO_FOLHA,
    trim(FOLHA_ABERTA.DESC_FUNCAO) as DESC_FUNCAO,
    trim(FOLHA_ABERTA.ATIVIDADE) as ATIVIDADE,
    trim(FOLHA_ABERTA.PERIODO_ANO) as PERIODO_ANO,
    trim(FOLHA_ABERTA.PERIODO_MES) as PERIODO_MES,

    sum(isnull(FOLHA_ABERTA.TOTAL_VT, 0.0)) as 'VT',
    sum(isnull(FOLHA_ABERTA.Vale_Alimentação_Total, 0.0)) as 'Vale Alimentação',
    sum(isnull(FOLHA_ABERTA.Cesta_Básica, 0.0)) as 'Cesta Básica',
    sum(isnull(FOLHA_ABERTA.Plano_Odontológico_Empresa, 0.0)) as 'Plano Odontológico Empresa',
    sum(isnull(FOLHA_ABERTA.Hapvida_Empresa, 0.0)) as 'Hapvida Empresa',
    sum(isnull(FOLHA_ABERTA.Diárias_Motoristas, 0.0)) as 'Diárias Motoristas',
    sum(isnull(FOLHA_ABERTA.Custo_pessoal, 0.0)) as 'Custo Total com Pessoal',
    sum(isnull(FOLHA_ABERTA.Total_de_Proventos, 0.0)) as 'Total de Proventos',
    max(isnull(FOLHA_ABERTA.Salario_Base, 0.0)) as 'Salario Base',
    sum(isnull(FOLHA_ABERTA.Dias_Trabalhados, 0.0)) as 'Dias Trabalhados',
    sum(isnull(FOLHA_ABERTA.Salário_Base_Pro_ratamês, 0.0)) as 'Salário Base Pro rata / mês',
    sum(isnull(FOLHA_ABERTA.PTS_premio_tempo_serviço, 0.0)) as 'PTS (premio tempo serviço)',
    sum(isnull(FOLHA_ABERTA.Férias_Qtde_de_dias_comprados, 0.0)) as 'Férias Qtde de dias comprados',
    sum(isnull(FOLHA_ABERTA.Pgto_de_férias_compradas, 0.0)) as 'Pgto de férias compradas',
    sum(isnull(FOLHA_ABERTA.Dobras_DomingosFeriados, 0.0)) as 'Dobras Domingos/ Feriados',
    sum(isnull(FOLHA_ABERTA.Hora_Extra_Eventual_mês, 0.0)) as 'Hora Extra Eventual (mês)',
    sum(isnull(FOLHA_ABERTA.Adicional_Noturno_FIXO, 0.0)) as 'Adicional Noturno',
    sum(isnull(FOLHA_ABERTA.Pericul_FIXA, 0.0)) as 'Periculosidade // Adic. Risco',
    sum(isnull(FOLHA_ABERTA.Sal_Família, 0.0)) as 'Sal. Família',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_créd_em_folha_PROVENTO, 0.0) + isnull(FOLHA_ABERTA.Arredond_3, 0.0) - isnull(FOLHA_ABERTA.ImpRendaAdd, 0.0)) as 'Pgto 1ª Q (créd. em folha)',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_créd_em_folha_DESCONTO, 0.0)) as 'Desc 1ª Q (créd. em folha)',
    sum(isnull(FOLHA_ABERTA.Arredond_1, 0.0)) as 'Arredond. mês',
    sum(isnull(FOLHA_ABERTA.Arredond_2, 0.0)) as 'Arredondamento',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_espécie, 0.0)) as 'Pgto 1ª Q (espécie )',
    sum(isnull(Pgto_1a_Q_créd_em_folha_PROVENTO, Pgto_1a_Q_créd_em_folha_DESCONTO) - isnull(FOLHA_ABERTA.Arredond_3, 0.0) + isnull(FOLHA_ABERTA.ImpRenda, 0.0)) as 'Saldo Folha Pgto 1ª Q.',
    sum(isnull(FOLHA_ABERTA.Pgto_2a_Q_créd_em_folha, 0.0)) as 'Pgto 2ª Q (créd. em folha)',
    sum(isnull(FOLHA_ABERTA.BV_Financ, 0.0)) as '(-) BV Financ.',
    sum(isnull(FOLHA_ABERTA.Santander_Financ, 0.0)) as '(-) Santander Financ.',
    sum(isnull(FOLHA_ABERTA.Biorc_Financ, 0.0)) as '(-) Biorc Financ.',
    sum(isnull(FOLHA_ABERTA.Dia_do_Motorista, 0.0)) as 'Dia do Motorista',
    sum(isnull(FOLHA_ABERTA.Arredond_4, 0.0)) as 'Arredond. férias',
    sum(isnull(FOLHA_ABERTA.Arredond_3, 0.0)) as 'Arredond. adiantamento',
    sum(isnull(FOLHA_ABERTA.Pgto_2a_Q_espécie, 0.0)) as 'Pgto 2ª Q (espécie )',
    sum(isnull(FOLHA_ABERTA.Saldo_Folha_Pgto_2a_Q, 0.0)) as 'Saldo Folha Pgto 2ª Q.',
    sum(isnull(FOLHA_ABERTA.Total_Descontos, 0.0)) as 'Total Descontos',
    sum(isnull(FOLHA_ABERTA.INSS, 0.0)) as 'INSS',
    sum(isnull(FOLHA_ABERTA.INSS_ferias, 0.0)) as 'INSS Férias',
    sum(isnull(FOLHA_ABERTA.Plano_Odontológico_funcionario, 0.0)) as 'Plano Odontológico (funcionario)',
    sum(isnull(FOLHA_ABERTA.Hapvida_funcionario, 0.0)) as 'Hapvida (funcionario)',
    sum(isnull(FOLHA_ABERTA.ImpRenda, 0.0)) as 'Imp.Renda',
    sum(isnull(FOLHA_ABERTA.Pens_Alim, 0.0)) as 'Pens Alim',
    sum(isnull(FOLHA_ABERTA.Mensal_Sind_Patronal, 0.0)) as 'Mensal Sind - Patronal',
    sum(isnull(FOLHA_ABERTA.Cont_Sindical_Funcionário, 0.0)) as 'Cont Sindical Funcionário',
    sum(isnull(FOLHA_ABERTA.ContAssist, 0.0)) as 'Cont. Assist.',
    sum(isnull(FOLHA_ABERTA.Faltas_DSR, 0.0)) as 'Faltas & DSR',
    sum(isnull(FOLHA_ABERTA.Atrasos_Suspensão_Faltas_em_Horas, 0.0)) as 'Atrasos, Suspensão & Faltas em Horas',
    sum(isnull(FOLHA_ABERTA.Desconto_VA, 0.0)) as 'Desconto VA',
    sum(isnull(FOLHA_ABERTA.Descontos_autorizados, 0.0)) as 'Descontos Autorizados (Funcionários)',
    sum(isnull(FOLHA_ABERTA.DescontoVT, 0.0)) as 'Desconto Vale Transporte',
    sum(isnull(FOLHA_ABERTA.Primeira_13, 0.0)) as 'Primeira Parcela 13° - Proventos',
    sum(isnull(FOLHA_ABERTA.Primeira_13, 0.0) - isnull(FOLHA_ABERTA.Primeira_13_valor_alimenticia, 0.0)) as 'Primeira Parcela 13° - Valor a pagar',
    max(isnull(FOLHA_ABERTA.Primeira_13_avos, 0.0)) as 'Primeira Parcela 13° - Avos',
    sum(isnull(FOLHA_ABERTA.Primeira_13_valor_insalubridade, 0.0)) as 'Primeira Parcela 13° - Insalubridade',
    sum(isnull(FOLHA_ABERTA.Primeira_13_media_periculosidade, 0.0)) as 'Primeira Parcela 13° - Ad. risco/Periculosidade',
    sum(isnull(FOLHA_ABERTA.Primeira_13_media_outros, 0.0)) as 'Primeira Parcela 13° - Outros valores',
    sum(isnull(FOLHA_ABERTA.Primeira_13_valor_ATS, 0.0)) as 'Primeira Parcela 13° - Ad. tempo serviço',
    sum(isnull(FOLHA_ABERTA.Primeira_13_valor_maternidade, 0.0)) as 'Primeira Parcela 13° - sal. maternidade',
    sum(isnull(FOLHA_ABERTA.Primeira_13_valor_alimenticia, 0.0)) as 'Primeira Parcela 13° - pensão alimentícia',
    sum(isnull(FOLHA_ABERTA.Primeira_13_valor_totaismedia, 0.0)) as 'Primeira Parcela 13° - totais média',
    sum(isnull(FOLHA_ABERTA.Segunda_13_provento, 0.0) - isnull(FOLHA_ABERTA.Segunda_13_desconto, 0.0)) as 'Segunda Parcela 13° - Valor a pagar',
    max(isnull(FOLHA_ABERTA.Segunda_13_avos, 0.0)) as 'Segunda Parcela 13° - Avos',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_insalubridade, 0.0)) as 'Segunda Parcela 13° - Insalubridade',
    sum(isnull(FOLHA_ABERTA.Segunda_13_media_periculosidade, 0.0)) as 'Segunda Parcela 13° - Ad. risco/Periculosidade',
    sum(isnull(FOLHA_ABERTA.Segunda_13_media_outros, 0.0)) as 'Segunda Parcela 13° - Outros valores',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_ATS, 0.0)) as 'Segunda Parcela 13° - Ad. tempo serviço',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_maternidade, 0.0)) as 'Segunda Parcela 13° - sal. maternidade',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_totaismedia, 0.0)) as 'Segunda Parcela 13° - totais média',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_INSS, 0.0)) as 'Segunda parcela 13° - INSS',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_IR, 0.0)) as 'Segunda parcela 13° - IR',
    sum(isnull(FOLHA_ABERTA.Segunda_13_valor_pensao_alim, 0.0)) as 'Segunda parcela 13° - Pensão alimentícia',
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Adiantamento_1a_QUINZENA, 0.0)) as 'Observações da Folha de Adiantamento - 1ª QUINZENA',
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA, 0.0)) as 'Observações da Folha de Enc. Mensal - 2ª QUINZENA'
from
(
    select
        row_number() over(partition by 
                SRA010.RA_FILIAL,
                SRA010.RA_ADMISSA,
                SRA010.RA_MAT,
                FOLHA.RD_PD,
                FOLHA.RD_SEQ,
                FOLHA.RD_DTREF,
                FOLHA.RD_PERIODO,
                FOLHA.RD_HORAS,
                FOLHA.RD_CC,
                SRA010.RA_SITFOLH,
                SRJ010.RJ_DESC

                order by SRA010.RA_FILIAL, SRA010.RA_MAT
            ) as contador,

        count(FOLHA.RD_PD) over(partition by SRA010.RA_FILIAL, FOLHA.RD_PERIODO, SRA010.RA_MAT, FOLHA.RD_SEQ) as VERBAS_FUNCIONARIO_PERIODO,
        count(SRA010.RA_MAT) over(partition by SRA010.RA_FILIAL, FOLHA.RD_PERIODO, FOLHA.RD_PD) as FUNCIONARIOS_FILIAL,

        SRA010.RA_FILIAL AS FILIAL,
        SRA010.RA_ADMISSA DATA_ADMISSAO,
        SRA010.RA_MAT AS MATRICULA,
        SRA010.RA_NOME as NOME,
        
        substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
        substring(FOLHA.RD_PERIODO, 5, 2) as PERIODO_MES,
        cast(FOLHA.RD_DTREF as date) as DATA_REFERENCIA,
        FOLHA.RD_PERIODO as PERIODO,

        FOLHA.RD_PD,
        CTD010.CTD_DESC01 as ATIVIDADE,
        
        FOLHA.RD_HORAS AS REFERENCIA,
        CTT010.CTT_DESC01 AS CENTRO_DE_CUSTO,

        SRA010.RA_SITFOLH as SITUACAO_FOLHA,
        SRA010.RA_CODFUNC as COD_FUNCAO,
        SRJ010.RJ_DESC as DESC_FUNCAO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('796', '560', '563', '719', '749', '056', '570', '574', '575', '576', '577', '711', '738', '057', '008', '132', '133', '113', '029', '111', '112', '113', '344', '030', '041', '039', '096', '097', '215', '356', '054', '113', '407', '001', '2112', '999')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Custo_pessoal,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('796') /* custo do func. incluso no custo total com pessoal, que é apenas da empresa */
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as TOTAL_VT,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('560', '563', '719') /* 410 apenas func */
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Vale_Alimentação_Total,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('749')  /* 562 apenas func */
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Cesta_Básica,
        (
            select max(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('056', '570', '574', '575', '576', '577', '711')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Plano_Odontológico_Empresa,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('738')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Hapvida_Empresa,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('057')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Diárias_Motoristas,/*
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('0')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Custo_Total_com_Pessoal,*/
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD not in ('450')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Total_de_Proventos,
        (
            select max(SRA010.RA_SALARIO)
            from SRA010 (nolock)
            where
                    SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
                and SRA010.RA_MAT = FOLHA.RD_MAT
        ) as Salario_Base,
        (
            select sum(SRD010.RD_HORAS)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('020', '025')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Dias_Trabalhados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('020', '025')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Salário_Base_Pro_ratamês,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('008')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as PTS_premio_tempo_serviço,
        (
            select sum(SRD010.RD_HORAS)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('132', '152')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Férias_Qtde_de_dias_comprados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('132', '133')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_de_férias_compradas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('113')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Dobras_DomingosFeriados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('029', '111', '112', '113', '344')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Hora_Extra_Eventual_mês,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('030', '041')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Adicional_Noturno_FIXO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('039', '096', '097', '215', '356')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pericul_FIXA,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('054')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Sal_Família,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('001')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_1a_Q_créd_em_folha_PROVENTO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('450')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_1a_Q_créd_em_folha_DESCONTO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('461')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Arredond_1,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('091')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Arredond_2,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_1a_Q_espécie,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('183')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Saldo_Folha_Pgto_1a_Q,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('999')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_2a_Q_créd_em_folha,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('567')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as BV_Financ,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('474')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Santander_Financ,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('566')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Biorc_Financ,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('113')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO and substring(SRD010.RD_PERIODO, 5, 6) = '07'
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Dia_do_Motorista,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('147')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Arredond_3,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('140')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Arredond_4,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pgto_2a_Q_espécie,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('999')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Saldo_Folha_Pgto_2a_Q,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    cast(SRD010.RD_PD as int) != 450
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('2')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Total_Descontos,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('401')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as INSS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('402')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as INSS_ferias,
        (
            select max(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('569', '570', '574', '575', '576', '577')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Plano_Odontológico_funcionario,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('565', '571')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Hapvida_funcionario,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('420', '421', '422')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as ImpRenda,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('421')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as ImpRendaAdd,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('530', '535', '414')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Pens_Alim,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('407')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Mensal_Sind_Patronal,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('980')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Cont_Sindical_Funcionário,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('622')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as ContAssist,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('440')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Faltas_DSR,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('440', '445')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Atrasos_Suspensão_Faltas_em_Horas,
        (   
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('410')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Desconto_VA,
        (            
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('597')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Descontos_autorizados,
        (            
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('561')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as DescontoVT,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13,
        (
            select avg(SRD010.RD_HORAS)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_avos,
                (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('167')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_valor_insalubridade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('009')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_media_periculosidade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('010')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_media_outros,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('011')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_valor_ATS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('202')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_valor_maternidade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('414', '533')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_valor_alimenticia,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('768', '769', '770')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Primeira_13_valor_totaismedia,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('300', '013', '015', '203', '204', '205', '206', '247', '304', '306', '307')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_provento,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('510', '403', '407', '423', '530', '535')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_desconto,
        (
            select avg(SRD010.RD_HORAS)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('300')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_avos,
                (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('015')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_insalubridade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_media_periculosidade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_media_outros,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('247')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_ATS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('203', '206')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_maternidade,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_totaismedia,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('403')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_INSS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('423')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_IR,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('530', '535')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Segunda_13_valor_pensao_alim,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD            
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Observações_da_Folha_de_Adiantamento_1a_QUINZENA,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('2112')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
        ) as Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA

    from SRA010 (nolock)
        inner join SRD010 as FOLHA (nolock)
            on FOLHA.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
            and SRA010.RA_MAT = FOLHA.RD_MAT
            and trim(FOLHA.RD_MAT) not in ('003264', '003263')

            inner join CTT010 (nolock)
                on CTT010.D_E_L_E_T_ = ''
                and FOLHA.RD_CC = CTT010.CTT_CUSTO

        inner join SRJ010 (nolock)
            on SRJ010.D_E_L_E_T_ = ''
            and substring(SRA010.RA_FILIAL, 1, 4) = SRJ010.RJ_FILIAL
            and SRA010.RA_CODFUNC = SRJ010.RJ_FUNCAO
        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and SRA010.RA_ITEM = CTD010.CTD_ITEM

    where SRA010.D_E_L_E_T_ = ''
) as FOLHA_ABERTA
group by
    FOLHA_ABERTA.FILIAL,
    FOLHA_ABERTA.DATA_ADMISSAO,
    FOLHA_ABERTA.MATRICULA,
    FOLHA_ABERTA.NOME,
    FOLHA_ABERTA.CENTRO_DE_CUSTO,
    FOLHA_ABERTA.SITUACAO_FOLHA,
    FOLHA_ABERTA.COD_FUNCAO,
    FOLHA_ABERTA.DESC_FUNCAO,
    FOLHA_ABERTA.ATIVIDADE,
    FOLHA_ABERTA.PERIODO_ANO,
    FOLHA_ABERTA.PERIODO_MES