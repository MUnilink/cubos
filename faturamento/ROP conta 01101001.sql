select
    SD2.D2_FILIAL as FILIAL,
    ZC1.ZC1_N UM as NUM,
    SC6.C6_CC as CC,
    sum(cast(coalesce(SD2.D2_VALBRUT, 0) as decimal(14, 2))) as TOTAL

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
    and
        case
            /* LP 610-001 */
            when trim(CFOP.X5_CHAVE) in ('5933', '6933') and SF4.F4_CSTCOF = '08' then trim(SB1.B1_YCTREC4)
            when trim(CFOP.X5_CHAVE) in ('5933', '6933') and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511' then trim(SB1.B1_YCTREC5)
            when trim(CFOP.X5_CHAVE) in ('5933', '6933') and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511' then trim(SB1.B1_YCTREC3)
            /* LP 610-040 */
            when trim(CFOP.X5_CHAVE) = 5359 then trim(SB1.B1_YCTREC1)
            /* LP 610-600 */
            when trim(CFOP.X5_CHAVE) = 5932 and SD2.D2_TES = '509' then trim(SB1.B1_YCTREC2)
            when trim(CFOP.X5_CHAVE) = 5932 and SD2.D2_TES != '509' then trim(SB1.B1_YCTREC1)
            /* LP 610-010 */
            when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES = '520' then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES != '520' then trim(SB1.B1_YCTREC2)
            /* LP 610-020 */
            when trim(CFOP.X5_CHAVE) in (5352, 5353) and (SD2.D2_TES = '507' or SD2.D2_TES = '539') then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) in (5352, 5353) and (SD2.D2_TES != '507' and SD2.D2_TES != '539') then trim(SB1.B1_YCTREC2)
            /* LP 610-030 */
            when trim(CFOP.X5_CHAVE) in (5352, 5351) and SD2.D2_TES in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) in (5352, 5351) and SD2.D2_TES not in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC2)
        else null end
    = '310102001'
    and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by SD2.D2_FILIAL, ZC1.ZC1_NUM, SC6.C6_CC
