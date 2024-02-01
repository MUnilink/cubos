select
    ZG1.ZG1_FILORI as FILIAL_LOG,
    ZG1.ZG1_TABELA as TABELA_LOG,
    ZG1.ZG1_CODIGO as CODIGO_LOG,
    ZG1.ZG1_TIPO as TIPOCOD_LOG,
    
    ZG1.ZG1_HRPAD as HORA_PADRAO,
    ZG1.ZG1_VLTOTL as VALOR_TOTAL,
    ZG1.ZG1_VLHORA as VALOR_HORA,
    
    ZG1.ZG1_HRPRO as HORA_PRODT,
    ZG1.ZG1_VLPROD as VALOR_PRODT,
    ZG1.ZG1_HRIMPR as HORA_IMPRO,
    ZG1.ZG1_VLIMPR as VALOR_IMPRO,
    
    ZG1.ZG1_COMPET as PERIODO_LOG,
    ZG1.ZG1_DTCALC as CALCULO_CUSTO,
    ZG1.ZG1_USRCAL as USUARIO_CUSTO,
    ZG1.ZG1_ATIVO as LOG_ATIVO,

    ZC1.ZC1_FILIAL as FILIAL,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    
    ZC2.ZC2_COMPET,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 6 then 'FECHADA'
        when 9 then 'PEDIDO CRIADO'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'RH'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        else 'OUTROS'
    end as TIPO_INSUMO,
    
    trim(ZC2.ZC2_COD) as INSUMO,
    case ZC2.ZC2_TIPO
        when 1 then (select case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 1)
        when 2 then (select trim(SRJ010.RJ_DESC) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2)
        when 3 then (select trim(ST9010.T9_CODBEM) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 3)
        when 4 then (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 4)
        when 6 then (select trim(ST9010.T9_CODBEM) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 6)
        when 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 7)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,
    ZC2.ZC2_ITEM as ITEM,

    isnull(nullif(concat(ZC2.ZC2_NUM, '-', ZC2.ZC2_ITEM), '-'), 'COMPARATIVO TIPO ' + ZC2.ZC2_TIPO) as OS_ITEM,

    (select sum(SD3010.D3_CUSTO1) from SD3010 (nolock) where SD3010.D_E_L_E_T_ = '' and SD3010.D3_FILIAL = ZC2.ZC2_FILIAL and SD3010.D3_YOS = ZC2.ZC2_NUM and SD3010.D3_COD = ZC2.ZC2_COD and eomonth(SD3010.D3_EMISSAO) = ZC2.ZC2_COMPET and SD3010.D3_ESTORNO != 'S' and ZC2.ZC2_TIPO = 4 and ZG1.ZG1_TABELA = 'SD3') as ESTOQUE,
    (select sum(TQN010.TQN_VALTOT) from TQN010 (nolock) where TQN010.D_E_L_E_T_ = '' and TQN010.TQN_FROTA = ZC2.ZC2_COD and eomonth(TQN010.TQN_DTABAS) = ZC2.ZC2_COMPET and ZC2.ZC2_TIPO = 3 and ZG1.ZG1_TABELA = 'TQN') as COMBUSTIVEL,
    (
        select sum(STL010.TL_CUSTO)
        from STJ010 (nolock)
            left join STL010 (nolock)
                on STL010.D_E_L_E_T_ = ''
                and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                and STL010.TL_PLANO = STJ010.TJ_PLANO
                and STL010.TL_ORDEM = STJ010.TJ_ORDEM
        where
                STJ010.D_E_L_E_T_ = ''
            and STJ010.TJ_CODBEM = ZC2.ZC2_COD
            and eomonth(STL010.TL_DTFIM) = ZC2.ZC2_COMPET
            and STL010.TL_SEQRELA > 0
            and ZC2.ZC2_TIPO = 3
    ) as MANUTENCAO,
    
    (
        select sum(SN4010.N4_VLROC1)
        from SN4010 (nolock)
            inner join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and SN3010.N3_CBASE = SN4010.N4_CBASE
                and SN3010.N3_ITEM = SN4010.N4_ITEM

                inner join SN1010 (nolock)
                    on SN1010.D_E_L_E_T_ = ''
                    and SN1010.N1_CBASE = SN3010.N3_CBASE
                    and SN1010.N1_ITEM = SN3010.N3_ITEM
        where
                SN4010.D_E_L_E_T_ = ''
            and SN1010.N1_CODBEM = ZC2.ZC2_COD
            and eomonth(SN4010.N4_DATA) = ZC2.ZC2_COMPET
            and SN4010.N4_OCORR = 6
            and SN4010.N4_TIPOCNT = 3
            and ZC2.ZC2_TIPO = 6
    ) as DEPRECIACAO,

    (
        select sum(TS1010.TS1_VALOR)
        from TS1010 (nolock)
            left join SE2010 (nolock)
                on SE2010.D_E_L_E_T_ = ''
                and trim(SE2010.E2_PREFIXO) = 'MNT'
                and SE2010.E2_NUM = TS1010.TS1_NUMSE2
        where
                TS1010.D_E_L_E_T_ = ''
            and TS1010.TS1_CODBEM = ZC2.ZC2_COD
            and year(SE2010.E2_VENCREA) = substring(ZC2.ZC2_COMPET, 1, 4)
            and ZC2.ZC2_TIPO = 9
    )/12 as DOCUMENTACAO,

    (
        select sum(ZC2010.ZC2_TOTAL)
        from ZA7010 (nolock)
            inner join ZC2010 (nolock)
                on ZC2010.D_E_L_E_T_ = ''
                and ZC2010.ZC2_COD = ZA7010.ZA7_COD
        where
                ZA7010.D_E_L_E_T_ = ''
            and ZC2010.ZC2_COD = ZC2.ZC2_COD
            and ZC2010.ZC2_COMPET = ZC2.ZC2_COMPET
            and ZC2010.ZC2_TIPO = 7
    ) as CONTABILIDADE

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    left join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_CODIGO = ZC2.ZC2_COD
        and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
        and ZG1.ZG1_ATIVO = 'S'
        and ZG1.ZG1_COMPET = substring(ZC2.ZC2_COMPET, 1, 6)
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_HRINI != '  :  '
    and ZC2.ZC2_HRFIM != '  :  '
