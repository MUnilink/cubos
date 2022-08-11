#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"

/*/{Protheus.doc} XCalc
@author Dilson Castro
@since 07/08/2022
@version 1.0
@return ${return}, ${return_description}
@type function
/*/

User Function XCalc()
    //SetPrvt
    SetPrvt("oTFont1","oTFont2","oTFont3","oTFont4","oTFont5","oDlg1","oSay1","oBtn1","oGet1")
    SetPrvt("oBtn01","oBtn02","oBtn03","oBtn04","oBtn05","oBtn06","oBtn07","oBtn09","oBtn10","oBtn11","oBtn12","oBtn13","oBtn14","oBtn15","oBtn16")
    Private nVisor := "0"
    //TFont
    oTFont1    := TFont():N ew('Courier new',,-45,.T.)
    oTFont2    := TFont():New('Courier new',,-40,.T.)
    oTFont3    := TFont():New('Courier new',,-35,.T.)
    oTFont4    := TFont():New('Courier new',,-30,.T.)
    oTFont5    := TFont():New('Courier new',,-12,.T.)
    //MSDialog
    oDlg1      := MSDialog():New( 092,232,520,560,"Calculadora",,,.F.,,,,,,.T.,,,.T. )
    //TSay
    oSay1      := TSay():New( 000,005,{||"Unilink || Versão 1.0"}   ,oDlg1,,oTFont5,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
    //TGet
    //cTGet1 := "Teste TGet 01"
    oGet1      := TGet():New( 010,005,/*{||cTGet1}*/,oDlg1,157,040,"@E 999,999.99",,0,,oTFont1,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,,)
    oGet1:SetContentAlign(1)
    oGet1:SetFocus()
    //TButton
    oBtn01     := TButton():New( 174,004,"0",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn02     := TButton():New( 174,044,",",oDlg1,,037,037,,oTFont3,,.T.,,"",,,,.F. )
    oBtn03     := TButton():New( 174,084,"=",oDlg1,,037,037,,oTFont2,,.T.,,"",,,,.F. )
    oBtn04     := TButton():New( 174,124,"+",oDlg1,,037,037,,oTFont3,,.T.,,"",,,,.F. )
    oBtn05     := TButton():New( 134,004,"1",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn06     := TButton():New( 134,044,"2",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn07     := TButton():New( 134,084,"3",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn08     := TButton():New( 134,124,"-",oDlg1,,037,037,,oTFont3,,.T.,,"",,,,.F. )
    oBtn09     := TButton():New( 094,004,"4",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn10     := TButton():New( 094,044,"5",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn11     := TButton():New( 094,084,"6",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn12     := TButton():New( 094,124,"*",oDlg1,,037,037,,oTFont3,,.T.,,"",,,,.F. )
    oBtn13     := TButton():New( 054,004,"7",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn14     := TButton():New( 054,044,"8",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn15     := TButton():New( 054,084,"9",oDlg1,,037,037,,oTFont4,,.T.,,"",,,,.F. )
    oBtn16     := TButton():New( 054,124,"/",oDlg1,,037,037,,oTFont3,,.T.,,"",,,,.F. )
    //SetColor
    oBtn03:SetColor(CLR_BLUE)
    oBtn04:SetColor(CLR_RED)
    oBtn08:SetColor(CLR_RED)
    oBtn12:SetColor(CLR_RED)
    oBtn16:SetColor(CLR_RED)
    oBtn01:SetColor(CLR_BLACK)
    oBtn02:SetColor(CLR_BLACK)
    oBtn05:SetColor(CLR_BLACK)
    oBtn06:SetColor(CLR_BLACK)
    oBtn07:SetColor(CLR_BLACK)
    oBtn09:SetColor(CLR_BLACK)
    oBtn10:SetColor(CLR_BLACK)
    oBtn11:SetColor(CLR_BLACK)
    oBtn13:SetColor(CLR_BLACK)
    oBtn14:SetColor(CLR_BLACK)
    oBtn15:SetColor(CLR_BLACK)
    //Ações
    oBtn01:bAction := {|| oGet1:cText(nVisor)}
    oGet1:CtrlRefresh()
    //Ativar janela
    oDlg1:Activate(,,,.T.)
Return
