select
    SF2.F2_FILIAL as FILIAL,
    SC6.C6_YOS as NUM,
    sum(cast(coalesce(SF2.F2_VALBRUT, 0) as decimal(14, 2))) as TOTAL
from SF3010 SF3
    inner join SF2010 SF2
        on SF2.F2_SERIE not in ('003', '100')
        and SF2.F2_CLIENTE = SF3.F3_CLIEFOR
        and SF2.F2_LOJA = SF3.F3_LOJA
        and SF2.F2_DOC = SF3.F3_NFISCAL
        and SF2.F2_SERIE = SF3.F3_SERIE
        
        inner join SD2010 SD2
            on SD2.D2_FILIAL = SF2.F2_FILIAL
            and SD2.D2_CLIENTE = SF2.F2_CLIENTE
            and SD2.D2_LOJA = SF2.F2_LOJA
            and SD2.D2_DOC = SF2.F2_DOC
            and SD2.D2_SERIE = SF2.F2_SERIE
            
            inner join SC6010 SC6
                on SC6.C6_FILIAL = SD2.D2_FILIAL
                and SC6.C6_NUM = SD2.D2_PEDIDO
                and SC6.C6_ITEM = SD2.D2_ITEMPV

                inner join ZC2010 ZC2
                    on ZC2.D_E_L_E_T_ = ''
                    and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
                    and ZC2.ZC2_NUM = SC6.C6_YOS
                    and ZC2.ZC2_ITEM = SC6.C6_YITOS
where
        SF3.D_E_L_E_T_ = ''
    and nullif(SF3.F3_DTCANC, '') is not null
    and left(SF3.F3_DTCANC, 6) = '"+cCompt+"' and SF2.F2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by
    SF2.F2_FILIAL,
    SC6.C6_YOS
