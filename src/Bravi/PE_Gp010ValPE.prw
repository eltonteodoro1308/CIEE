#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Gp010ValPE  � Autor �                    � Data � 11.05.18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para validacao final cadastr funcionarios ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CIEE                                                       ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function Gp010ValPE()

	Local lRet := .t.

	//Verifica se o centro de custo possui parametrizacao de codigo de municipio, quando filial 01 CLT
	If lRet .and. right(cFilAnt,2) == '01'
		CTT->(dbsetorder(1))
		If !(CTT->(dbseek(xFilial("CTT")+M->RA_CC))) .or. empty(CTT->CTT_XUF) .or. empty(CTT->CTT_XCODMU)
			MsgStop("O centro de custo selecionado n�o possui parametriza��o do local para feriados municipais. Ajuste o cadastro do centro de custo.")
			lRet := .f.
		EndIf
	EndIf

	//****************************************************************
	// ATENCAO: O trecho abaixo devera ser a ultima validacao deste PE
	//          pois realiza inclusoes de registros de beneficios e,
	//          caso por algum motivo este PE retorne Falso apos estas
	//          gravacoes, os registros ficarao orfaos.
	//****************************************************************
	If lRet
		lRet := U_CGPEE02()
	EndIf

	//****************************************************************
	//Se tudo acima estiver ok e o funcion�rio for estagi�rio
	//Faz integra��o com o Bravi
	//****************************************************************

	If lRet .And. Right( SRA->RA_FILIAL, 1 ) == '1' // Verifica se � Aluno

		lRet := lRet .And. U_IntegBravi()

	End If

Return(lret)
