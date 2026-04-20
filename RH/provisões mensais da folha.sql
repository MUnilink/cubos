select
    SRT.RT_FILIAL,
    SRT.RT_MAT,
    SRT.RT_DATACAL,
    SRT.RT_TIPPROV,
    SRT.RT_VERBA,
    sum(SRT.RT_DFERVEN) as DIAS_FERVENC,
    sum(SRT.RT_DFERPRO) as DIAS_FERPROP,
    sum(SRT.RT_DFERANT) as DIAS_FERANTP,
    cast(sum(SRT.RT_VALOR) as numeric(15, 2)) as RT_VALOR,
    case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRT.RT_VERBA || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,
    
    sum(SRT.RT_VALOR) /
	(
		select sum(
			case when SRT010.RT_VERBA in (830, 880) then isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5
				else
				case when SRT010.RT_VERBA = 890 then isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5
					else isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5
				end
			end)
		from SRT010 (nolock)
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = SRT.RT_FILIAL
			and SRT010.RT_MAT = SRT.RT_MAT
			and SRT010.RT_DATACAL = SRT.RT_DATACAL
			and SRT010.RT_VERBA in (830, 880, 890)
	) as PROV_MENSAL
from SRT010 SRT (nolock)
where
        SRT.D_E_L_E_T_ = ''
group by
    SRT.RT_FILIAL,
    SRT.RT_MAT,
    SRT.RT_DATACAL,
    SRT.RT_TIPPROV,
    SRT.RT_VERBA
