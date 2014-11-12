
create procedure pr_calculo_orcamento

@cd_consulta               int,
@cd_item_consulta          int,
@cd_item_orcamento         int,
@cd_categoria_orcamento    int,
@cd_grupo_produto          int  -- Grupo porque no SVD a consulta não foi gravada ainda ...
                                -- ou pode ser MOI e o grupo usado para cálculo é outro ...

as

  declare @cd_empresa           int
  declare @qt_tempo             float
  declare @vl_custo             float
  declare @vl_mao_obra          float
  declare @cd_formula_orcamento int
  declare @sql                  varchar(8000)
  declare @sql_aux              varchar(3000)

  set @cd_empresa = 1

  -- Mão-de-Obra (Antes buscava através do Grupo_Orcamento.cd_mao_obra)
  -- Alterado para pegar do Categoria_Orcamento

  select
    @vl_mao_obra = mo.vl_mao_obra
  from
    Categoria_Orcamento co,
    Mao_Obra            mo
  where
    co.cd_categoria_orcamento = @cd_categoria_orcamento and
    co.cd_mao_obra            = mo.cd_mao_obra

  --Fórmula que será utilizada para Cálculo conforme a Categoria do Orçamento

  select 
    @cd_formula_orcamento = co.cd_formula_orcamento
  from
    Categoria_Orcamento co
  where
    co.cd_categoria_orcamento = @cd_categoria_orcamento

  --Fórmula

  select
    @sql     = substring(ds_formula_orcamento,1,8000),
    @sql_aux = substring(ds_formula_orcamento,8001,3000)
  from
    Formula_Orcamento
  where
    @cd_formula_orcamento = cd_formula_orcamento
/*
set @sql = '
declare @cd_consulta int
declare @cd_item_consulta int
declare @qt_largura     float
declare @qt_comprimento float
declare @qt_area_base   float
declare @sg_manifold    char(10)
declare @qt_preparacao  int 
declare @qt_var1        float
declare @qt_var2        float
declare @qt_tempo       float
set @qt_tempo         = 0
set @cd_consulta      = (select cd_consulta from #dados_item_orcamento)
set @cd_item_consulta = (select cd_item_consulta from #dados_item_orcamento)
(select @sg_manifold  = rtrim(isnull(b.sg_tipo_manifold,''FMI''))
 from consulta_caract_tecnica_cq a,
      tipo_manifold b
 where a.cd_consulta      = @cd_consulta and 
       a.cd_item_consulta = @cd_item_consulta and
       a.cd_tipo_manifold *= b.cd_tipo_manifold)
if substring(@sg_manifold,3,1) = ''I'' -- Não cobra preparação
begin
   select @qt_tempo
   return
end
set @qt_largura     = (select qt_largac_item_orcamento from #dados_item_orcamento)
set @qt_comprimento = (select qt_compac_item_orcamento from #dados_item_orcamento)
set @qt_area_base   = (dbo.fn_extracao_parametro_orcamento(''#ABASEPP-155''))
set @qt_var1        = (dbo.fn_extracao_parametro_orcamento(''#TEMPPP1-155''))
set @qt_var2        = (dbo.fn_extracao_parametro_orcamento(''#TEMPPP2-155''))
set @qt_tempo       = 
   case when substring(@sg_manifold,3,3) = ''E32'' then 1 else
     (case when (@qt_largura*@qt_comprimento) < @qt_area_base then @qt_var1 else @qt_var2 end)
   end
set @qt_preparacao  = 
   case when substring(@sg_manifold,3,3) in (''E12'',''E16'',''E24'',''E32'') then 2 else 1 end
set @qt_tempo = @qt_tempo * @qt_preparacao
select isnull(@qt_tempo,0)
'
*/
  --Grava a Tabela Temporária para Extração da Area da Placa
  select dbo.fn_area_placa(@cd_consulta,@cd_item_consulta,@cd_item_orcamento) as area 
  into #Area_Placa

  -- Tempos das furações de fixação : Tabela Consulta_Item_Orcamento_Furo

  select cd_consulta,
         cd_item_consulta,
         cd_item_orcamento,
         sum(qt_tempo_item_orcamento) as tempo_furos
  -------
  into #Consulta_Item_Orcamento_Furo
  -------
  from consulta_item_orcamento_furo
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
  group by cd_consulta,
           cd_item_consulta,
           cd_item_orcamento

  -- Tempos das furações adicionais : Tabela Consulta_Item_Orcamento_Furo_Adicional

  select cd_consulta,
         cd_item_consulta,
         cd_item_orcamento,
         sum(qt_tempo_adic_item_orcam) as tempo_furos_adicionais
  -------
  into #Consulta_Item_Orcamento_Furo_Adicional
  -------
  from consulta_item_orcamento_furo_adicional
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
  group by cd_consulta,
           cd_item_consulta,
           cd_item_orcamento

  -- Componentes do orçamento + MAIOR DIÂMETRO : Tabela Consulta_Item_Componente 

  select a.cd_consulta,
         a.cd_item_consulta,
         max(po.qt_diametro_produto_orcam) as qt_maior_diametro,
         count(*) as qt_componente
  -------
  into #Consulta_Item_Componente
  -------
  from consulta_item_componente a

  left outer join Produto_Orcamento po on
  a.cd_produto = po.cd_produto

  inner join Produto p on
  a.cd_produto = p.cd_produto
  
  where a.cd_consulta       = @cd_consulta and
        a.cd_item_consulta  = @cd_item_consulta and
        isnumeric( substring(p.nm_fantasia_produto,2,2) ) = 1 -- Pegar somente pinos

  group by a.cd_consulta,
           a.cd_item_consulta

  -- RESULTADO FINAL dos dados de orçamento e consulta

  select a.cd_consulta,
         a.cd_item_consulta,
         a.cd_item_orcamento,
         a.qt_item_orcamento, -- qtde. placas
         a.qt_furfix_item_orcamento,
         a.qt_bc_item_orcamento,
         a.qt_bcags_item_orcamento,
         a.qt_diambc_item_orcamento,
         a.qt_dbcags_item_orcamento,
         a.qt_espac_item_orcamento,
         a.qt_espbru_item_orcamento,
         a.qt_tpdabc_item_orcamento,
         a.ic_refrig_item_orcamento,
         a.cd_materia_prima,
         @cd_categoria_orcamento as cd_categoria_orcamento,
         isnull(a.qt_velpac_item_orcamento,mp.qt_velocidade_preacab) as qt_velpac_item_orcamento,
         isnull(a.qt_velac_item_orcamento,mp.qt_velocidade_acab)     as qt_velac_item_orcamento,
         a.qt_largbru_item_orcamento,
         a.qt_compbru_item_orcamento,
        (a.qt_largac_item_orcamento * 
            a.qt_compac_item_orcamento) as qt_area,
         a.qt_largac_item_orcamento,
         a.qt_compac_item_orcamento,
         a.qt_pesliq_item_orcamento,
         a.qt_pesbru_item_orcamento,
         a.cd_tipo_placa,
         a.cd_grupo_esquadro,
         isnull(a.ic_aloj_item_orcamento,'N') as ic_aloj_item_orcamento, 
         a.ic_gancho_item_orcamento,
         a.qt_comprg_item_orcamento,
         a.cd_placa,
         -- (%) de redução dependendo da fase (categoria de orçamento) e da série + Compra 
         pc_reducao_calc_orcamento =
        (select pc_reducao_calc_orcamento
         from categoria_orcamento_serie
         where cd_categoria_orcamento = @cd_categoria_orcamento and
               cd_serie_produto = i.cd_serie_produto_padrao and
               a.ic_compra_item_orcamento = 'N'),
         isnull(i.cd_montagem,a.cd_montagem) as cd_montagem,
         g.cd_grupo_produto,
         sg_tipo_produto_espessura =
         case when upper(sg_tipo_produto_espessura) = 'MANIFOLD' then 'PLACA' 
         else t.sg_tipo_produto_espessura end,
         qt_sobremetal = a.qt_largbru_item_orcamento - a.qt_largac_item_orcamento,
         qt_sobremetal_espessura = a.qt_espbru_item_orcamento - a.qt_espac_item_orcamento,      
        (a.qt_item_orcamento * b.tempo_furos) as tempo_furos,
         c.tempo_furos_adicionais,
         co.qt_maior_diametro,
         co.qt_componente,
         a.qt_vias_hot_half

  -------
  into #Dados_Item_Orcamento
  -------

  from Consulta_Item_Orcamento a

  left outer join #Consulta_Item_Orcamento_Furo b on
  a.cd_consulta       = b.cd_consulta and
  a.cd_item_consulta  = b.cd_item_consulta and
  a.cd_item_orcamento = b.cd_item_orcamento

  left outer join #Consulta_Item_Orcamento_Furo_Adicional c on
  a.cd_consulta       = c.cd_consulta and
  a.cd_item_consulta  = c.cd_item_consulta and
  a.cd_item_orcamento = c.cd_item_orcamento

  left outer join Consulta_Itens i on
  a.cd_consulta      = i.cd_consulta and
  a.cd_item_consulta = i.cd_item_consulta  

  left outer join #Consulta_Item_Componente co on
  a.cd_consulta       = co.cd_consulta and
  a.cd_item_consulta  = co.cd_item_consulta

  -- Dá preferência do que vêm do parâmetro,
  -- pois pode ser MOI então o grupo usado é outro ...
  left outer join Grupo_Produto g on  
  isnull(@cd_grupo_produto,i.cd_grupo_produto) = g.cd_grupo_produto 

  left outer join Tipo_Produto_Espessura t on
  g.cd_tipo_produto_espessura = t.cd_tipo_produto_espessura

  left outer join Materia_Prima mp on
  a.cd_materia_prima = mp.cd_mat_prima 
  
  where a.cd_consulta       = @cd_consulta and
        a.cd_item_consulta  = @cd_item_consulta and
        a.cd_item_orcamento = @cd_item_orcamento

  --Criar Tabela Temporaria para gravação do tempo final de toda a fórmula

  create table #ComandoSQL
    ( qt_tempo float )

  --Executa a Fórmula e Retorna o Tempo para Cálculo do Custo

print len(@sql)
print len(@sql_aux)

  insert into #ComandoSQL exec(@sql+@sql_aux)

  --Cálculo do Custo

  select qt_tempo                as 'Hora',
         qt_tempo * @vl_mao_obra as 'CustoTotal', 
         @vl_mao_obra            as 'CustoMaoObra'
  from #ComandoSQL
 
