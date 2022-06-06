select
    FOLHA_RESUMO.RD_MAT,
    FOLHA_RESUMO.RD_FILIAL,
    FOLHA_RESUMO.RD_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RA_NOME,
    FOLHA_RESUMO.RD_CC,
    FOLHA_RESUMO.CTT_DESC01,
    count(FOLHA_RESUMO.ATIVOS) ATIVOS,
    count(FOLHA_RESUMO.LICENCA) LICENCA,
    count(FOLHA_RESUMO.DEMITIDOS) DEMITIDOS,
    count(FOLHA_RESUMO.FERIAS) FERIAS,
    sum(FOLHA_RESUMO.Custo_Total_COM_Diárias_Motoristas) as Custo_Total_COM_Diárias_Motoristas,
    sum(FOLHA_RESUMO.Custo_Total_SEM_Diárias_Motoristas_provento) + sum(FOLHA_RESUMO.Custo_Total_SEM_Diárias_Motoristas_bases) as Custo_Total_SEM_Diárias_Motoristas,
    sum(isnull(FOLHA_RESUMO.ADIANTAMENTO, 0.0) - isnull(FOLHA_RESUMO.IRRF_ADIANTAMENTO, 0.0)) as ADIANTAMENTO,
    sum(FOLHA_RESUMO.ARR_ADIANTAMENTO) as ARREDOND_ADIANTAMENTO,
    sum(FOLHA_RESUMO.IRRF_ADIANTAMENTO) as IR_ADIANTAMENTO,
    max(FOLHA_RESUMO.SALARIO_BASE) as SALARIO_BASE,
    sum(FOLHA_RESUMO.HORAS_EXTRAS) as HORAS_EXTRAS,
    sum(FOLHA_RESUMO.DOMINGOS_FERIADOS) as DOMINGOS_FERIADOS,
    sum(FOLHA_RESUMO.ADICIONAL_NOTURNO) as ADICIONAL_NOTURNO,
    sum(FOLHA_RESUMO.PERICULOSIDADES) as PERICULOSIDADES,
    sum(FOLHA_RESUMO.VALE_TRANSPORTE) as VALE_TRANSPORTE,
    sum(FOLHA_RESUMO.VALE_ALIMENTACAO) as VALE_ALIMENTACAO,
    sum(FOLHA_RESUMO.VALE_CESTA) as VALE_CESTA,
    sum(FOLHA_RESUMO.PLANO_SAUDE) as PLANO_SAUDE,
    sum(FOLHA_RESUMO.PLANO_ODONTOLOGICO) as PLANO_ODONTOLOGICO,
    sum(FOLHA_RESUMO.DIARIAS_VIAGEM) as DIARIAS_VIAGEM,
    sum(FOLHA_RESUMO.FERIAS_COMPRADAS) as FERIAS_COMPRADAS,
    sum(FOLHA_RESUMO.PRIMEIRA_13) as PRIMEIRA_13,
    sum(FOLHA_RESUMO.SEGUNDA_13_provento) - sum(FOLHA_RESUMO.SEGUNDA_13_desconto) as SEGUNDA_13
from
(
    select
        FOLHA.RD_FILIAL,
        FOLHA.RD_PERIODO,
        substring(FOLHA.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
        FOLHA.RD_MAT,
        FOLHA.RD_PD,
        FOLHA.RD_SEMANA ,
        FOLHA.RD_SEQ ,
        CTT010.CTT_DESC01,
        FOLHA.RD_CC,
        SRA010.RA_NOME,
        FOLHA.RD_PROCES,
        SRA010.RA_SITFOLH,
        row_number() over
            (
                partition by
                FOLHA.RD_FILIAL,
                FOLHA.RD_PERIODO,
                FOLHA.RD_MAT,
                FOLHA.RD_PD,
                FOLHA.RD_SEMANA ,
                FOLHA.RD_SEQ ,
                FOLHA.RD_CC,
                FOLHA.RD_PROCES

                order by FOLHA.RD_PERIODO
            ) as contador,
        count(FOLHA.RD_MAT) over
        (
            partition by
            FOLHA.RD_FILIAL,
            FOLHA.RD_PERIODO,
            FOLHA.RD_PD

            order by FOLHA.RD_PD
        ) as contador_matriculasPORverba,
        count(FOLHA.RD_PD) over
        (
            partition by
            FOLHA.RD_FILIAL,
            FOLHA.RD_PERIODO,
            FOLHA.RD_MAT

            order by FOLHA.RD_MAT
        ) as contador_verbasPORmatricula,

        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'A')
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    (SRD010.RD_PD in ('020', '025') and SRD010.RD_PD not in ('130', '220'))
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as ATIVOS,/*
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'L')
            from SRD010 (nolock)
                inner join SR8010 (nolock)
                    on SR8010.D_E_L_E_T_ = ''
                    and SRD010.RD_FILIAL = SR8010.R8_FILIAL
                    and SRD010.RD_MAT = SR8010.R8_MAT
                    and SR8010.R8_SEQ in ('004', '017')
                    and cast(SR8010.R8_DURACAO as int) > 15
            where
                    SRD010.D_E_L_E_T_ = ''
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as LICENCA,*/
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'L')
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('199')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as LICENCA,
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'D')
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    (SRD010.RD_PD in ('220'))
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as DEMITIDOS,/*
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'L')
            from SRD010 (nolock)
                inner join SR8010 (nolock)
                    on SR8010.D_E_L_E_T_ = ''
                    and SRD010.RD_FILIAL = SR8010.R8_FILIAL
                    and SRD010.RD_MAT = SR8010.R8_MAT
            where
                    SR8010.R8_SEQ in ('001') and SR8010.R8_
                and SRD010.D_E_L_E_T_ = ''
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as FERIAS,*/
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'L')
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('130')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as FERIAS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('057', '561', '796', '410', '719', '562', '749', '056', '570', '574', '575', '576', '577', '711', '738', '008', '132', '133', '113', '061', '041', '356', '039', '054', '001', '450', '999')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as Custo_Total_COM_Diárias_Motoristas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD not in ('450')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as Custo_Total_SEM_Diárias_Motoristas_provento,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('709', '711', '719', '738', '749', '796')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as Custo_Total_SEM_Diárias_Motoristas_bases,
        (
            select max(SRD010.RD_VALORBA)
            from SRD010 (nolock)
            where
                    SRD010.D_E_L_E_T_ = ''
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as SALARIO_BASE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('029', '111', '112', '113', '344')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as HORAS_EXTRAS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('113') /* ??? 114 equivalente a domingo/feriado ou hora extra mesmo? aparentemente OK*/
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as DOMINGOS_FERIADOS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('030', '041')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as ADICIONAL_NOTURNO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('039', '096', '097', '215', '356')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as PERICULOSIDADES,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('285', '561', '796')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as VALE_TRANSPORTE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('410', '560', '563', '719')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as VALE_ALIMENTACAO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('562', '749')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as VALE_CESTA,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('738')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as PLANO_SAUDE,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('711')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as PLANO_ODONTOLOGICO,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('057')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as DIARIAS_VIAGEM,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('132', '133')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                
        ) as FERIAS_COMPRADAS,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('001', '147', '450')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD 
        ) as ADIANTAMENTO,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('147')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD 
        ) as ARR_ADIANTAMENTO,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('421')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('2')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD 
        ) as IRRF_ADIANTAMENTO,

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
        ) as PRIMEIRA_13,

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
        ) as SEGUNDA_13_provento,
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
        ) as SEGUNDA_13_desconto

    from SRD010 FOLHA (nolock)
        inner join SRA010 (nolock)
            on SRA010.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
            and SRA010.RA_MAT = FOLHA.RD_MAT
            and trim(FOLHA.RD_MAT) not in ('003264', '003263')
        inner join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and FOLHA.RD_CC = CTT010.CTT_CUSTO
    where FOLHA.D_E_L_E_T_ = ''
        
) as FOLHA_RESUMO
group by
    FOLHA_RESUMO.RD_FILIAL,
    FOLHA_RESUMO.RD_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RD_MAT,
    FOLHA_RESUMO.RA_NOME,
    FOLHA_RESUMO.CTT_DESC01,
    FOLHA_RESUMO.RD_CC