
-------------------------------------------------------------------------------
--sp_helptext pr_atualizacao_manual_egisadmin_gbs_cliente
-------------------------------------------------------------------------------
--pr_atualizacao_manual_egisadmin_gbs_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--                   Douglas Lopes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Atualização Manual do EgisAdmin no Cliente
--Data             : 15.11.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualizacao_manual_egisadmin_gbs_cliente
as

--select * from tabela where cd_tabela = 491

select
  cd_tabela,
  nm_tabela,
  sql1 = 'drop table '+rtrim(ltrim(nm_tabela)),
  sql2 = 'select * into '+rtrim(ltrim(nm_tabela))+' from egisadmin.dbo.'+rtrim(ltrim(nm_tabela)),
--  cd_ordem_tabela,
  ordem = ( 
    Select top 1 status from sysobjects
            where 
                  name  = tabela.nm_tabela and
                  xtype = 'U' AND
                  uid = 1 )



into
  #Tabela

from
  tabela
where
  isnull(ic_sap_admin,'N')='S' and
  isnull(ic_versao_tabela,'N')='S'

select 
  * 
into
  #TabelaInsere
from 
  #Tabela


--select * from  #Tabela

declare @sql1      varchar(8000)
declare @sql2      varchar(8000)
declare @nm_tabela varchar(80)

declare @cd_tabela int

while exists( select top 1 cd_tabela from #Tabela )
begin
  select top 1
    @cd_tabela  = cd_tabela,
    @sql1       = sql1,
    @nm_tabela  = rtrim(nm_tabela)

  from
    #Tabela
  order by 
    ordem

  if exists(Select * from sysobjects
            where name = @nm_tabela and
                  xtype = 'U' AND
                  uid = 1 )
  begin
    exec (@sql1) 
  end

  delete from #Tabela where cd_tabela = @cd_tabela

end

--Criação da Nota Tabela Atualizada

while exists( select top 1 cd_tabela from #TabelaInsere )
begin
  select top 1
    @cd_tabela = cd_tabela,
    @sql2       = sql2,
    @nm_tabela  = rtrim(nm_tabela)

  from
    #TabelaInsere
  order by 
    ordem

  if not exists(Select * from sysobjects
            where name = @nm_tabela and
                  xtype = 'U' AND
                  uid = 1 )
  begin
    exec (@sql2) 
  end

  delete from #TabelaInsere where cd_tabela = @cd_tabela

end


--select * from #Tabela



