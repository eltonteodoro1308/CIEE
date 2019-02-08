#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} GetBraviApi
Retorna a instância do objeto que representa a conexão com o Web Service Rest de integração com o Bravi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Objeto, Objeto que representa a conexão com o Web Service Rest de integração com o Bravi
/*/

//username -> bravi1
//password -> bravi@2017

User Function GetBraviApi( cUrl, cUserName, cPassWord )

	Local oRet := BraviApi():New( cUrl, cUserName, cPassWord )

Return oRet

/*/{Protheus.doc} BraviApi
Classe que representa a conexão com o Web Service Rest de integração com o Bravi
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
/*/
Class BraviApi

	Data cUrl
	Data cUserName
	Data cPassWord

	Method New( cUrl, cUserName, cPassWord ) CONSTRUCTOR
	Method Consulta( cId )
	Method Exclui( cId )
	Method Inclui( aList )
	Method Altera( aList )

End Class

Method New( cUrl, cUserName, cPassWord ) Class BraviApi

	::cUrl      := cUrl
	::cUserName := cUserName
	::cPassWord := cPassWord

Return Self

Method Consulta( cId, aAlunos, cError ) Class BraviApi

	Local oRestClient := FWRest():New( ::cUrl )
	Local cPath       := '/v1/alunos/' + AllTrim( cId )
	Local aHeader     := {}
	Local cToken      := ''
	Local lRet        := .F.

	oRestClient:setPath( cPath )

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, { 'Authorization: Basic ' + cToken } )

		If lRet := oRestClient:Get( aHeader )

			FWJsonDeSerialize( oRestClient:GetResult(), @aAlunos )

		Else

			cError := oRestClient:GetLastError()

		End IF

	End If

Return lRet

Method Exclui( cId, cError ) Class BraviApi

	Local oRestClient := FWRest():New( ::cUrl )
	Local cPath       := '/v1/alunos/' + AllTrim( cId )
	Local aHeader     := {}
	Local cToken      := ''
	Local lRet        := .F.

	oRestClient:setPath( cPath )

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, { 'Authorization: Basic ' + cToken } )

		lRet := oRestClient:Delete( aHeader )

		If ! lRet

			cError := oRestClient:GetLastError()

		End IF

	End If

Return lRet

Method Inclui( aList, cError ) Class BraviApi

	Local oRestClient := FWRest():New( ::cUrl )
	Local cPath       := '/v1/alunos/' + AllTrim( cId )
	Local aHeader     := {}
	Local cToken      := ''
	Local lRet        := .F.

	oRestClient:setPath( cPath )
	oRestClient:SetPostParams( FWJsonSerialize( aList, .F., .F. ) )

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, { 'Authorization: Basic ' + cToken } )

		lRet := oRestClient:Post( aHeader )

		If ! lRet

			cError := oRestClient:GetLastError()

		End IF

	End If

Return lRet

Method Altera( aList, cError ) Class BraviApi

	Local oRestClient := FWRest():New( ::cUrl )
	Local cPath       := '/v1/alunos/' + AllTrim( cId )
	Local aHeader     := {}
	Local cToken      := ''
	Local lRet        := .F.

	oRestClient:setPath( cPath )
	oRestClient:SetPostParams( FWJsonSerialize( aList, .F., .F. ) )

	If lRet := GetToken( ::cUrl, ::cUserName, ::cPassWord, @cToken, @cError )

		aAdd( aHeader, { 'Authorization: Basic ' + cToken } )

		lRet := oRestClient:Post( aHeader )

		If ! lRet

			cError := oRestClient:GetLastError()

		End IF

	End If

Return lRet

Class BraviAuth

	Data username
	Data password

	Method New( cUserName, cPassWord ) CONSTRUCTOR
	Method GetJson()

End Class

Method New( cUserName, cPassWord ) Class BraviAuth

	::username := cUserName
	::password := cPassWord

Return Self

Method GetJson() Class BraviAuth

	Local cRet := FWJsonSerialize( Self, .F., .F. )

Return cRet

Static Function GetToken( cUrl, cUserName, cPassWord, cToken, cError )

	Local oRestClient := FWRest():New( cUrl )
	Local oAuth       := BraviAuth():New( cUserName, cPassWord )
	Local cPath       := '/v1/auth'
	Local aHeader     := {}
	Local lRet        := ''

	oRestClient:setPath( cPath )
	oRestClient:SetPostParams( oAuth:GetJson() )

	lRet := oRestClient:Post( aHeader )

	If lRet

		cToken := oRestClient:GetResult()

	Else

		cError := oRestClient:GetLastError()

	EndIf

Return lRet



/*
Class BraviAluno

Data matricula
Data cpf
Data nome
Data apelido
Data nascimento
Data id_areaconhecimento
Data areaconhecimento
Data id_cargo
Data cargo
Data id_setor
Data setor
Data admissao
Data rescisao
Data id_situacao
Data situacao
Data id_local
Data local
Data id_vinculo
Data vinculo
Data email
Data celularddd
Data celularnumero
Data superior
Data id_nivel
Data nivelcargo
Data login
Data id_gerencia
Data gerencia
Data id_superintendencia
Data superintendencia
Data empresa

Method New() CONSTRUCTOR
 Method GetJson()

End Class
*/