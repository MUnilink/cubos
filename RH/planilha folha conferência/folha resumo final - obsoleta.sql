select
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES,
    0 as ATIVOS,
    0 as LICENCA,
    0 as DEMITIDOS,
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
        FOLHA.RC_FILIAL,
        FOLHA.RC_PERIODO,
        substring(FOLHA.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(FOLHA.RC_PERIODO, 1, 4) as PERIODO_ANO,
        FOLHA.RC_MAT,
        FOLHA.RC_PD,
        FOLHA.RC_SEMANA ,
        FOLHA.RC_SEQ ,
        FOLHA.RC_CC,
        FOLHA.RC_PROCES,
        SRA010.RA_SITFOLH,

        (
            select top 1 concat(cast(FOLHA.RC_MAT as varchar), 'A')
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    (SRC010.RC_PD in ('020') and SRC010.RC_PD not in ('130', '220'))
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as ATIVOS,
        (
            select top 1 concat(cast(FOLHA.RC_MAT as varchar), 'L')
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    (SRC010.RC_PD in ('130'))
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as LICENCA,
        (
            select top 1 concat(cast(FOLHA.RC_MAT as varchar), 'D')
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    (SRC010.RC_PD in ('220'))
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as DEMITIDOS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('057', '020', '117', '118', '281', '061', '062', '063', '064', '111', '112', '113', '116', '344', '030', '041', '282', '096', '097', '215', '356', '285', '561', '560', '563', '562', '569', '570', '576', '577', '569', '570', '576', '577', '140')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as Custo_Total_COM_Diárias_Motoristas,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('020', '117', '118', '281', '061', '062', '063', '064', '111', '112', '113', '116', '344', '030', '041', '282', '096', '097', '215', '356', '285', '561', '560', '563', '562', '569', '570', '576', '577', '569', '570', '576', '577', '140')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as Custo_Total_SEM_Diárias_Motoristas,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('020')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as SALARIO_BASE,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('117', '118', '281')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as GRATIFICACAO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('061', '062', '063', '064', '111', '112', '113', '116' /* ??? add noturno?*/, '344')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as HORAS_EXTRAS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD = '114' /* ??? 114 equivalente a domingo/feriado ou hora extra mesmo? aparentemente OK*/
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as DOMINGOS_FERIADOS,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('030', '041', '282') /*or  SRC010.RC_PD = '116'  verba 116 também???*/
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as ADICIONAL_NOTURNO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('096', '097', '215', '356')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as PERICULOSIDADE,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('039')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as ADD_RISCO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('285', '561', '796')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as VALE_TRANSPORTE,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('560', '563', '719', '410')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
        ) as VALE_ALIMENTACAO,
        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('562', '749')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as VALE_CESTA,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('738')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as PLANO_SAUDE,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where
                    SRC010.RC_PD in ('569', '570', '576', '577')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as PLANO_ODONTOLOGICO,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('057')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as DIARIAS_VIAGEM,

        (
            select sum(SRC010.RC_VALOR)
            from SRC010 (nolock)
                inner join SRV010 (nolock)
                    on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                    and SRC010.RC_PD = SRV010.RV_COD
            where 
                    SRC010.RC_PD in ('132', '133')
                and SRC010.D_E_L_E_T_ = '' and SRV010.RV_TIPOCOD in ('1', '2', '3', '4')
                and SRC010.RC_MAT = FOLHA.RC_MAT
                and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
                and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
                and SRC010.RC_PD = FOLHA.RC_PD
                
        ) as FERIAS_COMPRADAS,

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
        ) as ADIANTAMENTO

    from SRC010 FOLHA (nolock)
        inner join SRA010 (nolock)
            on SRA010.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = FOLHA.RC_FILIAL
            and SRA010.RA_MAT = FOLHA.RC_MAT
    where FOLHA.D_E_L_E_T_ = ''
        
) as FOLHA_RESUMO
group by
    FOLHA_RESUMO.RC_FILIAL,
    FOLHA_RESUMO.RC_PERIODO,
    FOLHA_RESUMO.PERIODO_ANO,
    FOLHA_RESUMO.PERIODO_MES
