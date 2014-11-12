
-------------------------------------------------------------------------------
--sp_helptext pr_gera_codigo_produto_montagem
-------------------------------------------------------------------------------
--pr_gera_codigo_produto_montagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Montagem do Produto Final busca do nome fantasia
--Data             : 11.05.2008
--Alteração        : 13.05.2008 - Ajuste do Texto de Descrição
--
--
------------------------------------------------------------------------------
create procedure pr_gera_codigo_produto_montagem
@cd_resultado_montagem int = 0
as

declare @cd_modelo_produto        int
declare @cd_montagem_produto      int
declare @cd_item_montagem_produto int
declare @ds_item_montagem_produto varchar(8000)
declare @ds_montagem_produto      varchar(8000)
declare @cd_produto               int
declare @nm_fantasia_produto      varchar(30)
declare @ds_texto_padrao          varchar(8000)
declare @cd_norma_construtiva     int
declare @ds_norma_construtiva     varchar(8000)
declare @cd_portaria_norma        int
declare @ds_portaria_norma        varchar(8000)

set @cd_produto          = 0
set @nm_fantasia_produto = ''
set @ds_texto_padrao     = ''

--select * from modelo_produto
--select * from resultado_montagem
--select * from resultado_montagem_produto
--select * from montagem_produto
--select * from montagem_produto_composicao


if @cd_resultado_montagem>0 
begin
  
  select
    @cd_modelo_produto = isnull(cd_modelo_produto,0)
  from
    Resultado_Montagem
  where
    cd_resultado_montagem = @cd_resultado_montagem

  select
    @nm_fantasia_produto  = isnull(nm_fantasia_modelo,''),
    @cd_portaria_norma    = isnull(cd_portaria_norma,0),
    @cd_norma_construtiva = isnull(cd_norma_construtiva,0),
    @ds_texto_padrao      = @ds_texto_padrao + rtrim(ltrim( cast (ds_modelo_produto as varchar(8000) ) ) )

  from
    Modelo_Produto mp
  where
    cd_modelo_produto = @cd_modelo_produto

   --Verifica a Portaria
   --select * from portaria_norma
   --select @cd_portaria_norma

   if @cd_portaria_norma>0
   begin
     select
       @ds_portaria_norma = rtrim(ltrim( isnull( cast(nm_portaria_norma as varchar),'' )))
     from
       Portaria_Norma
     where
       cd_portaria_norma = @cd_portaria_norma
   end

   --Verifica a Norma Construtiva

   if @cd_norma_construtiva>0 
   begin
     select
       @ds_norma_construtiva = rtrim(ltrim( isnull( cast(nm_norma_construtiva as varchar),'' )))
     from
       Norma_Construtiva
     where
       cd_norma_construtiva = @cd_norma_construtiva
     
   end

   -------------------------------------------------------------------------------
   --Montagem do Texto conforme o Resultado da Montagem
   -------------------------------------------------------------------------------
   --select * from resultado_montagem_produto
   --select * from montagem_produto

   select 
     *
   into 
     #ResultadoMontagemProduto
   from
     Resultado_Montagem_Produto
   where
     cd_resultado_montagem = @cd_resultado_montagem

   while exists ( select top 1 cd_resultado_montagem from #ResultadoMontagemProduto )
   begin
     select
       top 1
       @cd_resultado_montagem = cd_resultado_montagem,
       @cd_montagem_produto   = cd_montagem_produto
     from
       #ResultadoMontagemProduto

     --print 'oi'

     select
       @ds_montagem_produto = @ds_montagem_produto + rtrim( ltrim( cast( ds_montagem_produto as varchar(8000) ) ) )       
     from
       Montagem_Produto
     where
       isnull(ic_texto_padrao,'N')='S'       

     delete from #ResultadoMontagemProduto
     where
       @cd_resultado_montagem = cd_resultado_montagem and
       @cd_montagem_produto   = cd_montagem_produto
         
   end
     
   -------------------------------------------------------------------------------
   --Montagem do Texto conforme o Resultado da Montagem Composição
   -------------------------------------------------------------------------------
   --select * from resultado_montagem_composicao
   --select * from montagem_produto

   select 
     *
   into
     #ResultadoMontagemComposicao
   from
     Resultado_Montagem_Composicao
   where
     cd_resultado_montagem = @cd_resultado_montagem

   while exists ( select top 1 cd_resultado_montagem from #ResultadoMontagemComposicao )
   begin
     select
       top 1
       @cd_resultado_montagem    = cd_resultado_montagem,
       @cd_montagem_produto      = cd_montagem_produto,
       @cd_item_montagem_produto = cd_item_montagem_produto
     from
       #ResultadoMontagemComposicao

     --print 'oi'

     select
       @ds_item_montagem_produto = @ds_item_montagem_produto + rtrim( ltrim( cast( nm_item_montagem_produto as varchar(60) ) ) )       
     from
       Montagem_Produto_Composicao
     where
       isnull(ic_texto_padrao_composicao,'N')='S'       

     delete from #ResultadoMontagemComposicao
     where
       @cd_resultado_montagem = cd_resultado_montagem and
       @cd_montagem_produto   = cd_montagem_produto   and
       @cd_item_montagem_produto = cd_item_montagem_produto
         
   end

   --select * from resultado_montagem_composicao
 
   --Montagem do Texto

   select
     @ds_texto_padrao = rtrim( ltrim( cast( @ds_texto_padrao as varchar(8000))))
                        + ' '
                        + rtrim( ltrim( cast( @ds_montagem_produto as varchar(8000))))
                        + ' '
                        + rtrim( ltrim( cast( @ds_item_montagem_produto as varchar(8000))))
                        + ' '  
                        + @ds_portaria_norma
                        + ' ' 
                        + @ds_norma_construtiva
   
--   select @ds_portaria_norma 

--   select @ds_texto_padrao

end

select
  --@cd_produto = isnull(p.cd_produto,0)
  isnull(p.cd_produto,0) as cd_produto,
  p.cd_mascara_produto   as cd_mascara_produto,
  p.nm_fantasia_produto  as nm_fantasia_produto,
  p.nm_produto           as nm_produto,
  @ds_texto_padrao       as ds_texto_padrao
from
  Produto p
where
  p.nm_fantasia_produto = @nm_fantasia_produto

-- select 
--   @cd_produto as cd_produto

