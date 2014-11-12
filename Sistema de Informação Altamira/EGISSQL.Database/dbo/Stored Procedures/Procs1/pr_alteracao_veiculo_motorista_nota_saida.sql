
-------------------------------------------------------------------------------
--sp_helptext pr_alteracao_veiculo_motorista_nota_saida
-------------------------------------------------------------------------------
--pr_alteracao_veiculo_motorista_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Alteração de Veículo/Motorista das Notas de Saída
--Data             : 12.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_alteracao_veiculo_motorista_nota_saida
@cd_nota_saida        int      = 0,
@dt_nota_saida        datetime = '',
@cd_vendedor          int      = 0,
@cd_veiculo_origem    int      = 0,
@cd_veiculo_destino   int      = 0,
@cd_motorista_origem  int      = 0,
@cd_motorista_destino int      = 0,
@cd_usuario           int      = 0

as

select
  ns.cd_nota_saida,
  ns.cd_veiculo,
  ns.cd_motorista
into
  #AlteraVeiculo
from
  Nota_Saida ns 
where
  ns.dt_nota_saida = @dt_nota_saida and --Data de Emissão da Nota
  ns.cd_veiculo    = @cd_veiculo_origem                                                                    and
  ns.cd_motorista  = case when @cd_motorista_origem = 0 then ns.cd_motorista else @cd_motorista_origem end and
  ns.cd_vendedor   = @cd_vendedor 
 

--select * from #AlteraVeiculo

update
  nota_saida
set
  cd_veiculo   = @cd_veiculo_destino,
  cd_motorista = case when @cd_motorista_destino = 0 then ns.cd_motorista else @cd_motorista_destino end
from
  Nota_Saida ns
  inner join #AlteraVeiculo av on av.cd_nota_saida = ns.cd_nota_saida 

                                  
drop table #AlteraVeiculo


