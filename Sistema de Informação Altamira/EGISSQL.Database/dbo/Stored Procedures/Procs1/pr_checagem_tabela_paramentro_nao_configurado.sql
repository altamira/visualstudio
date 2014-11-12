
-------------------------------------------------------------------------------
--pr_checagem_tabela_paramentro_nao_configurado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Checagem Tabela de Parâmetro
--Data             : 20.04.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_checagem_tabela_paramentro_nao_configurado
@cd_tabela int = 0

as

--select * from egisadmin.dbo.empresa

declare @nm_banco_empresa varchar(50)

select
  @nm_banco_empresa = isnull(nm_banco_empresa,'EGISSQL')
from
  egisadmin.dbo.empresa
where
  cd_empresa = dbo.fn_empresa()

--select @nm_banco_empresa

select
  bd.nm_fantasia_banco_dados,
  t.cd_tabela,
  t.nm_tabela,
  a.cd_atributo,
  a.nm_atributo,
  a.cd_natureza_atributo
into
  #Tabela  

from
  egisadmin.dbo.tabela t                       with (nolock)
  inner join egisadmin.dbo.atributo a          with (nolock) on a.cd_tabela       = t.cd_tabela
  left outer join egisadmin.dbo.banco_dados bd with (nolock) on bd.cd_banco_dados = t.cd_banco_dados
where
  t.cd_tabela = case when @cd_tabela = 0 then t.cd_tabela else @cd_tabela end and
  isnull(ic_parametro_tabela,'N')='S' and
  bd.nm_fantasia_banco_dados = @nm_banco_empresa and
  isnull(t.ic_sap_admin,'N') = 'N'
order by
  t.nm_tabela,
  a.cd_atributo

--select * from #Tabela  order by nm_atributo

  --Define o usuário logado

  declare @nm_usuario_logado varchar(100)
  declare @cSQL              varchar(8000)
  declare @nm_tabela_aux     varchar(40)

  select  @nm_usuario_logado = RTrim(LTrim(USER_NAME()))

  --Tabela Temporária
  set @nm_tabela_aux = @nm_usuario_logado + '.' + 'CONSULTA_PARAMETRO'

  --------------------------------------------------
  --- Apagar a tabela Temporária
  ---------------------------------------------------

  if exists(Select * from sysobjects
            where name = 'CONSULTA_PARAMETRO' and
                  xtype = 'U' AND
                  uid = USER_ID(@nm_usuario_logado))
  begin
    set @cSQL = ' DROP TABLE ' + @nm_tabela_aux
    exec(@cSQL)
--    print(@cSQL)
  end

  set @cSQL = ' CREATE TABLE ' + @nm_tabela_aux +
              ' ( cd_tabela int, cd_atributo int ) '
                  
  exec(@cSQL)
--  print(@cSQL)

-- Mostra a Tabela

--  select @cSQL = 'select * from ' + @nm_usuario_logado + '.' + 'CONSULTA_PARAMETRO'
--  exec(@cSQL )
--  print(@cSQL)

  declare @sql                  varchar(8000)
  declare @cd_tabela_aux        int
  declare @cd_atributo          int
  declare @nm_atributo          varchar(80)
  declare @nm_atributo_aux      varchar(40)
  declare @nm_tabela            varchar(40)
  declare @cd_natureza_atributo int   

  while exists ( select top 1 cd_tabela from #Tabela )
  begin
    select top 1
      @cd_tabela_aux        = cd_tabela,
      @cd_atributo          = cd_atributo,
      @nm_tabela            = nm_tabela,
      @nm_atributo          = nm_atributo,
      @nm_atributo_aux      = nm_atributo,
      @cd_natureza_atributo = cd_natureza_atributo
   from
     #Tabela


--   print @nm_tabela

   if @cd_natureza_atributo = 7 or @cd_natureza_atributo = 8
   begin
     set @nm_atributo = 'isnull('+@nm_atributo+','+''''''+') as '+@nm_atributo_aux
   end
   else
     begin
       set @sql = 'if exists (select top 1 '+@nm_atributo+' from '+@nm_tabela+' where '+@nm_atributo_aux+' is null )'+
                  ' begin '+
                  ' insert into '+@nm_tabela_aux+' select '+cast(@cd_tabela_aux as varchar)+', '
                                                       +cast(@cd_atributo as varchar)+
                 ' end '
   
       exec(@sql)

     end
 
--   select @sql
   print(@sql)   

   delete from #Tabela where cd_tabela = @cd_tabela_aux and cd_atributo = @cd_atributo
 
  end

  --select * from #Tabela

  --Apresenta o Resultado Final

  select @cSQL = 'select t.cd_tabela, a.cd_atributo, t.nm_tabela, a.nm_atributo, cast(isnull(a.ds_campo_help,'+''''''+') as varchar(255)) as ds_campo_help'+
                 ' from ' + @nm_usuario_logado + '.' + 'CONSULTA_PARAMETRO cp '+
                 ' inner join egisadmin.dbo.tabela t   on t.cd_tabela = cp.cd_tabela '+
                 ' inner join egisadmin.dbo.atributo a on a.cd_tabela = cp.cd_tabela and a.cd_atributo = cp.cd_atributo '+
                 ' order by t.nm_tabela, a.cd_atributo '

  print(@cSQL)
  exec(@cSQL )

