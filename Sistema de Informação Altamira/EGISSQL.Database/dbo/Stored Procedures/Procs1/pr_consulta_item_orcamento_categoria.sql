
CREATE PROCEDURE pr_consulta_item_orcamento_categoria

@cd_consulta       int,
@cd_item_consulta  int,
@cd_item_orcamento int

as

declare @qt_tempo float
declare @vl_custo float

set @qt_tempo = null
set @vl_custo = null 

   --
   -- Seleciona todas os grupos de categoria 
   --
   select
      go.cd_grupo_orcamento,
      'S'                             as 'ic_grupo_orcamento',
      max(go.cd_ordem_grupo_orcamento)as 'cd_ordem_grupo_orcamento',
      min(co.cd_categoria_orcamento)  as 'cd_categoria_orcamento',
      max(go.nm_grupo_orcamento)      as 'nm_categoria_orcamento', 
      sum(oc.qt_hora_item_orcamento)  as 'qt_hora_item_orcamento_total',
      sum(oc.vl_custo_item_orcamento) as 'vl_custo_item_orcamento_total',
      @qt_tempo                       as 'qt_hora_item_orcamento',
      @vl_custo                       as 'vl_custo_item_orcamento'

   into #TmpOrcamentoGrupoCat

   from 
      Consulta_Item_Orcamento_Cat oc

   Left Outer Join Categoria_Orcamento co on
   oc.cd_categoria_orcamento = co.cd_categoria_orcamento

   Left Outer Join Grupo_Orcamento go on
   co.cd_grupo_orcamento = go.cd_grupo_orcamento
      
   where
      oc.cd_consulta       = @cd_consulta and
      oc.cd_item_consulta  = @cd_item_consulta and
      oc.cd_item_orcamento = @cd_item_orcamento

   group by go.cd_grupo_orcamento

   --
   -- Seleciona todas as categorias
   --
   select
      go.cd_grupo_orcamento,
      'N'                         as 'ic_grupo_orcamento',
      go.cd_ordem_grupo_orcamento as 'cd_ordem_grupo_orcamento',
      co.cd_categoria_orcamento,
      co.nm_categoria_orcamento,
      @qt_tempo                  as 'qt_hora_item_orcamento_total',
      @vl_custo                  as 'vl_custo_item_orcamento_total',
      oc.qt_hora_item_orcamento  as 'qt_hora_item_orcamento',
      oc.vl_custo_item_orcamento as 'vl_custo_item_orcamento'

   into #TmpOrcamentoCat

   from 
      Consulta_Item_Orcamento_Cat oc

   Left Outer Join Categoria_Orcamento co on
   oc.cd_categoria_orcamento = co.cd_categoria_orcamento

   Left Outer Join Grupo_Orcamento go on
   co.cd_grupo_orcamento = go.cd_grupo_orcamento
      
   where
      oc.cd_consulta       = @cd_consulta and
      oc.cd_item_consulta  = @cd_item_consulta and
      oc.cd_item_orcamento = @cd_item_orcamento

   --
   -- Une as duas tabelas
   --
   insert into #TmpOrcamentoGrupoCat
   select * from #TmpOrcamentoCat
   
   -- Calcula o total para conseguir o percentual abaixo

   declare @vl_total float
   set @vl_total = 0

   select @vl_total = @vl_total + isnull(vl_custo_item_orcamento_total,0)
   from #TmpOrcamentoGrupoCat

   -- Resultado final

   select
      cd_grupo_orcamento, 
      ic_grupo_orcamento,
      cd_categoria_orcamento,
      nm_categoria_orcamento,
      qt_hora_item_orcamento,
      qt_hora_item_orcamento_total,
      vl_custo_item_orcamento,
      vl_custo_item_orcamento_total,
     (vl_custo_item_orcamento_total / @vl_total * 100) as 'pc_total'

   from #TmpOrcamentoGrupoCat

   order by cd_ordem_grupo_orcamento, 
            cd_grupo_orcamento,
            cd_categoria_orcamento,
            qt_hora_item_orcamento_total desc

