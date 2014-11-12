
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_produto_policia_civil
-------------------------------------------------------------------------------
--pr_mapa_produto_policia_civil
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa da Polícia Civil
--Data             : 15.01.2009
--Alteração        : 22.01.2009 - Ajuste para Multiplicar o Produto Fracionado
--
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
--
------------------------------------------------------------------------------
create procedure pr_mapa_produto_policia_civil
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_produto int      = 0
as

--select * from nota_saida
--select * from nota_saida_item

select 
  ns.nm_razao_social_nota,
  ns.cd_cnpj_nota_saida,
  ns.cd_inscest_nota_saida,
  ns.cd_ddd_nota_saida,
  ns.cd_telefone_nota_saida,
  ns.cd_fax_nota_saida,
  ns.nm_pais_nota_saida,
  ns.nm_endereco_nota_saida,
  ns.cd_numero_end_nota_saida,
  ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  ns.cd_cep_nota_saida,
  p.cd_produto,
  p.nm_fantasia_produto,
  p.cd_mascara_produto,
  p.nm_produto,
  um.sg_unidade_medida,
--  ns.cd_nota_saida,
  case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
       ns.cd_identificacao_nota_saida
  else
       ns.cd_nota_saida                  
  end                                   as 'cd_nota_saida',

  ns.dt_nota_saida,
  nsi.qt_item_nota_saida
  *
  case when isnull(pf.qt_produto_fracionado,0)>0 then
    pf.qt_produto_fracionado
  else
    1
  end                                      as qt_item_nota_saida,

  c.nm_fantasia_cliente

from
  Nota_Saida ns                            with (nolock)
  inner join Nota_Saida_Item nsi           with (nolock) on nsi.cd_nota_saida        = ns.cd_nota_saida
  inner join Produto p                     with (nolock) on p.cd_produto             = nsi.cd_produto
  left outer join Produto_Fracionamento pf with (nolock) on pf.cd_produto_fracionado = p.cd_produto
  left outer join Cliente        c         with (nolock) on c.cd_cliente             = ns.cd_cliente
  left outer join Unidade_Medida um        with (nolock) on um.cd_unidade_medida     = p.cd_unidade_medida 
where
  isnull(p.ic_mapa_pol_civil,'N')='S'                and
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.cd_status_nota = 5 and --Fechada
  nsi.cd_produto = case when isnull(@cd_produto,0) = 0 then nsi.cd_produto else @cd_produto end
order by
  p.nm_fantasia_produto

