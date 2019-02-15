#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} GetAuthBravi
Retorna a inst‚ncia do objeto que representa o Json a ser enviado ao Web Service de requisiÁ„o do Token
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param cUserName, characters, UserName para geraÁ„o Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para geraÁ„o Token de acesso as rotinas do Web Service
@return Object, Inst√¢ncia da Classe BraviAuth
/*/
User Function GetAuthBravi( cUserName, cPassWord )

	Local oRet := BraviAuth():New( cUserName, cPassWord )

Return oRet

/*/{Protheus.doc} BraviAuth
Classe que representa o Json a ser enviado ao Web Service de requisi√ß√£o do Token
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
M√©todo Construtor da classe BraviAuth
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Object, Inst√¢ncia da Classe BraviAuth
@param cUserName, characters, UserName para gera√ß√£o Token de acesso as rotinas do Web Service
@param cPassWord, characters, PassWord para gera√ß√£o Token de acesso as rotinas do Web Service
/*/
Method New( cUserName, cPassWord ) Class BraviAuth

	::username := cUserName
	::password := cPassWord

Return Self

/*/{Protheus.doc} GetJson
Serializa a inst√¢ncia da Classe no formato json
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return characters, Json com os dados da inst√¢ncia
/*/
Method GetJson() Class BraviAuth

	Local cRet := ''

	cRet += '{'
	cRet += '"usernamex": "' + ::username + '",'
	cRet += '"passwordx": "' + ::password + '"'
	cRet += '}'

Return cRet