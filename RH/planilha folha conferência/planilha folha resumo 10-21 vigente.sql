select
    FOLHA_RESUMO.RC_MAT,
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RC_ROTEIR as ROTEIRO,
    FOLHA_RESUMO.ATIVIDADE,
    FOLHA_RESUMO.NOME,
    FOLHA_RESUMO.SITUACAO,
    FOLHA_RESUMO.CARGO,
    FOLHA_RESUMO.DESC_CARGO,
    FOLHA_RESUMO.FUNCAO,
    FOLHA_RESUMO.DESC_FUNCAO,
    FOLHA_RESUMO.ADMISSAO,
    FOLHA_RESUMO.DEMISSAO,
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
    sum(FOLHA_RESUMO.SEGUNDA_13_provento) - sum(FOLHA_RESUMO.SEGUNDA_13_desconto) as SEGUNDA_13_LIQUIDO,
    sum(FOLHA_RESUMO.SEGUNDA_13_provento) as SEGUNDA_13_PROV,
    sum(FOLHA_RESUMO.SEGUNDA_13_desconto) as SEGUNDA_13_DESC,
    sum(FOLHA_RESUMO.SEGUNDA_13_IR_seg13) as SEGUNDA_13_IR,
    sum(FOLHA_RESUMO.SEGUNDA_13_INSS_seg13) as SEGUNDA_13_INSS,
    sum(FOLHA_RESUMO.Segunda_13_pensao_alim) as SEGUNDA_13_PENSAO,
    sum(FOLHA_RESUMO.Segunda_13_mensindical) as SEGUNDA_13_MENSIND,
    sum(FOLHA_RESUMO.Segunda_13_media_horas) as SEGUNDA_13_MEDIAHORAS,
    sum(FOLHA_RESUMO.Segunda_13_media_valor) as SEGUNDA_13_MEDIAVALOR,
    sum(FOLHA_RESUMO.Segunda_13_medias) as SEGUNDA_13_MEDIAS
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
            FOLHA.RC_ROTEIR,
            CTD010.CTD_DESC01 as ATIVIDADE,
            trim(SRA.RA_NOMECMP) as NOME,
            SRA.RA_SITFOLH as SITUACAO,
            trim(SQ3.Q3_CARGO) as CARGO,
            trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
            trim(SRJ.RJ_FUNCAO) as FUNCAO,
            trim(SRJ.RJ_DESC) as DESC_FUNCAO,
            cast(SRA.RA_ADMISSA as date) as ADMISSAO,
            cast(SRA.RA_DEMISSA as date) as DEMISSAO,
            FOLHA.RC_PROCES,
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as HORAS_EXTRAS,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on SRV010.D_E_L_E_T_ = ''
                        and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('113', '451', '452')
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as DOMINGOS_FERIADOS_provento,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on SRV010.D_E_L_E_T_ = ''
                        and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('623')
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as DOMINGOS_FERIADOS_desconto,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on SRV010.D_E_L_E_T_ = ''
                        and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('030', '041', '371', '372')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as ADICIONAL_NOTURNO,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on SRV010.D_E_L_E_T_ = ''
                        and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where 
                        SRC010.RC_PD in ('039', '096', '097', '215', '356', '013', '208')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
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
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as IRRF_ADIANTAMENTO,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('510', '009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as PRIMEIRA_13,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD = '1'
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as SEGUNDA_13_provento,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD = '2'
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as SEGUNDA_13_desconto,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PD in ('423')
                    and SRV010.RV_TIPOCOD = '2'
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as SEGUNDA_13_IR_seg13,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PD in ('403')
                    and SRV010.RV_TIPOCOD = '2'
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as SEGUNDA_13_INSS_seg13,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PD in ('373', '374')
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as Segunda_13_pensao_alim,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PD in ('407')
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as Segunda_13_mensindical,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('306')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as Segunda_13_media_horas,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('307')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as Segunda_13_media_valor,
            (
                select sum(SRC010.RC_VALOR)
                from SRC010 (nolock)
                    inner join SRV010 (nolock)
                        on SRV010.D_E_L_E_T_ = ''
                        and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                        and SRC010.RC_PD = SRV010.RV_COD
                where
                        SRC010.RC_PD in ('306', '307')
                    and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                    and SRC010.D_E_L_E_T_ = ''
                    and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                    and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                    and SRC010.RC_MAT = FOLHA.RC_MAT
                    and SRC010.RC_PD = FOLHA.RC_PD
                    and SRC010.RC_SEQ = FOLHA.RC_SEQ
                    and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
            ) as Segunda_13_medias

        from SRC010 FOLHA (nolock)
            inner join SRA010 SRA (nolock)
                on SRA.D_E_L_E_T_ = ''
                and SRA.RA_FILIAL = FOLHA.RC_FILIAL
                and SRA.RA_MAT = FOLHA.RC_MAT
                and trim(FOLHA.RC_MAT) not in ('003264', '003263')

                left join SRJ010 SRJ (nolock)
                    on SRJ.D_E_L_E_T_ = ''
                    and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                    left join SQ3010 SQ3 (nolock)
                        on SQ3.D_E_L_E_T_ = ''
                        and SQ3.Q3_CARGO = SRJ.RJ_CARGO

            left join CTD010 (nolock)
                on CTD010.D_E_L_E_T_ = ''
                and CTD010.CTD_ITEM = FOLHA.RC_ITEM
            left join CTT010 (nolock)
                on CTT010.D_E_L_E_T_ = ''
                and CTT010.CTT_CUSTO = FOLHA.RC_CC
            left join SRV010 SRV (nolock)
                on SRV.RV_COD = FOLHA.RC_PD
        where FOLHA.D_E_L_E_T_ = ''
) as FOLHA_RESUMO
group by
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    FOLHA_RESUMO.RC_MAT,
    FOLHA_RESUMO.RC_ROTEIR,
    FOLHA_RESUMO.ATIVIDADE,
    FOLHA_RESUMO.NOME,
    FOLHA_RESUMO.SITUACAO,
    FOLHA_RESUMO.CARGO,
    FOLHA_RESUMO.DESC_CARGO,
    FOLHA_RESUMO.FUNCAO,
    FOLHA_RESUMO.DESC_FUNCAO,
    FOLHA_RESUMO.ADMISSAO,
    FOLHA_RESUMO.DEMISSAO
