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
            ZC1.ZC1_NUM,
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
                    and DUD010.DUD_STATUS != '9'
                    and SD2.D2_FILIAL = SC5010.C5_FILIAL
                    and SD2.D2_DOC = SC5010.C5_NOTA
                    and SD2.D2_SERIE = SC5010.C5_SERIE
                    and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                    and SD2.D2_LOJA = SC5010.C5_LOJACLI
            )
        ) as VIAGEM,
        SD2.D2_CCUSTO as CC,
        SD2.D2_ITEMCC as ITEM,
        SD2.D2_DOC as PEDIDO,
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
        
        left join SC6010 SC6 (nolock)
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = SD2.D2_FILIAL
            and SC6.C6_NUM = SD2.D2_PEDIDO
            and SC6.C6_ITEM = SD2.D2_ITEMPV
            
            left join ZC2010 ZC2 (nolock)
                on ZC2.D_E_L_E_T_ = ''
                and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
                and ZC2.ZC2_NUM = SC6.C6_YOS
                and ZC2.ZC2_ITEM = SC6.C6_YITOS

                left join ZC1010 ZC1 (nolock)
                    on ZC1.D_E_L_E_T_ = ''
                    and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
                    and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
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
                    DUA010.DUA_CODOCO, /* and DUA010.DUA_CODOCO != 'E004' */
                    DUA010.DUA_FILVTR,
                    DUA010.DUA_NUMVTR, /* and DUA010.DUA_NUMVTR = '' */
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
                /* LP 610-001 */
                when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF = '08'
                then trim(SB1.B1_YCTREC4)
                when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511'
                then trim(SB1.B1_YCTREC5)
                when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511'
                then trim(SB1.B1_YCTREC3)
                
                /* LP 610-040 */
                when trim(CFOP.X5_CHAVE) = 5359
                then trim(SB1.B1_YCTREC1)
                
                /* LP 610-600 */
                when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES = '509'
                then trim(SB1.B1_YCTREC2)
                when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES != '509'
                then trim(SB1.B1_YCTREC1)
                
                /* LP 610-010 */
                when trim(CFOP.X5_CHAVE) = '5360' and SD2.D2_TES = '520'
                then trim(SB1.B1_YCTREC1)
                when trim(CFOP.X5_CHAVE) = '5360' and SD2.D2_TES != '520'
                then trim(SB1.B1_YCTREC2)
                
                /* LP 610-020 */
                when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and SD2.D2_TES in ('507', '539', '501', '534')
                then trim(SB1.B1_YCTREC1)
                when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES != '507' and SD2.D2_TES != '539') and SD2.D2_TES not in ('506', '534', '535', '536', '537')
                then trim(SB1.B1_YCTREC2)
                
                /* LP 610-030 */
                when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES in ('506', '534', '535', '536', '537')
                then trim(SB1.B1_YCTREC1)
                when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES not in ('506', '534', '535', '536', '537')
                then trim(SB1.B1_YCTREC2)
                
                /* LP 610-050 */
                when trim(CFOP.X5_CHAVE) = '7949' and SD2.D2_TES = '522'
                then trim(SB1.B1_YCTREC5)
                when trim(CFOP.X5_CHAVE) = '7949' and SD2.D2_TES != '522'
                then trim(SB1.B1_YCTREC4)
                
                /* LP 610-015 */
                when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES = '520'
                then trim(SB1.B1_YCTREC1)
                when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES != '520' and SD2.D2_TES != '558'
                then trim(SB1.B1_YCTREC2)
                
                /* outros */
                when trim(CFOP.X5_CHAVE) = '5357' and SD2.D2_TES in ('509', '516')
                then '310101002'
                when trim(CFOP.X5_CHAVE) like '[5-6]357' and SD2.D2_TES = '510'
                then '310101001'
                when trim(CFOP.X5_CHAVE) = '6355' and SD2.D2_TES = '558'
                then '310101001'
                when trim(CFOP.X5_CHAVE) = '6353' and SD2.D2_TES = '501'
                then '310101001'
            else null end
        = '310101002' /* NACIONAL */
        and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
) RECEITA_TMS
group by
    RECEITA_TMS.FILIAL,
    RECEITA_TMS.CC,
    RECEITA_TMS.ITEM,
    RECEITA_TMS.VIAGEM
