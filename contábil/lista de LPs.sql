select
    trim(CT5.CT5_LANPAD) as LP,
    trim(CT5.CT5_SEQUEN) as SEQ,
    case CT5.CT5_STATUS when 1 then 'ATIVO' when 2 then 'INATIVO' else null end as STATUS,
    trim(CT5.CT5_DESC) as DESCRICAO,
    CT5.CT5_DC as DEBCRE,
    trim(CT5.CT5_VLR01) as VALOR,
    trim(CT5.CT5_HAGLUT) as AGLUT,
    trim(CT5.CT5_ORIGEM) as ORIGEM,
    trim(CT5.CT5_DEBITO) as CDEBITO,
    trim(CT5.CT5_CREDIT) as CCREDIT,
    trim(CT5.CT5_CCD) as CC_DEB,
    trim(CT5.CT5_CCC) as CC_CRE,
    trim(CT5.CT5_ITEMD) as ATIV_DEB,
    trim(CT5.CT5_ITEMC) as ATIV_CRE,
    trim(CT5.CT5_HIST) as HISTORICO
from CT5010 CT5 (nolock)
where CT5.D_E_L_E_T_ = ''
