
CREATE procedure pr_gera_contabilizacao_nota_saida

------------------------------------------------------------------------
--pr_gera_contabilizacao_nota_saida
------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)	      	: Fabio Cesar
--Banco de Dados  	: EGISSQL
--Objetivo	       	: Gera Contabilizacao de Nota de Saída
--Alteração             : 01/07/2003
--                      : 14/07/2003 - Carlos
--                      : 15/07/2003 - Eduardo
--                      : 16/07/2003 - Inclusão do IPI nas Devoluções - ELIAS
--                      : 16/07/2003 - Carregamento correto do Valor do Serviço qdo. a CFOP indicar - ELIAS
--                      : 29/07/2003 - Calculo do Valor Total, incluido BC Reduzida quando dedução do desc. de ICMS
--                                     quando Zona Franca de Manaus - ELIAS
--                      : 30/07/2003 - Acrescentado Desp. Acess. ao Valor Contábil - ELIAS
--                      : 06/08/2003 - Não considerar código do produto se o item for serviço - ELIAS
--                      : 07/08/2003 - Comentado código feito anteriormente em relação ao IPI de devolução - ELIAS/PAULINHO
--                      : 15/01/2004 - Acerto no atributi cd_tipo_mercado para sempre retornar como default o 1 - Merdaco Interno - ELIAS
--                      : 23/01/2004 - Acerto no TIME-OUT - Ludinei
--                      : 16/04/2004 - Acerto do cd_tipo_operacao_fiscal = 2 trazer notas de Saída - Alexandre
--                      : 07/06/2004 - Inclusão dos valores de Frete, Seguro e Despesas Acessórias mesmo quando Serviço - ELIAS
--                      : 07/07/2004 - Passa a buscar o Tipo de Operação Fiscal da Operação Fiscal e não mais da NF, campo que
--                                     foi notado não estar sendo gravado corretamente. - ELIAS
--                                     Busca a Operação Fiscal do Cabeçalho, caso não encontre no Item - ELIAS
--                      : 12/01/2005 - Acerto da Contabilização Zona Franca Uso Próprio e Industrialização - Carlos
--                      : 04/02/2005 - Checando a Operação Fiscal
-- 28.05.2008 - Contabilização do Pis/COFINS - Carlos Fernandes.
---------------------------------------------------------------------------------------------------------------------

@cd_nota_saida        int,     -- Código da Nota de Saída
@cd_item_nota_saida   int,     -- Código do Item da Nota de Saída
@ic_tipo_atualizacao  char(1), -- Manual / Automatica
@cd_usuario           int      -- Usuário

as

  declare @dt_nota_saida              datetime
  declare @cd_produto                 int
  declare @cd_grupo_produto           int
  declare @cd_categoria_produto	      int
  declare @vl_contab_nota_saida       decimal(25,2)
  declare @cd_conta_debito            int
  declare @cd_conta_credito           int
  declare @cd_historico_contabil      int
  declare @vl_item_nota_saida         decimal(25,2)
  declare @vl_ipi_item                decimal(25,2)
  declare @vl_icms_item               decimal(25,2)
  declare @vl_pis                     decimal(25,2)
  declare @vl_cofins                  decimal(25,2)
  declare @ic_razao_cliente_empresa   char(1)
  declare @cd_conta_cliente           int
  declare @cd_tipo_destinatario       int
  declare @cd_cliente                 int
  declare @cd_operacao_fiscal         int
  declare @cd_tipo_mercado            int
  declare @nm_atributo                varchar(25)
  declare @nm_historico_nota_saida    varchar(40)
  declare @nm_fantasia_cliente        varchar(15)
  
  declare @qt_lancamento_gerado_count int --Define que gerou lançamento
  declare @qt_lancamento_gerado       int --Enviar o parametro
  declare @cd_conta_padrao            int --Plano de conta do cliente
  
  declare @vl_total_nota              decimal(25,2)
  
  set @cd_conta_debito        = 0
  set @cd_conta_credito       = 0
  set @cd_historico_contabil  = 0
  set @vl_cofins              = 0  
  set @vl_pis                 = 0
  set @nm_atributo            = ''
  set @nm_historico_nota_saida= ''
  set @nm_fantasia_cliente    = ''
  
  -- ELIAS 18/12/2003
  SET LOCK_TIMEOUT 15000
  SET NOCOUNT ON
     
  -- Seleciona o documento para contabilização
  select top 1
    @cd_nota_saida          = ns.cd_nota_saida,
    @cd_item_nota_saida     = isnull(nsi.cd_item_nota_saida,0),
    @dt_nota_saida          = ns.dt_nota_saida,
  
    -- se o item da NF for Serviço, então ignorar o código do produto - ELIAS 06/08/2003
    @cd_produto             = case when nsi.ic_tipo_nota_saida_item = 'S' then 
                                0
                              else
                                isnull(nsi.cd_produto,0) end,
    @cd_grupo_produto       = isnull(nsi.cd_grupo_produto,0),
  
    @cd_categoria_produto   = isnull( (Select top 1 cd_categoria_produto
                                       from Pedido_venda_item
                                       where cd_pedido_venda = nsi.cd_pedido_venda and
                                             cd_item_pedido_venda = nsi.cd_item_pedido_venda),
                                      isnull(nsi.cd_categoria_produto,0) ),
  
    @vl_item_nota_saida    =   /* Operações de Serviço */                             
                               case when (nsi.ic_tipo_nota_saida_item = 'S') then
                                 cast(str((isnull(nsi.qt_item_nota_saida,1) * isnull(nsi.vl_servico,0)),25,2) as decimal(25,2)) + 
                                 cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
                                 cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
                                 cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
                               else 
                                 /* Produtos */ 

                               --Checa a Destinação
                              
                                 case when ( ns.cd_destinacao_produto = 2 and isnull(op.ic_zfm_operacao_fiscal,'N')='S' ) then --Uso Próprio
                                   cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2))+ 
                                   cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
                                   cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
                                   cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
                                 else                                       
                                   case when (nsi.cd_nota_saida is not null) then 
                                        cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) - 
                                                                 (cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) * 
                                                                  cast(str((isnull(nsi.pc_reducao_icms,0)/100),25,4) as decimal(25,4))) * 
                                                                  cast(str((isnull(nsi.pc_icms_desc_item,0)/100),25,4) as decimal(25,4)) + 
                                        cast(str(isnull(nsi.vl_ipi,0),25,2) as decimal(25,2)) + 
                                        cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
                                        cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
                                        cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
                                    else 
                                        cast(str(isnull(ns.vl_total,0),25,2) as decimal(25,2))
                                    end 
                                 end
                               end,
  
    @vl_ipi_item            = case when (nsi.cd_nota_saida is not null) 
                              then cast(str(isnull(nsi.vl_ipi,0),25,2) as decimal(25,2))
                              else cast(str(isnull(ns.vl_ipi,0),25,2) as decimal(25,2))
                              end, 
  
    @vl_icms_item           = case when (nsi.cd_nota_saida is not null) 
                              then cast(str(isnull(nsi.vl_icms_item,0),25,2) as decimal(25,2))
                              else cast(str(isnull(ns.vl_icms,0),25,2) as decimal(25,2))
                              end,

      
    @vl_pis                 = case when (nsi.cd_nota_saida is not null) 
                              then cast(str(isnull(nsi.vl_pis,0),25,2)  as decimal(25,2))
                              else cast(str(isnull(ns.vl_pis,0),25,2) as decimal(25,2))
                              end,

    @vl_cofins              = case when (nsi.cd_nota_saida is not null) 
                              then cast(str(isnull(nsi.vl_cofins,0),25,2)  as decimal(25,2))
                              else cast(str(isnull(ns.vl_cofins,0),25,2) as decimal(25,2))
                              end,

    @cd_cliente             = ns.cd_cliente,
  
    @cd_operacao_fiscal     = case when isnull(nsi.cd_operacao_fiscal,0)>0
                              then nsi.cd_operacao_fiscal
                              else ns.cd_operacao_fiscal
                              end,
  
    @nm_fantasia_cliente    = ns.nm_fantasia_nota_saida,
  
    @cd_tipo_destinatario   = ns.cd_tipo_destinatario,
  
    @cd_tipo_mercado        = isnull((case when ns.cd_tipo_destinatario = 1 then
                                     (select top 1 cd_tipo_mercado from Cliente where ns.cd_cliente = cd_cliente) 
                                      else
                                     (select top 1 cd_tipo_mercado from Fornecedor where ns.cd_cliente = cd_fornecedor) end),1),
  
    @cd_conta_cliente       = case when ns.cd_tipo_destinatario = 1 then
                              (select top 1 cd_conta from Cliente where ns.cd_cliente = cd_cliente) 
                              else
                              (select top 1 cd_conta from Fornecedor where ns.cd_cliente = cd_fornecedor) end

  from

    nota_saida ns with (nolock) 
  
    left outer join nota_saida_item nsi
    on   nsi.cd_nota_saida      = ns.cd_nota_saida and
         nsi.cd_item_nota_saida = @cd_item_nota_saida
  
    left outer join operacao_fiscal op
    on   op.cd_operacao_fiscal = isnull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal)
    
    left outer join grupo_operacao_fiscal gop
    on   gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
  
  where
    -- ELIAS 07/07/2004
    gop.cd_tipo_operacao_fiscal = 2 and
    ns.cd_nota_saida            = @cd_nota_saida
  
  -- Arredonda os valores quando da passagem pelo último item
  if (@cd_item_nota_saida = (select max(cd_item_nota_saida) from nota_saida_item where cd_nota_saida = @cd_nota_saida))
  begin
  
    select @vl_total_nota = cast(str(vl_total,25,2) as decimal(25,2))
    from nota_saida where cd_nota_saida = @cd_nota_saida
  
    select @vl_contab_nota_saida = cast(str(sum(vl_contab_nota_saida),25,2) as decimal(25,2)) from nota_saida_contabil
    where cd_nota_saida = @cd_nota_saida
  
    if ((@vl_contab_nota_saida + @vl_item_nota_saida - @vl_total_nota) between -0.5 and 0.5)
      set @vl_item_nota_saida = @vl_item_nota_saida - (@vl_contab_nota_saida + @vl_item_nota_saida - @vl_total_nota)
  
  end
  
  
  --Checa o Parâmetro Contabil para saber se a Contabilização :
  --Única ou por Cliente
  select top 1
    @ic_razao_cliente_empresa = isnull(ic_razao_cliente_empresa,'N'),
    @cd_conta_padrao          = cd_conta_cliente
  from
    Parametro_Financeiro
  where
    cd_empresa = dbo.fn_empresa() -- funcao que pega a empresa automaticamente.
  
  --Checa se o código contábil é por cliente
  if @ic_razao_cliente_empresa = 'S'
     set @cd_conta_cliente = @cd_conta_padrao
  
  --Define que foi gerado algum lançamento
  set @qt_lancamento_gerado_count = 0
  
  -- Caso não tenha sido preenchido o Tipo de Mercado,
  -- Atribui-se como Default o Mercado Interno (1)
  if @cd_tipo_mercado is null
    set @cd_tipo_mercado = 1  
  
  --------------------------------------------------------
  -- Contabilizar o valor do ICMS se existir
  --------------------------------------------------------
  if isnull(@vl_icms_item,0) > 0 
  begin
  
    set @vl_contab_nota_saida    = @vl_icms_item
    set @nm_atributo             = 'vl_icms_item_nota_saida' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito         = 0
    set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  
    -- Essa stored procedure insere na tabela nota_saida_contabil
    exec pr_grava_geracao_contabilizacao_nota_saida
            @cd_nota_saida,
            @cd_item_nota_saida,
            @dt_nota_saida,
            @vl_contab_nota_saida,
            @nm_atributo,
            @cd_produto,
            @cd_grupo_produto,
            @cd_tipo_mercado,
            @cd_conta_debito,
            @cd_conta_credito,      
            @nm_historico_nota_saida, 				
            @cd_tipo_destinatario,
            @cd_cliente,
            @nm_fantasia_cliente,
            @cd_operacao_fiscal,
            @cd_usuario,
            @cd_categoria_produto,
            @qt_lancamento_gerado OUTPUT
  
     --Define a quantidade de lançamentos gerados
     set @qt_lancamento_gerado_count =
            @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)
  
  	-- ludinei 22/01/2004
  	SET LOCK_TIMEOUT 15000
  
  end
  
  
  --------------------------------------------------------
  -- Contabilizar o valor do IPI se existir
  --------------------------------------------------------
  if isnull(@vl_ipi_item,0) > 0
  begin
  
    set @vl_contab_nota_saida    = @vl_ipi_item
    set @nm_atributo             = 'vl_ipi_item_nota_saida' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito         = 0
    set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  
    -- Essa stored procedure insere na tabela nota_saida_contabil
    exec pr_grava_geracao_contabilizacao_nota_saida
            @cd_nota_saida,
            @cd_item_nota_saida,
            @dt_nota_saida,
            @vl_contab_nota_saida,
            @nm_atributo,
            @cd_produto,
            @cd_grupo_produto,
            @cd_tipo_mercado,
            @cd_conta_debito,
            @cd_conta_credito,      
            @nm_historico_nota_saida, 
            @cd_tipo_destinatario,
            @cd_cliente,
            @nm_fantasia_cliente,
            @cd_operacao_fiscal,
            @cd_usuario,
            @cd_categoria_produto,
            @qt_lancamento_gerado OUTPUT
  
     --Define a quantidade de lançamentos gerados
     set @qt_lancamento_gerado_count =
            @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)
  
  	-- ludinei 22/01/2004
  	SET LOCK_TIMEOUT 15000
  
  end
  
  --------------------------------------------------------
  -- Contabilizar o valor do COFINS se existir
  --------------------------------------------------------
  if isnull(@vl_cofins,0) > 0 
  begin
  
    set @vl_contab_nota_saida    = @vl_cofins
    set @nm_atributo             = 'vl_cofins' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito         = 0
    set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  
    -- Essa stored procedure insere na tabela nota_saida_contabil
    exec pr_grava_geracao_contabilizacao_nota_saida
            @cd_nota_saida,
            @cd_item_nota_saida,
            @dt_nota_saida,
            @vl_contab_nota_saida,
            @nm_atributo,
            @cd_produto,
            @cd_grupo_produto,
            @cd_tipo_mercado,
            @cd_conta_debito,
            @cd_conta_credito,      
            @nm_historico_nota_saida, 				
            @cd_tipo_destinatario,
            @cd_cliente,
            @nm_fantasia_cliente,
            @cd_operacao_fiscal,
            @cd_usuario,
            @cd_categoria_produto,
            @qt_lancamento_gerado OUTPUT
  
     --Define a quantidade de lançamentos gerados
     set @qt_lancamento_gerado_count =
            @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)
  
  	-- ludinei 22/01/2004
  	SET LOCK_TIMEOUT 15000
  
  end

  --------------------------------------------------------
  -- Contabilizar o valor do PIS se existir
  --------------------------------------------------------
  if isnull(@vl_pis,0) > 0 
  begin
  
    set @vl_contab_nota_saida    = @vl_pis
    set @nm_atributo             = 'vl_pis' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito         = 0
    set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  
    -- Essa stored procedure insere na tabela nota_saida_contabil
    exec pr_grava_geracao_contabilizacao_nota_saida
            @cd_nota_saida,
            @cd_item_nota_saida,
            @dt_nota_saida,
            @vl_contab_nota_saida,
            @nm_atributo,
            @cd_produto,
            @cd_grupo_produto,
            @cd_tipo_mercado,
            @cd_conta_debito,
            @cd_conta_credito,      
            @nm_historico_nota_saida, 				
            @cd_tipo_destinatario,
            @cd_cliente,
            @nm_fantasia_cliente,
            @cd_operacao_fiscal,
            @cd_usuario,
            @cd_categoria_produto,
            @qt_lancamento_gerado OUTPUT
  
     --Define a quantidade de lançamentos gerados
     set @qt_lancamento_gerado_count =
            @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)
  
  	-- ludinei 22/01/2004
  	SET LOCK_TIMEOUT 15000
  
  end
  
  --------------------------------------------------------
  -- Contabilizar o valor da Nota de Saída
  --------------------------------------------------------

  if isnull(@vl_item_nota_saida,0) > 0
  begin
  
    set @vl_contab_nota_saida    = @vl_item_nota_saida
    set @nm_atributo             = 'cd_nota_saida'
    set @cd_conta_debito         = 0
    set @cd_conta_credito        = @cd_conta_cliente
    set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  
    -- Essa stored procedure insere na tabela nota_saida_contabil
    exec pr_grava_geracao_contabilizacao_nota_saida
            @cd_nota_saida,
            @cd_item_nota_saida,
            @dt_nota_saida,
            @vl_contab_nota_saida,
            @nm_atributo,
            @cd_produto,
            @cd_grupo_produto,
            @cd_tipo_mercado,
            @cd_conta_debito,
            @cd_conta_credito,      
            @nm_historico_nota_saida, 
            @cd_tipo_destinatario,
            @cd_cliente,
            @nm_fantasia_cliente,
            @cd_operacao_fiscal,
            @cd_usuario,
            @cd_categoria_produto,
            @qt_lancamento_gerado OUTPUT
  
     --Define a quantidade de lançamentos gerados
     set @qt_lancamento_gerado_count =
            @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)
  
  	-- ludinei 22/01/2004
  	SET LOCK_TIMEOUT 15000
  end
  
  --=================================================================================
  --Caso não tenha gerado nenhum lançamento, pois a nota não possui lancamento_padrao
  --=================================================================================
  if @qt_lancamento_gerado_count = 0
  begin
  
    --------------------------------------------------------
    -- Contabilizar o valor do ICMS se existir
    --------------------------------------------------------
    if isnull(@vl_icms_item,0) > 0 
    begin
  
      set @vl_contab_nota_saida    = @vl_icms_item
      set @nm_atributo             = 'vl_icms_item_nota_saida' --Verificar no Cadastro de Tipo de Contabilização
      set @cd_conta_debito         = 0
      set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente		
  	
      -- Essa stored procedure insere na tabela nota_saida_contabil
      exec pr_grava_geracao_contabilizacao_nota_saida
              @cd_nota_saida,
              @cd_item_nota_saida,
              @dt_nota_saida,
              @vl_contab_nota_saida,
              @nm_atributo,
              @cd_produto,
              @cd_grupo_produto,
              @cd_tipo_mercado,
              @cd_conta_debito,
              @cd_conta_credito,      
              @nm_historico_nota_saida, 
              @cd_tipo_destinatario,
              @cd_cliente,
              @nm_fantasia_cliente,
              @cd_operacao_fiscal,
              @cd_usuario,
              @cd_categoria_produto,
              -1

    	-- ludinei 22/01/2004
    	SET LOCK_TIMEOUT 15000
  
    end
  
  
    --------------------------------------------------------
    -- Contabilizar o valor do IPI se existir
    --------------------------------------------------------
    if isnull(@vl_ipi_item,0) > 0
    begin
  
      set @vl_contab_nota_saida    = @vl_ipi_item
      set @nm_atributo             = 'vl_ipi_item_nota_saida' --Verificar no Cadastro de Tipo de Contabilização
      set @cd_conta_debito         = 0
      set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  		
      -- Essa stored procedure insere na tabela nota_saida_contabil
      exec pr_grava_geracao_contabilizacao_nota_saida
              @cd_nota_saida,
              @cd_item_nota_saida,
              @dt_nota_saida,
              @vl_contab_nota_saida,
              @nm_atributo,
              @cd_produto,
              @cd_grupo_produto,
              @cd_tipo_mercado,
              @cd_conta_debito,
              @cd_conta_credito,      
              @nm_historico_nota_saida, 
              @cd_tipo_destinatario,
              @cd_cliente,
              @nm_fantasia_cliente,
              @cd_operacao_fiscal,
              @cd_usuario,
              @cd_categoria_produto,
              -1 --Define que deve gravar
  
    	-- ludinei 22/01/2004
  	  SET LOCK_TIMEOUT 15000

    end
  
  
    --------------------------------------------------------
    -- Contabilizar o valor da Nota de Saída
    --------------------------------------------------------
    if isnull(@vl_item_nota_saida,0) > 0
    begin
  
      set @vl_contab_nota_saida    = @vl_item_nota_saida
      set @nm_atributo             = 'cd_nota_saida'
      set @cd_conta_debito         = 0
      set @cd_conta_credito        = @cd_conta_cliente
      set @nm_historico_nota_saida ='-NF '+cast(@cd_nota_saida as varchar(10))+'-'+@nm_fantasia_cliente
  		
      -- Essa stored procedure insere na tabela nota_saida_contabil		
      exec pr_grava_geracao_contabilizacao_nota_saida
              @cd_nota_saida,
              @cd_item_nota_saida,
              @dt_nota_saida,
              @vl_contab_nota_saida,
              @nm_atributo,
              @cd_produto,
              @cd_grupo_produto,
              @cd_tipo_mercado,
              @cd_conta_debito,
              @cd_conta_credito,      
              @nm_historico_nota_saida, 
              @cd_tipo_destinatario,
              @cd_cliente,
              @nm_fantasia_cliente,
              @cd_operacao_fiscal,
              @cd_usuario,
              @cd_categoria_produto,
              -1
  
    	-- ludinei 22/01/2004
    	SET LOCK_TIMEOUT 15000

    end
  
    -- ELIAS 18/12/2003
    SET LOCK_TIMEOUT -1
  
  end

