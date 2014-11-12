
CREATE  procedure pr_busca_faixa_produto
@cd_produto int 
as

declare @cd_fase_produto_baixa int

--if @cd_fase_produto_baixa is not null 
   select @cd_fase_produto_baixa = isnull(cd_fase_produto_baixa,0) 
    from produto
   where cd_produto = @cd_produto

if @cd_fase_produto_baixa = 0  
   select @cd_fase_produto_baixa = isnull(cd_fase_produto,0)
     from parametro_Comercial

if @cd_fase_produto_baixa = 0  
   select @cd_fase_produto_baixa = cd_fase_produto
      from parametro_Suprimento

select @cd_fase_produto_baixa as Faixa


