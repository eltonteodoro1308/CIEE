#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} GetAlunoBravi
Retorna a instância do objeto que representa o Json a ser enviado ao Web Service na inclusão/alteração do Web Service
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Objeto, Objeto que representa o Json a ser enviado ao Web Service na inclusão/alteração do Web Service
/*/
User Function GetAlunoBravi()

	Local oRet := BraviAluno():New()

Return oRet

/*/{Protheus.doc} BraviAluno
Classe que representa o Json a ser enviado ao Web Service na inclusão/alteração do Web Service
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
/*/
Class BraviAluno

	Data Campos

	Method New() CONSTRUCTOR
	Method SetCampo( Campo, uValor )
	Method GetJson()

End Class

/*/{Protheus.doc} New
Método Construtor da classe BraviAluno
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@return Object, Instância da Classe BraviAluno
/*/
Method New() Class BraviAluno

	::Campos := {}

	aAdd( ::Campos, { "id"                  , '' } )
	aAdd( ::Campos, { "matricula"           , '' } )
	aAdd( ::Campos, { "cpf"                 , '' } )
	aAdd( ::Campos, { "nome"                , '' } )
	aAdd( ::Campos, { "apelido"             , '' } )
	aAdd( ::Campos, { "nascimento"          , '' } )
	aAdd( ::Campos, { "id_areaconhecimento" , '' } )
	aAdd( ::Campos, { "areaconhecimento"    , '' } )
	aAdd( ::Campos, { "id_cargo"            , '' } )
	aAdd( ::Campos, { "cargo"               , '' } )
	aAdd( ::Campos, { "id_setor"            , '' } )
	aAdd( ::Campos, { "setor"               , '' } )
	aAdd( ::Campos, { "admissao"            , '' } )
	aAdd( ::Campos, { "rescisao"            , '' } )
	aAdd( ::Campos, { "id_situacao"         , '' } )
	aAdd( ::Campos, { "situacao"            , '' } )
	aAdd( ::Campos, { "id_local"            , '' } )
	aAdd( ::Campos, { "local"               , '' } )
	aAdd( ::Campos, { "id_vinculo"          , '' } )
	aAdd( ::Campos, { "vinculo"             , '' } )
	aAdd( ::Campos, { "email"               , '' } )
	aAdd( ::Campos, { "celularddd"          , '' } )
	aAdd( ::Campos, { "celularnumero"       , '' } )
	aAdd( ::Campos, { "superior"            , '' } )
	aAdd( ::Campos, { "id_nivel"            , '' } )
	aAdd( ::Campos, { "nivelcargo"          , '' } )
	aAdd( ::Campos, { "login"               , '' } )
	aAdd( ::Campos, { "id_gerencia"         , '' } )
	aAdd( ::Campos, { "gerencia"            , '' } )
	aAdd( ::Campos, { "id_superintendencia" , '' } )
	aAdd( ::Campos, { "superintendencia"    , '' } )
	aAdd( ::Campos, { "empresa"             , '' } )
	aAdd( ::Campos, { "hierarquia"          , '' } )

Return Self

/*/{Protheus.doc} SetCampo
Define o valor dos campos
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param Campo, characters, Nome do Campo
@param uValor, undefined, Valor do Campo
@return logical, Retorna se a atribuição foi possível e o campos existe
/*/
Method SetCampo( Campo, uValor ) Class BraviAluno

	Local nPos := aScan( ::Campos, { | X | X[1] == Campo } )

	If nPos # 0

		::Campos[ nPos, 2 ] := uValor

	End If

Return nPos # 0

/*/{Protheus.doc} GetJson
Serializa a instância da Classe no formato json
@author Elton Teodoro Alves
@since 08/02/2019
@version 12.1.17
@param nOpc, Numeric, C�digo da Opera��o 3=Inclui
@return characters, Json com os dados da instância
/*/
Method GetJson( nOpc ) Class BraviAluno

	Local cRet   := ''
	Local uValor := Nil

	cRet += '{'

	For nX := 1 To Len( ::Campos )

		 If ( nOpc == 3 .And. ::Campos[ nX, 1 ] # "id" ) .Or. ( nOpc # 3 .And. nOpc # 7 )

			uValor := If( ValType( ::Campos[ nX, 2 ] ) == 'C', '"' + AllTrim( ::Campos[ nX, 2 ] ) + '"'  , uValor )
			uValor := If( ValType( ::Campos[ nX, 2 ] ) == 'N', cValToChar( ::Campos[ nX, 2 ] ), uValor )
			uValor := If( ValType( ::Campos[ nX, 2 ] ) $ 'CN', uValor, '' )

			cRet += '"' + ::Campos[ nX, 1 ] + '": ' + uValor

			If nX < Len( ::Campos )

				cRet += ','

			End If

		End If

	Next nX

	cRet += '}'

Return cRet