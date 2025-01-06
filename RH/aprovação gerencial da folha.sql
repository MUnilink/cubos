    select
        SRC.RC_FILIAL as FILIAL,
        SRC.RC_PERIODO as PERIODO,
        substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
        SRC.RC_MAT as MATRICULA,
        SRC.RC_PD as VERBA,
        (select trim(coalesce(nullif(SRV010.RV_DESCDET, ''), SRV010.RV_DESC)) from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRC.RC_PD) as DESC_VERBA,
        SRC.RC_SEQ as SEQ,
        SRC.RC_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        case SRC.RC_PD when '990' then SRA.RA_SALARIO else 0.0 end as SALARIO_BASE,
        case SRC.RC_PD when '999' then SRC.RC_VALOR else 0.0 end as VALOR_LIQUIDO,
        case trim(SRV.RV_TIPOCOD) when '1' then SRC.RC_VALOR else 0.0 end as PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRC.RC_VALOR else 0.0 end as DESCONTOS,
        
        case SRC.RC_PD when '039' then SRC.RC_VALOR else 0.0 end as ADIC_RISCO,
        case SRC.RC_PD when '353' then SRC.RC_VALOR else 0.0 end as ADIC_TEMPOSERVICO,
        case SRC.RC_PD when '420' then SRC.RC_VALOR when '422' then SRC.RC_VALOR when '423' then SRC.RC_VALOR else 0.0 end as IR,
        case SRC.RC_PD when '401' then SRC.RC_VALOR when '402' then SRC.RC_VALOR when '403' then SRC.RC_VALOR else 0.0 end as INSS,
        case SRC.RC_PD when '407' then SRC.RC_VALOR else 0.0 end as MENS_SINDICAL,
        case SRC.RC_PD when '373' then SRC.RC_VALOR when '530' then SRC.RC_VALOR when '532' then SRC.RC_VALOR when '535' then SRC.RC_VALOR else 0.0 end as PENSAO_ALIM,
        
        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(SRA.RA_NOMECMP) as NOME,
        SRA.RA_SITFOLH as SITUACAO,
        trim(SQ3.Q3_CARGO) as CARGO,
        trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
        trim(SRJ.RJ_FUNCAO) as FUNCAO,
        trim(SRJ.RJ_DESC) as DESC_FUNCAO,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,

        SRC.RC_VALOR as VALOR,
        SRC.RC_HORAS as HORAS

    from SRC010 SRC (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRC.RC_FILIAL
            and SRA.RA_MAT = SRC.RC_MAT
            and trim(SRC.RC_MAT) not in ('003264', '003263')

            left join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and CTD010.CTD_ITEM = SRC.RC_ITEM
        left join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and CTT010.CTT_CUSTO = SRC.RC_CC
        left join SRV010 SRV (nolock)
            on SRV.RV_COD = SRC.RC_PD
    where SRC.D_E_L_E_T_ = ''
union
    select
        SRD.RD_FILIAL as FILIAL,
        SRD.RD_PERIODO as PERIODO,
        substring(SRD.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRD.RD_PERIODO, 1, 4) as PERIODO_ANO,
        SRD.RD_MAT as MATRICULA,
        SRD.RD_PD as VERBA,
        (select trim(coalesce(nullif(SRV010.RV_DESCDET, null), SRV010.RV_DESC)) from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD) as DESC_VERBA,
        SRD.RD_SEQ as SEQ,
        SRD.RD_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        case SRD.RD_PD when '990' then SRA.RA_SALARIO else 0.0 end as SALARIO_BASE,
        case SRD.RD_PD when '999' then SRD.RD_VALOR else 0.0 end as VALOR_LIQUIDO,
        case trim(SRV.RV_TIPOCOD) when '1' then SRD.RD_VALOR else 0.0 end as PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRD.RD_VALOR else 0.0 end as DESCONTOS,
        
        case SRD.RD_PD when '039' then SRD.RD_VALOR else 0.0 end as ADIC_RISCO,
        case SRD.RD_PD when '353' then SRD.RD_VALOR else 0.0 end as ADIC_TEMPOSERVICO,
        case SRD.RD_PD when '420' then SRD.RD_VALOR when '422' then SRD.RD_VALOR when '423' then SRD.RD_VALOR else 0.0 end as IR,
        case SRD.RD_PD when '401' then SRD.RD_VALOR when '402' then SRD.RD_VALOR when '403' then SRD.RD_VALOR else 0.0 end as INSS,
        case SRD.RD_PD when '407' then SRD.RD_VALOR else 0.0 end as MENS_SINDICAL,
        case SRD.RD_PD when '373' then SRD.RD_VALOR when '530' then SRD.RD_VALOR when '532' then SRD.RD_VALOR when '535' then SRD.RD_VALOR else 0.0 end as PENSAO_ALIM,
        
        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(SRA.RA_NOMECMP) as NOME,
        SRA.RA_SITFOLH as SITUACAO,
        trim(SQ3.Q3_CARGO) as CARGO,
        trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
        trim(SRJ.RJ_FUNCAO) as FUNCAO,
        trim(SRJ.RJ_DESC) as DESC_FUNCAO,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,

        SRD.RD_VALOR as VALOR,
        SRD.RD_HORAS as HORAS

    from SRD010 SRD (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT
            and trim(SRD.RD_MAT) not in ('003264', '003263')

            left join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join CTD010 (nolock)
            on CTD010.D_E_L_E_T_ = ''
            and CTD010.CTD_ITEM = SRD.RD_ITEM
        left join CTT010 (nolock)
            on CTT010.D_E_L_E_T_ = ''
            and CTT010.CTT_CUSTO = SRD.RD_CC
        left join SRV010 SRV (nolock)
            on SRV.RV_COD = SRD.RD_PD
    where
            datediff(month, concat(SRD.RD_DATARQ, '01'), getdate()) < 7
        and SRD.D_E_L_E_T_ = ''
