
CREATE PROCEDURE pr_venda_segmento_mercado  
  
------------------------------------------------------------------------------------------------------  
--pr_venda_segmento_mercado  
------------------------------------------------------------------------------------------------------  
--GBS - Global Business Solution        2002  
--Stored Procedure: Microsoft SQL Server       2000  
--Autor(es)       : Daniel Carrasco Neto  
--Banco de Dados  : EgisSQL  
--Objetivo        : Consulta Vendas no Período por Segmento de Mercado.  
--Data            : 05/09/2002  
--Atualizado      : 05/11/2003 - Inclusão de consulta por moeda.  
--                  20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar  
--                             - Daniel C. Neto.  
--                  02.05.2006 - Acertos Diversos   
--                  25.05.2006 - Acerto da Query para trazer os segmentos não Cadastrados - Carlos Fernandes  
--                  29.05.2006 - Melhoria de performance para retorno da procedure - Ludinei
--                  06.06.2006 - Potencial, Qtd. Clientes, Qtd. Vendedores e Qtd. Pedidos - Carlos Fernandes
--                  19.07.2006 - Acertos da retirada do código - Carlos Fernandes
-- 01.02.2010 - Bate de Valores com o Ranking de Cliente - Carlos Fernandes
------------------------------------------------------------------------------------------------------------  
  
@cd_ramo_atividade int = 0,  
@dt_inicial        datetime,  
@dt_final          datetime,  
@cd_moeda          int = 1  
  
as  
  
declare @vl_moeda float  
  
set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                  else dbo.fn_vl_moeda(@cd_moeda) end )  
  
-- Geração da tabela auxiliar de Vendas por Segmento  
  
select   
        isnull(cli.cd_ramo_atividade,0)               as 'ramo',   
        sum(b.qt_item_pedido_venda)                   as 'Qtd',  
        sum(b.qt_item_pedido_venda *   
            b.vl_unitario_item_pedido / @vl_moeda)    as 'Venda',   
        max(a.dt_pedido_venda)                        as 'UltimaVenda',  
        count(a.cd_pedido_venda)                      as 'pedidos',
        count(distinct a.cd_cliente)                  as 'QtdCliente',
        count(distinct a.cd_vendedor)                 as 'QtdVendedor'  

into #VendaGrupoAux  
from  
   Pedido_Venda a                 with (nolock)  
   inner join Pedido_Venda_Item b with (nolock) on a.cd_pedido_venda = b.cd_pedido_venda   
   inner join Cliente cli         with (nolock) on cli.cd_cliente    = a.cd_cliente  

where  
   (cli.cd_ramo_atividade  = case when @cd_ramo_atividade = 0 then 
		cli.cd_ramo_atividade else @cd_ramo_atividade end )     and  
   (a.dt_pedido_venda between @dt_inicial and @dt_final )     and  

-- Motivo de tirar a linha abaixo : Quando cancelado um PV, todos os itens são cancelados
--   (isnull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final) and  
    isnull(a.vl_total_pedido_venda,0) > 0                     and  
    isnull(a.ic_consignacao_pedido,'N') = 'N'                 and  
   --(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda ) > 0         and  
   (isnull(b.dt_cancelamento_item,@dt_final+1) > @dt_final)   and  
    isnull(b.ic_smo_item_pedido_venda,'N')    = 'N'                                  
    and isnull(a.ic_amostra_pedido_venda,'N') <>'S'
    and isnull(a.ic_garantia_pedido_venda,'N')<>'S'
    and isnull(b.cd_produto_servico,0)   = 0                     

--    (cli.cd_ramo_atividade  = case when @cd_ramo_atividade = 0 then cli.cd_ramo_atividade else @cd_ramo_atividade end ) and  
--    (a.dt_pedido_venda between @dt_inicial and @dt_final )           and  
--    ((a.dt_cancelamento_pedido is null ) or   
--    (a.dt_cancelamento_pedido > @dt_final))                          and  
--     isnull(a.vl_total_pedido_venda,0) > 0                                     and  
--     isnull(a.ic_consignacao_pedido,'N') = 'N'                       and  
--    (b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda ) > 0         and  
--    ((b.dt_cancelamento_item is null ) or   
--    (b.dt_cancelamento_item > @dt_final))                          and  
--     isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                  
  
Group by   
  cli.cd_ramo_atividade  

order  by 1 desc  
  
--select * from #VendaGrupoAux  
  
-------------------------------------------------  
-- calculando Potencial.  
-------------------------------------------------  
select   
        isnull(cli.cd_ramo_atividade,0)                                         as cd_ramo_atividade,   
        sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda )    as 'Potencial'  
  
into #Potencial  
from  
   Pedido_Venda a inner join  
   Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda inner join  
   Cliente cli on cli.cd_cliente = a.cd_cliente  
where  
-- Motivo de tirar a linha abaixo : Quando cancelado um PV, todos os itens são cancelados
--   (isnull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final) and  
    a.dt_pedido_venda < @dt_final-365                         and  
    isnull(a.vl_total_pedido_venda,0) > 0                     and  
    isnull(a.ic_consignacao_pedido,'N') = 'N'                 and  
   --(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda ) > 0         and  
   (isnull(b.dt_cancelamento_item,@dt_final+1) > @dt_final)   and  
    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                  
    and isnull(a.ic_amostra_pedido_venda,'N') <>'S'
    and isnull(a.ic_garantia_pedido_venda,'N')<>'S'
    and isnull(b.cd_produto_servico,0)   = 0                     

--    (cli.cd_ramo_atividade  = case when @cd_ramo_atividade = 0 then cli.cd_ramo_atividade else @cd_ramo_atividade end ) and  
--    (a.dt_pedido_venda between @dt_inicial and @dt_final )           and  
--    ((a.dt_cancelamento_pedido is null ) or   
--    (a.dt_cancelamento_pedido > @dt_final))                          and  
--     isnull(a.vl_total_pedido_venda,0) > 0                                     and  
--     isnull(a.ic_consignacao_pedido,'N') = 'N'                       and  
--    (b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda ) > 0         and  
--    ((b.dt_cancelamento_item is null ) or   
--    (b.dt_cancelamento_item > @dt_final))                          and  
--     isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                  
  
Group by cli.cd_ramo_atividade  
order  by 1 desc  
  
----------------------------------  
-- Fim da seleção de vendas totais  
----------------------------------  
  
declare @qt_total_grupo int  
declare @vl_total_grupo float  
  
-- Total de Grupos  
set @qt_total_grupo = @@rowcount  
  
-- Total de Vendas Geral por Grupo  
set    @vl_total_grupo = 0  
  
select @vl_total_grupo = @vl_total_grupo + venda  
from  
  #VendaGrupoAux  
  
--Cria a Tabela Final de Vendas por Grupo  
  
  
select IDENTITY(int,1,1)                                   as 'Posicao',  
       a.ramo                                              as cd_ramo_atividade,  
       --isnull(b.nm_ramo_atividade,'Não Cadastrado :' )+' '+cast(a.ramo as varchar(4)) as nm_ramo_atividade,  
       b.nm_ramo_atividade,
       a.venda,   
       cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc',  
       c.Potencial                                          as 'Potencial',
       a.pedidos,
       a.qtdCliente,
       a.qtdVendedor       
  
Into   
  #VendaGrupo  

from   
  #VendaGrupoAux a  
   left outer join Ramo_Atividade b on b.cd_ramo_atividade = a.ramo  
   left outer join #Potencial     c on c.cd_ramo_atividade = a.ramo  

--Where  
   --a.ramo = b.cd_ramo_atividade   
  
order by a.Venda desc  
  
select * from #VendaGrupo    
order by Posicao

