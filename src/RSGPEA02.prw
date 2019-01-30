/*/{Protheus.doc} ModelDef
Modelo de Dados do Cadastro de Vers�o de Matrizes
@type function
@author Elton Teodoro Alves
@since 30/01/2019
@version 12.1.17
@return Object, Objeto que representa o Modelo de Dados
/*/
Static Function ModelDef()
	
	Local oModel := MPFormModel():New('RSGPEA02')
	Local oStrZZ1  := FWFormStruct(1,'ZZ1')
	
	oModel:SetDescription('Vers�o das Matrizes')
	oModel:addFields('RSGPEA02_MASTER',,oStrZZ1)
	oModel:getModel('RSGPEA02_MASTER'):SetDescription('Vers�o das Matrizes')
	
Return oModel
