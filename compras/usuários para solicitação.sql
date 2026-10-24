    select
        'PC' as TIPO,
        USR.USR_ID as COD_USR,
        upper(trim(USR.USR_CODIGO)) as LOGIN,
        upper(trim(USR.USR_NOME)) as USUARIO,
        upper(trim(USR.USR_CARGO)) as CARGO,
        case when USR.USR_MSBLQL = 2 then 'S' else 'N' end as PODE_SOLICITAR
    from SY1010 SY1 (nolock)
        inner join SYS_USR USR (nolock)
            on USR.D_E_L_E_T_ = ''
            and USR.USR_ID = SY1.Y1_USER
union
    select
        'SC' as TIPO,
        USR.USR_ID as COD_USR,
        upper(trim(USR.USR_CODIGO)) as LOGIN,
        upper(trim(USR.USR_NOME)) as USUARIO,
        upper(trim(USR.USR_CARGO)) as CARGO,
        case when SAI.D_E_L_E_T_ = '' or USR.USR_MSBLQL = 2 then 'S' else 'N' end as PODE_SOLICITAR
    from SAI010 SAI (nolock)
        inner join SYS_USR USR (nolock)
            on USR.D_E_L_E_T_ = ''
            and USR.USR_ID = SAI.AI_USER
union
    select distinct
        'SA' as TIPO,
        USR.USR_ID as COD_USR,
        upper(trim(USR.USR_CODIGO)) as LOGIN,
        upper(trim(USR.USR_NOME)) as USUARIO,
        upper(trim(USR.USR_CARGO)) as CARGO,
        case when USR.USR_MSBLQL = 2 then 'S' else 'N' end as PODE_SOLICITAR
    from SCP010 SCP (nolock)
        inner join SYS_USR USR
            on USR.D_E_L_E_T_ = ''
            and USR.USR_ID = SCP.CP_USER
    where
            SCP.D_E_L_E_T_ = ''
        and SCP.CP_EMISSAO >=:SA_DESDE_DATA
