    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as AT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
        datediff(year, SRA.RA_NASC, RHP.RHP_DTOCOR) as IDADE,

        substring(RHP.RHP_DTOCOR, 1, 6) as PERIODO,

        case when RHP.RHP_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHP.RHP_PD in (88) then 'UNIMED'
            else
                case when RHP.RHP_PD in (569, 570, 574, 575, 576, 577, 711, 078) then 'ODONTO'
                else
                    case when RHP.RHP_PD in (624, 625) then 'COPARTICIPACAO'
                    else 'OUTROS'
                    end
                end
            end
        end as TIPO_VERBA,

        case RHP.RHP_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then AGG.RB_NOME
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
            when 3 then trim(AGG.RB_SEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHP.RHP_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHP.RHP_DTOCOR)
            when 2 then datediff(year, DEP.RB_DTNASC, RHP.RHP_DTOCOR)
            when 3 then datediff(year, AGG.RB_DTNASC, RHP.RHP_DTOCOR)
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

        trim(AGG.RB_NOME) AGREGADO,
        convert(date, AGG.RB_DTNASC, 103) as AGG_NASC,
        trim(AGG.RB_SEXO) as AGG_SEXO,
        datediff(year, AGG.RB_DTNASC, RHP.RHP_DTOCOR) as AGG_IDADE,
        AGG.RB_TPDEP as AGG_ES,
        AGG.RB_TIPIR as AGG_IR,
        AGG.RB_TIPSF as AGG_SF,
        
        RHP.RHP_VLRFUN,
        RHP.RHP_VLREMP,
        RHP.RHP_PD,
        RHP.RHP_TPLAN as TIPO_LANCAMENTO,
        RHP.RHP_ORIGEM as ORIGEM,
        RHP.RHP_CODIGO as COD_DEPAGG

    from RHP010 RHP (nolock)
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

            left join SRB010 AGG (nolock)
                on AGG.D_E_L_E_T_ = ''
                and AGG.RB_FILIAL = RHM.RHM_FILIAL
                and AGG.RB_MAT = RHM.RHM_MAT
                and AGG.RB_COD = RHM.RHM_CODIGO
    where
            RHP.D_E_L_E_T_ = ''
        and year(RHP.RHP_DTOCOR) > 2021
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as AT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
        datediff(year, SRA.RA_NASC, RHO.RHO_DTOCOR) as IDADE,

        substring(RHO.RHO_DTOCOR, 1, 6) as PERIODO,

        case when RHO.RHO_PD in (87, 565, 571) then 'HAPVIDA'
        else
            case when RHO.RHO_PD in (88) then 'UNIMED'
            else
                case when RHO.RHO_PD in (569, 570, 574, 575, 576, 577, 711, 078) then 'ODONTO'
                else
                    case when RHO.RHO_PD in (624, 625) then 'COPARTICIPACAO'
                    else 'OUTROS'
                    end
                end
            end
        end as TIPO_VERBA,

        case RHO.RHO_ORIGEM
            when 1 then SRA.RA_NOME
            when 2 then DEP.RB_NOME
            when 3 then AGG.RB_NOME
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
            when 3 then trim(AGG.RB_SEXO)
            else 'OUTROS'
        end as SEXO_USUARIO,

        case RHO.RHO_ORIGEM
            when 1 then datediff(year, SRA.RA_NASC, RHO.RHO_DTOCOR)
            when 2 then datediff(year, DEP.RB_DTNASC, RHO.RHO_DTOCOR)
            when 3 then datediff(year, AGG.RB_DTNASC, RHO.RHO_DTOCOR)
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

        trim(AGG.RB_NOME) AGREGADO,
        convert(date, AGG.RB_DTNASC, 103) as AGG_NASC,
        trim(AGG.RB_SEXO) as AGG_SEXO,
        datediff(year, AGG.RB_DTNASC, RHO.RHO_DTOCOR) as AGG_IDADE,
        AGG.RB_TPDEP as AGG_ES,
        AGG.RB_TIPIR as AGG_IR,
        AGG.RB_TIPSF as AGG_SF,
        
        RHO.RHO_VLRFUN,
        RHO.RHO_VLREMP,
        RHO.RHO_PD,
        RHO.RHO_TPLAN as TIPO_LANCAMENTO,
        RHO.RHO_ORIGEM as ORIGEM,
        RHO.RHO_CODIGO as COD_DEPAGG

    from RHO010 RHO (nolock)
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

            left join SRB010 AGG (nolock)
                on AGG.D_E_L_E_T_ = ''
                and AGG.RB_FILIAL = RHM.RHM_FILIAL
                and AGG.RB_MAT = RHM.RHM_MAT
                and AGG.RB_COD = RHM.RHM_CODIGO
    where
            RHO.D_E_L_E_T_ = ''