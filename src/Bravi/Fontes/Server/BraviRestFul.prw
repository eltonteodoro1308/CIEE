#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} BraviRestFul
Web Service Rest para envio dos cursos ministrados aos alunos
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
/*/
WSRESTFUL BraviRestFul DESCRIPTION 'Manutenção do Cadastro de Cursos de Alunos registrados no Bravi' FORMAT APPLICATION_JSON

WSDATA _queryparam AS STRING OPTIONAL

WSMETHOD POST DESCRIPTION &(;
'Faz a manutenção do cadastro de cursos do funcionário<br><br>'+;
'<b><u>Exemplo do Json de requisição:</u></b><br><br>'+;
'{<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"id": "103345",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"categoria": "001",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"curso": "0001",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"entidade": "0001",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"duracao": 50,<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"unidade_duracao": "H",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"percentual_presenca": 100,<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"data_inicio": "20180601",<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"data_fim": "20181031"<br>'+;
'}<br><br>'+;
'<b><u>Exemplo do Json de resposta:</u></b><br><br>'+;
'{<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"success": true,<br>'+;
'&nbsp;&nbsp;&nbsp;&nbsp;"message": "Registro incluído com sucesso."<br>'+;
'}<br>';
)  WSSYNTAX '/BraviRestFul'

END WSRESTFUL

/*/{Protheus.doc} POST
Metodo POST que recebe o Json com dados do curso a ser incluído para o aluno
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
/*/
WSMETHOD POST WSRESTFUL BraviRestFul

Local oJson := Nil

::SetContentType('application/json')

FwJsonDeserialiaze( ::GetContent(), @oJson )

::SetResponse( Processa( oJson ) )

Return .T.

/*/{Protheus.doc} Processa
Processa o Json recebido e retorna com o resultado positivo ou negativo da operação
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param oJson, object, Obejto que representa o Json recebido
@return caracter, Json com resultado da operação
/*/
Static Function Processa( oJson )

	Local cSuccess := 'true'
	Local cMessage := 'Registro incluído com sucesso.'
	Local lOk      := .T.
	Local aArea    := GetArea()
	Local lLock    := .F.
	Local cMat     := ''

	lOk :=;
	VldId      ( oJson:id                 , @cMat         , @cSuccess, @cMessage ) .And.;
	VldCateg   ( oJson:categoria                          , @cSuccess, @cMessage ) .And.;
	VldCurso   ( oJson:curso                              , @cSuccess, @cMessage ) .And.;
	VldEntid   ( oJson:entidade           , oJson:curso   , @cSuccess, @cMessage ) .And.;
	VldDurac   ( oJson:duracao                            , @cSuccess, @cMessage ) .And.;
	VldUnDurac ( oJson:unidade_duracao                    , @cSuccess, @cMessage ) .And.;
	VldPercPres( oJson:percentual_presenca                , @cSuccess, @cMessage ) .And.;
	VldDtInFim ( oJson:data_inicio        , oJson:data_fim, @cSuccess, @cMessage )

	If lOk

		DbSelectArea( 'RA4' )
		DbSetOrder( 1 ) // RA4_FILIAL+RA4_MAT+RA4_CURSO

		lLock := ! DbSeek( xFilial( 'RA4' ) + cMat + oJson:curso )

		RecLock( 'RA4', lLock )

		RA4->RA4_FILIAL := xFilial( 'RA4' )
		RA4->RA4_MAT    := cMat
		RA4->RA4_CATCUR := oJson:categoria
		RA4->RA4_CURSO  := oJson:curso
		RA4->RA4_ENTIDA := oJson:entidade
		RA4->RA4_DURACA := oJson:duracao
		RA4->RA4_UNDURA := oJson:unidade_duracao
		RA4->RA4_PRESEN := oJson:percentual_presenca
		RA4->RA4_DATAIN := StoD( oJson:data_inicio )
		RA4->RA4_DATAFI := StoD( oJson:data_fim    )

		MsUnlock()

	End If

	RestArea( aArea )

Return RetMessage( cSuccess, cMessage )

/*/{Protheus.doc} VldId
Valida o id recebido no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cId, characters, id a ser verificado no campo ZRA_BRAVI
@param cMat, characters, Variável recebida por referência para ser populada com a matrícula do funcionário
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se o id recebido é válido
/*/
Static Function VldId( cId, cMat, cSuccess, cMessage )

	Local lRet := .F.
	Local aArea    := GetArea()

	DbSelectArea( 'ZRA' )
	DbSetOrder( 2 ) // ZRA_BRAVI

	lRet :=;
	ValType( cId ) == 'C' .And.;
	! Empty( cId ) .And.;
	DbSeek( AllTrim( cId ) )

	cMat := ZRA->ZRA_MAT

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe um id válido.'

	End If

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} VldCateg
Valida o Código da Categoria recebido no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cCategoria, characters, Código da Categoria a ser verificado na Tabela AIQ
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se a Categoria recebida é válida
/*/
Static Function VldCateg( cCategoria, cSuccess, cMessage )

	Local lRet := .F.
	Local aArea    := GetArea()

	DbSelectArea( 'AIQ' )
	DbSetOrder( 1 ) // AIQ_FILIAL + AIQ_CODIGO

	lRet :=;
	ValType( cCategoria ) == 'C' .And.;
	! Empty( cCategoria ) .And.;
	DbSeek( xFilial( 'AIQ' ) + AllTrim( cCategoria ) )

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe uma categoria válida.'

	End If

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} VldCurso
Valida o Código do Curso recebido no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cCurso, characters, Código do Curso a ser verificado na Tabela RA1
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se o Curso recebido é válido
/*/
Static Function VldCurso( cCurso, cSuccess, cMessage )

	Local lRet := .F.
	Local aArea    := GetArea()

	DbSelectArea( 'RA1' )
	DbSetOrder( 1 ) // RA1_FILIAL+RA1_CURSO

	lRet :=;
	ValType( cCurso ) == 'C' .And.;
	! Empty( cCurso ) .And.;
	DbSeek( xFilial( 'RA1' ) + AllTrim( cCurso ) )

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe um curso válido.'

	End If

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} VldEntid
Valida o Código da entidade recebida no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cEntidade, characters, Código da Categoria a ser verificada na Tabela RA6
@param cCurso, characters, Código do Curso a ser verificado na Tabela RA6
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se a entidade recebida é válida
/*/
Static Function VldEntid( cEntidade, cCurso, cSuccess, cMessage )

	Local lRet := .F.
	Local aArea    := GetArea()

	cEntidade := PadL( AllTrim( cEntidade ), TamSx3( 'RA6_ENTIDA' )[ 1 ] )
	cCurso    := PadL( AllTrim( cCurso )   , TamSx3( 'RA6_ENTIDA' )[ 1 ] )

	DbSelectArea( 'RA6' )
	DbSetOrder( 1 ) // RA6_FILIAL+RA6_ENTIDA+RA6_CURSO

	lRet :=;
	ValType( cCurso ) == 'C' .And.;
	! Empty( cCurso ) .And.;
	DbSeek( xFilial( 'RA6' ) + cEntidade + cCurso )

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe uma entidade válida para o curso.'

	End If

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} VldDurac
Valida o tempo de duração do Curso recebido no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param nDuracao, numeric, Tempo de duração do curso
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se o tempo de duração recebido é válido
/*/
Static Function VldDurac( nDuracao, cSuccess, cMessage )

	Local lRet := .F.

	lRet :=;
	ValType( nDuracao ) == 'N' .And.;
	nDuracao > 0

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe um tempo de duração válido e maior que zero.'

	End If

Return lRet

/*/{Protheus.doc} VldUnDurac
Valida a unidade do tempo de duração recebida no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cUnDurac, characters, Código da unidade do tempo de duração na tabela genérica R5 (SX5)
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se a unidade do tempo de duração recebida é válida
/*/
Static Function VldUnDurac( cUnDurac, cSuccess, cMessage )

	Local lRet := .F.
	Local aArea    := GetArea()

	DbSelectArea( 'SX5' )
	DbSetOrder( 1 ) // X5_FILIAL+X5_TABELA+X5_CHAVE

	lRet :=;
	ValType( cUnDurac ) == 'C' .And.;
	! Empty( cUnDurac ) .And.;
	DbSeek( xFilial( 'RA6' ) + 'R5' + AllTrim( cUnDurac ) )

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe uma unidade de medida do tempo de duração válida.'

	End If

	RestArea( aArea )

Return lRet

/*/{Protheus.doc} VldPercPres
Valida o percentual de presença do Curso recebido no Json da requisição
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param nPercPres, numeric, Percentual de presença
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se o percentual de presença recebido é válido
/*/
Static Function VldPercPres( nPercPres, cSuccess, cMessage )

	Local lRet := .F.

	lRet :=;
	ValType( nPercPres ) == 'N' .And.;
	nPercPres > 0

	If ! lRet

		cSucces  := 'false'
		cMessage := 'Informe um tempo de duração válido e maior que zero.'

	End If

Return lRet

/*/{Protheus.doc} VldDtInFim
Valida a data de início e fim do curso
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cDtInic, characters, Data inicial do curso AAAAMMDD
@param cDataFim, characters, Data final do curso AAAAMMDD
@param cSuccess, characters, Variavel recebida por referência com valor true ou falso indicando o sucesso da operação
@param cMessage, characters, Mensagem de retorno da operação
@return logic, indica se a data de início e fim do curso recebidos são válidos
/*/
Static Function VldDtInFim( cDtInic, cDataFim, cSuccess, cMessage )

	Local lRet := .F.

	lRet :=;
	ValType( StoD( cDtInic ) ) == 'D' .And.;
	ValType( StoD( cDataFim ) ) == 'D' .And.;
	StoD( cDtInic ) # StoD('') .And.;
	StoD( cDataFim ) # StoD('') .And.;
	StoD( cDtInic ) <= StoD( cDataFim )

	If ! lRet

		cSuccess  := 'false'
		cMessage := 'Informe uma data de início e fim do curso válidas no formato AAAAMMDD e onde a data início seja igual ou anterior a data final.'

	End If

Return lRet

/*/{Protheus.doc} RetMessage
Monta o Json de retorno com o resultado da operação
@author Elton Teodoro Alves
@since 20/02/2019
@version 12.1.17
@param cSucces, characters, Indica true ou false para o sucesso da operação
@param cMessage, characters, Descrição do Status da operação
@return caracter, Json de retorno com o resultado da operação
/*/
Static Function RetMessage( cSucces, cMessage )

	Local cRet := ''

	cRet += '{"success": ' + cSucces  + ','
	cRet += '"message": "' + cMessage + '"}'

Return EncodeUtf8( cRet )