#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

user function TesteBravi()

	Local aAlunos := {}
	Local cError  := ''
	Local cJson   := ''

	oBraviApi := U_GetApiBravi( 'https://api.uniciee.ciee.org.br', 'bravi1', 'bravi@2017' )

	//For nX := 9001 To 9001

	oAluno := U_GetAlunoBravi()

	oAluno:SetCampo( "id"                  , 9002)
	oAluno:SetCampo( "matricula"           , 9010)
	oAluno:SetCampo( "cpf"                 , '04175343024')
	oAluno:SetCampo( "nome"                , 'Cláudio Igor Davi Vieira')
	oAluno:SetCampo( "apelido"             , 'Davi')
	oAluno:SetCampo( "nascimento"          , '1997-10-14')
	oAluno:SetCampo( "id_areaconhecimento" , 3)
	oAluno:SetCampo( "areaconhecimento"    , 'Técnicas')
	oAluno:SetCampo( "id_cargo"            , 148)
	oAluno:SetCampo( "cargo"               , 'Orientador Educacional')
	oAluno:SetCampo( "id_setor"            , 1.071)
	oAluno:SetCampo( "setor"               , 'Capacitação de Aprendizes SP')
	oAluno:SetCampo( "admissao"            , '2019-01-02')
	oAluno:SetCampo( "rescisao"            , '')
	oAluno:SetCampo( "id_situacao"         , 1)
	oAluno:SetCampo( "situacao"            , 'Em Atividade Normal')
	oAluno:SetCampo( "id_local"            , 277)
	oAluno:SetCampo( "local"               , 'EDIFICIO INTEGRACAO/SP')
	oAluno:SetCampo( "id_vinculo"          , 1)
	oAluno:SetCampo( "vinculo"             , 'Contrato conforme C.L.T')
	oAluno:SetCampo( "email"               , 'joao.salomao@bravi.com.br')
	oAluno:SetCampo( "celularddd"          , 55)
	oAluno:SetCampo( "celularnumero"       , 111123123)
	oAluno:SetCampo( "superior"            , 22.386)
	oAluno:SetCampo( "id_nivel"            , 5)
	oAluno:SetCampo( "nivelcargo"          , 'Técnicos')
	oAluno:SetCampo( "login"               , 'braviteste')
	oAluno:SetCampo( "id_gerencia"         , 600.00)
	oAluno:SetCampo( "gerencia"            , 'Gerência de Conteúdo e Capacitação')
	oAluno:SetCampo( "id_superintendencia" , 25)
	oAluno:SetCampo( "superintendencia"    , 'Supte Nac de Operações')
	oAluno:SetCampo( "empresa"             , 'CIEE-SP')
	oAluno:SetCampo( "hierarquia"          , '001.007.005.018.004.001')

	aAdd( aAlunos , oAluno:GetJson() )

	//Next nX

	oBraviApi:Inclui( aAlunos, @cError, @cJson )

	//cError := ''

	//oBraviApi:Consulta( '103322', @aAlunos, @cError )

	//cError := ''

	//oBraviApi:Exclui( '103318', @cError )

return

User Function Teste()

	cJson := '{"errors":{"code":"unprocessable_entity","description":"Mandatory fields are missing or incorrect in the payload!","message":{"aluno":{"nome":"The (nome) field is required.","cpf":"The (cpf) field is required.","nascimento":"The (nascimento) field is required."}}}}'
	oJson := Nil


	FWJsonDeserialize( cJson, @oJson )

	cError := oJson:errors:description + CRLF

	aErrors := aClone( ClassDataArr( oJson:errors:message:aluno ) )

	For nX := 1 To Len( aErrors )

		cError += aErrors[ nX, 1 ] + ': ' + aErrors[ nX, 2 ] + CRLF

	Next nX


Return