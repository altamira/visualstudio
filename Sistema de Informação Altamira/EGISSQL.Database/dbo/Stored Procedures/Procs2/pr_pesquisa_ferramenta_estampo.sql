
-------------------------------------------------------------------------------
--sp_helptext pr_pesquisa_ferramenta_estampo
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Estampo / Ferramental para Orçamento
--Data             : 06.12.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_pesquisa_ferramenta_estampo
@nm_estampo              varchar(40)= '',
@qt_diametro_interno_min float     = 0,
@qt_diametro_interno_max float     = 0,
@qt_diametro_externo_min float     = 0,
@qt_diametro_externo_max float     = 0,
@qt_espessura_min        float     = 0,
@qt_espessura_max        float     = 0,
@qt_altura_min           float     = 0,
@qt_altura_max           float     = 0


as


declare @sql       varchar(8000)
declare @nm_filtro varchar(4000)

set @nm_filtro = ''

if @nm_estampo <> '' 
   set @nm_filtro = 'nm_estampo like '+''''+'%'+@nm_estampo+'%'+''''

if @qt_diametro_interno_min <> 0 and @qt_diametro_interno_max <> 0 
begin

   if @nm_filtro <> ''
      set @nm_filtro = @nm_filtro + ' and '

   set @nm_filtro = @nm_filtro + 
                    'qt_diametro_interno >= '+cast(@qt_diametro_interno_min as varchar) + ' and qt_diametro_interno<= '+cast(@qt_diametro_interno_max as varchar )
end


set @sql = 'select * from estampo '

if @nm_filtro <> ''
   set @sql= @sql + ' where '+@nm_filtro

--select @nm_filtro
--select @sql

--Executa
exec (@sql)

--select * from estampo


