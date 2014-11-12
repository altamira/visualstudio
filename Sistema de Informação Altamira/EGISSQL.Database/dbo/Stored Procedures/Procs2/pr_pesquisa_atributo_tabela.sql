
-------------------------------------------------------------------------------
--pr_pesquisa_atributo_tabela
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_pesquisa_atributo_tabela
@nm_atributo varchar(40)
as
select
  b.nm_banco_dados          as Banco,
  t.nm_tabela               as Tabela,
  a.nm_atributo             as Atributo,
  a.ds_atributo             as Descricao,
  n.nm_natureza_atributo    as Natureza,
  a.qt_tamanho_atributo     as Tamanho,
  a.qt_decimal_atributo     as 'Decimal',
  a.nm_mascara_atributo     as Mascara,
  a.ic_atributo_obrigatorio as Obrigatorio,
  a.ic_atributo_chave       as Chave,
  a.ic_chave_estrangeira    as Estrangeira
  
from
  Atributo a 
  left outer join tabela t            on t.cd_tabela            = a.cd_tabela
  left outer join banco_dados b       on b.cd_banco_dados       = t.cd_banco_dados
  left outer join natureza_atributo n on n.cd_natureza_atributo = a.cd_natureza_atributo
where
  a.nm_atributo = @nm_atributo
order by
  t.nm_tabela  
  
--select * from banco_dados  
--select * from tabela
--select * from atributo
--select * from natureza_atributo

--sp_help atributo

