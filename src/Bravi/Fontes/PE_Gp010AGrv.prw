#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} Gp010AGrv
Ponto de Entrada apos a gravacao dos registros
@author Elton Teodoro Alves
@since 19/02/2019
@param nOpc, Numeric, Operação que está sendo executado 3 = Inclusão 4 = Alteração 5 = Exclusão 7 = Cópia
@param lGrava, Logic, Indica se a gravação foi executada.
@version 12.1.17
/*/
User Function Gp010AGrv()

	Local nOpc   := PARAMIXB[ 1 ]
	Local lGrava := PARAMIXB[ 2 ]


	If lGrava .And.; // Verifica se é Aluno
	If( nOpc == 3 , Right( cFilAnt, 1 ) == '1', Right( SRA->RA_FILIAL , 1 ) == '1' )

		U_IntegBravi( nOpc )

	End If

Return