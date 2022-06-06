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
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA, 0.0)) as 'Observações da Folha de Enc. Mensal - 2ª QUINZENA',
    sum(isnull(FOLHA_ABERTA.Observações_da_Folha_de_Adiantamento_1a_QUINZENA, 0.0)) as 'Observações da Folha de Adiantamento - 1ª QUINZENA'
from
(
    select
        row_number() over(partition by 
                SRA010.RA_FILIAL,
                SRA010.RA_ADMISSA,
                SRA010.RA_MAT,
                FOLHA.RC_PD,
                FOLHA.RC_SEQ,
                FOLHA.RC_DTREF,
                FOLHA.RC_PERIODO,
                FOLHA.RC_HORAS,
                FOLHA.RC_CC,
                SRA010.RA_SITFOLH,
                SRJ010.RJ_DESC

                order by SRA010.RA_FILIAL, SRA010.RA_MAT
            ) as contador,

        count(FOLHA.RC_PD) over(partition by SRA010.RA_FILIAL, FOLHA.RC_PERIODO, SRA010.RA_MAT, FOLHA.RC_SEQ) as VERBAS_FUNCIONARIO_PERIODO,
        count(SRA010.RA_MAT) over(partition by SRA010.RA_FILIAL, FOLHA.RC_PERIODO, FOLHA.RC_PD) as FUNCIONARIOS_FILIAL,

        SRA010.RA_FILIAL AS FILIAL,
        SRA010.RA_ADMISSA DATA_ADMISSAO,
        SRA010.RA_MAT AS MATRICULA,
        SRA010.RA_NOME as NOME,
        
        substring(FOLHA.RC_PERIODO, 1, 4) as PERIODO_ANO,
        substring(FOLHA.RC_PERIODO, 5, 2) as PERIODO_MES,
        cast(FOLHA.RC_DTREF as date) as DATA_REFERENCIA,
        FOLHA.RC_PERIODO as PERIODO,

        FOLHA.RC_PD,
        CTD010.CTD_DESC01 as ATIVIDADE,
        
        FOLHA.RC_HORAS AS REFERENCIA,
        CTT010.CTT_DESC01 AS CENTRO_DE_CUSTO,

        SRA010.RA_SITFOLH as SITUACAO_FOLHA,
        SRA010.RA_CODFUNC as COD_FUNCAO,
        SRJ010.RJ_DESC as DESC_FUNCAO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('450')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as VT_1a_Q,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('561', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as VT_2a_Q,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('561', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as TOTAL_VT,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('410', '719')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Vale_Alimentação_VrUnitário,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('719')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Total_de_Vale_Alimentação_QT,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('410', '719')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Vale_Alimentação_Total,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('562', '749')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Cesta_Básica,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('056', '570', '574', '575', '576', '577', '711')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Plano_Odontológico_Empresa,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('738')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD  
        ) as Hapvida_Empresa,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('2112')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Produt_Total,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('0')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Custo_Total_com_Pessoal,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    /*SRC010.RC_PD in ('')
                and*/ SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Total_de_Proventos,
        (
            select max(SRA010.RA_SALARIO)
            from SRA010 (nolock)
            where
                    SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = FOLHA.RC_FILIAL
                and SRA010.RA_MAT = FOLHA.RC_MAT
        ) as Salario_Base,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('281')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Gratificação,
        (
            select sum(SRC010.RC_HORAS)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('020')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as Dias_Trabalhados,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('020')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Salário_Base_Pro_ratamês,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('0')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Gratificação_Pro_Ratamês,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('008')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as PTS_premio_tempo_serviço,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('132', '152')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Férias_Qtde_de_dias_comprados,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('470')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as reais_dia_p_remuneração_s_férias,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('132', '133')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_de_férias_compradas,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('343')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Abono_Sindicam_18,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('113')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Dobras_DomingosFeriados,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('061')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Hora_Extra_Eventual_mês,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('041')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Adicional_Noturno_FIXO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('2112')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Desc_s_AdicNot,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('061')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Adicional_Noturno_a_pagar,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('356')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pericul_FIXA,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('2112')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Desc_s_Pericul,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('215')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pericul_a_pagar,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('039')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Add_risco,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('054')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Sal_Família,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('001')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_1a_Q_créd_em_folha,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('461')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Arredond_1,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('474')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Bco_Santander_Pgto_1a_Q_Cr_em_Folha,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('183')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_1a_Q_depós_cc_,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('091')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Arredond_2,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('474')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Bco_Santander_Pgto_1a_Q_Dep_cc,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('0')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_1a_Q_espécie,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('999')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Saldo_Folha_Pgto_1a_Q,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('999')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_2a_Q_créd_em_folha,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('567')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as BV_Financ,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('474')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Santander_Financ,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('113')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Dia_do_Motorista,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('147')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Arredond_3,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('474')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Bco_Santander_Pgto_2a_Q_cr_em_folha,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('999')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_2a_Q_depós_cc_,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('140')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Arredond_4,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('999')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as TOTAL_Pgto_2a_Q_depós_cc_,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('0')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pgto_2a_Q_espécie,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('999')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Saldo_Folha_Pgto_2a_Q,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    /*SRC010.RC_PD in ('0')
                and*/ SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('2')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Total_Descontos,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('401', '402', '403', '411')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as INSS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('401', '402', '403', '412')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Dif_INSS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('569', '570', '574', '575', '576', '577')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Plano_Odontológico_funcionario,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('565', '571')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Hapvida_funcionario,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('420', '422')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as ImpRenda,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('530', '535')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Pens_Alim,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('407')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Mensal_Sind_Patronal,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('980')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Cont_Sindical_Funcionário,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('596')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as ContAssist,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('440')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Faltas_DSR,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('440', '445')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Atrasos_Suspensão_Faltas_em_Horas,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('719')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Refeições_Adic,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('597')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Vales,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('561')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Vale_Transporte,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('2112')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD 
        ) as Observações_da_Folha_de_Adiantamento_1a_QUINZENA,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('2112')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as Observações_da_Folha_de_Enc_Mensal_2a_QUINZENA

    from SRA010 (nolock)
        inner join SRC010 as FOLHA (nolock)
            on FOLHA.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RC_FILIAL
            and SRA010.RA_MAT = FOLHA.RC_MAT
        inner join SRJ010 (nolock)
            on SRJ010.D_E_L_E_T_ = ''
            and substring(SRA010.RA_FILIAL, 1, 4) = SRJ010.RJ_FILIAL
            and SRA010.RA_CODFUNC = SRJ010.RJ_FUNCAO
        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and SRA010.RA_ITEM = CTD010.CTD_ITEM
        left join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and FOLHA.RC_CC = CTT010.CTT_CUSTO

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