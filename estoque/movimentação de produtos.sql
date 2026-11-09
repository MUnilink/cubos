select
    SB1.B1_COD as contador,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    trim(SB1.B1_YCTCUST) as PROD_CUSTO,
    trim(SB1.B1_YCTDEAD) as PROD_DESPE,
    
    case when trim(SB1.B1_COD) in ('14010070', '14010071', '14010027', '14010211', '14010215', '12040014', '14010069', '14010101', '14010422', '14010421', '14010028', '14010136', '14010167', '14010170', '14010248', '14010592', '14010512', '14010453', '14010587', '14010601', '14010164', '14010165', '14010195', '14010194', '14010193', '14010192', '14010600', '14010599', '14010598', '14010516', '14010203', '14010206', '14010209', '14010208', '14010207', '14010235', '14010233', '14010232', '14010231', '14010230', '14010229', '14010212', '14010466', '14010259', '14010257', '14010595', '14010594', '14010001', '12040013', '14010258', '14010217', '14010216', '14010605', '14010602', '14010423', '14010618', '14010617', '14010172', '14010249', '14010513', '14010687', '14010404', '14010406', '12040018', '14010527', '14010426', '14010715', '14010714', '14010400', '14010712', '14010531', '14010435', '14010434', '14010433', '14010514', '14010468', '14010405', '14010730', '14010731', '14010732', '14010741', '14010487', '14010958', '14010483', '14010758', '14010467', '14010504', '14010541', '14010528', '14010518', '14010559', '14010517', '14010540', '14010171', '14010812', '14010811', '14010826', '14010856', '14010672', '14010873', '14010887', '14010936', '14010515', '14010872', '14010962', '14010925', '14010975', '14010968', '14010894', '14010403')
        then '1401 içamento de materiais'
        else concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO))
    end as GRUPO,
    
    trim(SB1.B1_UM) as UN,
    left(SD3.D3_EMISSAO, 6) as PERIODO,
    cast(SD3.D3_EMISSAO as date) as EMISSAO,
    case when substring(SD3.D3_OP, 7, 2) != 'OS' then left(SD3.D3_OP, 6) else null end as OP,
    case when substring(SD3.D3_OP, 7, 2) = 'OS' then left(SD3.D3_OP, 6) else null end as OS_MNT,
    SD3.D3_YOS as OS_PORT,
    SD3.D3_NUMSA as SA,
    SD3.D3_FILIAL as FILIAL,
    SD3.D3_LOCAL as ARMAZEM,
    SD3.D3_TM as TM,
    
    case
        when SD3.D3_CF like 'ER[0-1]' then SD3.D3_CF + ' - ' + 'Estorno de produção manual/automática'
        when SD3.D3_CF like 'PR[0-1]' then SD3.D3_CF + ' - ' + 'Produção manual/automática'
        when right(SD3.D3_CF, 1) = '0' then left(SD3.D3_CF, 2) + ' - ' + 'Operação Manual (custo médio no estoque)'
        when right(SD3.D3_CF, 1) = '1' then left(SD3.D3_CF, 2) + ' - ' + 'Operação Automática (custo médio no estoque)'
        when right(SD3.D3_CF, 1) = '2' then left(SD3.D3_CF, 2) + ' - ' + 'Operação Automática (apropriação interna)'
        when right(SD3.D3_CF, 1) = '3' then left(SD3.D3_CF, 2) + ' - ' + 'Operação Manual (Apropriação Interna)'
        when right(SD3.D3_CF, 1) = '4' then left(SD3.D3_CF, 2) + ' - ' + 'Transferência (custo médio no estoque por local físico)'
        when right(SD3.D3_CF, 1) = '5' then left(SD3.D3_CF, 2) + ' - ' + 'Requisição para OP na NF (usa o custo do documento fiscal)'
        when right(SD3.D3_CF, 1) = '6' then left(SD3.D3_CF, 2) + ' - ' + 'Requisição Valorizada'
        when right(SD3.D3_CF, 1) = '7' then left(SD3.D3_CF, 2) + ' - ' + 'Transferência Múltipla (desmontagem de produtos)'
        when right(SD3.D3_CF, 1) = '8' then left(SD3.D3_CF, 2) + ' - ' + 'OBSOLETO - Integração com NF de Produtos Importados (SIGAEIC até a versão Advanced Protheus 6.09)'
        when right(SD3.D3_CF, 1) = '9' then left(SD3.D3_CF, 2) + ' - ' + 'Movimento para OP sem agreg. custo'
        when right(SD3.D3_CF, 1) = 'A' then left(SD3.D3_CF, 2) + ' - ' + 'Movimento Interno REA / DEA Gerado pela rotina MATA338'
    else 'outros' end as CF,
    
    SD3.D3_DOC as DOC,
    SD3.D3_NUMSEQ as SEQ,
    SD3.D3_ESTORNO as ESTORNO,
    trim(SD3.D3_CC) as CCUSTO,
    trim(SD3.D3_ITEMCTA) as ATIVIDADE,

    trim(ST9.T9_CODBEM) as EQUIPAMENTO,
    case when ST9.T9_CODBEM like 'UTM%' then 'UTM' else trim(TQR.TQR_DESMOD) end as MODELO,
    
    SD3.D3_CUSTO1 as CUSTO,
    case when SD3.D3_CF like 'R%' then -1*SD3.D3_CUSTO1 else SD3.D3_CUSTO1 end as CUSTO_MOV,
    SD3.D3_QUANT as QTD,
    case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV,
    case when SD3.D3_CF like 'R%' then 'SAI EST' when SD3.D3_CF like 'D%' then 'ENT EST' else 'outros' end as TIPO_MOV,
    
    case
        when left(SD3.D3_CC, 1) = '3' then concat(trim(SB1.B1_YCTCUST), ' ',(select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTCUST))
        else concat(trim(SB1.B1_YCTDEAD), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTDEAD))
    end as LP_DEB
    
from SD3010 SD3 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
        and SB1.B1_GRUPO like '1%'

    left join STJ010 STJ (nolock)
        on STJ.D_E_L_E_T_ = ''
        and STJ.TJ_FILIAL = SD3.D3_FILIAL
        and STJ.TJ_ORDEM + 'OS' + '001' = SD3.D3_OP

        left join ST9010 ST9 (nolock)
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = STJ.TJ_CODBEM

            left join TQR010 TQR (nolock)
                on TQR.D_E_L_E_T_ = ''
                and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
where
        SD3.D_E_L_E_T_ = ''
    and SD3.D3_EMISSAO between :DATA_INI_MOV and :DATA_FIM_MOV
