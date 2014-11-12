
/****** Object:  Stored Procedure dbo.pr_razao_auxiliar_cliente    Script Date: 13/12/2002 15:08:39 ******/

CREATE PROCEDURE pr_consulta_revisao_projeto_engenharia
@cd_projeto int
as

select
  p.cd_interno_projeto        as 'Projeto',
  pr.cd_item_projeto          as 'ItemProjeto',
  pr.cd_projeto_revisao       as 'ItemRevisao',
  pr.dt_projeto_revisao       as 'DataRevisao',
  trp.nm_tipo_revisao_projeto as 'Revisao',
  pr.nm_projeto_revisao       as 'Descricao',
  pr.nm_desenho_revisao       as 'Desenho',
  pr.nm_obs_projeto_revisao   as 'Observacao'
   
 
from
   Projeto p,
   Projeto_Revisao pr,
   Tipo_Revisao_Projeto trp
where
   pr.cd_projeto	      = @cd_projeto           and
   p.cd_projeto               = pr.cd_projeto         and
   pr.cd_tipo_revisao_projeto *= trp.cd_tipo_revisao_projeto
--sp_help projeto
--sp_help projeto_composicao
--sp_help projeto_revisao
--sp_help tipo_projeto
--select * from tipo_revisao_projeto

