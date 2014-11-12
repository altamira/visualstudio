
CREATE PROCEDURE pr_rel_pre_calculo_comp
@p_cd_consulta varchar(10),
@p_cd_item_consulta varchar(10)

AS

   SELECT @p_cd_consulta as cd_consulta,
          @p_cd_item_consulta as cd_item_consulta,
          a.cd_produto,
          a.ic_esp_comp_orcamento,
          a.ic_acessorio_orcamento,
          a.ic_componente_substituto,
          isnull(b.nm_fantasia_produto,a.nm_fantasia_componente) as nm_fantasia_produto,
          a.nm_produto_orcamento,
          a.qt_item_comp_orcamento,
          CAST((a.vl_custo_produto * a.qt_item_comp_orcamento) as numeric(11, 4)) as vl_custo_produto,
          CAST((a.vl_produto * a.qt_item_comp_orcamento) as numeric(11, 4)) as vl_produto,
          ISNULL(a.nm_obs_comp_orcamento, '-') as nm_obs_comp_orcamento

   FROM consulta_item_componente a

   LEFT OUTER JOIN produto b ON
   a.cd_produto = b.cd_produto

   WHERE a.cd_consulta = @p_cd_consulta
         AND a.cd_item_consulta = @p_cd_item_consulta

