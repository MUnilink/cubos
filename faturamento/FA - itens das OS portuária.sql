select
    convert(datetime, getdate(), 113) as ULTIMA_CARGA,
    'P |01|01' AS BK_EMPRESA,
    OS.BK_FILIAL,
    OS.BK_CLIENTE,
    OS.BK_FORNECEDOR,
    OS.ID_PRODUTO,
    OS.ID_OSPORTUARIA,
    PV.ID_PEDIDODEVENDA,
    PV.ID_NFS,
    null as ID_NFE,
    null as ID_PEDIDO,
    OS.BK_NAT_FINANCEIRA,
    OS.BK_CONDICAO_DE_PAGAMENTO,
    PV.BK_ITEM_CONTABIL,
    PV.BK_CENTRO_DE_CUSTO,
    OS.ID_TABELA_PRECO,
    OS.ID_TIPO_ITEM,
    OS.COD_SB1,
    OS.COD_DA3,
    OS.COD_SRJ,
    OS.COD_ZA7,
    OS.COD_SE1,
    OS.USUARIO,

    OS.INSUMO,
    OS.DT_INIOS,
    OS.DT_FIMOS,
    OS.COMPETENCIA,
    OS.BK_UNIDADE_DE_MEDIDA,
    
    cast(sum(OS.QTD_PREV) as numeric(15, 2)) as QTD_PREV,
    cast(sum(OS.QTD_REAL) as numeric(15, 2)) as QTD_REAL,
    cast(sum(OS.VAL_PREV) as numeric(15, 2)) as VAL_PREV,
    cast(sum(OS.VAL_REAL) as numeric(15, 2)) as VAL_REAL,
    cast(sum(OS.VAL_PREV_TOTAL) as numeric(15, 2)) as VAL_PREV_TOTAL,
    cast(sum(OS.VAL_REAL_TOTAL) as numeric(15, 2)) as VAL_REAL_TOTAL,
    cast(sum(OS.VALOR_TOTAL) as numeric(15, 2)) as VL_PROD,
    sum(OS.RATEIO_IMP * OS.VALOR_TOTAL) as VL_IMPR,
    cast(sum(OS.QTD_RECURSO) as numeric(15, 2)) as QTD_RECURSO,
    cast(sum(OS.HORAS_APONT) as numeric(15, 2)) as HORAS_APONT,
	cast(sum(OS.HORAS_TOTAIS) as numeric(15, 2)) as HORAS_TOTAIS,
    null as ITEM_RATEIO,
    null as PERC_RATEIO,
    sum(PV.QTD) as QTD_RATEIO

from
    (
        select
            CASE WHEN ZC1010.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1010.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
            'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED010.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED010.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
            'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4010.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4010.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
            'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1010.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1010.A1_COD, ' '))+RTRIM(COALESCE(SA1010.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
            'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2010.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2010.A2_COD, ' '))+RTRIM(COALESCE(SA2010.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
            'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1010.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC1010.ZC1_MERCAD, ' ')), ' '), '|') as ID_PRODUTO,
            'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH010.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1010.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
            
            concat(trim(ZC1010.ZC1_FILIAL), trim(ZC1010.ZC1_NUM)) as ID_OSPORTUARIA,
            concat(trim(DA0010.DA0_FILIAL), trim(DA0010.DA0_CODTAB)) as ID_TABELA_PRECO,
            cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
            case when cast(ZC2.ZC2_TIPO as int) = 1 then 'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1010.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC2.ZC2_COD, ' ')), ' '), '|') else null end as COD_SB1,
            case when cast(ZC2.ZC2_TIPO as int) = 3 then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13)) else null end as COD_DA3,
            case when cast(ZC2.ZC2_TIPO as int) = 2 then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14)) else null end as COD_SRJ,

            trim(ZC2.ZC2_COD) as INSUMO,
            trim(ZC2.ZC2_ITEM) as ITEM,
            cast(ZC1010.ZC1_EMISSA as date) as DT_INIOS,
            cast(case when ZC1010.ZC1_STATUS = 1 then null when ZC1010.ZC1_DTENCE = '' then ZC1010.ZC1_DTFIM else ZC1010.ZC1_DTENCE end as date) as DT_FIMOS,
            cast(ZC2.ZC2_DTFIM as date) as DATA_APP,
            concat(left(isnull(nullif(ZC2.ZC2_COMPET, ''), ZC1010.ZC1_DTFIM), 6), '01') as COMPETENCIA,
            
            case when ZC2.ZC2_QTDPRV > 99999999 then 99999999 else ZC2.ZC2_QTDPRV end as QTD_PREV,
            case when ZC2.ZC2_QTDREA > 99999999 then 99999999 else ZC2.ZC2_QTDREA end as QTD_REAL,
            case when ZC2.ZC2_VLUPRV > 99999999 then 99999999 else ZC2.ZC2_VLUPRV end as VAL_PREV,
            case when ZC2.ZC2_VLUREA > 99999999 then 99999999 else ZC2.ZC2_VLUREA end as VAL_REAL,
            cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
            cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
            case when ZC2.ZC2_TOTAL > 99999999 then 99999999 else ZC2.ZC2_TOTAL end as VALOR_TOTAL,
            ZC2.ZC2_QTDREC as QTD_RECURSO,
            upper(trim(ZC2.ZC2_NMUSU)) as USUARIO,
            null as COD_ZA7,
            null as COD_SE1,
            
            case when cast(ZC2.ZC2_TIPO as int) in (2, 3) then case when isdate(ZC2.ZC2_HRINI) + isdate(ZC2.ZC2_HRFIM) = 2 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end else 0.0 end as HORAS_APONT,
            case when cast(ZC2.ZC2_TIPO as int) in (2, 3) then case when isdate(ZC2.ZC2_HRINI) + isdate(ZC2.ZC2_HRFIM) = 2 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end else 0.0 end as HORAS_TOTAIS,

            cast(ZC1010.ZC1_DTENCE as date) as DT_ENCOS,
            case ZC1010.ZC1_TIPOP
                when 1 then upper('Cabotagem')
                when 2 then upper('Importacao')
                when 3 then upper('Exportacao')
                when 4 then upper('Interna')
            else 'OUTROS' end as TIPO_OP,

            case ZC1010.ZC1_STATUS
                when 1 then 'ABERTA'
                when 2 then 'SOLICITADO CANCELAMENTO'
                when 3 then 'CANCELADA'
                when 5 then 'CORTESIA'
                when 6 then 'ENCERRADA'
                else 'OUTROS'
            end as STATUS_OS,

            case ZC1010.ZC1_STATU2
                when 1 then 'PENDENTE'
                when 2 then 'PARCIAL'
                when 3 then 'FINALIZADO'
                else 'OUTROS'
            end as STATUS_FATURAMENTO,
                        
            cast(
                case
                    when cast(ZC2.ZC2_TIPO as int) = 2 then
                    (
                        select
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
                            ) as VL_RIMP
                        from ZG1010 ZG1 (nolock)
                        where
                                ZG1.ZG1_TIPO = 2
                            and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                            and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                            and ZG1.D_E_L_E_T_ = ''
                    )
                    when cast(ZC2.ZC2_TIPO as int) = 14 then
                    (
                        select
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
                            ) as VL_RIMP
                        from ZG1010 ZG1 (nolock)
                        where
                                ZG1.ZG1_TIPO = 14
                            and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                            and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                            and ZG1.D_E_L_E_T_ = ''
                    )
                else 0.0 end as numeric(15, 2)
            ) as RATEIO_IMP
        
        from ZC2010 ZC2 (nolock)
            left join ZC1010 (nolock)
                on ZC1010.D_E_L_E_T_ = ''
                and ZC1010.ZC1_FILIAL = ZC2.ZC2_FILIAL
                and ZC1010.ZC1_NUM = ZC2.ZC2_NUM
            left join SA1010
                on SA1010.D_E_L_E_T_ = ''
                and SA1010.A1_COD = ZC1010.ZC1_CODSA1
                and SA1010.A1_LOJA = ZC1010.ZC1_LOJSA1
            left join SA2010
                on SA2010.D_E_L_E_T_ = ''
                and SA2010.A2_COD = ZC1010.ZC1_DESPA
                and SA2010.A2_LOJA = ZC1010.ZC1_LJDESP
            left join SED010
                on SED010.D_E_L_E_T_ = ''
                and SED010.ED_CODIGO = ZC1010.ZC1_NATURE
            left join SE4010
                on SE4010.D_E_L_E_T_ = ''
                and SE4010.E4_CODIGO = ZC1010.ZC1_COND
            left join DA0010
                on DA0010.D_E_L_E_T_ = ''
                and DA0010.DA0_CODTAB = ZC1010.ZC1_TABPRC
            
            left join SB1010
                on SB1010.D_E_L_E_T_ = ''
                and SB1010.B1_FILIAL = ''
                and SB1010.B1_COD = ZC2.ZC2_COD

                left join SAH010
                    on SAH010.D_E_L_E_T_ = ''
                    and SAH010.AH_UNIMED = SB1010.B1_UM
        
        where ZC2.D_E_L_E_T_ = '' and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 2, 14, 15, 16)
    ) OS
    
        left join
        (
            select distinct
                SC6010.C6_FILIAL as FILIAL,
                SC6010.C6_YOS as OS,
                concat(trim(SC6010.C6_FILIAL), trim(SC6010.C6_NUM)) as ID_PEDIDODEVENDA,
                concat('SF2', trim(SF2010.F2_FILIAL), trim(SF2010.F2_CLIENTE), trim(SF2010.F2_LOJA), trim(SF2010.F2_DOC), trim(SF2010.F2_SERIE)) as ID_NFS,
                'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|') as BK_ITEM_CONTABIL,
                'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_CC, ' ')), ' '), '|') as BK_CENTRO_DE_CUSTO,
                SC6010.C6_CC as CC,
                1 as QTD
            from SC6010
                left join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
                            
                    left join SF2010
                        on SF2010.D_E_L_E_T_= ' '
                        and SF2010.F2_FILIAL = SD2010.D2_FILIAL
                        and SF2010.F2_CLIENTE = SD2010.D2_CLIENTE
                        and SF2010.F2_LOJA = SD2010.D2_LOJA
                        and SF2010.F2_DOC = SD2010.D2_DOC
                        and SF2010.F2_SERIE = SD2010.D2_SERIE
                
                left join CTD010
                    on CTD010.CTD_FILIAL = ''
                    and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                    and CTD010.D_E_L_E_T_ = ''
                left join CTT010
                    on CTT010.D_E_L_E_T_ = ''
                    and CTT010.CTT_FILIAL = substring(SC6010.C6_FILIAL, 1, 4)
                    and CTT010.CTT_CUSTO = SC6010.C6_CC
            where
                    SC6010.D_E_L_E_T_ = ''
        ) PV on concat(PV.FILIAL, PV.OS) = OS.ID_OSPORTUARIA
group by
    OS.BK_FILIAL,
    OS.BK_CLIENTE,
    OS.BK_FORNECEDOR,
    OS.ID_PRODUTO,
    OS.ID_OSPORTUARIA,
    PV.ID_PEDIDODEVENDA,
    PV.ID_NFS,
    OS.BK_NAT_FINANCEIRA,
    OS.BK_CONDICAO_DE_PAGAMENTO,
    PV.BK_ITEM_CONTABIL,
    PV.BK_CENTRO_DE_CUSTO,
    OS.ID_TABELA_PRECO,
    OS.ID_TIPO_ITEM,
    OS.COD_SB1,
    OS.COD_DA3,
    OS.COD_SRJ,
    OS.COD_ZA7,
    OS.COD_SE1,
    OS.INSUMO,
    OS.DT_INIOS,
    OS.DT_FIMOS,
    OS.COMPETENCIA,
    OS.BK_UNIDADE_DE_MEDIDA,
    OS.USUARIO
