#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CGPEA01    º Autor ³ Marcos Pereira     º Data ³  24/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Convenentes (ZZC)                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CGPEA01

Local oBrowse

oBrowse:= FWmBrowse():New()
oBrowse:SetAlias('ZZC')
oBrowse:SetDescription("Cadastro de Convenentes")
oBrowse:SetMenuDef( 'CGPEA01' ) 
oBrowse:Activate()

Return nil

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisa'      	 Action 'PesqBrw'             OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'   	 Action 'VIEWDEF.CGPEA01'     OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'           Action 'VIEWDEF.CGPEA01'     OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'           Action 'VIEWDEF.CGPEA01'     OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'           Action 'VIEWDEF.CGPEA01'     OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Copiar Convenente' Action 'VIEWDEF.CGPEA01'     OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruZZC := FWFormStruct(1,'ZZC')
Local oModel
Local bTOkVld		:= { || CGPEA01TOK( oModel )}

oModel := MPFormModel():New("CGPEA01M", NIL, bTOkVld, {|oModel| CGPEA01Commit(oModel)})
oModel:AddFields('ZZCMASTER',/*cOwner*/,oStruZZC)

//oModel:SetPrimaryKey({'ZZC_FILIAL','ZZC_CODIGO'})
oModel:SetDescription("Cadastro de Convenentes")
oModel:GetModel('ZZCMASTER'):SetDescription("Cadastro de Convenentes")

Return oModel 

Static Function ViewDef()

Local oModel := FWLoadModel('CGPEA01')
Local oStruZZC:= FWFormStruct(2,'ZZC')
Local oViewDef:=FWFormView():New()

oViewDef:SetModel(oModel)
oViewDef:AddField('VIEW_ZZC',oStruZZC,'ZZCMASTER')
oViewDef:CreateHorixontalBox('TELA',100)
oViewDef:SetOwnerView('VIEW_ZZC','TELA')

Return oViewDef

Static Function CGPEA01TOK(oMdlZZE)

Local lRet       := .T.
Local nOperation := oMdlZZE:nOperation

If nOperation == MODEL_OPERATION_DELETE

	//Verifica se existe periodo vinculado
	If !empty(ZZD->ZZD_CODCON) 
		Help(,,,"Atenção",OemToAnsi("Antes de excluir este Convenente, execute a exclusão dos períodos vinculados ao mesmo."),1,0) //##"Atenção"
		lRet := .f.
	EndIf

EndIf

Return lRet


Static Function CGPEA01Commit(oModel)

	Local lRet := .t.
	Local nOperation, aDadosAuto, cChave, cDescr
	Private lMsErroAuto := .f.

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
		//Deleta o Convenente
		RecLock("ZZC",.f.)
		ZZC->(dbDelete())
		ZZC->(MsUnlock())
	EndIf
	
	FWFormCommit(oModel)

Return( .T. )
