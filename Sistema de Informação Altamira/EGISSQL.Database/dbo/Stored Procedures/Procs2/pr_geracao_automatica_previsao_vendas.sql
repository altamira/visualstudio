
create procedure pr_geracao_automatica_previsao_vendas

------------------------------------------------------------------------
--pr_geracao_automatica_previsao_vendas
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
-------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Geração Automática de Previsão de Vendas
--Data			: 16/11/2004
--Alteração             : 16/11/2004
--                      : 13/12/2004 - Acerto do Cabeçalho -  Sérgio Cardoso
--                      : 30.11.2005 - Revisão Geral - Carlos Fernandes
--------------------------------------------------------------------------------

@ic_parametro        int      = 1,
@cd_vendedor         int      = 0,
@cd_cliente          int      = 0,
@dt_inicial          datetime = null,
@dt_final            datetime = null,
@dt_base             datetime = null,
@cd_fase_produto     int      = 0,
@dt_inicial_anterior datetime = null,
@dt_final_anterior   datetime = null,
@cd_usuario          int      = 0,
@cd_pais             int      = 0,
@cd_tipo_previsao    char(2)  = 'VC',
@cd_produto          int      = 0 

as

declare @cd_previsao_venda int

set @cd_previsao_venda = isnull(( select max(cd_previsao_venda) from previsao_venda ),0)+1
set @dt_base           = isnull(@dt_base,     getdate() )
set @cd_vendedor       = isnull(@cd_vendedor, 0)
set @cd_cliente        = isnull(@cd_cliente,  0)
set @dt_inicial        = isnull(@dt_inicial,  @dt_base)
set @dt_final          = isnull(@dt_final,    @dt_base)
set @cd_pais           = isnull(@cd_pais,     0)
set @cd_produto        = isnull(@cd_produto,  0)

--Busca a Fase de Produto

set @cd_fase_produto = isnull(@cd_fase_produto,
                             (SELECT cd_fase_produto
                              FROM Parametro_Comercial
                              WHERE cd_empresa = dbo.fn_empresa()))

-----------------------------------------------------------------------
if @ic_parametro = 1 -- Geração automatica
-----------------------------------------------------------------------
begin

  -----------------------------------------------------------------------
  if @cd_tipo_previsao = 'VC' -- Geração automatica Vendedor Cliente
  -----------------------------------------------------------------------
  begin

    select
      identity(int,1,1) as cd_previsao_venda,
      pv.cd_vendedor,
      pv.cd_cliente,
      pvi.cd_produto,
      @cd_fase_produto                as cd_fase_produto,
      pvi.qt_item_pedido_venda        as qt_produto_previsao_venda
    into
      #Aux_Previsao1

    from
      Pedido_Venda_Item pvi
      left join Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
      left join Cliente c on c.cd_cliente = pv.cd_cliente
    where
      pv.dt_pedido_venda between @dt_inicial_anterior and @dt_final_anterior and  --Período
      pv.dt_cancelamento_pedido is null                    and  --Pedido de Venda Cancelado não Entrada
      pvi.dt_cancelamento_item is null                     and  --Item do Pedido não pode estar Cancelado
      isnull(pvi.cd_produto,0)>0                           and
      isnull(pv.cd_vendedor,0)>0                           and
      isnull(pv.cd_vendedor,0) = case when isnull(@cd_vendedor,0)=0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
      isnull(pv.cd_cliente,0)  = case when isnull(@cd_cliente,0 )=0 then isnull(pv.cd_cliente,0)  else @cd_cliente  end and
      isnull(pvi.cd_produto,0) = case when isnull(@cd_produto,0 )=0 then isnull(pvi.cd_produto,0) else @cd_produto  end

      --Mostra a Tabela Temporária Gerada
      --select * from #Previsao
      --Mostra a Tabela Agrupada

    select distinct
      @cd_previsao_venda + max(p.cd_previsao_venda) AS cd_previsao_venda,
      p.cd_vendedor,
      p.cd_cliente,
      p.cd_produto,
      sum(p.qt_produto_previsao_venda) as qt_produto_previsao_venda
      --  sum(p.chave        )             as cd_previsao_venda
    into #Previsao1
    from #Aux_Previsao1 p
    group by
      p.cd_vendedor,
      p.cd_cliente,
      p.cd_produto
    order by
      p.cd_vendedor,
      p.cd_cliente,
      p.cd_produto

    --Gravação da Tabela Temporária

    insert 
      Previsao_Venda (
        cd_previsao_venda,
        dt_inicio_previsao_venda,
        dt_final_previsao_venda,
        cd_vendedor,
        cd_cliente,
        cd_produto,
        cd_fase_produto,
        qt_produto_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @dt_inicial,
      @dt_final,
      cd_vendedor,
      cd_cliente,
      cd_produto,
      @cd_fase_produto,
      qt_produto_previsao_venda,
      @cd_usuario,
      getdate()
    from #Previsao1
 
    -- Inserindo Composicao

    insert 
      Previsao_Venda_Composicao (
        cd_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @cd_usuario,
      getdate()
    from 
      #Previsao1

  -----------------------------------------------------------------------
  end -- Fim do Paramento 'VC'
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  if @cd_tipo_previsao = 'P' -- Geração automatica Pais
  -----------------------------------------------------------------------
  begin

    select
      identity(int,1,1)               as cd_previsao_venda,
      pvi.cd_produto,
      @cd_fase_produto                as cd_fase_produto,
      pvi.qt_item_pedido_venda        as qt_produto_previsao_venda,
      c.cd_pais
    into
      #Aux_Previsao2

    from
      Pedido_Venda_Item pvi
      left join Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
      left join Cliente c on c.cd_cliente = pv.cd_cliente
    where
      pv.dt_pedido_venda between @dt_inicial_anterior and @dt_final_anterior and  --Período
      pv.dt_cancelamento_pedido is null                    and  --Pedido de Venda Cancelado não Entrada
      pvi.dt_cancelamento_item is null                     and  --Item do Pedido não pode estar Cancelado
      isnull(pvi.cd_produto,0)>0                           and
      isnull(c.cd_pais,0)      = case when isnull(@cd_pais,0)=0     then isnull(c.cd_pais,0)      else @cd_pais    end and
      isnull(pvi.cd_produto,0) = case when isnull(@cd_produto,0 )=0 then isnull(pvi.cd_produto,0) else @cd_produto end

      --Mostra a Tabela Temporária Gerada
      --select * from #Previsao
      --Mostra a Tabela Agrupada

    select distinct
      @cd_previsao_venda + max(p.cd_previsao_venda) AS cd_previsao_venda,
      p.cd_pais,
      p.cd_produto,
      sum(p.qt_produto_previsao_venda) as qt_produto_previsao_venda
    into #Previsao2
    from #Aux_Previsao2 p
    group by
      p.cd_pais,
      p.cd_produto
    order by
      p.cd_pais,
      p.cd_produto

    --Gravação da Tabela Temporária

    insert 
      Previsao_Venda (
        cd_previsao_venda,
        dt_inicio_previsao_venda,
        dt_final_previsao_venda,
        cd_produto,
        cd_pais,
        cd_fase_produto,
        qt_produto_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @dt_inicial,
      @dt_final,
      cd_produto,
      cd_pais,
      @cd_fase_produto,
      qt_produto_previsao_venda,
      @cd_usuario,
      getdate()
    from #Previsao2
 
    -- Inserindo Composicao

    insert 
      Previsao_Venda_Composicao (
        cd_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @cd_usuario,
      getdate()
    from 
      #Previsao2

  -----------------------------------------------------------------------
  end -- Fim do Paramento P
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  if @cd_tipo_previsao = 'PC' -- Geração automatica Pais Cliente
  -----------------------------------------------------------------------
  begin

    select
      identity(int,1,1)               as cd_previsao_venda,
      pv.cd_cliente,
      pvi.cd_produto,
      @cd_fase_produto                as cd_fase_produto,
      pvi.qt_item_pedido_venda        as qt_produto_previsao_venda,
      c.cd_pais
    into
      #Aux_Previsao3

    from
      Pedido_Venda_Item pvi
      left join Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
      left join Cliente c on c.cd_cliente = pv.cd_cliente
    where
      pv.dt_pedido_venda between @dt_inicial_anterior and @dt_final_anterior and  --Período
      pv.dt_cancelamento_pedido is null                    and  --Pedido de Venda Cancelado não Entrada
      pvi.dt_cancelamento_item is null                     and  --Item do Pedido não pode estar Cancelado
      isnull(pvi.cd_produto,0)>0                           and
      isnull(c.cd_pais,0)      = case when isnull(@cd_pais,0)=0     then isnull(c.cd_pais,0)      else @cd_pais    end and
      isnull(pv.cd_cliente,0)  = case when isnull(@cd_cliente,0 )=0 then isnull(pv.cd_cliente,0)  else @cd_cliente end and
      isnull(pvi.cd_produto,0) = case when isnull(@cd_produto,0 )=0 then isnull(pvi.cd_produto,0) else @cd_produto end

      --Mostra a Tabela Temporária Gerada
      --select * from #Previsao
      --Mostra a Tabela Agrupada

    select distinct
      @cd_previsao_venda + max(p.cd_previsao_venda) AS cd_previsao_venda,
      p.cd_pais,
      p.cd_cliente,
      p.cd_produto,
      sum(p.qt_produto_previsao_venda) as qt_produto_previsao_venda
    into #Previsao3
    from #Aux_Previsao3 p
    group by
      p.cd_pais,
      p.cd_cliente,
      p.cd_produto
    order by
      p.cd_pais,
      p.cd_produto

    --Gravação da Tabela Temporária

    insert 
      Previsao_Venda (
        cd_previsao_venda,
        dt_inicio_previsao_venda,
        dt_final_previsao_venda,
        cd_cliente,
        cd_produto,
        cd_pais,
        cd_fase_produto,
        qt_produto_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @dt_inicial,
      @dt_final,
      cd_cliente,
      cd_produto,
      cd_pais,
      @cd_fase_produto,
      qt_produto_previsao_venda,
      @cd_usuario,
      getdate()
    from #Previsao3
 
    -- Inserindo Composicao

    insert 
      Previsao_Venda_Composicao (
        cd_previsao_venda,
        cd_usuario,
        dt_usuario
      )
    select 
      cd_previsao_venda,
      @cd_usuario,
      getdate()
    from 
      #Previsao3

  -----------------------------------------------------------------------
  end -- Fim do Paramento PC
  -----------------------------------------------------------------------

  --Atualização da Data da Ultima Compra do Cliente
  update
    Previsao_Venda 
  set
    dt_ultima_compra_cliente = ( select max(pv.dt_pedido_venda) from pedido_venda pv, Pedido_venda_Item pvi
                                 where p.cd_cliente = pv.cd_cliente AND
                                       pv.cd_pedido_venda = pvi.cd_pedido_venda and 
                                       p.cd_produto = pvi.cd_produto and
                                       pv.dt_cancelamento_pedido is null )         
   from
     Previsao_venda p

  -- inserindo o grupo de produto

  update
    Previsao_Venda 
  set
    cd_grupo_produto = ( select pr.cd_grupo_produto from produto pr
                         where p.cd_produto = pr.cd_produto)         
  from
    Previsao_venda p

  -- inserindo categoria produto
  update
    Previsao_Venda 
  set
    cd_categoria_produto = ( select pr.cd_categoria_produto from produto pr
                             where p.cd_produto = pr.cd_produto)         
  from
    Previsao_venda p

-- Inserindo a quantidade anterior
-- select
--   identity(int,1,1)        as cd_previsao_venda,
--   pv.cd_vendedor,
--   pv.cd_cliente,
--   pvi.cd_produto,
--   pvi.cd_categoria_produto,
--   pvi.cd_grupo_produto,
--   @cd_fase_produto                as cd_fase_produto, 
--   pvi.qt_item_pedido_venda        as qt_anterior_previsao
-- --   0                               as vl_produto_previsao_venda,
-- --   ' '                             as nm_obs_previsao_venda, 
-- --   0                               as qt_hora_previsao_venda,
-- --   0                               as qt_servico_previsao_venda,
-- --   'N'                             as ic_plano_mestre,
-- --   'N'                             as ic_plano_simulacao,
-- --   1                               as cd_usuario,
-- --   0                               as cd_servico
-- 
-- into #Aux_Previsao2
-- 
-- from
--   Pedido_Venda      pv,
--   Pedido_Venda_Item pvi
-- 
-- where
--   pv.dt_pedido_venda between @dt_inicial_anterior and @dt_final_anterior and  --Período
--   pv.dt_cancelamento_pedido is null                    and  --Pedido de Venda Cancelado não Entrada   
--   pv.cd_pedido_venda = pvi.cd_pedido_venda             and  --Item do Pedido
--  pvi.dt_cancelamento_item is null                      and  --Item do Pedido não pode estar Cancelado 
--  isnull(pvi.cd_produto,0)>0                            and
--  isnull(pv.cd_vendedor,0)>0
--  
-- --Mostra a Tabela Temporária Gerada
-- 
-- --select * from #Previsao
-- 
-- --Mostra a Tabela Agrupada
-- 
-- select  
-- distinct
--   max(p.cd_previsao_venda) as cd_previsao_venda,
--   p.cd_vendedor,
--   p.cd_cliente,
--   p.cd_produto,
--   sum(p.qt_anterior_previsao) as qt_anterior_previsao
-- into #Previsao2
-- from #Aux_Previsao2 p
-- 
-- group by
--   p.cd_vendedor,
--   p.cd_cliente,
--   p.cd_produto
-- 
-- order by
--   p.cd_vendedor,
--   p.cd_cliente,
--   p.cd_produto
-- 
-- 
-- --Gravação da Tabela Temporária
-- 
-- UPDATE 
--   Previsao_Venda 
-- SET
-- qt_anterior_previsao = p2.qt_anterior_previsao
-- 
-- FROM
-- Previsao_Venda pv,
-- #Previsao2 p2
-- WHERE
-- pv.cd_previsao_venda = p2.cd_previsao_venda
----------------------------------------------------------------------
end -- Fim do parametro <> 9
----------------------------------------------------------------------
 
----------------------------------------------------------------------
if @ic_parametro = 9 -- Zerar Tabelas
----------------------------------------------------------------------
begin
  if @cd_tipo_previsao = 'VC'
  begin
    delete from previsao_venda_composicao where cd_previsao_venda in ( select cd_previsao_venda from Previsao_Venda where isnull(cd_vendedor,0) > 0 )
    delete from previsao_venda where isnull(cd_vendedor,0) > 0
  end

  if @cd_tipo_previsao = 'P'
  begin
    delete from previsao_venda_composicao where cd_previsao_venda in ( select cd_previsao_venda from Previsao_Venda where isnull(cd_pais,0) > 0 and isnull(cd_cliente,0) = 0 and isnull(cd_vendedor,0)=0 )
    delete from previsao_venda where isnull(cd_pais,0) > 0 and isnull(cd_cliente,0) = 0 and isnull(cd_vendedor,0)=0
  end

  if @cd_tipo_previsao = 'PC'
  begin
    delete from previsao_venda_composicao where cd_previsao_venda in ( select cd_previsao_venda from Previsao_Venda where isnull(cd_pais,0) > 0 and isnull(cd_cliente,0) > 0 and isnull(cd_vendedor,0)=0 )
    delete from previsao_venda where isnull(cd_pais,0) > 0 and isnull(cd_cliente,0) > 0 and isnull(cd_vendedor,0)=0
  end
----------------------------------------------------------------------
end -- FIM DO PARAMETRO 9
----------------------------------------------------------------------
