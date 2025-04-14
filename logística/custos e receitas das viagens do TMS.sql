select distinct
    ZE1.ZE1_NUM as VIAGEM,
    ZE4.ZE4_DATAFI as DATA_FIM,
    left(ZE4.ZE4_DATAFI, 6) as PERIODO,
    ZE4.ZE4_TOTHR as VGA_HORAS,
    ZE4.ZE4_STATUS as STATUS_TMS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_KMFIM as km_fim,
    
    trim(ZE5.ZE5_ITENS) as VGA_COMPLEMENTOS,
    trim(ZE5.ZE5_MOTORI) as MOTORISTA,
    trim(ZE5.ZE5_BEMCAV) as CM,
    trim(ZE5.ZE5_CARR1) as SR1,
    trim(ZE5.ZE5_CARR2) as SR2,
    trim(ZE5.ZE5_CARR3) as SR3,
    
    trim(ZE1.ZE1_COD) as VGA_CODIGO,
    cast(ZE1.ZE1_TOTAL as numeric(15, 2)) as VGA_VALOR,
    cast(ZE1.ZE1_DATA as date) as VGA_DATA,
    left(ZE1.ZE1_COMPET, 6) as VGA_PERIODO,

    RAT_IMPR.*,
    case when ZE1.ZE1_TIPO in (15, 16) then cast(RAT_IMPR.PERC_RATEIO * ZE1.ZE1_TOTAL as numeric(15 ,2)) else 0.00 end as VALOR_IMPR,
    case when ZE1.ZE1_TIPO in (15, 16) then RAT_IMPR.TIPO else ZE1.ZE1_TIPO end as ID_TIPO,

    ZE1.ZE1_ITEM as VGA_ITEMCUSTO,
    ZE1.ZE1_TIPO as VGA_TIPO,
    case ZE1.ZE1_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'OUTROS CUSTOS - TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        when 17 then 'DIÁRIA'
        else 'OUTROS'
    end as TIPO_ITEM,

    case
        when ZE1.ZE1_TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (1, 4, 5, 11))
        when ZE1.ZE1_TIPO in (2, 14, 15) then (select trim(DA4010.DA4_COD) from DA4010 (nolock) where DA4010.D_E_L_E_T_ = '' and DA4010.DA4_COD = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (2, 14, 15))
        when ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZE1.ZE1_TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO = 7)
    else null end as DESC_RECURSO

from ZE1010 ZE1 (nolock)
    left join ZE4010 ZE4 (nolock)
        on ZE4.D_E_L_E_T_ = ''
        and ZE4.ZE4_FILIAL = ZE1.ZE1_FILIAL
        and ZE4.ZE4_VIAGEM = ZE1.ZE1_NUM

        left join ZE5010 ZE5 (nolock)
            on ZE5.D_E_L_E_T_ = ''
            and ZE5.ZE5_FILIAL = ZE4.ZE4_FILIAL
            and ZE5.ZE5_VIAGEM = ZE4.ZE4_VIAGEM

    left join
    (
        select
            ZG1.ZG1_FILORI as FILIAL,
            ZG1.ZG1_COMPET as COMPETENCIA,
            ZG1.ZG1_CODIGO as INSUMO,
            ZG1.ZG1_TIPO as TIPO,
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
        and RAT_IMPR.FILIAL = ZE1.ZE1_FILIAL
        and RAT_IMPR.COMPETENCIA = ZE1.ZE1_COMPET
        and RAT_IMPR.INSUMO = ZE1.ZE1_COD
where ZE1.D_E_L_E_T_ = ''
