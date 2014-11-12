
---------------------------------------------------------------------------------------
--fn_ultima_ordem_producao_item_pedido
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		      : Márcio Rodrigues 
--Banco de Dados		: EGISSQL
--Objetivo				: Varias Consultas necessitavam desta coluna no SPE, forma mais Rapida e facil de fazer isso.
--Data					: 05/02/2007
--Atualização        : 09.11.2010 - Busca do pedido na tabela de processo_producao_pedido - Carlos Fernandes
--
------------------------------------------------------------------------------------------------------------------------------------------

create FUNCTION fn_ultima_ordem_producao_item_pedido
 (@cd_pedido_venda int, 
  @cd_item_pedido_venda int)    
RETURNS int  
AS  

begin  

  declare @cd_processo int

  	 	Select Top 1 @cd_processo = isnull(Max(cd_processo),0)
		From Processo_Producao with (nolock) 
		where cd_pedido_venda      = isnull(@cd_pedido_venda,0) and
       		cd_item_pedido_venda = isnull(@cd_item_pedido_venda,0) and 
				dt_canc_processo	    is Null

  if @cd_processo = 0
  begin
    select top 1 @cd_processo = isnull(cd_processo,0) 
    from
      processo_producao_pedido 
    where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda
     
  end
   


  return @cd_processo


end  

