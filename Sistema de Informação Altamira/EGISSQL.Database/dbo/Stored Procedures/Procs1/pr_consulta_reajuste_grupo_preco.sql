CREATE PROCEDURE pr_consulta_reajuste_grupo_preco
---------------------------------------------------------------------
--pr_consulta_reajuste_grupo_preco
---------------------------------------------------------------------
--GBS - Global Business Solution Ltda                            2004
---------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server  2000
--Autor(es)		: Daniel Duela
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Produtos para Alteração Definitiva do Preço
--Data			: 19/07/2002
--                      : 03/02/2004 - Aceita a Categoria do Produto - Alexandre
--                      : 03/02/2004 - Quando for por Categoria, incluir os itens da
--                                     Composição. Permitir filtrar apenas os que movimentam
--                                     Estoque - Eduardo
--Atualização           : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--			: 28.03.2005 - Inclusao do parametro @cd_mascara_grupo_preco - Clelson Camargo
---------------------------------------------------------------------------------------------
@ic_parametro            int,
@cd_grupo_preco_produto  int,
@pc_reajuste             float,
@cd_motivo_reajuste      int,
@nm_obs_produto_preco    varchar(40),
@cd_usuario              int,
@dt_usuario              datetime,
@cd_categoria_produto    int = 0,
@ic_filtrar_com_preco    char(1) = 'S',
@ic_incluir_composicao   char(1) = 'N',
@cd_mascara_grupo_preco  varchar(40)
as

set @ic_filtrar_com_preco = isnull(@ic_filtrar_com_preco,'S')
set @ic_incluir_composicao = isnull(@ic_incluir_composicao,'N')

declare @cd_tipo_reajuste int,
	@cd_tipo_tabela_preco int

-------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta de Grupo de Produto
-------------------------------------------------------------------
begin
  -- Seleção de Grupo
  if (@cd_grupo_preco_produto <> 0) -- filtrada pelo codigo
  begin
    select
      gp.cd_grupo_preco_produto,
      gp.nm_grupo_preco_produto,
      gp.sg_grupo_preco_produto,
      0 as 'cd_motivo_reajuste'
    from Grupo_Preco_Produto gp
    where gp.cd_grupo_preco_produto = @cd_grupo_preco_produto
  end
  else if (not @cd_mascara_grupo_preco is null) -- filtrada pela mascara do grupo de preco
  begin
    select
      gp.cd_grupo_preco_produto,
      gp.nm_grupo_preco_produto,
      gp.sg_grupo_preco_produto,
      0 as 'cd_motivo_reajuste'
    from grupo_preco_produto gp
    where gp.cd_mascara_grupo_preco like @cd_mascara_grupo_preco
  end
  else
  begin
    -- Seleção de Categoria
    select
      cp.cd_categoria_produto as 'cd_grupo_preco_produto',
      cp.nm_categoria_produto as 'nm_grupo_preco_produto',
      cp.sg_categoria_produto as 'sg_grupo_preco_produto',
      0 as 'cd_motivo_reajuste'
    from Categoria_Produto cp
    where cp.cd_categoria_produto = @cd_categoria_produto
  end
end

-------------------------------------------------------------------
if @ic_parametro = 2 --Consulta filtrada por Grupo, Serie ou Produto
-------------------------------------------------------------------
begin
  select
    p.cd_produto
  into
    #Produtos
  from
    Produto p
    inner join Grupo_produto gp
	on gp.cd_grupo_produto=p.cd_grupo_produto 
	and IsNull(gp.cd_status_grupo_produto, 1)  = 1 
	and IsNull(p.cd_status_produto, gp.cd_status_grupo_produto)  = 1
    left outer join Produto_Custo pc    
      on pc.cd_produto=p.cd_produto
  where    
    ( isnull(pc.cd_grupo_preco_produto,0) =
      (case @cd_grupo_preco_produto 
			   when 0 then IsNull(pc.cd_grupo_preco_produto,0)
				        else @cd_grupo_preco_produto
				 end) )
    and
    ( isnull(p.cd_categoria_produto,0) =
     (case @cd_categoria_produto 
	  	  when 0 then p.cd_categoria_produto
               else @cd_categoria_produto
			 end) )

  -- Se o Filtro for por Categoria, incluir na lista de
  -- Produtos os registros da Composição
  if ( @ic_incluir_composicao = 'S' )
  begin

    declare @cd_produto int

    declare cr cursor for
    select cd_produto from #Produtos

    open cr

    FETCH NEXT FROM cr INTO @cd_produto

    while @@FETCH_STATUS = 0
    begin

      insert into #Produtos
      select cd_produto from dbo.fn_composicao_produto( @cd_produto )

      FETCH NEXT FROM cr INTO @cd_produto
    end
  end

  select
    p.cd_produto,
    dbo.fn_mascara_produto(p.cd_produto) as 'cd_mascara_produto',
    p.nm_fantasia_produto,
    p.nm_produto,
    u.sg_unidade_medida,
    p.vl_produto,
    pp.vl_temp_produto_preco,
    pp.qt_indice_produto_preco
  from
  #Produtos ptemp
  inner Join Produto p
    on p.cd_produto=ptemp.cd_produto
  left outer join Produto_Custo pc
    on pc.cd_produto=p.cd_produto
  left outer join Unidade_Medida u
    on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Produto_Preco pp
    on pp.cd_produto=p.cd_produto
  where
    ( (@ic_filtrar_com_preco = 'N') or
      (isnull(p.vl_produto,0) > 0 ) )
  order by
    2, 3
end

-------------------------------------------------------------------
if @ic_parametro = 3 --Atualização dos Preços de acordo com o 
                     --Grupo de Preço
-------------------------------------------------------------------
begin
	--Define o tipo de Reajuste como sendo manual
	set @cd_tipo_reajuste =
	  (select top 1 cd_tipo_reajuste 
	   from Tipo_Reajuste
	   where
	     ic_manual_tipo_reajuste='S')
	
	--Define o tipo de tabela como sendo a padrão
	set @cd_tipo_tabela_preco =
	  (select top 1 cd_tipo_tabela_preco 
	   from Tipo_Tabela_Preco
	   where
	     ic_pad_tipo_tabela_preco='S')
	
	Select
	  p.cd_produto,
	  @dt_usuario as dt_produto_preco,
	  p.vl_produto as vl_atual_produto_preco,
	  p.vl_produto + ( p.vl_produto / 100 * @pc_reajuste ) as vl_temp_produto_preco,
	  pc.cd_grupo_preco_produto,
	  @cd_tipo_reajuste as cd_tipo_reajuste,
	  @cd_motivo_reajuste as cd_motivo_reajuste,
	  @nm_obs_produto_preco as nm_obs_produto_preco,
	  @cd_usuario as cd_usuario,
	  IsNull(p.cd_moeda,1) as cd_moeda,
	  @dt_usuario as dt_usuario
	into
	  #Produto
	from
	  Produto p inner join Produto_Custo pc
	  on p.cd_produto = pc.cd_produto
	where
	  pc.cd_grupo_preco_produto = @cd_grupo_preco_produto
	
	delete from Produto_Preco
	where exists(Select 'x' from #Produto where cd_produto = Produto_Preco.cd_produto)
	
	insert into Produto_Preco
	Select
		cd_produto,
		dt_produto_preco,
		IsNull(vl_atual_produto_preco,0),
		IsNull(vl_temp_produto_preco,0),
		@pc_reajuste,
		@nm_obs_produto_preco,
		cd_grupo_preco_produto,
		cd_moeda,
		cd_tipo_reajuste,
		@cd_motivo_reajuste,
		@cd_tipo_tabela_preco,
		@cd_usuario,
		dt_usuario,
                null, -- código do Cliente
                null  -- código do Servico
	from
		#Produto
end


----------------------------------------------------------------------
/*
exec dbo.pr_consulta_reajuste_grupo_preco  @ic_parametro = 1, 
  @cd_grupo_preco_produto = 0, @pc_reajuste = NULL, @cd_motivo_reajuste = NULL,
  @nm_obs_produto_preco = NULL, @cd_usuario = NULL, @dt_usuario = NULL, 
  @cd_categoria_produto = 29
*/

/*
exec dbo.pr_consulta_reajuste_grupo_preco  @ic_parametro = 2, 
  @cd_grupo_preco_produto = 0, @pc_reajuste = NULL, @cd_motivo_reajuste = NULL,
  @nm_obs_produto_preco = NULL, @cd_usuario = NULL, @dt_usuario = NULL, 
  @cd_categoria_produto = 29, @ic_filtrar_com_preco = 'S'
*/
----------------------------------------------------------------------
--Testando a Stored Procedure
----------------------------------------------------------------------
-- go
-- exec dbo.pr_consulta_reajuste_grupo_preco  @ic_parametro = 3, @cd_grupo_preco_produto = 1, @pc_reajuste = 4.100000000000000e+000, @cd_motivo_reajuste = 2, @nm_obs_produto_preco = NULL, @cd_usuario = 1067, @dt_usuario = 'jul 25 2005 12:00:00:000AM', @cd_categoria_produto = NULL, @cd_mascara_grupo_preco = NULL
