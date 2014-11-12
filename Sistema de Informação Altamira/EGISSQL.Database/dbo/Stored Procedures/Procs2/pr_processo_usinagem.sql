--pr_processo_usinagem  
-------------------------------------------------------------------------------------------  
-- Polimold  
-- Stored Procedure : SQL Server  
-- Autor(es)        : Cleiton Marques  
-- Banco de Dados   : EGISSQL  
-- Objetivo         : Consulta dos Processos de Usinagem  
-- Data             : 23/01/2003   
-- Atualizado       :   
CREATE PROCEDURE pr_processo_usinagem  
@cd_maquina int,            
@cd_magazine int,  
@cd_processo_usinagem int,  
@cd_placa int  
  
  
as  
  
select a.cd_maquina,  
       a.cd_magazine,  
       a.cd_processo_usinagem,  
       a.cd_placa,  
       a.cd_usuario,  
       a.dt_usuario,  
       a.cd_operacao_usinagem,  
       b.nm_operacao_usinagem,  
       a.cd_sequencia_usinagem,  
       c.nm_sequencia_usinagem,  
       a.cd_ordem,
       a.ic_rasgo_placa  
from Egissql.dbo.Processo_usinagem_composicao a,  
     Egissql.dbo.Operacao_usinagem b,  
     Egissql.dbo.sequencia_usinagem c  
where a.cd_maquina=@cd_maquina and  
      a.cd_magazine=@cd_magazine and  
      a.cd_processo_usinagem=@cd_processo_usinagem and  
      a.cd_placa=@cd_placa and  
      b.cd_operacao_usinagem=a.cd_operacao_usinagem and  
      c.cd_sequencia_usinagem=a.cd_sequencia_usinagem  
order by a.cd_ordem  
  
  
  

