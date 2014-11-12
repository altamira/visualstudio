

/****** Object:  Stored Procedure dbo.pr_altera_cliente_vendedor    Script Date: 13/12/2002 15:08:11 ******/

CREATE PROCEDURE pr_altera_cliente_vendedor

@ic_parametro         int,
@nm_fantasia_cliente  varchar(30),
@cd_cliente           int,
@cd_vendedor          int,
@cd_vendedor_interno  int,
@dt_inicial           datetime,
@dt_final             datetime

as

-------------------------------------------------------------------------------  
if @ic_parametro = 1    -- Consulta de Clientes (Dados referentes aos Vendedores)  
-------------------------------------------------------------------------------  
begin
  select
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.cd_regiao,
    r.nm_regiao,
    c.cd_vendedor,
    v.nm_fantasia_vendedor as 'nm_vendedor',
    c.cd_vendedor_interno,
    v1.nm_fantasia_vendedor as 'nm_vendedor_interno'
  from Cliente c
  left outer join Vendedor v
    on v.cd_vendedor=c.cd_vendedor
  left outer join Vendedor v1
    on v1.cd_vendedor=c.cd_vendedor_interno
  left outer join Regiao r
    on r.cd_regiao=c.cd_regiao
  where c.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
  order by c.nm_fantasia_cliente
end

-------------------------------------------------------------------------------  
if @ic_parametro = 2    -- Altera o Vendedor dos Pedidos de Venda para o novo vendedor informado  
-------------------------------------------------------------------------------  
begin
  update Pedido_Venda 
  set
    cd_vendedor=@cd_vendedor,
    cd_vendedor_interno=@cd_vendedor_interno
  where 
    cd_cliente=@cd_cliente and
    dt_pedido_venda between @dt_inicial and @dt_final
end

-------------------------------------------------------------------------------  
if @ic_parametro = 3    -- Altera o Vendedor das Notas de Saída para o novo vendedor informado  
-------------------------------------------------------------------------------  
begin
  update Nota_Saida 
  set
    cd_vendedor=@cd_vendedor
  where 
    cd_cliente=@cd_cliente and
    dt_nota_saida between @dt_inicial and @dt_final
end



