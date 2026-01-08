select distinct
    ZE1.ZE1_NUM as VIAGEM,
    left(ZE4.ZE4_DATAFI, 6) as PERIODO_VGA,
    case when isdate(concat(ZE4.ZE4_DATAIN, ' ', replace(ZE4.ZE4_HORAIN, ',', ':'))) = 1 then convert(datetime, concat(ZE4.ZE4_DATAIN, ' ', replace(ZE4.ZE4_HORAIN, ',', ':')), 113) else cast(ZE4.ZE4_DATAIN as date) end as DATA_INI,
    case when isdate(concat(ZE4.ZE4_DATAFI, ' ', replace(ZE4.ZE4_HORAFI, ',', ':'))) = 1 then convert(datetime, concat(ZE4.ZE4_DATAFI, ' ', replace(ZE4.ZE4_HORAFI, ',', ':')), 113) else cast(ZE4.ZE4_DATAFI as date) end as DATA_FIM,
    case when ZE1.ZE1_TIPO = 16 or ZE1.ZE1_TIPO = 15 then 0.0 else cast(ZE4.ZE4_TOTHR as decimal(15, 2)) end as VGA_HORAS,
    
    concat
    (
        ZE4.ZE4_STATUS, ' - ',
        case ZE4.ZE4_STATUS
            when '1' then upper('Em Aberto')
            when '2' then upper('Em Transito')
            when '3' then upper('Encerrada')
            when '4' then upper('Chegada em Filial')
            when '5' then upper('Fechada')
            when '9' then upper('Cancelada')
            else 'Outros' end
    ) as STATUS_TMS,
    
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_KMFIM as km_fim,
    
    trim(ZE5.ZE5_ITENS) as VGA_COMPLEMENTOS,
    trim(ZE5.ZE5_MOTORI) as MOTORISTA,
    trim(ZE5.ZE5_BEMCAV) as CM,
    trim(ZE5.ZE5_CARR1) as SR1,
    trim(ZE5.ZE5_CARR2) as SR2,
    trim(ZE5.ZE5_CARR3) as SR3,
    
    case when nullif(ZE1.ZE1_NOTA, '') is not null then trim(ZE1.ZE1_NOTA) else trim(ZE1.ZE1_COD) end as VGA_CODIGO,
    cast(ZE1.ZE1_DATA as date) as VGA_DATA,
    left(ZE1.ZE1_COMPET, 6) as COMPETENCIA,

    case when ZE1.ZE1_TIPO in (15, 16) then cast(RAT_IMPR.PERC_RATEIO * ZE1.ZE1_TOTAL as numeric(15 ,2)) else 0.00 end as VALOR_IMPR,
    case when ZE1.ZE1_TIPO in (15, 16) then RAT_IMPR.TIPO else ZE1.ZE1_TIPO end as ID_TIPO,
    case when ZE1.ZE1_TIPO in (15, 16) then 0.0 else cast(ZE1.ZE1_TOTAL as numeric(15, 2)) end as VALOR_PROD,
    cast(ZE1.ZE1_IMPR1 as numeric(15, 2)) as HIMP_AFAMNT,
    cast(ZE1.ZE1_IMPR2 as numeric(15, 2)) as HIMP_FER,
    cast(ZE1.ZE1_IMPR3 as numeric(15, 2)) as HIMP_PON,
    cast(ZE1.ZE1_TOTAL as numeric(15, 2)) as VGA_TOTAL,

    ZE1.ZE1_ITEM as VGA_ITEMCUSTO,
    cast(ZE1.ZE1_TIPO as int) as VGA_TIPO,
    case
        when ZE1.ZE1_TIPO = 1 then 'RECEITA'
        when ZE1.ZE1_TIPO = 2 then 'FOLHA'
        when ZE1.ZE1_TIPO = 3 then 'MANUTENÇÃO'
        when ZE1.ZE1_TIPO = 4 then 'MATERIAIS'
        when ZE1.ZE1_TIPO = 5 then 'COMPRAS'
        when ZE1.ZE1_TIPO = 6 then 'DEPRECIAÇÃO'
        when ZE1.ZE1_TIPO = 7 then 'CONTABILIDADE'
        when ZE1.ZE1_TIPO = 8 then 'DESPESAS FINANCEIRAS'
        when ZE1.ZE1_TIPO = 9 then 'DOCUMENTAÇÃO'
        when ZE1.ZE1_TIPO = 10 then 'COMBUSTIVEL'
        when ZE1.ZE1_TIPO = 11 then 'SERVIÇOS TOMADOS'
        when ZE1.ZE1_TIPO = 12 then 'SEGURO EQUIPAMENTO'
        when ZE1.ZE1_TIPO = 13 then 'PNEUS'
        when ZE1.ZE1_TIPO = 14 then 'PROVISÕES'
        when ZE1.ZE1_TIPO = 17 then 'DIÁRIA'
        when ZE1.ZE1_TIPO = 18 then 'SEGURO AVARIA'
        when ZE1.ZE1_TIPO = 19 then 'SEGURO ROUBO'
        when ZE1.ZE1_TIPO = 15 and RAT_IMPR.TIPO = 2 then 'FOLHA'
        when ZE1.ZE1_TIPO = 15 and RAT_IMPR.TIPO = 14 then 'PROVISÕES'
        when ZE1.ZE1_TIPO = 16 and RAT_IMPR.TIPO = 3 then 'MANUTENÇÃO'
        when ZE1.ZE1_TIPO = 16 and RAT_IMPR.TIPO = 6 then 'DEPRECIAÇÃO'
        when ZE1.ZE1_TIPO = 16 and RAT_IMPR.TIPO = 9 then 'DOCUMENTAÇÃO'
        when ZE1.ZE1_TIPO = 16 and RAT_IMPR.TIPO = 12 then 'SEGURO EQUIPAMENTO'
        else 'OUTROS'
    end as TIPO_ITEM,

    case
        when ZE1.ZE1_TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (1, 4, 5, 11))
        when ZE1.ZE1_TIPO in (2, 14, 15) then (select trim(DA4010.DA4_COD) from DA4010 (nolock) where DA4010.D_E_L_E_T_ = '' and DA4010.DA4_COD = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (2, 14, 15))
        when ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZE1.ZE1_TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO = 7)
    else null end as DESC_RECURSO

from ZE1010 ZE1 (nolock)
    left join ZE5010 ZE5 (nolock)
        on ZE5.D_E_L_E_T_ = ''
        and ZE5.ZE5_FILIAL = ZE1.ZE1_FILIAL
        and ZE5.ZE5_VIAGEM = ZE1.ZE1_NUM
        
        left join ZE4010 ZE4 (nolock)
            on ZE4.D_E_L_E_T_ = ''
            and ZE4.ZE4_FILIAL = ZE5.ZE5_FILIAL
            and ZE4.ZE4_VIAGEM = ZE5.ZE5_VIAGEM

    left join
    (
        select
            ZG1.ZG1_FILORI as FILIAL,
            ZG1.ZG1_COMPET as COMPETENCIA,
            ZG1.ZG1_CODIGO as INSUMO,
            ZG1.ZG1_TIPO as TIPO,
            ZG1.ZG1_VLIMPR as VLIMP_TOT,
            cast(
                ZG1.ZG1_VLIMPR/
                (
                    select sum(ZG1010.ZG1_VLIMPR)
                    from ZG1010
                    where
                        ZG1010.ZG1_VLIMPR != 0
                    and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                    and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                    and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                    and ZG1010.D_E_L_E_T_ = ''
                )
                as numeric(15, 2)
            ) as PERC_RATEIO
        from ZG1010 ZG1 (nolock)
        where ZG1.D_E_L_E_T_ = ''
    ) RAT_IMPR
        on case when RAT_IMPR.TIPO in (2, 14) then 15 when RAT_IMPR.TIPO in (3, 6, 9, 12) then 16 else null end = ZE1.ZE1_TIPO
        and RAT_IMPR.FILIAL = left(ZE1.ZE1_FILIAL, 4)
        and RAT_IMPR.COMPETENCIA = left(ZE1.ZE1_COMPET, 6)
        and RAT_IMPR.INSUMO = ZE1.ZE1_COD
where
        ZE1.D_E_L_E_T_ = ''
    and left(ZE1.ZE1_COMPET,6)=:PERIODO
