select
    FOLHA_RESUMO.RC_MAT,
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RA_NOME,
    FOLHA_RESUMO.RC_CC,
    FOLHA_RESUMO.CTT_DESC01,
    FOLHA_RESUMO.CTD_DESC01,
    0 as ATIVOS,
    0 as LICENCA,
    0 as DEMITIDOS,
    0 as FERIAS,
    sum(FOLHA_RESUMO.Custo_Total_COM_Diárias_Motoristas_provento) + sum(FOLHA_RESUMO.Custo_Total_COM_Diárias_Motoristas_bases) as Custo_Total_COM_Diárias_Motoristas,
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
        FOLHA.RC_FILIAL,
        FOLHA.RC_PERIODO,
        substring(FOLHA.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(FOLHA.RC_PERIODO, 1, 4) as PERIODO_ANO,
        FOLHA.RC_MAT,
        FOLHA.RC_PD,
        FOLHA.RC_SEMANA,
        FOLHA.RC_SEQ,
        CTT010.CTT_DESC01,
        CTD010.CTD_DESC01,
        FOLHA.RC_CC,
        SRA010.RA_NOME,
        FOLHA.RC_PROCES,
        SRA010.RA_SITFOLH,
        row_number() over
            (
                partition by
                FOLHA.RC_FILIAL,
                FOLHA.RC_PERIODO,
                FOLHA.RC_MAT,
                FOLHA.RC_PD,
                FOLHA.RC_SEMANA ,
                FOLHA.RC_SEQ ,
                FOLHA.RC_CC,
                FOLHA.RC_PROCES

                order by FOLHA.RC_PERIODO
            ) as contador,
        count(FOLHA.RC_MAT) over
        (
            partition by
            FOLHA.RC_FILIAL,
            FOLHA.RC_PERIODO,
            FOLHA.RC_PD

            order by FOLHA.RC_PD
        ) as contador_matriculasPORverba,
        count(FOLHA.RC_PD) over
        (
            partition by
            FOLHA.RC_FILIAL,
            FOLHA.RC_PERIODO,
            FOLHA.RC_MAT

            order by FOLHA.RC_MAT
        ) as contador_verbasPORmatricula,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD not in ('450', '057')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as Custo_Total_COM_Diárias_Motoristas_provento,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('709', '711', '719', '738', '749', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as Custo_Total_COM_Diárias_Motoristas_bases,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD not in ('450', '057')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as Custo_Total_SEM_Diárias_Motoristas_provento,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('709', '711', '719', '738', '749', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as Custo_Total_SEM_Diárias_Motoristas_bases,
        (
            select max(SRA010.RA_SALARIO)
            from SRA010 (nolock)
            where
                    SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = FOLHA.RC_FILIAL
                and SRA010.RA_MAT = FOLHA.RC_MAT
        ) as SALARIO_BASE,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('029', '111', '112', '113', '344')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as HORAS_EXTRAS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('113') /* ??? 114 equivalente a domingo/feriado ou hora extra mesmo? aparentemente OK*/
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as DOMINGOS_FERIADOS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('030', '041')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as ADICIONAL_NOTURNO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('039', '096', '097', '215', '356')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as PERICULOSIDADES,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('285', '561', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as VALE_TRANSPORTE,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('410', '560', '563', '719')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as VALE_ALIMENTACAO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('562', '749')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as VALE_CESTA,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('738')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as PLANO_SAUDE,

        (
            select max(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('056', '570', '574', '575', '576', '577', '711')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as PLANO_ODONTOLOGICO,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('057')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as DIARIAS_VIAGEM,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('132', '133')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
                
        ) as FERIAS_COMPRADAS,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('001', '147', '450')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ 
        ) as ADIANTAMENTO,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('147')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ 
        ) as ARR_ADIANTAMENTO,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('421')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('2')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ 
        ) as IRRF_ADIANTAMENTO,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as PRIMEIRA_13,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('300', '013', '015', '203', '204', '205', '206', '247', '304', '306', '307')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as SEGUNDA_13_provento,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('510', '403', '407', '423', '530', '535', '533', '414')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PD = FOLHA.RC_PD
                and SRC010.RC_SEQ = FOLHA.RC_SEQ
        ) as SEGUNDA_13_desconto

    from SRC010 FOLHA (nolock)
        inner join SRA010 (nolock)
            on SRA010.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RC_FILIAL
            and SRA010.RA_MAT = FOLHA.RC_MAT
            and trim(FOLHA.RC_MAT) not in ('003264', '003263')

            left join CTD010 (nolock)
                on CTD010.D_E_L_E_T_ = ''
                and SRA010.RA_ITEM = CTD010.CTD_ITEM

        inner join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and FOLHA.RC_CC = CTT010.CTT_CUSTO
    where FOLHA.D_E_L_E_T_ = ''
        
) as FOLHA_RESUMO
group by
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RC_MAT,
    FOLHA_RESUMO.RA_NOME,
    FOLHA_RESUMO.CTT_DESC01,
    FOLHA_RESUMO.RC_CC,
    FOLHA_RESUMO.CTD_DESC01
