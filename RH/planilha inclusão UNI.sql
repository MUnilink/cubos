select /* PLANO DE SAÚDE E ODONTO */
    trim(SRA.RA_FILIAL) as FILIAL,

    case SRA.RA_FILIAL
        when '010101' then 'MATRIZ'
        when '010102' then 'FILIAL'
    end as NOME_FILIAL,

    trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
    trim(SRA.RA_ESTADO) as UF,
    convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    SRA.RA_SITFOLH as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
    trim(SRA.RA_ESTCIVI) as ESTADO_CIVIL,
    trim(SRA.RA_NATURAL) as NATURALIDADE,
    trim(SRA.RA_RG) as RG,
    trim(SRA.RA_DTRGEXP) as DT_EXP_RG,
    trim(SRA.RA_RGORG) as ORG_EMISSOR,
    trim(SRA.RA_MAE) as NOME_MAE,
    trim(SRA.RA_TELEFON) as TELEFONE,
    trim(SRA.RA_LOGRTP) as TIPO_LOGRA,
    trim(SRA.RA_ENDEREC) as ENDERECO_TITULAR,
    trim(SRA.RA_NUMENDE) as NUMERO_END,
    trim(SRA.RA_BAIRRO) as BAIRRO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
    trim(SRA.RA_ESTADO) as ESTADO,
    trim(SRA.RA_CEP) as CEP,
    trim(SRA.RA_COMPLEM) as COMPLEMENTO,
    trim(SRA.RA_TIPENDE) as TIPO_ENDERECO,

    trim(CTT.CTT_CUSTO) as CC,
    trim(CTT.CTT_DESC01) as CCUSTO,
    trim(CTD.CTD_ITEM) as ITCT,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

    trim(SRJ.RJ_CODCBO) as CBO,
    trim(SRA.RA_SEXO) as SEXO,
    trim(SRA.RA_CIC) as CPF,
    cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,

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
        when 1 then SRA.RA_NOMECMP
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
    case DEP.RB_GRAUPAR 
        when 'C' then 'CONJUGE'
        when 'F' then 'FILHO'
        when 'E' then 'ENTEADO'
        when 'P' then 'PAI/MAE'
        when 'O' then 'AGREGADO/OUTROS'
        else 'OUTROS'
    end as PARENTESCO,


    RHR.RHR_TPPLAN as TIPO_PLANO,
    RHR.RHR_PLANO as PLANO
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
    and year(RHR.RHR_DATA) = 2023
    and month(RHR.RHR_DATA) = 11