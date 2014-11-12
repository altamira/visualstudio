
CREATE PROCEDURE pr_consulta_tabela_inativa
   @ic_parametro Integer,
   @cd_tabela integer

AS

begin
--******************************************************************************************
if @ic_parametro = 1
--******************************************************************************************
begin
 Select 
   t.cd_tabela,
   t.nm_tabela,
   t.ds_tabela,
   t.dt_criacao_tabela,
   t.ic_inativa_tabela,
   pt.qt_prioridade_tabela
 from 
   dbo.Tabela t left outer join
   Prioridade_Tabela pt on (t.cd_prioridade_tabela = pt.cd_prioridade_tabela )
 where 
   t.ic_inativa_tabela = 'S'
 order by
   pt.qt_prioridade_tabela desc

	 
end

else
--******************************************************************************************
if @ic_parametro = 2
--******************************************************************************************
begin
 Select 
   t.cd_tabela,
   t.nm_tabela,
   t.ds_tabela,
   t.dt_criacao_tabela,
   t.ic_inativa_tabela,
   pt.qt_prioridade_tabela
 from 
   dbo.Tabela t left outer join
   Prioridade_Tabela pt on (t.cd_prioridade_tabela = pt.cd_prioridade_tabela )

 where 
   t.ic_inativa_tabela = 'S' and
   t.cd_tabela = @cd_tabela
 order by
   pt.qt_prioridade_tabela desc
end

end



