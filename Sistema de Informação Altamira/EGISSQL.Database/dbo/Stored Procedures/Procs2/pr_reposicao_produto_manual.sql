
CREATE PROCEDURE pr_reposicao_produto_manual
@cd_grupo_produto       int         = 0,
@cd_grupo_preco_produto int         = 0,
@ic_filtro_produto      char(1)     = '',
@cd_busca_produto       varchar(50) = '',
@ic_custo_zerado        char(1)     = 'S',
@ordernar_por           char(1)     = 'F',
@ic_tipo_preco_produto  int         = 0     --0=Preço de Custo de Reposição
                                            --1=Preço de Custo de Mercado

as


--select * from grupo_preco_produto
--select * from status_produto

begin

  declare @cd_produto int
  
  --Define padrão caso nulo

  Select
    @cd_grupo_preco_produto = IsNull(@cd_grupo_preco_produto,0),
    @ic_filtro_produto      = IsNull(@ic_filtro_produto,''),
    @cd_grupo_produto       = IsNull(@cd_grupo_produto,0),
    @cd_busca_produto       = IsNull(@cd_busca_produto,'')
  
  Select
   P.cd_produto,
   P.cd_mascara_produto,
   P.cd_grupo_produto,
   P.nm_fantasia_produto,
   P.nm_produto,
   U.sg_unidade_medida sg_unidade,
   PC.cd_produto pc_cd_produto,
   isnull(pc.vl_custo_produto,0)          as vl_custo_produto,
   isnull(pc.vl_custo_previsto_produto,0) as vl_custo_previsto_produto,
   isnull(pc.vl_custo_produto,0)          as vl_custo_produto_anterior,
   isnull(pc.vl_custo_previsto_produto,0) as vl_custo_previsto_produto_ant,
   cast (0.00 as money)                   as vl_composicao_produto,
   cast (0.00 as money)                   as vl_composicao_previsto_produto,
   PC.dt_custo_produto,
   PC.nm_obs_custo_produto,
   PC.cd_usuario,
   PC.dt_usuario,
   pc.cd_grupo_preco_produto,
   'N'                                   as ic_composto,
   isnull(pc.cd_moeda,1)                 as cd_moeda,
   isnull(m.sg_moeda,'')                 as sg_moeda,
   'S'                                   as ic_atualiza_cadastro,
   getdate()                             as dt_base_historico
   
  into
   #Temp

  from
  produto P                        with (nolock)
  left outer join Unidade_medida U with (nolock) on (U.cd_unidade_medida = P.cd_unidade_medida)
  left outer join produto_custo PC with (nolock) on (PC.cd_produto = P.cd_produto)  
  left outer join Moeda m          with (nolock) on m.cd_moeda     = pc.cd_moeda

  where
    isnull(p.cd_status_produto,1) = 1 and --Produto Ativo
    IsNull(p.nm_fantasia_produto,'') like ( case @ic_filtro_produto 
  			      		 when 'F' then @cd_busca_produto + '%'
  			    		 else IsNull(p.nm_fantasia_produto,'')
  				       end ) and
    IsNull(p.cd_mascara_produto,'') like ( case @ic_filtro_produto 
  			      		 when 'C' then @cd_busca_produto + '%'
  			    		 else IsNull(p.cd_mascara_produto,'')
  				       end ) and
    IsNull(p.cd_grupo_produto,0) = ( case IsNull(@cd_grupo_produto,0)
  			             when 0 then IsNull(p.cd_grupo_produto,0)
  				     else @cd_grupo_produto
  				   end ) and
    isnull(pc.cd_grupo_preco_produto,0)  = case when @cd_grupo_preco_produto=0 then isnull(pc.cd_grupo_preco_produto,0) else @cd_grupo_preco_produto end  

  if ( @cd_grupo_preco_produto <> 0 )
  begin
--     delete from #Temp where
--       not exists (Select 'x' from Grupo_Preco_Produto where cd_mascara_grupo_preco like @cd_grupo_preco_produto + '%')

     delete from #Temp where
       not exists (Select 'x' from Grupo_Preco_Produto where cd_grupo_preco_produto = @cd_grupo_preco_produto )

  end

  update #Temp
  set ic_composto = 'S'
  where exists(Select 'x' from produto_composicao where cd_produto_pai = #Temp.cd_produto)

  DECLARE Preco_Reposicao_Produto CURSOR 
  FAST_FORWARD
  READ_ONLY
  FOR 
  SELECT cd_produto
  FROM #Temp
  where ic_composto = 'S'
  
  OPEN Preco_Reposicao_Produto
  
  FETCH NEXT FROM Preco_Reposicao_Produto 
  INTO @cd_produto
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
    update #Temp
    set 
      vl_composicao_produto =   cast(round(IsNull((Select
  				        IsNull(sum(IsNull(pc.vl_custo_produto,0)),0)
  				      from
  				       [dbo].[fn_composicao_produto] (@cd_produto) p
  				       left outer join produto_custo pc with (nolock) on
  				       (pc.cd_produto = p.cd_produto)
  			            ),0),2) as money),
      vl_composicao_previsto_produto =   cast(round(IsNull((Select
  				        IsNull(sum(IsNull(pc.vl_custo_previsto_produto,0)),0)
  				      from
  				       [dbo].[fn_composicao_produto] (@cd_produto) p
  				       left outer join produto_custo pc with (nolock) on
  				       (pc.cd_produto = p.cd_produto)
  			            ),0),2) as money)

    where
      cd_produto = @cd_produto
  
    FETCH NEXT FROM Preco_Reposicao_Produto 
    INTO @cd_produto

  END
  
  CLOSE      Preco_Reposicao_Produto
  DEALLOCATE Preco_Reposicao_Produto


  if ( @ic_custo_zerado = 'N' )
  begin
    Delete from #Temp where IsNull(vl_custo_produto,0) + IsNull(vl_composicao_produto,0) = 0
  end

  if ( @ordernar_por = 'F' )
    Select *, 
      IsNull(vl_custo_produto,0)          + IsNull(vl_composicao_produto,0)          as vl_custo_total,
      IsNull(vl_custo_previsto_produto,0) + IsNull(vl_composicao_previsto_produto,0) as vl_custo_previsto_total
    from #Temp 
    order by nm_fantasia_produto
  else
    Select *,
      round(IsNull(vl_custo_produto,0),2)          + IsNull(vl_composicao_produto,0) as vl_custo_total,
      round(IsNull(vl_custo_previsto_produto,0),2) + IsNull(vl_composicao_previsto_produto,0) as vl_custo_previsto_total
    from #Temp 
    order by cd_mascara_produto

end

--select * from grupo_preco_produto

