select
	ZD3.ZD3_KMRD,
	cast(ZD3.ZD3_DATA as date) as ZD3_DATA,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	ZD3.TQN_CCUSTO as TQN_CCUSTO,
	ZD3.TQN_YITMCT as TQN_YITMCT,
    
    STZ.PNEU,
    case when STZ.TZ_DATAMOV < dateadd(month, -1, eomonth(ZD3.ZD3_DATA)) then dateadd(month, -1, eomonth(ZD3.ZD3_DATA)) else STZ.TZ_DATAMOV end as DATA_INI, /* se aplicado antes do mês*/
    case when STZ.TZ_DATASAI > eomonth(ZD3.ZD3_DATA) or STZ.TZ_DATASAI = '' then eomonth(ZD3.ZD3_DATA) else STZ.TZ_DATASAI end as DATA_FIM /* se desaplicado após o mês ou se ainda aplicado*/
from
	(
		select
			case cast(ZD30.ZD3_TANQUE as int) when 12 then '010102' else trim(isnull(ZD30.ZD3_FILIAL, '-')) end as ZD3_FILIAL,
			ZD30.ZD3_KM as ZD3_HODOM,
			ZD30.ZD3_VEICUL,
			ZD30.ZD3_LITROS,
			ZD30.ZD3_TOTAL,
			ZD30.ZD3_TANQUE,
			ZD30.ZD3_COMB,
			substring(ZD30.ZD3_DATA, 1, 8) as ZD3_DATA,
			ZD30.ZD3_KML,
			ZD30.ZD3_KMRD,

			(
				select TQN010.TQN_CCUSTO
				from TQN010
				where
						TQN010.D_E_L_E_T_ = ''
					and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
					and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
					and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
			) as TQN_CCUSTO,
			(
				select
					case when TQN010.TQN_YITMCT is not null and TQN010.TQN_YITMCT != '' then TQN010.TQN_YITMCT
					else
						case TQN010.TQN_CCUSTO
							when 302 then 11
							when 304 then 11
							when 303 then 21
							when 305 then 21
							when 306 then 21
							else 90
						end
					end
				from TQN010 (nolock)
				where
						TQN010.D_E_L_E_T_ = ''
					and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
					and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
					and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
			) as TQN_YITMCT		
		from ZD3010 ZD30 (nolock)
		where ZD30.D_E_L_E_T_ = ''
	) as ZD3

	left join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = ZD3.ZD3_VEICUL
    
    left join
    (
        select
            ST9.T9_CODBEM as PNEU,
            STZ010.TZ_BEMPAI as ESTRUTURA,
            CM.T9_TEMCONT,
            STZ010.TZ_LOCALIZ,
            cast(STZ010.TZ_DATAMOV as date) as TZ_DATAMOV,
            cast(STZ010.TZ_DATASAI as date) as TZ_DATASAI

        from ST9010 ST9 (nolock)
            inner join STZ010
                on STZ010.D_E_L_E_T_ = ' '
                and STZ010.TZ_CODBEM = ST9.T9_CODBEM
                
                inner join ST9010 CM
                    on CM.T9_CODBEM = STZ010.TZ_BEMPAI
                    and CM.T9_TEMCONT = 'S'
                    and CM.D_E_L_E_T_ = ' '
            where
                    ST9.T9_CATBEM = '3'
                and ST9.D_E_L_E_T_ = ' '
    ) STZ
    on STZ.ESTRUTURA = ZD3.ZD3_VEICUL
    and
    (
        (dateadd(month, -1, eomonth(ZD3.ZD3_DATA)) >= STZ.TZ_DATAMOV and eomonth(ZD3.ZD3_DATA) <= STZ.TZ_DATASAI) /* se aplicação antes do mês e desaplicação depois do mês de competência */
        or
        (STZ.TZ_DATAMOV <= dateadd(month, -1, eomonth(ZD3.ZD3_DATA)) and STZ.TZ_DATASAI = ' ') /* se aplicado antes do mês e não retirado*/
    )
where ZD3.ZD3_VEICUL in ('RS16', 'CM3009')