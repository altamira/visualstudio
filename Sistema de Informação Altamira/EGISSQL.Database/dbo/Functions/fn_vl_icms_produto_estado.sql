CREATE FUNCTION fn_vl_icms_produto_estado (  
 @cd_estado_cliente int,  
 @cd_pais_cliente int, 
 @cd_produto int )  
RETURNS NUMERIC(18,2)  
AS  
Begin  
 declare   @icms float   
   
 set @icms = (Select top 1 pc_icms_classif_fiscal 
                      from Classificacao_fiscal_Estado 
                      where cd_estado =  @cd_estado_cliente and 
                      cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) 
                                                 from Produto_Fiscal 
                                                 where cd_produto = @cd_produto))


  if (@icms is null  ) or (@icms <= 0)
     set @icms =  (Select top 1 isNull(pc_aliquota_icms_estado,0) from  Estado_Parametro 
                   where cd_pais = @cd_pais_cliente and cd_estado = @cd_estado_cliente )

 if @icms is null  
    set @icms = 0

   
 RETURN @icms 
   
end  
  
--   Declare @teste float
--   set @teste = dbo.fn_vl_icms_produto_estado(26,1,23877)
--   print @teste


