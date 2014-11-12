
-------------------------------------------------------------------------------
--sp_helptext pr_gera_schema_xml_padrao_nfe
-------------------------------------------------------------------------------
--pr_gera_schema_xml_padrao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera o schema padrão XML para geração da Nota Fiscal Eletrônica
--
--Data             : 22.11.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_schema_xml_padrao_nfe
@cd_nota_saida int = 0

as


  declare @a_sql varchar(8000)
  declare @b_sql varchar(8000)
  declare @c_sql varchar(8000)
  declare @d_sql varchar(8000)
  declare @e_sql varchar(8000)
  declare @f_sql varchar(8000)
  declare @g_sql varchar(8000)
  declare @h_sql varchar(8000)
  declare @i_sql varchar(8000)

  set @a_sql = ''
  set @b_sql = ''
  set @c_sql = ''
  set @d_sql = ''
  set @e_sql = ''
  set @f_sql = ''
  set @g_sql = ''
  set @h_sql = ''
  set @i_sql = ''
 
select

  @a_sql = ( select A_DADOS from vw_nfe_dados_nota_fiscal         vw where vw.cd_nota_saida = ns.cd_nota_saida ),
  @b_sql = ( select B_DADOS from vw_nfe_identificacao_nota_fiscal vw where vw.cd_nota_saida = ns.cd_nota_saida )

from
  Nota_Saida ns with (nolock)
where
  ns.cd_nota_saida = @cd_nota_saida 

select
  @a_sql  as A,
  @b_sql  as B,
  @c_sql  as C,
  @d_sql  as D,
  @e_sql  as E,
  @f_sql  as F,
  @g_sql  as G,
  @h_sql  as H,
  @i_sql  as I

