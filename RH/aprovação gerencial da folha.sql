    select
        SRC.RC_FILIAL as FILIAL,
        SRC.RC_PERIODO as PERIODO,
        substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
        SRC.RC_MAT as MATRICULA,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        SRC.RC_PD as VERBA,
        isnull(nullif(trim(SRV.RV_DESC), ''), SRV.RV_DESCDET) as DESC_VERBA,
        SRC.RC_SEQ as SEQ,
        SRC.RC_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,
        case trim(SRV.RV_TIPOCOD) when '1' then SRC.RC_VALOR else 0.0 end as PROVENTOS,
        case when trim(SRV.RV_TIPOCOD) != '1' then 0.0 when trim(SRV.RV_TIPOCOD) = '1' and SRC.RC_PD not in ('039', '215', '041', '030', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '039', '215', '041', '030', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304') then SRC.RC_VALOR else 0.0 end as OUTROS_PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRC.RC_VALOR else 0.0 end as DESCONTOS,
        case when trim(SRV.RV_TIPOCOD) != '2' then 0.0 when trim(SRV.RV_TIPOCOD) = '2' and SRC.RC_PD not in ('420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '456', '420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '45') then SRC.RC_VALOR else 0.0 end as OUTROS_DESCONTOS,
        
        case SRC.RC_PD when '990' then SRA.RA_SALARIO else 0.0 end as SALARIO_BASE,
        case when SRC.RC_PD in ('183', '999') then SRC.RC_VALOR else 0.0 end as VALOR_LIQUIDO,
        
        case when SRC.RC_PD in ('039', '215') then SRC.RC_VALOR else 0.0 end as ADIC_RISCO,
        case when SRC.RC_PD in ('041', '030') then SRC.RC_VALOR else 0.0 end as ADIC_NOTURNO,
        case when SRC.RC_PD in ('451', '452') then SRC.RC_VALOR else 0.0 end as DOBRAS_DOMINGOS,
        case when SRC.RC_PD in ('353') then SRC.RC_VALOR else 0.0 end as ADIC_TEMPOSERVICO,
        case when SRC.RC_PD in ('057') then SRC.RC_VALOR else 0.0 end as DIARIAS,
        case when SRC.RC_PD in ('113', '061', '062', '063', '064', '112', '116', '370', '344') then SRC.RC_VALOR else 0.0 end as HREXTRA_APROVADA,
        case when SRC.RC_PD in ('147', '091', '140', '304') then SRC.RC_VALOR else 0.0 end as ARRED_PROV,
        
        case when SRC.RC_PD in ('420', '421', '422') then SRC.RC_VALOR else 0.0 end as IR,
        case when SRC.RC_PD in ('401', '403', '402') then SRC.RC_VALOR else 0.0 end as INSS,
        case when SRC.RC_PD in ('373', '535', '532', '530') then SRC.RC_VALOR else 0.0 end as PENSAO_ALIM,
        case when SRC.RC_PD in ('407') then SRC.RC_VALOR else 0.0 end as MENS_SINDICAL,
        case when SRC.RC_PD in ('738') then SRC.RC_VALOR else 0.0 end as PLANO_SAUDE,
        case when SRC.RC_PD in ('461') then SRC.RC_VALOR else 0.0 end as ARRED_DESC,
        case when SRC.RC_PD in ('456') then SRC.RC_VALOR else 0.0 end as PROV_ECONSIG,
        case when SRC.RC_PD in ('562') then SRC.RC_VALOR else 0.0 end as VLCESTA_DESC,
        case when SRC.RC_PD in ('561') then SRC.RC_VALOR else 0.0 end as VLTRANP_DESC,
        
        case when SRC.RC_PD in ('796') then SRC.RC_VALOR else 0.0 end as VLTRANP_BASE,
        case when SRC.RC_PD in ('749') then SRC.RC_VALOR else 0.0 end as VLCESTA_BASE,
        case when SRC.RC_PD in ('719') then SRC.RC_VALOR else 0.0 end as VLALIM_BASE,
        
        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(CTT010.CTT_DESC01) as CENTRO_CUSTO,
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
            and SRV.D_E_L_E_T_ = ''
    where SRC.D_E_L_E_T_ = ''
union
    select
        SRD.RD_FILIAL as FILIAL,
        SRD.RD_PERIODO as PERIODO,
        substring(SRD.RD_PERIODO, 5, 6) as PERIODO_MES,
        substring(SRD.RD_PERIODO, 1, 4) as PERIODO_ANO,
        SRD.RD_MAT as MATRICULA,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        SRD.RD_PD as VERBA,
        isnull(nullif(trim(SRV.RV_DESC), ''), SRV.RV_DESCDET) as DESC_VERBA,
        SRD.RD_SEQ as SEQ,
        SRD.RD_ROTEIR as ROTEIRO,

        case trim(SRV.RV_TIPOCOD)
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
            else '-'
        end as TIPO_VERBA,
        
        cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,
        case trim(SRV.RV_TIPOCOD) when '1' then SRD.RD_VALOR else 0.0 end as PROVENTOS,
        case when trim(SRV.RV_TIPOCOD) != '1' then 0.0 when trim(SRV.RV_TIPOCOD) = '1' and SRD.RD_PD not in ('039', '215', '041', '030', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304', '039', '215', '041', '030', '451', '452', '353', '057', '113', '061', '062', '063', '064', '112', '116', '370', '344', '147', '091', '140', '304') then SRD.RD_VALOR else 0.0 end as OUTROS_PROVENTOS,
        case trim(SRV.RV_TIPOCOD) when '2' then SRD.RD_VALOR else 0.0 end as DESCONTOS,
        case when trim(SRV.RV_TIPOCOD) != '2' then 0.0 when trim(SRV.RV_TIPOCOD) = '2' and SRD.RD_PD not in ('420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '456', '420', '421', '422', '401', '403', '402', '373', '535', '532', '530', '407', '738', '461', '45') then SRD.RD_VALOR else 0.0 end as OUTROS_DESCONTOS,
        
        case SRD.RD_PD when '990' then SRA.RA_SALARIO else 0.0 end as SALARIO_BASE,
        case when SRD.RD_PD in ('183', '999') then SRD.RD_VALOR else 0.0 end as VALOR_LIQUIDO,
        
        case when SRD.RD_PD in ('039', '215') then SRD.RD_VALOR else 0.0 end as ADIC_RISCO,
        case when SRD.RD_PD in ('041', '030') then SRD.RD_VALOR else 0.0 end as ADIC_NOTURNO,
        case when SRD.RD_PD in ('451', '452') then SRD.RD_VALOR else 0.0 end as DOBRAS_DOMINGOS,
        case when SRD.RD_PD in ('353') then SRD.RD_VALOR else 0.0 end as ADIC_TEMPOSERVICO,
        case when SRD.RD_PD in ('057') then SRD.RD_VALOR else 0.0 end as DIARIAS,
        case when SRD.RD_PD in ('113', '061', '062', '063', '064', '112', '116', '370', '344') then SRD.RD_VALOR else 0.0 end as HREXTRA_APROVADA,
        case when SRD.RD_PD in ('147', '091', '140', '304') then SRD.RD_VALOR else 0.0 end as ARRED_PROV,
        
        case when SRD.RD_PD in ('420', '421', '422') then SRD.RD_VALOR else 0.0 end as IR,
        case when SRD.RD_PD in ('401', '403', '402') then SRD.RD_VALOR else 0.0 end as INSS,
        case when SRD.RD_PD in ('373', '535', '532', '530') then SRD.RD_VALOR else 0.0 end as PENSAO_ALIM,
        case when SRD.RD_PD in ('407') then SRD.RD_VALOR else 0.0 end as MENS_SINDICAL,
        case when SRD.RD_PD in ('738') then SRD.RD_VALOR else 0.0 end as PLANO_SAUDE,
        case when SRD.RD_PD in ('461') then SRD.RD_VALOR else 0.0 end as ARRED_DESC,
        case when SRD.RD_PD in ('456') then SRD.RD_VALOR else 0.0 end as PROV_ECONSIG,
        case when SRD.RD_PD in ('562') then SRD.RD_VALOR else 0.0 end as VLCESTA_DESC,
        case when SRD.RD_PD in ('561') then SRD.RD_VALOR else 0.0 end as VLTRANP_DESC,
        
        case when SRD.RD_PD in ('796') then SRD.RD_VALOR else 0.0 end as VLTRANP_BASE,
        case when SRD.RD_PD in ('749') then SRD.RD_VALOR else 0.0 end as VLCESTA_BASE,
        case when SRD.RD_PD in ('719') then SRD.RD_VALOR else 0.0 end as VLALIM_BASE,
        
        trim(CTD010.CTD_DESC01) as ATIVIDADE,
        trim(CTT010.CTT_DESC01) as CENTRO_CUSTO,
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
            and SRV.D_E_L_E_T_ = ''
    where
            datediff(month, concat(SRD.RD_DATARQ, '01'), getdate()) < 7
        and SRD.D_E_L_E_T_ = ''
