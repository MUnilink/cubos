select
    USR.USR_ID as COD_USR,
    trim(SAI.AI_ITEM) as ITEM_SOLIC,
    USR.USR_CODIGO as LOGIN,
    USR.USR_NOME as USUARIO,
    USR.USR_CARGO as LOTE
from SAI010 SAI (nolock)
    inner join SYS_USR USR (nolock)
        on USR.D_E_L_E_T_ = ''
        and USR.USR_ID = SAI.AI_USER
where SAI.D_E_L_E_T_ = ''
