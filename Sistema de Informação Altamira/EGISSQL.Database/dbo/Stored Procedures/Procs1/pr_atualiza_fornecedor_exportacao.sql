
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 04.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualiza_fornecedor_exportacao
@cd_fornecedor int = 0
as

if @cd_fornecedor>0 
begin
  update
    fornecedor 
  set
    dt_exportacao_fornecedor = getdate()
  where
    cd_fornecedor = @cd_fornecedor
end

