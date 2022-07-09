select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_NUMVGA,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DA8.DA8_DESC,

	REG_COL_DT6.*,
	REG_ENT_DUD.*,

    (
        select trim(DUY010.DUY_GRPVEN)
        from DUD010 (nolock)
            left join DT6010 (nolock)
                on DT6010.D_E_L_E_T_ = ''
                and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                and DT6010.DT6_DOC = DUD010.DUD_DOC
                and DT6010.DT6_SERIE = DUD010.DUD_SERIE
                
                inner join DUY010 (nolock)
                    on DUY010.D_E_L_E_T_ = ''
                    and DUY010.DUY_GRPVEN = DT6010.DT6_CDRDES
        where
                DUD010.D_E_L_E_T_ = ''
            and DUD010.DUD_VIAGEM = DUD.DUD_VIAGEM
            and trim(DUD010.DUD_SERIE) = 'COL'
    ) as GRP_ENT_doc,
    
    DT6.DT6_VALFRE / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DF1.DF1_NUMAGE,
    DF1.DF1_ITEAGE,

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
                trim(DUY010.DUY_GRPVEN) as GRP_ENT_dud,
                trim(DUY010.DUY_EST) as EST_ENT_dud,
                trim(DUY010.DUY_DESCRI) as MUN_ENT_dud
            from DUY010 (nolock)
            where DUY010.D_E_L_E_T_ = ''
        ) AS REG_ENT_DUD
        on REG_ENT_DUD.GRP_ENT_dud = DUD.DUD_CDRDES

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
            on REG_COL_DT6.GRP_COL = DT6.DT6_CDRORI

            left join SA1010 SA1 (nolock)
                on SA1.D_E_L_E_T_ = ''
                and SA1.A1_COD = DT6.DT6_CLIDEV
                and SA1.A1_LOJA = DT6.DT6_LOJDEV
            left join DTC010 DTC (nolock)
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILORI = DT6.DT6_FILDOC
                and DTC.DTC_DOC = DT6.DT6_DOC
                and DTC.DTC_SERIE = DT6.DT6_SERIE

                left join DF1010 DF1 (nolock)
                    on DF1.D_E_L_E_T_ = ''
                    and DF1.DF1_FILDOC = DTC.DTC_FILORI
                    and DF1.DF1_DOC = DTC.DTC_NUMSOL
where 
        DTQ.D_E_L_E_T_ = ''
