select
    ZC7.ZC7_CODIGO as ENTIDADE,
    ZC7.ZC7_CC as CC,
    ZC7.ZC7_COMPET as COMPETENCIA,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO) and cast(ZC2.ZC2_TIPO as int) and ZC7.ZC7_ORIGEM = 'SQ3') else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO) and cast(ZC2.ZC2_TIPO as int) and ZC7.ZC7_ORIGEM = 'ST9') else null end as COD_SRJ,
    cast(ZC7.ZC7_HRPAD as numeric(15, 2)) as HORA_PAD,
    cast(ZC7.ZC7_HRPROD as numeric(15, 2)) as HORA_PROD,
    cast(ZC7.ZC7_HRIMPR as numeric(15, 2)) as HORA_IMPR,
    cast(ZC7.ZC7_CUSTO as numeric(15, 2)) as CUSTO_TOTAL

from ZC7010 ZC7
    left join ZC2010 ZC2
        on ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COD

        left join SA1010 SA1
            on SA1.D_E_L_E_T_ = ''
            and SA1.A1_COD = ZC1.ZC1_CODSA1
            and SA1.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA2010 SA2
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD = ZC1.ZC1_DESPA
            and SA2.A2_LOJA = ZC1.ZC1_LJDESP
        left join SED010 SED
            on SED.D_E_L_E_T_ = ''
            and SED.ED_CODIGO = ZC1.ZC1_NATURE
        left join SE4010 SE4
            on SE4.D_E_L_E_T_ = ''
            and SE4.E4_CODIGO = ZC1.ZC1_COND
        left join DA0010 DA0
            on DA0.D_E_L_E_T_ = ''
            and DA0.DA0_CODTAB = ZC1.ZC1_TABPRC
    
    left join SB1010 SB1
        on SB1.D_E_L_E_T_ = ' '
        and SB1.B1_FILIAL = '      '
        and SB1.B1_COD = ZC2.ZC2_COD
        
    left join ZC3010 ZC3
        on ZC3.D_E_L_E_T_ = ''
        and ZC3.ZC3_FILIAL = ZC2.ZC2_FILIAL
        and ZC3.ZC3_NUM = ZC2.ZC2_NUM
        and ZC3.ZC3_ITEM = ZC2.ZC2_ITEM
    
        left join SC5010 SC5
            on SC5.D_E_L_E_T_ = ''
            and SC5.C5_FILIAL = ZC3.ZC3_FILIAL
            and SC5.C5_NUM = ZC3.ZC3_PEDIDO
            and SC5.C5_YOS = ZC3.ZC3_NUM

            left join SC6010 SC6
                on SC6.D_E_L_E_T_ = ''
                and SC6.C6_FILIAL = SC5.C5_FILIAL
                and SC6.C6_NUM = SC5.C5_NUM

            left join SD2010 SD2
                on SD2.D_E_L_E_T_ = ''
                and SD2.D2_FILIAL = SC5.C5_FILIAL
                and SD2.D2_PEDIDO = SC5.C5_NUM

                left join SF2010 SF2
                    on SF2.D_E_L_E_T_= ' '
                    and SF2.F2_FILIAL = SD2.D2_FILIAL
                    and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                    and SF2.F2_LOJA = SD2.D2_LOJA
                    and SF2.F2_DOC = SD2.D2_DOC
                    and SF2.F2_SERIE = SD2.D2_SERIE
            
            left join SAH010 SAH
                on SAH.D_E_L_E_T_ = ''
                and SAH.AH_UNIMED = SD2.D2_UM
where
        concat(ZC7.ZC7_COMPET, '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC2.D_E_L_E_T_ = ''
