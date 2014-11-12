
-------------------------------------------------------------------------------
--sp_helptext pr_verifica_fechamento_alocacao
-------------------------------------------------------------------------------
--pr_verifica_fechamento_alocacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Verifica a Proposta Comercial / Pedido de Venda
--                   Para permitir o fechamento da Proposta Comercial / Pedido de Venda
--
--Data             : 26.06.2009
--Alteração        : 
--
-- 22.07.2009 - Ajustes Diversos - Carlos fernandes
-- 03.10.2009 - Verificação de Performance - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_verifica_fechamento_alocacao
@cd_consulta          int      = 0, --Proposta Comercial
@cd_pedido_venda      int      = 0, --Pedido de Venda
@cd_item_pedido_venda int      = 0,
@cd_produto           int      = 0,
@qt_produto           float    = 0,
@dt_entrega           datetime = ''

as

declare @ic_liberada         char(1)
declare @cd_fase_produto     int 
declare @cd_item_consulta    int
declare @qt_item_consulta    float
declare @qt_disponivel       float
declare @dt_entrega_consulta datetime
declare @dt_disponibilidade  datetime
declare @qt_prevista         float


select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

set @ic_liberada = 'N'

if @cd_consulta>0 
begin

   --select * from consulta_itens

   select
     i.cd_consulta,
     i.cd_item_consulta,
     i.cd_produto,
     i.qt_item_consulta,
     i.dt_entrega_consulta,
     isnull(( isnull(ps.qt_saldo_atual_produto,0) -
       isnull( (select sum(vw.qt_estoque)
            from estoque_pedido_venda vw
            where
              vw.cd_produto = p.cd_produto ),0)),0) as qt_disponivel,

     --Data da Previsão
     ( select 
         top 1
         vwe.DataPrevisao
       from 
         vw_previsao_entrada vwe with (nolock) 
      where
         vwe.CodigoProduto = i.cd_produto            and
--         vwe.DataPrevisao  >= i.dt_entrega_consulta  and
        (vwe.Quantidade
          - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
                               where
                                 vwe.Documento        = apv.cd_documento      and 
                                 vwe.ItemDocumento    = apv.cd_item_documento and
                                 vwe.CodigoProduto   = apv.cd_produto ) ,0)) > 0 

      order by 
         vwe.DataPrevisao  ) as dt_disponibilidade,

     --quantidade

     isnull(( select 
         sum((vwe.Quantidade))
       from 
         vw_previsao_entrada vwe with (nolock) 

      where
         vwe.CodigoProduto = i.cd_produto            
      group by
        vwe.CodigoProduto),0)

     -

     isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv with (nolock) 
              where
                 i.cd_produto   = apv.cd_produto ),0)         as qt_prevista


--      isnull(( select 
--          top 1
--          (vwe.Quantidade
--           - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
--                                where
--                                  vwe.Documento        = apv.cd_documento      and 
--                                  vwe.ItemDocumento = apv.cd_item_documento and
--                                  vwe.CodigoProduto   = apv.cd_produto ) ,0))
--        from 
--          vw_previsao_entrada vwe with (nolock) 
--       where
--          vwe.CodigoProduto = i.cd_produto            and
-- --         vwe.DataPrevisao  >= i.dt_entrega_consulta  and
--         (vwe.Quantidade
--           - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
--                                where
--                                  vwe.Documento        = apv.cd_documento      and 
--                                  vwe.ItemDocumento    = apv.cd_item_documento and
--                                  vwe.CodigoProduto   = apv.cd_produto ) ,0)) > 0 
-- 
--       order by 
--          vwe.DataPrevisao  ),0) as qt_prevista
-- 
-- 
-- 
   into
     #Analise_Consulta    

   from
     Consulta_itens i                     with (nolock)
     left outer join produto p            with (nolock) on p.cd_produto = i.cd_produto
     left outer join Produto_Saldo ps     with (nolock) on ps.cd_produto              = p.cd_produto and
                                                           ps.cd_fase_produto         = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                                        then @cd_fase_produto 
                                                                                        else p.cd_fase_produto_baixa end
   where
     cd_consulta = @cd_consulta

   --select * from #Analise_Consulta

   set @ic_liberada = 'S'

   while exists (select top 1 cd_item_consulta from #Analise_Consulta )
   begin

     select top 1
        @cd_item_consulta    = cd_item_consulta,
        @qt_item_consulta    = qt_item_consulta,  
        @qt_disponivel       = qt_disponivel,
        @dt_entrega_consulta = dt_entrega_consulta,
        @dt_disponibilidade  = dt_disponibilidade,
        @qt_prevista         = qt_prevista

     from
        #Analise_Consulta

--      select
--        @dt_entrega_consulta, 
--        @qt_item_consulta,
--        @qt_disponivel,
--        @qt_disponivel

       
     ---Verificações----------------------------------------------------

     --1.Não tem Estoque e não tem disponibilidade
 
     if @qt_disponivel=0 and @qt_prevista = 0
     begin
       print '1'
       set @ic_liberada = 'N'
     end

     --2. Tem Estoque mas não atende e não tem Previsão

     if @qt_disponivel<@qt_item_consulta 
     begin   

       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade is null and @qt_prevista = 0
       begin
          print '2'
          set @ic_liberada = 'N'
       end

       --3. Tem Estoque mas tem Previsão
         
       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade>@dt_entrega_consulta and @dt_disponibilidade is not null
       begin
         print '3'
         set @ic_liberada = 'N'
       end

       --4. tem Estoque, tem Previsão, mas a quantidade não atende

       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade>=@dt_entrega_consulta and @qt_prevista<@qt_item_consulta
          and @dt_disponibilidade is not null
       begin
         print '4'
         set @ic_liberada = 'N'
       end

     
        --5. Quantidade Prevista não atende

        if @qt_item_consulta>@qt_prevista  and @dt_disponibilidade>=@dt_entrega_consulta and @dt_disponibilidade is not null
        begin
          print '5'
          set @ic_liberada = 'N'
        end

     end

     -- 6. Previsão mas a data de chegada é superior a data de entrega

     if @qt_prevista>0 and @qt_item_consulta>@qt_disponivel and @dt_entrega_consulta<@dt_disponibilidade
     begin
       set @ic_liberada = 'N'
     end

     --Verifica se Não está liberada
      
     if @ic_liberada = 'N'
     begin
       print '6'
       set @cd_item_consulta = 0 --Para deletar e sair do Loop
     end  
     
     delete from #Analise_Consulta
     where
       cd_item_consulta = @cd_item_consulta or @ic_liberada = 'N'

   end

end

-------------------------------------------------------------------------------
--Pedido de Venda
-------------------------------------------------------------------------------

if @cd_pedido_venda>0 
begin

   --select * from pedido_venda_item

   select
     i.cd_pedido_venda,
     i.cd_item_pedido_venda,
     i.cd_produto,
     i.qt_item_pedido_venda,
     i.dt_entrega_vendas_pedido,
     isnull(( isnull(ps.qt_saldo_atual_produto,0) -
       isnull( (select sum(vw.qt_estoque)
            from 
               estoque_pedido_venda vw with (nolock)
               inner join pedido_venda_item pvi on pvi.cd_produto           = vw.cd_produto and
                                                   pvi.cd_pedido_venda      = vw.cd_pedido_venda and
                                                   pvi.cd_item_pedido_venda = vw.cd_item_pedido_venda

          
            where
              pvi.dt_cancelamento_item is null            and
              isnull(pvi.qt_saldo_pedido_venda,0)>0       and
              vw.cd_produto = p.cd_produto ),0)),0) as qt_disponivel,

     --Data da Previsão
     ( select 
         top 1
         vwe.DataPrevisao
       from 
         vw_previsao_entrada vwe with (nolock) 
      where
         vwe.CodigoProduto = i.cd_produto                 and
--         vwe.DataPrevisao  >= i.dt_entrega_vendas_pedido  and
        (vwe.Quantidade
          - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
                               where
                                 vwe.Documento        = apv.cd_documento      and 
                                 vwe.ItemDocumento    = apv.cd_item_documento and
                                 vwe.CodigoProduto    = apv.cd_produto ) ,0)) > 0 

      order by 
         vwe.DataPrevisao  ) as dt_disponibilidade,

     --Soma da Quantidade

     isnull(( select 
         sum((vwe.Quantidade))
       from 
         vw_previsao_entrada vwe with (nolock) 

      where
         vwe.CodigoProduto = i.cd_produto            
      group by
        vwe.CodigoProduto),0)

     -

     isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv with (nolock) 
              where
                 i.cd_produto   = apv.cd_produto ),0)         as qt_prevista

--Antes

--      isnull(( select 
--          top 1
--          (vwe.Quantidade
--           - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
--                                where
--                                  vwe.Documento        = apv.cd_documento      and 
--                                  vwe.ItemDocumento    = apv.cd_item_documento and
--                                  vwe.CodigoProduto    = apv.cd_produto ) ,0))
--        from 
--          vw_previsao_entrada vwe with (nolock) 
--       where
--          vwe.CodigoProduto = i.cd_produto            and
-- --         vwe.DataPrevisao  >= i.dt_entrega_vendas_pedido  and
--         (vwe.Quantidade
--           - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
--                                where
--                                  vwe.Documento        = apv.cd_documento      and 
--                                  vwe.ItemDocumento    = apv.cd_item_documento and
--                                  vwe.CodigoProduto   = apv.cd_produto ) ,0)) > 0 
-- 
--       order by 
--          vwe.DataPrevisao  ),0) as qt_prevista



   into
     #Analise_Pedido

   from
     pedido_venda_item i                  with (nolock)
     left outer join produto p            with (nolock) on p.cd_produto = i.cd_produto
     left outer join Produto_Saldo ps     with (nolock) on ps.cd_produto              = p.cd_produto and
                                                           ps.cd_fase_produto         = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                                        then @cd_fase_produto 
                                                                                        else p.cd_fase_produto_baixa end
   where
     i.cd_pedido_venda      = @cd_pedido_venda and
     i.cd_item_pedido_venda = case when @cd_item_pedido_venda = 0 then i.cd_item_pedido_venda else @cd_item_pedido_venda end


   if not exists (select top 1 cd_item_pedido_venda from #Analise_pedido )
   begin
     insert into #Analise_Pedido
     select
        0           as cd_pedido_venda,
        0           as cd_item_pedido_venda,
        @cd_produto as cd_produto,
        @qt_produto as qt_item_pedido_venda,
        @dt_entrega as dt_entrega_vendas_pedido,

        isnull(( isnull(ps.qt_saldo_atual_produto,0) -
        isnull( (select sum(vw.qt_estoque)
            from 
               estoque_pedido_venda vw with (nolock)
               inner join pedido_venda_item pvi on pvi.cd_produto           = vw.cd_produto and
                                                   pvi.cd_pedido_venda      = vw.cd_pedido_venda and
                                                   pvi.cd_item_pedido_venda = vw.cd_item_pedido_venda

          
            where
              pvi.dt_cancelamento_item is null            and
              isnull(pvi.qt_saldo_pedido_venda,0)>0       and
              vw.cd_produto = p.cd_produto ),0)),0) as qt_disponivel,

     --Data da Previsão

     ( select 
         top 1
         vwe.DataPrevisao
       from 
         vw_previsao_entrada vwe with (nolock) 
      where
         vwe.CodigoProduto = p.cd_produto                 and
--         vwe.DataPrevisao  >= i.dt_entrega_vendas_pedido  and
        (vwe.Quantidade
          - isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv
                               where
                                 vwe.Documento        = apv.cd_documento      and 
                                 vwe.ItemDocumento    = apv.cd_item_documento and
                                 vwe.CodigoProduto    = apv.cd_produto ) ,0)) > 0 

      order by 
         vwe.DataPrevisao  ) as dt_disponibilidade,

     --Soma da Quantidade

     isnull(( select 
         sum((vwe.Quantidade))
       from 
         vw_previsao_entrada vwe with (nolock) 

      where
         vwe.CodigoProduto = p.cd_produto            
      group by
        vwe.CodigoProduto),0)

     -

     isnull(( select sum(apv.qt_atendimento) from Atendimento_Pedido_Venda apv 
              where
                 p.cd_produto   = apv.cd_produto ),0)         as qt_prevista

   from
     produto p                            with (nolock) 
     left outer join Produto_Saldo ps     with (nolock) on ps.cd_produto              = p.cd_produto and
                                                           ps.cd_fase_produto         = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                                        then @cd_fase_produto 
                                                                                        else p.cd_fase_produto_baixa end
   where
     @cd_produto = p.cd_produto
    

   end

   --select * from #Analise_Pedido

   set @ic_liberada = 'S'

   while exists (select top 1 cd_item_pedido_venda from #Analise_pedido )
   begin

     select top 1
        @cd_item_consulta    = cd_item_pedido_venda,
        @qt_item_consulta    = qt_item_pedido_venda,  
        @qt_disponivel       = qt_disponivel,
        @dt_entrega_consulta = dt_entrega_vendas_pedido,
        @dt_disponibilidade  = dt_disponibilidade,
        @qt_prevista         = qt_prevista

     from
        #Analise_Pedido

--      select
--        @dt_entrega_consulta, 
--        @qt_item_consulta,
--        @qt_disponivel,
--        @qt_disponivel

       
     ---Verificações----------------------------------------------------

     --1.Não tem Estoque e não tem disponibilidade
 
     if @qt_disponivel=0 and @qt_prevista = 0
     begin
       set @ic_liberada = 'N'
     end

     --2. Tem Estoque mas não atende e não tem Previsão
     if @qt_disponivel<@qt_item_consulta 
     begin   
       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade is null and @qt_prevista = 0 and @dt_disponibilidade is not null
       begin
         set @ic_liberada = 'N'
       end

       --3. Tem Estoque mas tem Previsão
         
       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade>@dt_entrega_consulta and @dt_disponibilidade is not null
       begin
         print '3'
         set @ic_liberada = 'N'
       end

       --4. tem Estoque, tem Previsão, mas a quantidade não atende

       if @qt_item_consulta>@qt_disponivel and @dt_disponibilidade>=@dt_entrega_consulta and @qt_prevista<@qt_item_consulta
       begin
         set @ic_liberada = 'N'
       end

       --5. Quantidade Prevista não atende

       if @qt_item_consulta>@qt_prevista  and @dt_disponibilidade>=@dt_entrega_consulta and @dt_disponibilidade is not null
       begin
         set @ic_liberada = 'N'
       end

     end

     -- 6. Previsão mas a data de chegada é superior a data de entrega

     if @qt_prevista>0 and @qt_item_consulta>@qt_disponivel and @dt_entrega_consulta<@dt_disponibilidade
     begin
       set @ic_liberada = 'N'
     end

     --Verifica se Não está liberada
      
     if @ic_liberada = 'N'
     begin
       set @cd_item_consulta = 0 --Para deletar e sair do Loop
     end  
     
     delete from #Analise_Pedido
     where
       cd_item_pedido_venda = @cd_item_consulta or @ic_liberada = 'N'

   end

   --Temporiamente
   --set @ic_liberada = 'S'

end

--Retorno

select
  @ic_liberada as Liberada


