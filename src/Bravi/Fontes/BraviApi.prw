#INCLUDE 'TOTVS.CH'

//username -> bravi1
//password -> bravi@2017

/*/{Protheus.doc} GetApiBravi
Retorna a inst�ncia do objeto que representa a conex�o com o Web Service Rest de integra��o com o Bravi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param cUrl, characters, Url do Web Service a ser invocando
@param cUserName, characters, UserName para gera��o Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para gera��o Token de acesso as rotinas do Web Service
@return Objeto, Objeto que representa a conex�o com o Web Service Rest de integra��o com o Bravi
/*/
User Function GetApiBravi( cUrl, cUserName, cPassWord )

	Local oRet := BraviApi():New( cUrl, cUserName, cPassWord )

Return oRet

/*/{Protheus.doc} BraviApi
Classe que representa a conex�o com o Web Service Rest de integra��o com o Bravi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
/*/
Class BraviApi

	Data cUrl
	Data cUserName
	Data cPassWord

	Method New( cUrl, cUserName, cPassWord ) CONSTRUCTOR
	Method Consulta( cId, aAlunos, cError )
	Method Exclui( cId, cError )
	Method Inclui( aList, cError )
	Method Altera( aList, cError )

End Class

/*/{Protheus.doc} New
M�todo Construtor da classe BraviApi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Object, Inst�ncia da Classe BraviApi
@param cUrl, characters, Url do Web Service a ser invocando
@param cUserName, characters, UserName para gera��o Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para gera��o Token de acesso as rotinas do Web Service
/*/
Method New( cUrl, cUserName, cPassWord ) Class BraviApi

	::cUrl      := cUrl
	::cUserName := cUserName
	::cPassWord := cPassWord

Return Self

/*/{Protheus.doc} Inclui
M�todo de Inclus�o da classe BraviApi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Logical, Indica se a opera��o foi bem sucedida
@param cJsonAluno, characters, Vari�vel com o Json que representam o aluno a ser inclu�do
@param cError, characters, Vari�vel passada por refer�ncia que ser� populada com a mensagem de erro retornada pelo Web Service
@param cId, characters, Vari�vel passada por refer�ncia que ser� populada com o id do estagi�rio incluido
/*/
Method Inclui( cJsonAluno, cError, cId ) Class BraviApi

	Local lRet        := .T.
	Local cPath       := '/v1/alunos'
	Local aHeader     := {}
	Local cHeaderRet  := ''
	Local cToken      := ''
	Local cError      := ''
	Local cResponse   := ''
	Local oJson       := Nil

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, 'Authorization: ' + cToken       )
		aAdd( aHeader, 'Accept: application/json'       )
		aAdd( aHeader, 'Content-Type: application/json' )

		cResponse := HTTPQuote ( ::cUrl + cPath, 'POST', , EncodeUtf8( '[' + cJsonAluno + ']' ), 120, aHeader, @cHeaderRet )

		FWJsonDeserialize( cResponse, @oJson )

		lRet := ValType( oJson ) == 'A'

		If lRet

			cId := oJson[ 1 ]:id

		Else

			cError := oJson:errors:description + CRLF

			If ValType( oJson:errors:message ) == 'C'

				cError += oJson:errors:message

			ElseIf ValType( oJson:errors:message ) == 'O'

				aErrors := aClone( ClassDataArr( oJson:errors:message:aluno ) )

				For nX := 1 To Len( aErrors )

					cError += aErrors[ nX, 1 ] + ': ' + aErrors[ nX, 2 ] + CRLF

				Next nX

			End If

		End If

	End If

Return lRet

/*/{Protheus.doc} Altera
M�todo de Altera��o da classe BraviApi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Logical, Indica se a opera��o foi bem sucedida
@param cJsonAluno, characters, Vari�vel com o Json que representam o aluno a ser inclu�do
@param cError, characters, Vari�vel passada por refer�ncia que ser� populada com a mensagem de erro retornada pelo Web Service
/*/
Method Altera( cJsonAluno, cError ) Class BraviApi

	Local lRet        := .T.
	Local cPath       := '/v1/alunos'
	Local aHeader     := {}
	Local cHeaderRet  := ''
	Local cToken      := ''
	Local cError      := ''
	Local cResponse   := ''
	Local oJson       := Nil

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, 'Authorization: ' + cToken       )
		aAdd( aHeader, 'Accept: application/json'       )
		aAdd( aHeader, 'Content-Type: application/json' )

		cResponse := HTTPQuote ( ::cUrl + cPath, 'PUT', , EncodeUtf8( '[' + cJsonAluno + ']' ), 120, aHeader, @cHeaderRet )

		FWJsonDeserialize( cResponse, @oJson )

		lRet := aScan( ClassDataArr(oJson), { |X| AllTrim( UPPER( X[1] ) ) == 'ERRORS' } ) == 0

		If ! lRet

			cError := oJson:errors:description + CRLF

			If ValType( oJson:errors:message ) == 'C'

				cError := oJson:errors:message

			ElseIf ValType( oJson:errors:message ) == 'O'

				aErrors := aClone( ClassDataArr( oJson:errors:message:aluno ) )

				For nX := 1 To Len( aErrors )

					cError += aErrors[ nX, 1 ] + ': ' + aErrors[ nX, 2 ] + CRLF

				Next nX

			End If

		End If

	End If

Return lRet

/*/{Protheus.doc} Exclui
M�todo de Exclus�o da classe BraviApi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Logical, Indica se a opera��o foi bem sucedida
@param cId, characters, Id do aluno a ser exclu�do
@param cError, characters, Vari�vel passada por refer�ncia que ser� populada com a mensagem de erro retornada pelo Web Service
/*/
Method Exclui( cId, cError ) Class BraviApi

	Local lRet        := .T.
	Local cPath       := '/v1/alunos/'
	Local aHeader     := {}
	Local cHeaderRet  := ''
	Local cToken      := ''
	Local cError      := ''
	Local cResponse   := ''
	Local oJson       := Nil

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, 'Authorization: ' + cToken       )
		aAdd( aHeader, 'Accept: application/json'       )
		aAdd( aHeader, 'Content-Type: application/json' )

		cResponse := HTTPQuote ( ::cUrl + cPath  + cId, 'DELETE', , , 120, aHeader, @cHeaderRet )

		FWJsonDeserialize( cResponse, @oJson )

		lRet := aScan( ClassDataArr(oJson), { |X| AllTrim( UPPER( X[1] ) ) == 'ERRORS' } ) == 0

		If ! lRet

			cError := oJson:errors:description + CRLF

			If ValType( oJson:errors:message ) == 'C'

				cError := oJson:errors:message

			ElseIf ValType( oJson:errors:message ) == 'O'

				aErrors := aClone( ClassDataArr( oJson:errors:message:aluno ) )

				For nX := 1 To Len( aErrors )

					cError += aErrors[ nX, 1 ] + ': ' + aErrors[ nX, 2 ] + CRLF

				Next nX

			End If

		End If

	End If

Return lRet

/*/{Protheus.doc} GetToken
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param cUrl, characters, Url do Web Service a ser invocando
@param cUserName, characters, UserName para geração Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para geração Token de acesso as rotinas do Web Service
@param cToken, characters, Variável passada por referência que será populada com o Token
@param cError, characters, Variável passada por referência que será populada com a mensagem de erro retornada pelo Web Service
@return Logical, Indica se a operação ocorreu com sucesso
/*/
Static Function GetToken( cUrl, cUserName, cPassWord, cToken, cError )

	Local oRestClient := FWRest():New( cUrl )
	Local oAuth       := U_GetAuthBravi( cUserName, cPassWord )
	Local cPath       := '/v1/auth'
	Local aHeader     := { }
	Local lRet        := .F.
	Local oJson       := Nil

	aAdd( aHeader, 'Accept: application/json'       )
	aAdd( aHeader, 'Content-Type: application/json' )

	oRestClient:setPath( cPath )
	oRestClient:SetPostParams( EncodeUtf8( oAuth:GetJson() ) )

	oRestClient:Post( aHeader )

	FWJsonDeserialize( oRestClient:GetResult(), @oJson )

	lRet := aScan( ClassDataArr(oJson), { |X| AllTrim( Upper( X[1] ) ) == 'ACCESS_TOKEN' } ) # 0

	If lRet

		cToken := oJson:token_type + ' ' + oJson:access_token

	Else

		cError := oJson:error:description

	End If

Return lRet
