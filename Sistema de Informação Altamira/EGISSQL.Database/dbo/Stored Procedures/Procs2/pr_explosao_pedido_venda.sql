
-------------------------------------------------------------------------------
--sp_helptext pr_explosao_pedido_venda
-------------------------------------------------------------------------------
--pr_explosao_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mostra a Explosão dos componentes do Pedido de Venda
--Data             : 04.08.2009
--Alteração        : 28.08.2009 - Ajuste dos itens - Carlos Fernandes
--
-- 01.09.2009 - Ajuste do Produto Pai - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_explosao_pedido_venda
@cd_pedido_venda int     = 0,
@ic_mostra_pai   char(1) = 'N'

as


if @cd_pedido_venda>0 
begin

--   select 
--     pv.cd_pedido_venda
--   from
--     pedido_venda pv
--   where
--     pv.cd_pedido_venda = @cd_pedido_venda

  --Mostra a Explosão do Pedido de Venda

  select   
--    identity(int,1,1)                                                                            as cd_controle,
    pvc.cd_pedido_venda,
    dbo.fn_mascara_produto(pvc.cd_produto)                                                       as 'cd_mascara_produto',
    p.nm_fantasia_produto,
    p.nm_produto,
    sum(pvc.qt_item_produto_comp)                                                                as qt_item_produto_comp,
    max(fp.nm_fase_produto)                                                                      as nm_fase_produto,
    max(IsNull(pe.nm_endereco, dbo.fn_produto_localizacao(pvc.cd_produto, pvc.cd_fase_produto))) as 'nm_endereco',
    p.cd_produto,
    case when isnull(( select top 1 cd_produto_pai
                       from produto_composicao pc with (nolock) 
      where
         pc.cd_produto_pai = p.cd_produto ),0)>0 then 'S' else 'N' end                           as ic_composicao                                             
  into
    #PedidoComposicao
 
  from 
    Pedido_Venda_Composicao pvc         with (nolock)  
    left outer join Produto p           with (nolock) on p.cd_produto       = pvc.cd_produto 
    left outer join Fase_produto fp     with (nolock) on fp.cd_fase_produto = pvc.cd_fase_produto
    left outer join Produto_Endereco pe with (nolock) on pe.cd_produto      = p.cd_produto and
		                                         pe.cd_fase_produto = pvc.cd_fase_produto
  where 
    pvc.cd_pedido_venda      = @cd_pedido_venda 
    --and pvc.cd_item_pedido_venda = :cd_item_pedido_venda

  group by
    pvc.cd_pedido_venda,
    pvc.cd_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    p.cd_produto

  --select * from #PedidoComposicao order by cd_mascara_produto
 
    CREATE TABLE #Produto_Composicao
(
   cd_produto_pai          INT NULL,
   id_produto_composicao   INT NULL,
   cd_produto              INT NULL,
   nm_fantasia_produto     VARCHAR(30) NULL,
   qt_produto_composicao   INT NULL,
   nm_fantasia_composicao  VARCHAR(30) NULL,
   ds_produto_codmposicao  VARCHAR(50) NULL,
   cd_mascara_composicao   VARCHAR(30) NULL,
   cd_fase_produto         INT NULL,
   cd_ordem_produto_comp   INT NULL,
   cd_versao_produto_comp  INT NULL,
   cd_unidade_medida       INT NULL,
   qt_leadtime             INT NULL,
   qt_leadtime_compra      INT NULL,
   cd_grupo_produto        INT NULL,
   cd_versao_produto       INT NULL,
   qt_peso_bruto           float null,
   qt_peso_liquido         float null,   
   cd_produto_composicao   INT NULL,
   sg_unidade_medida       CHAR(10) NULL,
   nm_fase_produto         CHAR(10) NULL,
   cd_processo_padrao      int      null)

  select
    * 
  into 
    #Aux
  from
    #PedidoComposicao
  where
    ic_composicao = 'S' 

  --select * from #Aux

  declare @cd_controle          int
  declare @nm_fantasia_produto  varchar(30)
  declare @qt_item_produto_comp float

  set @cd_controle = 0

  while exists( select top 1 cd_produto from #Aux )
  begin
    select top 1 
      @cd_controle          = cd_produto,
      @nm_fantasia_produto  = nm_fantasia_produto,
      @qt_item_produto_comp = qt_item_produto_comp
    from
      #Aux

    INSERT INTO #Produto_Composicao
       EXEC pr_consulta_produto_composicao @nm_fantasia_produto, 1, @qt_item_produto_comp

    --Atualiza a Quantidade do Item

--     update
--       #Produto_Composicao
--     set
--       qt_produto_composicao = qt_produto_composicao * @qt_item_produto_comp
--     where
--       cd_produto = @cd_controle

    delete from #Aux
    where
      cd_produto = @cd_controle
     
  end

  --select * from #Produto_Composicao 

  --Agrupamento dos Produtos/Quantidade

  select
--    identity(int,50000,1)                                                                        as cd_controle,
    max(@cd_pedido_venda)                                                                        as cd_pedido_venda,
    dbo.fn_mascara_produto(pvc.cd_produto)                                                       as 'cd_mascara_produto',
    p.nm_fantasia_produto,
    p.nm_produto,
    sum(pvc.qt_produto_composicao)                                                                as qt_item_produto_comp,
    max(fp.nm_fase_produto)                                                                      as nm_fase_produto,
    max(IsNull(pe.nm_endereco, dbo.fn_produto_localizacao(pvc.cd_produto, pvc.cd_fase_produto))) as 'nm_endereco',
    p.cd_produto,
    'N' as ic_composicao
--     case when isnull(( select top 1 cd_produto_pai from produto_composicao pc 
--       where
--          pc.cd_produto_pai = p.cd_produto ),0)>0 then 'S' else 'N' end                           as ic_composicao                                             
  into
    #AgrupaComposicao
 
  from 
    #Produto_Composicao pvc             with (nolock)  
    left outer join Produto p           with (nolock) on p.cd_produto       = pvc.cd_produto 
    left outer join Fase_produto fp     with (nolock) on fp.cd_fase_produto = pvc.cd_fase_produto
    left outer join Produto_Endereco pe with (nolock) on pe.cd_produto      = p.cd_produto and
		                                         pe.cd_fase_produto = pvc.cd_fase_produto
  group by
    pvc.cd_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    p.cd_produto


   --select * from #AgrupaComposicao

   declare @cd_fase_produto int

   select @cd_fase_produto = isnull(cd_fase_produto,0)
   from
       parametro_comercial
   where
      cd_empresa = dbo.fn_empresa()

   --select * from produto_saldo

--   SET IDENTITY_INSERT #PedidoComposicao On

    insert into #PedidoComposicao
     select * from #AgrupaComposicao

   select 
     c.*,
     Disponivel = isnull(qt_saldo_reserva_produto,0),
     Atual      = isnull(qt_saldo_atual_produto,0),
     Producao   = qt_item_produto_comp,
     p.qt_largura_produto,
     p.qt_comprimento_produto,
     p.qt_altura_produto
   from
     #PedidoComposicao c
     left outer join produto p        with (nolock) on p.cd_produto  = c.cd_produto
     left outer join produto_saldo ps with (nolock) on ps.cd_produto = c.cd_produto and
                                                       ps.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                              then
                                                                p.cd_fase_produto_baixa 
                                                              else
                                                                @cd_fase_produto 
                                                              end
    where
      c.ic_composicao    = 'N' --somente os filhos
      and c.nm_fase_produto is not null 
   order by
     c.nm_produto

--   union all



   drop table  #PedidoComposicao
  

end

