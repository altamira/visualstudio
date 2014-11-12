

/****** Object:  Stored Procedure dbo.pr_consulta_ordem_servico_aguardando_aprovacao    Script Date: 13/12/2002 15:08:21 ******/

CREATE  procedure pr_consulta_ordem_servico_aguardando_aprovacao
@dt_inicial datetime,
@dt_final datetime,
@cd_ordem_servico int
as

select 
  cl.nm_fantasia_cliente,
  o.cd_ordem_servico,
  cl.nm_razao_social_cliente,
  o.dt_ordem_servico,
  o.dt_entrega_ordem_servico,
  o.vl_total_ordem_servico,
  t.nm_fantasia_tecnico,
  a.nm_atendimento
from 
  ordem_servico o
  left outer join cliente cl    
                              on o.cd_cliente=cl.cd_cliente
left outer join tecnico t     
                              on o.cd_tecnico=t.cd_tecnico
left outer join atendimento a 
                              on o.cd_tipo_atendimento=a.cd_atendimento

where ((@cd_ordem_servico = 0) and (o.dt_ordem_servico between @dt_inicial and @dt_final)) 
        or (o.cd_ordem_servico = @cd_ordem_servico)





