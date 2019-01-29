#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} CONVENENTES
Web Service Rest para a manuten��od do cadastro de convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSRESTFUL CONVENENTES DESCRIPTION 'Consulta e Manuten��o do Cadastro de Convenentes' FORMAT APPLICATION_JSON

WSDATA _queryparam AS STRING OPTIONAL
WSDATA CONTRATO    AS STRING
WSDATA LOCALIDADE  AS STRING
WSDATA TIPO        AS STRING OPTIONAL
WSDATA VERSAO      AS STRING OPTIONAL
WSDATA EMREV       AS STRING OPTIONAL

WSMETHOD GET  DESCRIPTION 'Consulta' WSSYNTAX '/CONVENENTES'
WSMETHOD POST DESCRIPTION 'Inclus�o' WSSYNTAX '/CONVENENTES'
//WSMETHOD PUT  DESCRIPTION 'Manuten��o do Cadastro de Convenentes' WSSYNTAX '/CONVENENTES?ZZC_CODIGO={ZZC_CODIGO}'

END WSRESTFUL

/*/{Protheus.doc} GET
M�todo GET de consulta ao cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD GET QUERYPARAM CONTRATO, LOCALIDADE, TIPO, VERSAO, EMREV WSSERVICE CONVENENTES

//Define que m�todo ir� retornar um json
::SetContentType('application/json')

If ::TIPO == '0'

	::SetResponse( Matriz2Alt( ::CONTRATO, ::LOCALIDADE ) )

ElseIf ::TIPO == '1'

	::SetResponse( LstVersao( ::CONTRATO, ::LOCALIDADE ) )

ElseIf ::TIPO == '2'

	If ! Empty( ::EMREV ) .And. ! AllTrim( ::EMREV ) $ 'true/false'

		SetRestFault( 400, EncodeUtf8( 'Par�metro EMREV s� permite valor true ou false' ), .T. )

		Return .F.

	End If

	::SetResponse( GetMatriz( ::CONTRATO, ::LOCALIDADE, ::VERSAO, ::EMREV ) )

Else

	SetRestFault( 400, EncodeUtf8( 'Tipo de requisi��o inv�lida' ), .T. )

	Return .F.

End If

Return .T.

/*/{Protheus.doc} POST
M�todo POST de inclus�o do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD POST WSSERVICE CONVENENTES

	//Define que m�todo ir� retornar um json
	::SetContentType('application/json')

	//::SetResponse( ::GetContent() )

	::SetResponse( '[true]' )

Return .T.

/*/{Protheus.doc} PUT
M�todo PUT de inclus�o de uma nova vers�o do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
/*WSMETHOD PUT WSRECEIVE NULLPARAM WSSERVICE CONVENENTES

//Define que m�todo ir� retornar um json
::SetContentType('application/json')

::SetResponse( ::GetContent() )

Return .T.*/

/*/{Protheus.doc} GetZZC
Fun��o que faz a busca do cadastro de convenente e retorna em json
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
/*Static Function GetZZC( cSeek )

Local cRet  := ''
Local aAux  := {}
Local aArea := GetArea()

//	DbSelectArea( 'ZZC' )
//	ZZC->( DbSetOrder( 1 ) ) // ZZC_FILIAL + ZZC_CODIGO
//
//	If DbSeek( cSeek )
//
//	End If

aAdd( aAux, { 'cNumEmp', cNumEmp } )
aAdd( aAux, { 'cSeek', cSeek } )

cRet += FWJsonSerialize( aAux, .F., .F. )

RestArea( aArea )

Return cRet*/

/*/{Protheus.doc} Matriz2Alt
Verifica se a matriz de um Contrato/Localidade pode ser alterada
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@return characters, Array em formato Json indicando se a Matriz pode ou n�o ser atualizada
/*/
Static Function Matriz2Alt( cContrato, cLocalidade )

Return FWJsonSerialize( { Randomize( 1, 5 ) > Randomize( 1, 5 ) }, .F., .F.  )

/*/{Protheus.doc} LstVersao
Lista as vers�es da matriz de um contrato/Localidade com seu status correspondentes
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@return characters, Array em formato Json com a lista de vers�es e seus status correspondenetes
/*/
Static Function LstVersao( cContrato, cLocalidade )

	Local nNumVer  := Randomize( 5, 10 )
	Local lLastRev := Randomize( 1, 5 ) > Randomize( 1, 5 ) 
	Local nX       := 0
	Local aRet     := {  }

	For nX := 1 To nNumVer

		If nX < nNumVer
		
			aAdd( aRet, { StrZero( nX, 3 ), '2' } )	

		Else

			aAdd( aRet, { StrZero( nX, 3 ), '1' } )	

		End If		

	Next nX

	If lLastRev

		aRet[ Len( aRet ) - 1, 2 ] := '1'

		aRet[ Len( aRet )    , 2 ] := '0'

	End If

Return FWJsonSerialize( aRet )

/*/{Protheus.doc} GetMatriz
Retorna a vers�o de uma matriz de um contrato/localidade.
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@param cVersao, characters, Versao a ser requisitada, se n�o receber retorna a �ltima vers�o
@param cEmRev, characters, Indica se considera como �ltima vers�o a vers�o em revis�o
@return characters, Array em formato Json com a lista de vers�es e seus status correspondenetes
/*/
Static Function GetMatriz( cContrato, cLocalidade, cVersao, cEmRev )

	Local cRet := ''

	cRet += '{' 
	cRet += '"CONTRATO": {},' 
	cRet += '"LOCALIDADE": {},' 
	cRet += '"MATRIZ": {}' 
	cRet += '}'

Return cRet