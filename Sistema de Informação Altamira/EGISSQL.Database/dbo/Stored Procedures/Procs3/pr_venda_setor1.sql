-----------------------------------------------------------------------------------  
--pr_venda_setor1  
-----------------------------------------------------------------------------------  
--GBS-Global Business Solution Ltda.  
-----------------------------------------------------------------------------------  
--Stored Procedure : SQL Server Microsoft 7.0    
--Carlos Cardoso Fernandes           
--Vendas por Setor  
--Data         : 09.01.2000  
--Atualizado   : 06.06.2000  
--             : 05.07.2000 - Lucio (Mudada para Período)  
--             : 11.12.2000 -   
--             : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)  
--             : 06.04.2002 - Adriano - Conversao EGISSQL  
--             : 02/08/2002 - Daniel C. Neto - Filtro por Vendedor.  
--             : 09/08/2002 - Carrasco - Colocado IsNull no ic_smo_item_pedido_venda  
--             : 05/11/2002 - Acerto na quantidade de Pedidos de Venda por Vendedor (DUELA)  
--             : 06/11/2003 - Incluído filtro por Moeda - Daniel C. Neto.  
--               19/11/2003 - Acerto no Filtro - Daniel C. Neto.  
-- 21/11/2003 - Incluído novas colunas e acertado filtro - Daniel C. Neto.  
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar  
--            - Daniel C. Neto.  
-- 06.03.2006 - Acerto da Consulta - Carlos Fernandes  
-- 14.03.2006 - Tipo de Mercado - Carlos Fernandes  
-- 27.03.2006 - Status do Cliente  
--            - Vendedor do Movimento de Caixa - Carlos Fernandes  
-- 19.05.2006 - Implementação de With (nolock) e restruturação necessária visando desempenho - Fabio Cesar  
-----------------------------------------------------------------------------------  
CREATE procedure pr_venda_setor1     
@dt_inicial          datetime,    
@dt_final            datetime,    
@cd_vendedor         int,    
@cd_moeda            int = 1,    
@cd_tipo_mercado     int = 0,  
@cd_vendedor_interno int = 0      
as    
Begin    
  
  declare @vl_moeda              float    
  declare @ic_vendedor_mov_caixa char(1)  
    
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0   
                              then 1    
                              else dbo.fn_vl_moeda(@cd_moeda) end )    
    
  
  --*************************************************************************************************************  
  -- CARREGA TABELAS TEMPORÁRIAS EVITANDO-SE ASSIM PROBLEMAS COM ACESSOS CONCORRENTES  
  --*************************************************************************************************************  
  
  --Parâmetro BI  
  select  
    @ic_vendedor_mov_caixa = isnull(ic_vendedor_mov_caixa,'N')  
  from  
    Parametro_BI  
  where  
    cd_empresa = dbo.fn_empresa()  
  
  -- Montagem da tabela de total de clientes por setor    
  select c.cd_vendedor       as 'setor',    
         count(c.cd_cliente) as 'qtdclientes'    
  into     
    #Resumo_Clientes_setor    
  from    
    cliente c with (nolock)  
    left outer join status_cliente sc   
      on sc.cd_status_cliente = c.cd_status_cliente  
  where  
    isnull(sc.ic_analise_status_cliente,'N')='S'                               
  group by     
    c.cd_vendedor    
  
  
  --*************************************************************************************************************  
  --Gerar um tabela temporária com todos os itens e pedidos conforme o período definido evitando-se assim acesso   
  --a tabela de pedido de venda que é muito utilizada pelo sistema.  
  --*************************************************************************************************************  
  --PEDIDO DE VENDA  
  Select  
    a.cd_pedido_venda,  
    a.cd_cliente,  
    a.cd_vendedor,  
	 a.cd_vendedor_interno,
    a.cd_destinacao_produto,  
    a.dt_pedido_venda,  
    a.ic_consignacao_pedido,  
    a.ic_amostra_pedido_venda,  
    a.dt_cancelamento_pedido,  
    b.cd_item_pedido_venda,  
    b.qt_item_pedido_venda,  
    b.vl_unitario_item_pedido,  
    b.pc_icms_item,  
    b.dt_cancelamento_item,  
    b.pc_ipi,  
    b.vl_lista_item_pedido,  
    cli.cd_tipo_mercado,
	 vl_custo_contabil_produto  
  into  
    #Pedido_Venda  
  from  
    Pedido_Venda a with (nolock)  
    inner join Pedido_Venda_Item b with (nolock) on a.cd_pedido_venda = b.cd_pedido_venda  
    inner join Cliente cli with (nolock)         on a.cd_cliente = cli.cd_cliente   
    left outer join Produto_Custo ps with (nolock)   
      on ps.cd_produto = b.cd_produto      
  where  
--    (a.dt_pedido_venda between '2006-04-01' and '2006-04-30')    
    (a.dt_pedido_venda between @dt_inicial and @dt_final)    
  
  print 'Gravou tabela com pedidos para uso'  

  create index #pedido_venda_I on #pedido_venda (dt_pedido_venda, ic_consignacao_pedido, ic_amostra_pedido_venda)

 --Geração da tabela auxiliar de Vendas por Setor    
  Select     
    a.cd_vendedor                    as 'setor',     
    cast(sum( isnull(a.qt_item_pedido_venda,0) * (case     
     when(a.dt_cancelamento_item is null) then      
       (a.vl_unitario_item_pedido)     
     else 0     
        end)/ @vl_moeda)as decimal(25,2)) as 'Venda',    
     
   cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                        (a.vl_unitario_item_pedido / @vl_moeda))    
                                   , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',    
   cast(sum((a.qt_item_pedido_venda *    
            (a.vl_lista_item_pedido / @vl_moeda)    
           )    
       ) as decimal(25,2)) as 'TotalLiSta',    
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',    
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))  /    
        sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                        (a.vl_unitario_item_pedido / @vl_moeda))    
                                   , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial))) as decimal(25,2)) * 100 as 'MargemContribuicao',    
     
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',    
   max(a.dt_pedido_venda)                                        as 'UltimaVenda',     
   count(distinct a.cd_pedido_venda)                             as 'pedidos',    
   dbo.fn_meta_vendedor(a.cd_vendedor,@dt_inicial,@dt_final,0,0) as 'Meta',    
   count ( distinct a.cd_cliente  )                              as 'Atendimento'    
  into   
    #VendaSetorAux1    
  from    
     #Pedido_Venda a      
  where    
    (a.dt_pedido_venda between @dt_inicial and @dt_final) and                       
    isnull(a.ic_consignacao_pedido,'N')   <> 'S'          and               
    isnull(a.ic_amostra_pedido_venda,'N') <> 'S'          and    
      
    (isnull(a.qt_item_pedido_venda,0)* IsNull(a.vl_unitario_item_pedido,0)/ @vl_moeda) > 0  and    
    IsNull(a.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final    
    IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados    
    IsNull(a.cd_vendedor,0) = (case when (@cd_vendedor=0) then IsNull(a.cd_vendedor,0) else @cd_vendedor end)    and  
    a.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then a.cd_tipo_mercado else @cd_tipo_mercado end          
      
  Group by   
    a.cd_vendedor    
  Order by 2 desc    
    
  -- Geração da tabela auxiliar de Vendas por Setor    
  if @ic_vendedor_mov_caixa='S'  
  begin  
    
   --Venda do Vendedor Interno     
   select     
    a.cd_vendedor_interno                  as 'setor',     
      
    cast(((sum( isnull(a.qt_item_pedido_venda,0) * (case     
      when(a.dt_cancelamento_item is null) then      
        (a.vl_unitario_item_pedido)     
      else 0     
         end)/ @vl_moeda) ) / 2 )as decimal(25,2)) as 'Venda',    
      
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                         (a.vl_unitario_item_pedido / @vl_moeda))    
                                    , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',    
    cast(sum((a.qt_item_pedido_venda *                 (a.vl_lista_item_pedido / @vl_moeda)    
            )    
        ) as decimal(25,2)) as 'TotalLiSta',    
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))/2) as decimal(25,2)) as 'CustoContabil',    
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))  /    
         sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                         (a.vl_unitario_item_pedido / @vl_moeda))    
                                    , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial))))/2  as decimal(25,2)) * 100  as 'MargemContribuicao',    
      
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))/2) as decimal(25,2)) * dbo.fn_pc_bns()   
                                                                  as 'BNS',    
    max(a.dt_pedido_venda)                                        as 'UltimaVenda',     
    count(distinct a.cd_pedido_venda)                             as 'pedidos',    
    dbo.fn_meta_vendedor(a.cd_vendedor_interno,@dt_inicial,@dt_final,0,0) as 'Meta',    
    count ( distinct a.cd_cliente  )                              as 'Atendimento'    
      
    into   
      #VendaSetorAux2  
    from    
       #Pedido_Venda a  
    where    
      (a.dt_pedido_venda between @dt_inicial and @dt_final) and                       
      isnull(a.ic_consignacao_pedido,'N')   <> 'S'          and               
      isnull(a.ic_amostra_pedido_venda,'N') <> 'S'          and    
        
      (isnull(a.qt_item_pedido_venda,0)* IsNull(a.vl_unitario_item_pedido,0)/ @vl_moeda) > 0  and    
      IsNull(a.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final    
      IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados    
      IsNull(a.cd_vendedor_interno,0) = (case when (@cd_vendedor_interno=0) then IsNull(a.cd_vendedor_interno,0)     
                 else @cd_vendedor end)    and  
      --Somente as Vendas que são dividas   
      a.cd_vendedor_interno<>a.cd_vendedor and  
      a.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then a.cd_tipo_mercado else @cd_tipo_mercado end          
      
    Group by   
      a.cd_vendedor_interno    
    Order by 2 desc    
    
   --Soma dos Vendedores Externos  
    
   select     
    a.cd_vendedor                    as 'setor',     
     
    cast(((sum( isnull(a.qt_item_pedido_venda,0) * (case     
      when(a.dt_cancelamento_item is null) then      
        (a.vl_unitario_item_pedido)     
      else 0     
         end)/ @vl_moeda) ) / 2 )as decimal(25,2)) as 'Venda',    
      
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                         (a.vl_unitario_item_pedido / @vl_moeda))    
                                    , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',    
    cast(sum((a.qt_item_pedido_venda *    
             (a.vl_lista_item_pedido / @vl_moeda)    
            )    
        ) as decimal(25,2)) as 'TotalLiSta',    
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))/2) as decimal(25,2)) as 'CustoContabil',    
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))  /    
         sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                         (a.vl_unitario_item_pedido / @vl_moeda))    
                                    , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial))))/2 as decimal(25,2)) * 100  as 'MargemContribuicao',    
     
    cast((sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))/2) as decimal(25,2)) * dbo.fn_pc_bns()   
                                                                  as 'BNS',    
    max(a.dt_pedido_venda)                                        as 'UltimaVenda',     
    count(distinct a.cd_pedido_venda)                         as 'pedidos',    
    dbo.fn_meta_vendedor(a.cd_vendedor,@dt_inicial,@dt_final,0,0) as 'Meta',    
    count ( distinct a.cd_cliente  )                              as 'Atendimento'      
  into   
    #VendaSetorAux3  
  from    
    #Pedido_Venda a  
  where    
    (a.dt_pedido_venda between @dt_inicial and @dt_final) and                       
    isnull(a.ic_consignacao_pedido,'N')   <> 'S'          and               
    isnull(a.ic_amostra_pedido_venda,'N') <> 'S'          and    
      
    (isnull(a.qt_item_pedido_venda,0)* IsNull(a.vl_unitario_item_pedido,0)/ @vl_moeda) > 0  and    
    IsNull(a.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final    
    IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados    
    IsNull(a.cd_vendedor_interno,0) = (case when (@cd_vendedor_interno=0) then IsNull(a.cd_vendedor_interno,0)     
               else @cd_vendedor end)    and  
    --Somente as Vendas que são dividas   
    a.cd_vendedor_interno<>a.cd_vendedor and  
    a.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then a.cd_tipo_mercado else @cd_tipo_mercado end          
      
    Group by   
      a.cd_vendedor    
    Order by 2 desc    
    
    --Soma as Vendas dos Vendedores Externos + Internos     
    insert into #VendaSetorAux1   
      select a.* from #VendaSetorAux2 a where not exists( select a.setor from #VendaSetorAux1 )  
    
     --Soma da Venda do Principal  
     update  
       #VendaSetorAux1  
     set  
       venda = a.venda + b.venda  
     from  
       #VendaSetorAux1 a, #VendaSetorAux2 b  
     where  
       a.setor = b.setor  
    
     --Dedução no Vendedor Interno  
     update  
       #VendaSetorAux1  
     set  
       venda = a.venda - c.venda  
     from  
       #VendaSetorAux1 a, #VendaSetorAux3 c  
     where  
       a.setor = c.setor  
    
     --Delete Vendas Zeradas  
     delete from #VendaSetorAux1 where venda = 0     
      
  end  
  
   
  declare @qt_total_setor int    
  declare @vl_total_setor float    
      
  -- Total de Setores    
  set @qt_total_setor = @@rowcount    
      
  -- Total de Vendas Geral dos Setores    
    
  set @vl_total_setor = 0    
  
  Select   
    @vl_total_setor = @vl_total_setor + IsNull(venda,0)  
  from    
    #VendaSetorAux1    
      
  --Cria a Tabela Final de Vendas por Setor    
    
  select IDENTITY(int, 1,1)      as 'Posicao',    
         a.setor,     
         case when isnull(b.nm_fantasia_vendedor,'')<>'' then b.nm_fantasia_vendedor  
                                                         else 'Pedido s/ Vendedor ou Cadastro' end   
                                 as nm_fantasia_vendedor,    
         isnull(c.qtdclientes,0) as 'qtdclientes',    
         isnull(a.atendimento,0) as 'atendimento',    
         particpacao = (cast(a.atendimento as float)/case when c.qtdclientes=0 then 1 else c.qtdclientes end)*100,    
         isnull(a.venda,0)       as 'venda',     
         a.TotalLiquido,    
         a.TotalLista,    
         cast((( a.TotalLista / a.Venda ) * 100) - 100 as decimal (15,2)) as 'Descto',    
      a.CustoContabil,    
         a.MargemContribuicao,    
         a.BNS,    
         isnull(((a.venda/@vl_total_setor)*100),0) as 'Perc',    
         a.UltimaVenda,     
         isnull(a.pedidos,0)                       as 'pedidos',    
         isnull(a.Meta,0)                          as 'Meta',    
         case when a.Meta>0 then a.venda/a.Meta else 0 end * 100 as 'PercMeta'    
    
      
  Into   
    #VendaSetor1    
  from     
    #VendaSetorAux1 a  
    left outer join vendedor b  
      on a.setor = b.cd_vendedor  
    left outer join #Resumo_Clientes_setor c    
      on a.setor = c.setor  
  Order by     
    a.venda desc    
      
  --Mostra tabela ao usuário    
      
  Select   
    *   
  from   
    #VendaSetor1    
  order by   
    posicao    
end
