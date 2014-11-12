
CREATE  PROCEDURE pr_carrega_produto_nota_saida
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution              2004
------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server     2000
--Autor(es)      : Fabio Cesar Magalhães
--Banco de Dados : EGISSQL
--Objetivo       : Carregas as informações de consulta dos produtos na nota fiscal de saída
--Data           : 01.02.2004
--Atualização    : 10/01/2005 - Inclusão de Rotina para Busca da Fase Correta de Baixa, 
--                           Considerando Transferência entre Fases - ELIAS
--              12/01/2005 - Atualização do Campo de Perc. de Desconto, mesmo se não
--                           existir na Classificação_Fiscal_Estado, buscando da
--                           Estado_Parâmetro - ELIAS
--              20/01/2005 - Corrigido Busca da Alíquota que deve ser sempre da 
--                           Estado_Parametro ou Classificação_Fiscal_Estado, caso
--                           seja Operação InterEstadual - ELIAS
--              07/05/2005 - Busca os Impostos somente se a Tributação for de Cálculo - ELIAS
--              22/07/2005 - Retorna a Tributação da CFOP ou do Produto, de acordo com o
--                           configurado na CFOP - ELIAS
--              15/09/2005 - Acrescido campo ic_entrada_estoque_fat - ELIAS
--              01.12.2005 - Foi acrescido o campo ic_especial_produto - Fabio
--              26/01/2006 - Ajustado retorno da alíquota interna de ICMS que deverá ser
--                           a aplicada internamente no estado do emissor da NF e não
--                           o conteúdo do campo de alíquota interna do estado fiscal - ELIAS
--              29.07.2006 - Cubagem - Carlos Fernandes
--              08.08.2006 - Inversão na variável "@ic_internacional" a mesma realizava 
--                           um procedimento invertido, gerando categorias incorretas - FABIO CESAR
--              12.06.2007 - Verificação Geral - Carlos Fernandes
-- 10.11.2007 - Verificação dos flags de Estoque - Carlos Fernandes
-- 20.05.2008 - (%) da Substituição do Item do Produto, buscar da classificação Fiscal - Carlos Fernandes
-- 21.08.2008 - Movimento do Kit na Reserva do Faturamento - Carlos Fernandes - Carlos Fernandes
-- 10.08.2009 - Substituição Tributária - Checar o cadastro do cliente - Carlos Fernandes
-- 08.09.2009 - Verifica se a Empresa é Isenta do IPI - Carlos Fernandes
-- 05.12.2009 - Quantidade de Múltiplo de Embalagem - Carlos Fernandes
-- 20.01.2010 - Descritivo Técnico do Pedido de Venda - Carlos Fernandes
-- 16.03.2010 - Fase de Produto para Baixar Estoque - Carlos Fernandes
-- 29.09.2010 - Ajuste na busca do produto - Carlos Fernandes
---------------------------------------------------------------------------------------------------------
@cd_fase_produto      int        = 0,
@cd_produto           int        = 0,
@cd_mascara_produto   varchar(20),
@nm_fantasia_produto  varchar(30),
@cd_operacao_fiscal   int        = 0,
@sg_estado            varchar(2) ,
@cd_pedido_venda      int        = 0,
@cd_item_pedido_venda int        = 0

AS

begin

  declare @cd_estado_cliente            int 
  declare @cd_pais_cliente              int
  declare @cd_digito_tributacao_icms    char(2)  
  declare @cd_tributacao_icms           int  
  declare @cd_procedencia_produto       int 
  declare @cd_digito_procedencia        char(1)  
  declare @cd_tributacao                int
  declare @ic_tributacao_op_fiscal      char(1) --define se a preferência deve ser dada para o produto
  declare @pc_icms_estado_parametro_ext float
  declare @pc_icms_estado_parametro_int float
  declare @pc_reducao_icms_estado       float
  declare @cd_estado_empresa            int
  declare @cd_pais_empresa              int
  declare @ic_internacional             char(1)
  declare @ic_calculo_icms              char(1)
  declare @ic_calculo_ipi               char(1)
  declare @ic_sub_tributaria_cliente    char(1) 
  declare @ic_isento_ipi_produto        char(1)
  declare @cd_fase_saida_op_fiscal      int 

--  declare @pc_subs_trib_item            float

  set @ic_isento_ipi_produto = 'N'

  select 
    @ic_isento_ipi_produto     = isnull(ic_isento_ipi_produto,'N')
  from
    parametro_produto with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  -- Carrega o Código do Estado - UF do Cliente

  set @ic_internacional = 'N'

  Select top 1 
    @cd_estado_cliente = cd_estado,
    @cd_pais_cliente   = isnull(cd_pais,1)
  from 
    Estado with (nolock) 
  where 
    sg_estado = @sg_estado

  -- Carrega o % de ICMS do Estado do Cliente (Alíquota InterEstadual e Interna)

  select top 1 
    @pc_icms_estado_parametro_ext = isnull(pc_aliquota_icms_estado,0),
    @pc_reducao_icms_estado       = isnull(qt_base_calculo_icms,0),
    @pc_icms_estado_parametro_int = isnull(pc_aliquota_icms_interna,0) 
  from 
    Estado_Parametro with (nolock) 
  where 
    cd_estado = @cd_estado_cliente

  -- Carrega o Pais e Estado da Empresa que Emite a NF

  select top 1 
    @cd_estado_empresa = cd_estado,
    @cd_pais_empresa   = IsNull(cd_pais,1)
  from 
    EgisAdmin..Empresa
  where
    cd_empresa = dbo.fn_empresa()

  -- Verifica se o Local é de Fora do Brasil

  if ( @cd_pais_cliente > 0 ) and (@cd_pais_cliente <> @cd_pais_empresa)
    set @ic_internacional = 'S'
  else
    set @ic_internacional = 'N'

  -- Encontra o Código do Produto se foi informado apenas a Máscara ou a Fantasia

  if (isnull(@cd_produto,0)=0) 
  begin
    if (isnull(@cd_mascara_produto,'')<>'')
    begin
      select top 1 @cd_produto = p.cd_produto
      from 
        Produto p with (nolock)
        inner join status_produto sp on sp.cd_status_produto = p.cd_status_produto
  
      where 
        isnull(sp.ic_bloqueia_uso_produto,'N') = 'N'
        and
        --select * from status_produto

        replace(replace(replace(@cd_mascara_produto,'-',''),'/',''),'.','') =
        replace(replace(replace(cd_mascara_produto,'-',''),'/',''),'.','')
     end
    else
      select top 1
        @cd_produto = p.cd_produto
      from 
        Produto p with (nolock)
        inner join status_produto sp on sp.cd_status_produto = p.cd_status_produto
  
      where 
        isnull(sp.ic_bloqueia_uso_produto,'N') = 'N'
        and
        @nm_fantasia_produto = nm_fantasia_produto

  end

-- Antes 16.03.2010
--   -- Carrega a Fase de Movimentação de Estoque do Produto - ELIAS
-- 
--   select @cd_fase_produto = case when ((select isnull(cd_fase_produto_baixa,0) from Produto with (nolock)
--                                         where cd_produto = @cd_produto) = 0) then
--                               case when ((select isnull(cd_fase_saida_op_fiscal,0) from Operacao_Fiscal with (nolock) 
--                                           where cd_operacao_fiscal = @cd_operacao_fiscal) = 0) then
--                                 (select cd_fase_produto from Parametro_Comercial
--                                  where cd_empresa = dbo.fn_empresa())
--                               else
--                                 (select cd_fase_saida_op_fiscal from Operacao_Fiscal with (nolock) 
--                                  where cd_operacao_fiscal = @cd_operacao_fiscal)                                 
--                               end
--                             else
--                               (select isnull(cd_fase_produto_baixa,0) from Produto with (nolock) 
--                                where cd_produto = @cd_produto) 
--                             end
  
  -- Carrega dados de Tributação da Operação Fiscal

  select top 1
    @ic_tributacao_op_fiscal   = IsNull(o.ic_tributacao_op_fiscal,'N'),
    @cd_digito_tributacao_icms = ti.cd_digito_tributacao_icms,
    @cd_tributacao_icms        = ti.cd_tributacao_icms,
    @cd_tributacao             = t.cd_tributacao,
    @cd_fase_saida_op_fiscal   = isnull(cd_fase_saida_op_fiscal,0)

  from 
    Operacao_Fiscal o             with (nolock) 
    inner join Tributacao t       with (nolock) on o.cd_tributacao = t.cd_tributacao 
    inner join Tributacao_icms ti with (nolock) on t.cd_tributacao_icms = ti.cd_tributacao_icms
  where 
    o.cd_operacao_fiscal = @cd_operacao_fiscal

  -- Carrega a Fase de Movimentação de Estoque do Produto - ELIAS

  select 
    @cd_fase_produto = isnull(cd_fase_produto_baixa,0) 
  from
    Produto p with (nolock)
  where
    p.cd_produto = @cd_produto


  --Fase da Operação Fiscal

  if @cd_fase_produto = 0
  begin
    set @cd_fase_produto = @cd_fase_saida_op_fiscal
  end

  --Fase do Parâmetro Comercial

  if @cd_fase_produto = 0 and @cd_fase_saida_op_fiscal = 0
  begin
    select 
      @cd_fase_produto = isnull(cd_fase_produto,0)
      from 
        Parametro_Comercial with (nolock) 
      where 
        cd_empresa = dbo.fn_empresa() 

  end 


                           

  -- Carrega Flag da Tributação do Produto, caso a CFOP indique que
  -- a tributação é preferencial no Produto - ELIAS 07/05/2005
  if ((select isnull(ic_tributacao_op_fiscal,'N')
       from operacao_fiscal where cd_operacao_fiscal = @cd_operacao_fiscal) = 'S')
  begin
    select 
      @cd_tributacao = cd_tributacao
    from 
      Produto_Fiscal with (nolock) 
    where 
      cd_produto = @cd_produto
  end

  -- Carrega os Flags de Cálculo dos Impostos ICMS e IPI deacordo com 
  -- a composição da Tributação

  set @ic_calculo_icms = isnull((select ic_evento_tributacao
                                 from composicao_tributacao 
                                 where cd_tributacao = @cd_tributacao and
                                       cd_imposto = 1 and
                                       cd_evento_tributacao = 1),'N')

  set @ic_calculo_ipi = isnull((select ic_evento_tributacao
                                from composicao_tributacao 
                                where cd_tributacao = @cd_tributacao and
                                      cd_imposto = 2 and
                                      cd_evento_tributacao = 1),'N')    

  -- Carrega a Procedência do Grupo de Produto (Default)

  select top 1
    @cd_procedencia_produto = g.cd_procedencia_produto,
    @cd_digito_procedencia  = pp.cd_digito_procedencia
  from
    Grupo_Produto_Fiscal g            with (nolock) 
    inner join Produto p              with (nolock) on g.cd_grupo_produto = p.cd_grupo_produto
    inner join Procedencia_Produto pp with (nolock) on pp.cd_procedencia_produto = g.cd_procedencia_produto
  where
    p.cd_produto = @cd_produto  

  -- Retorno da Procedure

  select top 1
    p.cd_produto, 
    p.nm_fantasia_produto,
    p.cd_mascara_produto,
    (SELECT nm_fantasia_produto FROM Produto with (nolock) 
     WHERE cd_produto = p.cd_substituto_produto) AS nm_fantasia_produto_substituto, 
    p.cd_unidade_medida, 
    p.vl_produto, 
    p.nm_produto, 
    p.qt_peso_bruto, 
    p.qt_peso_liquido, 
    --Verifica se o IPI é isento para a empresa
    case when @ic_isento_ipi_produto = 'S' then
      0.00
    else
      case when @ic_calculo_ipi = 'S' then
        isnull(cf.pc_ipi_classificacao,0) 
      else
        0.00
      end
    end
                                       as pc_ipi, 
    isnull(cf.ic_base_reduzida,'N')    as ic_base_reduzida,
    isnull(cf.ic_subst_tributaria,'N') as ic_subst_tributaria,

    -- ELIAS 22/07/2005 - Buscar a Tributação da CFOP ou do Produto
    -- dependendo do configurado na CFOP
    @cd_tributacao                      as cd_tributacao,   
    --isnull(pf.cd_tributacao, @cd_tributacao) as 'cd_tributacao',

    isnull(pf.cd_procedencia_produto, @cd_procedencia_produto)          as 'cd_procedencia_produto',  
    isnull(ticms.cd_digito_tributacao_icms, @cd_digito_tributacao_icms) as 'cd_digito_tributacao_icms',  
    isnull(pp.cd_digito_procedencia, @cd_procedencia_produto)           as 'cd_digito_procedencia',  
    (cast(isnull(pp.cd_digito_procedencia, @cd_digito_procedencia) as char(1)) + 
          ltrim(rtrim(isnull(ticms.cd_digito_tributacao_icms, @cd_digito_tributacao_icms)))) as 'cd_situacao_tributaria',
    pf.cd_classificacao_fiscal, 

    case @ic_internacional 
      when 'S' then
        (Select top 1 cd_categoria_produto 
         from Produto_Exportacao with (nolock) 
         where cd_produto = p.cd_produto)
      else 
        p.cd_categoria_produto
    end                                                                 as 'cd_categoria_produto',

    --Verificando se produto de baixa é outro para pegar o saldo de produto de baixa
    case 
      when isnull(p.cd_produto_baixa_estoque,0) = 0 then
        (select isnull(qt_saldo_atual_produto,0) 
         from Produto_Saldo with (nolock) 
         where cd_produto = p.cd_produto and cd_fase_produto =  @cd_fase_produto)   
      else
        (select isnull(qt_saldo_atual_produto,0) 
         from Produto_Saldo with (nolock)  
         where cd_produto = p.cd_produto_baixa_estoque and cd_fase_produto = @cd_fase_produto)
    end                                                                  as 'qt_saldo_atual_produto', 

    (select nm_fase_produto from Fase_Produto with (nolock) where cd_fase_produto = @cd_fase_produto) as nm_fase_produto,

    pf.cd_dispositivo_legal_ipi,
    pf.cd_dispositivo_legal_icms,

    case when (@ic_calculo_icms = 'S') then
      --Verifica se o produto possui uma aliquota cd ICMS padrão, para empresa que cadastra no produto sua aliquota
      --Aliquota Externa
      case @ic_tributacao_op_fiscal
        when 'S' then 
          (case 
             when ((IsNull(pf.pc_aliquota_icms_produto,0) = 0) or (@cd_estado_cliente <> @cd_estado_empresa)) then
               (case
                  when IsNull(cfe.pc_icms_classif_fiscal,0) = 0 then
                    @pc_icms_estado_parametro_ext
                  else
                    IsNull(cfe.pc_icms_classif_fiscal,0)
                end)
             else
               IsNull(pf.pc_aliquota_icms_produto,0)
           end)
        else
          (case 
             when IsNull(cfe.pc_icms_classif_fiscal,0) = 0 then
               (case
                  when @pc_icms_estado_parametro_ext = 0 then             
                    IsNull(pf.pc_aliquota_icms_produto,0)
                  else
                    @pc_icms_estado_parametro_ext
                end)
             else
               IsNull(cfe.pc_icms_classif_fiscal,0)
           end)
      end 
    else 0.00 end                                         as pc_icms,

    --select * from produto_fiscal

    case when (@ic_calculo_icms = 'S') then

      --Verifica se o produto possui uma aliquota de ICMS padrão, para empresa que cadastra no produto sua aliquota
      --Aliquota Externa

      case @ic_tributacao_op_fiscal
        when 'S' then 
          (case 
             when ((IsNull(pf.pc_aliquota_icms_produto,0) = 0) or (@cd_estado_cliente <> @cd_estado_empresa)) then
               (case
                  when IsNull(cfe.pc_icms_classif_fiscal,0) = 0 then
                    @pc_icms_estado_parametro_int
                  else
                    IsNull(cfe.pc_icms_classif_fiscal,0)
                end)
             else
               IsNull(pf.pc_interna_icms_produto,0)
           end)
        else
          (case 
             when IsNull(cfe.pc_icms_classif_fiscal,0) = 0 then
               (case
                  when @pc_icms_estado_parametro_int = 0 then             
                    IsNull(pf.pc_interna_icms_produto,0)
                  else
                    @pc_icms_estado_parametro_int
                end)
             else
               IsNull(cfe.pc_icms_classif_fiscal,0)
           end)
      end 
    else 0.00 end                                    as pc_icms_interna,

    isnull(pc.ic_peps_produto,'N')                   as ic_peps_produto,

    case IsNull(vl_custo_contabil_produto,0)
      when 0 then isnull(pc.vl_custo_produto,0)
      else isnull(pc.vl_custo_contabil_produto,0)
    end as 'vl_custo_produto',
    --Campo para informar o percentual de redução de base presente na classificação fiscal do produto para o estado destino
    --Busca do Estado Parâmetro, caso não exista na Classificação_Fiscal_Estado - ELIAS 12/01/2005
    case when isnull(cf.ic_base_reduzida,'N') = 'S' then
      case when (isnull(cfe.pc_redu_icms_class_fiscal,0) = 0) then
        @pc_reducao_icms_estado 
      else
        cfe.pc_redu_icms_class_fiscal
      end
    else
      0
    end                                 as 'pc_redu_icms_class_fiscal',

    --Checar o Flag do Cadastro do Produto
    -- 17.08.2009 - Ajuste

    case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' 
    then
       p.ds_produto
    else
      cast(null as varchar)
    end                                    as ds_produto, 

    isnull(p.vl_fator_conversao_produt,0)  as vl_fator_conversao_produt,

    isnull(p.ic_descritivo_nf_produto,'N') as ic_descritivo_nf_produto,
    p.cd_grupo_produto,

    --Verificar o Tipo do Frete para pegar a alíquota correta de ii - Igor
    isnull(cf.pc_importacao,0)             as 'pc_ii',

    IsNull((select top 1 ic_montagem_item_pedido from Pedido_venda_item with (nolock)
            where cd_pedido_venda = @cd_pedido_venda
             and cd_item_pedido_venda = @cd_item_pedido_venda),'N') as ic_montagem_item_pedido,   

    case IsNull(pc.ic_estoque_produto,'S')
      when 'N' then 'N'
      else 
	IsNull(grpc.ic_estoque_grupo_prod,'S')
    end                                    as ic_estoque_venda_produto,

    case IsNull(pc.ic_venda_saldo_negativo,'N')
      when 'S' then 'S'
      else 
	IsNull(grpc.ic_venda_saldo_neg_grupo,'N')
    end    
                                  as ic_venda_saldo_negativo,
    case isnull(pc.ic_estoque_fatura_produto,'S')
    when 'N' then 'N'
    else
     isnull(grpc.ic_estoque_fatura,'S')
    end                                      as ic_estoque_fatura_produto,
    IsNull(ic_bloqueia_uso_produto,'N')      as ic_bloqueia_uso_produto,
    case when IsNull(p.ic_baixa_composicao_prod,'N') = 'N'
         then IsNull(grp.ic_baixa_composicao_grupo,'N') else IsNull(p.ic_baixa_composicao_prod,'N')
    end                                      as 'ic_baixa_composicao',
    case when IsNull(p.ic_dev_composicao_prod,'N') = 'N'
         then IsNull(grp.ic_dev_composicao_grupo,'N') else IsNull(p.ic_dev_composicao_prod,'N')
    end as 'ic_baixa_composicao_devolucao',
    isnull(p.ic_entrada_estoque_fat,'N')             as 'ic_entrada_estoque_fat',
    
    --Especial 
    case when isnull(p.cd_produto,0)<>0 then
      'N'
    else
      IsNull(p.ic_especial_produto, 'N')          
    end                                              as  ic_especial_produto,

    p.qt_cubagem_produto,

    --% IVA --> Subst. Tributária

    isnull(cfe.pc_icms_strib_clas_fiscal,0)          as pc_icms_strib_clas_fiscal,

    isnull(grp.ic_kit_grupo_produto,'N')             as ic_kit_grupo_produto,
    isnull(pf.vl_ipi_produto_fiscal,0)               as vl_ipi_produto_fiscal,
    isnull(p.qt_multiplo_embalagem,0)                as qt_multiplo_embalagem,
    isnull(p.cd_fase_produto_baixa,@cd_fase_produto) as cd_fase_produto_baixa

--select * from produto_fiscal

  FROM         
    Procedencia_Produto pp          with (nolock)                                                            right outer join 
    Produto_Fiscal pf               with (nolock) on pp.cd_procedencia_produto  = pf.cd_procedencia_produto  left outer join
    Tributacao t                    with (nolock) on pf.cd_tributacao           = t.cd_tributacao            left outer join
    Tributacao_ICMS ticms           with (nolock) on t.cd_tributacao_icms       = ticms.cd_tributacao_icms   left outer join
    Classificacao_Fiscal cf         with (nolock) on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal right outer join
    Produto p                       with (nolock) on pf.cd_produto              = p.cd_produto               left outer join
    Produto_Custo pc                with (nolock) on pc.cd_produto              = p.cd_produto               left outer join

    Classificacao_Fiscal_Estado cfe with (nolock) on cf.cd_classificacao_fiscal = cfe.cd_classificacao_fiscal and 
                                                     cfe.cd_estado              = @cd_estado_cliente         Left outer join 

    Status_Produto sp               with (nolock) on p.cd_status_produto        = sp.cd_status_produto left outer join
    Grupo_Produto grp               with (nolock) on p.cd_grupo_produto         = grp.cd_grupo_produto left outer join
    Grupo_Produto_Custo grpc        with (nolock) on p.cd_grupo_produto         = grpc.cd_grupo_produto

--select * from produto where cd_produto = 11153
--select * from grupo_produto where cd_grupo_produto = 34

  WHERE     
    (p.cd_produto = @cd_produto)

--select * from classificacao_fiscal_estado
--pc_icms_strib_clas_fiscal
 
end

