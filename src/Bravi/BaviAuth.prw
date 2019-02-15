#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} GetAuthBravi
Retorna a inst�ncia do objeto que representa o Json a ser enviado ao Web Service de requisi��o do Token
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param cUserName, characters, UserName para gera��o Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para gera��o Token de acesso as rotinas do Web Service
@return Object, Instância da Classe BraviAuth
/*/
User Function GetAuthBravi( cUserName, cPassWord )

	Local oRet := BraviAuth():New( cUserName, cPassWord )

Return oRet

/*/{Protheus.doc} BraviAuth
Classe que representa o Json a ser enviado ao Web Service de requisição do Token
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
/*/
Class BraviAuth

	Data username
	Data password

	Method New( cUserName, cPassWord ) CONSTRUCTOR
	Method GetJson()

End Class

/*/{Protheus.doc} New
Método Construtor da classe BraviAuth
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Object, Instância da Classe BraviAuth
@param cUserName, characters, UserName para geração Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para geração Token de acesso as rotinas do Web Service
/*/
Method New( cUserName, cPassWord ) Class BraviAuth

	::username := cUserName
	::password := cPassWord

Return Self

/*/{Protheus.doc} GetJson
Serializa a instância da Classe no formato json
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return characters, Json com os dados da instância
/*/
Method GetJson() Class BraviAuth

	Local cRet := ''

	cRet += '{'
	cRet += '"usernamex": "' + ::username + '",'
	cRet += '"passwordx": "' + ::password + '"'
	cRet += '}'

Return cRet