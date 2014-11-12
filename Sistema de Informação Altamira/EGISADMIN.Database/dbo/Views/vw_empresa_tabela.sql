
CREATE VIEW vw_empresa_tabela
------------------------------------------------------------------------------------
--vw_empresa_tabela
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISADMIN
--Objetivo	        : Montagem das Tabelas que deverão ter Cadastros
--                        da empresa Origem para as Empresas
--Data                  : 08.06.2007
--Atualização           : 
------------------------------------------------------------------------------------

as

--select * from empresa_tabela
  
    select
      e.cd_empresa,
      e.nm_fantasia_empresa,
      et.cd_empresa_destino,
      x.nm_fantasia_empresa  as  nm_fantasia_empresa_destino,
      x.nm_banco_empresa,
      x.nm_banco_origem,
      t.nm_tabela
      
    from
      Empresa e
      inner join Empresa_Tabela et  with (nolock) on et.cd_empresa = e.cd_empresa
      inner join Empresa        x   with (nolock) on x.cd_empresa  = et.cd_empresa_destino
      inner join Tabela         t   with (nolock) on t.cd_tabela   = et.cd_tabela
   
