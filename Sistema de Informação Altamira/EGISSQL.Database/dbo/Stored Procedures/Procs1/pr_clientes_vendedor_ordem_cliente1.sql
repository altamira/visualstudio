

/****** Object:  Stored Procedure dbo.pr_clientes_vendedor_ordem_cliente1    Script Date: 13/12/2002 15:08:15 ******/
--pr_clientes_vendedor_ordem_cliente1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Clientes por Mapa Geográfico Dividido por Vendedor - Ordem por Cliente
--Data       : 02.Abril.2001
--Atualizado : 11.Setembro.2001
--           : 18.09.2002 - Migração para a bco. EGISSQL (DUELA)
-----------------------------------------------------------------------------------
CREATE procedure pr_clientes_vendedor_ordem_cliente1

@ic_parametro int,
@cd_vendedor  int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Vendedor (Todos)
-------------------------------------------------------------------------------
begin
  select v.cd_vendedor,
         v.nm_fantasia_vendedor   as 'Vendedor',
         c.cd_cliente,
         c.nm_fantasia_cliente    as 'Cliente',
         r.nm_regiao              as 'Regiao',
         c.nm_endereco_cliente    as 'Endereco',
         c.nm_bairro              as 'Bairro',
         cid.nm_cidade            as 'Cidade',
         est.nm_estado            as 'Estado',
         c.cd_cep                 as 'CEP',
         c.cd_ddd                 as 'DDD',
         c.cd_telefone            as 'Fone'
  from  
      Cliente c
  left outer join Regiao r 
    on r.cd_regiao=c.cd_regiao
  left outer join Vendedor v 
    on v.cd_vendedor=c.cd_vendedor
  left outer join Estado est
    on est.cd_estado=c.cd_estado
  left outer join Cidade cid
     on cid.cd_cidade=c.cd_cidade
  order by c.nm_fantasia_cliente
end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Vendedor (Filtrado)
-------------------------------------------------------------------------------
begin
  select v.cd_vendedor,
         v.nm_fantasia_vendedor   as 'Vendedor',
         c.cd_cliente,
         c.nm_fantasia_cliente    as 'Cliente',
         r.nm_regiao              as 'Regiao',
         c.nm_endereco_cliente    as 'Endereco',
         c.nm_bairro              as 'Bairro',
         cid.nm_cidade            as 'Cidade',
         est.nm_estado            as 'Estado',
         c.cd_cep                 as 'CEP',
         c.cd_ddd                 as 'DDD',
         c.cd_telefone            as 'Fone'
  from  
      Cliente c
  left outer join Regiao r 
    on r.cd_regiao=c.cd_regiao
  left outer join Vendedor v 
    on v.cd_vendedor=c.cd_vendedor
  left outer join Estado est
    on est.cd_estado=c.cd_estado
  left outer join Cidade cid
     on cid.cd_cidade=c.cd_cidade
   where
      c.cd_vendedor = @cd_vendedor
   order by c.nm_fantasia_cliente
end



