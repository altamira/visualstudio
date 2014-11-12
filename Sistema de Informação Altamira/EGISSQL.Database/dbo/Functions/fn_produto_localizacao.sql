
CREATE FUNCTION fn_produto_localizacao 
	(@cd_produto int, @cd_fase_produto int)

RETURNS varchar(100) 

AS
Begin
   declare @cd_grupo_localizacao int
   declare @localizacao as varchar(100)
   declare @endereco as varchar(50)

   set @localizacao = ''

   --------------------------------------------------------------------------------
   --Declara o cursor para gerar a localização de estoque
   -- Procurar antes da tabela "Produto_Endereco"
   declare cProduto_Localizacao cursor for
   select
     nm_endereco
   from
     Produto_Endereco
   Where
     cd_produto = @cd_produto and
     cd_fase_produto = @cd_fase_produto
   order by
     nm_endereco

   open cProduto_Localizacao

   fetch next from cProduto_Localizacao into @endereco

   while @@FETCH_STATUS =0
   begin         
     if @localizacao <> ''
     begin
       set @localizacao = @localizacao + ' / '
     end

     set @localizacao = @localizacao + @endereco

     fetch next from cProduto_Localizacao into @endereco
   end

   close cProduto_Localizacao
   deallocate cProduto_Localizacao


   if ( @localizacao = '' )
   begin

     --------------------------------------------------------------------------------
     --Declara o cursor para gerar a localização de estoque
     declare cProduto_Localizacao cursor for
     select 
       cd_grupo_localizacao
     from
       Produto_Localizacao
     where 
       cd_produto = @cd_produto and
       cd_fase_produto = @cd_fase_produto
     order by
       cd_grupo_localizacao   

     open cProduto_Localizacao

     fetch next from cProduto_Localizacao into @cd_grupo_localizacao

     while @@FETCH_STATUS =0
     begin         
       select
         @localizacao = @localizacao + (
                        rtrim(cast(pl.qt_posicao_localizacao as varchar))
                        ) 
       from
         Produto_Localizacao pl 
       where 
         (pl.cd_produto = @cd_produto) and
         (pl.cd_grupo_localizacao = @cd_grupo_localizacao) and
         (pl.cd_fase_produto = @cd_fase_produto)

       fetch next from cProduto_Localizacao into @cd_grupo_localizacao
     end

     close cProduto_Localizacao
     deallocate cProduto_Localizacao

  end

  return @localizacao      

end


-----------------------------------------
-- Testando
-----------------------------------------
--select dbo.fn_produto_localizacao( 3, 3 )
