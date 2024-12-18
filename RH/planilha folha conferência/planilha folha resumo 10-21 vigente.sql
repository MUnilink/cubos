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
    CTT010.CTT_DESC01,
    CTD010.CTD_DESC01,
    FOLHA.RC_CC,
    SRA010.RA_NOME,
    FOLHA.RC_PROCES,
    SRA010.RA_SITFOLH,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on SRV010.D_E_L_E_T_ = ''
                and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD not in ('450', '057')
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('1')
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
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('3', '4')
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
            and SRC010.D_E_L_E_T_ = ''
            and SRV010.RV_TIPOCOD in ('1')
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
            and SRC010.D_E_L_E_T_ = ''
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
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as DOBRAS_PROVENTOS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on SRV010.D_E_L_E_T_ = ''
                and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('623')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as DOBRAS_DESCONTOS,
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
                SRC010.RC_PD in ('039', '096', '097', '215', '356', '013')
            and SRC010.D_E_L_E_T_ = ''
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
            and SRC010.D_E_L_E_T_ = ''
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
            and SRC010.D_E_L_E_T_ = ''
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
            and SRC010.D_E_L_E_T_ = ''
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
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as IR_ADIANTAMENTO,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('510', '009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772')
            and SRC010.D_E_L_E_T_ = ''
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
    ) as SEGUNDA_13_PROV,
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
    ) as SEGUNDA_13_DESC,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in (306)
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as SEGUNDA_13_MEDIAHORAS,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('307')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as SEGUNDA_13_MEDIAVALOR,
    (
        select sum(SRC010.RC_VALOR)
        from SRC010 (nolock)
            inner join SRV010 (nolock)
                on SRV010.D_E_L_E_T_ = ''
                and substring(SRC010.RC_FILIAL, 1, 4) = SRV010.RV_FILIAL
                and SRC010.RC_PD = SRV010.RV_COD
        where
                SRC010.RC_PD in ('208')
            and SRC010.D_E_L_E_T_ = ''
            and SRC010.RC_PERIODO = FOLHA.RC_PERIODO
            and SRC010.RC_FILIAL = FOLHA.RC_FILIAL
            and SRC010.RC_MAT = FOLHA.RC_MAT
            and SRC010.RC_PD = FOLHA.RC_PD
            and SRC010.RC_SEQ = FOLHA.RC_SEQ
            and SRC010.RC_ROTEIR = FOLHA.RC_ROTEIR
    ) as SEGUNDA_13_ADICRISCO,
    (
        select sum(SRD010.RD_VALOR)
        from SRD010 (nolock)
        where
                FOLHA.RC_PD = '510'
            and FOLHA.RC_ROTEIR = '132'
            and SRD010.RD_ROTEIR = '131'
            and left(SRD010.RD_PERIODO, 4) = left(FOLHA.RC_PERIODO, 4)
            and SRD010.RD_FILIAL = FOLHA.RC_FILIAL
            and SRD010.RD_MAT = FOLHA.RC_MAT
            and SRD010.D_E_L_E_T_ = ''
    ) as PRIMEIRA_13

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
