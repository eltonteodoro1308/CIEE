#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} CONVENENTES
Web Service Rest para a manuten��od do cadastro de convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSRESTFUL CONVENENTES DESCRIPTION 'Consulta e Manuten��o do Cadastro de Convenentes' FORMAT APPLICATION_JSON

WSDATA ZZC_CODIGO AS STRING

WSMETHOD GET  DESCRIPTION 'Consulta ao Cadastro de Convenentes'   WSSYNTAX '/CONVENENTES?ZZC_CODIGO={ZZC_CODIGO}'
WSMETHOD POST DESCRIPTION 'Inclus�o do Cadastro de Convenentes'   WSSYNTAX '/CONVENENTES/'
WSMETHOD PUT  DESCRIPTION 'Manuten��o do Cadastro de Convenentes' WSSYNTAX '/CONVENENTES?ZZC_CODIGO={ZZC_CODIGO}'

END WSRESTFUL

/*/{Protheus.doc} GET
M�todo GET de consulta ao cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD GET WSRECEIVE ZZC_CODIGO WSSERVICE CONVENENTES

	//Define que m�todo ir� retornar um json
	::SetContentType('application/json')

	::SetResponse( GetZZC( xFilial( 'ZZC' ) + ::ZZC_CODIGO ) )

Return .T.

/*/{Protheus.doc} POST
M�todo POST de inclus�o do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD POST WSRECEIVE NULLPARAM WSSERVICE CONVENENTES

	//Define que m�todo ir� retornar um json
	::SetContentType('application/json')

	::SetResponse( ::GetContent() )

Return .T.

/*/{Protheus.doc} PUT
M�todo PUT de inclus�o de uma nova vers�o do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD PUT WSRECEIVE NULLPARAM WSSERVICE CONVENENTES

	//Define que m�todo ir� retornar um json
	::SetContentType('application/json')

	::SetResponse( ::GetContent() )

Return .T.

/*/{Protheus.doc} GetZZC
Fun��o que faz a busca do cadastro de convenente e retorna em json
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
Static Function GetZZC( cSeek )

	Local cRet  := ''
	Local aAux  := {}
	Local aArea := GetArea()

	/*
	DbSelectArea( 'ZZC' )
	ZZC->( DbSetOrder( 1 ) ) // ZZC_FILIAL + ZZC_CODIGO

	If DbSeek( cSeek )

	End If

	*/

	aAdd( aAux, { 'cNumEmp', cNumEmp } )
	aAdd( aAux, { 'cSeek', cSeek } )	

	cRet += FWJsonSerialize( aAux, .F., .F. )

	RestArea( aArea )

Return cRet