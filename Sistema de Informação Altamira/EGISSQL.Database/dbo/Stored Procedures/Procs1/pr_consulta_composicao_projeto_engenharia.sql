
CREATE PROCEDURE pr_consulta_composicao_projeto_engenharia
-----------------------------------------------------------------
--pr_consulta_composicao_projeto_engenharia
-----------------------------------------------------------------
--GBS - Global Business Solution Ltda                        2004
-----------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados        : EgisSQL
--Objetivo              : Consulta da Composição de Projetos 
--Data                  : 25/1/2003
--Atualizado            : 31.01.2003 - RAFAEL M. SANTIAGO
--                                     Inclusão do Filtro pelo parametro
--                      : 04/01/2005 - Sérgio Cardoso
--                      : 14.05.2005 - Modificação do Item do Projeto - Carlos Fernandes
----------------------------------------------------------------------------------------
@cd_projeto int

as

	select
	  p.cd_interno_projeto         as 'Projeto',
	  pc.cd_item_projeto           as 'ItemInterno',
          pc.cd_ref_item_projeto       as 'Item',
	  pc.qt_item_projeto           as 'Qtd',
	  tp.nm_tipo_projeto           as 'TipoProjeto',    
	  pc.nm_projeto_composicao     as 'Descricao',
	  pc.nm_item_desenho_projeto   as 'Desenho',
	  sp.nm_status_projeto         as 'Status',
	  pr.nm_projetista             as 'Projetista',
	  pc.dt_conf_projeto           as 'Conferencia',
	  pc.dt_aprov_projeto          as 'Aprovacao',
	  pc.dt_liberacao_item_projeto as 'Liberacao',
    prlb.nm_fantasia_projetista  as 'ProjetistaLib'
  from
    Projeto p
      inner join
    Projeto_Composicao pc
      on p.cd_projeto = pc.cd_projeto
      left outer join
    Tipo_Projeto tp
      on pc.cd_tipo_projeto = tp.cd_tipo_projeto
      left outer join
    Status_Projeto sp
      on p.cd_status_projeto = sp.cd_status_projeto
      left outer join
    Projetista pr
      on pc.cd_projetista = pr.cd_projetista
      left outer join
    Projetista prlb
      on pc.cd_projetista_liberacao = prlb.cd_projetista
  where
    pc.cd_projeto = @cd_projeto

