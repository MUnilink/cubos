select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DA8.DA8_DESC,
    DTQ.DTQ_KMVGE,

    REG_COL_DUD.*,
	REG_COL_DUD.*,
	REG_ENT_DT6.*,
	REG_ENT_DT6.*,
    
    DT6.DT6_VALFRE / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    SA1.A1_COD,
    SA1.A1_LOJA,
    SA1.A1_NOME,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as COMPETENCIA

from DTQ010 DTQ (nolock)
    inner join DA8010 DA8 (nolock)
        on DA8.D_E_L_E_T_ = ''
        and DA8.DA8_COD = DTQ.DTQ_ROTA
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM
    
        left join
        (
            select
                trim(DUY010.DUY_GRPVEN) as GRP_COL,
                trim(DUY010.DUY_EST) as EST_COL,
                trim(DUY010.DUY_DESCRI) as MUN_COL
            from DUY010 (nolock)
            where DUY010.D_E_L_E_T_ = ''
        ) AS REG_COL_DUD
        on REG_COL.GRP_COL = DUD.DUD_CDRORI

        left join
        (
            select
                trim(DUY010.DUY_GRPVEN) as GRP_ENT,
                trim(DUY010.DUY_EST) as EST_ENT,
                trim(DUY010.DUY_DESCRI) as MUN_ENT
            from DUY010 (nolock)
            where DUY010.D_E_L_E_T_ = ''
        ) AS REG_ENT_DUD
        on REG_ENT.GRP_ENT = DUD.DUD_CDRDES

		left join DT6010 DT6 (nolock)
			on DT6.D_E_L_E_T_ = ''
			and DT6.DT6_FILDOC = DUD.DUD_FILDOC
			and DT6.DT6_DOC = DUD.DUD_DOC
			and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join
            (
                select
                    trim(DUY010.DUY_GRPVEN) as GRP_COL,
                    trim(DUY010.DUY_EST) as EST_COL,
                    trim(DUY010.DUY_DESCRI) as MUN_COL
                from DUY010 (nolock)
                where DUY010.D_E_L_E_T_ = ''
            ) AS REG_COL_DT6
            on REG_COL.GRP_COL = DT6.DT6_CDRORI

            left join
            (
                select
                    trim(DUY010.DUY_GRPVEN) as GRP_ENT,
                    trim(DUY010.DUY_EST) as EST_ENT,
                    trim(DUY010.DUY_DESCRI) as MUN_ENT
                from DUY010 (nolock)
                where DUY010.D_E_L_E_T_ = ''
            ) AS REG_ENT_DT6
            on REG_ENT.GRP_ENT = DT6.DT6_CDRDES

            left join SA1010 SA1 (nolock)
                on SA1.D_E_L_E_T_ = ''
                and SA1.A1_COD = DT6.DT6_CLIDEV
                and SA1.A1_LOJA = DT6.DT6_LOJDEV
where 
        DTQ.D_E_L_E_T_ = ''
