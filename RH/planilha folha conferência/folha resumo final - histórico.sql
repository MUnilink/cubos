select
    FOLHA_RESUMO.RD_FILIAL,
    FOLHA_RESUMO.RD_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    count(distinct FOLHA_RESUMO.ATIVOS) ATIVOS,
    count(distinct FOLHA_RESUMO.LICENCA) LICENCA,
    count(distinct FOLHA_RESUMO.DEMITIDOS) DEMITIDOS,
    sum(FOLHA_RESUMO.Custo_Total_COM_Diárias_Motoristas) as Custo_Total_COM_Diárias_Motoristas,
    sum(FOLHA_RESUMO.Custo_Total_SEM_Diárias_Motoristas) as Custo_Total_SEM_Diárias_Motoristas,
    sum(FOLHA_RESUMO.SALARIO_BASE) as SALARIO_BASE,
    sum(FOLHA_RESUMO.GRATIFICACAO) as GRATIFICACAO,
    sum(FOLHA_RESUMO.HORAS_EXTRAS) as HORAS_EXTRAS,
    sum(FOLHA_RESUMO.DOMINGOS_FERIADOS) as DOMINGOS_FERIADOS,
    sum(FOLHA_RESUMO.ADICIONAL_NOTURNO) as ADICIONAL_NOTURNO,
    sum(FOLHA_RESUMO.PERICULOSIDADE) as PERICULOSIDADE,
    sum(FOLHA_RESUMO.ADD_RISCO) as ADICIONAL_RISCO,
    sum(FOLHA_RESUMO.VALE_TRANSPORTE) as VALE_TRANSPORTE,
    sum(FOLHA_RESUMO.VALE_ALIMENTACAO) as VALE_ALIMENTACAO,
    sum(FOLHA_RESUMO.VALE_CESTA) as VALE_CESTA,
    sum(FOLHA_RESUMO.PLANO_SAUDE) as PLANO_SAUDE,
    sum(FOLHA_RESUMO.PLANO_ODONTOLOGICO) as PLANO_ODONTOLOGICO,
    sum(FOLHA_RESUMO.DIARIAS_VIAGEM) as DIARIAS_VIAGEM,
    sum(FOLHA_RESUMO.FERIAS_COMPRADAS) as FERIAS_COMPRADAS,
    sum(FOLHA_RESUMO.ADIANTAMENTO) as ADIANTAMENTO
from
(
    select
        FOLHA.RD_FILIAL,
        FOLHA.RD_PERIODO,
        substring(FOLHA.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(FOLHA.RD_PERIODO, 1, 4) as PERIODO_ANO,
        FOLHA.RD_MAT,
        FOLHA.RD_PD,
        FOLHA.RD_DATARQ ,
        FOLHA.RD_SEMANA ,
        FOLHA.RD_SEQ ,
        FOLHA.RD_CC,
        FOLHA.RD_PROCES,
        SRA010.RA_SITFOLH,
        row_number() over
            (
                partition by
                FOLHA.RD_FILIAL,
                FOLHA.RD_PERIODO,
                FOLHA.RD_MAT,
                FOLHA.RD_PD,
                FOLHA.RD_DATARQ ,
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
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    (SRD010.RD_PD in ('020') and SRD010.RD_PD not in ('130', '220'))
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as ATIVOS,
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'L')
            from SRA010 (nolock)
            where
                    SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_MAT = FOLHA.RD_MAT
                and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
                and trim(SRA010.RA_SITFOLH) = 'A'
        ) as LICENCA,
        (
            select top 1 concat(cast(FOLHA.RD_MAT as varchar), 'D')
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    (SRD010.RD_PD in ('220'))
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_PD = FOLHA.RD_PD
        ) as DEMITIDOS,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('057', '020', '117', '118', '281', '061', '062', '063', '064', '111', '112', '113', '116', '344', '030', '041', '282', '096', '097', '215', '356', '285', '561', '560', '563', '562', '569', '570', '576', '577', '569', '570', '576', '577', '140')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Custo_Total_COM_Diárias_Motoristas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('020', '117', '118', '281', '061', '062', '063', '064', '111', '112', '113', '116', '344', '030', '041', '282', '096', '097', '215', '356', '285', '561', '560', '563', '562', '569', '570', '576', '577', '569', '570', '576', '577', '140')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as Custo_Total_SEM_Diárias_Motoristas,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('020')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as SALARIO_BASE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('117', '118', '281')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as GRATIFICACAO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('061', '062', '063', '064', '111', '112', '113', '116' /* ??? add noturno?*/, '344')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as HORAS_EXTRAS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD = '114' /* ??? 114 equivalente a domingo/feriado ou hora extra mesmo? aparentemente OK*/
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as DOMINGOS_FERIADOS,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('030', '041', '282') /*or  SRD010.RD_PD = '116'  verba 116 também???*/
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as ADICIONAL_NOTURNO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('096', '097', '215', '356')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as PERICULOSIDADE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('039')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as ADD_RISCO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('285', '561')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as VALE_TRANSPORTE,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('560', '563')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
        ) as VALE_ALIMENTACAO,
        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('562', '749')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as VALE_CESTA,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('738')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as PLANO_SAUDE,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('569', '570', '576', '577')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as PLANO_ODONTOLOGICO,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('057')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as DIARIAS_VIAGEM,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where 
                    SRD010.RD_PD in ('132', '133')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ 
                and SRD010.RD_PD = FOLHA.RD_PD 
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA 
                and SRD010.RD_SEQ = FOLHA.RD_SEQ 
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES
                
        ) as FERIAS_COMPRADAS,

        (
            select sum(SRD010.RD_VALOR)
            from SRD010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRD010.RD_PD = SRV010.RV_COD
            where
                    SRD010.RD_PD in ('183')
                and SRD010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRD010.RD_MAT = FOLHA.RD_MAT
                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
                and SRD010.RD_DATARQ = FOLHA.RD_DATARQ
                and SRD010.RD_PD = FOLHA.RD_PD
                and SRD010.RD_SEMANA = FOLHA.RD_SEMANA
                and SRD010.RD_SEQ = FOLHA.RD_SEQ
                and SRD010.RD_CC = FOLHA.RD_CC
                and SRD010.RD_PROCES = FOLHA.RD_PROCES 
        ) as ADIANTAMENTO

    from SRD010 FOLHA (nolock)
        inner join SRA010 (nolock)
            on SRA010.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RD_FILIAL
            and SRA010.RA_MAT = FOLHA.RD_MAT
    where FOLHA.D_E_L_E_T_ = ''
        
) as FOLHA_RESUMO
group by
    FOLHA_RESUMO.RD_FILIAL,
    FOLHA_RESUMO.RD_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES