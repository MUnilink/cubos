    select /*HISTÓRICO COPARTICIPAÇÃO*/
        trim(SRA.RA_FILIAL) as FILIAL,

        case SRA.RA_FILIAL
            when '010101' then 'MATRIZ'
            when '010102' then 'FILIAL'
        end as NOME_FILIAL,

        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

        datediff(year, SRA.RA_NASC, RHP.RHP_DTOCOR) as IDADE,

        RHP.RHP_COMPPG as PERIODO,

        case when RHP.RHP_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHP.RHP_PD in (88) then 'UNIMED'
            else
                case when RHP.RHP_PD in (428, 429) then 'REDE SAUDE'
                else
                    case when RHP.RHP_PD in (569, 570, 574, 575, 576, 577, 711, 78) then 'ODONTO'
                    else
                        case when RHP.RHP_PD in (624, 625) then 'COPARTICIPACAO'
                        else 'OUTROS'
                        end
                    end
                end
            end
        end as TIPO_VERBA,

        trim(isnull(SRV.RV_DESC, '-')) as NOMEVERBA,

        case RHP.RHP_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then RHM.RHM_NOME
            else null
        end as USUARIO,

        case RHP.RHP_ORIGEM
            when 1 then 'TITULAR'
            when 2 then 'DEPENDENTE'
            when 3 then 'AGREGADO'
            else 'OUTROS'
        end as TIPO_USUARIO,

        case RHP.RHP_ORIGEM
            when 1 then trim(SRA.RA_SEXO)
            when 2 then trim(DEP.RB_SEXO)
            when 3 then trim(RHM.RHM_YSEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHP.RHP_ORIGEM
            when 1 then convert(date, SRA.RA_NASC, 103)
            when 2 then convert(date, DEP.RB_DTNASC, 103)
            when 3 then convert(date, RHM.RHM_DTNASC, 103)
            else null
        end as NASCIMENTO,

        case RHP.RHP_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHP.RHP_DTOCOR)
            when 2 then datediff(year, DEP.RB_DTNASC, RHP.RHP_DTOCOR)
            when 3 then datediff(year, RHM.RHM_DTNASC, RHP.RHP_DTOCOR)
            else null
        end as IDADE_USUARIO,

        case when RHP.RHP_ORIGEM = 1 then RHP.RHP_VLRFUN else 0.0 end as VALOR_FUNC,
        case when RHP.RHP_ORIGEM != 1 then RHP.RHP_VLRFUN else 0.0 end as VALOR_DEPAGG,

        trim(DEP.RB_NOME) DEPENDENTE,
        convert(date, DEP.RB_DTNASC, 103) as DEP_NASC,
        trim(DEP.RB_SEXO) as DEP_SEXO,
        datediff(year, DEP.RB_DTNASC, RHP.RHP_DTOCOR) as DEP_IDADE,
        DEP.RB_TPDEP as DEP_ES,
        DEP.RB_TIPIR as DEP_IR,
        DEP.RB_TIPSF as DEP_SF,

        trim(RHM.RHM_NOME) as AGG_NOME,
        convert(date, RHM.RHM_DTNASC, 103) as AGG_NASC,
        trim(RHM.RHM_YSEXO) as AGG_SEXO,
        datediff(year, RHM.RHM_DTNASC, RHP.RHP_DTOCOR) as AGG_IDADE,
        RHM.RHM_TPCALC as AGG_ES,
        
        RHP.RHP_VLRFUN as VALOR_FUNC_TOTAL,
        RHP.RHP_VLREMP as VALOR_EMPRESA,
        RHP.RHP_VLREMP + RHP.RHP_VLRFUN as VALOR_FATURAMENTO,

        RHP.RHP_PD as VERBA,
        RHP.RHP_TPLAN as TIPO_LANCAMENTO,
        null as TIPO_PLANO,
        null as PLANO,
        RHP.RHP_ORIGEM as ORIGEM,
        RHP.RHP_CODIGO as COD_DEPAGG

    from RHP010 RHP (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = RHP.RHP_PD
        left join RHK010 RHK (nolock)
            on RHK.D_E_L_E_T_ = ''
            and RHK.RHK_FILIAL = RHP.RHP_FILIAL
            and RHK.RHK_MAT = RHP.RHP_MAT
            and RHK.RHK_TPFORN = RHP.RHP_TPFORN
            and RHK.RHK_CODFOR = RHP.RHP_CODFOR

            left join SRA010 SRA (nolock)
                on SRA.D_E_L_E_T_ = ''
                and SRA.RA_FILIAL = RHP.RHP_FILIAL
                and SRA.RA_MAT = RHP.RHP_MAT

                inner join SQB010 SQB (nolock)
                    on SQB.D_E_L_E_T_ = ''
                    and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SQB.QB_DEPTO = SRA.RA_DEPTO
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

        left join RHL010 RHL (nolock)
            on RHL.D_E_L_E_T_ = ''
            and RHL.RHL_FILIAL = RHP.RHP_FILIAL
            and RHL.RHL_MAT = RHP.RHP_MAT
            and RHL.RHL_CODIGO = RHP.RHP_CODIGO
            and RHL.RHL_TPFORN = RHP.RHP_TPFORN
            and RHL.RHL_CODFOR = RHP.RHP_CODFOR

            left join SRB010 DEP (nolock)
                on DEP.D_E_L_E_T_ = ''
                and DEP.RB_FILIAL = RHL.RHL_FILIAL
                and DEP.RB_MAT = RHL.RHL_MAT
                and DEP.RB_COD = RHL.RHL_CODIGO
        
        left join RHM010 RHM (nolock)
            on RHM.D_E_L_E_T_ = ''
            and RHM.RHM_FILIAL = RHP.RHP_FILIAL
            and RHM.RHM_MAT = RHP.RHP_MAT
            and RHM.RHM_CODIGO = RHP.RHP_CODIGO
            and RHM.RHM_TPFORN = RHP.RHP_TPFORN
            and RHM.RHM_CODFOR = RHP.RHP_CODFOR
    where
            RHP.D_E_L_E_T_ = ''
        and year(RHP.RHP_DTOCOR) > 2021
union
    select /* COPARTICIPAÇÃO */
        trim(SRA.RA_FILIAL) as FILIAL,

        case SRA.RA_FILIAL
            when '010101' then 'MATRIZ'
            when '010102' then 'FILIAL'
        end as NOME_FILIAL,

        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        datediff(year, SRA.RA_NASC, RHO.RHO_DTOCOR) as IDADE,

        RHO.RHO_COMPPG as PERIODO,

        case when RHO.RHO_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHO.RHO_PD in (88) then 'UNIMED'
            else
                case when RHO.RHO_PD in (428, 429) then 'REDE SAUDE'
                else
                    case when RHO.RHO_PD in (569, 570, 574, 575, 576, 577, 711, 78) then 'ODONTO'
                    else
                        case when RHO.RHO_PD in (624, 625) then 'COPARTICIPACAO'
                        else 'OUTROS'
                        end
                    end
                end
            end
        end as TIPO_VERBA,

        trim(isnull(SRV.RV_DESC, '-')) as NOMEVERBA,

        case RHO.RHO_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then RHM.RHM_NOME
            else null
        end as USUARIO,

        case RHO.RHO_ORIGEM
            when 1 then 'TITULAR'
            when 2 then 'DEPENDENTE'
            when 3 then 'AGREGADO'
            else 'OUTROS'
        end as TIPO_USUARIO,

        case RHO.RHO_ORIGEM
            when 1 then trim(SRA.RA_SEXO)
            when 2 then trim(DEP.RB_SEXO)
            when 3 then trim(RHM.RHM_YSEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHO.RHO_ORIGEM
            when 1 then convert(date, SRA.RA_NASC, 103)
            when 2 then convert(date, DEP.RB_DTNASC, 103)
            when 3 then convert(date, RHM.RHM_DTNASC, 103)
            else null
        end as NASCIMENTO,

        case RHO.RHO_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHO.RHO_DTOCOR)
            when 2 then datediff(year, DEP.RB_DTNASC, RHO.RHO_DTOCOR)
            when 3 then datediff(year, RHM.RHM_DTNASC, RHO.RHO_DTOCOR)
            else null
        end as IDADE_USUARIO,

        case when RHO.RHO_ORIGEM = 1 then RHO.RHO_VLRFUN else 0.0 end as VALOR_FUNC,
        case when RHO.RHO_ORIGEM != 1 then RHO.RHO_VLRFUN else 0.0 end as VALOR_DEPAGG,

        trim(DEP.RB_NOME) DEPENDENTE,
        convert(date, DEP.RB_DTNASC, 103) as DEP_NASC,
        trim(DEP.RB_SEXO) as DEP_SEXO,
        datediff(year, DEP.RB_DTNASC, RHO.RHO_DTOCOR) as DEP_IDADE,
        DEP.RB_TPDEP as DEP_ES,
        DEP.RB_TIPIR as DEP_IR,
        DEP.RB_TIPSF as DEP_SF,

        trim(RHM.RHM_NOME) as AGG_NOME,
        convert(date, RHM.RHM_DTNASC, 103) as AGG_NASC,
        trim(RHM.RHM_YSEXO) as AGG_SEXO,
        datediff(year, RHM.RHM_DTNASC, RHO.RHO_DTOCOR) as AGG_IDADE,
        RHM.RHM_TPCALC as AGG_ES,
        
        RHO.RHO_VLRFUN as VALOR_FUNC_TOTAL,
        RHO.RHO_VLREMP as VALOR_EMPRESA,
        RHO.RHO_VLREMP + RHO.RHO_VLRFUN as VALOR_FATURAMENTO,

        RHO.RHO_PD as VERBA,
        RHO.RHO_TPLAN as TIPO_LANCAMENTO,
        null as TIPO_PLANO,
        null as PLANO,
        RHO.RHO_ORIGEM as ORIGEM,
        RHO.RHO_CODIGO as COD_DEPAGG

    from RHO010 RHO (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = RHO.RHO_PD
        left join RHK010 RHK (nolock)
            on RHK.D_E_L_E_T_ = ''
            and RHK.RHK_FILIAL = RHO.RHO_FILIAL
            and RHK.RHK_MAT = RHO.RHO_MAT
            and RHK.RHK_TPFORN = RHO.RHO_TPFORN
            and RHK.RHK_CODFOR = RHO.RHO_CODFOR

            left join SRA010 SRA (nolock)
                on SRA.D_E_L_E_T_ = ''
                and SRA.RA_FILIAL = RHO.RHO_FILIAL
                and SRA.RA_MAT = RHO.RHO_MAT

                inner join SQB010 SQB (nolock)
                    on SQB.D_E_L_E_T_ = ''
                    and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SQB.QB_DEPTO = SRA.RA_DEPTO
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

        left join RHL010 RHL (nolock)
            on RHL.D_E_L_E_T_ = ''
            and RHL.RHL_FILIAL = RHO.RHO_FILIAL
            and RHL.RHL_MAT = RHO.RHO_MAT
            and RHL.RHL_CODIGO = RHO.RHO_CODIGO
            and RHL.RHL_TPFORN = RHO.RHO_TPFORN
            and RHL.RHL_CODFOR = RHO.RHO_CODFOR

            left join SRB010 DEP (nolock)
                on DEP.D_E_L_E_T_ = ''
                and DEP.RB_FILIAL = RHL.RHL_FILIAL
                and DEP.RB_MAT = RHL.RHL_MAT
                and DEP.RB_COD = RHL.RHL_CODIGO
        
        left join RHM010 RHM (nolock)
            on RHM.D_E_L_E_T_ = ''
            and RHM.RHM_FILIAL = RHO.RHO_FILIAL
            and RHM.RHM_MAT = RHO.RHO_MAT
            and RHM.RHM_CODIGO = RHO.RHO_CODIGO
            and RHM.RHM_TPFORN = RHO.RHO_TPFORN
            and RHM.RHM_CODFOR = RHO.RHO_CODFOR
    where
            RHO.D_E_L_E_T_ = ''
union
    select /* PLANO DE SAÚDE E ODONTO */
        trim(SRA.RA_FILIAL) as FILIAL,

        case SRA.RA_FILIAL
            when '010101' then 'MATRIZ'
            when '010102' then 'FILIAL'
        end as NOME_FILIAL,

        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        datediff(year, SRA.RA_NASC, RHR.RHR_DATA) as IDADE,
        
        RHR.RHR_COMPPG as PERIODO,

        case when RHR.RHR_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHR.RHR_PD in (88) then 'UNIMED'
            else
                case when RHR.RHR_PD in (428, 429) then 'REDE SAUDE'
                else
                    case when RHR.RHR_PD in (569, 570, 574, 575, 576, 577, 711, 78) then 'ODONTO'
                    else
                        case when RHR.RHR_PD in (624, 625) then 'COPARTICIPACAO'
                        else 'OUTROS'
                        end
                    end
                end
            end
        end as TIPO_VERBA,

        trim(isnull(SRV.RV_DESC, '-')) as NOMEVERBA,

        case RHR.RHR_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then RHM.RHM_NOME
            else 'OUTROS'
        end as USUARIO,

        case RHR.RHR_ORIGEM
            when 1 then 'TITULAR'
            when 2 then 'DEPENDENTE'
            when 3 then 'AGREGADO'
            else 'OUTROS'
        end as TIPO_USUARIO,

        case RHR.RHR_ORIGEM
            when 1 then trim(SRA.RA_SEXO)
            when 2 then trim(DEP.RB_SEXO)
            when 3 then trim(RHM.RHM_YSEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHR.RHR_ORIGEM
            when 1 then convert(date, SRA.RA_NASC, 103)
            when 2 then convert(date, DEP.RB_DTNASC, 103)
            when 3 then convert(date, RHM.RHM_DTNASC, 103)
            else null
        end as NASCIMENTO,

        case RHR.RHR_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHR.RHR_DATA)
            when 2 then datediff(year, DEP.RB_DTNASC, RHR.RHR_DATA)
            when 3 then datediff(year, RHM.RHM_DTNASC, RHR.RHR_DATA)
            else null
        end as IDADE_USUARIO,

        case when RHR.RHR_ORIGEM = 1 then RHR.RHR_VLRFUN else 0.0 end as VALOR_FUNC,
        case when RHR.RHR_ORIGEM != 1 then RHR.RHR_VLRFUN else 0.0 end as VALOR_DEPAGG,

        trim(DEP.RB_NOME) DEPENDENTE,
        convert(date, DEP.RB_DTNASC, 103) as DEP_NASC,
        trim(DEP.RB_SEXO) as DEP_SEXO,
        datediff(year, DEP.RB_DTNASC, RHR.RHR_DATA) as DEP_IDADE,
        DEP.RB_TPDEP as DEP_ES,
        DEP.RB_TIPIR as DEP_IR,
        DEP.RB_TIPSF as DEP_SF,

        trim(RHM.RHM_NOME) as AGG_NOME,
        convert(date, RHM.RHM_DTNASC, 103) as AGG_NASC,
        trim(RHM.RHM_YSEXO) as AGG_SEXO,
        datediff(year, RHM.RHM_DTNASC, RHR.RHR_DATA) as AGG_IDADE,
        RHM.RHM_TPCALC as AGG_ES,
        
        RHR.RHR_VLRFUN as VALOR_FUNC_TOTAL,
        RHR.RHR_VLREMP as VALOR_EMPRESA,
        RHR.RHR_VLREMP + RHR.RHR_VLRFUN as VALOR_FATURAMENTO,

        RHR.RHR_PD as VERBA,
        RHR.RHR_TPLAN as TIPO_LANCAMENTO,
        RHR.RHR_TPPLAN as TIPO_PLANO,
        RHR.RHR_PLANO as PLANO,
        RHR.RHR_ORIGEM as ORIGEM,
        RHR.RHR_CODIGO as COD_DEPAGG

    from RHR010 RHR (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = RHR.RHR_PD
        left join RHK010 RHK (nolock)
            on RHK.D_E_L_E_T_ = ''
            and RHK.RHK_FILIAL = RHR.RHR_FILIAL
            and RHK.RHK_MAT = RHR.RHR_MAT
            and RHK.RHK_TPFORN = RHR.RHR_TPFORN
            and RHK.RHK_CODFOR = RHR.RHR_CODFOR

            left join SRA010 SRA (nolock)
                on SRA.D_E_L_E_T_ = ''
                and SRA.RA_FILIAL = RHR.RHR_FILIAL
                and SRA.RA_MAT = RHR.RHR_MAT

                inner join SQB010 SQB (nolock)
                    on SQB.D_E_L_E_T_ = ''
                    and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SQB.QB_DEPTO = SRA.RA_DEPTO
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

        left join RHL010 RHL (nolock)
            on RHL.D_E_L_E_T_ = ''
            and RHL.RHL_FILIAL = RHR.RHR_FILIAL
            and RHL.RHL_MAT = RHR.RHR_MAT
            and RHL.RHL_CODIGO = RHR.RHR_CODIGO
            and RHL.RHL_TPFORN = RHR.RHR_TPFORN
            and RHL.RHL_CODFOR = RHR.RHR_CODFOR

            left join SRB010 DEP (nolock)
                on DEP.D_E_L_E_T_ = ''
                and DEP.RB_FILIAL = RHL.RHL_FILIAL
                and DEP.RB_MAT = RHL.RHL_MAT
                and DEP.RB_COD = RHL.RHL_CODIGO
        
        left join RHM010 RHM (nolock)
            on RHM.D_E_L_E_T_ = ''
            and RHM.RHM_FILIAL = RHR.RHR_FILIAL
            and RHM.RHM_MAT = RHR.RHR_MAT
            and RHM.RHM_CODIGO = RHR.RHR_CODIGO
            and RHM.RHM_TPFORN = RHR.RHR_TPFORN
            and RHM.RHM_CODFOR = RHR.RHR_CODFOR
    where RHR.D_E_L_E_T_ = ''
union
    select /* HISTÓRICO PLANO DE SAÚDE E ODONTO */
        trim(SRA.RA_FILIAL) as FILIAL,

        case SRA.RA_FILIAL
            when '010101' then 'MATRIZ'
            when '010102' then 'FILIAL'
        end as NOME_FILIAL,

        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
	    trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        datediff(year, SRA.RA_NASC, RHS.RHS_DATA) as IDADE,

        RHS.RHS_COMPPG as PERIODO,        

        case when RHS.RHS_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHS.RHS_PD in (88) then 'UNIMED'
            else
                case when RHS.RHS_PD in (428, 429) then 'REDE SAUDE'
                else
                    case when (RHS.RHS_PD in (569, 570, 574, 575, 576, 577, 711, 78) or RHS.RHS_PD = BASE_ODONTO.RD_PD) then 'ODONTO'
                    else
                        case when RHS.RHS_PD in (624, 625) then 'COPARTICIPACAO'
                        else 'OUTROS'
                        end
                    end
                end
            end
        end as TIPO_VERBA,

        trim(isnull(SRV.RV_DESC, '-')) as NOMEVERBA,

        case RHS.RHS_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then RHM.RHM_NOME
            else null
        end as USUARIO,

        case RHS.RHS_ORIGEM
            when 1 then 'TITULAR'
            when 2 then 'DEPENDENTE'
            when 3 then 'AGREGADO'
            else 'OUTROS'
        end as TIPO_USUARIO,

        case RHS.RHS_ORIGEM
            when 1 then trim(SRA.RA_SEXO)
            when 2 then trim(DEP.RB_SEXO)
            when 3 then trim(RHM.RHM_YSEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHS.RHS_ORIGEM
            when 1 then convert(date, SRA.RA_NASC, 103)
            when 2 then convert(date, DEP.RB_DTNASC, 103)
            when 3 then convert(date, RHM.RHM_DTNASC, 103)
            else null
        end as NASCIMENTO,

        case RHS.RHS_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHS.RHS_DATA)
            when 2 then datediff(year, DEP.RB_DTNASC, RHS.RHS_DATA)
            when 3 then datediff(year, RHM.RHM_DTNASC, RHS.RHS_DATA)
            else null
        end as IDADE_USUARIO,

        case when RHS.RHS_ORIGEM = 1 then RHS.RHS_VLRFUN else 0.0 end as VALOR_FUNC,
        case when RHS.RHS_ORIGEM != 1 then RHS.RHS_VLRFUN else 0.0 end as VALOR_DEPAGG,

        trim(DEP.RB_NOME) DEPENDENTE,
        convert(date, DEP.RB_DTNASC, 103) as DEP_NASC,
        trim(DEP.RB_SEXO) as DEP_SEXO,
        datediff(year, DEP.RB_DTNASC, RHS.RHS_DATA) as DEP_IDADE,
        DEP.RB_TPDEP as DEP_ES,
        DEP.RB_TIPIR as DEP_IR,
        DEP.RB_TIPSF as DEP_SF,

        trim(RHM.RHM_NOME) as AGG_NOME,
        convert(date, RHM.RHM_DTNASC, 103) as AGG_NASC,
        trim(RHM.RHM_YSEXO) as AGG_SEXO,
        datediff(year, RHM.RHM_DTNASC, RHS.RHS_DATA) as AGG_IDADE,
        RHM.RHM_TPCALC as AGG_ES,
        
        RHS.RHS_VLRFUN as VALOR_FUNC_TOTAL,
        isnull(BASE_ODONTO.RD_VALOR, RHS.RHS_VLREMP) as VALOR_EMPRESA,
        isnull(BASE_ODONTO.RD_VALOR, RHS.RHS_VLRFUN) as VALOR_FATURAMENTO,

        RHS.RHS_PD as VERBA,
        RHS.RHS_TPLAN as TIPO_LANCAMENTO,
        RHS.RHS_TPPLAN as TIPO_PLANO,
        RHS.RHS_PLANO as PLANO,
        RHS.RHS_ORIGEM as ORIGEM,
        RHS.RHS_CODIGO as COD_DEPAGG

    from RHS010 RHS (nolock)
        left join SRD010 BASE_ODONTO (nolock)
            on BASE_ODONTO.D_E_L_E_T_ = ''
            and BASE_ODONTO.RD_FILIAL = RHS.RHS_FILIAL
            and BASE_ODONTO.RD_MAT = RHS.RHS_MAT
            and BASE_ODONTO.RD_PERIODO = substring(RHS.RHS_DATA, 1, 6)
            and BASE_ODONTO.RD_PD = case when RHS.RHS_PD in (569, 570, 574, 575, 576, 577, 711, 78) then 711 else null end
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = RHS.RHS_PD
        left join RHK010 RHK (nolock)
            on RHK.D_E_L_E_T_ = ''
            and RHK.RHK_FILIAL = RHS.RHS_FILIAL
            and RHK.RHK_MAT = RHS.RHS_MAT
            and RHK.RHK_TPFORN = RHS.RHS_TPFORN
            and RHK.RHK_CODFOR = RHS.RHS_CODFOR

            left join SRA010 SRA (nolock)
                on SRA.D_E_L_E_T_ = ''
                and SRA.RA_FILIAL = RHS.RHS_FILIAL
                and SRA.RA_MAT = RHS.RHS_MAT

                inner join SQB010 SQB (nolock)
                    on SQB.D_E_L_E_T_ = ''
                    and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SQB.QB_DEPTO = SRA.RA_DEPTO
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

        left join RHL010 RHL (nolock)
            on RHL.D_E_L_E_T_ = ''
            and RHL.RHL_FILIAL = RHS.RHS_FILIAL
            and RHL.RHL_MAT = RHS.RHS_MAT
            and RHL.RHL_CODIGO = RHS.RHS_CODIGO
            and RHL.RHL_TPFORN = RHS.RHS_TPFORN
            and RHL.RHL_CODFOR = RHS.RHS_CODFOR

            left join SRB010 DEP (nolock)
                on DEP.D_E_L_E_T_ = ''
                and DEP.RB_FILIAL = RHL.RHL_FILIAL
                and DEP.RB_MAT = RHL.RHL_MAT
                and DEP.RB_COD = RHL.RHL_CODIGO
        
        left join RHM010 RHM (nolock)
            on RHM.D_E_L_E_T_ = ''
            and RHM.RHM_FILIAL = RHS.RHS_FILIAL
            and RHM.RHM_MAT = RHS.RHS_MAT
            and RHM.RHM_CODIGO = RHS.RHS_CODIGO
            and RHM.RHM_TPFORN = RHS.RHS_TPFORN
            and RHM.RHM_CODFOR = RHS.RHS_CODFOR
    where
            RHS.D_E_L_E_T_ = ''
        and year(RHS.RHS_DATA) > 2021
