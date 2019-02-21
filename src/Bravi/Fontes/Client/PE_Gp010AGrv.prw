#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} Gp010AGrv
Ponto de Entrada apos a gravacao dos registros
@author Elton Teodoro Alves
@since 19/02/2019
@param nOpc, Numeric, Opera��o que est� sendo executado 3 = Inclus�o 4 = Altera��o 5 = Exclus�o 7 = C�pia
@param lGrava, Logic, Indica se a grava��o foi executada.
@version 12.1.17
/*/
User Function Gp010AGrv()

	Local nOpc   := PARAMIXB[ 1 ]
	Local lGrava := PARAMIXB[ 2 ]


	If lGrava .And.; // Verifica se � Aluno
	If( nOpc == 3 , Right( cFilAnt, 1 ) == '1', Right( SRA->RA_FILIAL , 1 ) == '1' )

		U_IntegBravi( nOpc )

	End If

Return