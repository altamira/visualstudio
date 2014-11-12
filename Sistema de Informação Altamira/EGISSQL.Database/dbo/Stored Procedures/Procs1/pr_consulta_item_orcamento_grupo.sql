
CREATE PROCEDURE pr_consulta_item_orcamento_grupo

@cd_consulta      int,
@cd_item_consulta int

as

   select
      go.cd_grupo_orcamento,
      max(go.cd_ordem_grupo_orcamento) as 'cd_ordem_grupo_orcamento',
      sum(oc.qt_hora_item_orcamento)  as 'qt_hora_item_orcamento',
      sum(oc.vl_custo_item_orcamento) as 'vl_custo_item_orcamento',
      max(go.nm_grupo_orcamento)      as 'nm_grupo_orcamento',
      max(tmo.nm_tipo_mao_obra)       as 'nm_tipo_mao_obra'

   into #TmpOrcamentoCat

   from 
      Consulta_Item_Orcamento_Cat oc

      Left Outer Join Categoria_Orcamento c on
      oc.cd_categoria_orcamento = c.cd_categoria_orcamento

      Left Outer Join Grupo_Orcamento go on
      c.cd_grupo_orcamento = go.cd_grupo_orcamento
      
      Left Outer Join Mao_Obra mo on
      go.cd_mao_obra = mo.cd_mao_obra

      Left Outer Join Tipo_Mao_Obra tmo on
      mo.cd_tipo_mao_obra = tmo.cd_tipo_mao_obra
      
   where
      oc.cd_consulta      = @cd_consulta and
      oc.cd_item_consulta = @cd_item_consulta

   group by
      go.cd_grupo_orcamento
   order by
      go.cd_grupo_orcamento

   -- Calcula o total para conseguir o percentual abaixo

   declare @vl_total float
   set @vl_total = 0

   select @vl_total = @vl_total + vl_custo_item_orcamento
   from #TmpOrcamentoCat

   -- Resultado final

   select
      cd_grupo_orcamento,
      nm_grupo_orcamento,
      qt_hora_item_orcamento,
      vl_custo_item_orcamento,
     (vl_custo_item_orcamento / @vl_total * 100) as 'pc_total',
      nm_tipo_mao_obra

   from #TmpOrcamentoCat

   order by cd_ordem_grupo_orcamento 

