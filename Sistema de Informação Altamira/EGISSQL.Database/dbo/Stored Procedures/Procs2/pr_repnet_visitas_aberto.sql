




--pr_repnet_visitas_aberto
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Visitas em Aberto por Vendedor/Cliente
--Data          : 07.04.2002
--Atualizado    : 
---------------------------------------------------------------------------------------
create procedure pr_repnet_visitas_aberto
@cd_vendedor      int,
@dt_inicial       datetime,
@dt_final         datetime
as

Select 
  v.dt_visita           as 'DataVisita',
  t.nm_tipo_visita      as 'TipoVisita',
  c.nm_fantasia_cliente as 'Cliente',
  d.nm_contato_cliente  as 'Contato',
  v.nm_assunto_visita   as 'Assunto',
  v.ds_visita           as 'Observacao'
      
From 
  Visita v,Tipo_Visita t,Cliente c, Cliente_Contato d
Where 
    v.cd_vendedor = @cd_vendedor    and
    v.dt_visita between @dt_inicial and @dt_final and
    v.cd_tipo_visita = t.cd_tipo_visita and
    v.cd_cliente  = c.cd_cliente    and
    c.cd_cliente  = d.cd_cliente    and
    v.cd_contato  = d.cd_contato    
    
order by 
    v.dt_visita desc,c.nm_fantasia_cliente




