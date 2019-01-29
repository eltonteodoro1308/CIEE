#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"

WSRESTFUL THEWSCLASS DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON

WSDATA startIndex AS STRING
WSDATA count AS STRING

WSMETHOD GET V1 DESCRIPTION "Exemplo de retorno de entidade(s)" WSSYNTAX "/THEWSCLASS"
WSMETHOD GET V2 DESCRIPTION "Exemplo de retorno de entidade(s)" WSSYNTAX "/THEWSCLASS/{id}" PATH "/{id}"

END WSRESTFUL

WSMETHOD GET V1 QUERYPARAM startIndex, count WSSERVICE THEWSCLASS

// define o tipo de retorno do método
::SetContentType("application/json")

::SetResponse( '{ "versao": "V1" }' )

Return .T.

WSMETHOD GET V2 PATHPARAM id WSSERVICE THEWSCLASS

// define o tipo de retorno do método
::SetContentType("application/json")

::SetResponse( '{ "versao": "V2" }' )

Return .T.