#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fwcommand.ch'
#include 'topconn.ch'
#include "RPTDEF.CH"
#include "FWPRINTSETUP.CH"
#include 'FWMVCDEF.CH'
/*/{Protheus.doc} RELMNT01
Relatório de Consumo do Combustível
@type function
@author diogo
@since 14/01/2021
/*/
User Function RELMNT01()
	Local nPrintType	:= 0
	Local nLocal		:= 0
	Local aDevice		:= {}
	Local cSession		:= nil
	Local cDevice		:= nil
	Local nFlags		:= nil
	Local oSetup		:= Nil
	///rpcsetenv("01","010101")
	cSession		:= GetPrinterSession()
	cDevice		:= GetProfString( cSession, "PRINTTYPE", "PDF", .T. )
	nFlags		:= PD_ISTOTVSPRINTER+PD_DISABLEORIENTATION+PD_DISABLEPREVIEW+PD_DISABLEPAPERSIZE
	Private nLinha
	Private oFont1		:= TFont():New( "Times New Roman",,10,,.T.,,,,,.F.)
	Private oFont2		:= TFont():New( "Tahoma",,16,,.T.,,,,,.F.)
	Private oFont3		:= TFont():New( "Arial"       ,,6,,.F.,,,,,.F.)
	Private oFont4		:= TFont():New( "Times New Roman",,13,,.T.,,,,,.F.)
	Private oFont5		:= TFont():New( "Franklin Gothic Heavy",,15,,.T.,,,,,.F.)
	Private oFont6		:= TFont():New( "Arial"       ,,11,,.F.,,,,,.F.)
	Private oFont7		:= TFont():New( "Arial"       ,,10,,.F.,,,,,.F.)
	Private oFont8 		:= TFont():New( "Arial",,8,,.F.,,,,,.F.)
	Private oFont9 		:= TFont():New( "Arial",,11,,.F.,,,,,.F.)
	Private oBrush1		:= TBrush():New( , CLR_GRAY )
	Private cPerg		:= "Consumo Combustível"
	Private cTitulo		:= "Consumo de Combustível Analítico"
	Private oPrn		:= FWMSPrinter():New( cPerg, IMP_PDF , .F., , .T., , oSetup)
	Private cViagde     := ""
	Private cViagate    := ""
	Private	dDatade     := Ctod(Space(8))
	Private dDataate    := Ctod(Space(8))
	Private cTipo       := ""
	Private cPerg  := ""
	Private aRetOpc:= {}
	If !(fAjusPerg())
		return
	Endif
	AADD(aDevice,"DISCO")
	AADD(aDevice,"SPOOL")
	AADD(aDevice,"EMAIL")
	AADD(aDevice,"EXCEL")
	AADD(aDevice,"HTML" )
	AADD(aDevice,"PDF"  )

	nPrintType := aScan(aDevice,{|x| x == cDevice })
	nLocal     := If(GetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )

	oSetup := FWPrintSetup():New(nFlags, cTitulo)

	oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
	oSetup:SetPropert(PD_ORIENTATION , 1)
	oSetup:SetPropert(PD_DESTINATION , nLocal)
	oSetup:SetPropert(PD_MARGIN      , {10,10,10,10})
	oSetup:SetPropert(PD_PAPERSIZE   , 2)

	MsgRun( "Gerando Relatorio...", "", {|| CursorWait(), fGerRel(oSetup,aRetOpc),CursorArrow()})
Return

Static Function fGerRel(oSetup,aRetOpc)
	Local nAlin		:= 0 //Alinhamento do relatório
	Local nSeqLin	:= 0 //Sequencial para realizar a quebra de página
	Local nTotLit	:= 0 //Litros por periodo
	Local nTotPag	:= 0 //Total valor pago
	Local nUltPar	:= 0 //Último abast. parcial do mês anterior
	Local nUlComp	:= 0 //Último KM completo do mês anterior
	Local nUlVlr	:= 0 //Último valor total parcial do periodo anterior
	Local nUMesCp	:= 0 //Último apontamento do mês completo
	Local nUltLct	:= 0 //Último lançamento do mês
	Local nVlULct	:= 0 //Último valor do lançamento do mês
	oPrn:SetPortrait()
	If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oPrn:nDevice := IMP_SPOOL
		WriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
		oPrint:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
		oPrn:nDevice := IMP_PDF
		oPrn:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
	Endif

	cQuery:= "SELECT "
	cQuery+= "TQN_FILIAL,	"
	cQuery+= "TQN_FROTA,	"
	cQuery+= "TQN_PLACA,	"
	cQuery+= "T9_NOME,		"
	cQuery+= "DA3_DESC,		"		
	cQuery+= "TQM_NOMCOM,	"
	cQuery+= "TQN_CODCOM	"
	cQuery+= "FROM "+RetSqlName("TQN")+" TQN "
	cQuery+= "INNER JOIN "+RetSqlName("TQM")+" TQM "
	cQuery+= "ON TQM_CODCOM = TQN_CODCOM "
	cQuery+= "INNER JOIN "+RetSqlName("ST9")+" ST9 "
	cQuery+= "ON T9_CODBEM = TQN_FROTA "
	cQuery+= "LEFT JOIN "+RetSqlName("DA3")+" DA3 "
	cQuery+= "ON DA3_PLACA = TQN_PLACA AND DA3.D_E_L_E_T_='  '  "
	cQuery+= "WHERE TQN_DTABAS BETWEEN '"+dTos(aRetOpc[3])+"' AND '"+dTos(aRetOpc[4])+"' "
	cQuery+= "AND T9_CODBEM BETWEEN '"+aRetOpc[1]+"' AND '"+aRetOpc[2]+"' "
	cQuery+= "AND TQN_CODCOM BETWEEN '"+aRetOpc[5]+"' AND '"+aRetOpc[6]+"' "
	cQuery+= "AND TQN.D_E_L_E_T_=' ' " 
	cQuery+= "AND TQM.D_E_L_E_T_=' ' "
	cQuery+= "AND ST9.D_E_L_E_T_=' ' "
	cQuery+= "GROUP BY   "
	cQuery+= "TQN_FILIAL, "
	cQuery+= "TQN_FROTA, "
	cQuery+= "TQN_PLACA, "
	cQuery+= "T9_NOME,  "
	cQuery+= "DA3_DESC,	"
	cQuery+= "TQN_CODCOM,"
	cQuery+= "TQM_NOMCOM "

	if Select("QR01") > 0
	dbSelectArea("QR01")
	dbCloseArea()
	endif
	TcQuery cQuery New Alias QR01

	While !QR01->(EOF())

		//Informações do cabeçalho
		fGetCabelho()
		cQuery:= "SELECT "
		cQuery+= " TQN_DTABAS, TQN_HRABAS, "
		cQuery+= " TQN_HODOM KM,   "
		cQuery+= " TQN_VALUNI UNI, "
		cQuery+= " TQN_QUANT * TQN_VALUNI TOT,* "
		cQuery+= " FROM "
		cQuery+= " "+RetSqlName("TQN")+" TQN "
		cQuery+= " WHERE TQN_FROTA='"+QR01->TQN_FROTA+"' "
		cQuery+= " AND TQN_FILIAL='"+QR01->TQN_FILIAL+"' "
		cQuery+= " AND TQN_CODCOM='"+QR01->TQN_CODCOM+"' "
		cQuery+= " AND TQN_DTABAS BETWEEN '"+dTos(aRetOpc[3])+"' AND '"+dTos(aRetOpc[4])+"' "
		cQuery+= " AND D_E_L_E_T_ = ' ' "
		cQuery+= " ORDER BY 1,2 "
		TcQuery cQuery New Alias QR02
		nSeqLin	:= 1
		nTotLit	:= 0 //Litros por periodo
		nTotPag	:= 0 //Total valor pago
		nUltPar	:= fGetLtAnter('P','AB') //Último abast. parcial do mês anterior
		nUlComp	:= fGetLtAnter('C','KM') //Último KM completo do mês anterior
		nUlVlr	:= fGetLtAnter('P','VL') //Último valor total parcial do periodo anterior
		nUMesCp := 0 //Último apontamento do mês completo
		nUltLct := 0 //Último lançamento do mês
		nVlULct := 0 //Valor do último lançamento do mês
		lPrim	:= .T.
		cUltTpo := ""
		
		while QR02->(!eof())
			If QR02->TQN_YTIPO = 'C' .and. lPrim .and. nUlComp = 0  //Se o primeiro do mês for completo, considera ele
				nUlComp:= QR02->TQN_HODOM
				lPrim := .F.
			endif
			nKmAnt:= fGetHrAnter() //Quantidade de Km rodados conforme o tipo: parcial ou completo
			nSumLitros:= fGetConsumo() + QR02->TQN_QUANT  //Somatório dos litros pós o último abastecimento completo
			oPrn:Say(nLinha,20,iif(QR02->TQN_YTIPO='P','*',' ')+dtoc(stod(QR02->TQN_DTABAS))+" "+QR02->TQN_HRABAS,oFont7,100) //Data
			
			nAlin:= 10 - len(alltrim(transform(QR02->TQN_QUANT,"@E 99,999.999")))
			nAlin:= iif(nAlin>0,nAlin+4,0)
			oPrn:Say(nLinha,100+nAlin,transform(QR02->TQN_QUANT,"@E 99,999.999"),oFont7,100) //m3
			
			oPrn:Say(nLinha,272,transform(QR02->TQN_HODOM,"@E 99,999,999"),oFont7,100) //KM
			
			If nKmAnt > 0 .and. QR02->TQN_YTIPO<>'P' .and. (QR02->TQN_HODOM - nKmAnt) > 0  //Verifica se tem Km Anterior
				nAlin:= 10 - len(alltrim(transform(QR02->TQN_HODOM - nKmAnt,"@E 999,999.99")))
				nAlin:= iif(nAlin>0,nAlin+3,0)
				oPrn:Say(nLinha,326+nAlin,transform(QR02->TQN_HODOM - nKmAnt,"@E 999,999.99"),oFont7,100) //KM Rod.
			endif

			If nKmAnt > 0  .and. QR02->TQN_YTIPO<>'P' .and. Round((QR02->TQN_HODOM - nKmAnt) / (nSumLitros),4) > 0   //Consumo completo: (km rodado / soma qtd de litros pós o último abastecimento)
				nAlin:= 13 - len(alltrim(transform( Round((QR02->TQN_HODOM - nKmAnt) / (nSumLitros),4),"@E 99,999,999.99")))
				nAlin:= iif(nAlin>0,nAlin+3,0)

				oPrn:Say(nLinha,394+nAlin,transform( Round((QR02->TQN_HODOM - nKmAnt) / (nSumLitros),4),"@E 99,999,999.99"),oFont7,100) //km/1(m3)
				nUMesCp:= QR02->TQN_HODOM //Último KM Completo do Mês
			endif
			
			nAlin:= 11 - len(alltrim(transform(QR02->UNI,"@E 99,999.9999")))
			nAlin:= iif(nAlin>0,nAlin+5,0)
			oPrn:Say(nLinha,460+nAlin,transform(QR02->UNI,"@E 99,999.9999"),oFont7,100) //Unit
			
			nAlin:= 10 - len(alltrim(transform(QR02->TOT,"@E 99,999.999")))
			nAlin:= iif(nAlin>0,nAlin+4,0)
			oPrn:Say(nLinha,529+nAlin,transform(QR02->TOT,"@E 99,999.999"),oFont7,100) //Total

			
			nSeqLin+=1
			If nSeqLin > 65 //Quebra de página
				oPrn:EndPage()
				fGetCabelho()
				nSeqLin:= 1
				nLinha-=10
			endif
			nTotLit+= QR02->TQN_QUANT
			nTotPag+= QR02->TOT
			nLinha+=10
			If QR02->TQN_YTIPO = 'C' //Zera se último lançamento for COMPLETO
				nUltLct:= 0
				nVlULct:= 0
			Else
				nUltLct+= QR02->TQN_QUANT //Último lançamento
				nVlULct+= QR02->TOT //Último lançamento
			Endif	
			cUltTpo:= QR02->TQN_YTIPO //Último Tipo do lançamento
			QR02->(dbSkip())
		enddo
		QR02->(dbCloseArea())

	If cUltTpo = 'C' //Zera se último lançamento for COMPLETO
		nUltLct:= 0
		nVlULct:= 0
	Endif	

	oPrn:Line(nLinha,20,nLinha,580)
	nLinha += 15
	oPrn:Say(nLinha,20,"Total Litros:",oFont7,100)

	nAlin:= 10 - len(alltrim(transform(nTotLit,"@E 99,999.999")))
	nAlin:= iif(nAlin>0,nAlin+4,0)
	oPrn:Say(nLinha,100+nAlin,transform(nTotLit,"@E 99,999.999"),oFont7,100) //total litros

	nAlin:= 10 - len(alltrim(transform(nTotPag,"@E 99,999.999")))
	nAlin:= iif(nAlin>0,nAlin+4,0)
	oPrn:Say(nLinha,529+nAlin,transform(nTotPag,"@E 99,999.999	"),oFont7,100)  //total pago
	
	nLinha += 15
	oPrn:Say(nLinha,20,"Total Média:",oFont7,100)

	If nTotLit+nUltPar-nUltLct > 0 
		nAlin:= 10 - len(alltrim(transform(nTotLit+nUltPar-nUltLct,"@E 99,999.999")))
		nAlin:= iif(nAlin>0,nAlin+4,0)
		oPrn:Say(nLinha,100+nAlin,transform(nTotLit+nUltPar-nUltLct,"@E 99,999.999"),oFont7,100) //total média: litros do periodo + ultimo parcial do mês anterior
	endif
	If nUMesCp - nUlComp > 0 
		oPrn:Say(nLinha,272,transform(nUMesCp - nUlComp,"@E 99,999,999"),oFont7,100) //Ultimo KM cheio do periodo - KM cheio do anterior
	endif
	
	If ((nUMesCp-nUlComp)/(nTotLit+nUltPar-nUltLct)) > 0 
		oPrn:Say(nLinha,326,transform( ((nUMesCp-nUlComp)/(nTotLit+nUltPar-nUltLct)),"@E 999,999.9999"),oFont7,100) //Divisão 
	endif

	If nTotPag+nUlVlr > 0 
		nAlin:= 10 - len(alltrim(transform(nTotPag-nVlULct,"@E 99,999.999")))
		nAlin:= iif(nAlin>0,nAlin+4,0)
		//oPrn:Say(nLinha,529+nAlin,transform(nTotPag+nUlVlr,"@E 99,999.999"),oFont7,100) //Total pago + valor do último parcial anterior
		oPrn:Say(nLinha,529+nAlin,transform(nTotPag-nVlULct,"@E 99,999.999"),oFont7,100) //Total pago + valor do último parcial anterior
	endif
	nLinha += 15
	oPrn:Say(nLinha,20,"Custo Médio de Abastecimento por Km",oFont7,100)

	If ((nTotPag+nUlVlr) / (nTotPag)) > 0 
		nAlin:= 10 - len(alltrim(transform(((nTotPag+nUlVlr) / (nTotPag)),"@E 99,999.999")))
		nAlin:= iif(nAlin>0,nAlin+4,0)
		oPrn:Say(nLinha,529+nAlin,transform(((nTotPag+nUlVlr) / (nTotPag)) ,"@E 99,999.999"),oFont7,100) //Total
	endif

	nLinha += 10	
	oPrn:Say(nLinha,20,"* Abastecimento Parcial",oFont7,100)
	oPrn:EndPage()
	QR01->(dbSkip())
Enddo
QR01->(DbCloseArea())
oPrn:Preview()
oPrn:EndPage()

Return
Static Function fAjusPerg()
	Local aPergs:= {}
	aAdd( aPergs ,{1,"Veiculo de",  space(TamSx3("T9_CODBEM")[1]),"@!" ,'.T.',"ST9" ,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Veiculo ate", space(TamSx3("T9_CODBEM")[1]),"@!",'.T.',"ST9" ,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Periodo de",	ctod(""),"@!",'.T.',"",'.T.',50,.T.})
	aAdd( aPergs ,{1,"Periodo ate", ctod(""),"@!",'.T.',"",'.T.',50,.T.})
	aAdd( aPergs ,{1,"Combustível de",  space(TamSx3("TQN_CODCOM")[1]),"@!" ,'.T.',"TQM" ,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Combustível ate", space(TamSx3("TQN_CODCOM")[1])	,"@!",'.T.',"TQM" ,'.T.',50,.T.})

	If !(ParamBox(aPergs,"Parâmetros",aRetOpc,,,,,,,"FRELMNT",.T.,.T.))
        Return .F.
    endif
Return .T.


Static Function fGetCabelho()
	Local nSep:= 0
	
	oPrn:StartPage()          // Inicia uma nova página
	oPrn:SayBitmap(1,24,"\system\logo_unilink\logounilink.bmp",100,100)
	oPrn:Say(30,180,"Consumo de Combustível Analítico",oFont2,100)
	nLinha := 30

	oPrn:Say(nLinha,440,"Data:"+cvaltochar(date()),oFont7,100)
	nLinha += 12

	oPrn:Say(nLinha,440,"Veiculo de: "+aRetOpc[1]+" até "+aRetOpc[2],oFont7,100)
	oPrn:Say(nLinha+12,440,"Combustível de: "+cvaltochar(aRetOpc[5])+" até "+cvaltochar(aRetOpc[6]),oFont7,100)
	oPrn:Say(nLinha+24,440,"Periodo de: "+cvaltochar(aRetOpc[3])+" até "+cvaltochar(aRetOpc[4]),oFont7,100)

	nLinha += 40
	oPrn:Line(nLinha,20,nLinha,580)
	nLinha += 15
	oPrn:Say(nLinha,20,"Veículo: "+alltrim(QR01->TQN_FROTA)+space(9)+;
	"Placa: "+alltrim(QR01->TQN_PLACA)+space(9)+;
	"Modelo: "+IIf(empty(QR01->DA3_DESC),alltrim(QR01->T9_NOME),alltrim(QR01->DA3_DESC)) +space(9)+;
	"Combustível: "+alltrim(QR01->TQM_NOMCOM),oFont4,100)
	
	nLinha+= 10
	oPrn:Line(nLinha,20,nLinha,580)
	nLinha += 10

	nSep:= 17
	oPrn:Say(nLinha,20,"Data "+space(nSep+12)+;
	"Litros  "+space(nSep)+;
	"C.B"+space(nSep)+;
	"Dif."+space(nSep+2)+;
	"Km"+space(nSep-2)+;
	"Km Rod"+space(nSep-2)+;
	"    Km/(L)   "+space(nSep-4)+;
	"Unitário"+space(nSep-6)+;
	"Valor Pago",oFont9,100)
	nLinha += 10
	oPrn:Line(nLinha,20,nLinha,580)
	nLinha += 10
Return

/*{Protheus.doc} fGetHrAnter
Verificar a km anterior
@type function
@author diogo
@since 06/01/2021
/*/
Static Function fGetHrAnter()
	Local nRet := 0 
	Local aArea:= getArea()
	cQuery:= " SELECT TOP 1 TQN_DTABAS,TQN_HRABAS,TQN_HODOM FROM "+RetSqlName("TQN")+" TQN "
	cQuery+= " INNER JOIN "+RetSqlName("ST9")+" ST9 "
	cQuery+= " ON T9_CODBEM = TQN_FROTA "
	cQuery+= " WHERE TQN_FROTA='"+QR02->TQN_FROTA+"' "
	cQuery+= " AND TQN.D_E_L_E_T_ = ' '  "
	cQuery+= " AND ST9.D_E_L_E_T_ = ' '  "
	cQuery+= " AND TQN_YTIPO = '"+QR02->TQN_YTIPO+"' "
	cQuery+= " AND TQN_CODCOM = '"+QR02->TQN_CODCOM+"' "
	cQuery+= " AND TQN_DTABAS+TQN_HRABAS < '"+QR02->TQN_DTABAS+QR02->TQN_HRABAS+"'  "
	cQuery+= " AND TQN_DTABAS >= '"+dTos(MonthSub(aRetOpc[3],1))+"' "
	cQuery+= " AND T9_CODBEM BETWEEN '"+aRetOpc[1]+"' AND '"+aRetOpc[2]+"' "	
	cQuery+= " AND TQN_CODCOM BETWEEN '"+aRetOpc[5]+"' AND '"+aRetOpc[6]+"' "
	cQuery+= " ORDER BY 1 DESC, 2 DESC "
	tcQuery cQuery new Alias TQKM

	If TQKM->(!eof())
		nRet:= TQKM->TQN_HODOM
	endif
	TQKM->(dbCloseArea())
	restArea(aArea)
Return nRet

/*/{Protheus.doc} fGetConsumo
Busca o somatório dos últimos abastecimentos parciais
@type function
@author diogo
@since 14/01/2021
/*/
Static Function fGetConsumo
	Local nRet := 0 
	Local aArea:= getArea()
	cQuery:= " SELECT TQN_DTABAS,TQN_HRABAS,TQN_HODOM,TQN_YTIPO,TQN_QUANT FROM "+RetSqlName("TQN")+" TQN "
	cQuery+= " INNER JOIN "+RetSqlName("ST9")+" ST9 "
	cQuery+= " ON T9_CODBEM = TQN_FROTA "
	cQuery+= " WHERE TQN_FROTA='"+QR02->TQN_FROTA+"' "
	cQuery+= " AND TQN.D_E_L_E_T_ = ' '  "
	cQuery+= " AND ST9.D_E_L_E_T_ = ' '  "
	cQuery+= " AND TQN_CODCOM = '"+QR02->TQN_CODCOM+"' "
	cQuery+= " AND TQN_DTABAS+TQN_HRABAS < '"+QR02->TQN_DTABAS+QR02->TQN_HRABAS+"'  "
	cQuery+= " AND TQN_DTABAS >= '"+dTos(MonthSub(aRetOpc[3],1))+"' "
	cQuery+= " AND TQN_FROTA = '"+QR01->TQN_FROTA+"' "
	cQuery+= " ORDER BY 1 DESC, 2 DESC "
	tcQuery cQuery new Alias TQKM

	while TQKM->(!eof())
		If TQKM->TQN_YTIPO = 'P' //Soma todos os parciais até o último abastecimento completo
			nRet+= TQKM->TQN_QUANT
		Else
			exit
		endif	
		TQKM->(dbSkip())
	enddo
	TQKM->(dbCloseArea())
	restArea(aArea)
Return nRet
/*/{Protheus.doc} fGetLtAnter
Retorna o último apontamento do mês anterior (KM/Litros/Valor)
@type function
@author diogo
@since 14/01/2021
/*/
Static Function fGetLtAnter(cTipo,cCamp)
	Local nRet := 0 
	Local aArea:= getArea()
	//Último do mês anterior
	cQuery:= " SELECT TQN_DTABAS,TQN_HRABAS,TQN_QUANT,TQN_YTIPO,TQN_VALUNI,TQN_HODOM FROM "+RetSqlName("TQN")+" TQN "
	cQuery+= " INNER JOIN "+RetSqlName("ST9")+" ST9 "
	cQuery+= " ON T9_CODBEM = TQN_FROTA "
	cQuery+= " WHERE TQN_FROTA='"+QR02->TQN_FROTA+"' "
	cQuery+= " AND TQN.D_E_L_E_T_ = ' '  "
	cQuery+= " AND ST9.D_E_L_E_T_ = ' '  "
	if cCamp = 'KM'
		cQuery+= " AND TQN_YTIPO = '"+cTipo+"' "
	endif
	cQuery+= " AND TQN_CODCOM = '"+QR02->TQN_CODCOM+"' "
	cQuery+= " AND TQN_DTABAS < '"+dTos(aRetOpc[3])+"' "
	cQuery+= " AND TQN_DTABAS >= '"+dTos(MonthSub(aRetOpc[3],1))+"' "
	cQuery+= " AND T9_CODBEM BETWEEN '"+aRetOpc[1]+"' AND '"+aRetOpc[2]+"' "
	cQuery+= " AND TQN_CODCOM BETWEEN '"+aRetOpc[5]+"' AND '"+aRetOpc[6]+"' "
	cQuery+= " AND TQN_FROTA = '"+QR01->TQN_FROTA+"' "
	cQuery+= " ORDER BY 1 DESC, 2 DESC "
	tcQuery cQuery new Alias TQKM

	while TQKM->(!eof())
		If cCamp = 'AB' //Abastecimento em litros
			If TQKM->TQN_YTIPO = 'C' //Completo, sai para contar somente Parcial
				exit
			Endif	
			nRet+= TQKM->TQN_QUANT
		Elseif cCamp = 'KM' //Km rodados
			nRet:= TQKM->TQN_HODOM
			EXIT
		Elseif cCamp = 'VL' //Valor Pago do mês anterior
			If TQKM->TQN_YTIPO = 'C'
				exit
			Endif	
			nRet+= TQKM->TQN_QUANT*TQKM->TQN_VALUNI
		Endif	
		TQKM->(dbSkip())
	enddo
	TQKM->(dbCloseArea())
	restArea(aArea)
Return nRet
