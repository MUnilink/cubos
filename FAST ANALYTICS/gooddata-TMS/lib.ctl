//===============================================//
//           DEFINIÇÃO DE CONSTANTES             //
//===============================================//
//Definição de fuso horário.
string DATE_TIMEZONE = "${DATE_TIMEZONE}";
integer DATE_TIMEZONE_OFFSET = getTimezoneOffset(DATE_TIMEZONE);

//Controle de base de demonstração.
date GOODDATA_DEMO_DATE;
string GOODDATA_DEMO_MODE = upperCase("${DEMO_MODE}");
if (GOODDATA_DEMO_MODE == "S") { GOODDATA_DEMO_DATE = str2date("${DEMO_DATE}", "${DATE_PATTERN}", "${DATE_LOCALE}"); }

//Valor máximo permitido no GoodData.
double GOODDATA_MAXVALUE = str2double("${NUMBER_MAXSIZE}", "${NUMBER_PATTERN}","${NUMBER_LOCALE}");

//Datas mínima / máxima permitidas no GoodData.
date GOODDATA_MINDATE = str2date("${GOODDATA_MINDATE}", "yyyy-MM-dd");
date GOODDATA_MAXDATE = str2date("${GOODDATA_MAXDATE}", "yyyy-MM-dd");

//Mês / Ano atual.
string THIS_MONTH = right(left(date2str(today(), "dd/MM/yyyy"), 5), 2);
string THIS_YEAR = right(date2str(today(), "dd/MM/yyyy"), 4);

//Data de corte do ETL (Controle de tamanho de base).
long MONTHS_TO_LOAD = str2long("${MONTHS_TO_LOAD}");
date ETL_MAXDATE = dateAdd(str2date("01/" + THIS_MONTH + "/" + THIS_YEAR, "dd/MM/yyyy"), -1*MONTHS_TO_LOAD, month);

//===============================================//
//            DEFINIÇÃO DE VARIÁVEIS             //
//===============================================//
date data;
string TipoPessoa;

//===============================================//
//            FUNÇÕES DA BIBLIOTECA              //
//===============================================//
function decimal formatMoney(decimal format, decimal cotacao) {
    if ((cotacao == 0) or (cotacao == null)) cotacao = 1;
    
    return 1.000000 * cotacao * format;
}

// Função que retorna a posição do fuso horário, em minutos.
function integer getTimezoneOffset(string timezone) {
	if (length(timezone) != 5) {
		return 0;
	} else {
		string timezone_minute = right(timezone, 2);
		string timezone_hour = left(right(timezone, 4), 2);
		string timezone_signal = left(right(timezone, 5), 1);
		return str2integer(timezone_signal + "1") * (str2integer(timezone_hour) * 60 + str2integer(timezone_minute));
	}
}

// Função que retorna o número de segundos passados em determinada data/hora.
function obj_dto getSecondsFromTime(date data) {
	
	obj_dto dto;
	
	//Calcula o ajuste de fuso horário de acordo com a configuração de data/hora do servidor de aplicação.
    integer offset = DATE_TIMEZONE_OFFSET - getTimezoneOffset(date2str(data, "Z", "${DATE_LOCALE}"));
    
    //Recalcula a variável de data com o fuso horário correto.
	dto.Data = dateAdd(data, offset, minute);
	
	//Calcula o número de segundos existentes na data.
    integer dt_hour = date2num(extractTime(dto.Data), hour, "${DATE_LOCALE}");
    integer dt_minute = date2num(extractTime(dto.Data), minute, "${DATE_LOCALE}");
    integer dt_second = date2num(extractTime(dto.Data), second, "${DATE_LOCALE}");
    
	dto.Offset_seconds = dt_hour * 3600 + dt_minute * 60 + dt_second;
	
	return dto;
}

// Função de tratamento de campos tipo decimal.
function decimal formatDecimal(string format, boolean random) {
    if ((format == null) or (trim(format) == "")) {
        return 0;
    } else {
        if (str2decimal(trim(format), "${NUMBER_PATTERN}", "${NUMBER_LOCALE}") >= GOODDATA_MAXVALUE) {
            return 0;
        } else {
            if (GOODDATA_DEMO_MODE == "S") {
                if (random) {
                    return (0.5 + random())*str2decimal(trim(format), "${NUMBER_PATTERN}", "${NUMBER_LOCALE}");
                } else {
                    return str2decimal(trim(format), "${NUMBER_PATTERN}", "${NUMBER_LOCALE}");
                }
            } else {
                return str2decimal(trim(format), "${NUMBER_PATTERN}", "${NUMBER_LOCALE}");
            }
        }
    }
}

// Função de tratamento de campos tipo long.
function long formatLong(string  format) {
    if ((format == null) or (trim(format) == "")) {
        return 0;
    } else {
        if (abs(str2long(trim(format), "${NUMBER_PATTERN}", "${NUMBER_LOCALE}")) >= GOODDATA_MAXVALUE) {
            return 0;
        } else {
            if (GOODDATA_DEMO_MODE == "S") {
                return round(random()*str2long(format, "${NUMBER_PATTERN}", "${NUMBER_LOCALE}"));
            } else {
                return str2long(format, "${NUMBER_PATTERN}", "${NUMBER_LOCALE}");
            }
        }
    }
}

// Função de tratamento de campos tipo string.
function string formatString(string format, string demoValue) {
    if ((format == null) or (trim(format) == "")) {
        return "N/A";
    } else {
        if ((GOODDATA_DEMO_MODE == "S") and (demoValue <> null)) {
            return demoValue;
        } else {
            return removeNonPrintable(translate(trim(upperCase(format)), "ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛÃÕÑÇ", "AEIOUAEIOUAEIOUAEIOUAONC"));
        }
    }
}

// Função de tratamento de campos tipo date.
function date formatDate(string format) {
    if ((format == null) or (trim(format) == "")) {
        return null;
    } else {
        data = str2date(format, "${DATE_PATTERN}", "${DATE_LOCALE}");
        if ((data < GOODDATA_MINDATE) || (data > GOODDATA_MAXDATE)) {
            return null;
        } else {
            if ((GOODDATA_DEMO_MODE == "S") and (GOODDATA_DEMO_DATE <> null)) {
                return dateAdd(data, dateDiff(today(), GOODDATA_DEMO_DATE, day), day);
            } else {
                return data;
            }
        }
    }
}



//Função para calcular a diferença entre duas datas.
    //valor1 - Valor da primeira data em String.
    //valor2 - Valor da segunda data em String.
function decimal subtractDateMinute(string valor1, string valor2) {
    if (((valor1 == null) or (trim(valor1) == "")) or ((valor2 == null) or (trim(valor2) == ""))) {
        return 0.0;
    } else {
        date data1 = str2date(valor1, "${DATE_PATTERN}", "${DATE_LOCALE}");
        date data2 = str2date(valor2, "${DATE_PATTERN}", "${DATE_LOCALE}");
        
        if (((data1 < GOODDATA_MINDATE) || (data1 > GOODDATA_MAXDATE)) or ((data2 < GOODDATA_MINDATE) || (data2 > GOODDATA_MAXDATE))) {
            return 0.0;
        } else {
            return dateDiff(data1, data2, minute);
        }
    }
}

//Função para calcular a diferença entre duas datas, em dias.
    //valor1 - Valor da primeira data em String.
    //valor2 - Valor da segunda data em String.
function long subtractDateDay(string valor1, string valor2) {
    if (((valor1 == null) or (trim(valor1) == "")) or ((valor2 == null) or (trim(valor2) == ""))) {
        return 0;
    } else {
        date data1 = str2date(valor1, "${DATE_PATTERN}", "${DATE_LOCALE}");
        date data2 = str2date(valor2, "${DATE_PATTERN}", "${DATE_LOCALE}");
        
        if (((data1 < GOODDATA_MINDATE) || (data1 > GOODDATA_MAXDATE)) or ((data2 < GOODDATA_MINDATE) || (data2 > GOODDATA_MAXDATE))) {
            return 0;
        } else {
            return dateDiff(data1, data2, day);
        }
    }
}

// Função de tratamento para chaves PROTHEUS.
function string formatKey(string format, boolean caseSensitive) {
    if((format == null) or (trim(format) == "")) {
        return "N/A";
    } else {
        if (caseSensitive) {
            return format;
        } else {
            return trim(upperCase(format));
        }
    }
}