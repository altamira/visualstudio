
create procedure pr_consulta_produto_especificacao_proposta
-------------------------------------------------------------------------------
--pr_consulta_produto_especificacao_proposta
-------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                   2004
-------------------------------------------------------------------------------
-- Stored Procedure   : Microsoft SQL Server 2000
-- Autor(es)          : Igor Gama
-- Banco de Dados     : EGISSQL
-- Objetivo           : Agrupar os dados de especificação do produto por item
--                      para mostrar no relatório de proposta na banda de especificação do produto.
-- Data               : 02.03.2004
--Atualização         : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso 
-------------------------------------------------------------------------------
  @cd_consulta int
as

  select 
    i.cd_item_consulta,
    i.cd_grupo_produto,
    gp.ds_tecnica_grupo_produto as ds_produto
  from
    Consulta_Itens i
    left outer join Grupo_Produto gp
    on i.cd_grupo_produto = gp.cd_grupo_produto
  where
    cd_consulta = @cd_consulta and
    len(cast(gp.ds_tecnica_grupo_produto as varchar(10))) > 0 and
    IsNull(i.ic_sel_fax_consulta, 'N') = 'S'
  Order by 
    i.cd_grupo_produto, cd_item_consulta desc


