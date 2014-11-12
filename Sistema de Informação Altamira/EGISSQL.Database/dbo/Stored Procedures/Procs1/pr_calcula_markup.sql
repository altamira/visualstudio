
create procedure pr_calcula_markup

@cd_aplicacao_markup     int,
@ic_tipo_formacao_markup char(1),
@ic_parametro            int,
@cd_consulta             int,
@cd_item_consulta        int,
@cd_grupo_produto_markup int = null,
@cd_produto_padrao       int = null

as

declare @cd_status int
declare @ic_tipo_orcamento char(1)

-- Tipo = (R)edutor, (M)arkup, (A)mbos
set @ic_tipo_orcamento = (select ic_tipo_calculo_markup 
                          from parametro_calculo_orcamento
                          where cd_empresa = 1) -- Parametrizar

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Com markup's de lucro
-------------------------------------------------------------------------------------------
begin
   declare @pc_lucro float
   
   set @pc_lucro  = 0
   set @cd_status = 0 -- Sucesso
   
   declare @cd_grupo_produto int   
   select Top 1
          @cd_grupo_produto =  ci.cd_grupo_produto
   from Consulta_Itens ci
   where ci.cd_consulta       = @cd_consulta and 
         ci.cd_item_consulta  = @cd_item_consulta
   
   if (@ic_tipo_orcamento in ('A','M')) and
      -- Se o percentual de lucro for Zero, procura em outras tabelas ...
      (select count(*) 
       from formacao_markup a,
            tipo_markup b
       where a.cd_aplicacao_markup     = @cd_aplicacao_markup and
            (a.ic_tipo_formacao_markup = 'A' or -- Ambos 
             a.ic_tipo_formacao_markup = @ic_tipo_formacao_markup) and
             a.cd_tipo_markup          = b.cd_tipo_markup and
             b.ic_tipo_markup_lucro    = 'S' and
             a.pc_formacao_markup = 0) > 0
   begin
      declare @qt_area_referencia      float
      declare @cd_materia_prima_ref    int    
      declare @cd_materia_prima        int
      declare @cd_serie_produto        int
      declare @cd_produto_padrao_orcam int
      declare @cd_area                 int 
      declare @cd_tipo_lucro           int
      declare @nm_fantasia_produto     varchar(20)
      
      select Top 1
             @qt_area_referencia      = (cio.qt_compac_item_orcamento * 
                                         cio.qt_largac_item_orcamento),
             @cd_materia_prima        =  cio.cd_materia_prima,
             @cd_serie_produto        =  ci.cd_serie_produto_padrao,
             @cd_produto_padrao_orcam =  ci.cd_produto_padrao_orcam
      
      from Consulta_Item_Orcamento cio,
           Consulta_Itens ci,
           Placa p
      
      where cio.cd_consulta       = @cd_consulta and 
            cio.cd_item_consulta  = @cd_item_consulta and
            cio.cd_consulta      *= ci.cd_consulta and
            cio.cd_item_consulta *= ci.cd_item_consulta and
            cio.cd_placa          = p.cd_placa 
      
      order by isnull(p.cd_ordem_area_referencia,99) -- (Pegar P1,P2 depois PS e por último PB)
                 
      if isnull(@cd_produto_padrao_orcam,0) = 0 -- Campo do item da consulta
         set @cd_produto_padrao_orcam = @cd_produto_padrao -- Campo parametrizado
                
      if isnull(@cd_produto_padrao_orcam,0) > 0
      begin
         select @nm_fantasia_produto = nm_fantasia_produto
         from produto
         where cd_produto = @cd_produto_padrao_orcam
         
         set @cd_materia_prima = cast(substring(@nm_fantasia_produto,7,1) as int)
         -- Incluído em 05/04/2005
         set @cd_serie_produto = (select cd_serie_produto from serie_produto
                                  where sg_serie_produto = substring(@nm_fantasia_produto,1,4))
      end
      
      -- A consulta pode não estar gravada ainda ... 
      
      -- Se veio o @cd_grupo_produto_markup é porque é diferente do Grupo da Consulta
      -- Exemplo : Grupo 23 MOI mas ... o markup é em cima de Molde - Grupo 20
      if (isnull(@cd_grupo_produto,0) = 0) or (@cd_grupo_produto_markup > 0)
         set @cd_grupo_produto = @cd_grupo_produto_markup
      
      if @cd_grupo_produto in (20,34) -- MPE e HOTHALF de MPE
      begin
         set @cd_tipo_lucro = isnull((select cd_tipo_lucro from Materia_Prima_Serie_Lucro
                                      where cd_serie_produto = @cd_serie_produto and
                                            cd_mat_prima     = @cd_materia_prima),0)
         
         if @cd_tipo_lucro = 0 
            set @cd_tipo_lucro = isnull((select top 1 cd_tipo_lucro 
                                         from Materia_Prima_Serie_Lucro
                                         where cd_serie_produto = @cd_serie_produto and
                                               cd_mat_prima     < @cd_materia_prima
                                         order by cd_mat_prima desc),0)
      end
      else
      if @cd_grupo_produto in (36,37,52,53) -- SCQ / MANIFOLD
      begin
         declare @sg_tipo_manifold varchar(10)
         select @sg_tipo_manifold = substring(b.sg_tipo_manifold,1,3)
         from consulta_caract_tecnica_cq a, tipo_manifold b
         where a.cd_consulta = @cd_consulta and
               a.cd_item_consulta = @cd_item_consulta and
               a.cd_tipo_manifold = b.cd_tipo_manifold 
         
         set @cd_serie_produto = (select cd_serie_produto from serie_produto                                   where sg_serie_produto = @sg_tipo_manifold)
      end 
      else
      begin
         set @cd_area = (select cd_area_placa from Area_Placa
                         where @qt_area_referencia between qt_inicial_area_placa and qt_final_area_placa)
            
         set @cd_tipo_lucro = isnull((select cd_tipo_lucro from Materia_Prima_Area
                                      where cd_area_placa = @cd_area and
                                            cd_mat_prima  = @cd_materia_prima),0)
            
         if @cd_tipo_lucro = 0
         begin
            set @cd_status = 1 -- Código de Lucro não cadastrado
            -- Tenta pegar "da área"
            set @cd_tipo_lucro = isnull((select cd_tipo_lucro from Area_Placa
                                         where cd_area_placa = @cd_area),0)
         end
      end
      
      if isnull(@cd_tipo_lucro,0) = 0
      begin
         -- Tenta pegar "da série"
         set @cd_tipo_lucro = isnull((select cd_tipo_lucro from Serie_Produto_Especificacao
                                      where cd_serie_produto = @cd_serie_produto),0)
         if isnull(@cd_tipo_lucro,0) = 0
            set @cd_status = 1 -- Código de Lucro não cadastrado
      end
      
      if @pc_lucro = 0 
         set @pc_lucro = isnull((select pc_tipo_lucro from Tipo_Lucro
                                 where cd_tipo_lucro = @cd_tipo_lucro),0)
      
      if @pc_lucro = 0
         set @cd_status = 2 -- Percentual de Lucro = Zero
      
   end
      
   declare @Exportacao char(1)
   declare @Moeda int
   select top 1 
          @Exportacao = isnull(tm.ic_exportacao_tipo_mercado,'N'),
          @Moeda = cl.cd_moeda
   from Consulta c,
        Cliente cl,
        Tipo_Mercado tm
   where c.cd_consulta = @cd_consulta and 
         c.cd_cliente  = cl.cd_cliente and
         cl.cd_tipo_mercado = tm.cd_tipo_mercado
      
   -- Analiza se tem um markup diferenciado. Por exemplo : Exportação
   declare @cd_aplicacao_markup_especifico int
      
   select @cd_aplicacao_markup_especifico = cd_aplicacao_markup
   from grupo_produto_markup
   where cd_grupo_produto = @cd_grupo_produto and
         cd_moeda = @moeda
   
   if isnull(@cd_aplicacao_markup_especifico,0) > 0
   set @cd_aplicacao_markup = @cd_aplicacao_markup_especifico
   
   select
      pc_markup = 
      case when pc_formacao_markup = 0 then @pc_lucro
      else pc_formacao_markup end
   into #TmpFormacao
   from formacao_markup
   where 
      cd_aplicacao_markup     = @cd_aplicacao_markup and
     (ic_tipo_formacao_markup = 'A' or -- Ambos 
      ic_tipo_formacao_markup = @ic_tipo_formacao_markup)
   
   -- Resultado final com a soma dos percentuais
   select pc_markup = (100-sum(pc_markup)) / 100,
          @cd_status as cd_status
   from #TmpFormacao
      
end

else

-------------------------------------------------------------------------------------------
if @ic_parametro = 2 -- Sem lucro
-------------------------------------------------------------------------------------------
begin
   set @cd_status = 0
      
   select pc_markup = (100-sum(a.pc_formacao_markup)) / 100,
          @cd_status as cd_status
      
   from formacao_markup a,
        tipo_markup b           
      
   where 
      a.cd_aplicacao_markup     = @cd_aplicacao_markup and
     (a.ic_tipo_formacao_markup = 'A' or -- Ambos 
      a.ic_tipo_formacao_markup = @ic_tipo_formacao_markup) and
      a.cd_tipo_markup = b.cd_tipo_markup and
      b.ic_tipo_markup_lucro <> 'S'
         
end

-- GO
-- 
-- exec pr_calcula_markup 18, 'P', 1, 400198, 6, null, null

-- 1o. Parâmetro = cd_aplicacao_markup (3=Molde, 4=Base, 5=Placa)
-- 2o. Parâmetro = ic_tipo_formacao (A=Ambos, P=Matéria-Prima, M=Mão de Obra)
-- 3o. Parâmetro = cd_parametro (1=Com lucro, 2=Sem lucro)
-- 4o. Parâmetro = cd_consulta
-- 5o. Parâmetro = cd_item_consulta
-- 6o. Parâmetro = cd_grupo_produto_markup (O grupo Escolhido pode ser diferente da Consulta)
-- 7o. Parâmetro = cd_produto_padrao



