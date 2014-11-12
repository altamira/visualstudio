
CREATE PROCEDURE pr_insere_servicos_agregados

@cd_consulta             int,
@cd_item_consulta        int,
@cd_item_orcamento       int,
@cd_serie_produto        int,
@qt_vias                 int,
@cd_usuario              int,
@ic_hothalf              char(1),
@sg_serie_produto_padrao char(4) = null

as

declare @cd_placa          int
declare @sg_placa          varchar(10) 
declare @cd_materia_prima  int
declare @cd_produto_padrao int

select @cd_placa         = a.cd_placa,
       @cd_materia_prima = a.cd_materia_prima,
       @sg_placa         = b.sg_placa
from consulta_item_orcamento a,
     placa b
where a.cd_consulta       = @cd_consulta and
      a.cd_item_consulta  = @cd_item_consulta and
      a.cd_item_orcamento = @cd_item_orcamento and
      a.cd_placa         *= b.cd_placa

set @cd_produto_padrao =
   isnull((select cd_produto_padrao_orcam
           from consulta_caract_tecnica_cq
           where cd_consulta      = @cd_consulta and
                 cd_item_consulta = @cd_item_consulta),0)

set @cd_produto_padrao =
   isnull((select cd_produto_padrao_orcam
           from consulta_caract_tecnica_cq
           where cd_consulta      = 400198 and
                 cd_item_consulta = 3),0)

delete from consulta_item_orcamento_servico_manual
where cd_consulta       = @cd_consulta and
      cd_item_consulta  = @cd_item_consulta and
      cd_item_orcamento = @cd_item_orcamento

--

select 
  @cd_consulta       as cd_consulta,
  @cd_item_consulta  as cd_item_consulta,
  @cd_item_orcamento as cd_item_orcamento,
  a.cd_item_servico_manual,
  a.qt_hora_item_serv_manual,
  isnull(mo.vl_mao_obra,0) as vl_unit_item_serv_manual,
  0 as vl_total_item_serv_manual,
  a.nm_item_servico_manual,
  a.cd_tipo_mao_obra,
  a.ic_tipo_mao_obra,
  a.ic_markup_serv_manual,
  a.cd_categoria_orcamento,
  @cd_usuario as cd_usuario,
  getdate()   as dt_usuario,
  a.cd_mao_obra
--
into #Tmp_serie_produto_servico_manual
--
from serie_produto_servico_manual a

left outer join mao_obra mo on
a.cd_mao_obra = mo.cd_mao_obra

where a.cd_serie_produto = @cd_serie_produto and
      a.cd_placa         = @cd_placa 

order by a.cd_item_servico_manual

--
-- Inclusão de serviços manuais pré-cadastrados na tabela Serie_Produto_Servico_Manual
--
declare @cd_item int
declare @qt_hora float
declare @cd_categoria_orcamento  int
declare @cd_serie_produto_padrao int

set @cd_serie_produto_padrao = (select top 1 cd_serie_produto from serie_produto 
                                where sg_serie_produto = @sg_serie_produto_padrao)

while exists (select 'x' from #Tmp_serie_produto_servico_manual)
begin
  select top 1 
         @cd_item                = cd_item_servico_manual,
         @cd_categoria_orcamento = isnull(cd_categoria_orcamento,0),
         @qt_hora                = qt_hora_item_serv_manual
  from #Tmp_serie_produto_servico_manual
  
  if @cd_categoria_orcamento > 0 -- Têm uma categoria preenchida, verifica se têm fórmula ...
  begin 
     declare @cd_formula_orcamento int
     
     select @cd_formula_orcamento = cd_formula_orcamento
     from categoria_orcamento
     where cd_categoria_orcamento = @cd_categoria_orcamento
     
     if @cd_formula_orcamento > 0 
     begin
        declare @ds_formula varchar(8000)
        set @ds_formula = (select substring(ds_formula_orcamento,1,8000) as ds_formula
                           from formula_orcamento
                           where cd_formula_orcamento = @cd_formula_orcamento)
        
        select @cd_serie_produto_padrao as cd_serie_produto_padrao, 
               @qt_vias as qt_vias
        --
        into #serie_item
        --
        from consulta_itens
        where cd_consulta      = @cd_consulta and
              cd_item_consulta = @cd_item_consulta 
        
        -- Criar Tabela Temporaria para gravação do tempo final da fórmula
        create table #ComandoSQL (qt_tempo float)
        
        --Executa a Fórmula onde retorna o Tempo
        insert into #ComandoSQL exec(@ds_formula)
        
        set @qt_hora = isnull( (select qt_tempo from #ComandoSQL),0 )
        
        drop table #ComandoSql
        drop table #serie_item
     end
  end
  
  insert into consulta_item_orcamento_servico_manual
   (cd_consulta,
    cd_item_consulta,
    cd_item_orcamento,
    cd_item_serv_manual,
    qt_hora_item_serv_manual,
    vl_unit_item_serv_manual,
    vl_total_item_serv_manual,
    nm_item_servico_manual,
    cd_tipo_mao_obra,
    ic_tipo_mao_obra,
    ic_markup_serv_manual,
    cd_usuario,
    dt_usuario,
    cd_mao_obra)
  select 
    cd_consulta,
    cd_item_consulta,
    cd_item_orcamento,
    cd_item_servico_manual,
    @qt_hora,
    vl_unit_item_serv_manual,
   (@qt_hora * vl_unit_item_serv_manual) as vl_total_item_serv_manual,
    nm_item_servico_manual,
    cd_tipo_mao_obra,
    ic_tipo_mao_obra,
    ic_markup_serv_manual,
    cd_usuario,
    dt_usuario,
    cd_mao_obra
  from #Tmp_serie_produto_servico_manual
  where cd_item_servico_manual = @cd_item
  
  delete from #Tmp_serie_produto_servico_manual
  where cd_item_servico_manual = @cd_item

  update consulta_item_orcamento
  set ic_agserv_item_orcamento = 'S',
      -- Tipo de Ajuste de BC
      qt_tpdabc_item_orcamento = 
      case when @sg_serie_produto_padrao < '3035' then 0
           when @sg_serie_produto_padrao > '4045' then 2
      else 1 end -- Entre 3035 e 4045     
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
end

--
-- Inclusão de Refrigeração 
--

-- Somente se for PBS ou PPB ...
if (@ic_hothalf = 'S') and (@sg_placa = 'PBS') or (@sg_placa = 'PPB')
begin
  delete from consulta_item_orcamento_refrigeracao
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento

  declare @qt_comprimento float
  declare @qt_largura     float
  declare @qt_preparacao  float
  declare @qt_perimetro   float
  
  set @qt_preparacao =
      case when @cd_placa = 1 then 2   
           when @qt_vias <= 6 then 2
           when @qt_vias >= 8 then 4
      end
  
  select @qt_largura     = qt_largac_item_orcamento,
         @qt_comprimento = qt_compac_item_orcamento
  from consulta_item_orcamento
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
  
  set @qt_perimetro =
  case when @cd_placa = 1 then ( (2 * (@qt_comprimento*0.75)) + (@qt_largura*0.75) )
       when @qt_vias <= 6 then (2 * @qt_comprimento)
       when @qt_vias >= 8 then ( (4 * (@qt_comprimento*0.80)) + (2 * (@qt_largura*0.80)) )
  end

  insert into consulta_item_orcamento_refrigeracao
  (
  cd_consulta,cd_item_consulta,cd_item_orcamento,cd_item_refrig,qt_preparacao_item_refrig,
  qt_diametro_item_refrig,qt_perimetro_item_refrig,cd_maquina,nm_obs_item_refrig,cd_usuario,
  dt_usuario,qt_hora_mandrilhadora,vl_custo_mandrilhadora
  )
  values
  (
  @cd_consulta,@cd_item_consulta,@cd_item_orcamento,1,@qt_preparacao,10,@qt_perimetro,
  152,null,@cd_usuario,getdate(),null,null
  )
  update consulta_item_orcamento
  set ic_agserv_item_orcamento = 'S',
      ic_refrig_item_orcamento = 'S'
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento

end
else
  -- Somente se for Manifold e NÃO FOR Manifold padrão ...
  if (@sg_placa = 'MANIFOLD') and (@cd_produto_padrao > 0)
  begin
     delete from consulta_item_orcamento_refrigeracao
     where cd_consulta       = @cd_consulta and
           cd_item_consulta  = @cd_item_consulta and
           cd_item_orcamento = @cd_item_orcamento
     
     -- Fórmula de Prep. e Usinagem do "Canal de Alimentação"
     declare @qt_largura_man     float
     declare @qt_comprimento_man float
     declare @qt_medida_E    float
     declare @qt_medida_X    float
     declare @qt_comp_max    float
     declare @qt_area_base   float
     declare @qt_preparacao_canal int
     declare @qt_perimetro_canal  float
     declare @sg_manifold    char(10)
     
     select @qt_largura_man     = qt_largac_item_orcamento,
            @qt_comprimento_man = qt_compac_item_orcamento
     from consulta_item_orcamento
     where cd_consulta       = @cd_consulta and
           cd_item_consulta  = @cd_item_consulta and
           cd_item_orcamento = @cd_item_orcamento
     
    (select @sg_manifold  = rtrim(isnull(b.sg_tipo_manifold,'FMI')) 
     from consulta_caract_tecnica_cq a,
          tipo_manifold b
     where a.cd_consulta      = @cd_consulta and 
           a.cd_item_consulta = @cd_item_consulta and
           a.cd_tipo_manifold *= b.cd_tipo_manifold)
     
     set @qt_perimetro_canal  = @qt_comprimento_man
     set @qt_medida_E         = (dbo.fn_extracao_parametro_orcamento('#MEDIDA_E-151'))
     set @qt_medida_X         = (dbo.fn_extracao_parametro_orcamento('#MEDIDA_X-161'))
     set @qt_comp_max         = (dbo.fn_extracao_parametro_orcamento('#COMPMAX-161'))
     set @qt_preparacao_canal = 
     case when substring(@sg_manifold,3,1) = 'I' then
        case when (@qt_comprimento_man-@qt_medida_E) > @qt_comp_max then 2 else 1 end
          when substring(@sg_manifold,3,1) = 'X' then
        case when (@qt_comprimento_man-@qt_medida_X) > @qt_comp_max then 4 else 2 end
          when substring(@sg_manifold,3,1) = 'H' then
        case when (@qt_comprimento_man-@qt_medida_E) > @qt_comp_max then 3 else 2 end
          when (substring(@sg_manifold,3,2) in ('E6','E8') or -- FME6/8
                substring(@sg_manifold,3,3) = ('E12')) then 
        case when (@qt_comprimento_man > @qt_comp_max) then 6 else 5 end
          when substring(@sg_manifold,3,3) = 'E16' then 
        case when (@qt_comprimento_man-@qt_medida_X) > @qt_comp_max then 6 else 4 end
          when substring(@sg_manifold,3,3) = 'E24' then 
        case when (@qt_comprimento_man-@qt_medida_X) > @qt_comp_max then 7 else 5 end
          when substring(@sg_manifold,3,3) = 'E32' then 10
     end

     set @qt_perimetro_canal = 
     case when substring(@sg_manifold,3,1) = 'I' then
             @qt_comprimento_man * (case when @qt_vias = 4 then 2 else 1 end)
          when substring(@sg_manifold,3,1) = 'X' then
            (@qt_largura_man+@qt_comprimento_man)-(@qt_medida_X*2)
          when substring(@sg_manifold,3,1) = 'H' then
             @qt_largura_man+(@qt_comprimento_man*2)
          when substring(@sg_manifold,3,2) = 'E6' then
             sqrt(power(@qt_largura_man,2)+power(@qt_comprimento_man/2,2))*3+(@qt_comprimento_man/4*3)
          when substring(@sg_manifold,3,2) = 'E8' then
             sqrt(power(@qt_largura_man,2)+power(@qt_comprimento_man/3,2))*4+@qt_comprimento_man
          when substring(@sg_manifold,3,3) = 'E12' then
             sqrt(power(@qt_largura_man,2)+power(@qt_comprimento_man/5,2))*6+@qt_comprimento_man
          when substring(@sg_manifold,3,3) = 'E16' then
             sqrt(power(@qt_largura_man/3,2)+power(@qt_comprimento_man/3,2))*4*2+
             sqrt(power(@qt_largura_man,2)+power(@qt_comprimento_man,2))*2 
          when substring(@sg_manifold,3,3) = 'E24' then
             sqrt(power(@qt_largura_man/3,2)+power(@qt_comprimento_man/5,2))*12+
             sqrt(power(@qt_largura_man/2,2)+power(@qt_comprimento_man/2,2))*4+@qt_comprimento_man
          when substring(@sg_manifold,3,3) = 'E32' then
             sqrt(power(@qt_largura_man/3,2)+power(@qt_comprimento_man/7,2))*8*2+
             sqrt(power(@qt_largura_man,2)+power(@qt_comprimento_man/2,2))*2*2+@qt_comprimento_man
     end
      
     if @qt_preparacao_canal > 0 
     begin 
       insert into consulta_item_orcamento_refrigeracao
       (
       cd_consulta,cd_item_consulta,cd_item_orcamento,cd_item_refrig,qt_preparacao_item_refrig,
       qt_diametro_item_refrig,qt_perimetro_item_refrig,cd_maquina,nm_obs_item_refrig,cd_usuario,
       dt_usuario,qt_hora_mandrilhadora,vl_custo_mandrilhadora
       )
       values
       (
       @cd_consulta,@cd_item_consulta,@cd_item_orcamento,1,@qt_preparacao_canal,10,@qt_perimetro_canal,
       152,null,@cd_usuario,getdate(),null,null
       )
       update consulta_item_orcamento
       set ic_agserv_item_orcamento = 'S',
           ic_refrig_item_orcamento = 'S'
       where cd_consulta       = @cd_consulta and
             cd_item_consulta  = @cd_item_consulta and
             cd_item_orcamento = @cd_item_orcamento
     end  
  end

--
-- Inclusão de Alojamento
--

-- Somente se for PPM e Aço for <> 1 (1045) ...
if (@ic_hothalf = 'S') and (@sg_placa = 'PPM') and (@cd_materia_prima <> 1)
begin
  delete from consulta_item_orcamento_alojamento
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
  
  declare @qt_espessura        float
  declare @qt_largura_aloj     float
  declare @qt_comprimento_aloj float
  declare @nm_medida           varchar(20)
  
  select @qt_espessura        = qt_espac_item_orcamento,
         @qt_largura_aloj     = qt_largac_item_orcamento,
         @qt_comprimento_aloj = qt_compac_item_orcamento
  from consulta_item_orcamento
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
  
  -- Tira 10% da área das medidas acabadas informadas na placa  
  set @qt_largura_aloj     = @qt_largura_aloj - (@qt_largura_aloj * 0.10)
  set @qt_comprimento_aloj = @qt_comprimento_aloj - (@qt_comprimento_aloj * 0.10)
  
  set @nm_medida = cast(@qt_espessura as varchar) + ' x ' + cast(@qt_largura_aloj as varchar) +
                   ' x ' + cast(@qt_comprimento_aloj as varchar)
  
  -- Alojamento Desbastado  
  insert into consulta_item_orcamento_alojamento
  (
   cd_consulta,cd_item_consulta,cd_item_orcamento,cd_item_alojamento,ic_tipo_acab_alojamento,
   qt_alojamento,ic_tipo_face_alojamento,ic_tipo_furo_alojamento,ic_raio_fundo_alojamento,
   ic_cabeca_alojamento,nm_alojamento,qt_tempo_alojamento,vl_alojamento,nm_obs_alojamento,
   qt_tempo_acab_alojamento,qt_tempo_desb_alojamento,vl_acab_alojamento,vl_desb_alojamento,
   cd_tipo_mao_obra,ic_tipo_mao_obra,qt_profundidade_aloj,nm_medida_alojamento,qt_diametro_alojamento,
   qt_largura_alojamento,qt_comprimento_alojamento,qt_profundidade_cabeca,nm_medida_cabeca,
   qt_diametro_cabeca,qt_largura_cabeca,qt_comprimento_cabeca,ic_alivio_alojamento,
   qt_altura_alivio_aloj,qt_hora_mandrilhadora,vl_custo_mandrilhadora,cd_usuario,dt_usuario
  )
  values
  (
  @cd_consulta,@cd_item_consulta,@cd_item_orcamento,1,'D',1,'R','C','N','N',
  '01 ALOJ. DESB. EM PPM RETANG. CEGO S/ RAIOS FUNDO DE '+@nm_medida,0,0,null,0,0,0,0,1,'C',
  @qt_espessura,replace(@nm_medida,' ',''),0,@qt_largura_aloj,@qt_comprimento_aloj,null,null,null,null,null,
  'N',0,0,0,@cd_usuario,getdate()
  )
  
  -- Alojamento Acabado
  insert into consulta_item_orcamento_alojamento
  (
   cd_consulta,cd_item_consulta,cd_item_orcamento,cd_item_alojamento,ic_tipo_acab_alojamento,
   qt_alojamento,ic_tipo_face_alojamento,ic_tipo_furo_alojamento,ic_raio_fundo_alojamento,
   ic_cabeca_alojamento,nm_alojamento,qt_tempo_alojamento,vl_alojamento,nm_obs_alojamento,
   qt_tempo_acab_alojamento,qt_tempo_desb_alojamento,vl_acab_alojamento,vl_desb_alojamento,
   cd_tipo_mao_obra,ic_tipo_mao_obra,qt_profundidade_aloj,nm_medida_alojamento,qt_diametro_alojamento,
   qt_largura_alojamento,qt_comprimento_alojamento,qt_profundidade_cabeca,nm_medida_cabeca,
   qt_diametro_cabeca,qt_largura_cabeca,qt_comprimento_cabeca,ic_alivio_alojamento,
   qt_altura_alivio_aloj,qt_hora_mandrilhadora,vl_custo_mandrilhadora,cd_usuario,dt_usuario
  )
  values
  (
  @cd_consulta,@cd_item_consulta,@cd_item_orcamento,2,'A',1,'R','P','N','N',
  '01 ALOJ. ACAB. EM PPM RETANG. PASSANTE S/ RAIOS FUNDO DE '+@nm_medida,0,0,null,0,0,0,0,1,'C',
  @qt_espessura,replace(@nm_medida,' ',''),0,@qt_largura_aloj,@qt_comprimento_aloj,null,null,null,null,null,
  'N',0,0,0,@cd_usuario,getdate()
  )
  update consulta_item_orcamento
  set ic_agserv_item_orcamento = 'S',
      ic_aloj_item_orcamento = 'S'
  where cd_consulta       = @cd_consulta and
        cd_item_consulta  = @cd_item_consulta and
        cd_item_orcamento = @cd_item_orcamento
 
end

--
-- Inclusão de Serviço Externo
--

-- Somente se for Manifold ...

if (@sg_placa = 'MANIFOLD') and (@cd_produto_padrao > 0)
begin
  delete from consulta_item_servico_externo
  where cd_consulta = @cd_consulta and cd_item_consulta = @cd_item_consulta
  
  declare @cd_tipo_manifold int  
  declare @cd_servico       int
  declare @nm_servico       varchar(50)
  declare @sg_tipo_manifold varchar(10)
  declare @qt_servico       int
  declare @vl_unit_servico  float
  declare @vl_total_servico float
  declare @ic_exportacao    char(1)
  
  select top 1 @qt_servico       = qt_tampao_manifold,
               @cd_tipo_manifold = cd_tipo_manifold
  from consulta_caract_tecnica_cq
  where cd_consulta = @cd_consulta and cd_item_consulta = @cd_item_consulta
    
  select top 1 @sg_tipo_manifold = sg_tipo_manifold
  from tipo_manifold 
  where cd_tipo_manifold = @cd_tipo_manifold 
  --
  -- Serviços de Soldas dos tampões
  --
  set @cd_servico = 17
  select @nm_servico      = nm_servico_especial,
         @vl_unit_servico = vl_servico_especial
  from servico_especial
  where cd_servico_especial = @cd_servico
  
  -- Verificar se é exportação : Deverá dividir pelo valor médio de outra moeda ...
  declare @cd_moeda int
  declare @cd_grupo_produto int
  
  select top 1 @ic_exportacao    = tm.ic_exportacao_tipo_mercado,
               @cd_moeda         = b.cd_moeda,
               @cd_grupo_produto = ci.cd_grupo_produto 
  from consulta_itens ci,
       consulta a,
       cliente b,
       tipo_mercado tm
  where ci.cd_consulta = @cd_consulta and
        ci.cd_item_consulta = @cd_item_consulta and 
        ci.cd_consulta = a.cd_consulta and
        a.cd_cliente = b.cd_cliente and
        b.cd_tipo_mercado = tm.cd_tipo_mercado
  
  -- Busca o markup diferenciado para exportação (se houver...) 
  if @ic_exportacao = 'S'
  begin
     -- Analiza se tem um markup diferenciado ...
     declare @cd_aplicacao_markup int
      
     select @cd_aplicacao_markup = cd_aplicacao_markup
     from grupo_produto_markup
     where cd_grupo_produto = @cd_grupo_produto and
           cd_moeda = @cd_moeda
     
     declare @pc_markup float
     if isnull(@cd_aplicacao_markup,0) > 0
     begin
        select @pc_markup = (100-sum(a.pc_formacao_markup))/100
        from formacao_markup a,  
             tipo_markup b             
        where a.cd_aplicacao_markup = @cd_aplicacao_markup and  
               a.ic_tipo_formacao_markup = 'A' and  
               a.cd_tipo_markup = b.cd_tipo_markup
     end
     
     declare @vl_medio_moeda float
     select top 1 @vl_medio_moeda = vl_moeda_periodo 
     from valor_moeda_periodo
     where cd_moeda = @cd_moeda and
          (getdate() between dt_inicial_periodo and dt_final_periodo)
     
     if @vl_medio_moeda > 0 
        set @vl_unit_servico = @vl_unit_servico / @vl_medio_moeda
     if @pc_markup > 0
        set @vl_unit_servico = @vl_unit_servico / @pc_markup
     
  end
  
  set @vl_total_servico = @qt_servico * @vl_unit_servico

  if @qt_servico > 0
  begin
    insert into consulta_item_servico_externo
     (cd_consulta,cd_item_consulta,cd_item_servico_externo,cd_servico_especial,nm_servico_externo,
      qt_item_servico_externo,cd_unidade_medida,vl_unit_servico_externo,vl_total_servico_externo,
      nm_obs_servico_externo,cd_usuario,dt_usuario)
    values(@cd_consulta,@cd_item_consulta,1,@cd_servico,@nm_servico,@qt_servico,17,@vl_unit_servico,
           @vl_total_servico,null,@cd_usuario,getdate())
  
    if @qt_vias >= 6 
    begin
      -- Serviços de Limpeza das soldas dos tampões
      set @cd_servico = 18
      select @nm_servico      = nm_servico_especial,
             @vl_unit_servico = vl_servico_especial
      from servico_especial
      where cd_servico_especial = @cd_servico
    
      if @ic_exportacao = 'S'
      begin
         if @vl_medio_moeda > 0 
            set @vl_unit_servico = @vl_unit_servico / @vl_medio_moeda
         if @pc_markup > 0
            set @vl_unit_servico = @vl_unit_servico / @pc_markup
      end
    
      set @vl_total_servico = @qt_servico * @vl_unit_servico
    
      insert into consulta_item_servico_externo
       (cd_consulta,cd_item_consulta,cd_item_servico_externo,cd_servico_especial,nm_servico_externo,
        qt_item_servico_externo,cd_unidade_medida,vl_unit_servico_externo,vl_total_servico_externo,
        nm_obs_servico_externo,cd_usuario,dt_usuario)
      values(@cd_consulta,@cd_item_consulta,2,@cd_servico,@nm_servico,@qt_servico,17,@vl_unit_servico,
             @vl_total_servico,null,@cd_usuario,getdate())
    end  
  end
end

