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
    substring(ZC2.ZC2_DTFIM, 1, 6) as PERIODO_APONT,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as HORAS_APONT,

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

    SD3.D3_CUSTO1,
    SD3.D3_NUMSA as SA,
    SD3.D3_DOC as DOC_EST,
    TQN.TQN_DTABAS,
    TQN.TQN_VALTOT,
    MNT.TJ_ORDEM,
    MNT.TL_CUSTO,
    DEP.DATA_MOV,
    DEP.N4_VLROC1

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    inner join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_CODIGO = ZC2.ZC2_COD
        and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
        and ZG1.ZG1_COMPET = substring(ZC2.ZC2_COMPET, 1, 6)
    
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = ZC2.ZC2_FILIAL
        and SD3.D3_YOS = ZC2.ZC2_NUM
        and eomonth(SD3.D3_EMISSAO) = ZC2.ZC2_COMPET
        and ZC2.ZC2_TIPO = 4
    
    left join TQN010 TQN (nolock)
        on TQN.D_E_L_E_T_ = ''
        and TQN.TQN_FILIAL = ZC2.ZC2_FILIAL
        and TQN.TQN_FROTA = ZC2.ZC2_COD
        and eomonth(TQN.TQN_DTABAS) = ZC2.ZC2_COMPET
        and ZC2.ZC2_TIPO = 3
    /*left join SRD010 SRD (nolock)*/
    left join
    (   
        select
            STJ010.TJ_FILIAL,
            STJ010.TJ_ORDEM,
            STJ010.TJ_CODBEM,
            STL010.TL_CODIGO,
            STL010.TL_SEQRELA,
            STL010.TL_CUSTO,
            STL010.TL_DTINICI,
            eomonth(STL010.TL_DTINICI) as PERIODO
        from STJ010 (nolock)
            left join STL010 (nolock)
                on STL010.D_E_L_E_T_ = ''
                and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                and STL010.TL_PLANO = STJ010.TJ_PLANO
                and STL010.TL_ORDEM = STJ010.TJ_ORDEM
        where
                STJ010.D_E_L_E_T_ = ''
            and STL010.TL_SEQRELA > 0
    ) MNT
        on ZC2.ZC2_TIPO = 3
        and MNT.TJ_CODBEM = ZC2.ZC2_COD
        and MNT.PERIODO = ZC2.ZC2_COMPET
    
    left join
    (
        select
            SN1010.N1_CODBEM,
            SN4010.N4_VLROC1,
            convert(datetime, concat(SN4010.N4_DATA, ' ', SN4010.N4_HORA), 113) as DATA_MOV,
            eomonth(SN4010.N4_DATA) as PERIODO,
            trim(SN1010.N1_CBASE) as ATIVO,
            trim(SN1010.N1_DESCRIC) as DESC_ATIVO,
            trim(ST9010.T9_CODBEM) as T9_CODBEM
        from SN4010 (nolock)
            inner join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and SN3010.N3_CBASE = SN4010.N4_CBASE
                and SN3010.N3_ITEM = SN4010.N4_ITEM

                inner join SN1010 (nolock)
                    on SN1010.D_E_L_E_T_ = ''
                    and SN1010.N1_CBASE = SN3010.N3_CBASE
                    and SN1010.N1_ITEM = SN3010.N3_ITEM

                    inner join ST9010 (nolock)
                        on ST9010.D_E_L_E_T_ = ''
                        and ST9010.T9_CODBEM = SN1010.N1_CODBEM
        where
                SN4010.D_E_L_E_T_ = ''
            and SN4010.N4_OCORR = 6
    ) DEP
        on ZC2.ZC2_TIPO = 6
        and DEP.T9_CODBEM = ZC2.ZC2_COD
        and DEP.PERIODO = ZC2.ZC2_COMPET
    /*left join CT2010 CT2 (nolock) and ZC2.ZC2_TIPO = 7*/
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_HRINI != '  :  '
    and ZC2.ZC2_HRFIM != '  :  '
