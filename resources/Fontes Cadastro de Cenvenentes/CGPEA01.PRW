#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CGPEA01    � Autor � Marcos Pereira     � Data �  24/07/18 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Convenentes (ZZC)                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Help(,,,"Aten��o",OemToAnsi("Antes de excluir este Convenente, execute a exclus�o dos per�odos vinculados ao mesmo."),1,0) //##"Aten��o"
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
