#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IntegBravi
Faz a inclusão, alteração e Exclusão do cadastro do Aluno no Bravi
@author Elton Teodoro Alves
@since 15/02/2019
@version 12.1.17
@param nOpc, Numeric, Código da Operação 3 = Inclui / 4 = Altera / 5 = Exclui
@return Logical, Se a operação ocorreu ou não com sucesso
/*/
User Function IntegBravi( nOpc )

	Local lRet      := .T.
	Local cMvBravi  := GetMv( 'CI_BRAVI' )
	Local aMvBravi  := StrTokArr2( cMvBravi, '|', .T. )
	Local oBraviApi := U_GetApiBravi( AllTrim( aMvBravi[ 1 ] ), AllTrim( aMvBravi[ 2 ] ), AllTrim( aMvBravi[ 3 ] ) )
	Local oAluno    := U_GetAlunoBravi()
	Local cError    := ''
	Local cId       := ''

	MontaJson( @oAluno, nOpc )

	cId := cValToChar( oAluno:Campos[ aScan( oAluno:Campos, { | X | X[ 1 ] == "id"} ) ][ 2 ] )

	If nOpc == 3 .Or. nOpc == 7 // Inclusão ou Cópia

		lRet := oBraviApi:Inclui( oAluno:GetJson( nOpc ), @cError, @cId )

		If ! lRet

			ShowMsg( cError )

		Else

			RecZRA( cId )

		End If

	ElseIf nOpc == 4 // Alteração

		If cId == '0'

			lRet := oBraviApi:Inclui( oAluno:GetJson( 3 ), @cError, @cId )

		Else

			lRet := oBraviApi:Altera( oAluno:GetJson( nOpc ), @cError )

		End If

		If lRet

			If nOpc == 4 .And. cValToChar( oAluno:Campos[ aScan( oAluno:Campos, { | X | X[ 1 ] == "id"} ) ][ 2 ] ) == '0'

				RecZRA( cId )

			End If

		Else

			ShowMsg( cError )

		End If

	ElseIf nOpc == 5 // Deleção

		lRet := oBraviApi:Exclui( cId, @cError )

		If ! lRet

			ShowMsg( cError )

		End If

	End If

Return lRet

/*/{Protheus.doc} MontaJson
Monta o obejto Json com base nos dados do cadastro de funcionário (Tabela SRA)
@author Elton Teodoro Alves
@since 19/02/2019
@version 12.1.17
@param oAluno, object, Variável recebida por referência que representa será populado com o objeto Json com os dados do aluno
@param nOpc, numeric, Código da operação executada para indicar que somente quando for alteração que a propriedade id será populada
/*/
Static Function MontaJson( oAluno, nOpc )

	Local uAux      := Nil
	Local aArea     := GetArea()
	Local aAreaSM0  := SM0->( GetArea() )
	Local cFil      := If( nOpc == 3 .Or. nOpc == 7 , cFilAnt, SRA->RA_FILIAL )

	If nOpc # 3 .And. nOpc # 7

		DbSelectArea( 'ZRA' )
		ZRA->( DbSetOrder( 1 ) )

		ZRA->( DbSeek( xFilial( 'ZRA' ) + M->RA_MAT ) )

		oAluno:SetCampo( "id", Val( ZRA->ZRA_BRAVI ) )

	End If

	oAluno:SetCampo( "matricula"           , Val( M->RA_MAT ) )
	oAluno:SetCampo( "cpf"                 , M->RA_CIC )
	oAluno:SetCampo( "nome"                , M->RA_NOMECMP )
	oAluno:SetCampo( "apelido"             , M->RA_APELIDO)

	uAux := PadL( Year ( M->RA_NASC ), 4, '0' ) + '-'
	uAux += PadL( Month( M->RA_NASC ), 2, '0' ) + '-'
	uAux += Padl( Day  ( M->RA_NASC ), 2, '0' )

	oAluno:SetCampo( "nascimento"          , uAux)

	//TODO Criar Campo // oAluno:SetCampo( "id_areaconhecimento" , 3)
	//TODO Criar Campo //oAluno:SetCampo( "areaconhecimento"    , 'Técnicas')

	oAluno:SetCampo( "id_cargo"            , Val( M->RA_CARGO ) )

	//TODO Criar Campo //oAluno:SetCampo( "cargo"               , 'Orientador Educacional')

	oAluno:SetCampo( "id_setor"            , Val( M->RA_CC ) )
	oAluno:SetCampo( "setor"               , Posicione( 'CTT', 1, xFilial( 'CTT' ) + M->RA_CC, 'CTT_DESC01' ) )

	uAux := Padl( Year ( M->RA_ADMISSA ), 4, '0' ) + '-'
	uAux += Padl( Month( M->RA_ADMISSA ), 2, '0' ) + '-'
	uAux += Padl( Day  ( M->RA_ADMISSA ), 2, '0' )

	oAluno:SetCampo( "admissao"            , uAux )

	If M->RA_DEMISSA # StoD( '' )

		uAux := PadL( Year ( M->RA_DEMISSA ), 4, '0' ) + '-'
		uAux += PadL( Month( M->RA_DEMISSA ), 2, '0' ) + '-'
		uAux += PadL( Day  ( M->RA_DEMISSA ), 2, '0' )

	End If

	oAluno:SetCampo( "rescisao"            , uAux )

	oAluno:SetCampo( "id_situacao"         , Val( M->RA_SITFOLH ) )

	//TODO Verificar tratamento de situação do funcionário também nas respectivas rotinas
	If EmPty( M->RA_SITFOLH )

		uAux := 'Ativo'

	ElseIf M->RA_SITFOLH == 'A'

		uAux := 'Afastamento'

	ElseIf M->RA_SITFOLH == 'F'

		uAux := 'Férias'

	ElseIf M->RA_SITFOLH == 'D'

		uAux := 'Demitido'

	ElseIf M->RA_SITFOLH == 'T'

		uAux := 'Transferido'

	End If

	oAluno:SetCampo( "situacao"            , uAux )
	oAluno:SetCampo( "id_local"            , Val( SubStr( cFil, 3, Len( cFil ) ) ) )

	SM0->( DbSeek( cFil ) )

	uAux := SM0->M0_FILIAL

	oAluno:SetCampo( "local"               , uAux )
	oAluno:SetCampo( "id_vinculo"          , Val( M->RA_CATFUNC ) )

	If M->RA_CATFUNC == 'A'

		uAux := 'Autonomo'

	ElseIf M->RA_CATFUNC == 'C'

		uAux := 'Comissionado'

	ElseIf M->RA_CATFUNC == 'D'

		uAux := 'Diarista'

	ElseIf M->RA_CATFUNC == 'E'

		uAux := 'Estagiário mensalista'

	ElseIf M->RA_CATFUNC == 'G'

		uAux := 'Estagiário horista'

	ElseIf M->RA_CATFUNC == 'H'

		uAux := 'Horista'

	ElseIf M->RA_CATFUNC == 'I'

		uAux := 'Professor horista'

	ElseIf M->RA_CATFUNC == 'J'

		uAux := 'Professor aulista'

	ElseIf M->RA_CATFUNC == 'M'

		uAux := 'Mensalista'

	ElseIf M->RA_CATFUNC == 'P'

		uAux := 'Pro Labore'

	ElseIf M->RA_CATFUNC == 'S'

		uAux := 'Semanalista'

	ElseIf M->RA_CATFUNC == 'T'

		uAux := 'Tarefeiro'

	End If

	oAluno:SetCampo( "vinculo"             , uAux )

	oAluno:SetCampo( "email"               , M->RA_EMAIL )
	oAluno:SetCampo( "celularddd"          , Val( M->RA_DDDCELU ) )
	oAluno:SetCampo( "celularnumero"       , Val( M->RA_NUMCELU ) )
	//TODO Verificar Campo //oAluno:SetCampo( "superior"            , 22.386)
	//TODO Verificar Campo //oAluno:SetCampo( "id_nivel"            , 5)
	//TODO Verificar Campo //oAluno:SetCampo( "nivelcargo"          , 'Técnicos')
	//TODO Verificar Campo //oAluno:SetCampo( "login"               , 'braviteste')
	//TODO Verificar Campo //oAluno:SetCampo( "id_gerencia"         , 600.00)
	//TODO Verificar Campo //oAluno:SetCampo( "gerencia"            , 'Gerência de Conteúdo e Capacitação')
	//TODO Verificar Campo //oAluno:SetCampo( "id_superintendencia" , 25)
	//TODO Verificar Campo //oAluno:SetCampo( "superintendencia"    , 'Supte Nac de Operações')
	oAluno:SetCampo( "empresa"             , SM0->M0_FILIAL )
	//TODO Verificar Campo //oAluno:SetCampo( "hierarquia"          , '001.007.005.018.004.001')

	SM0->( RestArea( aAreaSM0 ) )
	RestArea( aArea )

Return

/*/{Protheus.doc} ShowMsg
Monta e exige mensagem de erro das transações
@author Elton Teodoro Alves
@since 19/02/2019
@version 12.1.19
@param cError, characters, Mensagem de erro a ser exibida
/*/
Static Function ShowMsg( cError )

	Local cMsg := ''

	cMsg += 'Não Foi possível integrar com o Bravi: ' + CRLF
	cMsg += cError + CRLF

	ApMsgStop( cMsg, 'Atenção !!!' )

Return

/*/{Protheus.doc} RecZRA
Grava na tabela ZRA o id do aluno no cadastro do Bravi
@author Elton Teodoro Alves
@since 19/02/2019
@version 12.1.17
@param cId, characters, descricao
/*/
Static Function RecZRA( cId )

	Local lLock := .F.

	DbSelectArea( 'ZRA' )
	ZRA->( DbSetOrder( 1 ) )

	lLock := ! ZRA->( DbSeek( xFilial( 'ZRA' ) + M->RA_MAT ) )

	RecLock( 'ZRA', lLock )

	ZRA->ZRA_FILIAL := xFilial( 'ZRA' )
	ZRA->ZRA_MAT    := M->RA_MAT
	ZRA->ZRA_BRAVI  := PadR( cId, Len( ZRA->ZRA_BRAVI ) )

	ZRA->( MsUnlock() )

Return