select
    trim(SAL.AL_DESC) as GRUPO,
    trim(SAK.AK_LOGIN) as NOME,
    trim(SAL.AL_COD) as 'Grupo Aprovacao',
    trim(SAL.AL_ITEM) as 'Item Grupo',
    trim(SAL.AL_APROV) as 'Codigo Aprovador',
    trim(SAL.AL_PERFIL) as 'Perfil Aprovador',
    trim(SAL.AL_USER) as 'Codigo Usuário',
    trim(SAL.AL_NIVEL) as 'Nivel Aprovação',
    trim(SAL.AL_USERSUP) as 'Usuario superior',
    
    case SAL.AL_LIBAPR when 'V' then 'VISTO' when 'A' then 'APROVADOR' end as 'Tipo de Aprovacao',
    case SAL.AL_AUTOLIM when 'S' then 'SIM' when 'N' then 'NÃO' end as 'Utiliza Limite ',
    case SAL.AL_TPLIBER when 'U' then 'USUÁRIO' when 'N' then 'NÍVEL' when 'P' then 'DOCUMENTO' end as 'Tipo de liberacao',

    case SAL.AL_DOCAE when 'T' then 'V' end as 'Autorização de Entrega',
    case SAL.AL_DOCCO when 'T' then 'V' end as 'Cotações',
    case SAL.AL_DOCCP when 'T' then 'V' end as 'Contrato de Parceria',
    case SAL.AL_DOCMD when 'T' then 'V' end as 'Medições',
    case SAL.AL_DOCNF when 'T' then 'V' end as 'Nota Fiscal',
    case SAL.AL_DOCPC when 'T' then 'V' end as 'Pedido de Compra',
    case SAL.AL_DOCSA when 'T' then 'V' end as 'Solicitações ao Armazém',
    case SAL.AL_DOCSC when 'T' then 'V' end as 'Solicitações de Compra',
    case SAL.AL_DOCST when 'T' then 'V' end as 'Solicitação de Transf. ',
    case SAL.AL_DOCIP when 'T' then 'V' end as 'Item do Pedido',
    case SAL.AL_DOCCT when 'T' then 'V' end as 'Tipo do Contrato',
    case SAL.AL_DOCGA when 'T' then 'V' end as 'Documento de garantia',
    case SAL.AL_AGRCNNG when 'T' then 'V' end as 'Documento Agroindustria',
    case SAL.AL_DOCTP when 'T' then 'V' end as 'Título a Pagar',
    case SAL.AL_DOCPV when 'T' then 'V' end as 'Pedido de Venda',
    case SAL.AL_DOCDV when 'T' then 'V' end as 'Desconto Pedido de Venda',
    case SAL.AL_MSBLQL when 1 then 'BLQ' when 2 then 'LIB' else 'N/A' end as BLOQUEADO

from SAL010 SAL (nolock)
    inner join SAK010 SAK (nolock)
        on SAK.D_E_L_E_T_ = ''
        and SAK.AK_COD = SAL.AL_APROV
where SAL.D_E_L_E_T_ = ''
