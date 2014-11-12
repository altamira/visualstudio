
--sp_helptext pr_apropriacao_icms_ciap_futura

-------------------------------------------------------------------------------
--pr_apropriacao_icms_ciap_futura
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta Analítica de Crédito de Icms Futura - Apropriar
--Data             : 04/11/2006
--Alteração        : 22.12.2006
------------------------------------------------------------------------------
create procedure pr_apropriacao_icms_ciap_futura
@cd_bem      int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''
as

--select * from ciap
--select * from ciap_composicao
--select * from ciap_demonstrativo
  
select
  c.cd_ciap                                  as Numero,
  b.nm_bem                                   as Bem,
  b.ds_bem                                   as Descricao,
  b.cd_patrimonio_bem                        as Patriminio,
  c.cd_nota_entrada                          as NotaEntrada,
  c.dt_entrada_nota_ciap                     as Entrada,
  sn.sg_serie_nota_fiscal                    as Serie,
  isnull(c.vl_icms_ciap,0)                   as ValorImposto,
  isnull(c.cd_livro_entrada,0)               as Livro,
  isnull(c.qt_folha_livro_entrada,0)         as Pagina,

  ( select sum( isnull(d.vl_icms,0)) from
      ciap_demonstrativo d
    where
      c.cd_ciap = d.cd_ciap and
      c.dt_entrada_nota_ciap>=d.dt_parcela_ciap ) as Saldo

  --select * from ciap_demonstrativo
  --select * from ciap
from
  Ciap c
  left outer join Bem b                 on b.cd_bem                = c.cd_bem
  left outer join Ciap_Composicao cc    on cc.cd_ciap              = c.cd_ciap
  left outer join Serie_Nota_Fiscal sn  on sn.cd_serie_nota_fiscal = c.cd_serie_nota_fiscal
  --left outer join Ciap_Demonstrativo cd on cd.cd_ciap              = c.cd_ciap
where
  c.cd_bem = case when @cd_bem = 0 then c.cd_bem else @cd_bem end and
  c.dt_entrada_nota_ciap between @dt_inicial and @dt_final
order by
  c.cd_ciap
 

