

-------------------------------------------------------------------------------
--sp_helptext pr_geracao_alocacao_disponibilidade
-------------------------------------------------------------------------------
--pr_geracao_alocacao_disponibilidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Alocação de Disponibilidade do Produto
--Data             : 06.11.2008
--Alteração        : 
----------------------------------------------------------------------------------------
--
-- 20.02.2009 - Ajuste e Acerto na Rotina - Carlos Fernandes
-- 11.03.2009 - Complementos com funcionalidades - Carlos Fernandes
-- 16.03.2009 - Ajuste da Alocação para considerar do Estoque apenas se não tiver
--              compras ( PI + PC + OP ) - Carlos Fernandes
-- 18.03.2009 - Ajuste de produtos sem previsão de Entrada - Carlos Fernandes
-- 21.03.2009 - Performance        - Carlos Fernandes
-- 07.04.2009 - Ajuste no processo - Carlos Fernandes
-- 08.04.2009 - Acertos para Alocação - Carlos Fernandes
-- 17.04.2009 - Atualização Automática da quantidade Alocada - Carlos Fernandes
-- 27.04.2009 - Ajuste na Rotina, porque não está alocando - Carlos Fernandes
-- 29.04.2009 - Chamada da Recomposição de Saldos - Carlos Fernandes
-- 05.05.2009 - Ajustes na Rotina - Carlos Fernandes
-- 06.05.2009 - Novos Ajustes - Carlos Fernandes
-- 07.05.2009 - Revisão - Carlos Fernandes
-- 08.05.2009 - Ajuste no flag da Alocação - Carlos Fernandes
-- 12.05.2009 - Criação de um flag para alocação do Pedido de Venda - Carlos Fernandes
-- 21.05.2009 - Comandos de Transação - 
-- 29.06.2009 - Ajuste quando é exclusão do Pedido - Carlos Fernandes
-- 30.09.2009 - Análise de Performance - Carlos Fernandes
-- 02.10.2009 - Verificação Limpa Código - Carlos Fernandes
-- 04.10.2009 - checagem de unificação de Tabelas - Carlos Fernandes
----------------------------------------------------------------------------------------
create procedure pr_geracao_alocacao_disponibilidade
@ic_parametro       int      = 0,
@cd_produto         int      = 0,
@cd_usuario         int      = 0,
@dt_inicial         datetime = null,
@dt_final           datetime = null,
@ic_alocacao_pedido char(1)  = 'N',
@ic_deleta_alocacao char(1)  = 'S'

as

set @ic_deleta_alocacao = 'S'

--Criar Índices Manualmente em um novo Cliente

-- DROP INDEX ATENDIMENTO_PEDIDO_VENDA.IX_Atendimento_Pedido_Venda_Produto
-- DROP INDEX ESTOQUE_PEDIDO_VENDA.IX_Estoque_Pedido_Venda_Produto

-- CREATE INDEX IX_Atendimento_Pedido_Venda_Produto
--    ON Atendimento_Pedido_Venda (cd_produto)

-- CREATE INDEX IX_Estoque_Pedido_Venda_Produto
--    ON Estoque_Pedido_Venda (cd_produto)


-- CREATE INDEX IX_IX_Atendimento_Pedido_Venda_Documento
--    ON Atendimento_Pedido_Venda (cd_documento,cd_item_documento)


--select * from atendimento_pedido_venda


  ------------------------------------------------------------------------------
  --Executa a Recomposição de Saldos
  ------------------------------------------------------------------------------
  --select * from fechamento_mensal

--   if @dt_inicial is not null
--   begin
-- 
--     set @dt_fechamento = @dt_inicial - 1
-- 
--     exec dbo.pr_recomposicao_saldo 
--       5,              --Parâmetro
--       @dt_fechamento, --Data do Fechamento
--       @dt_inicial,    --Data Inicial,
--       @dt_final,      --Data Final
--       @cd_produto,    -- Produto
--       0,
--       0,
--       @cd_fase_produto
-- 
--   end

--   exec dbo.pr_recomposicao_saldo 
--      @ic_parametro = 5, 
--      @dt_fechamento = 'mar 31 2009 12:00:00:000AM',
--      @dt_inicial = 'abr  1 2009 12:00:00:000AM',
--      @dt_final = 'abr 30 2009 12:00:00:000AM',
--      @cd_produto = 263, 
--      @cd_grupo_produto = 0, 
--      @cd_serie_produto = 0, 
--      @cd_fase_produto = 1

------------------------------------------------------------------------------
--Deleta a Alocação Atendimento em PI/OP/PCAnterior
------------------------------------------------------------------------------

if @ic_deleta_alocacao = 'S'
begin

  delete from atendimento_pedido_venda --with (tablock)
  where
    cd_produto = @cd_produto

  delete from estoque_pedido_venda --with (tablock)
  where
    cd_produto = @cd_produto

end

------------------------------------------------------------------------------
--Deleta a Alocação de Estoque
------------------------------------------------------------------------------

-- delete from estoque_pedido_venda --with (tablock)
-- where
--  cd_produto = @cd_produto

-------------------------------------------------------------------------------------------------------
-- delete from egisadmin.dbo.codigo where nm_tabela = 'EgisSql.dbo.Atendimento_Pedido_Venda' 
-- delete from egisadmin.dbo.codigo where nm_tabela = 'EgisSql.dbo.Estoque_Pedido_Venda' 
-------------------------------------------------------------------------------------------------------

--select * from config_alocacao

  declare @cd_fase_produto         int
  declare @cd_controle             int
  declare @qt_saldo                float
  declare @qt_movimento            float 
  declare @qt_total_movimento      float
  declare @ic_utilizar             char(1)
  declare @dt_hoje                 datetime
  declare @cd_estoque_pedido       int
  declare @Tabela                  varchar(80)
  declare @cd_pedido_venda         int
  declare @cd_item_pedido_venda    int
  declare @ic_alocacao             char(1)
  declare @qt_dia_alocacao_estoque int 
  declare @nm_usuario_logado       varchar(100)
  declare @cSQL                    varchar(8000)
  

set @dt_hoje           = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
set @cd_estoque_pedido = 0

  --Define o usuário logado
  Select @nm_usuario_logado = RTrim(LTrim(USER_NAME()))

--Alocação de Pedidos Somente Fechados

if @ic_alocacao_pedido is null
begin
  set @ic_alocacao_pedido = 'N'
end

--Fase do Parâmetro Comercial

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------------------
--parâmetro de Dias de Alocação
-------------------------------------------------------------------------------------------

select
  @qt_dia_alocacao_estoque = isnull(qt_dia_alocacao_estoque,1) --1 Dia
from
  Config_Alocacao with (nolock)
where
  cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------------------

--select * from produto_saldo
--select * from vw_reserva_produto_estoque


------------------------------------------------------------------------------
--Reservas Geral do Movimento de Estoque
------------------------------------------------------------------------------
--select * from estoque_pedido_venda

  --------------------------------------------------
  -- Apagar a tabela de Alocação
  ---------------------------------------------------

  if exists(Select * from sysobjects
            where name = 'GERACAO_ALOCACAO' and
                  xtype = 'U' AND
                  uid = USER_ID(@nm_usuario_logado))
  begin
    set @cSQL = ' DROP TABLE ' + @nm_usuario_logado + '.' + 'GERACAO_ALOCACAO'
    exec(@cSQL)
  end


--Montagem da Tabela 

select

  identity(int,1,1)                        as cd_controle,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  um.sg_unidade_medida,
  isnull(ps.qt_saldo_reserva_produto,0)    as Disponivel,
  isnull(ps.qt_saldo_atual_produto,0)      

--   - 
--   isnull( (select sum(epv.qt_estoque)
--                         from
--                           estoque_pedido_venda epv
--                         where
--                            epv.cd_produto           = p.cd_produto and
--                            epv.cd_pedido_venda      = pv.cd_pedido_venda and
--                            epv.cd_item_pedido_venda = pvi.cd_item_pedido_venda),0)

                                           as Atual,
  
  c.nm_fantasia_cliente                    as Cliente, 
  pvi.dt_entrega_vendas_pedido             as Entrega,
--   pv.cd_pedido_venda,
--   pvi.cd_item_pedido_venda,
  pv.cd_pedido_venda                       as Pedido,
  pv.dt_pedido_venda,
  pvi.cd_item_pedido_venda                 as Item,
  --pvi.qt_saldo_pedido_venda                as Quantidade,

  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
    pvi.qt_saldo_pedido_venda
  else
   pvi.qt_item_pedido_venda
  end                                      as 'Quantidade',

  'N'                                      as Estoque,
  cast(0.00 as float)                      as QtdEstoque,
--  cast(pvi.qt_saldo_pedido_venda as float) as Saldo,
  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
    pvi.qt_saldo_pedido_venda
  else
   pvi.qt_item_pedido_venda
  end                                      as 'Saldo',

  vwp.forma,
  vwp.Documento,
  vwp.ItemDocumento,
  vwp.Destino,
  vwp.DataPrevisao,
  cast(pvi.dt_entrega_vendas_pedido-isnull(vwp.DataPrevisao,getdate()) as int ) as Dias,
  Entrada = ( select top 1 'S' from vw_previsao_entrada vwe
              where
                vwe.CodigoProduto = p.cd_produto
              order by
                DataPrevisao),
  'N'                                   as Atendimento,

  cast(0.00 as float)                   as QtdAtendimento,

  ----Utilizar do Pedido de Importação + Pedido de Compra + OP

  --select * from fase_produto
  --select * from produto_saldo

  ---------------------------------------------------------------------------------------------
  --Rotina de Alocação Estoque ou Pedido Importação ou Pedido de Compra ou Ordem de Produção
  ---------------------------------------------------------------------------------------------
  --Verifica se Tem Saldo de Estoque

  --Verifica se o Item deve ser Pego do Estoque
  

  case when isnull(ps.qt_saldo_atual_produto,0)<=0 
  then
    'N'
  else

     case when ( 
      select
        top 1 DataPrevisao 
      from
        vw_previsao_entrada_atendimento with (nolock) 
      where
        CodigoProduto =  p.cd_produto 
      order by
        DataPrevisao  ) is null and isnull(ps.qt_saldo_atual_produto,0)>0 
      then 
        'S'
      else

        --Verifica se tem Previsão----------------------------------------------------------------
        --select * from vw_previsao_entrada_atendimento

        case when pvi.dt_entrega_vendas_pedido >=
        isnull(
        ( 
         select
           top 1 DataPrevisao 
         from
           vw_previsao_entrada_atendimento with (nolock) 
         where
           CodigoProduto =  p.cd_produto
         order by
           DataPrevisao ),@dt_hoje) 
        then
          'N'   
        else
          'S'
       end

     end
 
  end                                                     as Utilizar,

  'N'                                                     as Alocacao,

  --Verifica a Data de Entrega

--   case when isnull(pvi.dt_entrega_vendas_pedido,@dt_hoje)<
--   isnull((
--     select
--      top 1 DataPrevisao 
--      from
--        vw_previsao_entrada_atendimento with (nolock) 
--      where
--        CodigoProduto =  p.cd_produto 
--        --and DataPrevisao  >= vw.dt_entrega_vendas_pedido 
--     order by
--       DataPrevisao  ),@dt_hoje) and isnull(ps.qt_saldo_atual_produto,0)>0
--   
--   then 'S'        --Utilizar
--   else
--    case when 
--         --17.04.2009
--         (isnull(ps.qt_saldo_atual_produto,0)>0 and
-- 
--         --Cálculo do Disponível
-- 
--         --Saldo Atual
--         (isnull(ps.qt_saldo_atual_produto,0) -
-- 
--         --Movimento de Estoque Reservado 
-- 
--         isnull( (select sum(vw.qt_movimento_estoque)
--         from 
--           vw_reserva_produto_estoque vw
--         where
--            vw.cd_produto = p.cd_produto     and
--            vw.dt_cancelamento_item is null  and
--            vw.cd_documento_movimento not in
--              ( select top 1 cd_pedido_venda 
--                from
--                  Atendimento_Pedido_Venda with (nolock) 
--                where
--                   cd_pedido_venda      = pvi.cd_pedido_venda and
--                   cd_item_pedido_venda = pvi.cd_item_pedido_venda )
--               ),0 ) )>0                              and
-- 
-- 
--              vwp.DataPrevisao is null                and 
--              isnull(ps.qt_importacao_produto,0)=0    and --importação
--              isnull(ps.qt_pd_compra_produto,0) =0 )
-- 
--                --compra no mercado interno
--    then
--      'S'
--    else 
--      'N'
--    end
-- 
---------------------------------------------------------------------------------------
--Alterado - Carlos 27.04.2009
---------------------------------------------------------------------------------------
--
--      case when (isnull(ps.qt_saldo_atual_produto,0)>0 and isnull(
--              ( select top 1 cd_pedido_venda 
--                from
--                  Atendimento_Pedido_Venda with (nolock) 
--                where
--                   cd_pedido_venda      = pvi.cd_pedido_venda and
--                   cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0)=0) then 'S'
--      else          
--     'N' 
--     end
--   end

--  end                     as Utilizar,

  pv.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  pvi.dt_cancelamento_item

  --Estoque---------------------------------------------------------------------
--   cd_estoque_pedido = isnull((
--                         select top 1 cd_estoque_pedido
--                         from
--                           estoque_pedido_venda epv with (nolock) 
--                         where
--                            epv.cd_produto           = p.cd_produto and
--                            epv.cd_pedido_venda      = pv.cd_pedido_venda and
--                            epv.cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0),



  --Atendimento------------------------------------------------------------------
--   cd_atendimento_pedido = isnull(( select top 1 cd_atendimento_pedido
--                             from
--                               atendimento_pedido_venda apv with (nolock) 
--                             where
--                               apv.cd_produto           = p.cd_produto and
--                               apv.cd_pedido_venda      = pv.cd_pedido_venda and
--                               apv.cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0)

--select * from atendimento_pedido_venda

--  vw.dt_entrega_vendas_pedido           as DataEntrega
  
into
  #Reserva
  --GERACAO_ALOCACAO

from
  Produto p                         with (nolock) 
  left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  inner join fase_produto fp        with (nolock) on fp.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                          then
                                                                            p.cd_fase_produto_baixa 
                                                                          else 
                                                                            @cd_fase_produto
                                                                          end

  left outer join produto_saldo ps                with (nolock) on ps.cd_produto      = p.cd_produto and
                                                                   ps.cd_fase_produto = fp.cd_fase_produto
  --Reserva
  --inner join vw_reserva_geral_produto_estoque vw  with (nolock) on vw.cd_produto = p.cd_produto

  inner join pedido_venda_item pvi                with (nolock) on pvi.cd_produto         = p.cd_produto
 
  inner join pedido_venda      pv                 with (nolock) on pv.cd_pedido_venda     = pvi.cd_pedido_venda  


  left outer join Tipo_Pedido tp                  with (nolock) on tp.cd_tipo_pedido      = pv.cd_tipo_pedido
  left outer join Cliente c                       with (nolock) on c.cd_cliente           = pv.cd_cliente
  left outer join vendedor ve                     with (nolock) on ve.cd_vendedor         = pv.cd_vendedor
  left outer join vendedor vi                     with (nolock) on vi.cd_vendedor         = pv.cd_vendedor_interno


  --Previsao de Entrada
  left outer join vw_previsao_entrega_produto vwp with (nolock) on vwp.CodigoProduto       = p.cd_produto              and  
                                                                   vwp.PedidoVenda         = pv.cd_pedido_venda        and
                                                                   vwp.ItemPedidoVenda     = pvi.cd_item_pedido_venda
                                                                  
  LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi        on nsi.cd_pedido_venda        = pvi.cd_pedido_venda      and
                                                                nsi.cd_item_pedido_venda   = pvi.cd_item_pedido_venda

where

  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end and

  --Pedido Fechado----------------------------------------------------------------------------------------
  --22.07.2009
  isnull(pv.ic_fechado_pedido,'N') = 'S' 
  and
--   isnull(pv.ic_fechado_pedido,'N') = case when @ic_alocacao_pedido = 'S' 
--                                           then isnull(pv.ic_fechado_pedido,'N')                                        
--                                           else
--                                            'S'
--                                           end            and  --Pedido Fechado
  --isnull(pvi.qt_saldo_pedido_venda,0)>0                  and  --Pedido com Saldo 

  (isnull(pvi.qt_saldo_pedido_venda,0)>0                                          
   or  
   (isnull(pvi.qt_saldo_pedido_venda,0)=0 and nsi.cd_status_nota=1)                    --Notas em Aberto 
  ) 

  and

  pvi.dt_cancelamento_item is null                            --Pedido não pode estar cancelado
  --Verifica se o Pedido de Venda ( Permite Alocação )
  and isnull(tp.ic_alocacao_tipo_pedido,'S')='S'

order by
  pvi.dt_entrega_vendas_pedido,
  pv.dt_pedido_venda 


--Criação de um índice

  --Create Index IX_Geracao_Alocacao on GERACAO_ALOCACAO (cd_controle)
  Create Index IX_Geracao_Alocacao on #Reserva (cd_controle)

--select ic_fechado_pedido,* from pedido_venda where cd_pedido_venda = 650495

------------------------------------------------------------------------------
--Deleta os pedidos de Venda Cancelado
------------------------------------------------------------------------------
-- delete from #Reserva
-- where
--   dt_cancelamento_item is not null   

------------------------------------------------------------------------------
--Atualiza a Tabela de Reserva com os Dados da Manutenção
------------------------------------------------------------------------------

--select * from #Reserva

update
  --GERACAO_ALOCACAO
  #Reserva
set
  Utilizar = case when isnull(mpv.ic_estoque,'N')  = 'S' then 'S' else Utilizar end,
  Alocacao = case when isnull(mpv.ic_alocacao,'N') = 'S' then 'S' else 'N'      end
from
  #Reserva r
  --GERACAO_ALOCACAO r
  inner join Manutencao_Pedido_Venda mpv on mpv.cd_pedido_venda      = r.cd_pedido_venda      and
                                            mpv.cd_item_pedido_venda = r.cd_item_pedido_venda and
                                            mpv.cd_produto           = r.cd_produto



--select * from #Reserva

------------------------------------------------------------------------------
--Monta a Tabela Auxiliar
------------------------------------------------------------------------------

select
  *
into
  #Aux_Reserva

from
  #Reserva
  --GERACAO_ALOCACAO

where
  forma is null       and
  isnull(Saldo,0) > 0 

--   cd_estoque_pedido     = case when @ic_deleta_alocacao = 'N' then 0 else cd_estoque_pedido     end and
--   cd_atendimento_pedido = case when @ic_deleta_alocacao = 'N' then 0 else cd_atendimento_pedido end 

  --Criando um Índice

  Create Index IX_Aux_Reserva on #Aux_Reserva (cd_controle)

--select * from #Aux_Reserva

--Begin Transaction

--  SET LOCK_TIMEOUT 25000

---------------------------------------------------------------------------------------
--Atualiza a Quantidades de Estoque
---------------------------------------------------------------------------------------

set @Tabela = cast(DB_NAME()+'.dbo.Estoque_Pedido_Venda' as varchar(80))

set @qt_saldo           = 0
set @qt_movimento       = 0
set @qt_total_movimento = 0
set @ic_utilizar        = 'N'

while exists( select top 1 cd_controle from #Aux_Reserva )
begin

  select top 1
     @cd_controle          = cd_controle,
     @qt_movimento         = Quantidade,
     @qt_saldo             = (Atual-@qt_total_movimento),
     @qt_total_movimento   = @qt_total_movimento + Quantidade,
     @ic_utilizar          = Utilizar,
     @cd_pedido_venda      = Pedido,
     @cd_item_pedido_venda = Item,
     @ic_alocacao          = Alocacao
      
  from
    #Aux_Reserva
   
  order by
    Entrega,
    dt_pedido_venda,
    cd_pedido_venda,
    cd_item_pedido_venda

  --Atualiza o Item com Estoque = 'SIM'

  --select @qt_saldo,@qt_total_movimento,@qt_movimento
 
  if @qt_saldo>0 and @ic_utilizar = 'S' 
  begin

--    select @qt_saldo,@qt_total_movimento,@qt_movimento

    if @qt_movimento>@qt_saldo
    begin
       set @qt_movimento = @qt_saldo    
    end

    update
      #Reserva
      --GERACAO_ALOCACAO
    set
      Estoque    = case when @ic_alocacao = 'N' then 'S'           else 'N' end,
      QtdEstoque = case when @ic_alocacao = 'N' then @qt_movimento else 0   end,
      Saldo      = Quantidade - ( case when @ic_alocacao =  'N' then @qt_movimento else 0 end ) ,
      Dias       = 0,
      Entrada    = 'N'
    where
      cd_controle = @cd_controle

    if @ic_alocacao = 'N'
    begin
      --select * from estoque_pedido_venda
--       if not exists 
--          (
--           select top 1 epv.cd_estoque_pedido 
--           from
--              estoque_pedido_venda epv
--           where
-- --            epv.cd_estoque_pedido    = @cd_estoque_pedido    and
--             epv.cd_pedido_venda      = @cd_pedido_venda      and
--             epv.cd_item_pedido_venda = @cd_item_pedido_venda and
--             epv.qt_estoque           = @qt_movimento         and
--             epv.cd_produto           = @cd_produto
-- 
--          )
--       begin


        ---------------------------------------------------------------------------
        --Atualização da Tabela de Controle de Itens do Estoque
        --------------------------------------------------------------------------- 
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_estoque_pedido', @codigo = @cd_estoque_pedido output
	
        while exists(Select top 1 'x' from Estoque_Pedido_Venda  with (nolock) 
                     where cd_estoque_pedido = @cd_estoque_pedido )
        begin
          exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_estoque_pedido', @codigo = @cd_estoque_pedido output
          -- limpeza da tabela de código
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_estoque_pedido, 'D'
        end

        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_estoque_pedido, 'D'
     
        insert into estoque_pedido_venda
        select
          @cd_estoque_pedido,
          @cd_pedido_venda,
          @cd_item_pedido_venda,
          @qt_movimento,
          @cd_produto,
          getdate(),
          @cd_usuario,
          getdate()
        where
          @qt_movimento>0

--       end
--     else
--        begin
--           update
--              estoque_pedido_venda 
--           set
--             qt_estoque = @qt_movimento    
--           from
--             estoque_pedido_venda epv
--           where
--             epv.cd_estoque_pedido    = @cd_estoque_pedido    and
--             epv.cd_pedido_venda      = @cd_pedido_venda      and
--             epv.cd_item_pedido_venda = @cd_item_pedido_venda and
--             epv.qt_estoque           = @qt_movimento         and
--             epv.cd_produto           = @cd_produto
--        end

        --Atualização com a Data de Vendas

        update
          pedido_venda_item
        set
          dt_reprog_item_pedido = dt_entrega_vendas_pedido,
          qt_estoque            = @qt_movimento,
          dt_estoque            = getdate()

        where
          cd_pedido_venda       = @cd_pedido_venda      and
          cd_item_pedido_venda  = @cd_item_pedido_venda       

     end

  end  

  delete from #Aux_Reserva 
  where
    cd_controle = @cd_controle

  
end

--------------------------------------------------------------------------------------------
--Mostra a Tabela
--------------------------------------------------------------------------------------------

--   select
--     *
--   from
--     #Reserva
--   where
--     Saldo>0
--   order by
--     Entrega


--select * from #Reserva

------------------------------------------------------------------------------
--Atendimento / Alocação
------------------------------------------------------------------------------

  select
    *
  into 
    #Atendimento
  from
    #Reserva
    --GERACAO_ALOCACAO

  where
    Saldo>0 --and Utilizar = 'N'

    --Somente os Pedidos não atendidos
--     cd_atendimento_pedido = case when @ic_deleta_alocacao = 'N' then 0 else cd_atendimento_pedido end and 
--     cd_estoque_pedido     = case when @ic_deleta_alocacao = 'N' then 0 else cd_estoque_pedido     end and

  order by
    Entrega,
    dt_pedido_venda


  --Criando um Índice

  Create Index IX_Atendimento_Alocacao on #Atendimento (cd_controle)

  --select * from #Atendimento
  
  declare @cd_atendimento_pedido     int
  declare @qt_atendimento            float
  declare @dt_atendimento            datetime
  declare @nm_forma                  varchar(10)
  declare @cd_documento              int
  declare @cd_item_documento         int
  declare @dt_entrega                datetime
  declare @qt_saldo_atual_produto    float
  declare @qtdAtendimento            int

  set @Tabela = cast(DB_NAME()+'.dbo.Atendimento_Pedido_Venda' as varchar(80))

  set @qt_saldo               = 0
  set @qt_total_movimento     = 0
  set @qt_saldo_atual_produto = 0
  set @qtdAtendimento         = 0

  declare @i int
  set @i = 0

  --select * from #Atendimento
  --select * from estoque_pedido_venda
  --select * from atendimento_pedido_venda where cd_produto = 81

  while exists( select top 1 cd_controle from #Atendimento )
  begin

    select top 1
       @cd_controle            = a.cd_controle,
       @qt_saldo               = a.Saldo,         --Saldo do Pedido de Venda
       @cd_pedido_venda        = a.Pedido,
       @cd_item_pedido_venda   = a.Item,
       @dt_entrega             = isnull(a.Entrega,@dt_hoje),
       @ic_alocacao            = Alocacao,
       @qt_saldo_atual_produto = isnull(ps.qt_saldo_atual_produto,0) 
                                 - 
                                 isnull(( select sum(epv.qt_estoque)
                                   from
                                     estoque_pedido_venda epv with (nolock) 
                                   where 
                                     epv.cd_produto = a.cd_produto ),0)
                                    
                                 
      
    from
      #Atendimento a
      left outer join produto p        with (nolock) on p.cd_produto       = a.cd_produto
      left outer join produto_saldo ps with (nolock) on ps.cd_produto      = a.cd_produto and
                                                        ps.cd_fase_produto = --isnull(p.cd_fase_produto_baixa,0)
                                                                             case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                             then
                                                                               p.cd_fase_produto_baixa 
                                                                             else 
                                                                               @cd_fase_produto
                                                                             end    
    order by
      Entrega,
--      Pedido
    dt_pedido_venda,
    cd_pedido_venda,
    cd_item_pedido_venda
       
    --select @qt_saldo_atual_produto

--    select @cd_pedido_venda,@cd_item_pedido_venda,@cd_produto,@dt_entrega,@qt_saldo
 
--    select @qt_saldo

    --Definir quais Pedidos de Compra/Pedidos de Importação/Ordem de Produção pode atender

    --select * from atendimento_pedido_venda
    --select * from vw_previsao_entrada

    set @qt_movimento       = 0
    set @i                  = 0

    while @i=0 
    begin
 
      --select @qt_saldo,@qt_movimento

      set @qt_atendimento = 0
    
      select
        top 1
        @qt_atendimento    = isnull(vwe.Quantidade,0)

                             -
                             --Quantidade já alocada em outras pedidos vendas                           
                             isnull((select sum( isnull(qt_atendimento,0))
                              from atendimento_pedido_venda a with (nolock) 
                              where                              
                                a.cd_documento         = vwe.documento     and
                                a.cd_item_documento    = vwe.ItemDocumento and
                                a.cd_produto           = vwe.CodigoProduto 
                                
                              group by
                                a.cd_documento, a.cd_item_documento ),0),
         
        @dt_atendimento         = vwe.DataPrevisao,
        @nm_forma               = vwe.Forma,
        @cd_documento           = vwe.Documento,
        @cd_item_documento      = vwe.ItemDocumento,
        @qt_saldo_atual_produto = isnull(ps.qt_saldo_atual_produto,@qt_saldo_atual_produto)
                                  - 
                                 isnull(( select sum(epv.qt_estoque)
                                   from
                                     estoque_pedido_venda epv with (nolock) 
                                   where 
                                     epv.cd_produto = p.cd_produto ),0)



        --select * from vw_previsao_entrada 

      from
        vw_previsao_entrada vwe          with (nolock) 
        left outer join produto p        with (nolock) on p.cd_produto       = vwe.codigoProduto
        left outer join produto_saldo ps with (nolock) on ps.cd_produto      = p.cd_produto and
                                                          ps.cd_fase_produto = --isnull(p.cd_fase_produto_baixa,0)
                                                                               case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                               then
                                                                                 p.cd_fase_produto_baixa 
                                                                               else 
                                                                                 @cd_fase_produto
                                                                               end

      where
        vwe.CodigoProduto = @cd_produto        and
        (vwe.Quantidade   
                             -
                             --Quantidade já alocada em outras pedidos vendas                           
                             isnull((select sum( isnull(qt_atendimento,0))
                              from atendimento_pedido_venda a with (nolock) 
                              where                              
                                a.cd_documento         = vwe.documento     and
                                a.cd_item_documento    = vwe.ItemDocumento and
                                a.cd_produto           = vwe.CodigoProduto 
                              group by
                                a.cd_documento, a.cd_item_documento ),0)

         ) > 0                  and

        --Data de Entrega
        @dt_entrega >= vwe.DataPrevisao      
        
      order by
        vwe.CodigoProduto,
        --vwe.DataPrevisao 
        vwe.DataPrevisao desc

      --select @qt_atendimento

      --select * from vw_previsao_entrada
    
      --Mostra os registros do cálculo do alocação

--        select
--         top 1
--         vwe.*,
--         
-- 
--                              
--                              --Quantidade já alocada em outras pedidos vendas                           
--                              isnull((select sum( isnull(qt_atendimento,0))
--                               from atendimento_pedido_venda a 
--                               where                              
--                                 a.cd_documento      = vwe.documento     and
--                                 a.cd_item_documento = vwe.ItemDocumento and
--                                 a.cd_produto        = vwe.CodigoProduto
--                               group by
--                                 a.cd_documento, a.cd_item_documento ),0) as qt_atendimento
--          
-- 
--       from
--         vw_previsao_entrada vwe with (nolock) 
--       where
--         vwe.CodigoProduto = @cd_produto        and
--         vwe.Quantidade    > 0                  and
--         --Data de Entrega
--         @dt_entrega >= vwe.DataPrevisao      
--         
--       order by
--         vwe.CodigoProduto,
--         vwe.DataPrevisao 



      
--       select @cd_pedido_venda        as pedido,
--              @cd_item_pedido_venda   as item,
--              @dt_entrega             as entrega,
--              @dt_atendimento         as 'atendimento',
--              @qt_atendimento         as 'qtated',
--              @qt_saldo               as 'saldo',
--              @nm_forma               as 'forma',
--              @cd_documento           as 'documento',
--              @cd_item_documento      as 'item',
--              @qt_saldo_atual_produto as 'saldo atual'
      
      ------------------------------------------------------------------  
      --Verifica a Última Previsão se Houve Saldo
      ------------------------------------------------------------------  

      if @qt_atendimento=0
      begin

        select
          top 1
          @qt_atendimento    = isnull(vwe.Quantidade,0)

                             -

                             --Quantidade já alocada em outras pedidos vendas                           
                             isnull((select sum( isnull(qt_atendimento,0))
                              from atendimento_pedido_venda a 
                              where                              
                                a.cd_documento         = vwe.documento     and
                                a.cd_item_documento    = vwe.ItemDocumento and
                                a.cd_produto           = vwe.CodigoProduto 
                              group by
                                a.cd_documento, a.cd_item_documento ),0),
         
          @dt_atendimento    = vwe.DataPrevisao,
          @nm_forma          = vwe.Forma,
          @cd_documento      = vwe.Documento,
          @cd_item_documento = vwe.ItemDocumento,
          @qt_saldo_atual_produto = isnull(ps.qt_saldo_atual_produto,@qt_saldo_atual_produto)
                                  - 
                                   isnull(( select sum(epv.qt_estoque)
                                   from
                                     estoque_pedido_venda epv with (nolock) 
                                   where 
                                     epv.cd_produto = p.cd_produto ),0)


          --select * from atendimento_pedido_venda
          --select * from vw_previsao_entrada where Codigoproduto = 2988

        from
          vw_previsao_entrada vwe with (nolock) 
          left outer join produto p        with (nolock) on p.cd_produto       = vwe.codigoProduto
          left outer join produto_saldo ps with (nolock) on ps.cd_produto      = p.cd_produto and
                                                          ps.cd_fase_produto = --isnull(p.cd_fase_produto_baixa,0)
                                                                               case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                               then
                                                                                 p.cd_fase_produto_baixa 
                                                                               else 
                                                                                 @cd_fase_produto
                                                                               end

        where
          vwe.CodigoProduto = @cd_produto        and
          (vwe.Quantidade
                             -
                             --Quantidade já alocada em outras pedidos vendas                           
                             isnull((select sum( isnull(qt_atendimento,0))
                              from atendimento_pedido_venda a with (nolock) 
                              where                              
                                a.cd_documento         = vwe.documento     and
                                a.cd_item_documento    = vwe.ItemDocumento and
                                a.cd_produto           = vwe.CodigoProduto 
                              group by
                                a.cd_documento, a.cd_item_documento ),0)
          )
          > 0                  
          --Data de Entrega
          and @dt_entrega >= vwe.DataPrevisao      
        
        order by
          vwe.CodigoProduto,
          vwe.DataPrevisao 
--          vwe.DataPrevisao desc

      end

--     select @qt_atendimento

      --select @qt_saldo_atual_produto
      --select @cd_pedido_venda,@cd_item_pedido_venda,@dt_entrega,@dt_atendimento,@qt_atendimento,@qt_saldo,@qt_saldo_atual_produto,@nm_forma,@cd_documento,@cd_item_documento
      --select * from atendimento_pedido_venda where cd_produto = 81

--       select @cd_pedido_venda        as pedido,
--              @cd_item_pedido_venda   as item,
--              @dt_entrega             as entrega,
--              @dt_atendimento         as 'atendimento',
--              @qt_atendimento         as 'qtated',
--              @qt_saldo               as 'saldo',
--              @nm_forma               as 'forma',
--              @cd_documento           as 'documento',
--              @cd_item_documento      as 'item',
--              @qt_saldo_atual_produto as 'saldo atual'

      --------------------------------------------------------------------------
      --Ajustar a quantidade de atendimento
      --------------------------------------------------------------------------

      if @qt_atendimento>=@qt_saldo
      begin
        set @qt_atendimento = @qt_saldo
      end

      if @qt_atendimento>0 
      begin

        --Verificar se Existe o Atendimento já na Tabela 

       -- select @qt_atendimento,@qt_saldo

--         if not exists(
-- 
--            select top 1 cd_atendimento_pedido
--            from
--              atendimento_pedido_venda with (nolock) 
--            where
--             cd_pedido_venda      = @cd_pedido_venda      and
--             cd_item_pedido_venda = @cd_item_pedido_venda and
--             --qt_atendimento       = @qt_saldo             and
--             qt_atendimento       = @qt_atendimento       and
--             cd_produto           = @cd_produto           and
--             dt_atendimento       = @dt_atendimento       and
--             nm_forma             = @nm_forma             and
--             cd_documento         = @cd_documento         and
--             cd_item_documento    = @cd_item_documento 
-- 
-- --         select * from atendimento_pedido_venda where cd_produto = 81
-- 
--         )
--         begin         

          --Insere a tabela de atendimento
          set @Tabela = cast(DB_NAME()+'.dbo.Atendimento_Pedido_Venda' as varchar(80))
 
          exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_atendimento_pedido', @codigo = @cd_atendimento_pedido output
	
          while exists(Select top 1 'x' from Atendimento_Pedido_Venda where cd_atendimento_pedido = @cd_atendimento_pedido)
          begin
            exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_atendimento_pedido', @codigo = @cd_atendimento_pedido output
            -- limpeza da tabela de código
            exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_atendimento_pedido, 'D'
          end

          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_atendimento_pedido, 'D'
     
          insert into atendimento_pedido_venda
          select
            @cd_atendimento_pedido,
            @cd_pedido_venda,
            @cd_item_pedido_venda,
            @qt_atendimento,
            @cd_produto,
            @dt_atendimento,
            @nm_forma,
            @cd_documento,
            @cd_item_documento,
            '',
            @cd_usuario,
            getdate()

          where
            @qt_atendimento>0


--          end
--       else
--          begin
--            print 'atualizacao'
-- --            update
-- --              atendimento_pedido_venda
-- --            set
-- --              qt_atendimento      = @qt_atendimento
-- --            where
-- --             cd_pedido_venda      = @cd_pedido_venda      and
-- --             cd_item_pedido_venda = @cd_item_pedido_venda and
-- --             qt_atendimento       = @qt_atendimento       and
-- --             cd_produto           = @cd_produto           and
-- --             dt_atendimento       = @dt_atendimento       and
-- --             nm_forma             = @nm_forma             and
-- --             cd_documento         = @cd_documento         and
-- --             cd_item_documento    = @cd_item_documento 
-- 
--          end
--     
          --------------------------------------------------------------------------------------------
          --Atualizar o  Item do Pedido de Venda com a data da Reprogramação
          --------------------------------------------------------------------------------------------

          update
            pedido_venda_item
          set
            dt_reprog_item_pedido = @dt_atendimento,
            dt_atendimento        = @dt_atendimento,
            qt_atendimento        = @qt_atendimento,
            nm_forma              = @nm_forma,
            cd_documento          = @cd_documento,
            cd_item_documento     = @cd_item_documento,
            qt_atendimento_1      = case when @qtdAtendimento = 1 then @qt_atendimento else 0.00 end,
            qt_atendimento_2      = case when @qtdAtendimento = 2 then @qt_atendimento else 0.00 end,
            qt_atendimento_3      = case when @qtdAtendimento = 3 then @qt_atendimento else 0.00 end

                     
          where
            cd_pedido_venda      = @cd_pedido_venda      and
            cd_item_pedido_venda = @cd_item_pedido_venda       
     
          --------------------------------------------------------------------------------------------

       end

--      select @qt_saldo,@qt_atendimento
      
      set @qt_saldo     = @qt_saldo - @qt_atendimento

      ------------------------------------------------------------------------------------------------
      --Caso não for Atendido e estiver estoque - Gera Estoque
      ------------------------------------------------------------------------------------------------

      if @qt_saldo > 0 and @qt_atendimento = 0 and isnull(@qt_saldo_atual_produto,0) > 0 and @ic_alocacao = 'N'
      begin

        ---------------------------------------------------------------------------
        --Atualização da Tabela de Controle de Itens do Estoque
        --------------------------------------------------------------------------- 
        set @Tabela = cast(DB_NAME()+'.dbo.Estoque_Pedido_Venda' as varchar(80))

        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_estoque_pedido', @codigo = @cd_estoque_pedido output
	
        while exists(Select top 1 'x' from Estoque_Pedido_Venda where cd_estoque_pedido = @cd_estoque_pedido)
        begin
          exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_estoque_pedido', @codigo = @cd_estoque_pedido output
          -- limpeza da tabela de código
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_estoque_pedido, 'D'
        end

        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_estoque_pedido, 'D'
     
        insert into estoque_pedido_venda
        select
          @cd_estoque_pedido,
          @cd_pedido_venda,
          @cd_item_pedido_venda,
          @qt_saldo,
          @cd_produto,
          getdate(),
          @cd_usuario,
          getdate()
         where
           @qt_saldo>0

          --print 'entrei aqui'
 
          --Atualização com a Data de Vendas
  
          update
            pedido_venda_item
          set
            dt_reprog_item_pedido = dt_entrega_vendas_pedido,
            qt_estoque            = @qt_saldo,
            dt_estoque            = getdate()
          where
            cd_pedido_venda       = @cd_pedido_venda      and
            cd_item_pedido_venda  = @cd_item_pedido_venda       

      end

     
      --Verifica o Saldo

      if @qt_saldo = 0 or @qt_atendimento = 0
      begin
        set @i = 1
      end

--      select @i, @qt_saldo,@qt_atendimento

   
--      select @qt_saldo,@qt_movimento,@qt_atendimento,@nm_forma,@cd_documento,@cd_item_documento

  
    end

    delete from #Atendimento
    where
      cd_controle = @cd_controle


    set @qtdAtendimento = @qtdAtendimento + 1

  end
   
  -- Nome da Tabela usada na geração e liberação de códigos

  --  

  --exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_atendimento_pedido, 'D'
  

  --select * from Atendimento_Pedido_Venda where cd_produto = 81


  ------------------------------------------------------------------------------------------
  --Atualização da Quantidade Alocação
  ------------------------------------------------------------------------------------------
  declare @qt_alocado_produto float
  declare @dt_fechamento      datetime

  select
    @cd_fase_produto = isnull(p.cd_fase_produto_baixa,@cd_fase_produto)
  from
    Produto p with (nolock)
  where
    p.cd_produto = @cd_produto

  --Quantidade Alocada----------------------------------------------------------------------
 
  select
    @qt_alocado_produto = sum( apv.qt_atendimento ) 
  from
    Atendimento_Pedido_Venda apv   
  where
    apv.cd_produto  = @cd_produto
  group by
    apv.cd_produto

  ------------------------------------------------------------------------------------------
  --Atualiza o Valor
  ------------------------------------------------------------------------------------------

  update
    Produto_Saldo
  set
    qt_alocado_produto = @qt_alocado_produto
  from
    Produto_Saldo
  where
    cd_produto      = @cd_produto         and
    cd_fase_produto = @cd_fase_produto


--drop table #Reserva
--drop table #Aux_Reserva
--drop table #Atendimento

-------------------------------------------------------------------------------
--  CONFIRMAÇÃO DAS GRAVAÇÕES OU CANCELAMENTO                                --
-------------------------------------------------------------------------------

--SET LOCK_TIMEOUT -1

-- if @@Error = 0
--   Commit Transaction
-- else
--   Rollback Transaction



