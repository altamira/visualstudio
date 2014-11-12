
-------------------------------------------------------------------------------
--pr_desconfigura_usuario_ocorrencia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Remove a Configuração de todos os usuários para utilizar o 
--                   Comunicado de ocorrência
--Data             : 04.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_desconfigura_usuario_ocorrencia
as

--select * from empresa

--Configuração da Empresa

update
  empresa
set
  ic_ocorrencia_empresa = 'N'
where
  cd_empresa = egissql.dbo.fn_empresa()    

--Configuração dos Usuários

--select * from usuario

update
  usuario
set
  ic_ocorrencia_usuario = 'N'



