-----------------------------------------------------------------------------------  
--pr_ranking_conceito_cliente_vendas
-----------------------------------------------------------------------------------  
--GBS-Global Business Solution Ltda.                                           2006
-----------------------------------------------------------------------------------  
--Stored Procedure : SQL Server Microsoft 2000
--Autor            : Carlos Cardoso Fernandes           
--Objetivo         : Consulta do Ranking de Vendas por Conceito de clientes
--Data             : 05.06.2006
--Atualizado       : 
-----------------------------------------------------------------------------------  
CREATE procedure pr_ranking_conceito_cliente_vendas
@dt_inicial          datetime,    
@dt_final            datetime,    
@cd_conceito_cliente int = 0,    
@cd_moeda            int = 1,    
@cd_tipo_mercado     int = 0

as    

begin    
  
  declare @vl_moeda              float    
  declare @ic_vendedor_mov_caixa char(1)  
    
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0   
                              then 1    
                              else dbo.fn_vl_moeda(@cd_moeda) end )    
    
  
  -- Montagem da tabela de total de clientes por setor    

  select 
    c.cd_conceito_cliente  as 'conceito',    
    count(c.cd_cliente)    as 'qtdclientes'    
  into     
    #Resumo_Clientes_Conceito
  from    
    cliente c with (nolock)  
    left outer join status_cliente sc on sc.cd_status_cliente = c.cd_status_cliente  
  where  
     c.cd_conceito_cliente = case when @cd_conceito_cliente = 0 then c.cd_conceito_cliente else @cd_conceito_cliente end and      
    isnull(sc.ic_analise_status_cliente,'N')='S'                               
  group by     
    c.cd_conceito_cliente
  
  
--PEDIDO DE VENDA  

  Select  
    cli.cd_conceito_cliente,
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
    inner join Pedido_Venda_Item b with (nolock)   on a.cd_pedido_venda = b.cd_pedido_venda  
    inner join Cliente cli with (nolock)           on a.cd_cliente      = cli.cd_cliente   
    left outer join Produto_Custo ps with (nolock) on ps.cd_produto     = b.cd_produto      
  where  
    (a.dt_pedido_venda between @dt_inicial and @dt_final)    
  
  --print 'Gravou tabela com pedidos para uso'  

  create index #pedido_venda_I on #pedido_venda (dt_pedido_venda, ic_consignacao_pedido, ic_amostra_pedido_venda)

 --Geração da tabela auxiliar de Vendas por Setor    

  Select     
    a.cd_conceito_cliente                       as 'conceito',     
    cast(sum( isnull(a.qt_item_pedido_venda,0) * (case     
     when(a.dt_cancelamento_item is null) then      
       (a.vl_unitario_item_pedido)     
     else 0     
        end)/ @vl_moeda)as decimal(25,2))       as 'Venda',    
     
   cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                        (a.vl_unitario_item_pedido / @vl_moeda))    
                                   , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) 
                                                as 'TotalLiquido',    
   cast(sum((a.qt_item_pedido_venda *    
            (a.vl_lista_item_pedido / @vl_moeda))) as decimal(25,2))
                                                as 'TotalLiSta',    
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) 
                                                as 'CustoContabil',    
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda))  /    
        sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*    
                                        (a.vl_unitario_item_pedido / @vl_moeda))    
                                   , a.pc_icms_item, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial))) as decimal(25,2)) * 100 
                                                as 'MargemContribuicao',    
     
   cast(sum((a.qt_item_pedido_venda* a.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() 
                                                                 as 'BNS',    
   max(a.dt_pedido_venda)                                        as 'UltimaVenda',     
   count(distinct a.cd_pedido_venda)                             as 'pedidos',    
   count ( distinct a.cd_cliente  )                              as 'Atendimento',
   count ( distinct a.cd_vendedor )                              as 'QtdVendedor'    

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
    a.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then a.cd_tipo_mercado else @cd_tipo_mercado end          
      
  Group by   
    a.cd_conceito_cliente
  Order by 2 desc    
    
   
  declare @qt_total_conceito int    
  declare @vl_total_conceito float    
      
  -- Total de Setores    
  set @qt_total_conceito = @@rowcount    
      
  -- Total de Vendas Geral dos Setores    
    
  set @vl_total_conceito = 0    
  
  Select   
    @vl_total_conceito = @vl_total_conceito + IsNull(venda,0)  
  from    
    #VendaSetorAux1    
      
  --Cria a Tabela Final de Vendas por Setor    
    
  select IDENTITY(int, 1,1)      as 'Posicao',    
         a.conceito,     
         case when isnull(b.nm_conceito_cliente,'')<>'' then b.nm_conceito_cliente
                                                         else 'Cliente sem conceito ou Cadastro' end   
                                 as nm_conceito_cliente,    
         isnull(c.qtdclientes,0) as 'qtdclientes',    
         isnull(a.qtdvendedor,0) as 'qtdvendedor',
         isnull(a.atendimento,0) as 'atendimento',    
         participacao = (cast(a.atendimento as float)/case when c.qtdclientes=0 then 1 else c.qtdclientes end)*100,    
         isnull(a.venda,0)       as 'venda',     
         a.TotalLiquido,    
         a.TotalLista,    
         cast((( a.TotalLista / a.Venda ) * 100) - 100 as decimal (15,2)) as 'Descto',    
         a.CustoContabil,    
         a.MargemContribuicao,    
         a.BNS,    
         isnull(((a.venda/@vl_total_conceito)*100),0)               as 'Perc',    
         a.UltimaVenda,     
         isnull(a.pedidos,0)                                     as 'pedidos'    
          
  Into   
    #VendaSetor1    
  from     
    #VendaSetorAux1 a  
    left outer join Cliente_Conceito b           on a.conceito = b.cd_conceito_cliente
    inner join #Resumo_Clientes_Conceito c  on a.conceito = c.conceito
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

