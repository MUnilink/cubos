select
    SRD.RD_PERIODO + SRD.RD_MAT + SRV.CONTA as ID_LANCAMENTO,
    SRV.CONTA
from SRD010 SRD (nolock)
    inner join
    (
        select
            SRV.RV_FILIAL,
            SRV.RV_COD,
            case when SRV010.RV_COD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then 'Salários e Ordenados'
            else
                case when SRV010.RV_COD in ('029', '111', '113') then 'Hora Extra'
                else
                    case when SRV010.RV_COD in ('038', '711', '719', '738', '749', '796') then 'Benefícios'
                    else
                        case when SRV010.RV_COD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then 'Encargos Sociais'
                        else 'N/A Custo'
                        end
                    end
                end
            end as CONTA
        from SRV010 (nolock)
        when SRV010.D_E_L_E_T_ = ''
    ) SRV
    on SRV.RV_FILIAL = substring(SRD.RD_FILIAL, 1, 4)
    and SRV.RV_COD = SRD.RD_PD
where
        SRD.D_E_L_E_T_ = ''
