
-------------------------------------------------------------------------------
--sp_helptext pr_gera_pedidos_nextel
-------------------------------------------------------------------------------
--pr_gera_pedidos_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Douglas
--Banco de Dados   : Egissql
--             
--Objetivo         : Mostra os pedidos de venda gerados pelo EDI
--
--
--Data             : 01.01.2008
--Alteração        : 
-- 02.12.2008 - Ajustes Diversos - Carlos Fernandes
-- 22.01.2009 - Não mostrar caso o Pedido já estiver gerado - Carlos Fernandes
-- 02.09.2009 - Acerto do Status do Produto - Carlos Fernandes
--            - Condição de Pagamento - Carlos Fernandes
-- 05.03.2009 - Ajustes Diversos - Carlos Fernandes
-- 08.03.2010 - Consistência conforme Tabela - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_pedidos_nextel
@dt_Inicial   datetime,    
@dt_Final     datetime,    
@cd_pedido    int,    
@filtro       char(1),
@relatorio    char(1) = 'N',
@ic_parametro int     = 0
as

declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


--select * from pedido_venda_nextel
--select * from status_pedido_nextel
--select * from status_cliente

--Atualização da Tabela de Pedidos de Vendas que foram gerados na Entrada

--Atualiza a Tabela de Preço

update
 pedido_venda_nextel
set
 cd_tabela_preco = c.cd_tabela_preco

from
  pedido_venda_nextel p
  inner join cliente c         on c.cd_cliente         = p.cd_cliente

 where
   isnull(c.cd_tabela_preco,0) <> 0 and isnull(p.cd_tabela_preco,0) = 0


--0--> Zera todos os Status

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 0
from
  pedido_venda_nextel 

--1 --> Produto Inativo

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 1
from
  pedido_venda_nextel p
  inner join produto pro       on pro.cd_produto       = p.cd_produto
  inner join status_produto sp on sp.cd_status_produto = pro.cd_status_produto
where
  isnull(sp.ic_bloqueia_uso_produto,'N')='S'

--select * from status_produto

--2 --> Cliente Inativo

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 2
from
  pedido_venda_nextel p
  inner join cliente c         on c.cd_cliente         = p.cd_cliente
  inner join status_cliente sc on sc.cd_status_cliente = c.cd_status_cliente
where
  isnull(sc.ic_operacao_status_cliente,'S')='N'

--3 --> Data de Entrega

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 3
from
  pedido_venda_nextel p
where
  p.dt_entrega_pedido < @dt_hoje

--select * from pedido_venda_nextel

--4 --> Condição de Pagamento

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 4
from
  pedido_venda_nextel p
  inner join cliente c         on c.cd_cliente         = p.cd_cliente
where
  ( c.cd_condicao_pagamento <> p.cd_condicao_pagamento or isnull(c.cd_condicao_pagamento,0)=0 )

--5 --> Quantidade Múltiplo de Embalagem

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 5
from
  pedido_venda_nextel p
  inner join produto pro       on pro.cd_produto       = p.cd_produto
where
  (isnull(p.qt_item_pedido_venda_nextel,0)
  /
  isnull(pro.qt_multiplo_embalagem,1)
  - 
  cast( isnull(p.qt_item_pedido_venda_nextel,0)
  /
  isnull(pro.qt_multiplo_embalagem,1) as int )
  )
  <> 0

--select * from pedido_venda_nextel

--6 --> Preço fora da Tabela de Preço

update
  pedido_venda_nextel

set
  cd_status_pedido_nextel = 6

from
  pedido_venda_nextel p
  inner join produto pro       on pro.cd_produto       = p.cd_produto
  inner join cliente c         on c.cd_cliente         = p.cd_cliente
  left outer join tabela_preco_categoria_produto tp on tp.cd_tabela_preco      = c.cd_tabela_preco and
                                                       tp.cd_categoria_produto = pro.cd_categoria_produto

--select * from tabela_preco_categoria_produto

where
  p.vl_item_total_pedido <> tp.vl_tabela_preco

--7 --> Estoque Insuficiente

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 7

from
  pedido_venda_nextel p
  inner join produto pro           on pro.cd_produto       = p.cd_produto
  left outer join produto_saldo ps on ps.cd_fase_produto = pro.cd_fase_produto_baixa and
                                      ps.cd_produto      = pro.cd_produto
where
  isnull(ps.qt_saldo_reserva_produto,0)<p.qt_item_pedido_venda_nextel

--select * from pedido_venda_nextel
--select * from produto_saldo

--8 --> Pedido sem Cliente

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 8
from
  pedido_venda_nextel 

where
  isnull(cd_cliente,0)=0

--9 --> Pedido sem Condição de Pagamento

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 9

from
  pedido_venda_nextel 

where
  isnull(cd_condicao_pagamento,0)=0

--10 --> Pedido de Compra do Cliente

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 10

from
  pedido_venda_nextel pvn

where
  cast(pvn.cd_pedido_venda as varchar(40)) in ( select nm_referencia_consulta 
                                                    from 
                                                      pedido_venda with (nolock) 
                                                    where
                                                      dt_cancelamento_pedido is null and
                                                      nm_referencia_consulta  = cast(pvn.cd_pedido_venda as varchar(40) ))

--11 --> Cliente sem Tabela de Preço

update
  pedido_venda_nextel
set
  cd_status_pedido_nextel = 11
from
  pedido_venda_nextel p
  inner join cliente c         on c.cd_cliente         = p.cd_cliente
where
  isnull(c.cd_tabela_preco,0)=0

--select * from pedido_venda_nextel

select 

  ----- Itens da Tabela Principal (pedido_venda_nextel)

  pvn.cd_pedido_venda,         --
  pvn.cd_cliente,              --
  pvn.cd_vendedor,             --
  pvn.cd_nota_saida,           -- Não Existe
  pvn.dt_pedido_venda_nextel,  --
  isnull(pvn.qt_dia_pagamento,0)        as qt_dia_pagamento,        --
  pvn.cd_status_pedido_nextel,     --
  pvn.cd_produto,                  --
  pvn.qt_item_pedido_venda_nextel, ---
  pvn.vl_item_total_pedido,--
  pvn.cd_tabela_preco,--
  pvn.qt_itens_pedido_venda,--
  pvn.cd_usuario,--
  pvn.dt_usuario,--
  pvn.cd_item_pedido_venda,--
  pvn.ic_gerado_pedido_venda,--
  isnull(pvn.qt_item_pedido_venda_nextel,0) * isnull(pvn.vl_item_total_pedido,0) as VLTotal,

-----      

  c.nm_fantasia_cliente,        
  isnull(spn.nm_status_pedido_nextel,'Ok.') as nm_status_pedido_nextel,
  v.nm_fantasia_vendedor,        
  ltrim(rtrim(p.nm_produto))                as nm_produto, 
  p.vl_produto,       
  tp.nm_tabela_preco,  
  um.sg_unidade_medida,   
  cast(pvn.cd_cliente as varchar)     + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,  
  rtrim(ltrim(c.nm_endereco_cliente)) + ' '   + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro)) as endereco, 
  c.cd_ddd + ' ' +  c.cd_telefone as telefone,
  c.cd_cep,
  ci.nm_cidade,
  es.nm_estado,
  rtrim(ltrim(p.nm_fantasia_produto)) as nome_produto,

  cp.nm_condicao_pagamento,
  cpp.nm_condicao_pagamento           as nm_condicao_pedido,
  isnull(spn.ic_gera_pedido,'S')      as ic_gera_pedido,
  pvn.cd_unidade_medida,
  pvn.cd_condicao_pagamento 

into
  #pedido_venda_nextel     

from    
  pedido_venda_nextel                  pvn with(nolock)    
  left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto    
  left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente    
  left outer join status_cliente      sc   with(nolock) on sc.cd_status_cliente        = c.cd_status_cliente
  left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor    
  left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel
  left outer join tabela_preco         tp  with(nolock) on tp.cd_tabela_preco          = pvn.cd_tabela_preco
  left outer join cidade               ci  with(nolock) on ci.cd_cidade                = c.cd_cidade
  left outer join estado               es  with(nolock) on es.cd_estado                = c.cd_estado
  left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida        = p.cd_unidade_medida
  left outer join Condicao_Pagamento   cp  with(nolock) on cp.cd_condicao_pagamento    = pvn.cd_condicao_pagamento
  left outer join Condicao_Pagamento   cpp with(nolock) on cpp.cd_condicao_pagamento   = pvn.cd_condicao_pedido

where

--pedido_venda
--select * from pedido_venda where nm_referencia_consulta = '1445139'

  isnull(pvn.ic_gerado_pedido_venda,'N') = 'N' and

  --Checa a Referência do Pedido
  cast(pvn.cd_pedido_venda as varchar(40)) not in ( select nm_referencia_consulta 
                                                    from 
                                                      pedido_venda with (nolock) 
                                                    where
                                                      dt_cancelamento_pedido is null and
                                                      nm_referencia_consulta  = cast(pvn.cd_pedido_venda as varchar(40) ))

  and

  pvn.cd_item_pedido_venda <= (case when @relatorio = 'N' then 
                                 (select 
                                    min(cd_item_pedido_venda) 
                                  from 
                                    pedido_venda_nextel with (nolock) 
                                  where 
                                    cd_pedido_venda = pvn.cd_pedido_venda and
                                    cd_cliente      = pvn.cd_cliente      and
                                    cd_vendedor     = pvn.cd_vendedor     )
 
                               else 
                                  (select 
                                    max(cd_item_pedido_venda) 
                                  from 
                                    pedido_venda_nextel with (nolock) 
                                  where 
                                    cd_pedido_venda = pvn.cd_pedido_venda and
                                    cd_cliente      = pvn.cd_cliente      and
                                    cd_vendedor     = pvn.cd_vendedor     )
                               end) 

--Total

    select
      cd_pedido_venda,
      cd_cliente,
      cd_vendedor,
      sum( qt_item_pedido_venda_nextel )                        as qtd_total,
      sum( qt_item_pedido_venda_nextel * vl_item_total_pedido ) as valor_total

    into
      #SomaPedido

    from
      pedido_venda_nextel with (nolock) 

    group by
      cd_pedido_venda,
      cd_cliente,
      cd_vendedor


if @filtro = '1' 
  begin
    select 
      pn.*,
      sm.qtd_total,
      sm.valor_total 
    from 
      #pedido_venda_nextel pn
      inner join #SomaPedido sm on sm.cd_pedido_venda = pn.cd_pedido_venda and
                                   sm.cd_cliente      = pn.cd_cliente      and
                                   sm.cd_vendedor     = pn.cd_vendedor    
    where   
      pn.dt_pedido_venda_nextel between @dt_Inicial and @dt_Final 
    order by 
      pn.cd_pedido_venda, pn.cd_item_pedido_venda 

  end 
else
  if @filtro = '2' 
    begin
      select pn.* from #pedido_venda_nextel pn
            inner join #SomaPedido sm on sm.cd_pedido_venda = pn.cd_pedido_venda

      where    pn.cd_pedido_venda = @cd_pedido
      order by pn.cd_pedido_venda, pn.cd_item_pedido_venda
    end
  else
    select pn.* from #pedido_venda_nextel pn
    inner join #SomaPedido sm on sm.cd_pedido_venda = pn.cd_pedido_venda

    where    pn.dt_pedido_venda_nextel between @dt_Inicial and @dt_Final and 
                                            pn.cd_pedido_venda = @cd_pedido
    order by pn.cd_pedido_venda, pn.cd_item_pedido_venda 

