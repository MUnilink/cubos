select
    FOLHA_RESUMO.RD_MAT,
    FOLHA_RESUMO.RD_FILIAL,
    FOLHA_RESUMO.RD_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RA_NOME,
    FOLHA_RESUMO.RD_CC,
    FOLHA_RESUMO.CTT_DESC01,
    FOLHA_RESUMO.RD_ROTEIR as ROTEIRO,
    0 as ATIVOS,
    0 as LICENCA,
    0 as DEMITIDOS,
    0 as FERIAS,
    sum(FOLHA_RESUMO.Custo_Total_COM_Diárias_Motoristas) as Custo_Total_COM_Diárias_Motoristas,
    sum(FOLHA_RESUMO.Custo_Total_SEM_Diárias_Motoristas_provento) + sum(FOLHA_RESUMO.Custo_Total_SEM_Diárias_Motoristas_bases) as Custo_Total_SEM_Diárias_Motoristas,
    sum(isnull(FOLHA_RESUMO.ADIANTAMENTO, 0.0) - isnull(FOLHA_RESUMO.IRRF_ADIANTAMENTO, 0.0)) as ADIANTAMENTO,
    sum(FOLHA_RESUMO.ARR_ADIANTAMENTO) as ARREDOND_ADIANTAMENTO,
    sum(FOLHA_RESUMO.IRRF_ADIANTAMENTO) as IR_ADIANTAMENTO,
    max(FOLHA_RESUMO.SALARIO_BASE) as SALARIO_BASE,
    sum(FOLHA_RESUMO.HORAS_EXTRAS) as HORAS_EXTRAS,
    sum(isnull(FOLHA_RESUMO.DOMINGOS_FERIADOS_provento, 0.0)) - sum(isnull(FOLHA_RESUMO.DOMINGOS_FERIADOS_desconto, 0.0)) as DOMINGOS_FERIADOS,
    sum(isnull(FOLHA_RESUMO.DOMINGOS_FERIADOS_provento, 0.0)) as DOBRAS_VALOR_TOTAL,
    sum(isnull(FOLHA_RESUMO.DOMINGOS_FERIADOS_desconto, 0.0)) as DOBRAS_DESCONTO,
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
    sum(FOLHA_RESUMO.SEGUNDA_13_provento) - sum(FOLHA_RESUMO.SEGUNDA_13_desconto) as SEGUNDA_13,
    sum(FOLHA_RESUMO.Segunda_13_media_horas) as SEGUNDA_13_MEDIAHORAS,
    sum(FOLHA_RESUMO.Segunda_13_media_valor) as SEGUNDA_13_MEDIAVALOR
from
(
    select
        FOLHA.RD_FILIAL,
        FOLHA.RD_PERIODO,
        substring(FOLHA.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
        FOLHA.RD_MAT,
        FOLHA.RD_PD,
        FOLHA.RD_SEMANA,
        FOLHA.RD_SEQ,
        FOLHA.RD_ROTEIR,
        CTT010.CTT_DESC01,
        FOLHA.RD_CC,
        SRA010.RA_NOME,
        FOLHA.RD_PROCES,
        SRA010.RA_SITFOLH,
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as Custo_Total_COM_Diárias_Motoristas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD not in ('450', '057')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as HORAS_EXTRAS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('113', '451', '452')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as DOMINGOS_FERIADOS_provento,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('623')
                and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.D_E_L_E_T_ = ''
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as DOMINGOS_FERIADOS_desconto,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('030', '041', '371', '372')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as ADICIONAL_NOTURNO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('039', '096', '097', '215', '356', '013')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as PLANO_SAUDE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on SRV010.D_E_L_E_T_ = ''
                    and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('056', '570', '574', '575', '576', '577', '711')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as IRRF_ADIANTAMENTO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
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
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as SEGUNDA_13_provento,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('510', '403', '407', '423', '530', '535', '533', '414', '373', '374')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as SEGUNDA_13_desconto,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in (306)
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as Segunda_13_media_horas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in (307)
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
                and SRD010.RD_ROTEIR = FOLHA.RD_ROTEIR
        ) as Segunda_13_media_valor

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
    FOLHA_RESUMO.RD_CC,
    FOLHA_RESUMO.RD_ROTEIR
