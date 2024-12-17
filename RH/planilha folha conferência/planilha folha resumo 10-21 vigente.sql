select
    SRC.RC_FILIAL as FILIAL,
    SRC.RC_PERIODO as PERIODO,
    substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
    substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
    SRC.RC_MAT as MATRICULA,
    SRC.RC_PD as VERBA,
    SRC.RC_SEQ as SEQ,
    SRC.RC_ROTEIR as ROTEIRO,
    CTT010.CTT_DESC01 as CC,
    CTD010.CTD_DESC01 as ATIVIDADE,
    SRA010.RA_NOME as NOME,
    SRA010.RA_SITFOLH as SITUACAO,

    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD not in ('450', '057')
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('1')
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as Custo_Total_COM_Diárias_Motoristas_provento,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD ('709', '711', '719', '738', '749', '796')
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('3', '4')
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as Custo_Total_COM_Diárias_Motoristas_bases,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD not in ('450', '057')
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('1')
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as Custo_Total_SEM_Diárias_Motoristas_provento,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD ('709', '711', '719', '738', '749', '796')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as Custo_Total_SEM_Diárias_Motoristas_bases,
    (
        select max(SRA010.RA_SALARIO)
        from SRA010 (nolock)
        where
                SRA010.D_E_L_E_T_ = ''
            and SRA010.RA_FILIAL = SRC.RC_FILIAL
            and SRA010.RA_MAT = SRC.RC_MAT
    ) as SALARIO_BASE,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('029', '111', '112', '113', '344')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as HORAS_EXTRAS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('113', '451', '452')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as DOBRAS_PROVENTOS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('623')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as DOBRAS_DESCONTOS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('030', '041', '371', '372')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as ADICIONAL_NOTURNO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where 
                SRC010.RC_PD in ('039', '096', '097', '215', '356', '013')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as PERICULOSIDADES,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('285', '561', '796')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as VALE_TRANSPORTE,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('410', '560', '563', '719')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as VALE_ALIMENTACAO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('562', '749')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as VALE_CESTA,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where 
                SRC010.RC_PD in ('738')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as PLANO_SAUDE,
    (
        select max(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('056', '570', '574', '575', '576', '577', '711')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as PLANO_ODONTOLOGICO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where 
                SRC010.RC_PD in ('057')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as DIARIAS_VIAGEM,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where 
                SRC010.RC_PD in ('132', '133')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as FERIAS_COMPRADAS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('001', '147', '450')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as ADIANTAMENTO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('147')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as ARR_ADIANTAMENTO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('421')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as IR_ADIANTAMENTO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
                SRC010.RC_PD in ('510', '009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as PRIMEIRA_13,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
                SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD = '1'
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as SEGUNDA_13_PROV,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
                SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD = '2'
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as SEGUNDA_13_DESC,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
                SRC010.RC_PD in (306)
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as SEGUNDA_13_MEDIAHORAS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
                SRC010.RC_PD in ('307')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as SEGUNDA_13_MEDIAVALOR,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
        where
                SRC010.RC_PD in ('208')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = SRC.RC_PERIODO
            and SRC010.RC_FILIAL = SRC.RC_FILIAL
            and SRC010.RC_MAT = SRC.RC_MAT
            and SRC010.RC_PD = SRC.RC_PD
            and SRC010.RC_SEQ = SRC.RC_SEQ
            and SRC010.RC_ROTEIR = SRC.RC_ROTEIR
    ) as SEGUNDA_13_ADICRISCO,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
        where
                SRC.RC_PD = '510'
            and SRC.RC_ROTEIR = '132'
            and SRD010.RD_ROTEIR = '131'
            and left(SRD010.RD_PERIODO, 4) = left(SRC.RC_PERIODO, 4)
            and SRD010.RD_FILIAL = SRC.RC_FILIAL
            and SRD010.RD_MAT = SRC.RC_MAT
            and SRD010.D_E_L_E_T_ = ''
    ) as PRIMEIRA_13

from SRC010 SRC (nolock)
    inner join SRA010 (nolock)
        on SRA010.D_E_L_E_T_ = ''
        and SRA010.RA_FILIAL = SRC.RC_FILIAL
        and SRA010.RA_MAT = SRC.RC_MAT
        and trim(SRC.RC_MAT) not in ('003264', '003263')

    left join CTD010 (nolock)
        on CTD010.D_E_L_E_T_ = ''
        and SRC.RC_ITEM = CTD010.CTD_ITEM
    left join CTT010 (nolock)
        on CTT010.D_E_L_E_T_ = ''
        and SRC.RC_CC = CTT010.CTT_CUSTO
    left join SRV010 SRV (nolock)
        on SRV.RV_COD = SRC.RC_PD
where SRC.D_E_L_E_T_ = ''
