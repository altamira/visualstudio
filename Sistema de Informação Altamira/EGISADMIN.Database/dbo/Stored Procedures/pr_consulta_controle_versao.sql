
CREATE PROCEDURE pr_consulta_controle_versao
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Rafael M. Santiago
--Banco de Dados: EGISADMIN 
--Objetivo      : Controle Verão Módulo
--Data          : 11/07/2003
--Atualizado    : 04/01/2007 - Adicionando sigla do modulo - Anderson 
----------------------------------------------------------------------

@cd_modulo as integer,
@ic_parametro as integer

as

if @ic_parametro = 1

SELECT
  m.ic_liberado          as 'Liberado',
  m.cd_modulo            as 'Codigo',
  m.sg_modulo            as 'Sigla',
  m.nm_modulo            as 'Modulo',
  m.dt_ult_versao_modulo as 'UltimaVersao',
  m.cd_versao_modulo     as 'CodigoVersao',
  mvc.cd_modulo_versao   as 'VersaoCliente',
  c.nm_fantasia_cliente  as 'Cliente'
  
FROM
  Modulo m
  LEFT OUTER JOIN
  Modulo_Versao_Cliente mvc 
  ON
  m.cd_modulo = mvc.cd_modulo
  LEFT OUTER JOIN
  EGISSQL.dbo.Cliente c
  ON
  c.cd_cliente = mvc.cd_cliente 

WHERE
  ((mvc.cd_modulo = @cd_modulo) or (@cd_modulo =0)) and
    ic_liberado  = 'S'

ORDER BY
m.nm_modulo 

  

if @ic_parametro = 2

SELECT
  m.ic_liberado          as 'Liberado',
  m.cd_modulo            as 'Codigo',
  m.sg_modulo            as 'Sigla',
  m.nm_modulo            as 'Modulo',
  m.dt_ult_versao_modulo as 'UltimaVersao',
  m.cd_versao_modulo     as 'CodigoVersao',
  mvc.cd_modulo_versao   as 'VersaoCliente',
  c.nm_fantasia_cliente  as 'Cliente'
  
FROM
  Modulo m
  LEFT OUTER JOIN
  Modulo_Versao_Cliente mvc 
  ON
  m.cd_modulo = mvc.cd_modulo
  LEFT OUTER JOIN
  EGISSQL.dbo.Cliente c
  ON
  c.cd_cliente = mvc.cd_cliente 

WHERE
  ((mvc.cd_modulo = @cd_modulo) or (@cd_modulo =0))

ORDER BY
m.nm_modulo   


