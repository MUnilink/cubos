select

        case
            /* LP 610-001 */
            when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF = '08' then trim(SB1.B1_YCTREC4)
            when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511' then trim(SB1.B1_YCTREC5)
            when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511' then trim(SB1.B1_YCTREC3)
            /* LP 610-040 */
            when trim(CFOP.X5_CHAVE) = 5359 then trim(SB1.B1_YCTREC1)
            /* LP 610-600 */
            when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES = '509' then trim(SB1.B1_YCTREC2)
            when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES != '509' then trim(SB1.B1_YCTREC1)
            /* LP 610-010 */
            when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES = '520' then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES != '520' then trim(SB1.B1_YCTREC2)
            /* LP 610-020 */
            when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES = '507' or SD2.D2_TES = '539') then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES != '507' and SD2.D2_TES != '539') then trim(SB1.B1_YCTREC2)
            /* LP 610-030 */
            when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES not in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC2)
            /*LP 610-050 */
            when trim(CFOP.X5_CHAVE) = 7949 and SD2.D2_TES = '522' then trim(SB1.B1_YCTREC5)
            when trim(CFOP.X5_CHAVE) = 7949 and SD2.D2_TES != '522' then trim(SB1.B1_YCTREC4)
            /* LP 610-015 */
            when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES = '520' then trim(SB1.B1_YCTREC1)
            when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES != '520' then trim(SB1.B1_YCTREC2)
        else null end as CONTAC,
    SD2.D2_EMISSAO,
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
    ) as NUM,
    SD2.D2_CCUSTO as CC,
    SD2.D2_DOC as PEDIDO,
    cast(coalesce(SF2.F2_VALBRUT, 0) as decimal(14, 2)) as TOTAL,
    cast(coalesce(SD2.D2_VALICM, 0) as decimal(14, 2)) as ICMS,
    cast(coalesce(SD2.D2_VALIss, 0) as decimal(14, 2)) as ISS

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
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILDOC = SD2.D2_FILIAL
        and DUD.DUD_DOC = SD2.D2_DOC
        and DUD.DUD_SERIE = SD2.D2_SERIE
        and DUD.DUD_SERIE != 'COL'
        and DUD.DUD_STATUS != '9'
        and exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILIAL = DUD.DUD_FILIAL and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_TIPVIA != '4')

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
where
        SD2.D_E_L_E_T_ = ' '
    and SD2.D2_TIPO not in ('B', 'D')
    and SD2.D2_SERIE not in ('003', '100')
    and trim(SD2.D2_ITEMCC) = '11' and SD2.D2_EMISSAO like '202503%'
