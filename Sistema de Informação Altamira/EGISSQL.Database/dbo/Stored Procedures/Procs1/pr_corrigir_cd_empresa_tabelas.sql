CREATE PROCEDURE pr_corrigir_cd_empresa_tabelas    
  @ic_parametro int = 0,    
  @cd_empresa_atual int = 14,    
  @cd_empresa_nova int  = 1    
    
As    
-- Caso for implantação - TRIGGERS    
-----------------------------------------------------------------------------    
SELECT    
 name,    
 owner = OBJECT_NAME (parent_obj)    
  into #TableTriggers    
FROM sysobjects    
WHERE  type = 'TR' and    
    OBJECTPROPERTY (id, 'ExecIsTriggerDisabled') = 0    
-----------------------------------------------------------------------------    
    
    
SELECT 'ALTER TABLE ' +    
       QUOTENAME( c.TABLE_NAME ) +    
       ' NOCHECK CONSTRAINT ' +    
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT    
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c    
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'    
-- Caso for implantação    
-----------------------------------------------------------------------------    
union all    
SELECT 'ALTER TABLE ' +    
       'EGISADMIN.dbo.' +Name +    
       ' NOCHECK CONSTRAINT ' +    
       Constraints AS ALTER_SCRIPT    
FROM  EGISADMIN.dbo.vw_implantacao_admin_chaves_estrangeiras    
where  @ic_parametro = 1    
-----------------------------------------------------------------------------    
    
union all    
    
-- Caso for implantação - Triggers    
-----------------------------------------------------------------------------    
 Select     
  'ALTER TABLE ' + owner +' Disable TRIGGER ' + name    
 from  #TableTriggers    
    
-----------------------------------------------------------------------------    
    
union all    
    
select 'delete '+t.name+    
' where cd_empresa not in ('+cast(@cd_empresa_atual as varchar)+','+    
cast(@cd_empresa_nova as varchar)+')'    
as comandosql    
from syscolumns c, sysobjects t,dbo.sysindexes i     
where t.id = c.id and c.name = 'cd_empresa' and     
    OBJECTPROPERTY(t.id, N'IsTable') = 1 and     
      i.id = t.id and     
      i.indid < 2 and     
      t.name not like N'#%'    
    
-- Caso for implantação    
-----------------------------------------------------------------------------    
    
union all    
    
select 'delete EGISADMIN.dbo.'+t.comandosql+    
' where cd_empresa not in ('+cast(@cd_empresa_atual as varchar)+','+    
cast(@cd_empresa_nova as varchar)+')'    
as comandosql    
from EGISADMIN.dbo.vw_implantacao_consulta_tabela_cd_empresa t    
where  @ic_parametro = 1    
    
    
    
-----------------------------------------------------------------------------    
    
-- Caso for implantação    
-----------------------------------------------------------------------------    
-- union all    
-- select 'insert into EGISADMIN.dbo.Empresa(cd_empresa, nm_empresa, nm_fantasia_empresa) Values('+Cast(@cd_empresa_nova as varchar(5))+', ''Empresa Nova'', ''Empresa em Implantação'')'where  @ic_parametro = 1    
    
union all    
    
select 'Delete from EGISADMIN.dbo.Empresa where not(cd_empresa in  ('+Cast(@cd_empresa_nova as varchar(5))+','+Cast(@cd_empresa_atual as varchar(5))+'))'where  @ic_parametro = 1    
    
union all    
    
-----------------------------------------------------------------------------    
select 'update '+t.name+' set cd_empresa = '+cast(@cd_empresa_nova as varchar)    
as comandosql    
from syscolumns c, sysobjects t,dbo.sysindexes i     
where  t.id = c.id and c.name = 'cd_empresa' and     
    OBJECTPROPERTY(t.id, N'IsTable') = 1 and     
      i.id = t.id and     
      i.indid < 2 and     
      t.name not like N'#%'    
    
-- Caso for implantação    
-----------------------------------------------------------------------------    
    
union all    
    
select 'update EGISADMIN.dbo.'+t.comandosql+' set cd_empresa = '+cast(@cd_empresa_nova as varchar)    
as comandosql    
from EGISADMIN.dbo.vw_implantacao_consulta_tabela_cd_empresa t    
where  @ic_parametro = 1    
-----------------------------------------------------------------------------    
    
union all    
    
-- Caso for implantação    
------------------------------------------------------------------------------------------------------------------------    
select 'Delete from '+(Case isnull(t.cd_banco_dados,0)  when 1 then 'EgisAdmin' else db_name() end)+'.dbo.' + nm_tabela    
from  EGISADMIN.dbo.tabela  t    
WHERE isnull(ic_implantacao_tabela,'N') = 'S' AND      
      isnull(ic_inativa_tabela, 'N') = 'N' AND      
      isnull(ic_sap_admin, 'N') = 'N'  and     
      @ic_parametro = 1    
    
union all    
    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Acesso_Automatico  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Agenda  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Aprovacao  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Assinatura  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
Select 'Delete from  Usuario_Autorizacao_Aprovacao  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_BDE  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Classe_TabSheet  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Cliente_Sistema  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Config  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Contato  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Contato_Endereco  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Dica  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Email  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Empresa  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Grupo_Ocorrecia_Pedido_venda  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_GrupoUsuario  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Info_Gerencial  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Internet  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Lembrete  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Log  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Menu_Internet  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Usuario_Modulo  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Usuario_Nota  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
Select 'Delete from  Usuario_Tarefa  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Menu_Usuario  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Grafico_Usuario  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  Grafico_Usuario_Parametro  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Grupo_Usuario_Classe_Tabsheet  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Grupo_Usuario_Menu  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.GrupoUsuario  where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.LogUsuario   where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from  EGISADMIN.dbo.Menu_Historico where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Delete from EGISADMIN.dbo.Usuario where cd_usuario <> 1' where  @ic_parametro = 1    
    
union all    
    
select 'Update EGISADMIN.dbo.Empresa set cd_empresa = '+Cast(@cd_empresa_nova as varchar(10)) where  @ic_parametro = 1    
    
----------------------------------------------------------------------------------------------------------------------    
union all    
    
SELECT 'ALTER TABLE ' +    
       QUOTENAME( c.TABLE_NAME ) +    
       ' CHECK CONSTRAINT ' +    
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT    
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c    
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'    
    
union all    
    
-- Caso for implantação    
-----------------------------------------------------------------------------    
SELECT 'ALTER TABLE ' +    
       'EGISADMIN.dbo.' +Name +    
       ' CHECK CONSTRAINT ' +    
       Constraints AS ALTER_SCRIPT    
FROM  EGISADMIN.dbo.vw_implantacao_admin_chaves_estrangeiras    
where  @ic_parametro = 1    
-----------------------------------------------------------------------------    
    
union all    
    
-- Caso for implantação - Triggers    
-----------------------------------------------------------------------------    
 Select     
  'ALTER TABLE ' + owner +' Enable TRIGGER ' + name    
 from  #TableTriggers    
    
-----------------------------------------------------------------------------    
    
drop table #TableTriggers    
  

