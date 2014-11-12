
--------------------------------------------------------------------------------------------------------------
--pr_analise_cotacao_compra
--------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)	      	: Daniel C. Neto.
--Banco de Dados  	: EGISSQL
--Objetivo	      	: Verifica a melhor cotação de uma requisição de compra.
--Data		        	: 09/11/2004
-- 17/12/2004 - Permitido consulta de requisições de serviço. - Daniel C. Neto.
-- 20/12/2004 - Verificação para pegar somente o top 1 das subqueries - Daniel C. Neto.
-- 27/12/2004 - Incluída Verificação para não considerar preço Zero como melhor cotação. - ELIAS
-- 05.07.2006 - Verificação Geral - Carlos Fernandes
-- 15/08/2006 - Mudado Vlr. Desc para Vlr. com Desc. , incluído vl_desconto_item no valor da cotação - Daniel Carrasco Neto.
-- 31/08/2006 - Modificado label do valor da cotação para economizar espaço. - Daniel C. neto.
-- 08.08.2007 - Verificação para 04 fornecedores - Carlos Fernandes
-- 08.09.2007 - Impostos - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_analise_cotacao_compra
@cd_requisicao_compra int = 0

as

declare @ic_servico_tipo_requisicao char(1)

set @ic_servico_tipo_requisicao = ( select tr.ic_servico_tipo_requisicao
                                    from Requisicao_Compra rc inner join
                                         tipo_requisicao tr on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao
                                    where cd_requisicao_compra = @cd_requisicao_compra )

select  distinct
  r.cd_requisicao_compra,
  r.cd_item_requisicao_compra as cd_item_requisicao,
  r.cd_produto,
  IsNull(p.nm_fantasia_produto, s.nm_servico) as nm_fantasia_produto,
  un.sg_unidade_medida,
  ci.qt_item_cotacao,
  cf.pc_ipi_classificacao,
  pf.pc_aliquota_icms_produto,
  cast(null as varchar(100)) as vl_fornecedor_1,
  cast(null as varchar(100)) as vl_fornecedor_2,
  cast(null as varchar(100)) as vl_fornecedor_3,
  cast(null as varchar(100)) as vl_fornecedor_4,
  cast(null as varchar(100)) as vl_fornecedor_5,
  cast(null as varchar(100)) as vl_fornecedor_6,
  cast(null as varchar(100)) as vl_fornecedor_7,
  cast(null as varchar(100)) as vl_fornecedor_8,
  cast(0    as int )         as cd_cotacao_1,
  cast(0    as int )         as cd_cotacao_2,
  cast(0    as int )         as cd_cotacao_3,
  cast(0    as int )         as cd_cotacao_4,
  cast(0    as int )         as cd_cotacao_5,
  cast(0    as int )         as cd_cotacao_6,
  cast(0    as int )         as cd_cotacao_7,
  cast(0    as int )         as cd_cotacao_8,
  cast(0    as int )         as cd_item_cotacao_1,
  cast(0    as int )         as cd_item_cotacao_2,
  cast(0    as int )         as cd_item_cotacao_3,
  cast(0    as int )         as cd_item_cotacao_4,
  cast(0    as int )         as cd_item_cotacao_5,
  cast(0    as int )         as cd_item_cotacao_6,
  cast(0    as int )         as cd_item_cotacao_7,
  cast(0    as int )         as cd_item_cotacao_8,
  cast(null as datetime)     as dt_entrega_1,
  cast(null as datetime)     as dt_entrega_2,
  cast(null as datetime)     as dt_entrega_3,
  cast(null as datetime)     as dt_entrega_4,
  cast(null as datetime)     as dt_entrega_5,
  cast(null as datetime)     as dt_entrega_6,
  cast(null as datetime)     as dt_entrega_7,
  cast(null as datetime)     as dt_entrega_8,
  cast(0    as float)        as pc_desconto_1,
  cast(0    as float)        as pc_desconto_2,
  cast(0    as float)        as pc_desconto_3,
  cast(0    as float)        as pc_desconto_4,
  cast(0    as float)        as pc_desconto_5,
  cast(0    as float)        as pc_desconto_6,
  cast(0    as float)        as pc_desconto_7,
  cast(0    as float)        as pc_desconto_8,
  cast(0    as int)          as cd_condicao_pagamento


into #Produto_Preco

from
  requisicao_compra_item r                with (nolock)
  inner join Cotacao_Item ci              with (nolock) on ci.cd_requisicao_compra      = r.cd_requisicao_compra and
                                                          ci.cd_item_requisicao_compra = r.cd_item_requisicao_compra 
  left outer join Produto p               with (nolock) on p.cd_produto = r.cd_produto                             
  left outer join Unidade_Medida un       with (nolock) on un.cd_unidade_medida = p.cd_unidade_medida               
  left outer join Servico s               with (nolock) on s.cd_servico = r.cd_servico
  left outer join Produto_Fiscal pf       with (nolock) on pf.cd_produto = p.cd_produto
  left outer join Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
where
  r.cd_requisicao_compra = @cd_requisicao_compra
order by
  p.nm_fantasia_produto

--select * from classificacao_fiscal
--select * from produto_fiscal

declare @cd_item_max int

set @cd_item_max = (select max(cd_item_requisicao) from #Produto_Preco) + 1

select * into #Temp from #Produto_Preco

--select * from #Temp

insert into #Produto_Preco
  values ( 0,
           @cd_item_max,
           0,
           '',
           '',
           0,
        cast(null as float),
        cast(null as float),  
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(null as varchar(20)),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(0    as int),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as int))

  insert into #Produto_Preco
  values ( 0,
           @cd_item_max + 1,
           0,
           'TOTAL DA COMPRA',
           '',
           0,
          cast(null as float),
          cast(null as float),  
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)),
          cast(null as varchar(20)), 
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
          cast(0    as int),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(null as datetime),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as float),
        cast(0    as int))

--select * from #Produto_preco

declare @cd_item_requisicao int,
        @vl_fornecedor_1 float,
        @vl_fornecedor_2 float,
        @vl_fornecedor_3 float,
        @vl_fornecedor_4 float,
        @vl_fornecedor_5 float,
        @vl_fornecedor_6 float,
        @vl_fornecedor_7 float,
        @vl_fornecedor_8 float,
        @vl_melhor_preco float

select distinct top 8
    ci.cd_requisicao_compra,
    c.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    ci.cd_produto,
    ci.cd_cotacao,
    ci.cd_item_cotacao,
    ci.dt_entrega_item_cotacao
into 
    #Fornecedor_Requisicao1
from
    cotacao_item ci 
    left outer join cotacao c    on ci.cd_cotacao   = c.cd_cotacao
    left outer join fornecedor f on f.cd_fornecedor = c.cd_fornecedor
where
    ci.cd_requisicao_compra = @cd_requisicao_compra --  and
order by nm_fantasia_fornecedor

select 
  identity(int,1,1)               as cd_chave, 
  nm_fantasia_fornecedor,
  max(cd_fornecedor)              as cd_fornecedor,
  max(cd_cotacao)                 as cd_cotacao,
  max(cd_item_cotacao)            as cd_item_cotacao,
  max(dt_entrega_item_cotacao)    as dt_entrega_item_cotacao
into 
  #Fornecedor_Requisicao
from 
  #Fornecedor_Requisicao1
group by 
  nm_fantasia_fornecedor
order by
  nm_fantasia_fornecedor


--select * from #Fornecedor_Requisicao

while exists ( select 'x' from #Temp )
begin

  set @cd_item_requisicao = ( select top 1 cd_item_requisicao from #Temp)

  select top 8
    ci.cd_requisicao_compra,
    c.cd_cotacao,
    ci.cd_item_cotacao,
    c.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    ci.cd_produto,
    ci.vl_item_cotacao,
    pc_desconto_item_cotacao,
    IsNull(ci.vl_item_cotacao,0) - ( IsNull((ci.vl_item_cotacao * (ci.pc_desconto_item_cotacao/100)),0) )
as vl_item_desconto,
--    0 as vl_total,
  (  ( IsNull(ci.vl_item_cotacao,0) -
    IsNull((ci.vl_item_cotacao * (pc_desconto_item_cotacao/100)),0) ) + 

    ( IsNull(ci.vl_item_cotacao,0) -
    IsNull((ci.vl_item_cotacao * (pc_desconto_item_cotacao/100)),0) )
      * pc_ipi_item_cotacao / 100  )  * qt_item_cotacao 

 as vl_total,

--    ((ci.vl_item_cotacao) * pc_ipi_item_cotacao / 100) * qt_item_cotacao  as vl_total,
    (select sum(
                  (  ( IsNull(xi.vl_item_cotacao,0) -
                       IsNull((xi.vl_item_cotacao * (xi.pc_desconto_item_cotacao/100)),0) ) + 
          
                     ( IsNull(xi.vl_item_cotacao,0) -
                       IsNull((xi.vl_item_cotacao * (xi.pc_desconto_item_cotacao/100)),0) )
                       * xi.pc_ipi_item_cotacao / 100  )  * xi.qt_item_cotacao )
     from Cotacao_Item xi 
     where
       xi.cd_cotacao = ci.cd_cotacao ) as vl_total_cotacao
  into #Fornecedor_Valor
  from
    cotacao_item ci 
  left outer join cotacao    c on ci.cd_cotacao   = c.cd_cotacao
  left outer join fornecedor f on f.cd_fornecedor = c.cd_fornecedor
  where
    ci.cd_requisicao_compra      = @cd_requisicao_compra and
    ci.cd_item_requisicao_compra = @cd_item_requisicao
  order by -- Prestar atenção nesse nome fantasia, este será o campo para relacionar na tela depois
    f.nm_fantasia_fornecedor

  --select * from #Fornecedor_Requisicao
  --select * from #Fornecedor_Valor

  set @vl_fornecedor_1 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor        = fr.cd_fornecedor        
                                                                           where fr.cd_chave = 1)

  set @vl_fornecedor_2 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor        = fr.cd_fornecedor 
                                                                           where fr.cd_chave = 2)
  set @vl_fornecedor_3 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor               
                                                                            where fr.cd_chave = 3)
  set @vl_fornecedor_4 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor                
                                                                             where fr.cd_chave = 4)
  set @vl_fornecedor_5 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor 
                                                                             where fr.cd_chave = 5)
  set @vl_fornecedor_6 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor 
                                                                             where fr.cd_chave = 6)
  set @vl_fornecedor_7 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor
                                                                             where fr.cd_chave = 7)
  set @vl_fornecedor_8 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor 
                                                                             where fr.cd_chave = 8)

  set @vl_melhor_preco = ( select min(IsNull(case when (vl_total <> 0) then vl_total else 999999999 end,0)) from #Fornecedor_Valor fv inner join
                                                                             #Fornecedor_Requisicao fr on
                                                                              fv.cd_fornecedor = fr.cd_fornecedor )

--   select @vl_fornecedor_1
--   select @vl_melhor_preco

  update #Produto_Preco
  set vl_fornecedor_1 = ( case when @vl_melhor_preco = @vl_fornecedor_1 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_1 as decimal(25,2)) as varchar(20))+						  
								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor 
                                                                          where fr.cd_chave = 1),
      vl_fornecedor_2 = ( case when @vl_melhor_preco = @vl_fornecedor_2 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_2 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor 
                                                                          where fr.cd_chave = 2),

      vl_fornecedor_3 = ( case when @vl_melhor_preco = @vl_fornecedor_3 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_3 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 3),

      vl_fornecedor_4 = ( case when @vl_melhor_preco = @vl_fornecedor_4 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_4 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 4),

      vl_fornecedor_5 = ( case when @vl_melhor_preco = @vl_fornecedor_5 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_5 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 5),

      vl_fornecedor_6 = ( case when @vl_melhor_preco = @vl_fornecedor_6 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_6 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 6),

      vl_fornecedor_7 = ( case when @vl_melhor_preco = @vl_fornecedor_7 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_7 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 7),

      vl_fornecedor_8 = ( case when @vl_melhor_preco = @vl_fornecedor_8 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_8 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl.Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl.c/Desc.= ' +
								  Cast(Cast(vl_item_desconto as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 8),

      --Cotação

      cd_cotacao_1 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 1),
      cd_cotacao_2 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 2),
      cd_cotacao_3 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 3),
      cd_cotacao_4 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 4),
      cd_cotacao_5 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 5),
      cd_cotacao_6 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 6),
      cd_cotacao_7 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 7),
      cd_cotacao_8 = ( select top 1 cast(cd_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 8),

      --Item da Cotação

      cd_item_cotacao_1 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 1),
      cd_item_cotacao_2 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 2),
      cd_item_cotacao_3 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 3),
      cd_item_cotacao_4 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 4),
      cd_item_cotacao_5 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 5),
      cd_item_cotacao_6 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 6),
      cd_item_cotacao_7 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 7),
      cd_item_cotacao_8 = ( select top 1 cast(cd_item_cotacao as int) from #Fornecedor_Requisicao fr where cd_chave = 8),

      --Data de Entrega do Item

      dt_entrega_1 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 1),
      dt_entrega_2 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 2),
      dt_entrega_3 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 3),
      dt_entrega_4 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 4),
      dt_entrega_5 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 5),
      dt_entrega_6 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 6),
      dt_entrega_7 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 7),
      dt_entrega_8 = ( select top 1 cast(dt_entrega_item_cotacao as datetime) from #Fornecedor_Requisicao fr where cd_chave = 8)

  where cd_item_requisicao = @cd_item_requisicao

  update #Produto_Preco
  set vl_fornecedor_1 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 1),
      vl_fornecedor_2 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 2),
      vl_fornecedor_3 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 3),
      vl_fornecedor_4 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 4),
      vl_fornecedor_5 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 5),
      vl_fornecedor_6 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 6),
      vl_fornecedor_7 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 7),
      vl_fornecedor_8 = ( select top 1 cast(vl_total_cotacao as decimal(25,2)) from #Fornecedor_Valor fv inner join 
                                                       #Fornecedor_Requisicao fr on fr.cd_fornecedor = fv.cd_fornecedor where cd_chave = 8)

  where cd_item_requisicao = @cd_item_max + 1

  drop table #Fornecedor_Valor

  delete from #Temp where cd_item_requisicao = @cd_item_requisicao

end

--Mostra a Tabela final

select 
  pr.*, p.nm_produto as Descricao 
from 
  #Produto_Preco Pr 
  left outer join Produto p on p.cd_produto = pr.cd_produto 
order by 
  pr.cd_item_requisicao

