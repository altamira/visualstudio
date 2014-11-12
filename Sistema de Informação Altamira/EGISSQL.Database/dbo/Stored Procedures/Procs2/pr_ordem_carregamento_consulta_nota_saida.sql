
-------------------------------------------------------------------------------
--sp_helptext pr_ordem_carregamento_consulta_nota_saida
-------------------------------------------------------------------------------
--pr_ordem_carregamento_consulta_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta das Notas Fiscais da Ordem de Carregamento
--
--Data             : 04.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ordem_carregamento_consulta_nota_saida
@ic_parametro   int = 0,
@cd_ordem_carga int = 0
 
as

--select * from nota_saida

if @ic_parametro = 1
begin
  select 
    ns.cd_nota_saida,
    ns.dt_nota_saida,
    ns.nm_fantasia_nota_saida,
    ns.cd_nota_saida,
    ns.cd_telefone_nota_saida,
    ns.vl_total,
    v.nm_fantasia_vendedor

  from
    nota_saida ns with (nolock)
    left outer join Vendedor v on v.cd_vendedor = ns.cd_vendedor
  where
    ns.cd_ordem_carga = case when @cd_ordem_carga = 0 then ns.cd_ordem_carga else @cd_ordem_carga end 
end

if @ic_parametro = 2
begin

  --select * from nota_saida_item

  select 
    nsi.cd_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.nm_fantasia_produto,
    nsi.qt_item_nota_saida,
    nsi.vl_total_item,
    nsi.nm_produto_item_nota

  from
    nota_saida_item nsi with (nolock)
    inner join nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
  where
    ns.cd_ordem_carga = case when @cd_ordem_carga = 0 then ns.cd_ordem_carga else @cd_ordem_carga end 

end

