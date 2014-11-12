

CREATE PROCEDURE pr_Consulta_Proposta_PorReferencia_Cliente
  @dt_inicio datetime,                 --Data inicial da emissão da consulta
  @dt_termino datetime,                --Data terminal da emissão da consulta
  @nm_referencia_consulta varchar(40), --Referência do Cliente
  @nm_fantasia_cliente varchar(30)     --Nome Fantasia do cliente
AS
  
  if @nm_fantasia_cliente = '' 
      SELECT  
	Consulta.nm_referencia_consulta, 
	Cliente.nm_fantasia_cliente, 
	Consulta.cd_consulta, 
	Consulta.dt_consulta, 
	Consulta_Itens.cd_item_consulta, 
	Consulta_Itens.qt_item_consulta, 
	Consulta_Itens.nm_fantasia_produto, 
	cast(Consulta_Itens.vl_unitario_item_consulta as numeric(18,2)) as vl_unitario_item_consulta, 
	(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = Consulta.cd_vendedor_interno) nm_vendedor_interno, 
	(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = Consulta.cd_vendedor) nm_vendedor,
    Consulta_itens.pc_desconto_item_consulta, 
    cast(Consulta_Itens.vl_lista_item_consulta as numeric(18,2)) as vl_lista_item_consulta,
    (cast(Consulta_Itens.vl_unitario_item_consulta as numeric(18,2)) * Consulta_Itens.qt_item_consulta) as vl_total_item_consulta
      FROM         
	Consulta 
	INNER JOIN Consulta_Itens 
	ON Consulta.cd_consulta = Consulta_Itens.cd_consulta 
	INNER JOIN Cliente 
	ON Consulta.cd_cliente = Cliente.cd_cliente
      Where Consulta.dt_consulta between @dt_inicio and @dt_termino
	and Consulta.nm_referencia_consulta like '%' + @nm_referencia_consulta + '%'
     Else
       SELECT  
	Consulta.nm_referencia_consulta, 
	Cliente.nm_fantasia_cliente, 
	Consulta.cd_consulta, 
	Consulta.dt_consulta, 
	Consulta_Itens.cd_item_consulta, 
	Consulta_Itens.qt_item_consulta, 
	Consulta_Itens.nm_fantasia_produto, 
	cast(Consulta_Itens.vl_unitario_item_consulta as numeric(18,2)) as vl_unitario_item_consulta, 
	(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = Consulta.cd_vendedor_interno) nm_vendedor_interno, 
	(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = Consulta.cd_vendedor) nm_vendedor,
    Consulta_itens.pc_desconto_item_consulta, 
    cast(Consulta_Itens.vl_lista_item_consulta as numeric(18,2)) as vl_lista_item_consulta,
    (cast(Consulta_Itens.vl_unitario_item_consulta as numeric(18,2)) * Consulta_Itens.qt_item_consulta) as vl_total_item_consulta
       FROM         
	Consulta 
	INNER JOIN Consulta_Itens 
	ON Consulta.cd_consulta = Consulta_Itens.cd_consulta 
	INNER JOIN Cliente 
	ON Consulta.cd_cliente = Cliente.cd_cliente
       where Consulta.dt_consulta between @dt_inicio and @dt_termino
	and Consulta.nm_referencia_consulta like '%' + @nm_referencia_consulta + '%'
	and Cliente.nm_fantasia_cliente like @nm_fantasia_cliente + '%'       

