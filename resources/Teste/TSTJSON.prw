#INCLUDE 'TOTVS.CH'

User Function TstJson()

    Local cJson := ""
    Local oJson := Nil
    Local lOk   := .F.

   cJson += '{'
   cJson += ' "CODIFICACAOPADRAO": "CODIFICACAOPADRAO",'
   cJson += ' "CODIFICACAOAUXILIAR": "CODIFICACAOAUXILIAR",'
   cJson += ' "TEXTO": "TEXTO",'
   cJson += ' "NUMERICO": 123,'
   cJson += ' "TRUE": true,'
   cJson += ' "FALSE": false,'
   cJson += ' "NULO": null,'
   cJson += ' "OBJETO": { "NOME": "OBJETO"},'
   cJson += ' "ARRAY": [ "TEXTO", 123, true, false, null, { "NOME": "OBJETO"} ]'
   cJson += '}'
    
    lOk := FWJsonDeserialize( cJson, @oJson )

Return