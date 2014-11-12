
CREATE PROCEDURE pr_consulta_maquina_operacao

@cd_maquina    int

AS


SELECT     IDENTITY(int, 1,1) AS 'Item',
           mo.cd_operacao, 
           ma.nm_fantasia_maquina,
           o.nm_fantasia_operacao, 
           mo.qt_prioridade_maq_oper, 
           mo.pc_efic_maquina_operacao, 
           mo.pc_red_efic_maq_operacao, 
           mo.qt_tempo_maquina_operacao, 
           mo.nm_obs_maquina_operacao, 
           mo.pc_custo_maq_operacao,
	   gm.nm_grupo_maquina

into       #MaquinaOperacao

FROM       Maquina_Operacao mo INNER JOIN
           Operacao o ON mo.cd_operacao = o.cd_operacao  left outer join
           Maquina ma on ma.cd_maquina = mo.cd_maquina left outer join
	   Grupo_Maquina gm on gm.cd_grupo_maquina = ma.cd_grupo_maquina

where     ((mo.cd_maquina = @cd_maquina) or (@cd_maquina = 0)) 

order by  mo.cd_maquina

select * from #MaquinaOperacao

drop table #MaquinaOperacao
      
