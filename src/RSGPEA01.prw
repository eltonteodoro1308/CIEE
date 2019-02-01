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
WSDATA TIPO        AS STRING
WSDATA VERSAO      AS STRING OPTIONAL
WSDATA EMREV       AS STRING OPTIONAL

WSMETHOD GET  DESCRIPTION 'Consulta'  WSSYNTAX '/CONVENENTES'
WSMETHOD POST DESCRIPTION 'Inclus�o'  WSSYNTAX '/CONVENENTES'
WSMETHOD PUT  DESCRIPTION 'Altera��o' WSSYNTAX '/CONVENENTES'

END WSRESTFUL

/*/{Protheus.doc} GET
M�todo GET de consulta ao cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD GET QUERYPARAM CONTRATO, LOCALIDADE, TIPO, VERSAO, EMREV WSRESTFUL CONVENENTES

Local aRetorno
// Array que recebe os dados do resultado da opera��o solicitada
// Posic�o 1 - .T. ou .F. indicando sucesso da opera��o
// Posi��o 2 - String a ser retornada pelo m�todo ou
// Mensagem indicando o problema ocorrido na opera��o
// Conforme sucesso ou fracasso da opera��o

//Define que m�todo ir� retornar um json
::SetContentType('application/json')

If ::TIPO == '0'

	aRetorno := Matriz2Alt( ::CONTRATO, ::LOCALIDADE )

	If aRetorno[ 1 ]

		::SetResponse( aRetorno[ 2 ] )

	Else

		SetRestFault( 404, EncodeUtf8( aRetorno[ 2 ] ) )

		Return .F.

	End If

ElseIf ::TIPO == '1'

	aRetorno := LstVersao( ::CONTRATO, ::LOCALIDADE )

	If aRetorno[ 1 ]

		::SetResponse( aRetorno[ 2 ] )

	Else

		SetRestFault( 404, EncodeUtf8( aRetorno[ 2 ] ) )

		Return .F.

	End If

ElseIf ::TIPO == '2'

	If ! Empty( ::EMREV ) .And. ! AllTrim( ::EMREV ) $ 'true/false'

		SetRestFault( 400, EncodeUtf8( 'Par�metro EMREV s� permite valor true ou false' ), .T. )

		Return .F.

	End If

	aRetorno := GetMatriz( ::CONTRATO, ::LOCALIDADE, ::VERSAO, ::EMREV )

	If aRetorno[ 1 ]

		::SetResponse( aRetorno[ 2 ] )

	Else

		SetRestFault( 404, EncodeUtf8( aRetorno[ 2 ] ) )

		Return .F.

	End If

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
WSMETHOD POST WSRESTFUL CONVENENTES

Local aRetorno
// Array que recebe os dados do resultado da opera��o solicitada
// Posic�o 1 - .T. ou .F. indicando sucesso da opera��o
// Posi��o 2 - Mensagem indicando resultado da opera��o
// Conforme sucesso ou fracasso da opera��o

Local cResponse := ''

//Define que m�todo ir� retornar um json
::SetContentType('application/json')

aRetorno := IncContr( ::GetContent() )

If aRetorno[ 1 ]

	cResponse := EncodeUtf8( '{ "Id": "200", "Descricao": "' + aRetorno[ 2 ] + '" }' )

Else

	SetRestFault( 400, EncodeUtf8( aRetorno[ 2 ] ), .T. )

	Return .F.

End If

::SetResponse( cResponse )

Return .T.

/*/{Protheus.doc} PUT
M�todo PUT de inclus�o de uma nova vers�o do cadastro de Convenentes
@author Elton Teodoro Alves
@since 22/01/2019
@version 12.1.17
/*/
WSMETHOD PUT QUERYPARAM TIPO WSRESTFUL CONVENENTES

Local aRetorno
// Array que recebe os dados do resultado da opera��o solicitada
// Posic�o 1 - .T. ou .F. indicando sucesso da opera��o
// Posi��o 2 - Mensagem indicando resultado da opera��o
// Conforme sucesso ou fracasso da opera��o

Local cResponse := ''

//Define que m�todo ir� retornar um json
::SetContentType('application/json')

If ::TIPO $ '012'

	aRetorno := AltContr( ::GetContent(), ::TIPO )

	If aRetorno[ 1 ]

		cResponse := EncodeUtf8( '{ "Id": "200", "Descricao": "' + aRetorno[ 2 ] + '" }' )

	Else

		SetRestFault( 400, EncodeUtf8( aRetorno[ 2 ] ), .T. )

		Return .F.

	End If

Else

	SetRestFault( 400, EncodeUtf8( 'Tipo de requisi��o inv�lida' ), .T. )

	Return .F.

End If

::SetResponse( cResponse )

Return .T.

/*/{Protheus.doc} Matriz2Alt
Verifica se a matriz de um Contrato/Localidade pode ser alterada
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@return array, Array com resultado da opera��o
/*/
Static Function Matriz2Alt( cContrato, cLocalidade )

	Local aArea   := GetArea()
	Local aRet    := {}
	Local cSeek   := ''

	//TODO Implementar a valida��o refente a crit�rios pertinentes
	//TODO ao cadastro de convenentes

	// Ajusta os c�digos de contrato e localidade para o tamanho definido no dicion�rio
	cContrato   := PadR( AllTrim( cContrato )  , GetSx3Cache( 'ZZ1_CONTRA', 'X3_TAMANHO' ) )
	cLocalidade := PadR( AllTrim( cLocalidade ), GetSx3Cache( 'ZZ1_LOCALI', 'X3_TAMANHO' ) )

	cSeek := xFilial( 'ZZ1' ) + cContrato + cLocalidade

	DbSelectArea( 'ZZ1' )
	DbSetOrder( 2 ) // ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI + ZZ1_STATUS + ZZ1_PROCES

	// Verifica se o Contrato/Localidade existe no controle de vers�es
	If ! DbSeek( cSeek )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Registro n�o Localizado.' )

	Else

		cSeek += '0' +  '1'

		aAdd( aRet, .T. )
		aAdd( aRet, FWJsonSerialize( { ! DbSeek( cSeek ) }, .F., .F.  ) )

	End If

	RestArea( aArea )

Return aRet

/*/{Protheus.doc} LstVersao
Lista as vers�es da matriz de um contrato/Localidade com seu status correspondentes
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@return array, Array com resultado da opera��o
/*/
Static Function LstVersao( cContrato, cLocalidade )

	Local aArea   := GetArea()
	Local aRet    := {}
	Local aAux    := {}
	Local cSeek   := ''

	// Ajusta os c�digos de contrato e localidade para o tamanho definido no dicion�rio
	cContrato   := PadR( AllTrim( cContrato )  , GetSx3Cache( 'ZZ1_CONTRA', 'X3_TAMANHO' ) )
	cLocalidade := PadR( AllTrim( cLocalidade ), GetSx3Cache( 'ZZ1_LOCALI', 'X3_TAMANHO' ) )

	cSeek := xFilial( 'ZZ1' ) + cContrato + cLocalidade

	DbSelectArea( 'ZZ1' )
	DbSetOrder( 1 ) // ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI + ZZ1_STATUS + ZZ1_VERSAO

	// Verifica se o Contrato/Localidade existe no controle de vers�es
	If ! DbSeek( cSeek )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Registro n�o Localizado.' )

	Else

		Do While ZZ1->( ! Eof() ) .And. cSeek == ZZ1->( ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI )

			aAdd( aAux, ZZ1->( { ZZ1_VERSAO, ZZ1_STATUS } ) )

			ZZ1->( DbSkip() )

		End Do

		aAdd( aRet, .T. )
		aAdd( aRet, FWJsonSerialize( aAux ) )

	End If

	RestArea( aArea )

Return aRet

/*/{Protheus.doc} GetMatriz
Retorna a vers�o de uma matriz de um contrato/localidade.
@author Elton Teodoro Alves
@since 29/01/2019
@version 12.1.17
@param cContrato, characters, C�digo do Contrato
@param cLocalidade, characters, C�digo da Localidade
@param cVersao, characters, Versao a ser requisitada, se n�o receber retorna a �ltima vers�o
@param cEmRev, characters, Indica se considera como �ltima vers�o a vers�o em revis�o
@return array, Array com resultado da opera��o
/*/
Static Function GetMatriz( cContrato, cLocalidade, cVersao, cEmRev )

	Local aArea   := GetArea()
	Local aRet    := {}
	Local cSeek   := ''

	Default cVersao := ''
	Default cEmRev  := ''

	// Ajusta os c�digos de contrato e localidade para o tamanho definido no dicion�rio
	cContrato   := PadR( AllTrim( cContrato )  , GetSx3Cache( 'ZZ1_CONTRA', 'X3_TAMANHO' ) )
	cLocalidade := PadR( AllTrim( cLocalidade ), GetSx3Cache( 'ZZ1_LOCALI', 'X3_TAMANHO' ) )

	cSeek := xFilial( 'ZZ1' ) + cContrato + cLocalidade

	DbSelectArea( 'ZZ1' )

	If ! Empty( cVersao )

		cSeek += cVersao

		DbSetOrder( 1 ) // ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI + ZZ1_STATUS + ZZ1_VERSAO

	ElseIf Empty( cVersao ) .And. cEmRev # 'true'

		DbSetOrder( 2 ) // ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI + ZZ1_STATUS + ZZ1_PROCES

		cSeek += '1'

	ElseIf Empty( cVersao ) .And. cEmRev == 'true'

		DbSetOrder( 2 ) // ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI + ZZ1_STATUS + ZZ1_PROCES

		If DbSeek( cSeek + '0' )

			cSeek += '0'

		End If

	End If

	// Verifica se o Contrato/Localidade existe no controle de vers�es
	If ! DbSeek( cSeek )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Registro n�o Localizado.' )

	Else

		aAdd( aRet, .T. )
		aAdd( aRet, ZZ1->ZZ1_JSON )

	End If

	RestArea( aArea )

Return aRet

/*/{Protheus.doc} IncContr

@author Elton Teodoro Alves
@since 30/01/2019
@version 12.1.17
@param cJson, characters, Json com dados de inclus�o de um contrato/localidade/matriz
@return array, Array com resultado da opera��o
/*/
Static Function IncContr( cJson )

	Local aRet        := {}
	Local aArea       := GetArea()
	Local cSeek       := ''
	Local oJson       := Nil
	Local cContrato   := ''
	Local cLocalidade := ''

	// Veririca se foi poss�vel deserializar o json
	If ! FWJsonDeserialize( cJson, @oJson )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Json recebido n�o pode ser inst�nciado.' )

		Return aRet

	End If

	// Ajusta os c�digos de contrato e localidade para o tamanho definido no dicion�rio
	cContrato   := PadR( AllTrim( oJson:Contrato:Codigo   ), GetSx3Cache( 'ZZ1_CONTRA', 'X3_TAMANHO' ) )
	cLocalidade := PadR( AllTrim( oJson:Localidade:Codigo ), GetSx3Cache( 'ZZ1_LOCALI', 'X3_TAMANHO' ) )

	DbSelectArea( 'ZZ1' )
	DbSetOrder( 1 )

	cSeek := xFilial( 'ZZ1' ) + cContrato + cLocalidade

	// Verifica se o contrato/localidade/matriz j� n�o foi inclu�do
	If DbSeek( cSeek )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Contrato/Localidade/Matriz j� inclu�do.' )

		Return aRet

	End If

	//TODO Definir aqui a valida��o para inclus�o do convenentes
	If .T. //Randomize( 1, 100 ) % 2 # 0

		RecLock( 'ZZ1', .T. )

		ZZ1->ZZ1_FILIAL := xFilial( 'ZZ1' )
		ZZ1->ZZ1_CONTRA := cContrato
		ZZ1->ZZ1_LOCALI := cLocalidade
		ZZ1->ZZ1_VERSAO := '000'
		ZZ1->ZZ1_STATUS := '0'
		ZZ1->ZZ1_PROCES := '2'
		ZZ1->ZZ1_JSON   := FWJsonSerialize( oJson:Matriz, .F., .F. )

		MsUnlock()

		aAdd( aRet, .T. )
		aAdd( aRet, 'Registro Inclu�do com Sucesso.' )

	Else

		aAdd( aRet, .F. )
		aAdd( aRet, 'Dados incorretos' )

	End If

	RestArea( aArea )

Return aRet

/*/{Protheus.doc} AltContr

@author Elton Teodoro Alves
@since 31/01/2019
@version 12.1.17
@param cJson, characters, Json com dados de um contrato/localidade/matriz
@param cTipo, characters, Tipo de altera��o 0=Contrato, 1=Localidade, 2=Matriz
@return array, Array com resultado da opera��o
/*/
Static Function AltContr( cJson, cTipo )

	Local aRet        := {}
	Local aArea       := GetArea()
	Local cSeek       := ''
	Local oJson       := Nil
	Local cContrato   := ''
	Local cLocalidade := ''
	Local cVersao     := ''
	Local lAdd        := .F.

	// Veririca se foi poss�vel deserializar o json
	If ! FWJsonDeserialize( cJson, @oJson )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Json recebido n�o pode ser inst�nciado.' )

		Return aRet

	End If

	// Ajusta os c�digos de contrato e localidade para o tamanho definido no dicion�rio
	cContrato   := PadR( AllTrim( oJson:Contrato:Codigo   ), GetSx3Cache( 'ZZ1_CONTRA', 'X3_TAMANHO' ) )
	cLocalidade := PadR( AllTrim( oJson:Localidade:Codigo ), GetSx3Cache( 'ZZ1_LOCALI', 'X3_TAMANHO' ) )

	DbSelectArea( 'ZZ1' )
	DbSetOrder( 1 )

	cSeek := xFilial( 'ZZ1' ) + cContrato + cLocalidade

	// Verifica se o contrato/localidade/matriz j� n�o foi inclu�do
	If ! DbSeek( cSeek )

		aAdd( aRet, .F. )
		aAdd( aRet, 'Contrato/Localidade/Matriz n�o localizado.' )

		Return aRet

	End If

	// Verifica se o contrato/localidade/matriz tem vers�o em revis�o

	DbSetOrder( 2 )

	If DbSeek( cSeek + '0' + '1')

		aAdd( aRet, .F. )
		aAdd( aRet, 'Contrato/Localidade/Matriz em revis�o.' )

		Return aRet

	End If

	If cTipo == '0'

		//TODO Altera��o do contrato

	ElseIf cTipo == '1'

		//TODO Altera��o da localidade

	ElseIf cTipo == '2'

		lAdd := ! DbSeek( cSeek + '0' + '2' )

		If ! lAdd

			cVersao := ZZ1->ZZ1_VERSAO

		Else

			DbSetOrder( 1 )

			DbSeek( cSeek + '000')

			Do While ZZ1->( ! Eof() ) .And. cSeek == ZZ1->( ZZ1_FILIAL + ZZ1_CONTRA + ZZ1_LOCALI )

				cVersao := ZZ1->ZZ1_VERSAO

				ZZ1->( DbSkip() )

			End Do

		End If

		//TODO Definir aqui a altera��o da matriz do convenente
		If .T. //Randomize( 1, 100 ) % 2 # 0

			RecLock( 'ZZ1', lAdd )

			ZZ1->ZZ1_FILIAL := xFilial( 'ZZ1' )
			ZZ1->ZZ1_CONTRA := cContrato
			ZZ1->ZZ1_LOCALI := cLocalidade
			ZZ1->ZZ1_VERSAO := Soma1( cVersao )
			ZZ1->ZZ1_STATUS := '0'
			ZZ1->ZZ1_PROCES := '2'
			ZZ1->ZZ1_JSON   := FWJsonSerialize( oJson:Matriz, .F., .F. )

			MsUnlock()

			aAdd( aRet, .T. )
			aAdd( aRet, 'Registro Processado com Sucesso.' )

		Else

			aAdd( aRet, .F. )
			aAdd( aRet, 'Dados incorretos' )

		End If

	End If

	RestArea( aArea )

Return aRet