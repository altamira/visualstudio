
-------------------------------------------------------------------------------
--pr_configura_usuario_ocorrencia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Configuração de todos os usuários para utilizar o 
--                   Comunicado de ocorrência
--Data             : 04.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_configura_usuario_ocorrencia
as

--select * from empresa

--Configuração da Empresa

update
  empresa
set
  qt_time_verif_ocorrencia = 5,
  qt_time_mostra_ocorrencia = 15,
  ic_ocorrencia_empresa = 'S'
where
  cd_empresa = egissql.dbo.fn_empresa()    

--Configuração dos Usuários

--select * from usuario

update
  usuario
set
  ic_ocorrencia_usuario = 'S'



