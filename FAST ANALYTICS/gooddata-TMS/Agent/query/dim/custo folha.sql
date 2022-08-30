select distinct
    SRA.RA_FILIAL + VERBAS.PERIODO + VERBAS.MATRICULA + substring(VERBAS.CONTA, 1, 2) as ID_LANCAMENTO,
    SRA.RA_FILIAL,
    VERBAS.PERIODO,
    VERBAS.MATRICULA,

    substring(VERBAS.CONTA, 4, len(VERBAS.CONTA)) as CONTA,

    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
    trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,

    sum(VERBAS.VALOR) as VALOR

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
    inner join
    (
        select
            isnull(SRD010.RD_FILIAL, SRT010.RT_FILIAL) as FILIAL,
            isnull(SRD010.RD_PERIODO, SRT010.RT_DATACAL) as PERIODO,
            isnull(SRD010.RD_MAT, SRT010.RT_MAT) as MATRICULA,
            SRV010.RV_COD, /* VER ELIMINAÇÃO DE VERBAS INDIVIDUAIS, OQ PERMITIRIA USAR DISTINCT NESTA TABELA E VINCULAR AO EMPREGADO SEM DUPLICATAS */
            isnull(SRD010.RD_PD, SRT010.RT_VERBA) as EVENTO,
            
            case when SRD010.RD_PD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then '02 Salários e Ordenados'
            else
                case when SRD010.RD_PD in ('029', '111', '113') then '03 Hora Extra'
                else
                    case when SRD010.RD_PD in ('038', '711', '719', '738', '749', '796') then '04 Benefícios'
                    else
                        case when SRD010.RD_PD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then '05 Encargos Sociais'
                        else
                            case when SRT010.RT_VERBA in ('845', '846') then '06 13º Salário'
                            else
                                case when SRT010.RT_VERBA in ('833', '834', '847', '848') then '07 Encargos Sociais (13º e Férias)'
                                else
                                    case when SRT010.RT_VERBA in ('830', '831', '832') then '08 Férias'
                                    else '01 N/A Custo'
                                    end
                                end
                            end
                        end
                    end
                end
            end as CONTA,
            
            isnull(SRD010.RD_VALOR, SRT010.RT_VALOR) as VALOR
        from SRV010 (nolock)
            left join SRD010 (nolock)
                on SRD010.D_E_L_E_T_ = ''
                and SRV010.RV_FILIAL = substring(SRD010.RD_FILIAL, 1, 4)
                and SRV010.RV_COD = SRD010.RD_PD
                and SRD010.RD_PERIODO > '20211231'
            left join SRT010 (nolock)
                on SRT010.D_E_L_E_T_ = ''
                and SRV010.RV_FILIAL = substring(SRT010.RT_FILIAL, 1, 4)
                and SRV010.RV_COD = SRT010.RT_VERBA
                and SRT010.RT_DATACAL > '20211231'
        where
                SRV010.D_E_L_E_T_ = ''
            and SRV010.RV_COD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783', '029', '111', '113', '038', '711', '719', '738', '749', '796', '739', '759', '760', '800', '817', '950', '955', '960', '961', '962', '845', '846', '833', '834', '847', '848', '830', '831', '832')
    ) VERBAS
        on VERBAS.FILIAL = SRA.RA_FILIAL
        and VERBAS.MATRICULA = SRA.RA_MAT
        and VERBAS.CONTA != '01 N/A Custo'
    inner join DTQ010 DTQ (nolock)
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILORI = VERBAS.FILIAL
        and substring(DTQ.DTQ_DATENC, 1, 6) = VERBAS.PERIODO
where
        SRA.D_E_L_E_T_ = ''
    and (SRA.RA_CC = 304 or SRA.RA_CC = 302 or SRA.RA_CC = 206 or SRA.RA_MAT = '002282')
group by
    SRA.RA_FILIAL,
    VERBAS.PERIODO,
    VERBAS.MATRICULA,
    VERBAS.CONTA,
    CTD.CTD_DESC01,
    CTT.CTT_DESC01,
    SRA.RA_NOME,
	SRJ.RJ_DESC
