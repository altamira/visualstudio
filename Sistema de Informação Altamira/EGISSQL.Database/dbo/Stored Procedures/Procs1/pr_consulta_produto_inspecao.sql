
CREATE PROCEDURE pr_consulta_produto_inspecao
@ic_parametro        int, 
@cd_produto          int,
@nm_fantasia_produto varchar(30),
@nm_produto          varchar(40),
@cd_fase_produto     int

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Produto Inspecionado por Código
-------------------------------------------------------------------------------
  begin
    select 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      u.sg_unidade_medida,
      i.dt_produto_inspecao,
      t.nm_inspetor,
      m.nm_motivo_inspecao,
      i.nm_obs_produto_inspecao,
      s.qt_saldo_atual_produto        

    from produto p
    left outer join unidade_medida u on
      u.cd_unidade_medida = p.cd_unidade_medida
    
    left outer join produto_inspecao i on
      i.cd_produto = p.cd_produto
     
    left outer join inspetor t on
      t.cd_inspetor = i.cd_inspetor

    left outer join motivo_inspecao m on
      m.cd_motivo_inspecao = i.cd_motivo_inspecao

    left outer join produto_saldo s on
      s.cd_produto = p.cd_produto

   where p.cd_produto = @cd_produto and
	 s.cd_fase_produto = @cd_fase_produto 
  

  end
  
-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta de Produto Inspecionado por Nome Fantasia
-------------------------------------------------------------------------------
  begin
    select 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      u.sg_unidade_medida,
      i.dt_produto_inspecao,
      t.nm_inspetor,
      m.nm_motivo_inspecao,
      i.nm_obs_produto_inspecao,
      s.qt_saldo_atual_produto        

    from produto p
    left outer join unidade_medida u on
      u.cd_unidade_medida = p.cd_unidade_medida
    
    left outer join produto_inspecao i on
      i.cd_produto = p.cd_produto
     
    left outer join inspetor t on
      t.cd_inspetor = i.cd_inspetor

    left outer join motivo_inspecao m on
      m.cd_motivo_inspecao = i.cd_motivo_inspecao

    left outer join produto_saldo s on
      s.cd_produto = p.cd_produto
    
   where p.nm_fantasia_produto like @nm_fantasia_produto+'%' and
	 s.cd_fase_produto = @cd_fase_produto 

  end
  
-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta de Produto Inspecionado por Nome do Produto
-------------------------------------------------------------------------------
  begin
    select 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      u.sg_unidade_medida,
      i.dt_produto_inspecao,
      t.nm_inspetor,
      m.nm_motivo_inspecao,
      i.nm_obs_produto_inspecao,
      s.qt_saldo_atual_produto        

    from produto p
    left outer join unidade_medida u on
      u.cd_unidade_medida = p.cd_unidade_medida
    
    left outer join produto_inspecao i on
      i.cd_produto = p.cd_produto
     
    left outer join inspetor t on
      t.cd_inspetor = i.cd_inspetor

    left outer join motivo_inspecao m on
      m.cd_motivo_inspecao = i.cd_motivo_inspecao

    left outer join produto_saldo s on
      s.cd_produto = p.cd_produto

    where p.nm_produto like @nm_produto+'%' and
	  s.cd_fase_produto = @cd_fase_produto 
    

  end
  
