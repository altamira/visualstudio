


CREATE PROCEDURE pr_proposta_comercial_desconto

@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime

AS

--------------------------------------------------------------------------------------------
   If @ic_parametro = 1 -- Lista Todos os Documentos
--------------------------------------------------------------------------------------------  

Begin
  select

     c.cd_vendedor,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
    c.cd_vendedor_interno,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    c.dt_consulta,
    c.cd_consulta,
    ci.cd_item_consulta,
    ci.qt_item_consulta,
    ci.pc_desconto_item_consulta,
    ci.vl_lista_item_consulta,
    ci.vl_unitario_item_consulta as 'vl_preco_venda',  
    ci.nm_fantasia_produto,
    ci.vl_unitario_item_consulta * ci.qt_item_consulta as 'vl_total_venda'

from
   Consulta c
left outer join
   Cliente cli
on
   c.cd_cliente = cli.cd_cliente
inner join
   Consulta_Itens ci
on
   ci.cd_consulta = c.cd_consulta
left outer join
   Grupo_Produto gp
on
   ci.cd_grupo_produto = gp.cd_grupo_produto


where
   c.cd_consulta = ci.cd_consulta and
   c.dt_consulta between @dt_inicial and @dt_final and
   (IsNull(ci.pc_desconto_item_consulta,0) <> 0.0) and
   ci.vl_lista_item_consulta <> ci.vl_unitario_item_consulta

   
end    
    

--------------------------------------------------------------------------------------------
else If @ic_parametro = 2 -- Acima do Nível de Desconto
--------------------------------------------------------------------------------------------  

begin

  select

     c.cd_vendedor,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
    c.cd_vendedor_interno,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    c.dt_consulta,
    c.cd_consulta,
    ci.cd_item_consulta,
    ci.qt_item_consulta,
    ci.pc_desconto_item_consulta,
    ci.vl_lista_item_consulta,
    ci.vl_unitario_item_consulta as 'vl_preco_venda',  
    ci.nm_fantasia_produto,
    ci.vl_unitario_item_consulta * ci.qt_item_consulta as 'vl_total_venda'

from
   Consulta c
left outer join
   Cliente cli
on
   c.cd_cliente = cli.cd_cliente
inner join
   Consulta_Itens ci
on
   ci.cd_consulta = c.cd_consulta
left outer join
   Grupo_Produto gp
on
   ci.cd_grupo_produto = gp.cd_grupo_produto


where
   c.cd_consulta = ci.cd_consulta and
   c.dt_consulta between @dt_inicial and @dt_final and
   (IsNull(ci.pc_desconto_item_consulta,0) <> 0.0) and
   ci.vl_lista_item_consulta <> ci.vl_unitario_item_consulta and
   IsNull(gp.pc_desconto_max_grupo_produto,0) < IsNull(ci.pc_desconto_item_consulta,0)

end

--------------------------------------------------------------------------------------------
else If @ic_parametro = 3 -- Acima do Preço da Lista
--------------------------------------------------------------------------------------------  

begin

  select

     c.cd_vendedor,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
    c.cd_vendedor_interno,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    c.dt_consulta,
    c.cd_consulta,
    ci.cd_item_consulta,
    ci.qt_item_consulta,
    ci.pc_desconto_item_consulta,
    ci.vl_lista_item_consulta,
    ci.vl_unitario_item_consulta as 'vl_preco_venda',  
    ci.nm_fantasia_produto,
    ci.vl_unitario_item_consulta * ci.qt_item_consulta as 'vl_total_venda'

from
   Consulta c
left outer join
   Cliente cli
on
   c.cd_cliente = cli.cd_cliente
inner join
   Consulta_Itens ci
on
   ci.cd_consulta = c.cd_consulta
left outer join
   Grupo_Produto gp
on
   ci.cd_grupo_produto = gp.cd_grupo_produto


where
   c.cd_consulta = ci.cd_consulta and
   c.dt_consulta between @dt_inicial and @dt_final and
   IsNull(ci.pc_desconto_item_consulta,0) <> 0.0 and
   ci.vl_lista_item_consulta < ci.vl_unitario_item_consulta
   
end

