#include "TOTVS.CH"

/*/{Protheus.doc} UniMaps
@author Dilson Castro
@since 09/08/2022
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
  
User Function UniMaps()
  DEFINE MSDIALOG oDlg TITLE "Unilink - Maps Cliente" FROM 025,025 TO 600,900 PIXEL
  
    // Prepara o conector WebSocket
    PRIVATE oWebChannel := TWebChannel():New()
    nPort := oWebChannel:connect()
    
    // Cria componente
    PRIVATE oWebEngine := TWebEngine():New(oDlg, 050, 050, 500, 800,, nPort)
    oWebEngine:bLoadFinished := {|self,url| conout("Termino da carga do pagina: " + url) }
    oWebEngine:navigate("https://www.google.com.br/maps/place/UniLink+Transportes+Integrados+Ltda/@-3.8341005,-38.5062409,17z/data=!3m1!4b1!4m5!3m4!1s0x7c751248fe5c7ad:0x690fa489698ad361!8m2!3d-3.8341005!4d-38.5040522")
    oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT
  
  ACTIVATE MSDIALOG oDlg CENTERED
Return
