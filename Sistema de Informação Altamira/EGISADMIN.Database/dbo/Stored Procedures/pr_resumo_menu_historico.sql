
--------------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                                           2004
--------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Elias Pereira da Silva
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo da quantidade de OS resolvidas
--Data             : 13/08/2004
--Atualizado       : 24/08/2004 - Acerto no campo de Data, não considerar horas.
--                       - Daniel C. Neto.
--                 : 16.11.2004 - Criado uma coluna mês - Carlos Fernandes
--                 : 04/12/2004 - Acertado quando não existe a entrada de OS no dia, somente saída
--                 : 24/12/2004 - Verificação porque não está sainda Sábado/Domingo
--                 : 02.01.2006 - Consulta do perído sem entrada de novas OS 
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_menu_historico
@dt_inicial datetime,
@dt_final   datetime

as

create table #OS (
  Data         datetime,
  Entrada      int,
  Desenvolvido int,
  Homologado   int,
  Compilado    int,
  Previsto     int,
  Retrabalho   int,
  FinalSemana  char(1))


insert into #OS
select 
  distinct 
  dt_usuario as Data,
  0          as Entrada,
  0          as Desenvolvido,
  0          as Homologado,
  0          as Compilado,
  0          as Previsto,
  0          as Retrabalho,
  case when (datepart(dw,dt_usuario) = 1) or 
            (datepart(dw,dt_usuario) = 7) 
  then 'S' else 'N' end as FinalSemana
from 
  menu_historico 
where 
  dt_usuario between @dt_inicial and @dt_final
order by 
  dt_usuario

declare @dt_aux      datetime
declare @cd_controle int

set @dt_aux = @dt_inicial

--print @dt_aux
--print @dt_inicial
--print @dt_final

while @dt_aux <= @dt_final
begin

  set @cd_controle = 1

  if exists( select data from #OS where @dt_aux = Data )
  begin
    set @cd_controle = 0
  end
       
  --print @cd_controle
                                                                    
  if @cd_controle = 1 
  begin

    insert into #OS
    select 
      @dt_aux    as Data,
      0          as Entrada,
      0          as Desenvolvido,
      0          as Homologado,
      0          as Compilado,
      0          as Previsto,
      0          as Retrabalho,
      case when (datepart(dw,@dt_aux) = 1) or 
                (datepart(dw,@dt_aux) = 7) 
      then 'S' else 'N' end as FinalSemana    
  end

  set @dt_aux = @dt_aux + 1

end

--select * from #OS
-- select * from menu_historico

--Desenvolvido

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
  distinct dt_homologacao as Data,
  count(*) as Homologado
into
  #Homologado
from menu_historico 
where 
  convert(varchar,dt_homologacao,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by dt_homologacao

--select * from #homologado

update #OS 
  set Homologado = h.Homologado
from 
  #Homologado h, #OS os
where 
  convert(varchar,h.Data,103) = convert(varchar,os.Data,103)

select 
  distinct dt_compilacao as Data,
  count(*) as Compilado
into
  #Compilado
from menu_historico 
where 
  convert(varchar,dt_compilacao,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by dt_compilacao

--select * from #Compilado

update #OS 
  set Compilado = c.Compilado
from 
  #Compilado c, #OS os
where 
  convert(varchar,c.Data,103) = convert(varchar,os.Data,103)

select 
  distinct dt_prevista_os as Data,
  count(*) as Previsto
into
  #Previsto
from menu_historico 
where 
  convert(varchar,dt_prevista_os,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by dt_prevista_os

update #OS 
  set Previsto = p.Previsto
from 
  #Previsto p, #OS os
where 
  convert(varchar,p.Data,103) = convert(varchar,os.Data,103) 

--select * from #Previsto

select 
  distinct dt_usuario as Data,
  count(*) as Retrabalho
into
  #Retrabalho
from menu_historico 
where (dt_homologacao between @dt_inicial and @dt_final or
       dt_prevista_os between @dt_inicial and @dt_final or
       dt_compilacao between @dt_inicial and @dt_final) and
      isnull(ic_retrabalho,'N') = 'S'
group by dt_usuario

--select * from #Retrabalho

update #OS 
  set Retrabalho = r.Retrabalho
from 
  #Retrabalho r, #OS os
where 
  convert(varchar,r.Data,103) = convert(varchar,os.Data,103)

select 
  distinct data,
  os.*,
  (select (sum(Entrada - Desenvolvido)) from #OS os1
   where os1.Data <= os.Data) as EmAberto,
  month(data) as Mes,
  year(data)  as Ano
from 
  #OS os 
--where 
--  FinalSemana = 'N'
order by 
  Data


