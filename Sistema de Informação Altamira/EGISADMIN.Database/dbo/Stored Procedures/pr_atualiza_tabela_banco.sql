
---------------------------------------------------------------------------------------
--pr_atualiza_tabela_banco
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Autor            : Carlos Cardoso Fernandes
--Objetivo         : Consulta dos Atributos por Tabela
--Data             : 31.12.2002
--Atualizado       : 19/10/2004
--                 : Não pegar tabelas Inativas - Daniel C. Neto.
--                 : 27.10.2007 - Ajustes Diversos - Carlos Fernandes
---------------------------------------------------------------------------------------

CREATE procedure pr_atualiza_tabela_banco

@ic_parametro int,
@dt_inicial   DateTime,
@dt_final     DateTime,
@cd_tabela    int = 0
as

-- Montagem da Tabela de Criação de Atributos em Ordem de Prioridade


select
   t.cd_tabela                  as 'Codigo',
   max(pt.cd_prioridade_tabela) as 'Ordem'
into #tabela_codigo  
from 
   Tabela t, Atributo a, Prioridade_Tabela pt
where 
   1 = (	case isnull(@cd_tabela,0)
		  	when 0 then
				case when  a.dt_usuario between @dt_Inicial and @dt_final then
						1
					else
						0
					end
			else
				1
			end)  and  
  (t.cd_tabela            = a.cd_tabela)             and
  (t.cd_prioridade_tabela = pt.cd_prioridade_tabela ) and
  IsNull(t.ic_inativa_tabela,'N') = 'N' and  
  isnull(t.cd_tabela,0) = case isnull(@cd_tabela,0) when 0 then   isnull(t.cd_tabela,0) else isnull(@cd_tabela,0) end
group by
  t.cd_tabela
order by 2

-- Tabela Final para Rotina Automática de Criação

Select 
	Codigo
from
	#Tabela_Codigo
order by
	Ordem

