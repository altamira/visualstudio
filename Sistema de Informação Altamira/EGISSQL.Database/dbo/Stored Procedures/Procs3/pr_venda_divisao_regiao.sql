
-------------------------------------------------------------------------------
--pr_venda_divisao_regiao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 01/06/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_venda_divisao_regiao
@dt_inicial          datetime,    
@dt_final            datetime,    
@cd_divisao_regiao   int,    
@cd_moeda            int = 1,    
@cd_tipo_mercado     int = 0  
as    
    
declare @vl_moeda              float    
declare @ic_vendedor_mov_caixa char(1)  
    
set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0   
                            then 1    
                            else dbo.fn_vl_moeda(@cd_moeda) end )    
    
    
--Parâmetro BI  
  
select  
  @ic_vendedor_mov_caixa = isnull(ic_vendedor_mov_caixa,'N')  
from  
  Parametro_BI  
where  
  cd_empresa = dbo.fn_empresa()  
  
-- Montagem da tabela de total de clientes por setor    
  
--select * from status_cliente  
select DR.cd_divisao_regiao as 'Divisao',    
       count(distinct(c.cd_cliente))  as 'qtdclientes'    
into     
  #Resumo_Clientes_Divisao    
from    
  cliente c   
  left outer join status_cliente   sc on sc.cd_status_cliente = c.cd_status_cliente --and  
  left outer join Cliente_Endereco Ce on ce.cd_cliente = c.cd_cliente
  left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  left outer join Divisao_Regiao   DR on DR.cd_divisao_regiao = Cep.cd_divisao_regiao
where  
  isnull(sc.ic_analise_status_cliente,'N')='S'                               
group by     
  DR.cd_divisao_regiao
    
 
--select * from #Resumo_Clientes_setor    
  
-- Geração da tabela auxiliar de Vendas por Setor    
  
 select     
    DR.cd_divisao_regiao                    as 'Divisao',     
    
--  cast(sum(b.qt_item_pedido_venda*(b.vl_unitario_item_pedido / @vl_moeda)) as decimal(25,2)) as 'Venda',     
    
  cast(sum( isnull(b.qt_item_pedido_venda,0) * (case     
    when(b.dt_cancelamento_item is null) then      
      (b.vl_unitario_item_pedido)     
    else 0     
       end)/ @vl_moeda)as decimal(25,2)) as 'Venda',    
    
  cast(sum(dbo.fn_vl_liquido_venda('V',(b.qt_item_pedido_venda*    
                                       (b.vl_unitario_item_pedido / @vl_moeda))    
                                  , b.pc_icms_item, b.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',    
  cast(sum((b.qt_item_pedido_venda *    
           (b.vl_lista_item_pedido / @vl_moeda)    
          )    
      ) as decimal(25,2)) as 'TotalLiSta',    
  cast(sum((b.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',    
  cast(sum((b.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /    
       sum((dbo.fn_vl_liquido_venda('V',(b.qt_item_pedido_venda*    
                                       (b.vl_unitario_item_pedido / @vl_moeda))                                      , b.pc_icms_item, b.pc_ipi, a.cd_destinacao_produto, @dt_inicial)))    
 as decimal(25,2)) * 100 as 'MargemContribuicao',    
    
  cast(sum((b.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',    
  max(a.dt_pedido_venda)                                        as 'UltimaVenda',     
  count(distinct a.cd_pedido_venda)                             as 'pedidos',    
--  dbo.fn_meta_vendedor(a.cd_vendedor,@dt_inicial,@dt_final,0,0) as 'Meta',    
  count ( distinct a.cd_cliente  )                              as 'Atendimento'    
    
into #Venda
from    
   Pedido_Venda a   
   inner join      Pedido_Venda_Item b on b.cd_pedido_venda = a.cd_pedido_venda   
   left outer join Produto_Custo ps on ps.cd_produto = b.cd_produto    left outer join  
   Cliente cli   on cli.cd_cliente = a.cd_cliente           
   left outer join Cliente_Endereco Ce on ce.cd_cliente = cli.cd_cliente
   left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
   left outer join Divisao_Regiao   DR on DR.cd_divisao_regiao = Cep.cd_divisao_regiao
where    
  (a.dt_pedido_venda between @dt_inicial and @dt_final) and                       
  isnull(a.ic_consignacao_pedido,'N')   <> 'S'          and               
  isnull(a.ic_amostra_pedido_venda,'N') <> 'S'          and    
    
  (isnull(b.qt_item_pedido_venda,0)* IsNull(b.vl_unitario_item_pedido,0)/ @vl_moeda) > 0  and    
  IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final    
  IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados    
--  isnull(b.ic_smo_item_pedido_venda,'N') = 'N'          and --Desconsidera notas de serviço    
  IsNull(DR.cd_divisao_regiao,0) = (case when (@cd_divisao_regiao=0) then IsNull(DR.cd_divisao_regiao,0) else @cd_divisao_regiao end)      
  and  cli.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then cli.cd_tipo_mercado else @cd_tipo_mercado end          
    
Group by DR.cd_divisao_regiao
Order by 2 desc    
    
  
  
declare @qt_total_setor int    
declare @vl_total_setor float    
    
-- Total de Setores    
set @qt_total_setor = @@rowcount    
    
-- Total de Vendas Geral dos Setores    
  
set @vl_total_setor = 0    
select @vl_total_setor = @vl_total_setor + venda    
from    
  #Venda
    
--Cria a Tabela Final de Vendas por Setor    
  
select IDENTITY(int, 1,1)      as 'Posicao',    
       a.Divisao,     
       Cast ((case when isnull(dr.sg_divisao_regiao,'') <>'' then dr.sg_divisao_regiao  else 'Pedido s/ Divisão de Região no Cadastro' end )  as varchar(45) ) as nm_divisao_regiao,
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
       isnull(a.pedidos,0)                       as 'pedidos'    
--       isnull(a.Meta,0)                          as 'Meta',    
--       case when a.Meta>0 then a.venda/a.Meta else 0 end * 100 as 'PercMeta'    
  
    
Into #VendaDivisao
from     
   #Venda a 
   left outer join  #Resumo_Clientes_Divisao c on  a.Divisao = c.Divisao     
   left outer join Divisao_Regiao   DR on DR.cd_divisao_regiao = c.Divisao
Order by     
  a.venda desc    
    
--Mostra tabela ao usuário    
    
select * from #VendaDivisao    
order by posicao  


------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------
/*
exec pr_venda_divisao_regiao
@dt_inicial = '01/01/2000',   
@dt_final = '01/01/2007',   
@cd_divisao_regiao   =0,    
@cd_moeda            = 1,    
@cd_tipo_mercado     = 0  

*/


