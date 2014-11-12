
-------------------------------------------------------------------------------
--pr_geracao_agenda_visita_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Geração da Agenda de Visita do Vendedor
--Data             : 15/01/2005
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_geracao_agenda_visita_vendedor
@cd_vendedor int,       --Vendedor
@dt_inicial  datetime,  --Data Inicial
@dt_final    datetime   --Data Final

as




--Visita Diária do Cadastro de Vendedor

declare @qt_visita_diaria int

set @qt_visita_diaria = 0

select @qt_visita_diaria = isnull(qt_visita_diaria_vendedor,0)
from
  Vendedor
where
  cd_vendedor = @cd_vendedor


--Verifica se a Visita Diária é Zero e Busca da Tabela de Parâmetro CRM

if @qt_visita_diaria = 0 
begin
  --select * from parametro_crm
  select @qt_visita_diaria = isnull(qt_visita_vendedor,0)
  from
     Parametro_CRM
  where
     cd_empresa = dbo.fn_empresa()
end


--select @qt_visita_diaria

--Gravação da Visita do Vendedor

declare @cd_visita int




-- cd_visita	int
-- dt_visita	datetime
-- cd_tipo_visita	int
-- cd_vendedor	int
-- cd_cliente	int
-- cd_contato	int
-- ic_retorno_visita	char
-- dt_retorno_visita	datetime
-- ds_visita	text
-- cd_usuario	int
-- dt_usuario	datetime
-- nm_assunto_visita	varchar
-- ds_visita_retorno	text
-- dt_agenda_visita	datetime
-- cd_operador_telemarketing	int
-- cd_cliente_prospeccao	int
-- nm_obs_visita	varchar
-- cd_motivo_visita	int
-- qt_dia_lembrete_visita	int
-- ic_lembrete_visita	char
-- ic_particular_visita	char
-- hr_fim_visita	varchar
-- hr_inicio_visita	varchar
-- cd_prospeccao_contato	int







--sp_help visita

--select * from vendedor
--select * from visita
--select * from cliente_contato
--select * from cliente_prospeccao_contato
--select * from cliente_prospeccao


