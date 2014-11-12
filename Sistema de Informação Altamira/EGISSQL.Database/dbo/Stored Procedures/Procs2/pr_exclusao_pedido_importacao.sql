
CREATE PROCEDURE pr_exclusao_pedido_importacao
-------------------------------------------------------------------------------
--pr_exclusao_pedido_importacao
-------------------------------------------------------------------------------
-- GBS - Global Business Sollution  Ltda                                   2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Paulo Souza
--Banco de Dados          : EgisSql
--Objetivo                : Exclusão de Pedido de Importação de todas as tabelas
--                          relacionadas. 
--Data                    : 22/12/2004
--Atualização             : 27/12/2004 - Acerto do cabeçalho  - Sérgio Cardoso
--                        : 20.09.2007 - Verificação da Procedure - Carlos Fernandes
-----------------------------------------------------------------------------------------------

@ic_parametro         integer = 0,
@cd_pedido_importacao Integer = 0

AS

  if @ic_parametro = 1
     delete from Pedido_Importacao_CartaCredito where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 2
    delete from Pedido_Importacao_Despesa       where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 3
    delete from Pedido_Importacao_Documento     where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 4
    delete from Pedido_Importacao_Entreposto    where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 5
    delete from Pedido_Importacao_Frete         where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 6
    delete from Pedido_Importacao_Historico     where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 7
    delete from Pedido_Importacao_Proforma      where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 8
    delete from Pedido_Importacao_Seguro   where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 9
    delete from Pedido_Importacao_Texto    where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 10
    delete from Pedido_Importacao_Item     where cd_pedido_importacao = @cd_pedido_importacao

  else if @ic_parametro = 11
    delete from Pedido_Importacao          where cd_pedido_importacao = @cd_pedido_importacao

