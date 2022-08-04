//biblioteca
#Include 'Protheus.ch'
#define CRL := 
//nome da função FOP1
User Function FOP1()
    //Declaração de variáveis
    Local nNumero1 := 4// tipo local
    Local nNumero2

    Local nResult
    Local nResult1
    Local nResult2
    Local nResult3
    Local nResult4
    Local nResult5

    nNumero1 := 4 //Utilizando o operador de atribuição
    nNumero2 := 2 //Utilizando o operador de atribuição

    nResult  := nNumero1 + nNumero2
    nResult1 := nNumero1 - nNumero2
    nResult2 := nNumero1 * nNumero2
    nResult3 := nNumero1 / nNumero2
    nResult4 := nNumero1 ** nNumero2
    nResult5 := nNumero1 % nNumero2

    MsgInfo("A soma de " + str(nNumero1) + " e " + str(nNumero2) + "é: " + str(nResult),"Soma")
    MsgInfo(nResult1,"Subtração")
    MsgInfo(nResult2,"Multiplicação")
    MsgInfo(nResult3,"Divisão")
    MsgInfo(nResult4,"Exponenciação")
    MsgInfo(nResult5,"Resto/Mod")
Return
