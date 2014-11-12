create procedure pr_consulta_produto_garantia_proposta
-------------------------------------------------------------------------------
--pr_consulta_produto_garantia_proposta
-------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                   2004
-------------------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)             : Igor Gama
-- Banco de Dados        : EGISSQL
-- Objetivo              : Agrupar os dados de garantia do produto por item
--                         para mostrar no relatório de proposta na banda de garantia do produto.
-- Data                  : 02.03.2004
--Atualização            : 13/12/2004 - Acerto do Cabeçalho
--                       : 05.05.2005 - Checagem do Retorno - Carlos Fernandes.
--                       : 17.05.2005 - Fábio Cesar - Reestruturação pois o agrupamento será
--                                      realizado por meio de código no Delphi, devido a 
--                                      deficiência do SQL trabalhar com campos "TEXT"
--                       : 24.05.2005 - Por solicitação de Vendas foi removida a necessidade de apresentar o item
--					para melhorar a performance, após essa mudança foi reestruturado o script.
-------------------------------------------------------------------------------
@cd_consulta int

as

    Select
       '' as cd_item_consulta,
       g.ds_termo_garantia as ds_produto_garantia 
    From
      (Select
         distinct 
           (case
              when ( IsNull(i.cd_produto,0) = 0 ) then
                gp.cd_termo_garantia
              else
                IsNull(p.cd_termo_garantia,gp.cd_termo_garantia)
            end) as cd_termo_garantia          
       from
         consulta_itens i
         left outer join produto p on i.cd_produto = p.cd_produto            
         left outer join grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto            
       where
         IsNull(p.cd_termo_garantia,gp.cd_termo_garantia) > 0 and
         cd_consulta = @cd_consulta) as t inner join 
         Termo_Garantia g
         on t.cd_termo_garantia = g.cd_termo_garantia
