
--------------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                                           2004
--------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo da quantidade de OS Entrada/Saída por Mês
--Data             : 24/12/2004
--Atualizado       : 02.01.2006 - Acerto do Resumo
--                   
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_menu_historico_mensal
@dt_inicial datetime,
@dt_final   datetime

as

create table #OS (
  Data datetime,
  Entrada int,
  Desenvolvido int,
  Homologado int,
  Compilado int,
  Previsto int,
  Retrabalho int)


insert into #OS
select 
  distinct 
  dt_usuario as Data,
  0          as Entrada,
  0          as Desenvolvido,
  0          as Homologado,
  0          as Compilado,
  0          as Previsto,
  0          as Retrabalho
from 
  menu_historico 
where 
  convert(varchar,dt_usuario,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
order by 
  dt_usuario

--select * from #OS

declare @dt_aux      datetime
declare @cd_controle int

--select @dt_aux = max(dt_usuario) + 1 from menu_historico

select @dt_aux = @dt_inicial

while @dt_aux <= @dt_final
begin

  set @cd_controle = 1

  if exists( select data from #OS where @dt_aux = Data )
  begin
    set @cd_controle = 0
  end


  --select @cd_controle = case when isnull(Data,0)=0 then 0 else 1 end from #OS where @dt_aux = Data
                                                                           
  if @cd_controle = 1 
  begin

--    select @dt_aux,@cd_controle

    insert into #OS
    select 
      @dt_aux    as Data,
      0          as Entrada,
      0          as Desenvolvido,
      0          as Homologado,
      0          as Compilado,
      0          as Previsto,
      0          as Retrabalho
  end

  set @dt_aux = @dt_aux + 1

end

--select * from #OS
-- select * from menu_historico

select 
  distinct convert(varchar,dt_fim_desenvolvimento,103) as Data,
  count(*) as Desenvolvido
into
  #Desenvolvido
from menu_historico 
where 
  convert(varchar,dt_fim_desenvolvimento,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by 
  convert(varchar,dt_fim_desenvolvimento,103)

--select * from #Desenvolvido

update #OS 
  set Desenvolvido = d.Desenvolvido
from 
  #Desenvolvido d, #OS os
where 
  convert(varchar,d.Data,103) = convert(varchar,os.Data,103)

select 
  distinct dt_usuario as Data,
  count(*) as Entrada
into
  #Entrada
from menu_historico 
where 
  convert(varchar,dt_usuario,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by dt_usuario

--select * from #Entrada

update #OS 
  set Entrada = e.Entrada
from 
  #Entrada e, #OS os
where convert(varchar,e.Data,103) = convert(varchar,os.Data,103)


select 
  distinct data,
  Entrada,
  Desenvolvido
into #Resumo
from 
  #OS 

--select * from #Resumo

select 
  month(data)                 as Mes,
  year(data)                  as Ano,
  sum(Entrada)                as Entrada,
  sum(Desenvolvido)           as Desenvolvido,
  sum(Desenvolvido - Entrada) as Total,
  sum(0)                      as Engenheiro
from #Resumo
group by
  year(data),month(data)
order by
  year(data) desc,month(data)


