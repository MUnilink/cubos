select
    concat(trim(SB1.B1_GRUPO), ' ', upper(trim(SBM.BM_DESC))) as GRUPO,
    concat(SBM.BM_YGRUPO, ' ', (select trim(upper(ZA5010.ZA5_DESC)) from ZA5010 where ZA5010.D_E_L_E_T_ = '' and ZA5010.ZA5_COD = SBM.BM_YGRUPO)) as 'Grupo Primario',
    concat(SBM.BM_YSUBGRU, ' ', (select trim(upper(ZA6010.ZA6_DESC)) from ZA6010 where ZA6010.D_E_L_E_T_ = '' and ZA6010.ZA6_GRUPO = SBM.BM_YGRUPO and ZA6010.ZA6_SUBGRU = SBM.BM_YSUBGRU)) as 'SubGrupo',
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_COD) as contador,
    cast(SB1.B1_UCOM as date) as 'Data da Ultima Compra',
    cast(SB1.B1_UREV as date) as 'Data da Ultima Revisao',
    cast(SB1.B1_DATREF as date) as 'Data Referencia do Custo',
    cast(SB1.B1_CONINI as date) as 'Data do Consumo Inicial',
    cast(SB1.B1_DATASUB as date) as 'Data da Substituicao',
    cast(SB1.B1_VIGENC as date) as 'Data Vigencia Inicial',
    trim(SB1.B1_DESC) as DESCRICAO,
    trim(SB1.B1_UM) as UN,
    trim(SB1.B1_SEGUM) as UN_2,
    trim(SB1.B1_LOCPAD) as ARMAZEM,
    cast(SB1.B1_UPRC as numeric(15, 2)) as ULT_PRECO,
    trim(SB1.B1_YDESCRI) as DESC_FROTA,
    trim(SB1.B1_YMARCA) as OP_MARCA,
    trim(SB1.B1_YPARTNU) as PARTNUMBER,

    concat(trim(SB1.B1_CONTA), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_CONTA)) as CONTA_ESTOQUE,
    concat(trim(SB1.B1_YCTDEAD), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTDEAD)) as CONTA_DESPE,
    concat(trim(SB1.B1_YCTCUST), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTCUST)) as CONTA_CUSTO,
    concat(trim(SB1.B1_YCTATIV), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTATIV)) as CONTA_ATIVO,

    case SB1.B1_MSBLQL when 1 then 'S' else 'N' end as BLOQUEADO,
    case SB1.D_E_L_E_T_ when '*' then 'S' else 'N' end as EXCLUIDO
from SB1010 SB1 (nolock)
    inner join SBM010 SBM (nolock)
        on SBM.D_E_L_E_T_ = ''
        and SBM.BM_GRUPO = SB1.B1_GRUPO
