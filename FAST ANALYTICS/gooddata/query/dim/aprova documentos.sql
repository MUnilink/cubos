SELECT 'P |L' AS BK_APROV_COMPRA,
       'L' AS CODIGO_APROVCOMPRA,
       'Pedido Aprovado' AS DESCRICAO_APROVCOMPRA
UNION
SELECT 'P |B' AS BK_APROV_COMPRA,
       'B' AS CODIGO_APROVCOMPRA,
       'Aguardando Aprovacao' AS DESCRICAO_APROVCOMPRA
UNION
SELECT 'P |R' AS BK_APROV_COMPRA,
       'R' AS CODIGO_APROVCOMPRA,
       'Pedido Rejeitado' AS DESCRICAO_APROVCOMPRA
UNION
    select distinct
        trim(SCR010.CR_STATUS) as BK_APROV_COMPRA,
        trim(SCR010.CR_STATUS) as CODIGO_APROVCOMPRA,
        case SCR010.CR_STATUS
            when '01' then 'PENDENTE NIVEL'
            when '02' then 'PENDENTE'
            when '03' then 'LIBERADA'
            when '04' then 'BLOQUEADA'
            when '05' then 'LIBERADA OUTREM'
            when '06' then 'REJEITADA'
            when '07' then 'REJEITADA OUTREM'
            else 'OUTROS'
        end AS DESCRICAO_APROVCOMPRA
    from SCR010
    where SCR010.D_E_L_E_T_ = ' '
UNION
SELECT 'P ||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'
