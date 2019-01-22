#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CGPEA03    º Autor ³ Marcos Pereira     º Data ³  24/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Benefícios X Períodos (ZZE)                               º±±
±±º          ³ (executada a partir da CGPEA02 botao Beneficios           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CGPEA03(cChave,cTitulo)

Local oBrowse
Local oRelation

Private cTituloB := cTitulo

DEFAULT cChave  := '' 
DEFAULT cTitulo := 'Benefícios X Períodos'

oBrowse:= FWmBrowse():New()
oBrowse:SetAlias('ZZE')
oBrowse:SetDescription(cTituloB)
oBrowse:SetMenuDef( 'CGPEA03' ) 
oBrowse:AddFilter("Filtro padrão","ZZE->(ZZE_FILIAL+ZZE_CODCON+ZZE_PERINI) == ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)",.T.,.T.)
oBrowse:Activate()

Return nil

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisa'      	Action 'PesqBrw'             OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'   	Action 'VIEWDEF.CGPEA03'     OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'          Action 'VIEWDEF.CGPEA03'     OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'          Action 'VIEWDEF.CGPEA03'     OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'          Action 'VIEWDEF.CGPEA03'     OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Copiar Benefício' Action 'VIEWDEF.CGPEA03'     OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruZZE := FWFormStruct(1,'ZZE')
Local oModel
Local bTOkVld		:= { || CGPEA03TOK( oModel )}

oModel := MPFormModel():New("CGPEA03M", NIL, bTOkVld, {|oModel| CGPEA03Commit(oModel)})
oModel:AddFields('ZZEMASTER',/*cOwner*/,oStruZZE)
oModel:SetPrimaryKey({'ZZE_FILIAL','ZZE_CODCON','ZZE_PERINI','ZZE_CODIGO'})
oModel:SetDescription(cTituloB)
oModel:GetModel('ZZEMASTER'):SetDescription(cTituloB)

Return oModel 

Static Function ViewDef()

Local oModel := FWLoadModel('CGPEA03')
Local oStruZZE:= FWFormStruct(2,'ZZE')
Local oViewDef:=FWFormView():New()

oViewDef:SetModel(oModel)
oViewDef:AddField('VIEW_ZZE',oStruZZE,'ZZEMASTER')
oViewDef:CreateHorixontalBox('TELA',100)
oViewDef:SetOwnerView('VIEW_ZZE','TELA')

Return oViewDef


Static Function CGPEA03TOK(oMdlZZE)

Local lRet       := .T.
Local nOperation := oMdlZZE:nOperation
Local aZZF		 := ZZF->(getarea())
Local aArea		 := getarea()

If nOperation == MODEL_OPERATION_DELETE

	//Verifica se existe localidade no periodo vinculado ao beneficio em exclusao
	ZZF->(dbsetorder(2))
	cChave := ZZE->(ZZE_FILIAL+ZZE_CODCON+ZZE_PERINI+ZZE_CODIGO)
	If ZZF->(dbseek(cChave)) 
		Help(,,,"Atenção",OemToAnsi("Antes de excluir este Benefício, execute a exclusão das localidades vinculadas ao mesmo no período selecionado."),1,0) //##"Atenção"
		lRet := .f.
	EndIf

Else  //Alteracao ou inclusao

	If M->ZZE_OPCAO $ '1/3/4' .and. (empty(M->ZZE_CODVR4) .or. empty(M->ZZE_CODVR6))
		Help( ,, 'HELP',, "Conforme a opção selecionada no campo 'VR/VA' na primeira pasta, os códigos de VR 4 e 6 horas passam a ser de preenchimento obrigatório.", 1, 0 )  
		lRet := .f.
	ElseIf  M->ZZE_OPCAO $ '2/3/4' .and. (empty(M->ZZE_CODVA4) .or. empty(M->ZZE_CODVA6))
		Help( ,, 'HELP',, "Conforme a opção selecionada no campo 'VR/VA' na primeira pasta, os códigos de VA 4 e 6 horas passam a ser de preenchimento obrigatório.", 1, 0 )  
		lRet := .f.
	EndIf
	
	If lRet .and. M->ZZE_FORNVR == '0' .and. !(M->ZZE_OPCAO == '2') 
		Help( ,, 'HELP',, "O campo 'VR/VA' na pasta geral está configurado para fornecimento de VR e o campo 'VR Forn.Por' está com 0-Não Fornece.", 1, 0 )  
		lRet := .f.
	EndIf
	
	If lRet .and. M->ZZE_FORNVA == '0' .and. !(M->ZZE_OPCAO == '1') 
		Help( ,, 'HELP',, "O campo 'VR/VA' na pasta geral está configurado para fornecimento de VA e o campo 'VA Forn.Por' está com 0-Não Fornece.", 1, 0 )  
		lRet := .f.
	EndIf

	If lRet .and. !empty(M->ZZE_CODVR4)
		If empty(M->ZZE_VALVR4)
			Help( ,, 'HELP',, "Informe o valor do VR no campo 'Valor Dia 4h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_TPVVR4)
			Help( ,, 'HELP',, "Preencha o campo 'Tipo valor 4h' do VR.", 1, 0 )  
			lRet := .f.
		ElseIf M->ZZE_TPVVR4 == '2' .and. empty(M->ZZE_QTFVR4)
			Help( ,, 'HELP',, "Informe a quantidade do VR no campo 'Qtde Fixa 4h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_DFXVR4) .and. empty(M->ZZE_PDEVR4)
			Help( ,, 'HELP',, "Para o VR informe a configuração de desconto no campo 'Desc.Fixo 4h' ou '% Desc.4h'.", 1, 0 )  
			lRet := .f.
		EndIf
	EndIf
	
	If  lRet .and. !empty(M->ZZE_CODVR6)
		If empty(M->ZZE_VALVR6)
			Help( ,, 'HELP',, "Informe o valor do VR no campo 'Valor Dia 6h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_TPVVR6)
			Help( ,, 'HELP',, "Preencha o campo 'Tipo valor 6h' do VR.", 1, 0 )  
			lRet := .f.
		ElseIf M->ZZE_TPVVR6 == '2' .and. empty(M->ZZE_QTFVR6)
			Help( ,, 'HELP',, "Informe a quantidade do VR no campo 'Qtde Fixa 6h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_DFXVR6) .and. empty(M->ZZE_PDEVR6)
			Help( ,, 'HELP',, "Para o VR informe a configuração de desconto no campo 'Desc.Fixo 6h' ou '% Desc.6h'.", 1, 0 )  
			lRet := .f.
		EndIf
	EndIf

	If  lRet .and. !empty(M->ZZE_CODVA4)
		If empty(M->ZZE_VALVA4)
			Help( ,, 'HELP',, "Informe o valor do VA no campo 'Valor Dia 4h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_TPVVA4)
			Help( ,, 'HELP',, "Preencha o campo 'Tipo valor 4h' do VA.", 1, 0 )  
			lRet := .f.
		ElseIf M->ZZE_TPVVA4 == '2' .and. empty(M->ZZE_QTFVA4)
			Help( ,, 'HELP',, "Informe a quantidade do VA no campo 'Qtde Fixa 4h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_DFXVA4) .and. empty(M->ZZE_PDEVA4)
			Help( ,, 'HELP',, "Para o VA informe a configuração de desconto no campo 'Desc.Fixo 4h' ou '% Desc.4h'.", 1, 0 )  
			lRet := .f.
		EndIf
	EndIf

	If  lRet .and. !empty(M->ZZE_CODVA6)
		If empty(M->ZZE_VALVA6)
			Help( ,, 'HELP',, "Informe o valor do VA no campo 'Valor Dia 6h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_TPVVA6)
			Help( ,, 'HELP',, "Preencha o campo 'Tipo valor 6h' do VA.", 1, 0 )  
			lRet := .f.
		ElseIf M->ZZE_TPVVA6 == '2' .and. empty(M->ZZE_QTFVA6)
			Help( ,, 'HELP',, "Informe a quantidade do VA no campo 'Qtde Fixa 6h'.", 1, 0 )  
			lRet := .f.
		ElseIf empty(M->ZZE_DFXVA6) .and. empty(M->ZZE_PDEVA6)
			Help( ,, 'HELP',, "Para o VA informe a configuração de desconto no campo 'Desc.Fixo 6h' ou '% Desc.6h'.", 1, 0 )  
			lRet := .f.
		EndIf
	EndIf

EndIf

RestArea(aZZF)
RestArea(aArea)

Return lRet


Static Function CGPEA03Commit(oModel)

	Local lRet := .t.
	Local nOperation, aDadosAuto, cChave, cDescr
	Private lMsErroAuto := .f.

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
		//Deleta o Beneficio
		RecLock("ZZE",.f.)
		ZZE->(dbDelete())
		ZZE->(MsUnlock())
	EndIf
	
	FWFormCommit(oModel)

Return( .T. )

