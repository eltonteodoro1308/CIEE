#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} CONVENENTES
Web Service Rest para a manutençãod do cadastro de convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSRESTFUL CONVENENTES DESCRIPTION 'Consulta e Manutenção do Cadastro de Convenentes' FORMAT APPLICATION_JSON

WSDATA _queryparam AS STRING OPTIONAL
WSDATA CONTRATO    AS STRING
WSDATA LOCALIDADE  AS STRING
WSDATA TIPO        AS STRING OPTIONAL
WSDATA VERSAO      AS STRING OPTIONAL
WSDATA EMREV       AS STRING OPTIONAL

WSMETHOD GET  DESCRIPTION 'Consulta' WSSYNTAX '/CONVENENTES'
WSMETHOD POST DESCRIPTION 'Inclusão' WSSYNTAX '/CONVENENTES'
//WSMETHOD PUT  DESCRIPTION 'Manutenção do Cadastro de Convenentes' WSSYNTAX '/CONVENENTES?ZZC_CODIGO={ZZC_CODIGO}'

END WSRESTFUL

/*/{Protheus.doc} GET
Método GET de consulta ao cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD GET QUERYPARAM CONTRATO, LOCALIDADE, TIPO, VERSAO, EMREV WSSERVICE CONVENENTES

//Define que método irá retornar um json
::SetContentType('application/json')

If ::TIPO == '0'

	::SetResponse( Matriz2Alt( ::CONTRATO, ::LOCALIDADE ) )

ElseIf ::TIPO == '1'

	::SetResponse( LstVersao( ::CONTRATO, ::LOCALIDADE ) )

ElseIf ::TIPO == '2'

	If ! Empty( ::EMREV ) .And. ! AllTrim( ::EMREV ) $ 'true/false'

		SetRestFault( 400, EncodeUtf8( 'Parâmetro EMREV só permite valor true ou false' ), .T. )

		Return .F.

	End If

	::SetResponse( GetMatriz( ::CONTRATO, ::LOCALIDADE, ::VERSAO, ::EMREV ) )

Else

	SetRestFault( 400, EncodeUtf8( 'Tipo de requisição inválida' ), .T. )

	Return .F.

End If

Return .T.

/*/{Protheus.doc} POST
Método POST de inclusão do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD POST WSSERVICE CONVENENTES

	//Define que método irá retornar um json
	::SetContentType('application/json')

	//::SetResponse( ::GetContent() )

	::SetResponse( '[true]' )

Return .T.

/*/{Protheus.doc} PUT
Método PUT de inclusão de uma nova versão do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
/*WSMETHOD PUT WSRECEIVE NULLPARAM WSSERVICE CONVENENTES

//Define que método irá retornar um json
::SetContentType('application/json')

::SetResponse( ::GetContent() )

Return .T.*/

/*/{Protheus.doc} GetZZC
Função que faz a busca do cadastro de convenente e retorna em json
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
@param cContrato, characters, Código do Contrato
@param cLocalidade, characters, Código da Localidade
@return characters, Array em formato Json indicando se a Matriz pode ou não ser atualizada
/*/
Static Function Matriz2Alt( cContrato, cLocalidade )

Return FWJsonSerialize( { Randomize( 1, 5 ) > Randomize( 1, 5 ) }, .F., .F.  )

/*/{Protheus.doc} LstVersao
Lista as versões da matriz de um contrato/Localidade com seu status correspondentes
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, Código do Contrato
@param cLocalidade, characters, Código da Localidade
@return characters, Array em formato Json com a lista de versões e seus status correspondenetes
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
Retorna a versão de uma matriz de um contrato/localidade.
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, Código do Contrato
@param cLocalidade, characters, Código da Localidade
@param cVersao, characters, Versao a ser requisitada, se não receber retorna a última versão
@param cEmRev, characters, Indica se considera como última versão a versão em revisão
@return characters, Array em formato Json com a lista de versões e seus status correspondenetes
/*/
Static Function GetMatriz( cContrato, cLocalidade, cVersao, cEmRev )

	Local cRet := ''

	cRet += '{' 
	cRet += '"CONTRATO": {},' 
	cRet += '"LOCALIDADE": {},' 
	cRet += '"MATRIZ": {}' 
	cRet += '}'

Return cRet