select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,
    
    STZ.TZ_ORDEM,
    convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as DATA_ENT,
    STZ.TZ_POSCONT,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as DATA_SAI,
    STZ.TZ_CONTSAI,

    abs(STZ.TZ_CONTSAI - STZ.TZ_POSCONT) as km,

	STZ.TZ_BEMPAI as ESTRUTURA,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	trim(concat(cast(STZ.TZ_CAUSA as int), ' - ' , ST8.T8_NOME)) as DESTINO_PNEU, /* quando com análise sem movimento, retorna o destino do movimento */

    (
        select top 1
            case when STZ.TZ_CAUSA = 7 then concat(convert(datetimeoffset, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 113), ' SEM ANALISE (RODIZIO)') /* QUANDO MOVIMENTO DE RODIZIO*/
            else
                case when STZ.TZ_CAUSA = 8 and TR4010.TR4_MOTIVO = 30 then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO MOVIMENTO DE RETORNO AO ESTOQUE E ANALISE DE AJUSTE */
                else
                    case when STZ.TZ_CAUSA = 8 and TR4010.TR4_MOTIVO != 30 then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' - AJUSTE STATUS N° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO MOVIMENTO DE RETORNO AO ESTOQUE E ANALISE DIFERENTE DE AJUSTE */
                    else
                        case when STZ.TZ_CAUSA = '' then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO SEM CAUSA DE MOVIMENTO */
                        else
                            concat(convert(datetimeoffset, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113), ' - ')
                        end
                    end
                end
            end
        from TR4010 (nolock)
            inner join ST8010 (nolock)
                on ST8010.D_E_L_E_T_ = ''
                and ST8010.T8_CODOCOR = TR4010.TR4_MOTIVO
            inner join SX5010 (nolock)
                on SX5010.D_E_L_E_T_ = ''
                and SX5010.X5_TABELA = 'DP'
                and cast(SX5010.X5_CHAVE as int) = cast(TR4010.TR4_DESTIN as int)
        where
                TR4010.D_E_L_E_T_ = ''
            and TR4010.TR4_CODBEM = TQS.TQS_CODBEM
            and TR4010.TR4_DTANAL + TR4010.TR4_HRANAL >= STZ.TZ_DATASAI + STZ.TZ_HORASAI
        order by TR4010.TR4_DTANAL asc
    ) as ANALISE_SAI,
    (
        select top 1
            case when STZ.TZ_CAUSA = 7 then concat(convert(datetimeoffset, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 113), ' SEM ANALISE (RODIZIO)') /* QUANDO MOVIMENTO DE RODIZIO*/
            else
                case when STZ.TZ_CAUSA = 8 and TR4010.TR4_MOTIVO = 30 then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO MOVIMENTO DE RETORNO AO ESTOQUE E ANALISE DE AJUSTE */
                else
                    case when STZ.TZ_CAUSA = 8 and TR4010.TR4_MOTIVO != 30 then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' AJUSTE STATUS N° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO MOVIMENTO DE RETORNO AO ESTOQUE E ANALISE DIFERENTE DE AJUSTE */
                    else
                        case when STZ.TZ_CAUSA = '' then concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113), +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + TR4010.TR4_MOTIVO + ' ' + trim(ST8010.T8_NOME) + ')') /* QUANDO SEM CAUSA DE MOVIMENTO */
                        else
                            concat(convert(datetimeoffset, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113), ' - ')
                        end
                    end
                end
            end
        from TR4010 (nolock)
            inner join ST8010 (nolock)
                on ST8010.D_E_L_E_T_ = ''
                and ST8010.T8_CODOCOR = TR4010.TR4_MOTIVO
            inner join SX5010 (nolock)
                on SX5010.D_E_L_E_T_ = ''
                and SX5010.X5_TABELA = 'DP'
                and cast(SX5010.X5_CHAVE as int) = cast(TR4010.TR4_DESTIN as int)
        where
                TR4010.D_E_L_E_T_ = ''
            and TR4010.TR4_CODBEM = TQS.TQS_CODBEM
            and TR4010.TR4_DTANAL + TR4010.TR4_HRANAL <= STZ.TZ_DATAMOV + STZ.TZ_HORAENT
        order by TR4010.TR4_DTANAL desc
    ) as ANALISE_ENT/*,

    (
        select STJ010.TJ_CUSTTER
        from STJ010 (nolock)
        where
                STJ010.D_E_L_E_T_ = ''
            and STJ010.TJ_CODBEM = TQS.TQS_CODBEM
            and STJ010.TJ_DTMRFIM <= STZ.TZ_DATAMOV
    ) as CUSTO*/

from TQS010 TQS (nolock)
    inner join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join STZ010 STZ (nolock)
        on STZ.D_E_L_E_T_ = ''
        and STZ.TZ_CODBEM = TQS.TQS_CODBEM

        left join ST8010 ST8 (nolock)
			on ST8.D_E_L_E_T_ = ''
			and ST8.T8_CODOCOR = STZ.TZ_CAUSA
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS

where TQS.D_E_L_E_T_ = ''
