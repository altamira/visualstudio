
CREATE PROCEDURE pr_consulta_composicao_markup
-------------------------------------------------------------------
--pr_consulta_composicao_markup
-------------------------------------------------------------------
--GBS - Global Business Sollution Ltda                         2004
-------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Lucio Saraiva
--Banco de Dados         : SAPSQL
--Objetivo               : Listar Composição do markup de acordo com
--                         um tipo de produto (base, placa, etc.)
--Data                   : 11/04/2002
--Atualizado             : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 18.04.2007 - Filtro para Mostrar somente os Markup para Orçamento
--                                      Carlos Fernandes
-----------------------------------------------------------------------------------------------------

@cd_aplicacao_markup int -- Tipo de produto : 3=Molde, 4=Base, 5=Placa

as

   select

      am.nm_aplicacao_markup,
      fm.cd_tipo_markup,
      tm.nm_tipo_markup,
      isnull(fm.pc_formacao_markup,tm.pc_tipo_markup) as 'pc_formacao_markup',
      fm.nm_obs_formacao_markup,
      aplicacao =
      case when fm.ic_tipo_formacao_markup = 'A' then 'M.P. / M.O.  '
           when fm.ic_tipo_formacao_markup = 'P' then 'Matéria-Prima'
           when fm.ic_tipo_formacao_markup = 'M' then 'Mão de Obra  '
      else 'M.P. / M.O.  ' end
      
   from 
      Formacao_Markup fm

      Left Outer Join Tipo_Markup tm      on fm.cd_tipo_markup = tm.cd_tipo_markup
      Left Outer Join Aplicacao_Markup am on fm.cd_aplicacao_markup = am.cd_aplicacao_markup

   where
     (@cd_aplicacao_markup = 0 or
      fm.cd_aplicacao_markup = @cd_aplicacao_markup) and
      isnull(am.ic_orcamento_aplicacao,'N') = 'S'

   order by
      am.nm_aplicacao_markup,
      fm.cd_tipo_markup

