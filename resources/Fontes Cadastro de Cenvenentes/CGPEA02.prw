#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#Include "RWMAKE.CH"
#INCLUDE 'FWMBROWSE.CH'      
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02    บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Perํodos X Convenentes (ZZD)                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CGPEA02()
Local aCoors 		:= FWGetDialogSize(oMainWnd)
Local oDlg			                                 
Local oFWLayer
Local oPanelUp
Local oPanelDown

Private cCadastro   	:= OemToAnsi("Cadastro de Perํodos X Convenentes")	
Private oMBrowseUp
Private oMBrowseDown           
Private nVez := 1

	DEFINE MSDIALOG oDlg TITLE "Convenentes X Perํodos" FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] PIXEL
	
		oFWLayer := FWLayer():New()
		oFWLayer:Init(oDlg,.F.,.T.)
		
		//-- Browse ZZC
		oFWLayer:AddLine("UP",50,.F.) 
		oFWLayer:AddCollumn("ALLZZC", 100, .T., 'UP' )     
		oPanelUp := oFWLayer:GetColPanel("ALLZZC", 'UP' )
				
		oMBrowseUp := FWMBrowse():New() 
		oMBrowseUp:SetOwner( oPanelUp )  
		oMBrowseUp:SetDescription("Cadastro de Convenentes")  
		oMBrowseUp:SetAlias('ZZC')
	   	oMBrowseUp:SetMenuDef( 'CGPEA01' )  
	  	oMBrowseUp:SetCacheView (.F.) 
		oMBrowseUp:SetProfileID( '1' ) 
//		oMBrowseUp:SetFilterDefault(cFTerRCJ)
		oMBrowseUp:DisableDetails()    		 		
		oMBrowseUp:Activate()		
		
		//-- Browse ZZD   
		oFWLayer:AddLine("DOWN", 50, .F. ) 
		oFWLayer:AddCollumn("ALLZZD", 100, .T., 'DOWN' )
		oPanelDown := oFWLayer:GetColPanel("ALLZZD", 'DOWN')
				
		oMBrowseDown := FWMBrowse():New() 
		oMBrowseDown:SetOwner( oPanelDown )
		oMBrowseDown:SetDescription("Perํodos")  		  
	   	oMBrowseDown:SetMenuDef( 'CGPEA02' ) 
		oMBrowseDown:DisableDetails()
		oMBrowseDown:SetAlias('ZZD')                     
	   	oMBrowseDown:SetCacheView (.F.)   
		oMBrowseDown:SetProfileID( '2' ) 			 		  
		oMBrowseDown:ForceQuitButton()   
		oMBrowseDown:AddLegend( "empty(ZZD_PERFIM)",	"GREEN",	OemToAnsi("Periodo Aberto") )
		oMBrowseDown:AddLegend( "!empty(ZZD_PERFIM)",	"RED"  ,	OemToAnsi("Periodo Fechado") )
		oMBrowseDown:Activate()    
		oRelation := FWBrwRelation():New()

		oRelation:AddRelation(oMBrowseUp,oMBrowseDown, {{"ZZD_FILIAL", "ZZC_FILIAL"}, {"ZZD_CODCON", "ZZC_CODIGO"}})
		oRelation:Activate() 
				
//		oMBrowseDown:AddFilter("Filtro por Modulo",cFiltro,.T.,.T.)
		oMBrowseDown:ExecuteFilter()	

	oMBrowseDown:SetDescription("Convenente "+alltrim(ZZC->ZZC_DESCR)+" - Perํodo "+ZZD->ZZD_PERINI)  		  
	oMBrowseDown:Refresh(.T.)
		
	ACTIVATE MSDIALOG oDlg

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MENUDEF    บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Menu                                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MenuDef()

Local aRotina := {}

	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Define Array contendo as Rotinas a executar do programa      ณ
	ณ ----------- Elementos contidos por dimensao ------------     ณ
	ณ 1. Nome a aparecer no cabecalho                              ณ
	ณ 2. Nome da Rotina associada                                  ณ
	ณ 3. Usado pela rotina                                         ณ
	ณ 4. Tipo de Transao a ser efetuada                          ณ
	ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
	ณ    2 - Simplesmente Mostra os Campos                         ณ
	ณ    3 - Inclui registros no Bancos de Dados                   ณ
	ณ    4 - Altera o registro corrente                            ณ
	ณ    5 - Remove o registro corrente do Banco de Dados          ณ
	ณ    6 - Copiar                                                ณ
	ณ    7 - Legenda                                               ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	aRotina := {	{ "Pesquisar" 			, "PesqBrw"	   , 0 , 1 ,, .F.} ,; 	// "Pesquisar"
					{ "Visualizar" 			, "U_CGPEA02M" , 0 , 2 ,, .F.} ,; 	// "Visualizar"  
					{ "Finalizar/Novo" 		, "U_CGPEA02M" , 0 , 3 ,, .F.} ,;	// "Finalizar/Novo"
					{ "Alterar" 			, "U_CGPEA02M" , 0 , 4 ,, .F.} ,; 	// "Alterar"
					{ "Excluir" 			, "U_CGPEA02M" , 0 , 5 ,, .F.} ,; 	// "Excluir"
					{ "Benefํcios" 			, "U_CGPEA02B" , 0 , 1 ,, .F.} ,; 	// "Benefํcios"
					{ "Localidades" 		, "U_CGPEA02D" , 0 , 1 ,, .F.} ,; 	// "Localidades"
					{ "Legenda" 			, "U_CGPEA02L" , 0 , 7 ,, .F.};		// "Legenda"
				}
Return aRotina





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02M   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Manuten็ใo dos Perํdos X Convenentes (ZZD)                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CGPEA02M( cAlias , nReg , nOpc )
	// Variaveis de controle
	Local aSavePos			:= GetArea()
	Local nOpcAlt			:= 0.00		// Variavel de controle das alteracoes - utilizada para a gravacao
	Local nX				:= 0.00		// Variavel utilizada em loops
	Local nPosRec			:= 0
	
	// Variaveis da janela
	Local bSet15			:= { || Nil }	// Bloco com as validacoes do botao OK
	Local bSet24			:= { || Nil }	// Bloco com as validacoes do botao Cancelar
	Local bDialogInit		:= { || Nil }	// Inicializacao do Dialog

	// Variaveis do tipo objetos
	Local oDlg				:= Nil
	Local oFont

	// Variaveis para controle de coordenadas da janela
	Local aAdvSize			:= {}
	Local aInfoAdvSize		:= {}
	Local aObjSize			:= {}
	Local aObjCoords		:= {}
	Local aButtons			:= {}
	Local nPosicao := 0

	// Variaveis para enchoice da tabela ZZD
	Private aZZDFields		:= {}		// Vetor com os campos da tabela
	Private aZZDAltera		:= {}		// Vetor com os campos que permitem alteracao
	Private aZZDNaoAltera	:= {}		// Vetor com os campos que nao permitem alteracao
	Private aZZDVirtChoice	:= {}		// Vetor com os campos virtuais
	Private aZZDVisualChoice:= {}		// Vetor com os campos visuais
	Private aZZDNotFields	:= {}		// Vetor com os campos que nao serao visualizados
	Private aColsEnChoice 	:= {}		// Vetor com as colunas da Enchoice RCH
	Private aSvEnchoice		:= {}		// Vetor com a copia de aColsEnchoice para verificar se houve alteracoes
	Private nZZDXs			:= 0.00		// Variavel com a quantidade de campos da tabela

	// Variaveis privadas da Enchoice da tabela ZZD
	Private cFilZZD			:= ''			// Filial corrente
	Private aEnchoice		:= {}			// Vetor com o cabecalho da Enchoice ZZD (utilizada por chamadas da tabela SX3)

	// Variaveis auxiliares
	Private bChange     	:= {|| Nil}
	Private bExeCalc		:= {|| Nil}
	Private cKeySeek		:= ""			// Chave para o Posicionamento no Alias Filho
	Private cQuery			:= ""			// Utilizacao de Query para Selecao de Dados
	
	If nVez > 1
		nVez := 1
		Return
	EndIf
	
	cAlias := "ZZD"

	Begin Sequence
		
		dbSelectArea("ZZD")
		dbSetOrder(1)
		
		If nOpc <> 3
			cKeySeek := ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)
		EndIf
		
		aColsEnChoice	:= ZZD->(GdMontaCols(	@aEnchoice	   		,;	//01 -> Array com os Campos do Cabecalho da GetDados
												@nZZDXs				,;	//02 -> Numero de Campos em Uso
												@aZZDVirtChoice		,;	//03 -> [@]Array com os Campos Virtuais
												@aZZDVisualChoice	,;	//04 -> [@]Array com os Campos Visuais
												"ZZD"				,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
												aZZDNotFields		,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
												{nReg}				,;  //07 -> [@]Array unidimensional contendo os Recnos	
																	,;	//08 -> Alias do Arquivo Pai
												cKeySeek     		,;  //09 -> Chave para o Posicionamento no Alias Filho
												,,,,,,,,,,,,,,,,,,,,,,nOpc,; //32 -> nOpc
											))
		aSvEnchoice		:= aClone( aColsEnchoice )

		//Quando Novo e nao existe nenhum periodo para o convenente, pergunta se deseja copiar de outro		
		If nOpc == 3 .and. empty(ZZD->ZZD_PERINI) .and. MsgNoYes("Deseja iniciar um perํodo atrav้s de c๓pia de perํodo e benefํcios de outro convenente ?") 
			CGPEA02C()

		//Finaliza o perido que esta sem data fim	
		ElseIf nOpc == 3 .and. !empty(ZZD->ZZD_PERINI) .and. empty(ZZD->ZZD_PERFIM) 
			CGPEA02F()

		Else
		
			if (!empty(ZZD->ZZD_PERINI) .Or. !(cvaltochar(nOpc) $ '5/4' )) 
	
				// Cria as Variaveis de Memoria e Carrega os Dados Conforme o Arquivo
				cFilZZD := xFilial("ZZD", ZZC->ZZC_FILIAL)
				For nX := 1 To nZZDXs
					aAdd( aZZDFields , aEnchoice[ nX , 02 ] )
					Private &( "M->"+aEnchoice[ nX , 02 ] ) := aColsEnchoice[ 01 , nX ]
				Next nX
				
				If ( ( nOpc == 3 ) .Or. ( nOpc == 4 ) )
					// Campos que nao poderao ser alterados
					nZZDXs := Len( aZZDVisualChoice )
					For nX := 1 To nZZDXs
						aAdd( aZZDNaoAltera , aZZDVisualChoice[ nX ] )
					Next nX
					// Campos editaveis na alteracao
					nZZDXs := Len( aZZDFields )
					For nX := 1 To nZZDXs
						If ( aScan( aZZDNaoAltera , { |cNaoA| cNaoA == aZZDFields[ nX ] } ) == 0.00 )
							aAdd( aZZDAltera , aZZDFields[ nX ] )
						EndIf
					Next nX
				EndIf
	
				bSet15	:= { ||If( !(nOpc == 2), If( ValidEnch(oEnchoice,nOpc) .and. U_CGPEA02V(),(nOpcAlt:=1.00,oDlg:End()),(nOpcAlt:=0.00,.F.)), ( nOpcAlt := 1.00 , oDlg:End()))}
				bSet24	:= { ||oDlg:End() }
	
				// Define o Bloco para a Inicializacao do Dialog
				bDialogInit		:= { ||;
					CursorWait()							,;
					EnchoiceBar( oDlg , bSet15 , bSet24 , Nil ,aButtons)	,;
					RstEnchoVlds()							,;
					CursorArrow()							 ;
				}
				aAdvSize		:= MsAdvSize()
				aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
				aAdd( aObjCoords , { 000 , 000 , .T. , .T.  } )
				aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	
				// Monta as Dimensoes dos Objetos  - Aba 2
				If nOpc == 3
					M->ZZD_CODCON := ZZC->ZZC_CODIGO
				EndIf
	
				// Monta o Dialogo Principal
				DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
				DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL
	
				oEnchoice	:= MsmGet():New( 	"ZZD",;   			// 1  Tabela a consultar
					Nil,;				// 2  Nro do Recno do Registro
					nOpc,;				// 3  Tipo de operacao
					Nil,;				// 4
					Nil,;				// 5
					Nil,; 				// 6
					aZZDFields,;		// 7  Vetor com nome dos campos que serao exibidos
					aObjSize[1],; 		// 8  Posicao da Enchoice na tela
					aZZDAltera,;		// 9  Campos que permitem alteracao
					Nil,;				// 10
					Nil,;				// 11
					Nil,;				// 12 Funcao para validacao da Enchoice
					Nil,; 	 			// 13  Objeto
					Nil,;
					.F.						,;
					Nil						,;
					.F.			 			 ;
				)
	
	
	
	//			oEnchoice	:= MsMGet():New( "ZZD" , nReg , nOpc , Nil , Nil , Nil , aZZDFields , aObjSize[1] , aZZDAltera , Nil , Nil , Nil, oDlg , Nil , .F. , Nil , .F. )
	//			oEnchoice	:= MsMGet():New( "ZZD" , nReg , nOpc , Nil , Nil , Nil ,  , aObjSize[1] ,  , Nil , Nil , Nil, oDlg , Nil , .F. , Nil , .F. )
	
					
				ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
	
				// Confirmada a Opcao e Nao for Visualizacao Grava
				If nOpcAlt == 1 .And. nOpc != 2
				// Gravando/Incluido ou Excluindo Informacoes do ZZD
	
					FGrava( 		cAlias,;			// 1-Alias pai
									nOpc,;				// 2-Opcao da operacao
									nReg,;				// 3-Registro pai 
									aColsEnchoice,;		// 4-Cols da Enchoice
									aSvEnchoice	,;		// 5-Clone de aEnchoice 
									aZZDVirtChoice,; 	// 6-Campos virtuais da enchoice
									{},;				// 7-Clone de aXXXCols -
									0,;					// 8-Qtde de Campos usados 
									{},;				// 9-Clone de ARCHCols
									{},;				// 10-Vetor com Recnos de XXX
									nPosRec,;		    // 11- Pos. Recno
									{};					// 12- Clone de aXXXolsAll
								)
	
				EndIf
	
			Else
				Help( ,, 'HELP',, "Periodo fechado, permitido apenas visualiza็ใo", 1, 0 )  //'Periodo fechado, permitido apenas visualiza็ใo'
			EndIf

		EndIf

		RestArea( aSavePos )
		nPosicao := oMBrowseDown:nAt
		oMBrowseDown:Refresh(.T.)
		oMBrowseDown:Goto( nPosicao )
	End Sequence

Return( Nil )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02L   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Legenda                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CGPEA02L() 
Local aArea := GetArea()
BrwLegenda("Cadastro de periodo","Definicao do Status do Periodo:", {	{"BR_VERDE"		, OemToAnsi("Periodo Atual")},; 
								{"BR_VERMELHO"	, OemToAnsi("Periodo Fechado")}})
									
RestArea(aArea)
									
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02C   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Copiar Periodos de outro convenente                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CGPEA02C()

Local oDlgC
Local oFontC
Local oDirecc
Local cVarAlias	:= ""
Local cOrigem 	:= Space( TamSX3("ZZC_CODIGO")[1] )
Local cPeriodo 	:= Space(6)
Local cTipo     := 'C' //C=Copia
Local lRet    	:= .T.

	DEFINE FONT oFontC NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlgC TITLE OemToAnsi("Copiar Perํodo de outro convenente") FROM 100,001 TO 240,300 PIXEL 

		@ 12,  10 SAY "Convenente Origem" SIZE 80,10 PIXEL
		@ 10,  80 MSGET oDirecc VAR cOrigem SIZE 40,10 PIXEL

		@ 27,  10 SAY "Perํodo Inicial (AAAAMM)" SIZE 80,10 PIXEL
		@ 25,  80 MSGET oDirecc VAR cPeriodo  SIZE 40,10 PIXEL

	DEFINE SBUTTON FROM 45, 070 TYPE 1 ENABLE OF oDlgC ACTION ( If(CGPEA02X(cOrigem,cPeriodo,cTipo),lRet := .T.,lRet:=.f.), oDlgC:End() )
	DEFINE SBUTTON FROM 45, 105 TYPE 2 ENABLE OF oDlgC ACTION ( lRet := .F., oDlgC:End() )
			
	ACTIVATE MSDIALOG oDlgC CENTERED 
	
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02X   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Copiar Periodos de outro convenente                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CGPEA02X(cOrigem,cPeriodo,cTipo,cPerFim)

Local aArea				:= GetArea()
Local aZZC  			:= ZZC->(getarea())
Local lRet				:= .t. 				
Local aColsEnZZE		:= {}
Local aEnchZZE			:= {}
Local nZZEXs			:= 0
Local aZZEVirtChoice	:= {}
Local aZZEVisualChoice	:= {}
Local aColsEnZZF		:= {}
Local aEnchZZF			:= {}
Local nZZFXs			:= 0
Local aZZFVirtChoice	:= {}
Local aZZFVisualChoice	:= {}
Local nChoice, nChoices, cChave

Default cPerFim := cPeriodo

If cTipo == 'C' //Copia
	If empty(cOrigem) .or. empty(cPeriodo)
		MsgAlert("Informe corretamente os parโmetros.")
		lRet := .f.
	Else
		ZZD->(dbsetorder(1))
		If !ZZD->(dbseek(xFilial("ZZD")+cOrigem+cPeriodo))
			MsgAlert("Convenente/Perํodo nใo encontrado. Revise os parโmetros.")
			lRet := .f.
		Else
			cConvDest := ZZC->ZZC_CODIGO+"-"+alltrim(ZZC->ZZC_DESCR)
			ZZC->(dbsetorder(1))
			ZZC->(dbseek(xFilial("ZZC")+cOrigem))
			cConvOrig := ZZC->ZZC_CODIGO+"-"+alltrim(ZZC->ZZC_DESCR)
			cMsg := "Deseja realmente copiar os perํodos do convenenente conforme abaixo ?"+Chr(13)+Chr(10)+;
			        "Convenente Destino: "+cConvDest+Chr(13)+Chr(10)+;
			        "Convenente Origem:  "+cConvOrig+Chr(13)+Chr(10)+;
			        "Perํodo Inicial:    "+cPeriodo
			If !MsgNoYes(cMsg)
				lRet := .f.
			EndIf
		EndIf
	EndIf
	
	RestArea(aZZC)
EndIf

If lRet

	If cTipo == 'C'
		cChave := "ZZD->ZZD_PERINI >= cPeriodo"  	//Quando Copia
	Else	
		cChave := "ZZD->ZZD_PERINI == cPeriodo"		//Quando Finalizacao do periodo e abertura de novo
		cNewPer := anomes(stod(cPerFim+'28')+10)
	EndIf

	Begin Transaction

		//Inicia a copia dos periodos
		While ZZD->(!eof()) .and. ZZD->(ZZD_FILIAL+ZZD_CODCON) == xFilial("ZZD")+cOrigem .and. &cChave
			
			nChoices	:= Len(	aEnchoice )
			aNew := array(nChoices)
	
			//Guarda no aNew o conteudo de todos os campos do registro ZZD posicionado	 
			For nChoice := 1 To nChoices
				If ( aScan( aZZDVirtChoice , { |cCpo| ( cCpo == aEnchoice[ nChoice , 02 ] ) } ) == 0.00 )
					If cTipo == 'C' .and. aEnchoice[ nChoice , 02 ]  == 'ZZD_CODCON'
						aNew[nChoice] := ZZC->ZZC_CODIGO
					ElseIf cTipo == 'F' .and. aEnchoice[ nChoice , 02 ] == 'ZZD_PERINI'
						aNew[nChoice] := cNewPer
					ElseIf cTipo == 'F' .and. aEnchoice[ nChoice , 02 ] $ 'ZZD_PERFIM/ZZD_PCONGE'
						aNew[nChoice] := ""
					Else
						aNew[nChoice] := ZZD->( &( aEnchoice[ nChoice , 02 ] ) )
					EndIf
				EndIf
			Next nChoice     
			nRecnoZZD := ZZD->(recno())
	
			RecLock( "ZZD" , .T. , .F. ) // Inclusao
				ZZD->ZZD_FILIAL := cFilZZD  //Filial nao esta nos controles 
				For nChoice := 1 To nChoices
					If ( aScan( aZZDVirtChoice , { |cCpo| ( cCpo == aEnchoice[ nChoice , 02 ] ) } ) == 0.00 )
						ZZD->( &( aEnchoice[ nChoice , 02 ] ) ) := aNew[nChoice]
					EndIf
				Next nChoice     
	        ZZD->( MsUnLock() ) 	        
			
			ZZD->(dbgoto(nRecnoZZD))
			ZZD->(dbskip())
			
		EndDo
		
		//Inicia a copia dos beneficios vinculados aos periodos
		aColsEnZZE	:= ZZE->(GdMontaCols(	@aEnchZZE	   		,;	//01 -> Array com os Campos do Cabecalho da GetDados
											@nZZEXs				,;	//02 -> Numero de Campos em Uso
											@aZZEVirtChoice		,;	//03 -> [@]Array com os Campos Virtuais
											@aZZEVisualChoice	,;	//04 -> [@]Array com os Campos Visuais
											"ZZE"				,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																,;  //07 -> [@]Array unidimensional contendo os Recnos	
																,;	//08 -> Alias do Arquivo Pai
											xFilial("ZZE")+cOrigem+cPeriodo,;  //09 -> Chave para o Posicionamento no Alias Filho
											,,,,,,,,,,,,,,,,,,,,,,3,; //32 -> nOpc
											))
	
		If cTipo == 'C'
			cChave := "ZZE->ZZE_PERINI >= cPeriodo"  	//Quando Copia
		Else	
			cChave := "ZZE->ZZE_PERINI == cPeriodo"		//Quando Finalizacao do periodo e abertura de novo
		EndIf

		ZZE->(dbsetorder(1))
		If ZZE->(dbseek(xFilial("ZZE")+cOrigem+cPeriodo))

			While ZZE->(!eof()) .and. ZZE->(ZZE_FILIAL+ZZE_CODCON) == xFilial("ZZE")+cOrigem .and. &cChave
				
				nChoices	:= Len(	aEnchZZE )
				aNew := array(nChoices)
		
				//Guarda no aNew o conteudo de todos os campos do registro ZZD posicionado	 
				For nChoice := 1 To nChoices
					If ( aScan( aZZEVirtChoice , { |cCpo| ( cCpo == aEnchZZE[ nChoice , 02 ] ) } ) == 0.00 )
						If cTipo == 'C' .and. aEnchZZE[ nChoice , 02 ]  == 'ZZE_CODCON'
							aNew[nChoice] := ZZC->ZZC_CODIGO
						ElseIf cTipo == 'F' .and. aEnchZZE[ nChoice , 02 ] == 'ZZE_PERINI'
							aNew[nChoice] := cNewPer
						Else
							aNew[nChoice] := ZZE->( &( aEnchZZE[ nChoice , 02 ] ) )
						EndIf
					EndIf
				Next nChoice     
				nRecnoZZE := ZZE->(recno())
		
				RecLock( "ZZE" , .T. , .F. ) // Inclusao
					ZZE->ZZE_FILIAL := xFilial("ZZE")  //Filial nao esta nos controles 
					For nChoice := 1 To nChoices
						If ( aScan( aZZEVirtChoice , { |cCpo| ( cCpo == aEnchZZE[ nChoice , 02 ] ) } ) == 0.00 )
							ZZE->( &( aEnchZZE[ nChoice , 02 ] ) ) := aNew[nChoice]
						EndIf
					Next nChoice     
		        ZZE->( MsUnLock() ) 	        
				
				ZZE->(dbgoto(nRecnoZZE))
				ZZE->(dbskip())
				
			EndDo
		
		EndIf		
		
		//Quando Finalizacao de periodo e abertura de novo, copia tambem as localidades do periodo em finalizacao
		If cTipo == 'F'
			aColsEnZZF	:= ZZF->(GdMontaCols(	@aEnchZZF	   		,;	//01 -> Array com os Campos do Cabecalho da GetDados
												@nZZFXs				,;	//02 -> Numero de Campos em Uso
												@aZZFVirtChoice		,;	//03 -> [@]Array com os Campos Virtuais
												@aZZFVisualChoice	,;	//04 -> [@]Array com os Campos Visuais
												"ZZF"				,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																	,;  //07 -> [@]Array unidimensional contendo os Recnos	
																	,;	//08 -> Alias do Arquivo Pai
												xFilial("ZZF")+cOrigem+cPeriodo,;  //09 -> Chave para o Posicionamento no Alias Filho
												,,,,,,,,,,,,,,,,,,,,,,3,; //32 -> nOpc
												))
			cChave := "ZZF->ZZF_PERINI == cPeriodo"	
			ZZF->(dbsetorder(1))
			If ZZF->(dbseek(xFilial("ZZF")+cOrigem+cPeriodo))
	
				While ZZF->(!eof()) .and. ZZF->(ZZF_FILIAL+ZZF_CODCON) == xFilial("ZZF")+cOrigem .and. &cChave
					
					nChoices	:= Len(	aEnchZZF )
					aNew := array(nChoices)
			
					//Guarda no aNew o conteudo de todos os campos do registro ZZD posicionado	 
					For nChoice := 1 To nChoices
						If ( aScan( aZZFVirtChoice , { |cCpo| ( cCpo == aEnchZZF[ nChoice , 02 ] ) } ) == 0.00 )
							If aEnchZZF[ nChoice , 02 ] == 'ZZF_PERINI'
								aNew[nChoice] := cNewPer
							Else
								aNew[nChoice] := ZZF->( &( aEnchZZF[ nChoice , 02 ] ) )
							EndIf
						EndIf
					Next nChoice     
					nRecnoZZF := ZZF->(recno())
			
					RecLock( "ZZF" , .T. , .F. ) // Inclusao
						ZZF->ZZF_FILIAL := xFilial("ZZF")  //Filial nao esta nos controles 
						For nChoice := 1 To nChoices
							If ( aScan( aZZFVirtChoice , { |cCpo| ( cCpo == aEnchZZF[ nChoice , 02 ] ) } ) == 0.00 )
								ZZF->( &( aEnchZZF[ nChoice , 02 ] ) ) := aNew[nChoice]
							EndIf
						Next nChoice     
			        ZZF->( MsUnLock() ) 	        
					
					ZZF->(dbgoto(nRecnoZZF))
					ZZF->(dbskip())
					
				EndDo
			
			EndIf		
		EndIf

		If cTipo == 'C'
			MsgAlert("Registros copiados com sucesso")
		Else
			MsgAlert("Perํodo finalizado com sucesso")
		EndIf

	End Transaction  

EndIf

RestArea(aArea)

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02F   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Finaliza o periodo                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CGPEA02F()

Local oDlgC
Local oFontC
Local oDirecc
Local cVarAlias	:= ""
Local cPerFim 	:= Space(6)
Local cCongela 	:= Space(6)
Local lRet    	:= .T.

	DEFINE FONT oFontC NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlgC TITLE OemToAnsi("Finalizar o perํodo e abrir o pr๓ximo") FROM 100,001 TO 240,500 PIXEL 

		@ 05,  10 SAY "Finalizar perํodo "+ZZD->ZZD_PERINI SIZE 80,10 PIXEL

		@ 20,  10 SAY "Informe a compet๊ncia final para o perํodo "+ZZD->ZZD_PERINI SIZE 160,10 PIXEL
		@ 18,  180 MSGET oDirecc VAR cPerFim SIZE 40,10 PIXEL

		@ 35,  10 SAY "Informe a compet๊ncia de congelamento, se houver (AAAAMM)" SIZE 160,10 PIXEL
		@ 33,  180 MSGET oDirecc VAR cCongela  SIZE 40,10 PIXEL

	DEFINE SBUTTON FROM 52, 140 TYPE 1 ENABLE OF oDlgC ACTION ( If(CGPEA02Y(cPerFim,cCongela),lRet := .T.,lRet:=.f.), oDlgC:End() )
	DEFINE SBUTTON FROM 52, 175 TYPE 2 ENABLE OF oDlgC ACTION ( lRet := .F., oDlgC:End() )
			
	ACTIVATE MSDIALOG oDlgC CENTERED 
	
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02Y   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Finaliza periodo (processamento)                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CGPEA02Y(cPerFim,cCongela)

Local aArea				:= GetArea()

If empty(cPerFim) .or. cPerFim < ZZD->ZZD_PERINI
	MsgAlert("Perํodo final invแlido")

ElseIf !empty(cCongela) .and. !empty(ZZD->ZZD_PCONGE) .and. ZZD->ZZD_PCONGE <> cCongela
	MsgAlert("No cadastro do perํodo jแ existe informa็ใo do perํodo de congelamento")
	
Else

	Begin Transaction

		RecLock("ZZD",.f.)
		ZZD->ZZD_PERFIM := cPerFim
		ZZD->ZZD_PCONGE := cCongela
		ZZD->(MsUnLock())

		//Executa a copia do periodo finalizado abrindo um novo periodo
		CGPEA02X(ZZC->ZZC_CODIGO,ZZD->ZZD_PERINI,"F",cPerFim)

	End Transaction
	
EndIf

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02B   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Beneficios no periodo                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CGPEA02B()
Local cChave  := ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)
Local cTitulo := "Cadastro de Benefํcios - Convenente: "+ZZC->ZZC_CODIGO+"-"+alltrim(ZZC->ZZC_DESCR)+"         Perํodo: "+left(ZZD->ZZD_PERINI,4)+"/"+Right(ZZD->ZZD_PERINI,2)+" a "
	cTitulo += If(empty(ZZD->ZZD_PERFIM),'____/__',+left(ZZD->ZZD_PERFIM,4)+"/"+Right(ZZD->ZZD_PERFIM,2))
	U_CGPEA03(cChave,cTitulo)
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02D   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Localidades no periodo                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CGPEA02D()
Local cChave  := ZZD->(ZZD_FILIAL+ZZD_CODCON+ZZD_PERINI)
Local cTitulo := "Cadastro de Localidades - Convenente: "+ZZC->ZZC_CODIGO+"-"+alltrim(ZZC->ZZC_DESCR)+"         Perํodo: "+left(ZZD->ZZD_PERINI,4)+"/"+Right(ZZD->ZZD_PERINI,2)+" a "
	cTitulo += If(empty(ZZD->ZZD_PERFIM),'____/__',+left(ZZD->ZZD_PERFIM,4)+"/"+Right(ZZD->ZZD_PERFIM,2))
	U_CGPEA04(cChave,cTitulo)
Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FGrava     บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava o registro                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FGrava(			cAlias,;			// Alias do arquivo principal - ZZD
								nOpc,;				// Opcao de Acordo com aRotina
							 	nReg,;				// Numero do Registro do Arquivo Pai ( ZZD )
							 	aColsEnChoice,;		// Cols da Enchoice - ZZD
							 	aSvEnchoice,;		// Clone do Vetor aEnchoice - para comparacao
							 	aZZDVirtChoice,;	// Campos Virtuais do Arquivo Pai ( ZZD )
							 	aRCFSvCols,;		// Clone de aRCFCols - RCF
								nRCFUsado,;	   		// Qtde de Campos usados - RCF
								aSvCols,;			// Clone de aCols
								aColsRec, ;	   		// Vetor com os Recnos 
								nPosRec,;           // Recno
								aRCGSvCols;			// Clone de aRCGColsAll	
						   )
Local aArea			:= GetArea()
// Variaveis auxiliares
Local nChoice		:= 0				// Variavel utilizada para for/while
Local nX			:= 0				// Utilizado em While/For
Local nY			:= 0				// Utilizado em While/For
Local nPosRot		:= ""
Local nPosPersel	:= ""
Local nPosFolCpl	:= ""   
Local cRotFol		:= fGetRotOrdinar()
Local lCompl		:= .T.
// Variaveis de tratamento da Tabela ZZD - Enchoice 
Local cKey			:= ""    			// Valor do campo chave
Local nChoices		:= 0.00				// Quantidade de campos da enchoice 
Local nLnAt			:= 0
     
DEFAULT nOpc			:= 0.00			// Opcao do menu selecionado   
DEFAULT nReg			:= 0.00
DEFAULT aZZDVirtChoice	:= {}			// Campos virtuais da tabela pai

	nChoices	:= Len(	aEnchoice )
    cKey 		:= cFilZZD +GetMemVar("ZZD_CODCON") + GetMemVar("ZZD_PERINI")   
      				
	// Se for Exclusao ( nOpc == 5 )								   
	If ( nOpc == 5 ) 
	
		If ZZD->(MsSeek( cKey ))	
			fDelZZD(cKey) 
		EndIf
	
	// Se for Inclusao/Alteracao 	   
	ElseIf ( nOpc == 3 .Or. nOpc == 4 )
		
		// Gravado em um vetor para verificar se houve alteracao 
		For nChoice := 1 To nChoices
			aColsEnChoice[ 01 , nChoice ] := &( "M->"+aEnchoice[ nChoice , 02 ] )
		Next nChoice                                                                            
	 
		Begin Transaction
			
			dbSelectArea("ZZD") 
			dbSetOrder(1)				
		
			If ZZD->(MsSeek( cKey ))	
		  		RecLock( "ZZD" , .F. , .F. ) // Alteracao		
			Else
				RecLock( "ZZD" , .T. , .F. ) // Inclusao
			EndIf
			
			// Campo que nao estao em controles 
			ZZD->ZZD_FILIAL := cFilZZD 

			For nChoice := 1 To nChoices
				If ( aScan( aZZDVirtChoice , { |cCpo| ( cCpo == aEnchoice[ nChoice , 02 ] ) } ) == 0.00 )
					ZZD->( &( aEnchoice[ nChoice , 02 ] ) ) := &( "M->"+aEnchoice[ nChoice , 02 ] )
				EndIf
			Next nChoice     
						
	        ZZD->( MsUnLock() ) 	        
		
		End Transaction  
		If nOpc == 3
			nVez++
		EndIf	

	EndIf
	
	RestArea(aArea)

Return( Nil )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CGPEA02V   บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao final antes da gravacao                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CGPEA02V()

Local lRet := .t.
Local aPer := {}
Local aArea 	:= getArea()
Local aAreaZZD 	:= ZZD->(getArea())
Local cPerIni   := M->ZZD_PERINI
Local cPerFim   := if(empty(M->ZZD_PERFIM),"299912",M->ZZD_PERFIM)
Local nX
Local nRecAtu   := ZZD->(recno())

//Verifica se as datas iniciais e finais do periodo conflitam com outros periodos ja cadastrados
ZZD->(dbsetorder(1))
If ZZD->(dbseek(xFilial("ZZD")+ZZC->(ZZC_CODIGO)))
	While ZZD->(ZZD_FILIAL+ZZD_CODCON) == ZZC->(ZZC_FILIAL+ZZC_CODIGO)
		If ZZD->(recno()) <> nRecAtu
			aadd(aPer,{ZZD->ZZD_PERINI,if(empty(ZZD->ZZD_PERFIM),"299912",ZZD->ZZD_PERFIM)})
		EndIf
		ZZD->(dbskip())
	EndDo
EndIf
If len(aPer) > 0
	For nX := 1 to len(aPer)
		If cPerIni >= aPer[nX,1] .and. cPerIni <= aPer[nX,2]
			MsgAlert("O perํodo inicial estแ conflitando com outro registro jแ existente com inํcio em "+aPer[nX,1])
			lRet := .f.
			Exit
		ElseIf cPerFim >= aPer[nX,1] .and. cPerFim <= aPer[nX,2]
			MsgAlert("O perํodo final estแ conflitando com outro registro jแ existente com inํcio em "+aPer[nX,1])
			lRet := .f.
			Exit
		EndIf
	Next nX
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidEnch  บ Autor ณ Marcos Pereira     บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da enchoice em uso                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidEnch(oEnchoice,nOpc)   
Local aArea			:= GetArea()	
Local cKey			:= ""       
Local lExistChav	:= .F.
	
	// Obrigatorio - verifica se todos os campos obrigatorios foram preenchidos
	lValEnchoice := ( Obrigatorio( oEnchoice:aGets , oEnchoice:aTela ) )
	
	If lValEnchoice

		If M->ZZD_TPSALA == '3' .and. (empty(M->ZZD_TAB1P) .or. empty(M->ZZD_TAB2P) .or. empty(M->ZZD_NIV1P) .or. empty(M->ZZD_NIV2P)) 
			Help( ,, 'HELP',, "Quando o Tipo de Salแrio estแ configurado para '3-Tabela', o preenchimento dos campos de Tabela e Nํvel sใo obrigat๓rios para os dois perํodos.", 1, 0 )  
			lValEnchoice := .f.

		ElseIf M->ZZD_TPSALA == '2' .and. (empty(M->ZZD_SALMEN) .or. empty(M->ZZD_SALHOR)) 
			Help( ,, 'HELP',, "Quando o Tipo de Salแrio estแ configurado para '2-Piso', o preenchimento dos campos de Piso Mensalista e Horista sใo obrigat๓rios.", 1, 0 )  
			lValEnchoice := .f.

		ElseIf !empty(M->ZZD_VLKITA) .and. empty(M->ZZD_QTKITA)  
			Help( ,, 'HELP',, "Quantidade de parcelas do Kit Admissใo nใo foi preenchida.", 1, 0 )  
			lValEnchoice := .f.

		ElseIf !empty(M->ZZD_VLMATD) .and. empty(M->ZZD_QTMATD)  
			Help( ,, 'HELP',, "Quantidade de parcelas do Material Didแtico nใo foi preenchida.", 1, 0 )  
			lValEnchoice := .f.

		ElseIf !empty(M->ZZD_VLRECR) .and. empty(M->ZZD_QTRECR)  
			Help( ,, 'HELP',, "Quantidade de parcelas do Reembolso de Crachแ nใo foi preenchida.", 1, 0 )  
			lValEnchoice := .f.

		ElseIf !empty(M->ZZD_VLREUN) .and. empty(M->ZZD_QTREUN)  
			Help( ,, 'HELP',, "Quantidade de parcelas do Reembolso de Uniforme nใo foi preenchida.", 1, 0 )  
			lValEnchoice := .f.

		EndIf
		
	EndIf
			
	If !lValEnchoice   
		oEnchoice:aEntryCtrls[ 2 ]:SetFocus()
	EndIf
		                                     
	RestArea(aArea)

Return( lValEnchoice )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDelZZD      บ Autor ณ Marcos Pereira   บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclusao (validacao e efetivacao)                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fDelZZD(cKeyDel)  
Local aArea		:= GetArea() 					
Local cMsg		:= '' 	

//Verifica se o periodo possui beneficios e/ou localidades
ZZE->(dbsetorder(1))
If ZZE->(dbseek(cKeyDel))
	cMsg += "na tabela de Benefํcios"
EndIf
ZZF->(dbsetorder(1))
If ZZF->(dbseek(cKeyDel))
	cMsg += if(!empty(cMsg)," e ","")
	cMsg += "na tabela de Localidades"
EndIf

If !empty(cMsg)
	cMsg := "A exclusใo nใo pode ser realizada devido a exist๊ncia de registros vinculados a este perํodo " + cMsg
	cMsg += ". Realize as devidas exclus๕es de registros relacionados para posteriormente excluir este perํodo."
	MsgAlert(cMsg)

Else

	RecLock("ZZD",.F.)
	ZZD->(dbDelete())
	ZZD->(MsUnlock())

EndIf

RestArea(aArea)

Return( Nil )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fValCpo      บ Autor ณ Marcos Pereira   บ Data ณ  24/07/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao generica para validacao de campos                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function fValCpo(cCampo,uConteudo)

Local lRet := .t.

DEFAULT cCampo 		:= readvar()
DEFAULT uConteudo 	:= &(readvar())

cCampo 		:= alltrim(strtran(cCampo,"M->",""))


If cCampo == 'ZZD_PERINI'
	If len(alltrim(uConteudo)) <> 6 .or. left(uConteudo,4) < '2018' .or. !(right(uConteudo,2)$"01/02/03/04/05/06/07/08/09/10/11/12")
		Help( ,, 'HELP',, "Compet๊ncia invแlida no campo 'Perํodo De'. Deverแ ser informada no formato AAAAMM, sendo ano a partir de 2018 e m๊s dentro do intervalo de 01 a 12.", 1, 0 )  
		lRet := .f.
	ElseIf !empty(M->ZZD_PERFIM) .and. uConteudo > M->ZZD_PERFIM
		Help( ,, 'HELP',, "Compet๊ncia invแlida no campo 'Perํodo De'. O seu conte๚do nใo pode ser maior que o perํodo final.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZD_PERFIM'
	If len(alltrim(uConteudo)) <> 6 .or. left(uConteudo,4) < '2018' .or. !(right(uConteudo,2)$"01/02/03/04/05/06/07/08/09/10/11/12")
		Help( ,, 'HELP',, "Compet๊ncia invแlida no campo 'Perํodo At้'. Deverแ ser informada no formato AAAAMM, sendo ano a partir de 2018 e m๊s dentro do intervalo de 01 a 12", 1, 0 )
		lRet := .f.
	ElseIf !empty(M->ZZD_PERINI) .and. uConteudo < M->ZZD_PERINI
		Help( ,, 'HELP',, "Compet๊ncia invแlida no campo 'Perํodo At้'. O seu conte๚do nใo pode ser menor que o perํodo inicial.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZD_TPSALM'
	If M->ZZD_TPSALA=='1' .and. !(uConteudo $ '12')  
		Help( ,, 'HELP',, "Quando no campo 'Tipo Salแrio' estiver configurado com 1-Salแrio Mํnimo, deverแ selecionar neste campo o tipo (Nacional ou Estadual).", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo $ 'ZZD_TAB1P/ZZD_TAB2P'
	If !EXISTCPO("RB6",uConteudo)                                                                         
		lRet := .f.
	EndIf
	
ElseIf cCampo == 'ZZD_NIV1P'
	If !EXISTCPO("RB6",M->(ZZD_TAB1P)+uConteudo)                                                                         
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZD_NIV2P'
	If !EXISTCPO("RB6",M->(ZZD_TAB2P)+uConteudo)                                                                         
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZC_CODIGO'
	If !(len(alltrim(uConteudo))==4) .or. uConteudo > '9999'    
		Help( ,, 'HELP',, "O c๓digo deve ter tamanho 4 e limitado at้ o c๓digo '9999'.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZC_DTINI'
	If empty(uConteudo) .or. (!empty(M->ZZC_DTFIM) .and. uConteudo > M->ZZC_DTFIM)    
		Help( ,, 'HELP',, "A data ้ obrigat๓ria e nใo pode maior que a data final.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZC_DTFIM'
	If !(empty(uConteudo)) .and. uConteudo < M->ZZC_DTINI    
		Help( ,, 'HELP',, "A data final nใo pode ser anterior เ data inicial.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZF_CODIGO'
	If !(len(alltrim(uConteudo))==4) .or. uConteudo > '9999'    
		Help( ,, 'HELP',, "O c๓digo deve ter tamanho 4 e limitado at้ o c๓digo '9999'.", 1, 0 )
		lRet := .f.
	EndIf

ElseIf cCampo == 'ZZE_OPCAO'
	If uConteudo == '2' //Somente VA
		M->ZZE_FORNVR 	:= '0'
		M->ZZE_BDESVR 	:= M->ZZE_FALTVR := M->ZZE_TPVVR4 := M->ZZE_TPVVR6 := '1'
		M->ZZE_DPCIVR   := '4'
		M->ZZE_MINFVR	:= M->ZZE_PFIXVR := M->ZZE_VFIXVR := M->ZZE_VALVR4 := M->ZZE_VALVR6 := 0
		M->ZZE_QTFVR4 := M->ZZE_QTFVR6 := M->ZZE_DFXVR4 := M->ZZE_DFXVR6 := M->ZZE_PDEVR4 := M->ZZE_PDEVR6 := 0
		M->ZZE_AFASVR	:= M->ZZE_CODVR4 := M->ZZE_CODVR6 := ''
	ElseIf uConteudo == '1' //Somente VR
		M->ZZE_FORNVA 	:= '0'
		M->ZZE_BDESVA 	:= M->ZZE_FALTVA := M->ZZE_TPVVA4 := M->ZZE_TPVVA6 := '1'
		M->ZZE_DPCIVA   := '4'
		M->ZZE_MINFVA	:= M->ZZE_PFIXVA := M->ZZE_VFIXVA := M->ZZE_VALVA4 := M->ZZE_VALVA6 := 0
		M->ZZE_QTFVA4 := M->ZZE_QTFVA6 := M->ZZE_DFXVA4 := M->ZZE_DFXVA6 := M->ZZE_PDEVA4 := M->ZZE_PDEVA6 := 0
		M->ZZE_AFASVA	:= M->ZZE_CODVA4 := M->ZZE_CODVA6 := ''
	ElseIf !(uConteudo $ '3/4')
		Help( ,, 'HELP',, "Op็ใo invแlida.", 1, 0 )
		lRet := .f.
	EndIf

EndIf

Return(lRet)		 