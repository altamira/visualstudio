
--------------------------------------------------------------------------------------
--pr_venda_cliente1
--------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                            2008
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei  / Carlos Cardoso Fernandes       
--Consulta do Total de Vendas por Cliente
--Data         : 05.07.2000 - Lucio (Trocada para Período)
--             : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--             : 14.08.2001 - Alteração Campo Setor : Pegar do cliente (não do pedido)
--             : 06.04.2002 - Alterado para o padrão do EGIS-Sandro Campos
--             : 03/09/2002 - Incluido o código do Cliente - Daniel C. Neto.
--             : 19/09/2002 - Acertado para pegar cd_vendedor da tabela Pedido_Venda. - Daniel C. Neto.
--             : 30/10/2002 - Correção dos joins
--               10/11/2003 -  Incluído novas colunas. - Daniel C. Neto.
--               30/02/2004 - Acerto na consulta para bater com os valores do SPE - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 02/09/2005 - Margem de Contribuição - Carlos Fernandes
-- 14.03.2006 - Filtro por Tipo de Mercado - Carlos Fernandes
-- 16.03.2006 - Colocar o Tipo de Mercado na Grid - Carlos / Danilo
-- 06.06.2006 - Comparativo de Valores - Carlos Fernandes
-- 04.06.2007 - Cliente Origem - Carlos Fernandes
-- 07.01.2008 - Verificação do Vendedor, porque alguns casos some o nome fantasia - Carlos Fernandes
-- 27.03.2008 - Ajuste da rotina da cliente origem - Carlos Fernandes
-- 09.04.2008 - Inclusão do Ramo de Atividade/Segmento - Carlos Fernandes
-- 11.10.2008 - Ajustes Diversos - Carlos Fernandes
-- 25.03.2009 - Ajuste do Vendedor do Cliente - Carlos Fernandes
-- 10.08.2009 - Pedidos de Amostra não é considerado venda - Carlos Fernandes
------------------------------------------------------------------------------------------------------

create procedure pr_venda_cliente1
@dt_inicial          datetime,
@dt_final            datetime,
@cd_moeda            int,
@cd_tipo_mercado     int = 0,
@ic_comparativo      char(1) = 'N',
@ic_tipo_comparativo int     = 0   --1 : Inclusão / --2 : Alteração
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por Cliente

select 
  vw.nm_fantasia_cliente                                            as 'Cliente', 
  vw.cd_cliente,
  sum(qt_item_pedido_venda * (vl_unitario_item_pedido / @vl_moeda)) as 'Compra', 
  cast(sum(dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda*
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
  cast(sum((qt_item_pedido_venda *
           (vl_lista_item_pedido / @vl_moeda)
          )
      ) as decimal(25,2)) as 'TotalLiSta',
  cast(sum( ( (qt_item_pedido_venda * case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end  ) / @vl_moeda) ) as decimal(25,2) ) as 'CustoContabil',

  cast(sum((qt_item_pedido_venda* case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end / @vl_moeda))  /
       sum((dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda *
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)))	as decimal(25,2)) * 100                                                       as 'MargemContribuicao',
  cast(sum((qt_item_pedido_venda* case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',

  max(dt_pedido_venda)                                         as 'UltimaCompra', 
  count(distinct cd_pedido_venda)                              as 'pedidos',

  --Vendedor ( não pode ser utilizado devido ao grupo by )

--   (select max(v.nm_fantasia_vendedor)
--    from Vendedor v
--    where
--       v.cd_vendedor = vw.cd_vendedor)                            as 'setor',

  isnull(max(vw.nm_vendedor_externo),
        (select max(v.nm_fantasia_vendedor)
         from 
           Cliente c with (nolock) 
           inner join vendedor v on c.cd_vendedor = v.cd_vendedor
         where
           c.cd_cliente = vw.cd_cliente))                      as 'setor',

   max(vw.nm_tipo_mercado)                                     as nm_tipo_mercado,
   max(vw.nm_ramo_atividade)                                   as nm_ramo_atividade,
   max(vw.nm_pais)                                             as nm_pais,
   max(vw.nm_estado)                                           as nm_estado,
   max(vw.nm_cidade)                                           as nm_cidade,
   max(vw.nm_cliente_regiao)                                   as nm_cliente_regiao,
   max(cc.nm_classificacao_cliente)                            as nm_classificacao_cliente

--  (select max(v.nm_fantasia_vendedor)
--   from vendedor v
--   where v.cd_vendedor = max(vw.cd_vendedor))                 as 'setor'

into #VendaClienteAux1

from 
  vw_venda_bi vw 
  left outer join Agrupamento_Cliente ac on ac.cd_cliente = vw.cd_cliente
  left outer join Classificacao_cliente cc on cc.cd_classificacao_cliente = ac.cd_classificacao_cliente

where
 (vw.dt_pedido_venda between @dt_inicial and @dt_final) 
 and 
 vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end
 and isnull(vw.ic_amostra_pedido_venda ,'N') <>'S'
 and isnull(vw.ic_garantia_pedido_venda,'N') <>'S'
 --and isnull(vw.ic_consignacao_pedido,'N') = 'N'                       

--select * from vw_venda_bi
 
group by 
  vw.nm_fantasia_cliente, vw.cd_cliente

order by 
	Compra desc

--select * from vw_venda_bi

declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set    @vl_total_cliente = 0

select @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteAux1

--Define tabela com Total Geral de Venda Ano
--select @vl_total_cliente as 'TOTALANO' 
--into ##TotalVendaAno

--Cria a Tabela Final de Vendas por Cliente
-- Define a posição de Compra do Cliente - IDENTITY

select IDENTITY(int, 1,1) as 'Posicao',
       cd_cliente,
       Cliente, 
       Compra, 
       TotalLiquido,
       TotalLista,
       CustoContabil,
       MargemContribuicao,
       BNS,
       cast(((Compra / @vl_total_cliente ) * 100) as decimal (25,2)) as 'Perc',
       UltimaCompra,
       setor, 
       pedidos,
--     cast((( TotalLista / Compra ) * 100) - 100 as decimal (15,2)) as 'Desc',
      cast( 100-( ( Compra/TotalLista ) * 100) as decimal (15,2)) as 'Desc',
       nm_tipo_mercado,
       nm_ramo_atividade,
       nm_pais,
       nm_estado,
       nm_cidade,
       nm_cliente_regiao,
       nm_classificacao_cliente

Into 
  #VendaCliente1
from 
  #VendaClienteAux1

Order by 
     Compra desc

--Mostra tabela ao usuário

select 
  * 
from 
  #VendaCliente1
order by 
  posicao

--Carga Comparativo e Inclusão

declare @cd_posicao int
declare @cd_cliente int
declare @nm_cliente varchar(40)
declare @vl_total   float

if @ic_comparativo='S' and @ic_tipo_comparativo = 1
begin

   while exists ( select top 1 posicao from #VendaCliente1 )
   begin
     select top 1
       @cd_posicao = posicao,
       @cd_cliente = cd_cliente,
       @nm_cliente = cliente,
       @vl_total   = compra
     from #VendaCliente1

     exec  pr_geracao_comparativo
       @ic_parametro     = 1,          
       @nm_comparativo   = @nm_cliente,
       @vl_total         = @vl_total,               
       @cd_posicao_atual = @cd_posicao,
       @cd_localizacao   = @cd_cliente

     delete from #VendaCliente1 where posicao = @cd_posicao 

   end
    
   
end

--Carga Comparativo e Alteração

if @ic_comparativo='S' and @ic_tipo_comparativo = 2
begin

   while exists ( select top 1 posicao from #VendaCliente1 )
   begin
     select top 1
       @cd_posicao = posicao,
       @cd_cliente = cd_cliente,
       @nm_cliente = cliente,
       @vl_total   = compra
     from #VendaCliente1

     exec  pr_geracao_comparativo
       @ic_parametro        = 2,          
       @nm_comparativo      = @nm_cliente,
       @vl_comparativo      = @vl_total,               
       @cd_posicao_anterior = @cd_posicao,
       @cd_localizacao      = @cd_cliente

     delete from #VendaCliente1 where posicao = @cd_posicao 

   end
    
   
end

