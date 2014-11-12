--pr_repnet_perdas_periodo  
-----------------------------------------------------------------------------------  
--GBS-Global Business Solution Ltda                                            2000                       
--Stored Procedure : SQL Server Microsoft 2000    
--Carlos Cardoso Fernandes           
--Consultas das Consultas Perdidas por Vendedor  
--Data          : 07.04.2002  
--Atualizado    : 21.01.2000   
-----------------------------------------------------------------------------------  
CREATE   procedure pr_repnet_perdas_periodo  
@ic_tipo_usuario varchar(10),  
@cd_tipo_usuario int,  
@dt_inicial      datetime,  
@dt_final        datetime   
as  
  
if @ic_tipo_usuario='Vendedor'  
begin  
select  
   d.dt_perda_consulta     as 'Data Perda',  
   isnull(m.nm_motivo_perda,'')       as 'Perda',  
   isnull(n.nm_concorrente,'')        as 'Concorrente',  
   isnull(c.nm_fantasia_cliente,'')   as 'Cliente',  
   a.cd_consulta           as 'Consulta',  
   a.dt_consulta           as 'Data',  
   b.cd_item_consulta      as 'Item',  
   isnull(b.qt_item_consulta,0)      as 'Qtd',  
   isnull(b.nm_fantasia_produto,'')   as 'Descricao',  
  isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),0) as 'Preco',  
  isnull((b.qt_item_consulta*d.vl_perda_consulta ),0)        as 'PrecoConcorrente',  
  isnull((100-( ( (b.qt_item_consulta*d.vl_perda_consulta) /  
           case when isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) = 0 then 1 else isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) end )*100 ) ),0) as 'perc'  
From  
   Cliente c  
   left outer join Consulta a  
   on (a.cd_cliente  = c.cd_cliente)  
   left outer join Consulta_Itens b  
   on (a.cd_consulta = b.cd_consulta)  
   left outer join Consulta_item_Perda d  
   on (b.cd_consulta = d.cd_consulta and b.cd_item_consulta=d.cd_item_consulta)  
   left outer join Motivo_Perda m  
   on (m.cd_motivo_perda=d.cd_motivo_perda)  
   left outer join Concorrente n  
   on (n.cd_concorrente=d.cd_concorrente)  
Where  
  a.cd_vendedor  = @cd_tipo_usuario      and  
  d.dt_perda_consulta between @dt_inicial and @dt_final  
order by 1 desc  
end  
  
if @ic_tipo_usuario='Cliente'  
begin  
select  
   d.dt_perda_consulta     as 'Data Perda',  
   isnull(m.nm_motivo_perda,'')       as 'Perda',  
   isnull(n.nm_concorrente,'')        as 'Concorrente',  
   isnull(c.nm_fantasia_cliente,'')   as 'Cliente',  
   a.cd_consulta           as 'Consulta',  
   a.dt_consulta           as 'Data',  
   b.cd_item_consulta      as 'Item',  
   isnull(b.qt_item_consulta,0)      as 'Qtd',  
   isnull(b.nm_fantasia_produto,'')   as 'Descricao',  
  isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),0) as 'Preco',  
  isnull((b.qt_item_consulta*d.vl_perda_consulta ),0)        as 'PrecoConcorrente',  
  isnull((100-( ( (b.qt_item_consulta*d.vl_perda_consulta) /  
           case when isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) = 0 then 1 else isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) end )*100 ) ),0) as 'perc'  
From  
   Cliente c  
   left outer join Consulta a  
   on (a.cd_cliente  = c.cd_cliente)  
   left outer join Consulta_Itens b  
   on (a.cd_consulta = b.cd_consulta)  
   left outer join Consulta_item_Perda d  
   on (b.cd_consulta = d.cd_consulta and b.cd_item_consulta=d.cd_item_consulta)  
   left outer join Motivo_Perda m  
   on (m.cd_motivo_perda=d.cd_motivo_perda)  
   left outer join Concorrente n  
   on (n.cd_concorrente=d.cd_concorrente)  
Where  
  a.cd_cliente  = @cd_tipo_usuario      and  
  d.dt_perda_consulta between @dt_inicial and @dt_final  
order by 1 desc  
end  
  
if @ic_tipo_usuario='Supervisor'  
begin  
select  
   d.dt_perda_consulta     as 'Data Perda',  
   isnull(m.nm_motivo_perda,'')       as 'Perda',  
   isnull(n.nm_concorrente,'')        as 'Concorrente',  
   isnull(c.nm_fantasia_cliente,'')   as 'Cliente',  
   a.cd_consulta           as 'Consulta',  
   a.dt_consulta           as 'Data',  
   b.cd_item_consulta      as 'Item',  
   isnull(b.qt_item_consulta,0)      as 'Qtd',  
   isnull(b.nm_fantasia_produto,'')   as 'Descricao',  
  isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),0) as 'Preco',  
  isnull((b.qt_item_consulta*d.vl_perda_consulta ),0)    as 'PrecoConcorrente',  
  isnull((100-( ( (b.qt_item_consulta*d.vl_perda_consulta) /  
           case when isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) = 0 then 1 else isnull((b.qt_item_consulta*b.vl_unitario_item_consulta),1) end )*100 ) ),0) as 'perc'  
From  
   Cliente c  
   left outer join Consulta a  
   on (a.cd_cliente  = c.cd_cliente)  
   left outer join Consulta_Itens b  
   on (a.cd_consulta = b.cd_consulta)  
   left outer join Consulta_item_Perda d  
   on (b.cd_consulta = d.cd_consulta and b.cd_item_consulta=d.cd_item_consulta)  
   left outer join Motivo_Perda m  
   on (m.cd_motivo_perda=d.cd_motivo_perda)  
   left outer join Concorrente n  
   on (n.cd_concorrente=d.cd_concorrente)  
Where  
  d.dt_perda_consulta between @dt_inicial and @dt_final  
order by 1 desc  
end  
  
  
  
  

