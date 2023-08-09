select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
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
    datediff(year, SRA.RA_NASC, RHR.RHR_DATA) as IDADE,
    
    substring(RHR.RHR_DATA, 1, 6) as PERIODO,

    case when RHR.RHR_PD in (87, 565, 571) then 'HAPVIDA'
    else
        case when RHR.RHR_PD in (88) then 'UNIMED'
        else
            case when RHR.RHR_PD in (569, 570, 574, 575, 576, 577, 711, 078) then 'ODONTO'
            else
                case when RHR.RHR_PD in (624, 625) then 'COPARTICIPACAO'
                else 'OUTROS'
                end
            end
        end
    end as TIPO_VERBA,

    case RHR.RHR_ORIGEM
        when 1 then SRA.RA_NOME
        when 2 then DEP.RB_NOME
        when 3 then AGG.RB_NOME
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
        when 3 then trim(AGG.RB_SEXO)
        else 'OUTROS'
    end as SEXO_USUARIO,

    case RHR.RHR_ORIGEM
        when 1 then datediff(year, SRA.RA_NASC, RHR.RHR_DATA)
        when 2 then datediff(year, DEP.RB_DTNASC, RHR.RHR_DATA)
        when 3 then datediff(year, AGG.RB_DTNASC, RHR.RHR_DATA)
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

    trim(AGG.RB_NOME) AGREGADO,
	convert(date, AGG.RB_DTNASC, 103) as AGG_NASC,
	trim(AGG.RB_SEXO) as AGG_SEXO,
    datediff(year, AGG.RB_DTNASC, RHR.RHR_DATA) as AGG_IDADE,
    AGG.RB_TPDEP as AGG_ES,
    AGG.RB_TIPIR as AGG_IR,
    AGG.RB_TIPSF as AGG_SF,
    
    RHR.RHR_VLRFUN,
    RHR.RHR_VLREMP,
    RHR.RHR_PD,
    RHR.RHR_TPLAN as TIPO_LANCAMENTO,
    RHR.RHR_TPPLAN as TIPO_PLANO,
    RHR.RHR_PLANO as PLANO,
    RHR.RHR_ORIGEM as ORIGEM,
    RHR.RHR_CODIGO as COD_DEPAGG

from RHR010 RHR (nolock)
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

        left join SRB010 AGG (nolock)
            on AGG.D_E_L_E_T_ = ''
            and AGG.RB_FILIAL = RHM.RHM_FILIAL
            and AGG.RB_MAT = RHM.RHM_MAT
            and AGG.RB_COD = RHM.RHM_CODIGO
where RHR.D_E_L_E_T_ = ''
