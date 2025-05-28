select
    trim(FOLHA_ABERTA.FILIAL) as FILIAL,
    trim(FOLHA_ABERTA.DATA_ADMISSAO) as DATA_ADMISSAO,
    trim(FOLHA_ABERTA.MATRICULA) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(FOLHA_ABERTA.NOME) as NOME,
    trim(FOLHA_ABERTA.CENTRO_DE_CUSTO) as CENTRO_DE_CUSTO,
    trim(FOLHA_ABERTA.SITUACAO_FOLHA) as SITUACAO_FOLHA,
    trim(FOLHA_ABERTA.DESC_FUNCAO) as DESC_FUNCAO,
    trim(FOLHA_ABERTA.ATIVIDADE) as ATIVIDADE,
    trim(FOLHA_ABERTA.PERIODO_ANO) as PERIODO_ANO,
    trim(FOLHA_ABERTA.PERIODO_MES) as PERIODO_MES,

    sum(isnull(FOLHA_ABERTA.VT_1a_Q, 0.0)) as 'VT 1a Q',
    sum(isnull(FOLHA_ABERTA.VT_2a_Q, 0.0)) as 'VT 2a Q',
    sum(isnull(FOLHA_ABERTA.TOTAL_VT, 0.0)) as 'TOTAL VT',
    sum(isnull(FOLHA_ABERTA.Vale_Alimentação_VrUnitário, 0.0)) as 'Vale Alimentação Vr.Unitário',
    sum(isnull(FOLHA_ABERTA.Total_de_Vale_Alimentação_QT, 0.0)) as 'Total de Vale Alimentação (QT)',
    sum(isnull(FOLHA_ABERTA.Vale_Alimentação_Total, 0.0)) as 'Vale Alimentação Total',
    sum(isnull(FOLHA_ABERTA.Cesta_Básica, 0.0)) as 'Cesta Básica',
    sum(isnull(FOLHA_ABERTA.Plano_Odontológico_Empresa, 0.0)) as 'Plano Odontológico Empresa',
    sum(isnull(FOLHA_ABERTA.Hapvida_Empresa, 0.0)) as 'Hapvida Empresa',
    sum(isnull(FOLHA_ABERTA.Produt_Total, 0.0)) as 'Produt. Total',
    (sum(isnull(FOLHA_ABERTA.TOTAL_VT, 0.0)) + sum(isnull(FOLHA_ABERTA.Vale_Alimentação_Total, 0.0)) + sum(isnull(FOLHA_ABERTA.Cesta_Básica, 0.0)) + sum(isnull(FOLHA_ABERTA.Plano_Odontológico_Empresa, 0.0)) + sum(isnull(FOLHA_ABERTA.Hapvida_Empresa, 0.0)) + sum(isnull(FOLHA_ABERTA.Produt_Total, 0.0)) + sum(isnull(FOLHA_ABERTA.Total_de_Proventos, 0.0)) + sum(isnull(FOLHA_ABERTA.Pgto_de_férias_compradas, 0.0)) + sum(isnull(FOLHA_ABERTA.Dobras_DomingosFeriados, 0.0)) + sum(isnull(FOLHA_ABERTA.Hora_Extra_Eventual_mês, 0.0))) as 'Custo Total com Pessoal',
    sum(isnull(FOLHA_ABERTA.Total_de_Proventos, 0.0)) as 'Total de Proventos',
    max(isnull(FOLHA_ABERTA.Salario_Base, 0.0)) as 'Salario Base ',
    sum(isnull(FOLHA_ABERTA.Gratificação, 0.0)) as 'Gratificação',
    sum(isnull(FOLHA_ABERTA.Dias_Trabalhados, 0.0)) as 'Dias Trabalhados',
    sum(isnull(FOLHA_ABERTA.Salário_Base_Pro_ratamês, 0.0)) as 'Salário Base Pro rata/mês',
    sum(isnull(FOLHA_ABERTA.Gratificação_Pro_Ratamês, 0.0)) as 'Gratificação Pro Rata/mês',
    sum(isnull(FOLHA_ABERTA.PTS_premio_tempo_serviço, 0.0)) as 'PTS (premio tempo serviço)',
    sum(isnull(FOLHA_ABERTA.Férias_Qtde_de_dias_comprados, 0.0)) as 'Férias - Qtde de dias comprados',
    sum(isnull(FOLHA_ABERTA.reais_dia_p_remuneração_s_férias, 0.0)) as 'R$ / dia - p/ remuneração s/ férias',
    sum(isnull(FOLHA_ABERTA.Pgto_de_férias_compradas, 0.0)) as 'Pgto de férias compradas',
    sum(isnull(FOLHA_ABERTA.Abono_Sindicam_18, 0.0)) as 'Abono Sindicam - 1/8',
    sum(isnull(FOLHA_ABERTA.Dobras_DomingosFeriados, 0.0)) as 'Dobras Domingos/Feriados',
    sum(isnull(FOLHA_ABERTA.Hora_Extra_Eventual_mês, 0.0)) as 'Hora Extra Eventual (mês)',
    sum(isnull(FOLHA_ABERTA.Adicional_Noturno_FIXO, 0.0)) as 'Adicional Noturno FIXO',
    sum(isnull(FOLHA_ABERTA.Desc_s_AdicNot, 0.0)) as 'Desc. s/ Adic.Not.',
    sum(isnull(FOLHA_ABERTA.Adicional_Noturno_a_pagar, 0.0)) as 'Adicional Noturno  (a pagar)',
    sum(isnull(FOLHA_ABERTA.Pericul_FIXA, 0.0)) as 'Pericul. FIXA',
    sum(isnull(FOLHA_ABERTA.Desc_s_Pericul, 0.0)) as 'Desc. s/ Pericul.',
    sum(isnull(FOLHA_ABERTA.Pericul_a_pagar, 0.0)) as 'Pericul.  (a pagar)',
    sum(isnull(FOLHA_ABERTA.Add_risco, 0.0)) as 'Adicional de risco',
    sum(isnull(FOLHA_ABERTA.Sal_Família, 0.0)) as 'Sal. Família',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_créd_em_folha, 0.0)) as 'Pgto 1ª Q (créd. em folha)',
    sum(isnull(FOLHA_ABERTA.Arredond_1, 0.0)) as 'Arred. Mês',
    sum(isnull(FOLHA_ABERTA.Bco_Santander_Pgto_1a_Q_Cr_em_Folha, 0.0)) as 'Bco Santander  Pgto 1ª Q (Cr. em Folha)',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_depós_cc_, 0.0)) as 'Pgto 1ª Q (depós. c/c)',
    sum(isnull(FOLHA_ABERTA.Arredond_2, 0.0)) as 'Arredondamento',
    sum(isnull(FOLHA_ABERTA.Bco_Santander_Pgto_1a_Q_Dep_cc, 0.0)) as 'Bco Santander Pgto 1ª Q (Dep.c/c)',
    sum(isnull(FOLHA_ABERTA.Pgto_1a_Q_espécie, 0.0)) as 'Pgto 1ª Q (espécie)',
    sum(isnull(FOLHA_ABERTA.Saldo_Folha_Pgto_1a_Q, 0.0)) as 'Saldo Folha Pgto 1ª Q.',
    sum(isnull(FOLHA_ABERTA.Pgto_2a_Q_créd_em_folha, 0.0)) as 'Pgto 2ª Q (créd. em folha)',
    sum(isnull(FOLHA_ABERTA.BV_Financ, 0.0)) as '(-) BV Financ.',
    sum(isnull(FOLHA_ABERTA.Santander_Financ, 0.0)) as '(-) Santander Financ.',
    sum(isnull(FOLHA_ABERTA.Dia_do_Motorista, 0.0)) as 'Dia do Motorista',
    sum(isnull(FOLHA_ABERTA.Arredond_3, 0.0)) as 'Arredondamento adiantamento',
    sum(isnull(FOLHA_ABERTA.Bco_Santander_Pgto_2a_Q_cr_em_folha, 0.0)) as 'Bco Santander Pgto 2ª Q (cr. em folha)',
    sum(isnull(FOLHA_ABERTA.Pgto_2a_Q_depós_cc_, 0.0)) as 'Pgto 2ª Q (depós. c/c)',
    sum(isnull(FOLHA_ABERTA.Arredond_4, 0.0)) as 'Arredondamento férias',
    sum(isnull(FOLHA_ABERTA.TOTAL_Pgto_2a_Q_depós_cc_, 0.0)) as 'TOTAL Pgto 2ª Q (depós. c/c)',
    sum(isnull(FOLHA_ABERTA.Pgto_2a_Q_espécie, 0.0)) as 'Pgto 2ª Q (espécie)',
    sum(isnull(FOLHA_ABERTA.Saldo_Folha_Pgto_2a_Q, 0.0)) as 'Saldo Folha Pgto 2ª Q.',
    sum(isnull(FOLHA_ABERTA.Total_Descontos, 0.0)) as 'Total Descontos',
    sum(isnull(FOLHA_ABERTA.INSS, 0.0)) as 'INSS',
    sum(isnull(FOLHA_ABERTA.Dif_INSS, 0.0)) as 'Dif. INSS',
    sum(isnull(FOLHA_ABERTA.Plano_Odontológico_funcionario, 0.0)) as 'Plano Odontológico (funcionario)',
    sum(isnull(FOLHA_ABERTA.Hapvida_funcionario, 0.0)) as 'Hapvida (funcionario)',
    sum(isnull(FOLHA_ABERTA.ImpRenda, 0.0)) as 'Imp.Renda',
    sum(isnull(FOLHA_ABERTA.Pens_Alim, 0.0)) as 'Pens Alim',
    sum(isnull(FOLHA_ABERTA.Mensal_Sind_Patronal, 0.0)) as 'Mensal Sind - Patronal',
    sum(isnull(FOLHA_ABERTA.Cont_Sindical_Funcionário, 0.0)) as 'Cont Sindical Funcionário',
    sum(isnull(FOLHA_ABERTA.ContAssist, 0.0)) as 'Cont.Assist.',
    sum(isnull(FOLHA_ABERTA.Faltas_DSR, 0.0)) as 'Faltas & DSR',
    sum(isnull(FOLHA_ABERTA.Atrasos_Suspensão_Faltas_em_Horas, 0.0)) as 'Atrasos, Suspensão & Faltas em Horas',
    sum(isnull(FOLHA_ABERTA.Refeições_Adic, 0.0)) as 'Refeições Adic',
    sum(isnull(FOLHA_ABERTA.Vales, 0.0)) as 'Vales',
    sum(isnull(FOLHA_ABERTA.Vale_Transporte, 0.0)) as 'Vale Transporte',
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA, 0.0)) as 'Observações da Folha de Adiantamento - 1ª QUINZENA',
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Adiantamento_1a_QUINZENA, 0.0)) as 'Observações da Folha de Enc. Mensal - 2ª QUINZENA'
from
(
    select
        row_number() over(partition by 
                SRA010.RA_FILIAL,
                SRA010.RA_ADMISSA,
                SRA010.RA_MAT,
                FOLHA.RD_PD,
                FOLHA.RD_SEQ,
                FOLHA.RD_DATPGT,
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
        SRA010.RA_MAT as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        SRA010.RA_NOME as NOME,
        
        cast(FOLHA.RD_DATPGT as date) as DATA_PAGAMENTO,
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
                    SRD010.RD_PD in ('450')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as VT_1a_Q,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('561', '796')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as VT_2a_Q,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('561', '796')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as TOTAL_VT,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('410', '719')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Vale_Alimentação_VrUnitário,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('719')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Total_de_Vale_Alimentação_QT,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('410', '719')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Vale_Alimentação_Total,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('562', '749')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Cesta_Básica,
        (
            select sum(SRD010.RD_VALOR)
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD  
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Hapvida_Empresa,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Produt_Total,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Custo_Total_com_Pessoal,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    /*SRD010.RD_PD in ('')
                and*/ SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('281')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Gratificação,
        (
            select sum(SRD010.RD_HORAS)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('020')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Dias_Trabalhados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('020')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Salário_Base_Pro_ratamês,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Gratificação_Pro_Ratamês,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as PTS_premio_tempo_serviço,
        (
            select sum(SRD010.RD_VALOR)
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Férias_Qtde_de_dias_comprados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('470')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as reais_dia_p_remuneração_s_férias,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pgto_de_férias_compradas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('343')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Abono_Sindicam_18,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Dobras_DomingosFeriados,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('061')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Hora_Extra_Eventual_mês,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('041')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Adicional_Noturno_FIXO,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Desc_s_AdicNot,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('061')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Adicional_Noturno_a_pagar,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('356')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pericul_FIXA,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Desc_s_Pericul,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('215')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pericul_a_pagar,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('039')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Add_risco,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pgto_1a_Q_créd_em_folha,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Arredond_1,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Bco_Santander_Pgto_1a_Q_Cr_em_Folha,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pgto_1a_Q_depós_cc_,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Arredond_2,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Bco_Santander_Pgto_1a_Q_Dep_cc,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pgto_1a_Q_espécie,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Santander_Financ,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Arredond_3,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Bco_Santander_Pgto_2a_Q_cr_em_folha,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Pgto_2a_Q_depós_cc_,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Arredond_4,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as TOTAL_Pgto_2a_Q_depós_cc_,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Saldo_Folha_Pgto_2a_Q,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    /*SRD010.RD_PD in ('0')
                and*/ SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('2')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Total_Descontos,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('401', '402', '403', '411')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as INSS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('401', '402', '403', '412')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Dif_INSS,
        (
            select sum(SRD010.RD_VALOR)
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Hapvida_funcionario,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('420', '422')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as ImpRenda,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Cont_Sindical_Funcionário,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('596')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Atrasos_Suspensão_Faltas_em_Horas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('719')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Refeições_Adic,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Vales,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Vale_Transporte,
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
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
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA

    from SRA010 (nolock)
        inner join SRD010 as FOLHA (nolock)
            on FOLHA.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
            and SRA010.RA_MAT = FOLHA.RD_MAT
        inner join SRJ010 (nolock)
            on SRJ010.D_E_L_E_T_ = ''
            and substring(SRA010.RA_FILIAL, 1, 4) = SRJ010.RJ_FILIAL
            and SRA010.RA_CODFUNC = SRJ010.RJ_FUNCAO
        inner join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and SRA010.RA_ITEM = CTD010.CTD_ITEM
        inner join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and FOLHA.RD_CC = CTT010.CTT_CUSTO

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