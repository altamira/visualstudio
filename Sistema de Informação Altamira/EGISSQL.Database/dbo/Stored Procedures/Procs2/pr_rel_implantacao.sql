
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel C. Neto
--Banco de Dados: EGISSQL 
--Objetivo      : Listagem das RA
--Data          : 26/09/2006
----------------------------------------------------------------------
create procedure pr_rel_implantacao
@nm_fantasia_cliente varchar(50),
@dt_inicial datetime,
@cd_consultor int,
@cd_projeto int = null,
@ic_status char(1)

as
  set dateformat dmy

	
  -- DESENVOLVIDOS NA EMPRESA
SELECT     
  rac.cd_registro_atividade, 
  rac.dt_registro_atividade, 
  rac.dt_inicio_atividade, 
  ci.nm_fantasia_consultor, 
  c.nm_razao_social_cliente, 
  c.nm_fantasia_cliente, 
  ai.nm_atividade, 
  ai.qt_ordem_atividade, 
  ai.qt_hora_atividade, 
  cl.nm_logotipo_cliente, 
  lt.nm_local_tarefa, 
  rac.nm_responsavel_cliente, 
  rac.nm_ra,
  ( select count(*)
    from EGISADMIN.dbo.Menu_historico h
    where
      h.cd_registro_atividade = rac.cd_registro_atividade ) as qtd_engenharia,
  cast(tai.cd_tarefa_atividade as varchar) + ' - ' + tai.nm_tarefa_atividade as Tarefa,
   ( case when rac.dt_conclusao_atividade is not null then 'Concluida'
      else 'Aberto' end ) as Status,
  m.sg_modulo,
  men.nm_menu

FROM         
  Registro_Atividade_Cliente rac left outer join
  Cliente c ON rac.cd_cliente = c.cd_cliente left outer join
  Consultor_Implantacao ci ON rac.cd_consultor = ci.cd_consultor left outer join
  Atividade_Implantacao ai ON rac.cd_atividade_analista = ai.cd_atividade left outer join
  Cliente_Logotipo cl ON c.cd_cliente = cl.cd_cliente left outer join
  Local_Tarefa lt ON rac.cd_local_tarefa = lt.cd_local_tarefa left outer join
  EGISADMIN.dbo.Modulo m on m.cd_modulo = rac.cd_modulo left outer join
  EGISADMIN.dbo.Menu men on men.cd_menu = rac.cd_menu left outer join
  Tarefa_Atividade_Implantacao tai ON rac.cd_tarefa_atividade = tai.cd_tarefa_atividade AND 
                                      ai.cd_atividade = tai.cd_atividade
  
where 
  c.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and 
  cast(convert(varchar,dt_final_atividade,103) as datetime) >=  cast(convert(varchar,@dt_inicial,103) as datetime) and 
  ( case when ((@ic_status = '0') and ( rac.dt_conclusao_atividade is null ))  then 1
             when ((@ic_status = '1') and ( rac.dt_conclusao_atividade is not null )) then 1
             when ((@ic_status = '2')) then 1
    else 0 end ) = 1 and
  isnull(rac.cd_consultor,0) = (case when (isnull(@cd_consultor,0)<>0) then @cd_consultor
                           else isnull(rac.cd_consultor,0) end ) and
  isnull(rac.cd_projeto_sistema,0) = (case when (isnull(@cd_projeto,0)<>0) then @cd_projeto
                         else isnull(rac.cd_projeto_sistema,0) end )
order by
  c.nm_razao_social_cliente, 
  ai.qt_ordem_atividade,
  ai.nm_atividade



