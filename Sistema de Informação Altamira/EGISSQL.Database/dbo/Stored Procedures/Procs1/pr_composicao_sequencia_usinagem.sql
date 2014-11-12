
--pr_processo_usinagem
-------------------------------------------------------------------------------------------
-- Polimold
-- Stored Procedure : SQL Server
-- Autor(es)        : Cleiton Marques
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta da Composição da Sequencia de Usinagem
-- Data             : 23/01/2003	
-- Atualizado       : 
CREATE PROCEDURE pr_composicao_sequencia_usinagem
@cd_maquina int,          
@cd_magazine int,
@cd_sequencia_usinagem int,
@cd_placa int


as

select a.cd_maquina,
       a.cd_magazine,
       a.cd_sequencia_usinagem,
       a.cd_placa,
       a.cd_item,
       a.cd_posicao_ferramenta,
       a.cd_bloco_prog_cnc,
       e.nm_prog_cnc,
       a.cd_ciclo_fixo_maquina,
       b.nm_ciclo_fixo_maquina,
       a.cd_sub_rotina,
       c.sg_sub_rotina,
       a.cd_ordem,
       a.cd_usuario,
       a.dt_usuario,
       a.qt_peso_min,
       a.qt_peso_max,
       a.ic_montagem_g,
       a.ic_rotina_pos,
       a.ic_chk_curso_ext,
       a.ic_uti_montagem_g,
       a.ic_usi_placa_especial,
       a.ic_chk_rotina_rasgo,
       a.ic_chk_rotina_proc_esp,
       a.ic_bloco_barrado,
       a.nm_observacao


       --c.sg_sub_rotina
from Egissql.dbo.sequencia_usinagem_composicao a
     left outer join Egissql.dbo.Sub_Rotina_Prog_Cnc c
       ON a.cd_sub_rotina=c.cd_sub_rotina
     left outer join Egissql.dbo.ciclo_fixo_maquina b
       ON a.cd_ciclo_fixo_maquina=b.cd_ciclo_fixo_maquina and
          a.cd_maquina=b.cd_maquina
      left outer join maquina d
       ON a.cd_maquina=d.cd_maquina
      left outer join programacao_cnc e
       ON d.cd_comando=e.cd_comando and
          a.cd_bloco_prog_cnc=e.cd_prog_cnc 
      
where a.cd_maquina=@cd_maquina and
      a.cd_magazine=@cd_magazine and
      a.cd_sequencia_usinagem=@cd_sequencia_usinagem and
      a.cd_placa=@cd_placa
order by a.cd_ordem


--select * from programacao_cnc


