CREATE FUNCTION fn_vl_produto_cliente (  
 @cd_produto int,  
 @cd_cliente int )  
RETURNS NUMERIC(18,2)  
AS  
Begin  
 declare   @Preco float   
   
 set @Preco = (select top 1 pc.vl_produto_cliente from produto_cliente pc
              where isNull(pc.vl_produto_cliente,0) > 0 and
              pc.cd_cliente = @cd_cliente and pc.cd_produto = @cd_produto)
  
 if @Preco is null  
    set @Preco = 0  
   
 RETURN @Preco  
   
end  
  
-- Declare @teste float
-- set @teste = dbo.fn_vl_produto_cliente(256,256)
-- print @teste


