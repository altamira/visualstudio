
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_valor_ipi_produto_classificacao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualizar o Valor do IPI da Tabela Produto Fiscal Entrada/Saída
--Data             : 12.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualiza_valor_ipi_produto_classificacao
@cd_classificacao_fiscal int = 0

as



if @cd_classificacao_fiscal>0 
begin

  declare @vl_ipi_classificacao float
  
  select
    @vl_ipi_classificacao = isnull(vl_ipi_classificacao,0)
  from
    classificacao_fiscal
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal


  update 
    produto_fiscal
  set
    vl_ipi_produto_fiscal = @vl_ipi_classificacao
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal

  update 
    produto_fiscal_entrada
  set
    vl_ipi_produto_fiscal = @vl_ipi_classificacao
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal


end


