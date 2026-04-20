select
	trim(PNE.T9_CODBEM) as PNEU,
	trim(EST.T9_CODBEM) as ESTRUTURA,
	SB1.B1_COD as PRODUTO,
	PNE.T9_CCUSTO as CC,
	PNE.T9_ITEMCTA as ATIVIDADE,
    PNE.T9_LOCPAD as ARMAZEM,
    PNE.T9_SITBEM as SITUACAO,
	TQS.TQS_MEDIDA,
    trim(TQT.TQT_DESMED) as MEDIDA,
	PNE.T9_STATUS as STATUS,
    trim(TQY.TQY_DESTAT) as DESC_STATUS,
    PNE.T9_CONTACU as CONT_ACUM,
    STC.TC_LOCALIZ as POSICAO,
    cast(STC.TC_DATAINI as date) as DATA_INI

from STC010 STC (nolock)
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STC.TC_COMPONE

		inner join ST9010 PNE (nolock)
			on PNE.D_E_L_E_T_ = ''
			and PNE.T9_CODBEM = TQS.TQS_CODBEM
			and PNE.T9_CATBEM = 3

			inner join TQY010 TQY (nolock)
				on TQY.D_E_L_E_T_ = ''
				and TQY.TQY_STATUS = PNE.T9_STATUS
		
		inner join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
			
			left join SB1010 SB1 (nolock)
				on SB1.D_E_L_E_T_ = ''
				and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA

	inner join ST9010 EST (nolock)
		on EST.D_E_L_E_T_ = ''
		and EST.T9_CODBEM = STC.TC_CODBEM
		and EST.T9_CATBEM != 3
where
        STC.D_E_L_E_T_ = ''
