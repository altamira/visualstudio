
-------------------------------------------------------------------------------
--pr_retorno_fornecedor_exportacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : Atualização do Retorno do Arquivo
--Data             : 04.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_retorno_fornecedor_exportacao
@cd_fornecedor               int = 0,
@cd_identificacao_fornecedor varchar(15) = ''
as

if @cd_fornecedor>0 
begin
  update
    fornecedor 
  set
    cd_identificacao_fornecedor = @cd_identificacao_fornecedor
  where
    cd_fornecedor = @cd_fornecedor
end

