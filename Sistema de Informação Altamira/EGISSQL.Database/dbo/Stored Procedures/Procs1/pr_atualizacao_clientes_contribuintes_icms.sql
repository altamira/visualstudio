
-------------------------------------------------------------------------------
--pr_atualizacao_clientes_contribuintes_icms
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização dos Clientes Contribuintes do ICMS
--                   conforme o tipo de pessoa
--Data             : 05.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualizacao_clientes_contribuintes_icms

as

 --select * from cliente
 --select * from tipo_pessoa


 update
   cliente
 set
   ic_contrib_icms_cliente = case when cd_tipo_pessoa = 1 then 'S' else
                                  case when cd_tipo_pessoa = 2 then 'N' else 'S' end
                             end,
   ic_mp66_cliente         = isnull(ic_mp66_cliente,'N')
                                                          
