
CREATE PROCEDURE pr_consulta_reajuste_grupo_preco_custo
@ic_parametro            int,
@cd_grupo_preco_produto  int,
@pc_reajuste             float,
@cd_motivo_reajuste      int,
@nm_obs_produto_preco    varchar(40),
@cd_usuario              int,
@dt_usuario              datetime,
@cd_categoria_produto    int         = 0,
@ic_filtrar_com_preco    char(1)     = 'S',
@ic_incluir_composicao   char(1)     = 'N',
@cd_mascara_grupo_preco  varchar(40) = '' ,
@cd_fornecedor           int         = 0,
@ic_tipo_custo           char(1)     = '' --R = Reposição / --M = Mercado 

as

set @ic_filtrar_com_preco  = isnull(@ic_filtrar_com_preco,'S')
set @ic_incluir_composicao = isnull(@ic_incluir_composicao,'N')

declare @cd_tipo_reajuste     int,
	@cd_tipo_tabela_preco int


--select @ic_parametro

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
    from Grupo_Preco_Produto gp with (nolock) 
    where gp.cd_grupo_preco_produto = @cd_grupo_preco_produto
  end
  else if (not @cd_mascara_grupo_preco is null) -- filtrada pela mascara do grupo de preco
  begin
    select
      gp.cd_grupo_preco_produto,
      gp.nm_grupo_preco_produto,
      gp.sg_grupo_preco_produto,
      0 as 'cd_motivo_reajuste'
    from grupo_preco_produto gp with (nolock) 
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
    from Categoria_Produto cp with (nolock) 
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
    Produto p                   with (nolock) 
    inner join Grupo_produto gp with (nolock) 
	on gp.cd_grupo_produto=p.cd_grupo_produto 
	and IsNull(gp.cd_status_grupo_produto, 1)  = 1 
	and IsNull(p.cd_status_produto, gp.cd_status_grupo_produto)  = 1
    left outer join Produto_Custo pc with (nolock) on pc.cd_produto=p.cd_produto
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
    pc.vl_custo_produto                  as vl_produto,
    isnull(pp.vl_temp_produto_preco,0)   as vl_temp_produto_preco,
    pp.qt_indice_produto_preco,
    pc.vl_custo_produto,
    pc.vl_custo_previsto_produto

--select * from produto_custo

  from
  #Produtos ptemp
  inner Join Produto p                   with (nolock) on p.cd_produto       =ptemp.cd_produto
  left outer join Produto_Custo pc       with (nolock) on pc.cd_produto      =p.cd_produto
  left outer join Unidade_Medida u       with (nolock) on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Produto_Preco_Custo pp with (nolock) on pp.cd_produto      =p.cd_produto
  where
    ( (@ic_filtrar_com_preco = 'N') or 
      (isnull(pc.vl_custo_produto,0) > 0 ) )
  order by
    2, 3

end

-------------------------------------------------------------------
if @ic_parametro = 3 --Atualização dos Preços de acordo com o 
                     --Grupo de Preço
-------------------------------------------------------------------
begin

--  select @ic_parametro

	--Define o tipo de Reajuste como sendo manual
	set @cd_tipo_reajuste =
	  (select top 1 cd_tipo_reajuste 
	   from Tipo_Reajuste with (nolock) 
	   where
	     isnull(ic_manual_tipo_reajuste,'N')='S')
	
	--Define o tipo de tabela como sendo a padrão
	set @cd_tipo_tabela_preco =
	  (select top 1 cd_tipo_tabela_preco 
	   from Tipo_Tabela_Preco with (nolock) 
	   where
	     isnull(ic_pad_tipo_tabela_preco,'N')='S')
	
	Select
	  p.cd_produto,
	  @dt_usuario            as dt_produto_preco,
	  pc.vl_custo_produto    as vl_atual_produto_preco,
	  pc.vl_custo_produto + ( pc.vl_custo_produto / 100 * @pc_reajuste ) as vl_temp_produto_preco,
	  pc.cd_grupo_preco_produto,
	  @cd_tipo_reajuste      as cd_tipo_reajuste,
	  @cd_motivo_reajuste    as cd_motivo_reajuste,
	  @nm_obs_produto_preco  as nm_obs_produto_preco,
	  @cd_usuario            as cd_usuario,
	  IsNull(pc.cd_moeda,1)  as cd_moeda,
	  @dt_usuario            as dt_usuario
	into
	  #Produto
	from
	  Produto p 
          inner join Produto_Custo pc with (nolock) on p.cd_produto = pc.cd_produto
	where
	  pc.cd_grupo_preco_produto = @cd_grupo_preco_produto

--        select @cd_grupo_preco_produto

--        select * from #Produto
	
	delete from Produto_Preco_Custo
	where 
          cd_produto in ( Select cd_produto from #Produto ) --where cd_produto = Produto_Preco_Custo.cd_produto)
	
	insert into Produto_Preco_Custo
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

   drop table #Produto

end

