select
	trim(SRT.RT_FILIAL) as FILIAL,
	substring(SRT.RT_DATACAL, 1, 6) as PERIODO,
	cast(SRT.RT_DATABAS as date) as DATA_BASE,
	trim(SRT.RT_MAT) as MAT,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRT.RT_VERBA) as VERBA,
	trim(SRV.RV_DESC) as RV_DESC,
	trim(SRV.RV_DESCDET) as RV_DESCDET,

	trim(SRT.RT_CC) as CC,
	trim(SRT.RT_ITEM) as ATIVIDADE,

	case trim(SRT.RT_TIPPROV)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRT.RT_FILIAL
				and SR7010.R7_MAT = SRT.RT_MAT
				and SR7010.R7_DATA <= SRT.RT_DATACAL
		), trim(SQ3.Q3_CARGO)
	) as CARGO_FOLHA,
	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRT.RT_FILIAL
				and SR7010.R7_MAT = SRT.RT_MAT
				and SR7010.R7_DATA <= SRT.RT_DATACAL
		), trim(SRJ.RJ_FUNCAO)
	) as FUNCAO_FOLHA,
	
	isnull
	(
		(
			select trim(SQ3010.Q3_DESCSUM)
			from SQ3010
			where
					SQ3010.D_E_L_E_T_ = ''
				and SQ3010.Q3_CARGO =
				(
					select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRT.RT_FILIAL
						and SR7010.R7_MAT = SRT.RT_MAT
						and SR7010.R7_DATA <= SRT.RT_DATACAL
				)
		), trim(SQ3.Q3_DESCSUM)
	) as DESC_CARGO,
	isnull
	(
		(
			select trim(SRJ010.RJ_DESC)
			from SRJ010
			where
					SRJ010.D_E_L_E_T_ = ''
				and SRJ010.RJ_FUNCAO =
				(
					select top 1 last_value(SR7010.R7_FUNCAO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRT.RT_FILIAL
						and SR7010.R7_MAT = SRT.RT_MAT
						and SR7010.R7_DATA <= SRT.RT_DATACAL
				)
		), trim(SRJ.RJ_DESC)
	) as DESC_FUNCAO,

	case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,

	SRT.RT_VALOR / isnull(nullif(
	(
		select sum(
			case when SRT010.RT_VERBA = 830 and SRT010.RT_TIPPROV = 1 then SRT010.RT_DFERVEN / 2.5
			else
				case when SRT010.RT_VERBA = 830 and SRT010.RT_TIPPROV = 2 then SRT010.RT_DFERPRO / 2.5
				else
					case when SRT010.RT_VERBA = 880 then SRT010.RT_DFERPRO / 2.5
					else
						case when SRT010.RT_VERBA = 890 and SRT010.RT_TIPPROV in (1, 2) then floor(datediff(month, SRT010.RT_DATABAS, SRT010.RT_DATACAL))
						else
							case when SRT010.RT_VERBA = 890 and SRT010.RT_TIPPROV = 3 then floor(datediff(month, SRT010.RT_DATACAL, concat('01/01/', year(SRT010.RT_DATACAL))))
							else isnull(nullif(SRT010.RT_AVOS13S, 0), 12)
							end
						end
					end
				end
			end
		)
		from SRT010 (nolock)
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = SRT.RT_FILIAL
			and SRT010.RT_MAT = SRT.RT_MAT
			and SRT010.RT_DATACAL = SRT.RT_DATACAL
			and SRT010.RT_VERBA in (830, 880, 890)
	), 0), -1*SRT.RT_VALOR) as PROV_MENSAL,

	isnull(nullif(
	(
		select sum(
			case when SRT010.RT_VERBA = 830 and SRT010.RT_TIPPROV = 1 then SRT010.RT_DFERVEN / 2.5
			else
				case when SRT010.RT_VERBA = 830 and SRT010.RT_TIPPROV = 2 then SRT010.RT_DFERPRO / 2.5
				else
					case when SRT010.RT_VERBA = 880 then SRT010.RT_DFERPRO / 2.5
					else
						case when SRT010.RT_VERBA = 890 and SRT010.RT_TIPPROV in (1, 2) then floor(datediff(month, SRT010.RT_DATABAS, SRT010.RT_DATACAL))
						else
							case when SRT010.RT_VERBA = 890 and SRT010.RT_TIPPROV = 3 then floor(datediff(month, SRT010.RT_DATACAL, concat('01/01/', year(SRT010.RT_DATACAL))))
							else isnull(nullif(SRT010.RT_AVOS13S, 0), 12)
							end
						end
					end
				end
			end
		)
		from SRT010 (nolock)
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = SRT.RT_FILIAL
			and SRT010.RT_MAT = SRT.RT_MAT
			and SRT010.RT_DATACAL = SRT.RT_DATACAL
			and SRT010.RT_VERBA in (830, 880, 890)
	), 0), -1) as AVO_MENSAL,

/*
	CASE
	WHEN SRT.RT_TIPPROV =  '1' THEN ROUND(SRT.RT_VALOR/(RT2.RT_DFERVEN/2.5),2)
	WHEN SRT.RT_TIPPROV =  '2' THEN ROUND(SRT.RT_VALOR/(RT2.RT_DFERPRO/2.5),2)
	WHEN SRT.RT_TIPPROV =  '3' THEN ROUND(SRT.RT_VALOR/RT2.RT_AVOS13S,2)
	END AS RD_VALOR,

	SRT.RT_VALOR /
	(
		select
			CASE
				WHEN SRT.RT_TIPPROV =  '1' THEN (SRT010.RT_DFERVEN / 2.5)
				WHEN SRT.RT_TIPPROV =  '2' THEN (SRT010.RT_DFERPRO / 2.5)
				WHEN SRT.RT_TIPPROV =  '3' THEN SRT010.RT_AVOS13S
			END
		from SRT010 (nolock)
		where 
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = SRT.RT_FILIAL
			and SRT010.RT_MAT = SRT.RT_MAT
			and SRT010.RT_DATACAL = SRT.RT_DATACAL
			and SRT010.RT_VERBA = 830
			and SRT010.RT_TIPPROV = 1
			and SRT010.RT_DATABAS != ''
	) as PROV_CUSTO,

" SELECT "
	" RA_CODFUNC, "
	" CASE "
	" WHEN SRT.RT_TIPPROV =  '1' THEN ROUND(SRT.RT_VALOR/(RT2.RT_DFERVEN/2.5),2)  "
	" WHEN SRT.RT_TIPPROV =  '2' THEN ROUND(SRT.RT_VALOR/(RT2.RT_DFERPRO/2.5),2)  "
	" WHEN SRT.RT_TIPPROV =  '3' THEN ROUND(SRT.RT_VALOR/RT2.RT_AVOS13S,2)  "
	" END AS RD_VALOR
" FROM "+RetSqlName("SRT")+" SRT "
	" INNER JOIN "+RetSqlName("SRA")+" SRA "
	" ON RA_FILIAL='"+xFilial("SRA")+"' AND RA_MAT=SRT.RT_MAT AND SRA.D_E_L_E_T_=' ' "
	" INNER JOIN "+RetSqlName("SRT")+" RT2 "
	" ON RT2.RT_FILIAL = RA_FILIAL AND RT2.RT_MAT = RA_MAT AND RT2.RT_TIPPROV = '1' AND RT2.RT_VERBA = '830' AND RT2.RT_DATABAS <> ' '  AND RT2.D_E_L_E_T_ = ' ' AND RT2.RT_DATACAL = SRT.RT_DATACAL "
" WHERE  "
	" SRT.RT_FILIAL='"+xFilial("SRT")+"' "
	" AND SUBSTRING(SRT.RT_DATACAL,1,6) = '"+SUBSTR(DTOS(::dDataIni),1,6)+"'  "
	" AND SRT.RT_VERBA IN (
		For nCont:=1 to Len(aVerbas)
			If nCont>1
				cQuery	+= ","
			EndIf
			cQuery	+= "'"+aVerbas[nCont]+"'"
		Next
		For nCont1:=1 to Len(aVerbas1)
			If nCont1>1
				cQuery	+= ","
			EndIf
			cQuery	+= "'"+aVerbas1[nCont1]+"'"
		Next
	" )"
	" AND SRT.D_E_L_E_T_=' ' "
	" AND SRA.D_E_L_E_T_=' ') AS FOLHA "
	" GROUP BY RA_CODFUNC "
	" )
*/
	(
		select sum()
		from SRT010 RT2
			on RT2.RT_FILIAL = SRT.RT_FILIAL
			and RT2.RT_MAT = SRT.RT_MAT
			and RT2.RT_TIPPROV = '1'
			and RT2.RT_VERBA = '830'
			and RT2.RT_DATABAS <> ' '
			and RT2.D_E_L_E_T_ = ' '
			and RT2.RT_DATACAL = SRT.RT_DATACAL
	)
	SRT.RT_VALOR as PROV_ACUMULADA,
	SRT.RT_DFERPRO as AVO_FERPRO,
	SRT.RT_AVOS13S as AVOS_13,

	case when SRT.RT_VERBA = 830 then 2.5 * SRT.RT_SALARIO/30 else case when SRT.RT_VERBA in (880, 890) then 2.5 * SRT.RT_SALARIO/30 else 0.0 end end as VL_FERIAS,
	case when SRT.RT_VERBA = 830 then 2.5 * SRT.RT_SALARIO/90 else case when SRT.RT_VERBA in (880, 890) then 2.5 * SRT.RT_SALARIO/90 else 0.0 end end as VL_FTERC,
	case when SRT.RT_VERBA = 830 then .08 * 2.5 * SRT.RT_SALARIO/30 else case when SRT.RT_VERBA in (880, 890) then .08 * 2.5 * SRT.RT_SALARIO/30 else 0.0 end end as VL_FFGTS,
	case when SRT.RT_VERBA = 830 then .14 * 2.5 * SRT.RT_SALARIO/90 else case when SRT.RT_VERBA in (880, 890) then .14 * 2.5 * SRT.RT_SALARIO/90 else 0.0 end end as VL_FINSS,
	case when month(SRT.RT_DATACAL) = 12 then 2.5 * SRT.RT_SALARIO/30 else 2.5 * SRT.RT_SALARIO/30 end as VL_DECIMO,
	case when month(SRT.RT_DATACAL) = 12 then .08 * 2.5 * SRT.RT_SALARIO/30 else .08 * 2.5 * SRT.RT_SALARIO/30 end as VL_13FGTS,
	case when month(SRT.RT_DATACAL) = 12 then .14 * 2.5 * SRT.RT_SALARIO/30 else .14 * 2.5 * SRT.RT_SALARIO/30 end as VL_13INSS,

	SRT.RT_DFERVEN as DIAS_FERVENC,
	isnull(nullif(SRT.RT_DFERVEN, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERVENC,
	SRT.RT_DFERPRO as DIAS_FERPROP,
	isnull(nullif(SRT.RT_DFERPRO, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERPROP,
	SRT.RT_DFERANT as DIAS_FERANTP,
	isnull(nullif(SRT.RT_DFERANT, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERANTP,
	SRT.RT_DFALVEN as DIAS_FALFERV,
	isnull(nullif(SRT.RT_DFALVEN, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FALFERV,
	SRT.RT_DFALPRO as DIAS_FALFERP,
	isnull(nullif(SRT.RT_DFALPRO, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FALFERP,
	SRT.RT_SALARIO as SALARIO_BASE

from SRT010 SRT (nolock)
    inner join SRV010 SRV (nolock)
    	on SRV.D_E_L_E_T_ = ''
        and substring(SRT.RT_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRT.RT_VERBA = SRV.RV_COD
    inner join SRA010 SRA (nolock)
    	on SRA.D_E_L_E_T_ = ''
    	and SRA.RA_FILIAL = SRT.RT_FILIAL
    	and SRA.RA_MAT = SRT.RT_MAT

    	inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
		left join SQ3010 SQ3 (nolock)
			on SQ3.D_E_L_E_T_ = ''
			and SQ3.Q3_CARGO = SRA.RA_CARGO
    
	inner join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SRT.RT_CC
    inner join CTD010 CTD (nolock)
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SRT.RT_ITEM
where
        SRT.D_E_L_E_T_ = ''
