select
    SRD.RD_PERIODO + SRD.RD_MAT + substring(SRV.CONTA, 1, 2) as ID_LANCAMENTO,
    SRD.RD_PERIODO,
    SRV.CONTA,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO
from SRA010 SRA (nolock)
    inner join SRJ010 SRJ (nolock)
        on SRJ.D_E_L_E_T_ = ''
        and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
        and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
    inner join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SRA.RA_CC
    inner join CTD010 CTD (nolock)
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SRA.RA_ITEM
    left join SRD010 SRD (nolock)
        on SRD.D_E_L_E_T_ = ''
        and SRD.RD_FILIAL = SRA.RA_FILIAL
        and SRD.RD_MAT = SRA.RA_MAT
        and SRD.RD_PERIODO > '20211231'

        inner join
        (
            select
                SRV010.RV_FILIAL,
                SRV010.RV_COD,
                case when SRV010.RV_COD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then '02 Salários e Ordenados'
                else
                    case when SRV010.RV_COD in ('029', '111', '113') then '03 Hora Extra'
                    else
                        case when SRV010.RV_COD in ('038', '711', '719', '738', '749', '796') then '04 Benefícios'
                        else
                            case when SRV010.RV_COD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then '05 Encargos Sociais'
                            else '01 N/A Custo'
                            end
                        end
                    end
                end as CONTA
            from SRV010 (nolock)
            where SRV010.D_E_L_E_T_ = ''
        ) SRV
            on SRV.RV_FILIAL = substring(SRD.RD_FILIAL, 1, 4)
            and SRV.RV_COD = SRD.RD_PD/*

    inner join
    (
        select
            SRT010.RT_FILIAL,
            SRT010.RT_VERBA,
            case when SRT010.RT_VERBA in ('845', '846') then '13º Salário'
            else
                case when SRT010.RT_VERBA in ('833', '834', '847', '848') then 'Encargos Sociais (13º e Férias)'
                else
                    case when SRT010.RT_VERBA in ('830', '831', '832') then 'Férias'
                    else 'N/A Custo'
                    end
                end
            end as CONTA
        from SRT010 (nolock)
        where SRT010.D_E_L_E_T_ = ''
    ) SRT
        on SRT.RV_FILIAL = substring(SRD.RD_FILIAL, 1, 4)
        and SRT.RT_COD = SRD.RD_PD*/
where
        SRA.D_E_L_E_T_ = ''
    and (SRA.RA_CC = 304 or SRA.RA_CC = 302 or SRA.RA_CC = 206 or SRA.RA_MAT = '002282')