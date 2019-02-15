#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IntegBravi
Faz a inclusão e alteração do cadastro do Aluno no Bravi
@author Elton Teodoro Alves
@since 15/02/2019
@version 12.1.17
@return Logical, Se a operação ocorreu ou não com sucesso
/*/
User Function IntegBravi()

	Local lRet      := .T.
	Local cMvBravi  := GetMv( 'CI_BRAVI' )
	Local aMvBravi  := StrTokArr2( cMvBravi, '|', .T. )
	Local oBraviApi := U_GetApiBravi( AllTrim( aMvBravi[ 1 ] ), AllTrim( aMvBravi[ 2 ] ), AllTrim( aMvBravi[ 3 ] ) )
	Local oAluno    := U_GetAlunoBravi()
	Local uAux      := Nil
	Local aArea     := GetArea()
	Local aAreaSM0  := SM0->( GetArea() )
	Local cError    := ''
	Local cId       := ''
	Local cMsg      := ''
	Local lLock     := .F.

	If ! INCLUI

		//TODO POSICIONAR NA ZRA
		oAluno:SetCampo( "id", ZRA->ZRA_XBRAVI )

	End If

	oAluno:SetCampo( "matricula"           , Val( SRA->RA_MATRICULA ) )
	oAluno:SetCampo( "cpf"                 , SRA->RA_CIC )
	oAluno:SetCampo( "nome"                , SRA->RA_NOMECMP )
	oAluno:SetCampo( "apelido"             , SRA->SRA_APELIDO)

	SRA->( uAux += cValtochar( Year ( SRA_NASC ) ) + '-' )
	SRA->( uAux += cValtochar( Month( SRA_NASC ) ) + '-' )
	SRA->( uAux += cValtochar( Day  ( SRA_NASC ) )       )

	oAluno:SetCampo( "nascimento"          , cDataNasc)

	//TODO Criar Campo // oAluno:SetCampo( "id_areaconhecimento" , 3)
	//TODO Criar Campo //oAluno:SetCampo( "areaconhecimento"    , 'Técnicas')

	oAluno:SetCampo( "id_cargo"            , Val( SRA->RA_CARGO ) )

	//TODO Criar Campo //oAluno:SetCampo( "cargo"               , 'Orientador Educacional')

	oAluno:SetCampo( "id_setor"            , Val( SRA->RA_CC ) )
	oAluno:SetCampo( "setor"               , Posicione( 'CTT', 1, xFilial( 'CTT' ) + SRA->RA_CC, 'CTT_DESC01' ) )

	SRA->( uAux += cValtochar( Year ( RA_ADMISSA ) ) + '-' )
	SRA->( uAux += cValtochar( Month( RA_ADMISSA ) ) + '-' )
	SRA->( uAux += cValtochar( Day  ( RA_ADMISSA ) )       )

	oAluno:SetCampo( "admissao"            , cDataAux )

	SRA->( uAux += cValtochar( Year ( RA_DEMISSA ) ) + '-' )
	SRA->( uAux += cValtochar( Month( RA_DEMISSA ) ) + '-' )
	SRA->( uAux += cValtochar( Day  ( RA_DEMISSA ) )       )

	oAluno:SetCampo( "rescisao"            , cDataAux )

	oAluno:SetCampo( "id_situacao"         , Val( SRA->RA_SITFOLH ) )

	//TODO Verificar tratamento de situação do funcionário também nas respectivas rotinas
	If EmPty( SRA->RA_SITFOLH )

		uAux := 'Ativo'

	ElseIf SRA->RA_SITFOLH == 'A'

		uAux := 'Afastamento'

	ElseIf SRA->RA_SITFOLH == 'F'

		uAux := 'Férias'

	ElseIf SRA->RA_SITFOLH == 'D'

		uAux := 'Demitido'

	ElseIf SRA->RA_SITFOLH == 'T'

		uAux := 'Transferido'

	End If

	oAluno:SetCampo( "situacao"            , uAux )
	oAluno:SetCampo( "id_local"            , Val( SubStr( SRA->RA_FILIAL, 3, Len( SRA->RA_FILIAL ) ) ) )

	SM0->( DbSeek( SRA->RA_FILIAL ) )

	uAux := SM0->M0_FILIAL

	oAluno:SetCampo( "local"               , uAux )
	oAluno:SetCampo( "id_vinculo"          , Val( SRA->RA_CATFUNC ) )

	If SRA->RA_CATFUNC == 'A'

		uAux := 'Autonomo'

	ElseIf SRA->RA_CATFUNC == 'C'

		uAux := 'Comissionado'

	ElseIf SRA->RA_CATFUNC == 'D'

		uAux := 'Diarista'

	ElseIf SRA->RA_CATFUNC == 'E'

		uAux := 'Estagiário mensalista'

	ElseIf SRA->RA_CATFUNC == 'G'

		uAux := 'Estagiário horista'

	ElseIf SRA->RA_CATFUNC == 'H'

		uAux := 'Horista'

	ElseIf SRA->RA_CATFUNC == 'I'

		uAux := 'Professor horista'

	ElseIf SRA->RA_CATFUNC == 'J'

		uAux := 'Professor aulista'

	ElseIf SRA->RA_CATFUNC == 'M'

		uAux := 'Mensalista'

	ElseIf SRA->RA_CATFUNC == 'P'

		uAux := 'Pro Labore'

	ElseIf SRA->RA_CATFUNC == 'S'

		uAux := 'Semanalista'

	ElseIf SRA->RA_CATFUNC == 'T'

		uAux := 'Tarefeiro'

	End If

	oAluno:SetCampo( "vinculo"             , uAux )

	oAluno:SetCampo( "email"               , SRA->RA_EMAIL )
	oAluno:SetCampo( "celularddd"          , Val( SRA->RA_DDDCELI ) )
	oAluno:SetCampo( "celularnumero"       , Val( SRA->RA_NUMCELU ) )
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


	If INCLUI

		If ! oBraviApi:Inclui( oAluno:GetJson(), @cError, @cId )

			cMsg += 'Não Foi possível integrar com o Bravi: ' + CRLF
			cMsg += cError + CRLF
			cMsg += 'Deseja Gravar Mesmo Assim ?'

			ApMsgYesNo ( cMsg, 'Atenção !!!' )

		Else

			DbSelectArea( 'ZRA' )
			ZRA->( DbSetOrder( 1 ) )

			lLock := ZRA->( DbSeek( xFilial() + SRA->RA_MAT ) )

			ZRA->( RecLock( 'SRA', lLock ) )

			ZRA->ZRA_FILIAL := ZRA->ZRA_FILIAL
			ZRA->ZRA_MAT    := ZRA->ZRA_MAT
			ZRA->ZRA_BRAVI  := cId

			ZRA->( MsUnlock() )

		End If

	Else

	End If

Return lRet