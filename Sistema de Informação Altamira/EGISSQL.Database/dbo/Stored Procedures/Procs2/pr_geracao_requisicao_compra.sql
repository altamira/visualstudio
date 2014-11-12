
CREATE PROCEDURE pr_geracao_requisicao_compra

@ic_parametro     int,
@cd_grupo_produto int,
@ic_comprado_grupo_produto char(1),
@cd_sugestao_qtd int ------ 0 - Falta para o Máximo
                     ------ 1.- Falta pra o Mínimo 
                     ------ 2.- Estoque Mínimo
                     ------ 3.- Lote
                     ------ 4.- Consumo Médio
AS
declare @cd_fase_produto_parametro int
declare @cd_data1 datetime
declare @cd_data2 datetime
declare @cd_data3 datetime

-----------------------------------
--Meses Anteriores de Consumo
-----------------------------------
select @cd_data1= cast(cast(month(getdate()) as varchar) + '/01/' + cast(year(getdate()) as varchar) as datetime)-1
select @cd_data2= @cd_data1-31
select @cd_data3= @cd_data2-31

-----------------------------------
--Fase padrao de compra
-----------------------------------
select
  @cd_fase_produto_parametro = cd_fase_produto
from
  Parametro_Suprimento
where
  cd_empresa = dbo.fn_empresa()

---------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta de produtos com estoque negativo
---------------------------------------------------------------------------------------------
begin
  select     
    0 	        		as Selecionado, 
    p.cd_produto,
    p.nm_fantasia_produto	as Fantasia, 
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo, 
    p.nm_produto		as Descricao, 
    p.cd_unidade_medida,
    IsNull(ump.sg_unidade_medida,'')      as Unidade, 
    p.cd_categoria_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    IsNull(ps.qt_saldo_atual_produto,0)	  as Atual, 
    IsNull(ps.qt_saldo_reserva_produto,0) as Disponivel, 
    IsNull(ps.qt_req_compra_produto,0)	  as Requisicao, 
    IsNull(ps.qt_pd_compra_produto,0)	  as PedidoCompra,   
    IsNull(ps.qt_consumo_produto,0)	  as Consumo, 
    case when IsNull(ps.qt_saldo_reserva_produto,0)<  IsNull(ps.qt_saldo_atual_produto,0) then
      IsNull(ps.qt_saldo_reserva_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0)	
    else
      IsNull(ps.qt_saldo_atual_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0) end as Total, 
    IsNull(ps.qt_minimo_produto,0)	  as Minimo, 
    IsNull(ps.qt_maximo_produto,0)	  as Maximo, 
    IsNull(ps.qt_padrao_lote_compra,0)	  as Lote, 
    IsNull(p.qt_leadtime_compra,0)	  as LeadTime,
    dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1))  +
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2))+
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as Consumo_Trim
  into #Tabela1
  from         
    produto p 
  left outer join produto_saldo ps on 
    ps.cd_produto = p.cd_produto 
  left outer join produto_compra pc on 
    pc.cd_produto = p.cd_produto 
  left outer join unidade_medida ump on 
    ump.cd_unidade_medida = p.cd_unidade_medida 
  left outer join grupo_produto gp on 
    p.cd_grupo_produto = gp.cd_grupo_produto
  where
   ((gp.cd_grupo_produto = @cd_grupo_produto) or (@cd_grupo_produto = 0)) and
   ps.cd_fase_produto = @cd_fase_produto_parametro                        and
   (case when ps.qt_saldo_atual_produto< ps.qt_saldo_reserva_produto then   
     (ps.qt_saldo_atual_produto)
   when ps.qt_saldo_atual_produto> ps.qt_saldo_reserva_produto then
     (ps.qt_saldo_reserva_produto) end +
      (select sum(qt_item_requisicao_compra) from requisicao_compra_item
       where cd_produto=p.cd_produto)+
      (select sum(qt_saldo_item_ped_compra) from pedido_compra_item   
       where cd_produto=p.cd_produto) <0)                                 and
   ((pc.cd_produto is not null and @ic_comprado_grupo_produto = 'S') or
    (@ic_comprado_grupo_produto = 'N'))

  select 
    t1.*, 
    case when IsNull(Consumo,0)>0 then
      IsNull(Atual,0) / (IsNull(Consumo,0)*30)
    else 
      IsNull(Atual,0) / ((Consumo_Trim-total)*30) end as Duracao,
    dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1)) as mes1,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2)) as mes2,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as mes3,
    Consumo_Trim/3 as Media,
    case when @cd_sugestao_qtd=0 then
      IsNull(Maximo,Minimo) - Disponivel
    when @cd_sugestao_qtd=2 then --Estoque Mínimo
      IsNull(Minimo,0)
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))<= 0 then --Falta para o Mínimo
      0
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))> 0 then     
      IsNull(Atual,0)-IsNull(Minimo,0)
    when @cd_sugestao_qtd=3 then      --Lote
      IsNull(Lote,0)
    when @cd_sugestao_qtd=4 then      --Consumo Médio
      (Consumo_Trim/3) end as Sugerido
  from #Tabela1 t1	 
end

else

---------------------------------------------------------------------------------------------
if @ic_parametro = 2 --Consulta de produtos com estoque abaixo do mínimo
---------------------------------------------------------------------------------------------
begin
  select     
    0 	        		as Selecionado, 
    p.cd_produto,
    p.nm_fantasia_produto	as Fantasia, 
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo, 
    p.nm_produto		as Descricao, 
    p.cd_unidade_medida,
    IsNull(ump.sg_unidade_medida,'')      as Unidade, 
    p.cd_categoria_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    IsNull(ps.qt_saldo_atual_produto,0)	  as Atual, 
    IsNull(ps.qt_saldo_reserva_produto,0) as Disponivel, 
    IsNull(ps.qt_req_compra_produto,0)	  as Requisicao, 
    IsNull(ps.qt_pd_compra_produto,0)	  as PedidoCompra,   
    IsNull(ps.qt_consumo_produto,0)	  as Consumo, 
    case when IsNull(ps.qt_saldo_reserva_produto,0)<  IsNull(ps.qt_saldo_atual_produto,0) then
      IsNull(ps.qt_saldo_reserva_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0)	
    else
      IsNull(ps.qt_saldo_atual_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0) end as Total, 
    IsNull(ps.qt_minimo_produto,0)	  as Minimo, 
    IsNull(ps.qt_maximo_produto,0)	  as Maximo, 
    IsNull(ps.qt_padrao_lote_compra,0)	  as Lote, 
    IsNull(p.qt_leadtime_compra,0)	  as LeadTime,
    dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1))  +
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2))+
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as Consumo_Trim
  into #Tabela2
  from         
    produto p 
  left outer join produto_saldo ps on 
    ps.cd_produto = p.cd_produto 
  left outer join produto_compra pc on 
    pc.cd_produto = p.cd_produto 
  left outer join unidade_medida ump on 
    ump.cd_unidade_medida = p.cd_unidade_medida 
  left outer join grupo_produto gp on 
    p.cd_grupo_produto = gp.cd_grupo_produto
  where
   (IsNull(gp.cd_grupo_produto,0) = ( case when @cd_grupo_produto = 0 then
                                        IsNull(gp.cd_grupo_produto,0) else
                                       @cd_grupo_produto end ) ) and
   ps.cd_fase_produto = @cd_fase_produto_parametro                        and
   (case when IsNull(ps.qt_saldo_atual_produto,0)<= IsNull(ps.qt_saldo_reserva_produto,0) then   
     (IsNull(ps.qt_saldo_atual_produto,0))
   when IsNull(ps.qt_saldo_atual_produto,0)> IsNull(ps.qt_saldo_reserva_produto,0) then
    (IsNull(ps.qt_saldo_reserva_produto,0)) end +
      IsNull((select sum(qt_item_requisicao_compra) from requisicao_compra_item
       where cd_produto=p.cd_produto),0)+
      IsNull((select sum(qt_saldo_item_ped_compra) from pedido_compra_item   
      where cd_produto=p.cd_produto),0) < (IsNull(ps.qt_minimo_produto,0)))           and
   ((pc.cd_produto is not null and @ic_comprado_grupo_produto = 'S') or
    (@ic_comprado_grupo_produto = 'N'))


  select 
    t2.*, 
    case when IsNull(Consumo,0)>0 then
      IsNull(Atual,0) / (IsNull(Consumo,0)*30)
    else 
      IsNull(Atual,0) / ((case when IsNull(Consumo_Trim,0)-IsNull(total,0) = 0 then
                           1 else IsNull(Consumo_Trim,0)-IsNull(total,0) end)*30) end as Duracao,
    dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1)) as mes1,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2)) as mes2,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as mes3,
    Consumo_Trim/3 as Media,
    case when @cd_sugestao_qtd=0 then
      IsNull(Maximo,Minimo) - Disponivel
    when @cd_sugestao_qtd=2 then --Estoque Mínimo
      IsNull(Minimo,0)
    when @cd_sugestao_qtd=1 and (IsNull(Minimo,0)-IsNull(Disponivel,0))<= 0 then --Falta para o Mínimo
      0
    when @cd_sugestao_qtd=1 and (IsNull(Minimo,0)-IsNull(Disponivel,0))> 0 then     
      IsNull(Minimo,0)-IsNull(Disponivel,0)
    when @cd_sugestao_qtd=3 then      --Lote
      IsNull(Lote,0)
    when @cd_sugestao_qtd=4 then      --Consumo Médio
      (Consumo_Trim/3) end as Sugerido
  from #Tabela2 t2	 
end

---------------------------------------------------------------------------------------------
if @ic_parametro = 3 --Consulta de produtos pela duração
---------------------------------------------------------------------------------------------
begin
  select     
    0 	        		as Selecionado, 
    p.cd_produto,
    p.nm_fantasia_produto	as Fantasia, 
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo, 
    p.nm_produto		as Descricao, 
    p.cd_unidade_medida,
    IsNull(ump.sg_unidade_medida,'')      as Unidade, 
    p.cd_categoria_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    IsNull(ps.qt_saldo_atual_produto,0)	  as Atual, 
    IsNull(ps.qt_saldo_reserva_produto,0) as Disponivel, 
    IsNull(ps.qt_req_compra_produto,0)	  as Requisicao, 
    IsNull(ps.qt_pd_compra_produto,0)	  as PedidoCompra,   
    IsNull(ps.qt_consumo_produto,0)	  as Consumo, 
    case when IsNull(ps.qt_saldo_reserva_produto,0)<  IsNull(ps.qt_saldo_atual_produto,0) then
      IsNull(ps.qt_saldo_reserva_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0)	
    else
      IsNull(ps.qt_saldo_atual_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0) end as Total, 
    IsNull(ps.qt_minimo_produto,0)	  as Minimo, 
    IsNull(ps.qt_maximo_produto,0)	  as Maximo, 
    IsNull(ps.qt_padrao_lote_compra,0)	  as Lote, 
    IsNull(p.qt_leadtime_compra,0)	  as LeadTime,
    dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1))  +
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2))+
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as Consumo_Trim
  into #Tabela3
  from         
    produto p 
  left outer join produto_saldo ps on 
    ps.cd_produto = p.cd_produto 
  left outer join produto_compra pc on 
    pc.cd_produto = p.cd_produto 
  left outer join unidade_medida ump on 
    ump.cd_unidade_medida = p.cd_unidade_medida 
  left outer join grupo_produto gp on 
    p.cd_grupo_produto = gp.cd_grupo_produto
  where
   ((gp.cd_grupo_produto = @cd_grupo_produto) or (@cd_grupo_produto = 0)) and
   ps.cd_fase_produto = @cd_fase_produto_parametro                        and
   ((pc.cd_produto is not null and @ic_comprado_grupo_produto = 'S') or
    (@ic_comprado_grupo_produto = 'N'))

  select 
    t3.*, 
    case when IsNull(Consumo,0)>0 then
      IsNull(Atual,0) / (IsNull(Consumo,0)*30)
    else 
      IsNull(Atual,0) / ((Consumo_Trim-total)*30) end as Duracao,
    dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1)) as mes1,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2)) as mes2,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as mes3,
    Consumo_Trim/3 as Media,
    case when @cd_sugestao_qtd=0 then
      IsNull(Maximo,Minimo) - Disponivel
    when @cd_sugestao_qtd=2 then --Estoque Mínimo
      IsNull(Minimo,0)
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))<= 0 then --Falta para o Mínimo
      0
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))> 0 then     
      IsNull(Atual,0)-IsNull(Minimo,0)
    when @cd_sugestao_qtd=3 then      --Lote
      IsNull(Lote,0)
    when @cd_sugestao_qtd=4 then      --Consumo Médio
      (Consumo_Trim/3) end as Sugerido
  from #Tabela3 t3	 
  where 
    case when IsNull(Consumo,0)>0 then
      IsNull(Atual,0) / (IsNull(Consumo,0)*30)
    else 
      IsNull(Atual,0) / ((IsNull(Consumo_Trim,0)-IsNull(total,0))*30) end <30
end

---------------------------------------------------------------------------------------------
if @ic_parametro = 4 --Consulta de produtos pelo Consumo
---------------------------------------------------------------------------------------------
begin
  select     
    0 	        		as Selecionado, 
    p.cd_produto,
    p.nm_fantasia_produto	as Fantasia, 
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo, 
    p.nm_produto		as Descricao, 
    p.cd_unidade_medida,
    IsNull(ump.sg_unidade_medida,'')      as Unidade, 
    p.cd_categoria_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    IsNull(ps.qt_saldo_atual_produto,0)	  as Atual, 
    IsNull(ps.qt_saldo_reserva_produto,0) as Disponivel, 
    IsNull(ps.qt_req_compra_produto,0)	  as Requisicao, 
    IsNull(ps.qt_pd_compra_produto,0)	  as PedidoCompra,   
    IsNull(ps.qt_consumo_produto,0)	  as Consumo, 
    case when IsNull(ps.qt_saldo_reserva_produto,0)<  IsNull(ps.qt_saldo_atual_produto,0) then
      IsNull(ps.qt_saldo_reserva_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0)	
    else
      IsNull(ps.qt_saldo_atual_produto,0) + IsNull(ps.qt_req_compra_produto,0) +
      IsNull(ps.qt_pd_compra_produto,0) end as Total, 
    IsNull(ps.qt_minimo_produto,0)	  as Minimo, 
    IsNull(ps.qt_maximo_produto,0)	  as Maximo, 
    IsNull(ps.qt_padrao_lote_compra,0)	  as Lote, 
    IsNull(p.qt_leadtime_compra,0)	  as LeadTime,
    dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1))  +
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2))+
      dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as Consumo_Trim
  into #Tabela4
  from         
    produto p 
  left outer join produto_saldo ps on 
    ps.cd_produto = p.cd_produto 
  left outer join produto_compra pc on 
    pc.cd_produto = p.cd_produto 
  left outer join unidade_medida ump on 
    ump.cd_unidade_medida = p.cd_unidade_medida 
  left outer join grupo_produto gp on 
    p.cd_grupo_produto = gp.cd_grupo_produto
  where
   ((gp.cd_grupo_produto = @cd_grupo_produto) or (@cd_grupo_produto = 0)) and
   ps.cd_fase_produto = @cd_fase_produto_parametro                        and
   (case when ps.qt_saldo_atual_produto < ps.qt_saldo_reserva_produto then   
     (ps.qt_saldo_atual_produto)
   when ps.qt_saldo_atual_produto> ps.qt_saldo_reserva_produto then
     (ps.qt_saldo_reserva_produto) end < ((dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1))  +
                                           dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2))+
                                           dbo.fn_consumo_produto_mes(p.cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)))/3)) and
   ((pc.cd_produto is not null and @ic_comprado_grupo_produto = 'S') or
    (@ic_comprado_grupo_produto = 'N'))

  select 
    t4.*, 
    case when IsNull(Consumo,0)>0 then
      IsNull(Atual,0) / (IsNull(Consumo,0)*30)
    else 
      IsNull(Atual,0) / ((Consumo_Trim-total)*30) end as Duracao,
    dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data1), year(@cd_data1)) as mes1,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data2), year(@cd_data2)) as mes2,
      dbo.fn_consumo_produto_mes(cd_produto, @cd_fase_produto_parametro, 'S', month(@cd_data3), year(@cd_data3)) as mes3,
    Consumo_Trim/3 as Media,
    case when @cd_sugestao_qtd=0 then
      IsNull(Maximo,Minimo) - Disponivel
    when @cd_sugestao_qtd=2 then --Estoque Mínimo
      IsNull(Minimo,0)
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))<= 0 then --Falta para o Mínimo
      0
    when @cd_sugestao_qtd=1 and (IsNull(Atual,0)-IsNull(Minimo,0))> 0 then     
      IsNull(Atual,0)-IsNull(Minimo,0)
    when @cd_sugestao_qtd=3 then      --Lote
      IsNull(Lote,0)
    when @cd_sugestao_qtd=4 then      --Consumo Médio
      (Consumo_Trim/3) end as Sugerido
  from #Tabela4 t4
end


---------------------------------------------------------------------------------------------
