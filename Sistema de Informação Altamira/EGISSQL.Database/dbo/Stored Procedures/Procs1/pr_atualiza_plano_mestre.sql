

/****** Object:  Stored Procedure dbo.pr_atualiza_plano_mestre    Script Date: 13/12/2002 15:08:12 ******/

CREATE PROCEDURE pr_atualiza_plano_mestre
@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_usuario int

as

  declare @cd_produto 			int
  declare @qt_produto		 	float
  declare @qt_leadtime			float
  declare @cd_fase_produto 		int
  declare @cd_categoria_produto 	int
  declare @qt_saldo			float
  declare @qt_producao			float

  declare @qt_saldo_reserva_produto	float
  declare @qt_saldo_fase_produto	float

  declare @qt_minimo_produto		float
  declare @qt_lote_fabricacao		float
  declare @qt_minimo_importacao		float

  declare @qt_saldo_pedido		float

  declare @cd_previsao			int
  declare @cd_pedido			int

  -- preenchimento da tabela temporária com todos os planejamentos de venda
  select
    identity(int,1,1) as 'CODIGO',
    *
  into
    #Previsao_Venda
  from
    Previsao_Venda
  where
    dt_inicio_previsao_venda = @dt_inicial and
    dt_final_previsao_venda = @dt_final and
    ic_plano_mestre = case when @ic_parametro = 2 then 'N' end or
    ic_plano_simulacao = case when @ic_parametro = 1 then 'N' end

  if not exists(select * from #Previsao_Venda)
    begin
      raiserror('Não existe planejamento de venda para o período especificado!', 16, 1)
      return
    end

  -- Apaga a tabela de Plano de Producao
  if @ic_parametro = 1  -- SIMULACAO
    truncate table Plano_Simulacao_Producao
  else			-- MESTRE
    truncate table Plano_Mestre_Producao

  -- faz a leitura do planejamento para montagem do novo plano mestre
  while exists(select * from #Previsao_Venda)
    begin

      -- Campos da própria Previsão
      select
        @cd_previsao		= CODIGO,
        @cd_categoria_produto 	= cd_categoria_produto,
        @cd_produto		= cd_produto,
        @cd_fase_produto	= cd_fase_produto,
        @qt_produto		= isnull(qt_produto_previsao_venda,0)
      from
        #Previsao_Venda
     
      -- Campos do Saldo do Produto
      select 
	top 1 
        @qt_saldo  = isnull(qt_atual_prod_fechamento,0)
      from 
        produto_fechamento 
      where 
        cd_produto = @cd_produto and 
        cd_fase_produto = @cd_fase_produto and 
        dt_produto_fechamento < @dt_inicial
      order by 
        dt_produto_fechamento desc
   
      -- Campos do Produto
      select
        @qt_leadtime = isnull(qt_leadtime_compra,0)
      from 
        produto
      where
        cd_produto = @cd_produto

      -- Cálculo do Saldo de Produção 
      set @qt_producao = @qt_produto - @qt_saldo

      -- Saldo da Reserva, Estoque e Importação Mínimos 
      select
        @qt_saldo_reserva_produto = qt_saldo_reserva_produto,
        @qt_minimo_produto  = qt_minimo_produto,
        @qt_minimo_importacao     = qt_minimo_imp_produto
      from
        Produto_Saldo
      where
        cd_produto = @cd_produto and
        cd_fase_produto = @cd_fase_produto

      -- Saldo de Todas as Fases
      select
        @qt_saldo_fase_produto = sum(qt_saldo_atual_produto)
      from
        Produto_Saldo
      where
        cd_produto = @cd_produto

      -- Lote Econômico/Lote de Produção
      select
        @qt_lote_fabricacao = qt_lote_fabricacao_prod
      from
        Produto_PCP 
      where
        cd_produto = @cd_produto   

      -- caso esteja com saldo negativo então ler os pedidos de venda 
      set @qt_saldo_reserva_produto = @qt_saldo_reserva_produto -
				      (@qt_minimo_produto +
                                       @qt_minimo_importacao +
				       @qt_saldo_fase_produto)

      if @qt_saldo_reserva_produto < 0
        begin

          -- tabela temporária com os itens dos pedidos
          select
            identity(int,1,1) as 'CODIGO',
            i.qt_saldo_pedido_venda
          into 
            #Pedido_Venda_Item
          from 
            pedido_venda_item i,
            pedido_venda p
          where 
            i.cd_produto = @cd_produto and
            i.qt_saldo_pedido_venda > 0 and
            p.cd_status_pedido = 1 and
            p.ic_fat_pedido_venda <> 'S' and
            p.cd_pedido_venda = i.cd_pedido_venda and
            p.dt_pedido_venda between @dt_inicial and @dt_final
          order by
            p.dt_pedido_venda desc

          while exists(select * from #Pedido_Venda_Item)
            begin

              select
                @cd_pedido = CODIGO,
                @qt_saldo_pedido = qt_saldo_pedido_venda
              from
                #Pedido_Venda_Item
                
              set @qt_producao = @qt_producao + @qt_saldo_pedido
              

              delete from
                #Pedido_Venda_Item
              where
                CODIGO = @cd_pedido

            end

        end      

      -- Insere os dados na tabela específica
      if @ic_parametro = 1
        begin
          insert into Plano_Simulacao_Producao         
            (dt_inicio_plano_simulacao,
             dt_final_plano_simulacao,
             cd_produto,
             qt_produto_plano_simulacao,
             qt_lead_plano_simulacao,
             cd_fase_produto,
             cd_categoria_produto,
             qt_saldo_plano_simulacao,
             qt_produc_plano_simulacao,
             cd_usuario,
             dt_usuario )
           values
             (@dt_inicial,
              @dt_final,
              @cd_produto,
              @qt_produto,
              @qt_leadtime,
              @cd_fase_produto,
              @cd_categoria_produto,
              @qt_saldo,
              @qt_producao,
              @cd_usuario,
              getDate() )
        end
      else
        begin
          insert into Plano_Mestre_Producao         
            (dt_inicio_plano_mestre,
             dt_final_plano_mestre,
             cd_produto,
             qt_produto_plano_mestre,
             qt_lead_plano_mestre,
             cd_fase_produto,
             cd_categoria_produto,
             qt_saldo_plano_mestre,
             qt_producao_plano_mestre,
             cd_usuario,
             dt_usuario )
           values
             (@dt_inicial,
              @dt_final,
              @cd_produto,
              @qt_produto,
              @qt_leadtime,
              @cd_fase_produto,
              @cd_categoria_produto,
              @qt_saldo,
              @qt_producao,
              @cd_usuario,
              getDate() )
        end

      delete from
        #Previsao_Venda
      where
        CODIGO = @cd_previsao

    end 

  -- atualiza a tabela de previsão de vendas
  if @ic_parametro = 1
    update
      Previsao_Venda
    set
      ic_plano_simulacao = 'S'
    where    
      dt_inicio_previsao_venda = @dt_inicial and
      dt_final_previsao_venda = @dt_final and
      cd_produto = @cd_produto and
      cd_fase_produto = @cd_fase_produto
  else
    update
      Previsao_Venda
    set
      ic_plano_mestre = 'S'
    where    
      dt_inicio_previsao_venda = @dt_inicial and
      dt_final_previsao_venda = @dt_final and
      cd_produto = @cd_produto and
      cd_fase_produto = @cd_fase_produto
  


