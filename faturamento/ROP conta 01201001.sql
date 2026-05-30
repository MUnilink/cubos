    select
        SD2.D2_FILIAL as FILIAL,
        SC6.C6_CC as CC,
        SC6.C6_ITEMCTA as ITEM,
        ZC1.ZC1_NUM as NUM,
        sum(cast(coalesce(SC6.C6_VALOR, 0) as decimal(14, 2))) as TOTAL

    from SD2010 SD2
        inner join SF2010 SF2 (nolock)
            on SF2.F2_FILIAL = SD2.D2_FILIAL
            and SF2.F2_CLIENTE = SD2.D2_CLIENTE
            and SF2.F2_LOJA = SD2.D2_LOJA
            and SF2.F2_DOC = SD2.D2_DOC
            and SF2.F2_SERIE = SD2.D2_SERIE
            and SF2.D_E_L_E_T_= ' '

            left join SA1010 SA1 (nolock)
                on SA1.D_E_L_E_T_= ''
                and SA1.A1_COD = SF2.F2_CLIENTE
                and SA1.A1_LOJA = SF2.F2_LOJA
            
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_= ''
            and SB1.B1_COD = SD2.D2_COD
        inner join SF4010 SF4 (nolock)
            on SF4.D_E_L_E_T_ = ''
            and SF4.F4_CODIGO = SD2.D2_TES
        inner join SX5010 CFOP (nolock)
            on CFOP.D_E_L_E_T_ = ''
            and CFOP.X5_TABELA = '13'
            and CFOP.X5_CHAVE = SD2.D2_CF
        
        inner join SC6010 SC6 (nolock)
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = SD2.D2_FILIAL
            and SC6.C6_NUM = SD2.D2_PEDIDO
            and SC6.C6_ITEM = SD2.D2_ITEMPV
            
            inner join ZC2010 ZC2 (nolock)
                on ZC2.D_E_L_E_T_ = ''
                and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
                and ZC2.ZC2_NUM = SC6.C6_YOS
                and ZC2.ZC2_ITEM = SC6.C6_YITOS

                inner join ZC1010 ZC1 (nolock)
                    on ZC1.D_E_L_E_T_ = ''
                    and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
                    and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    where
            SD2.D_E_L_E_T_ = ' '
        and SD2.D2_TIPO not in ('B', 'D')
        and SD2.D2_SERIE not in ('003', '100')
        and SD2.D2_CCUSTO = '304'
        and SD2.D2_ITEMCC in ('32', '35')
        and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by SD2.D2_FILIAL, ZC1.ZC1_NUM, SC6.C6_CC, SC6.C6_ITEMCTA
union
    select
        RECEITA_TMS.FILIAL,
        RECEITA_TMS.CC,
        RECEITA_TMS.ITEM,
        RECEITA_TMS.VIAGEM as NUM,
        sum(RECEITA_TMS.VALOR) as TOTAL
    from
    (
        select
            SD2.D2_FILIAL as FILIAL,
            coalesce
            (
                DUD.DUD_VIAGEM,
                VGA2.DUD_VIAGEM,
                (
                    select distinct DUD010.DUD_VIAGEM
                    from DUD010 (nolock)
                        inner join SC5010 (nolock)
                            on SC5010.D_E_L_E_T_ = ' '
                            and nullif(SC5010.C5_YVIAGEM, '') = DUD010.DUD_VIAGEM
                    where
                            DUD010.D_E_L_E_T_ = ''
                        and SD2.D2_FILIAL = SC5010.C5_FILIAL
                        and SD2.D2_DOC = SC5010.C5_NOTA
                        and SD2.D2_SERIE = SC5010.C5_SERIE
                        and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                        and SD2.D2_LOJA = SC5010.C5_LOJACLI
                )
            ) as VIAGEM,
            SD2.D2_CCUSTO as CC,
            SD2.D2_ITEMCC as ITEM,
            SD2.D2_DOC as DOC,
            cast(coalesce(SD2.D2_VALBRUT, 0) as decimal(14, 2)) as VALOR

        from SD2010 SD2 (nolock)
            inner join SF2010 SF2 (nolock)
                on SF2.F2_FILIAL = SD2.D2_FILIAL
                and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                and SF2.F2_LOJA = SD2.D2_LOJA
                and SF2.F2_DOC = SD2.D2_DOC
                and SF2.F2_SERIE = SD2.D2_SERIE
                and SF2.D_E_L_E_T_= ' '

                left join SA1010 SA1 (nolock)
                    on SA1.D_E_L_E_T_= ''
                    and SA1.A1_COD = SF2.F2_CLIENTE
                    and SA1.A1_LOJA = SF2.F2_LOJA
                
            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_= ''
                and SB1.B1_COD = SD2.D2_COD
            
                left join SBM010 SBM (nolock)
                    on SBM.D_E_L_E_T_ = ''
                    and SBM.BM_GRUPO = SB1.B1_GRUPO
            
            left join SF4010 SF4 (nolock)
                on SF4.D_E_L_E_T_ = ''
                and SF4.F4_CODIGO = SD2.D2_TES
            left join SX5010 CFOP (nolock)
                on CFOP.D_E_L_E_T_ = ''
                and CFOP.X5_TABELA = '13'
                and CFOP.X5_CHAVE = SD2.D2_CF

                left join
                (
                    select distinct
                        DUD010.DUD_FILIAL,
                        DUD010.DUD_FILORI,
                        DUD010.DUD_VIAGEM,
                        DUD010.DUD_FILDOC,
                        DUD010.DUD_DOC,
                        DUD010.DUD_SERIE,
                        DUD010.DUD_STATUS,
                        DUA010.DUA_FILVTR,
                        DUA010.DUA_NUMVTR,
                        case when DUA010.DUA_CODOCO = 'E004' and concat(DUA010.DUA_FILVTR, DUA010.DUA_NUMVTR) != '' then 'SOC' else 'NOR' end as VGA_NORMAL
                    from DUD010
                        left join DUA010
                            on DUA010.D_E_L_E_T_ = ''
                            and DUA010.DUA_FILIAL = DUD010.DUD_FILIAL
                            and DUA010.DUA_FILORI = DUD010.DUD_FILORI
                            and DUA010.DUA_VIAGEM = DUD010.DUD_VIAGEM
                            and DUA010.DUA_FILDOC = DUD010.DUD_FILDOC
                            and DUA010.DUA_DOC = DUD010.DUD_DOC
                            and DUA010.DUA_SERIE = DUD010.DUD_SERIE
                    where
                            DUD010.D_E_L_E_T_ = ''
                        and DUD010.DUD_SERIE != 'COL'
                ) DUD
                    on DUD.DUD_FILDOC = SD2.D2_FILIAL
                    and DUD.DUD_DOC = SD2.D2_DOC
                    and DUD.DUD_SERIE = SD2.D2_SERIE
                    and DUD.DUD_STATUS != '9'
                    and DUD.VGA_NORMAL != 'SOC'

            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_DOC = SD2.D2_NFORI
                and COMP.D2_SERIE = SD2.D2_SERIORI
                and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                and COMP.D2_LOJA = SD2.D2_LOJA

                left join DUD010 VGA2 (nolock)
                    on VGA2.D_E_L_E_T_ = ''
                    and VGA2.DUD_FILDOC = COMP.D2_FILIAL
                    and VGA2.DUD_DOC = COMP.D2_DOC
                    and VGA2.DUD_SERIE = COMP.D2_SERIE
                    and VGA2.DUD_STATUS != '9'
        where
                SD2.D_E_L_E_T_ = ' '
            and SD2.D2_TIPO not in ('B', 'D')
            and SD2.D2_SERIE not in ('003', '100')
            and
                case
                    when (SB1.B1_COD like '2101000[3-4]' or SB1.B1_COD like '21010006') and trim(CFOP.X5_CHAVE) like '[5-6]933' and SD2.D2_TES like '50[3-4]' then '310101001'
                    when SB1.B1_COD = '21010003' and (trim(CFOP.X5_CHAVE) like '[5-6]933' or trim(CFOP.X5_CHAVE) = '7949') and SD2.D2_TES in ('522', '525') then '310101002'
                    when SB1.B1_COD = '21010001' and SD2.D2_TES in ('501', '502', '506', '507', '510', '519', '520', '524', '526', '534', '535', '536', '554', '558') and
                    (
                        trim(CFOP.X5_CHAVE) like '[5-6]363' or
                        trim(CFOP.X5_CHAVE) like '[5-6]932' or
                        trim(CFOP.X5_CHAVE) like '[5-6]351' or
                        trim(CFOP.X5_CHAVE) like '[5-6]352' or 
                        trim(CFOP.X5_CHAVE) like '[5-6]353' or
                        trim(CFOP.X5_CHAVE) like '[5-6]355' or
                        trim(CFOP.X5_CHAVE) like '[5-6]357' or
                        trim(CFOP.X5_CHAVE) like '[5-6]359' or
                        trim(CFOP.X5_CHAVE) like '[5-6]360'
                    ) then '310101001'
                    when SB1.B1_COD = '21010001' and SD2.D2_TES in ('509', '514', '516', '517', '518', '539') and
                    (
                        trim(CFOP.X5_CHAVE) like '[5-6]363' or
                        trim(CFOP.X5_CHAVE) like '[5-6]932' or
                        trim(CFOP.X5_CHAVE) like '[5-6]351' or
                        trim(CFOP.X5_CHAVE) like '[5-6]352' or
                        trim(CFOP.X5_CHAVE) like '[5-6]353' or
                        trim(CFOP.X5_CHAVE) like '[5-6]355' or
                        trim(CFOP.X5_CHAVE) like '[5-6]357' or
                        trim(CFOP.X5_CHAVE) like '[5-6]359' or
                        trim(CFOP.X5_CHAVE) like '[5-6]360'
                    ) then '310101002'
                else null end
            = '310101001' /* NACIONAL */
            and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    ) RECEITA_TMS
    where RECEITA_TMS.VIAGEM is not null
    group by RECEITA_TMS.FILIAL, RECEITA_TMS.CC, RECEITA_TMS.ITEM, RECEITA_TMS.VIAGEM
