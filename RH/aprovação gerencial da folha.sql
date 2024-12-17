select
    SRC.RC_FILIAL as FILIAL,
    SRC.RC_PERIODO as PERIODO,
    substring(SRC.RC_PERIODO, 5, 6) as PERIODO_MES,
    substring(SRC.RC_PERIODO, 1, 4) as PERIODO_ANO,
    SRC.RC_MAT as MATRICULA,
    SRC.RC_PD as VERBA,
    SRC.RC_SEQ as SEQ,
    SRC.RC_ROTEIR as ROTEIRO,
    CTT010.CTT_DESC01 as CC,
    CTD010.CTD_DESC01 as ATIVIDADE,
    SRA010.RA_NOME as NOME,
    SRA010.RA_SITFOLH as SITUACAO,

    case
        when SRV.RV_COD in ('029', '111', '112', '113', '344') then 'HORAS_EXTRAS'
        when SRV.RV_COD in ('113', '451', '452') then 'DOBRAS_PROVENTOS'
        when SRV.RV_COD in ('623') then 'DOBRAS_DESCONTOS'
        when SRV.RV_COD in ('030', '041', '371', '372') then 'ADICIONAL_NOTURNO'
        when SRV.RV_COD in ('039', '096', '097', '215', '356', '013') then 'PERICULOSIDADES'
        when SRV.RV_COD in ('285', '561', '796') then 'VALE_TRANSPORTE'
        when SRV.RV_COD in ('410', '560', '563', '719') then 'VALE_ALIMENTACAO'
        when SRV.RV_COD in ('562', '749') then 'VALE_CESTA'
        when SRV.RV_COD in ('738') then 'PLANO_SAUDE'
        when SRV.RV_COD in ('056', '570', '574', '575', '576', '577', '711') then 'PLANO_ODONTOLOGICO'
        when SRV.RV_COD in ('057') then 'DIARIAS_VIAGEM'
        when SRV.RV_COD in ('132', '133') then 'FERIAS_COMPRADAS'
        when SRV.RV_COD in ('001', '147', '450') then 'ADIANTAMENTO'
        when SRV.RV_COD in ('147') then 'ARR_ADIANTAMENTO'
        when SRV.RV_COD in ('421') then 'IR_ADIANTAMENTO'
        when SRV.RV_COD in ('510', '009', '010', '011', '017', '167', '202', '290', '304', '768', '769', '770', '772') then 'PRIMEIRA_13'
        when SRV.RV_COD in ('306') then 'SEGUNDA_13_MEDIAHORAS'
        when SRV.RV_COD in ('307') then 'SEGUNDA_13_MEDIAVALOR'
        when SRV.RV_COD in ('208') then 'SEGUNDA_13_ADICRISCO'
    else trim(coalesce(SRV.RV_DESCDET, SRV.RV_DESC, '')) end as NOME_VERBA,
    SRC.RC_VALOR as VALOR

from SRC010 SRC (nolock)
    inner join SRA010 (nolock)
        on SRA010.D_E_L_E_T_ = ''
        and SRA010.RA_FILIAL = SRC.RC_FILIAL
        and SRA010.RA_MAT = SRC.RC_MAT
        and trim(SRC.RC_MAT) not in ('003264', '003263')

    left join CTD010 (nolock)
        on CTD010.D_E_L_E_T_ = ''
        and CTD010.CTD_ITEM = SRC.RC_ITEM
    left join CTT010 (nolock)
        on CTT010.D_E_L_E_T_ = ''
        and CTT010.CTT_CUSTO = SRC.RC_CC
    left join SRV010 SRV (nolock)
        on SRV.RV_COD = SRC.RC_PD
where SRC.D_E_L_E_T_ = ''
