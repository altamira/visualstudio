-------------------------------------------------------------------------------  
--pr_delecao_movimentacao_estoque_caixa  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2004  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes  
--Banco de Dados   : Egissql  
--Objetivo         :   
--Data             : 07.03.2006  
--Alteração        :   
------------------------------------------------------------------------------  
CREATE procedure pr_delecao_movimentacao_estoque_caixa  
  
@ic_parametro       int = 0, --1 Cancelamento / --2 Reativação  
@cd_movimento_caixa int = 0  
  
as  
  
  
--Cancelamento  
  
if @cd_movimento_caixa > 0  
begin  
  
  -- Cancelamento  
  
  if @ic_parametro = 1  
  begin  
  
    insert into Seguranca_Movimento_Estoque  
    select  
      *  
    from  
      Movimento_Estoque  
    where  
      cd_documento_movimento = @cd_movimento_caixa and cd_tipo_documento_estoque = 16  
  
    delete from movimento_estoque where cd_documento_movimento=@cd_movimento_caixa and cd_tipo_documento_estoque = 16  
  
  end  
  
  -- Cancelamento  
  
  if @ic_parametro = 2  
  begin  
  
    insert into Movimento_Estoque  
    select  
      *  
    from  
      Seguranca_Movimento_Estoque  
    where  
      cd_documento_movimento = @cd_movimento_caixa and cd_tipo_documento_estoque = 16  
  
    delete from seguranca_movimento_estoque where cd_documento_movimento=@cd_movimento_caixa and cd_tipo_documento_estoque = 16  
  
  end  
  
     
end  
  

