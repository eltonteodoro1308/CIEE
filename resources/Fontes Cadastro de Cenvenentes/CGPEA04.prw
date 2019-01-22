#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CGPEA03    � Autor � Marcos Pereira     � Data �  24/07/18 ���
�������������������������������������������������������������������������͹��
���Descricao � Localidades X Per�odos (ZZF)                               ���
���          � (executada a partir da CGPEA02 botao Localidades           ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CGPEA04(cChave,cTitulo)

Local oBrowse
Local oRelation

Private cTituloB := cTitulo

DEFAULT cChave  := '' 
DEFAULT cTitulo := 'Localidades X Per�odos'

oBrowse:= FWmBrowse():New()
oBrowse:SetAlias('ZZF')
oBrowse:SetDescription(cTituloB)
oBrowse:SetMenuDef( 'CGPEA04' ) 
oBrowse:AddFilter("Filtro padr�o","ZZF->(ZZF_FILIAL+ZZF_CODCON+ZZF_PERINI) == ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)",.T.,.T.)
oBrowse:Activate()

Return nil

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisa'      	 Action 'PesqBrw'             OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'   	 Action 'VIEWDEF.CGPEA04'     OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'           Action 'VIEWDEF.CGPEA04'     OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'           Action 'VIEWDEF.CGPEA04'     OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'           Action 'VIEWDEF.CGPEA04'     OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Copiar Localidade' Action 'VIEWDEF.CGPEA04'     OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruZZF := FWFormStruct(1,'ZZF')
Local oModel
Local bTOkVld		:= { || CGPEA04TOK( oModel )}

oModel := MPFormModel():New("CGPEA04M", NIL, bTOkVld, {|oModel| CGPEA04Commit(oModel)})
oModel:AddFields('ZZFMASTER',/*cOwner*/,oStruZZF)
oModel:SetPrimaryKey({'ZZF_FILIAL','ZZF_CODCON','ZZF_PERINI','ZZF_CODIGO'})
oModel:SetDescription(cTituloB)
oModel:GetModel('ZZFMASTER'):SetDescription(cTituloB)

Return oModel 

Static Function ViewDef()

Local oModel := FWLoadModel('CGPEA04')
Local oStruZZF:= FWFormStruct(2,'ZZF')
Local oViewDef:=FWFormView():New()

oViewDef:SetModel(oModel)
oViewDef:AddField('VIEW_ZZF',oStruZZF,'ZZFMASTER')
oViewDef:CreateHorixontalBox('TELA',100)
oViewDef:SetOwnerView('VIEW_ZZF','TELA')

Return oViewDef

Static Function CGPEA04TOK(oMdlZZF)

Local lRet       := .T.
Local nOperation := oMdlZZF:nOperation

If nOperation == MODEL_OPERATION_DELETE

	//Se existir ainda o registro na CTT nao permite a exclusao da localidade
	CTT->(dbsetorder(1))
	cChave := ZZF->(ZZF_CODCON+ZZF_CODIGO)
	If CTT->(dbseek(xFilial("CTT")+cChave)) 
		Help(,,,"Aten��o",OemToAnsi("Antes de excluir esta Localidade, execute a exclus�o do Centro de Custo "+cChave),1,0) //##"Aten��o"
		lRet := .f.
	EndIf

Else  //Alteracao ou inclusao

	If M->ZZF_TPSALA == '2' .and. (empty(M->ZZF_SALMEN) .or. empty(M->ZZF_SALHOR))
		Help( ,, 'HELP',, "Quando selecionado o Tipo Sal�rio com 2-Piso, o preenchimento dos campos 'Piso Mensalista', 'Piso Horista', '% Sal.1oPer' e '% Sal.2oPer' se tornam obrigat�rios.", 1, 0 )  
		lRet := .f.

	ElseIf empty(M->ZZF_ADMAME) .and. !(empty(M->ZZF_CODAMA))
		Help( ,, 'HELP',, "O preenchimento do campo 'Na admiss�o' � obrigat�rio quando h� preenchimento do c�digo para a Assit.M�dica.", 1, 0 )  
		lRet := .f.

	ElseIf empty(M->ZZF_ADMODO) .and. !(empty(M->ZZF_CODODO))
		Help( ,, 'HELP',, "O preenchimento do campo 'Na admiss�o' � obrigat�rio quando h� preenchimento do c�digo para a Assit.Odontol�gica.", 1, 0 )  
		lRet := .f.

	EndIf

EndIf

Return lRet


Static Function CGPEA04Commit(oModel)

	Local lRet := .t.
	Local nOperation, aDadosAuto, cChave, cDescr
	Private lMsErroAuto := .f.

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_INSERT

		//Cria o centro de custo na CTT
		CTT->(dbsetorder(1))
		cChave := "C"+M->(ZZF_CODCON+ZZF_CODIGO)
		cDescr := alltrim(ZZC->ZZC_DESCR)+" - "+Alltrim(M->ZZF_DESCR)
		If !CTT->(dbseek(xFilial("CTT")+cChave))
			aDadosAuto:= {	{'CTT_CUSTO' , cChave    		 , Nil},;	// Especifica qual o C�digo do Centro de Custo.
							{'CTT_CLASSE', "2"			     , Nil},;	// Especifica a classe do Centro de Custo, 
							{'CTT_NORMAL', "2"			     , Nil},;	// 1-Receita ; 2-Despesa                                       
							{'CTT_DESC01', cDescr   		 , Nil},;	// Indica a Nomenclatura do Centro de Custo
							{'CTT_TPLOT' , "01"     		 , Nil},;	// Indica o Tipo da Lotacao (e-social)
							{'CTT_DTEXIS', date()			 , Nil}}	// Especifica qual a Data de In�cio de Exist�ncia para CC

			aDadosAuto	:= FWVetByDic( aDadosAuto, 'CTT' )
			MSExecAuto({|x, y| CTBA030(x, y)},aDadosAuto, 3)
		EndIf
		If lMsErroAuto	
			MsgAlert("A localidade foi criada." + CRLF + "A rotina tamb�m cria um centro de custo com 'c�digo do convenente + c�digo da localidade'." + CRLF +" Verifique a mensagem que aparecer� ap�s fechar estar janela para certificar-se que o processo foi ou n�o realizado com sucesso.")
			MostraErro()
		EndIf
		FWFormCommit(oModel)

	ElseIf nOperation == MODEL_OPERATION_UPDATE

		//Verifica se foi alterada a descricao do centro de custo na CTT
		CTT->(dbsetorder(1))
		cChave := "C"+M->(ZZF_CODCON+ZZF_CODIGO)
		cDescr := alltrim(ZZC->ZZC_DESCR)+" - "+Alltrim(M->ZZF_DESCR)
		If CTT->(dbseek(xFilial("CTT")+cChave)) .and. alltrim(CTT->CTT_DESC01) <> cDescr
			aDadosAuto:= {	{'CTT_CUSTO' , cChave    		 , Nil},;	// Especifica qual o C�digo do Centro de Custo.
							{'CTT_DESC01', cDescr   		 , Nil}}	// Indica a Nomenclatura do Centro de Custo
			aDadosAuto	:= FWVetByDic( aDadosAuto, 'CTT' )
			MSExecAuto({|x, y| CTBA030(x, y)},aDadosAuto, 4)
		EndIf
		If lMsErroAuto	
			MsgAlert("Foi alterada a descri��o da localidade, por�m h� um problema na replica��o autom�tica da descri��o no centro de custo." + CRLF + "Verifique a mensagem que aparecer� ap�s fechar estar janela.")
			MostraErro()
		EndIf
		FWFormCommit(oModel)

	ElseIf nOperation == MODEL_OPERATION_DELETE

		//Deleta a Localizacao
		RecLock("ZZF",.f.)
		ZZF->(dbDelete())
		ZZF->(MsUnlock())
		FWFormCommit(oModel)

	EndIf
	
Return( .T. )


User Function InitZZF(cCampo,cTipo)
Local cRet := ''
If cCampo == "ZZF_DESBEN"
	If cTipo == "I"
		cRet := if(INCLUI,'',Posicione("ZZE",1,ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)+M->ZZF_CODBEN,"ZZE_DESCR"))
	ElseIf cTipo == 'B'
		cRet := Posicione("ZZE",1,ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)+ZZF->ZZF_CODBEN,"ZZE_DESCR")
	EndIf
EndIf
Return(cRet)
	                                                                

