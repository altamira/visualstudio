
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_centro_custo_documento_pagar
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Rateio automático do Contas a Pagar 
--                   Documento Pagar
--                   A partir de uma Nota Fiscal de Centra 
--Data             : 21.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualiza_centro_custo_documento_pagar
@ic_parametro         int = 0,
@cd_nota_entrada      int = 0,
@cd_fornecedor        int = 0,
@cd_operacao_fiscal   int = 0,
@cd_serie_nota_fiscal int = 0

as

--select * from nota_entrada_centro_custo


if @cd_nota_entrada>0 
begin

  select
    *
  from
    nota_entrada_centro_custo
  where
    cd_nota_entrada      = @cd_nota_entrada      and
    cd_fornecedor        = @cd_fornecedor        and
    cd_operacao_fiscal   = @cd_operacao_fiscal   and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal

  --select * from nota_entrada_parcela
  
  select
    *
  into
    #NotaEntradaParcela
  from
   Nota_Entrada_Parcela
  where
    cd_nota_entrada      = @cd_nota_entrada      and
    cd_fornecedor        = @cd_fornecedor        and
    cd_operacao_fiscal   = @cd_operacao_fiscal   and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal 


end



