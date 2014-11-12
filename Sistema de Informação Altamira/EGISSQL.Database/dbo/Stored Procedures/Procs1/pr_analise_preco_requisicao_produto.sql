
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--pr_analise_preco_requisicao_produto
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Carlos Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Verifica as opções de Produto para a Requisição de Compra
--                        sem a necessidade de cotação
--
--Data			: 11/04/2006
--
--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

CREATE PROCEDURE pr_analise_preco_requisicao_produto
@cd_requisicao_compra int

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
  0.00                       as qt_item_cotacao,
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
  requisicao_compra_item r 
  inner join Produto p on p.cd_produto = r.cd_produto left outer join
  Unidade_Medida un on un.cd_unidade_medida = p.cd_unidade_medida left outer join
  Servico s on s.cd_servico = r.cd_servico
where
  r.cd_requisicao_compra = @cd_requisicao_compra
order by
  p.nm_fantasia_produto

declare @cd_item_max int

set @cd_item_max = (select max(cd_item_requisicao) from #Produto_Preco) + 1

select * into #Temp from #Produto_Preco

insert into #Produto_Preco
  values ( 0,
           @cd_item_max,
           0,
           '',
           '',
           0,
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

--select * from requisicao_compra_item

select distinct top 8
    fp.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    ci.cd_requisicao_compra          as cd_cotacao,
    ci.cd_item_requisicao_compra     as cd_item_cotacao,
    ci.dt_item_nec_req_compra        as dt_entrega_item_cotacao
into
     #Fornecedor_Requisicao1
from
  requisicao_compra_item ci 
  inner join      requisicao_compra c   on ci.cd_requisicao_compra   = c.cd_requisicao_compra
  left outer join fornecedor_produto fp on fp.cd_produto             = ci.cd_produto
  left outer join fornecedor f          on f.cd_fornecedor           = fp.cd_fornecedor
where
    ci.cd_requisicao_compra = @cd_requisicao_compra --  and
order by 
    nm_fantasia_fornecedor

select identity(int,1,1) as cd_chave, 
  * 
into 
  #Fornecedor_Requisicao  
from #Fornecedor_Requisicao1


--Montagem da Tabela Auxiliar com valores de última compra do Produto / Fornecedor

select
  top 1
  fp.cd_fornecedor,
  fp.cd_produto,       
  pci.qt_item_pedido_compra, 
  pci.vl_item_unitario_ped_comp, 
  pci.vl_total_item_pedido_comp, 
  pci.pc_item_descto_ped_compra as Perc_Desc,
  (pci.vl_total_item_pedido_comp * pci.pc_item_descto_ped_compra / 100) as Desconto,
  pci.vl_total_item_pedido_comp - (pci.vl_total_item_pedido_comp * pci.pc_item_descto_ped_compra / 100) as Liquido,
  pci.pc_ipi                    as Perc_Ipi
into
  #Fornecedor_Compra  
from
  requisicao_compra_item ci  
  inner join requisicao_compra c         on ci.cd_requisicao_compra   = c.cd_requisicao_compra
  left outer join fornecedor_produto fp  on fp.cd_produto             = ci.cd_produto
  left outer join fornecedor f           on f.cd_fornecedor           = fp.cd_fornecedor
  left outer join pedido_compra pc       on pc.cd_fornecedor          = fp.cd_fornecedor  
  left outer join pedido_compra_item pci on pci.cd_pedido_compra      = pc.cd_pedido_compra

order by
  pci.dt_item_pedido_compra desc

while exists ( select 'x' from #Temp )
begin

  set @cd_item_requisicao = ( select top 1 cd_item_requisicao from #Temp)

  --select * from fornecedor_produto
   
  select top 8
    fp.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    0.00 as vl_item_cotacao,
    0.00 as pc_desconto_item_cotacao,
    0.00 as vl_total,
    0.00 as vl_total_cotacao

  into #Fornecedor_Valor
  from
    requisicao_compra_item  ci 
    left outer join requisicao_compra c   on ci.cd_requisicao_compra = c.cd_requisicao_compra
    left outer join fornecedor_produto fp on fp.cd_produto = ci.cd_produto
    left outer join fornecedor f          on f.cd_fornecedor = fp.cd_fornecedor
  where
    ci.cd_requisicao_compra      = @cd_requisicao_compra and
    ci.cd_item_requisicao_compra = @cd_item_requisicao
  order by -- Prestar atenção nesse nome fantasia, este será o campo para relacionar na tela depois
    f.nm_fantasia_fornecedor

  set @vl_fornecedor_1 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 1)
  set @vl_fornecedor_2 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 2)
  set @vl_fornecedor_3 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where cd_chave = 3)
  set @vl_fornecedor_4 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 4)
  set @vl_fornecedor_5 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 5)
  set @vl_fornecedor_6 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 6)
  set @vl_fornecedor_7 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 7)
  set @vl_fornecedor_8 = ( select top 1 vl_total from #Fornecedor_Valor fv inner join
                                                #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 8)
  set @vl_melhor_preco = ( select min(IsNull(case when (vl_total <> 0) then vl_total else 999999999 end,0)) from #Fornecedor_Valor)


  update #Produto_Preco
  set vl_fornecedor_1 = ( case when @vl_melhor_preco = @vl_fornecedor_1 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_1 as decimal(25,2)) as varchar(20))+
								  
								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 1),
      vl_fornecedor_2 = ( case when @vl_melhor_preco = @vl_fornecedor_2 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_2 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 2),

      vl_fornecedor_3 = ( case when @vl_melhor_preco = @vl_fornecedor_3 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_3 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 3),

      vl_fornecedor_4 = ( case when @vl_melhor_preco = @vl_fornecedor_4 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_4 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 4),

      vl_fornecedor_5 = ( case when @vl_melhor_preco = @vl_fornecedor_5 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_5 as decimal(25,2)) as varchar(20))+
								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 5),

      vl_fornecedor_6 = ( case when @vl_melhor_preco = @vl_fornecedor_6 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_6 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 6),

      vl_fornecedor_7 = ( case when @vl_melhor_preco = @vl_fornecedor_7 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_7 as decimal(25,2)) as varchar(20))+

								( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
                          from #Fornecedor_Valor fv inner join
                          #Fornecedor_Requisicao fr on fv.cd_fornecedor = fr.cd_fornecedor where fr.cd_chave = 7),

      vl_fornecedor_8 = ( case when @vl_melhor_preco = @vl_fornecedor_8 then '*' else '' end ) +
                          cast(cast(@vl_fornecedor_8 as decimal(25,2)) as varchar(20))+
   							( select top 1 ' (Vl. Unit.= ' +Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) +', Vl. Desc.= ' +
								  Cast(Cast(vl_item_cotacao as decimal(25,2))as varchar(20)) + ')' 
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

select 
	pr.*, p.nm_produto as Descricao 
from 
	#Produto_Preco Pr left outer join
	Produto p on p.cd_produto = pr.cd_produto 
order by pr.cd_item_requisicao

