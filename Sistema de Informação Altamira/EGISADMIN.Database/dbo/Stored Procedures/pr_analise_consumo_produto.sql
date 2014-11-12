
CREATE PROCEDURE pr_analise_consumo_produto

--------------------------------------------------------------------------------------------
--GBS - Global Business Sollution              2002
--------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Eduardo Baião
--Banco de Dados: EGISSQL
--Objetivo      : Consulta a Análise de Consumo de Produtos
--Data          : 22/01/2004
-- Eduardo : Devido aos transtornos mensais devido à problemas relacionado à dados e performance,
--           a rotina foi completamente reescrita.
-- 16/02/2004 - Finalização do desenvolvimento da rotina de acordo com as regras antigas - Eduardo.
-- 17/02/2004 - Filtrar apenas os tipos de Movimento com "ic_consumo_tipo_movimento" igual a 'S' - Eduardo.
-- 18/02/2004 - Permitir a selação dos produtos pela Carteira de Pedidos - Eduardo.
-- 02/03/2004 - Permitir selecionar os registros do Fornecedor usando o Filtro de Destinatário - Eduardo.
-- 03/03/2004 - Se foi usado o filtro por Destinatário Fornecedor,
--              na Coluna Fornecedor só aparecerá o nome do mesmo - Eduardo.
-- 09/03/2004 - Acerto na coluna de Consumo Trimestral - Eduardo.
-- 22/03/2004 - Usar parâmetro para definir se deve aparecer o mês atual - Eduardo.
-- 06/07/2004 - Não estava filtrando corretamento pelo Status do Produto - Eduardo.
-- 15.05.2004 - Nos campos de previsão, foi feito uma nova flag no parametro_estoque "ic_previsao_evolucao_consumo"
--            - para verificar se as previsões serão originadas pelo compras ou pela importação. Igor Gama
-- 28/06/2004 - Reescrito SQL e feito macrosubstituição para evitar problemas de Permissões de 
--              usuários ao criar tabelas - Daniel C. Neto.
-- 20/01/2005 - Acerto da Média Trimestral ( dividir por 3 e não pela quantidade de meses da Evolução )
-- 02/09/2005 - Qtd. de Pedidos, somar os pedidos de importação - Carlos Fernandes.
-- 22/11/2005 - Passa a buscar as quantidades e datas de previsão dos Lançamentos de Previsão e Pedidos de Compra, de acordo
--              com o configurado no arâmetro de Estoque - ELIAS    
-- 19/12/2005 - Acerto na Quantidade a ser comprada quando parâmetro de estoque indicar "Importação", que no caso
--              deverá utilizar somente as quantidades digitadas como previsão - ELIAS
-- 20.12.2005 - Foi implementado um controle de valores nulos para os campos "Saldo_Disponivel" e "Saldo_Atual" - Fabio
-- 09.01.2006 - Implementar a mesma lógica na soma das quantidades de Ambos, como atualmente é feito para Importação - Fabio
-- 15/03/2006 - Ajuste na quantidade e data de previsão que utilizará o mesmo campo de compras quando parâmetro for ambas,
--              Isso devido a gravação correta das previsões pelas entradas de produtos - ELIAS
-- 12/04/2006 - Paulo Souza
--              Inclusão das requisições de importação e dos pedidos de importação
-- 08.05.2006 - Foi implementada uma nova coluna "Entreposto" a ser carregada em função da fase definida no parâmetro de estoque - Fabio
-----------------------------------------------------------------------------------------------------------------------

@cd_mes			  int,
@cd_ano			  int,
@qt_mes			  int,
@nm_fantasia_produto  	  varchar(30) = '',
@cd_serie_produto 	  int,
@cd_fase_produto          int,
@cd_tipo_operacao_fiscal  varchar(1)  = 'S', --Parametro para dizer se é de Entrada/Saida ou Carteira de Pedidos
@nm_fantasia_destinatario varchar(30) = '',
@cd_fornecedor            int,
@cd_grupo_produto         int = 0,
@cd_mascara_produto	  varchar(30) = '',
@cd_status_produto        int = 0,
@cd_procedencia_produto   int = 0,

@ic_custo_zerado          varchar(1), -- Este parâmetro não deve usar a mesma lógica dos
                                      -- parâmetros de finalidade

-----------------------------------------------------------------------------------------
-- ATENÇÂO!!!!!!! Sempre que incluir um novo filtro de Finalidade
-- lembrar de atualizar as variáveis @ic_todas_finalidades e @ic_numero_de_SIM_finalidade
-- logo abaixo (Eduardo)
@ic_comercial             varchar(1),
@ic_compra                varchar(1),
@ic_producao              varchar(1),
@ic_importacao            varchar(1),
@ic_exportacao            varchar(1),
@ic_beneficiamento        varchar(1),
@ic_amostra               varchar(1),
@ic_consignacao           varchar(1),
@ic_transferencia         varchar(1),
@ic_sob_encomenda         varchar(1),
@ic_revenda               varchar(1),
@ic_assistencia_tecnica   varchar(1),
@ic_almoxarifado          varchar(1),
-----------------------------------------------------------------------------------------

@ic_sem_movimentacao      varchar(1), -- Este parâmetro não deve usar a mesma lógica dos
                                     -- parâmetros de finalidade
@ic_carteira_pedidos      varchar(1) = 'N',
@cd_tipo_destinatario     int = 1 -- Tipo de Destinatário padrão: Cliente


as begin

	declare 
	  @cont                        int,
	  @dt_inicial                  datetime,
	  @dt_final                    datetime,
	  @dt_inicial_trimestral       datetime,
	  @dt_final_trimestral         datetime,
	  @ic_todas_finalidades        varchar(30), --Informa se deve trazer todas as finalidades
    @ic_numero_de_SIM_finalidade varchar(30),
	  @ic_numero_de_NAO_finalidade varchar(30),
    @ic_mostrar_mes_atual        char(1),
    @cd_fase_produto_entreposto int,
    @nm_usuario_logado varchar(100)


  --Define o usuário logado
  Select @nm_usuario_logado = RTrim(LTrim(USER_NAME()))

  select
    @ic_mostrar_mes_atual = ic_mostrar_mes_atual,
    @cd_fase_produto_entreposto = IsNull(cd_fase_produto_entreposto, @cd_fase_produto) --Define a fase do entreposto - Fabio
  from
    parametro_estoque
  where
    cd_empresa = dbo.fn_empresa()  

  set @ic_mostrar_mes_atual = IsNull(@ic_mostrar_mes_atual,'N')
	
	-- Se a procedure for executado de dentro do Egis
	-- o SQL Server não preenche os parâmetros com valores Default,
	-- logo temos que fazer isto "na mão"
	set @ic_custo_zerado = IsNull(@ic_custo_zerado,'I')
	set @ic_sem_movimentacao = IsNull(@ic_sem_movimentacao,'N')
  set @ic_carteira_pedidos = IsNull(@ic_carteira_pedidos,'N')
	
	set @ic_comercial = IsNull(@ic_comercial,'S')
	set @ic_compra = IsNull(@ic_compra,'S')
	set @ic_producao = IsNull(@ic_producao,'S')
	set @ic_importacao = IsNull(@ic_importacao,'S')
	set @ic_exportacao = IsNull(@ic_exportacao,'S')
	set @ic_beneficiamento = IsNull(@ic_beneficiamento,'S')
	set @ic_amostra = IsNull(@ic_amostra,'S')
	set @ic_consignacao = IsNull(@ic_consignacao,'S')
	set @ic_transferencia = IsNull(@ic_transferencia,'S')
	set @ic_sob_encomenda = IsNull(@ic_sob_encomenda,'S')
	set @ic_revenda = IsNull(@ic_revenda,'S')
	set @ic_assistencia_tecnica = IsNull(@ic_assistencia_tecnica,'S')
	set @ic_almoxarifado = IsNull(@ic_almoxarifado,'S')
	
	set @ic_todas_finalidades = @ic_comercial + @ic_compra + @ic_producao + @ic_importacao
	+ @ic_exportacao + @ic_beneficiamento + @ic_amostra + @ic_consignacao
	+ @ic_transferencia + @ic_sob_encomenda + @ic_revenda + @ic_assistencia_tecnica 
	+ @ic_almoxarifado
	
	set @ic_numero_de_SIM_finalidade = 'SSSSSSSSSSSSS'
	set @ic_numero_de_NAO_finalidade = 'NNNNNNNNNNNNN'

  set @nm_fantasia_destinatario = IsNull(@nm_fantasia_destinatario,'')
  set @cd_tipo_destinatario = IsNull(@cd_tipo_destinatario,1) -- Tipo de Destinatário padrão: Cliente

  set @nm_fantasia_produto = IsNull(@nm_fantasia_produto,'')
  set @cd_mascara_produto  = IsNull(@cd_mascara_produto,'')

  set @cd_serie_produto       = IsNull(@cd_serie_produto,0)
  set @cd_grupo_produto       = IsNull(@cd_grupo_produto,0)
  set @cd_status_produto      = IsNull(@cd_status_produto,0)
  set @cd_procedencia_produto = IsNull(@cd_procedencia_produto,0)

  -- Limpar qualquer formatação na máscara digitada
  set @cd_mascara_produto = dbo.fn_limpa_mascara( @cd_mascara_produto )

	-------------------------------------------------------------------------
	-- Criar a tabela temporária onde ficará a seleção inicial dos produtos
	-------------------------------------------------------------------------
	
	create table #Selecao_Inicial
    ( cd_chave_produto int null )

  -- Só selecionar os registros se tiver escolhido
  -- pelo menos uma finalidade
  if ( @ic_todas_finalidades <> @ic_numero_de_NAO_finalidade ) 
  begin
	
		declare @cSQL as varchar(4000)
		declare @cFinalidades as varchar(1000)
		
		set @cSQL =	
			'Insert Into ' +
			'  #Selecao_Inicial ' +
			'Select ' +
			'  p.cd_produto as cd_chave_produto ' +
			'From ' +
			'  Produto p with (nolock) ' +
			'  left outer join Produto_Custo pc with (nolock) ' +
			'    on pc.cd_produto = p.cd_produto ' +
			
			'  left outer join Produto_Fiscal pf with (nolock) ' +
			'    on pf.cd_produto = p.cd_produto ' +
			' Where ' +
		  '  ( 1 = 1 ) '
		
		-- Nome Fantasia
		if ( @nm_fantasia_produto <> '' )
		  set @cSQL = @cSQL + ' and ( p.nm_fantasia_produto like ''' + @nm_fantasia_produto + '%'' ) '
		
		-- Série
		if ( @cd_serie_produto <> 0 )
		  set @cSQL = @cSQL + ' and ( p.cd_serie_produto = ' + cast(@cd_serie_produto as varchar) + ' ) '
		
		-- Série
		if ( @cd_grupo_produto <> 0 )
		  set @cSQL = @cSQL + ' and ( p.cd_grupo_produto = ' + cast(@cd_grupo_produto as varchar) + ' ) '
		
		-- Máscara do Produto
		if ( @cd_mascara_produto <> '' )
		  set @cSQL = @cSQL + ' and ( p.cd_mascara_produto like ''' + @cd_mascara_produto + '%'' ) '
		
		-- Status do Produto
		if ( @cd_status_produto <> 0 )
		  set @cSQL = @cSQL + ' and ( p.cd_status_produto = ' + cast(@cd_status_produto as varchar) + ' ) '
		
		-- Procedência
		if ( @cd_procedencia_produto <> 0 )

		  set @cSQL = @cSQL + ' and ( pf.cd_procedencia_produto = ' + cast(@cd_procedencia_produto as varchar) + ' ) '
		
		-- Custo Zerado
		if( @ic_custo_zerado = 'S' )
		  set @cSQL = @cSQL + ' and ( isNull(pc.vl_custo_produto,0) = 0 ) '
		
		-- Custo Preenchido
		if( @ic_custo_zerado = 'N' )
		  set @cSQL = @cSQL + ' and ( isNull(pc.vl_custo_produto,0) <> 0 ) '

    -- Fornecedor
    if ( @cd_fornecedor <> 0 )
    begin
		  set @cSQL = @cSQL +
        ' and ( exists ( select top 1 fp.cd_fornecedor ' +
                       ' from fornecedor_produto fp with (nolock) ' +
                       ' where fp.cd_fornecedor = ' + cast(@cd_fornecedor as varchar) + ' and ' +
                             ' fp.cd_produto = p.cd_produto ) ) '
    end

    ---- Se desmarcou pelo menos uma finalidade, filtrar
    ---- pelas que estiverem marcadas
  	if ( @ic_todas_finalidades <> @ic_numero_de_SIM_finalidade )
    begin
 
      set @cFinalidades = ''

			--Comercial
      if ( @ic_comercial = 'S' )
      begin
		    set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_comercial_produto,''N'') = ''S'' ) '
      end

			--Compra
			if ( @ic_compra = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_compra_produto,''N'') = ''S'' ) '
      end

			--Produção
			if ( @ic_producao = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_producao_produto,''N'') = ''S'' ) '
			end

			--Importação
			if ( @ic_importacao = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_importacao_produto,''N'') = ''S'' ) '
      end

			--Exportação
			if ( @ic_exportacao = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_exportacao_produto,''N'') = ''S'' ) '
      end

			--Beneficiamento
			if ( @ic_beneficiamento = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_beneficiamento_produto,''N'') = ''S'' ) '
      end

			--Amostra
			if ( @ic_amostra = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_amostra_produto,''N'') = ''S'' ) '
      end

			--Consignação
			if ( @ic_consignacao = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_consignacao_produto,''N'') = ''S'' ) '
      end

			--Transferencia
			if ( @ic_transferencia = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_transferencia_produto,''N'') = ''S'' ) '
      end

			--Sob Encomenda
			if ( @ic_sob_encomenda = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_sob_encomenda_produto,''N'') = ''S'' ) '
      end

			--Transferencia
			if ( @ic_revenda = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_revenda_produto,''N'') = ''S'' ) '
      end

			--Assistencia Técnica
			if ( @ic_assistencia_tecnica = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_tecnica_produto,''N'') = ''S'' ) '
      end

			--Almoxarifado
			if ( @ic_almoxarifado = 'S' )
      begin
        if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        set @cFinalidades = @cFinalidades + ' ( isnull(p.ic_almox_produto,''N'') = ''S'' ) '
      end

      set @cSQL = @cSQL + ' and ( ' + @cFinalidades + ' ) '

    	print @cFinalidades	

    end -- if

	end -- if

	print @cSQL

	exec( @cSQL )

	---------------------------------------------------
	-- Apagar a tabela de Evoluçao de Consumo
	---------------------------------------------------
  if exists(Select * from sysobjects
            where name = 'EVOLUCAO_CONSUMO' and
                  xtype = 'U' AND
                  uid = USER_ID(@nm_usuario_logado))
  begin
    set @cSQL = ' DROP TABLE ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO'
    exec(@cSQL)
  end

	---------------------------------------------------
	-- Seleção dos dados dos Produtos
	---------------------------------------------------
  --P.S.: Nos campos de previsão, foi feito uma nova flag no parametro_estoque "ic_previsao_evolucao_consumo"
  -- para verificar se as previsões serão originadas pelo compras ou pela importação. Igor Gama - 13.05.2004

  Select ------------------------------------------------------------------- SELECT
    cast(0 as integer)         as 'Sel',
    p.cd_produto,
    p.cd_mascara_produto,
    'N'                        as Comprar,
    'N'                        as EstNeg,
    'N'                        as ReservaMReal,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.cd_unidade_medida,
    um.nm_unidade_medida,
    p.cd_categoria_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    gp.nm_grupo_produto,
    p.ic_kogo_produto          as Kogo,
    isnull(isnull(p.qt_evolucao_produto, gp.qt_evolucao_grupo_produto),4) as 'qt_evolucao_produto',
    p.nm_marca_produto,

    --Produto para produção
    isnull(p.ic_producao_produto,'N') as ic_producao_produto,
    --Produto para compra
    isnull(p.ic_compra_produto,'N')   as ic_compra_produto,

    --Qtd_Minimo
	  ps.qt_minimo_produto        as 'Qtd_Minimo',

    
    --Define a quantidade no entreposto, caso necessária
    case @cd_fase_produto_entreposto
      when 0 then
        0
      when @cd_fase_produto then
        0
      else
        IsNull((Select 
                  top 1 qt_saldo_atual_produto 
                from 
                  Produto_Saldo ps with (nolock) 
                where 
                  ps.cd_produto = p.cd_produto and ps.cd_fase_produto = @cd_fase_produto_entreposto), 0)
    end as 'qt_saldo_entreposto',

    --Dt_Prev_Entrada1
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then case when ps.dt_prev_ent1_produto = 0 then null else ps.dt_prev_ent1_produto end
      when 'I' then case when ps.dt_ped_comp_imp1 = 0 then null else ps.dt_ped_comp_imp1 end
      when 'A' then case when ps.dt_prev_ent1_produto = 0 then null else ps.dt_prev_ent1_produto end
    end as 'Dt_Prev_Entrada1',

    --Qtd_Prev_Entrada1    
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then isnull(ps.qt_prev_ent1_produto,0) 
      when 'I' then isnull(ps.qt_ped_comp_imp1,0)
      when 'A' then isnull(ps.qt_prev_ent1_produto,0) 
    end as 'Qtd_Prev_Entrada1',

    --Dt_Prev_Entrada2
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then case when ps.dt_prev_ent2_produto = 0 then null else ps.dt_prev_ent2_produto end
      when 'I' then case when ps.dt_ped_comp_imp2 = 0 then null else ps.dt_ped_comp_imp2 end
      when 'A' then case when ps.dt_prev_ent2_produto = 0 then null else ps.dt_prev_ent2_produto end
    end as 'Dt_Prev_Entrada2',

    --Qtd_Prev_Entrada2    
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then isnull(ps.qt_prev_ent2_produto,0)
      when 'I' then isnull(ps.qt_ped_comp_imp2,0)
      when 'A' then isnull(ps.qt_prev_ent2_produto,0)
    end as 'Qtd_Prev_Entrada2',

    --Dt_Prev_Entrada3
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then case when ps.dt_prev_ent3_produto = 0 then null else ps.dt_prev_ent3_produto end
      when 'I' then case when ps.dt_ped_comp_imp3 = 0 then null else ps.dt_ped_comp_imp3 end
      when 'A' then case when ps.dt_prev_ent3_produto = 0 then null else ps.dt_prev_ent3_produto end
    end as 'Dt_Prev_Entrada3',

    --Qtd_Prev_Entrada3    
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then isnull(ps.qt_prev_ent3_produto,0)
      when 'I' then isnull(ps.qt_ped_comp_imp3,0)
      when 'A' then isnull(ps.qt_prev_ent3_produto,0)
    end as 'Qtd_Prev_Entrada3',

		--Saldo_Disponivel --Controle de nulo implementado no dia 20.12.2005 - Fabio
    IsNull(ps.qt_saldo_reserva_produto, 0.00)        as 'Saldo_Disponivel',

		--Saldo_Atual --Controle de nulo implementado no dia 20.12.2005 - Fabio
    isNull(ps.qt_saldo_atual_produto,0.00)          as 'Saldo_Atual',

    --Qtd_Requisitada       
    isnull(ps.qt_req_compra_produto,0) + 
      ( case 
          when ( @cd_fase_produto_entreposto <> 0 ) and ( @cd_fase_produto_entreposto <> @cd_fase_produto) then
            isnull(pse.qt_req_compra_produto,0)
          else
            0
        end ) as 'Qtd_Requisitada',

    --Qtd_Comprada
    isnull(ps.qt_pd_compra_produto,0)+
    isnull(ps.qt_importacao_produto,0) +

    --Entreposto
    ( case 
          when ( @cd_fase_produto_entreposto <> 0 ) and ( @cd_fase_produto_entreposto <> @cd_fase_produto) then
            isnull(pse.qt_pd_compra_produto,0)
          else
            0
        end ) + 
    ( case 
          when ( @cd_fase_produto_entreposto <> 0 ) and ( @cd_fase_produto_entreposto <> @cd_fase_produto) then
            isnull(pse.qt_importacao_produto,0)
          else
            0
        end ) as 'Qtd_Comprada',

    ps.qt_maximo_produto               as 'Qtd_Maximo',

    isnull(ps.qt_pd_compra_produto,0)+
    isnull(ps.qt_importacao_produto,0)+
    ( case 
          when ( @cd_fase_produto_entreposto <> 0 ) and ( @cd_fase_produto_entreposto <> @cd_fase_produto) then
            isnull(pse.qt_pd_compra_produto,0)
          else
            0
        end ) + 
    ( case 
          when ( @cd_fase_produto_entreposto <> 0 ) and ( @cd_fase_produto_entreposto <> @cd_fase_produto) then
            isnull(pse.qt_importacao_produto,0)
          else
            0
        end ) as 'Qtd_Prevista_PC',

    ps.qt_padrao_lote_compra           as 'Qtd_Lote_Compra',
    ps.qt_padrao_compra                as 'Qtd_Padrao_Compra',
    ps.vl_custo_contabil_produto,
    ps.vl_fob_produto,
    ps.vl_fob_convertido,

          cast(0 as float) as 'JANEIRO',
	  cast(0 as float) as 'FEVEREIRO',           
	  cast(0 as float) as 'MARCO',               
	  cast(0 as float) as 'ABRIL',               
	  cast(0 as float) as 'MAIO',                
	  cast(0 as float) as 'JUNHO',               
	  cast(0 as float) as 'JULHO',               
	  cast(0 as float) as 'AGOSTO',              
	  cast(0 as float) as 'SETEMBRO',            
	  cast(0 as float) as 'OUTUBRO',             
          cast(0 as float) as 'NOVEMBRO',            
          cast(0 as float) as 'DEZEMBRO',            

    -- Custo Unitário
    dbo.fn_vl_custo_unitario_produto( p.cd_produto ) as 'vlr_custo_unit',
    cast(0 as float) as 'Vlr_Custo_Total',

    -- Estes campos serão Calculados logo abaixo
    cast(0 as int)         as 'MesesComConsumo',  -- Feito
    cast('' as varchar(5)) as 'Frequencia', -- Feito
    cast(0 as float)       as 'X_Trim', -- Feito            
    cast(0 as float)       as 'X_Anual', -- Feito
    cast(0 as float)       as 'qtd_est_compra', -- Feito

	  Pais.cd_pais as 'cd_pais_origem',
	  Pais.nm_pais as 'Origem',

    -- Data da última Venda
  	(Select top 1
       ns.dt_nota_saida
     from
       nota_saida ns with (nolock)
       inner join nota_saida_item nsi with (nolock)
         on nsi.cd_nota_saida = ns.cd_nota_saida
       inner join Operacao_Fiscal op with (nolock)
         on ns.cd_operacao_fiscal = op.cd_operacao_fiscal 
     where
       op.cd_tipo_movimento_estoque = 11 and
       op.ic_comercial_operacao = 'S' and
       nsi.cd_produto = p.cd_produto
     order by
       ns.dt_nota_saida desc) as 'Ultima_Venda',

    -- Nome do Fornecedor
    case when (@cd_tipo_destinatario = 2)
      then
        @nm_fantasia_destinatario
      else
        (case ( select count(*)
                from Fornecedor_Produto fp with (nolock)
                where fp.cd_produto = p.cd_produto )
           when 0 then ''
           when 1 then ( select f.nm_fantasia_fornecedor
                         from Fornecedor f with (nolock) 
                          inner join  Fornecedor_Produto fp with (nolock)
                           on fp.cd_produto = p.cd_produto and
                              f.cd_fornecedor = fp.cd_fornecedor )
            else'Vários'
         end)
    end as 'Fornecedor',

     -- Campos utilizados na Cálculo baseado em Carteira de Pedidos
     cast(0 as float) as 'Carteira',
     cast(0 as float) as 'PrevCompra',
     cast(0 as float) as 'PrevImportacao',
     cast(0 as float) as 'TotalCompra',
     IsNull((select Sum(pii.qt_saldo_item_ped_imp)
             from pedido_importacao_item pii with (nolock)
             where pii.cd_produto = p.cd_produto and
                   pii.qt_saldo_item_ped_imp > 0 and
                   pii.dt_cancel_item_ped_imp is null
             group by pii.cd_produto),0) as 'Qtd_Pedido_Imp',
     isNull(ps.qt_req_compra_produto,0) + 
     IsNull((select Sum(rci.qt_item_requisicao_compra)
             from requisicao_compra_item rci with (nolock)
             left outer join pedido_importacao_item piii with (nolock) 
               on rci.cd_requisicao_compra = piii.cd_requisicao_compra and
                  rci.cd_item_requisicao_compra = piii.cd_item_requisicao_compra and
                  piii.dt_cancel_item_ped_imp is null
             where rci.cd_produto = p.cd_produto
             Group by rci.cd_produto),0) as 'Qtd_Req_Total'
  Into
    EVOLUCAO_CONSUMO

  From ------------------------------------------------------------------------- FROM
    #Selecao_Inicial

    inner join Produto p
      on p.cd_produto = #Selecao_Inicial.cd_chave_produto

    left outer join Unidade_Medida um
      on um.cd_unidade_medida = p.cd_unidade_medida

    left outer join Grupo_Produto gp
      on gp.cd_grupo_produto = p.cd_grupo_produto

    left outer join Produto_Saldo ps
      on ps.cd_produto = p.cd_produto and
         ps.cd_fase_produto = @cd_fase_produto

    left outer join Produto_Saldo pse
      on pse.cd_produto = p.cd_produto and
         pse.cd_fase_produto = @cd_fase_produto_entreposto

    left outer join  Pais
      on Pais.cd_pais = p.cd_origem_produto

  Where ------------------------------------------------------------------ WHERE

  --------------------------------------------------------------------------------------
  -- ATENÇÃO!!!!!! Nunca filtre a tabela Produto neste "where". Use o SQL dinâmico que
  -- gera a tabela temporária "#Selecao_Inicial". Senão o SQL Server não utilizará
  -- a chave primária do Produto, o que tornará a Consulta MUUUUIIITO lenta.
  ---------------------------------------------------------------------------------------
    (( @ic_carteira_pedidos = 'N' ) or ( isnull(ps.qt_saldo_reserva_produto,0) < 0 ))

	---------------------------------------------------
	-- Apagar a tabela temporária com a seleção inicial 
	---------------------------------------------------
  drop table #Selecao_Inicial

  ---------------------------------------------------
  -- Criar um índice para agilizar os Updates logo abaixo
  ---------------------------------------------------
  Create Index IX_Evolucao_Consumo on EVOLUCAO_CONSUMO (cd_produto)

  -----------------------------------------------------
  -- Calcular as Datas
  -----------------------------------------------------
  SET DATEFORMAT ymd

  -- Definir a data Inicial para o cálculo Trimestral
  set @dt_inicial_trimestral = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)
  set @dt_inicial_trimestral = dateadd( mm , -3, @dt_inicial_trimestral )

  print 'Dt. Inicial Calc. Trim.'
  print @dt_inicial_trimestral

  -- Data Final do Período Trimestral
  set @dt_final_trimestral = dateadd( ss , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )

  print 'Dt. Final Calc. Trim.'
  print @dt_final_trimestral

  -- Data Inicial do Período
  set @dt_inicial = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)
  set @dt_inicial = dateadd( mm , - (@qt_mes), @dt_inicial )

  print 'Dt. Inicial'
  print @dt_inicial

  -- Data Final do Período
  set @dt_final = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)

  -- Acrescentar um mês se estiver definido para mostrar o mês atual
  if @ic_mostrar_mes_atual = 'S'
  begin
    set @dt_final = dateadd( mm , 1, @dt_final )
  end

  print 'Mostrar mês atual'
  print @ic_mostrar_mes_atual

  set @dt_final = dateadd( ss , -1, @dt_final )

  print 'Dt. Final'
  print @dt_final

  --===============================================================
  -- Evolução de Consumo Baseada na Carteira de Pedidos
  --===============================================================
  if ( @ic_carteira_pedidos = 'S' )
  begin

    --------------------------------------------------
    -- Acumula os Pedidos de Venda em Aberto
    --------------------------------------------------
    set @cSQL = 
    'update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    ' set Carteira = Carteira + pedvenda.Qtde
    from '
      + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO , 
        ( select
            cd_produto,
            isnull( sum( qt_saldo_pedido_venda ), 0 ) as Qtde
          from
            pedido_venda_item with (nolock)
          where
            qt_saldo_pedido_venda > 0
            and
            dt_cancelamento_item is null
            and
            isnull(ic_sel_fechamento,''N'') = ''S'' 
          group by
            cd_produto

        ) pedvenda
    where
      EVOLUCAO_CONSUMO.cd_produto = pedvenda.cd_produto '

    exec(@cSQL)

    

    --------------------------------------------------
    -- Acumula os Pedidos de Compra
    --------------------------------------------------
    set @cSQL = 
    'update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    '  set PrevCompra = PrevCompra + pedcompra.Qtde,
          TotalCompra = TotalCompra + pedcompra.Qtde
    from ' + 
      @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO, ' + 
'        ( select
            cd_produto,
            isnull( sum( qt_saldo_item_ped_compra ), 0 ) as Qtde
          from
            pedido_compra_item with (nolock)
          where
            qt_saldo_item_ped_compra > 0
            and
            dt_item_canc_ped_compra is null
          group by
            cd_produto

        ) pedcompra
    where
      EVOLUCAO_CONSUMO.cd_produto = pedcompra.cd_produto '

    exec(@cSQL)

    --------------------------------------------------
    -- Acumula os Pedidos de Importação
    --------------------------------------------------
    set @cSQL = 
    'update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    ' set PrevImportacao = PrevImportacao + pedimp.Qtde,
          TotalCompra = TotalCompra + pedimp.Qtde
    from ' + 
    @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO, ' + 
    '    ( select
            cd_produto,
            isnull( sum( qt_saldo_item_ped_imp ), 0 ) as Qtde
          from
            pedido_importacao_item with (nolock)
          where
            qt_saldo_item_ped_imp > 0
            and
            dt_cancel_item_ped_imp is null
          group by
            cd_produto

        ) pedimp
    where
      EVOLUCAO_CONSUMO.cd_produto = pedimp.cd_produto '

   exec(@cSQL)


    -- Excluir os Produtos que não tiveram Movimentação

    if ( @ic_sem_movimentacao = 'N' )
    begin
      set @cSQL = ' Delete From ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO where ( PrevCompra = 0 ) and ( PrevImportacao = 0 ) '
      exec(@cSQL)
    end

  end

  --===============================================================
  -- Evolução de Consumo Baseada na Movimentação do Estoque
  --===============================================================
  declare @dt_inicial_movimentacao datetime,
          @dt_final_movimentacao   datetime

  set @cont = 0

  -- define o mês inicial
  set @cd_ano = year(@dt_inicial)
  set @cd_mes = month(@dt_inicial)

  -- Acrescentar um mês se estiver definido para mostrar o mês atual
  if @ic_mostrar_mes_atual = 'S'
  begin
    set @qt_mes = @qt_mes + 1
  end

  -- Fazer um Loop calculando todos os meses do Período
  while @cont < @qt_mes
  begin

    if @cd_mes > 12
    begin
      set @cd_ano = @cd_ano + 1
      set @cd_mes = 1
    end      

    -- Data Inicial
    set @dt_inicial_movimentacao = cast( cast(@cd_ano as varchar) + '-' +
                            cast(@cd_mes as varchar) + '-' +
                            '01' as datetime )
    -- Data Final
    set @dt_final_movimentacao = dateadd( mm, 1, @dt_inicial_movimentacao )
    set @dt_final_movimentacao = dateadd( ss, -1, @dt_final_movimentacao )

    print 'Período de Movimentação:'
    print 'Inicial:'
    print @dt_inicial_movimentacao
    print 'Final:'
    print @dt_final_movimentacao

    -- Obs: Uso a Data Final acrescentado em um dia pois no campo da tabela de Movimentação
    -- é gravada também a hora.  Logo abaixo, no momento de filtrar pelo período
    -- filtro por datas menores "<"  que esta Data Final


    --------------------------------------------------
    -- Acumula as Saídas do mês
    --------------------------------------------------
    set @cSql = 
    ' update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    '  set X_Anual = X_Anual + mov.Qtde, ' + 
         ' X_Trim = X_Trim + mov.QtdeTrim, ' + 

         ' Janeiro = Janeiro + ( case when ' + cast( @cd_mes as varchar) + ' = 1 then mov.Qtde else 0 end ), ' +
         ' Fevereiro = Fevereiro + ( case when ' + cast( @cd_mes as varchar) + ' = 2 then mov.Qtde else 0 end ), ' + 
         ' Marco = Marco + ( case when ' + cast( @cd_mes as varchar) + ' = 3 then mov.Qtde else 0 end ), ' + 
         ' Abril = Abril + ( case when ' + cast( @cd_mes as varchar) + ' = 4 then mov.Qtde else 0 end ), ' + 
         ' Maio = Maio + ( case when ' + cast( @cd_mes as varchar) + ' = 5 then mov.Qtde else 0 end ), ' + 
         ' Junho = Junho + ( case when ' + cast( @cd_mes as varchar) + ' = 6 then mov.Qtde else 0 end ), ' + 
         ' Julho = Julho + ( case when ' + cast( @cd_mes as varchar) + ' = 7 then mov.Qtde else 0 end ), ' + 
         ' Agosto = Agosto + ( case when ' + cast( @cd_mes as varchar) + ' = 8 then mov.Qtde else 0 end ), ' + 
         ' Setembro = Setembro + ( case when ' + cast( @cd_mes as varchar) + ' = 9 then mov.Qtde else 0 end ), ' + 
         ' Outubro = Outubro + ( case when ' + cast( @cd_mes as varchar) + ' = 10 then mov.Qtde else 0 end ), ' + 
         ' Novembro = Novembro + ( case when ' + cast( @cd_mes as varchar) + ' = 11 then mov.Qtde else 0 end ), ' + 
         ' Dezembro = Dezembro + ( case when ' + cast( @cd_mes as varchar) + ' = 12 then mov.Qtde else 0 end ) ' + 
   ' from ' + 
     @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO, ' + 
   '    ( select ' + 
        '    cd_produto, ' + 
        '    isnull( sum( movProduto.QtdeProduto ), 0 ) as Qtde, ' +
        '    isnull( sum( movProduto.QtdeTrimProduto ), 0 ) as QtdeTrim ' + 
        '  from ' + 
        '    ( select ' + 
        '        me.cd_produto, ' + 
        '        isnull( me.qt_movimento_estoque, 0 ) as QtdeProduto, ' + 

--        '        ( case when ( me.dt_movimento_estoque between ' + QuoteName(cast(@dt_inicial_movimentacao as varchar(40)), '''') + ' and ' + QuoteName(cast(@dt_final_trimestral as varchar(40)), '''') + ' ) ' + 
--Carlos 20.01.2005
        '        ( case when ( me.dt_movimento_estoque between ' + QuoteName(cast(@dt_inicial_trimestral as varchar(40)), '''') + ' and ' + QuoteName(cast(@dt_final_trimestral as varchar(40)), '''') + ' ) ' + 
        '            then isnull( me.qt_movimento_estoque, 0 ) ' + 
        '            else 0 ' + 
        '          end ) as QtdeTrimProduto ' + 
        '      from ' + 
        '        Movimento_Estoque me with (nolock) ' + 
        
        '        left outer join Tipo_Movimento_Estoque tme with (nolock) ' + 
        '          on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque ' +
        '      where ' + 
        '        ( me.cd_fase_produto = ' + cast(@cd_fase_produto as varchar) + ') and ' + 
        '        ( me.dt_movimento_estoque >= ' + QuoteName(cast(@dt_inicial_movimentacao as varchar(40)), '''') + ' ) and ' + 
        '        ( me.dt_movimento_estoque <= ' + QuoteName(cast(@dt_final_movimentacao as varchar(40)), '''') + ' ) ' + 
        '        and ' +
        '        ( tme.ic_mov_tipo_movimento = ' + QuoteName(cast(@cd_tipo_operacao_fiscal as varchar),'''') + ') and ' + 
        '        ( isnull(tme.ic_consumo_tipo_movimento,''S'') = ''S'' ) and ' + 
        '  		  ( tme.ic_operacao_movto_estoque in (''R'',''A'') ) ' -- Movimenta o Real ou Ambos    

    if @nm_fantasia_destinatario <> ''
      set @cSql = @cSql + 
        ' and (( me.cd_tipo_destinatario = ' + cast(@cd_tipo_destinatario as varchar) + ') and ' +
        '      ( me.nm_destinatario = ' +     QuoteName(@nm_fantasia_destinatario,'''') + ')) ' 

    set @cSql = @cSql + 
        '    ) movProduto ' + 
        ' group by ' + 
        '   movProduto.cd_produto ' + 

        ' ) mov ' + 
    ' where ' + 
    '  EVOLUCAO_CONSUMO.cd_produto = mov.cd_produto ' 

    print(@cSQL)
    exec(@cSQL)

    if ( @cd_tipo_operacao_fiscal = 'S' ) -- Só ser for Evolução das Saídas
    begin

      --------------------------------------------------
      -- Subtrai as Devoluções do mês
      --------------------------------------------------
    set @cSql = 
    ' update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    '   set X_Anual = X_Anual + mov.Qtde, ' + 
          ' X_Trim = X_Trim + mov.QtdeTrim, ' + 
  
          ' Janeiro = Janeiro + ( case when ' + cast( @cd_mes as varchar) + ' = 1 then mov.Qtde else 0 end ), ' + 
          ' Fevereiro = Fevereiro + ( case when ' + cast( @cd_mes as varchar) + ' = 2 then mov.Qtde else 0 end ), ' + 
          ' Marco = Marco + ( case when ' + cast( @cd_mes as varchar) + ' = 3 then mov.Qtde else 0 end ), ' + 
          ' Abril = Abril + ( case when ' + cast( @cd_mes as varchar) + ' = 4 then mov.Qtde else 0 end ), ' + 
          ' Maio = Maio + ( case when ' + cast( @cd_mes as varchar) + ' = 5 then mov.Qtde else 0 end ), ' + 
          ' Junho = Junho + ( case when ' + cast( @cd_mes as varchar) + ' = 6 then mov.Qtde else 0 end ), ' + 
          ' Julho = Julho + ( case when ' + cast( @cd_mes as varchar) + ' = 7 then mov.Qtde else 0 end ), ' + 
          ' Agosto = Agosto + ( case when ' + cast( @cd_mes as varchar) + ' = 8 then mov.Qtde else 0 end ), ' + 
          ' Setembro = Setembro + ( case when ' + cast( @cd_mes as varchar) + ' = 9 then mov.Qtde else 0 end ), ' + 
          ' Outubro = Outubro + ( case when ' + cast( @cd_mes as varchar) + ' = 10 then mov.Qtde else 0 end ), ' + 
          ' Novembro = Novembro + ( case when ' + cast( @cd_mes as varchar) + ' = 11 then mov.Qtde else 0 end ), ' + 
          ' Dezembro = Dezembro + ( case when ' + cast( @cd_mes as varchar) + ' = 12 then mov.Qtde else 0 end ) ' + 
     ' from ' 
     + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
       ' EVOLUCAO_CONSUMO, ' + 
         ' ( select ' + 
            ' cd_produto, ' + 
            ' isnull( sum( movProduto.QtdeProduto ), 0 ) as Qtde, ' + 
            ' isnull( sum( movProduto.QtdeTrimProduto ), 0 ) as QtdeTrim ' + 
            ' from ' + 
            '  ( ' + 
               ' select ' + 
               '  me.cd_movimento_estoque, ' + 
               '  me.dt_movimento_estoque, ' + 
  
               '  meCancDev.cd_produto, ' + 
               '  isnull( meCancDev.qt_movimento_estoque, 0 ) * ( case when meCancDev.cd_tipo_movimento_estoque = 13 then 1 else -1 end ) as QtdeProduto, ' + 

--               '  ( case when ( me.dt_movimento_estoque between ' + QuoteName(cast(@dt_inicial_movimentacao as varchar(40)), '''') + ' and ' + QuoteName(cast(@dt_final_trimestral as varchar(40)), '''') + ' ) ' + 
--Carlos 20.01.2005
               '  ( case when ( me.dt_movimento_estoque between ' + QuoteName(cast(@dt_inicial_trimestral as varchar(40)), '''') + ' and ' + QuoteName(cast(@dt_final_trimestral as varchar(40)), '''') + ' ) ' + 
               '      then isnull( meCancDev.qt_movimento_estoque, 0 ) ' + 
               '      else 0 ' + 
               '    end ) * ( case when meCancDev.cd_tipo_movimento_estoque = 13 then 1 else -1 end ) as QtdeTrimProduto ' + 
               ' from ' + 
               '  Movimento_Estoque me with (nolock) ' + 
         
               '  inner join Tipo_Movimento_Estoque tme with (nolock) ' + 
               '    on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque ' + 
  
               '  inner join Movimento_Estoque meCancDev with (nolock) ' + 
               '     on ( meCancDev.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque ) and ' + 
               '       ( meCancDev.cd_documento_movimento = me.cd_documento_movimento ) and ' + 
               '        ( meCancDev.cd_item_documento = me.cd_item_documento ) and ' + 
               '        ( meCancDev.cd_produto = me.cd_produto ) and ' + 
               '        ( meCancDev.cd_fase_produto = me.cd_fase_produto ) and ' + 
               '        ( meCancDev.cd_tipo_movimento_estoque in (10,12,13)) and ' + -- Devolução, Ativação e Cancelamento
               '        ( meCancDev.cd_movimento_estoque > me.cd_movimento_estoque ) ' + 
               ' where ' + 
               '  ( me.cd_fase_produto = ' + cast(@cd_fase_produto as varchar) + ') and ' + 
               '  ( me.dt_movimento_estoque >= ' + QuoteName(cast(@dt_inicial_movimentacao as varchar(40)), '''') + ' ) and ' + 
               '  ( me.dt_movimento_estoque <= ' + QuoteName(cast(@dt_final_movimentacao as varchar(40)), '''') + ' ) ' + 
               '  and ' + 
               '  ( tme.ic_mov_tipo_movimento = ' + QuoteName(cast(@cd_tipo_operacao_fiscal as varchar),'''') + ') and ' + 
               '  ( isnull(tme.ic_consumo_tipo_movimento,''S'') = ''S'' ) and ' + 
            	 ' ( tme.ic_operacao_movto_estoque in (''R'',''A'') ) ' -- Movimenta o Real ou Ambos    

     if @nm_fantasia_destinatario <> ''
       set @cSql = @cSql + 
               ' and (( me.cd_tipo_destinatario = ' + cast(@cd_tipo_destinatario as varchar) + ') and ' + 
               ' ( me.nm_destinatario = ' +     QuoteName(@nm_fantasia_destinatario,'''') +')) ' 

     set @cSql = @cSql +  
             ' ) movProduto ' + 
          ' group by ' + 
          '   movProduto.cd_produto ' + 
          ' ) mov ' + 
     ' where ' + 
     '   EVOLUCAO_CONSUMO.cd_produto = mov.cd_produto ' 

     exec(@cSQl)

    end -- if
  

    -- Próximo mês
    set @cd_mes = @cd_mes + 1
    set @cont = @cont + 1

  end -- while

  -- Calcular os Meses que tiveram Consumo e a Frequência.
  -- Calcular a Quantidade à Comprar 

  set @cSql = 
   ' declare @Consumo int, ' + 
         ' @Saldo float, ' + 
         ' @QtdComprar float, ' + 
         ' @Trimestral float '  

  set @cSql = @cSql + 
    ' update ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO ' + 
    ' set @Consumo = ' + 
         ' (case when ( Janeiro > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Fevereiro > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Marco > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Abril > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Maio > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Junho > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Julho > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Agosto > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Setembro > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Outubro > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Novembro > 0 ) then 1 else 0 end) + ' + 
         ' (case when ( Dezembro > 0 ) then 1 else 0 end), ' + 
    ' MesesComConsumo = @Consumo, ' + 
    ' Frequencia = cast(@Consumo as varchar) + ''/'' + cast( ' + cast(@qt_mes as varchar ) + ' as varchar), ' + 
     -- Média Trimestral
    ' @Trimestral = cast( X_Trim / 3 as int ), ' + 
    ' X_Trim = @Trimestral, ' + 

     -- Saldo em Estoque
    ' @Saldo = isnull( (case when ( Saldo_Disponivel > Saldo_Atual ) then Saldo_Disponivel else Saldo_Atual end), 0), ' + 

    -- ELIAS 19/12/2005 - Cálcula a Quantidade a Comprar de acordo com o Parâmetro de Estoque
    case (select IsNull(ic_previsao_evolucao_consumo,'C') from parametro_estoque where cd_empresa = dbo.fn_empresa()) 
      when 'C' then ' @QtdComprar = ( @Trimestral * qt_evolucao_produto ) - ' + 
                    '   ( @Saldo + IsNull(qt_saldo_entreposto,0) + Qtd_Prev_Entrada1 + Qtd_Prev_Entrada2 + Qtd_Prev_Entrada3 + Qtd_Requisitada + Qtd_Comprada ), '                     
			--Adição de "IsNull" para os casos dos campos estarem nulos - Fabio 20.12.2005
      when 'I' then ' @QtdComprar = case when IsNull(qt_saldo_entreposto,0) + (IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0)) <= 0 '+
                                    'then ( IsNull(@Trimestral,0) * IsNull(qt_evolucao_produto,0) ) - ' + 
                                         '( IsNull(@Saldo,0) + IsNull(qt_saldo_entreposto,0) + IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0) + IsNull(Qtd_Requisitada,0) + IsNull(Qtd_Comprada,0) ) '+
                                    'else ( @Trimestral * IsNull(qt_evolucao_produto,0) ) - ' + 
                                         '( IsNull(@Saldo,0) + IsNull(qt_saldo_entreposto,0) + IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0) + IsNull(Qtd_Requisitada,0) )'+
                                    'end, '
      --09.01.2006 - Foi implementada a mesma lógica de importação para os casos de "Ambos" - Fabio Cesar
      when 'A' then ' @QtdComprar = case when IsNull(qt_saldo_entreposto,0) + (IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0)) <= 0 '+
                                    'then ( IsNull(@Trimestral,0) * IsNull(qt_evolucao_produto,0) ) - ' + 
                                         '( IsNull(@Saldo,0) + IsNull(qt_saldo_entreposto,0)+ IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0) + IsNull(Qtd_Requisitada,0) + IsNull(Qtd_Comprada,0) ) '+
                                    'else ( @Trimestral * IsNull(qt_evolucao_produto,0) ) - ' + 
                                         '( IsNull(@Saldo,0) + IsNull(qt_saldo_entreposto,0)+ IsNull(Qtd_Prev_Entrada1,0) + IsNull(Qtd_Prev_Entrada2,0) + IsNull(Qtd_Prev_Entrada3,0) + IsNull(Qtd_Requisitada,0) ) '+
                                    'end, '
    end +

    --' @QtdComprar = ( @Trimestral * qt_evolucao_produto ) - ' + 
    --'   ( @Saldo + Qtd_Prev_Entrada1 + Qtd_Prev_Entrada2 + Qtd_Prev_Entrada3 + Qtd_Requisitada + Qtd_Comprada ), ' + 

     -- Sugestão de Compra 
    ' qtd_est_compra = ' + 
      ' case when ( ' + QuoteName(@ic_carteira_pedidos,'''') + ' = ''N'' ) ' + 
        ' then ' + 
         ' (case when ( @QtdComprar < 0 ) then 0 else @QtdComprar end) ' + 
        ' else ' + 
          ' (case when ( abs(Saldo_Disponivel) > TotalCompra ) then abs(Saldo_Disponivel) - TotalCompra else 0 end) ' + 
      ' end ' 

  exec(@cSql)

  -- Excluir os Produtos que não tiveram Movimentação
  if ( @ic_sem_movimentacao = 'N' ) and ( @ic_carteira_pedidos = 'N' )
  begin
    set @cSQL = ' Delete From ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO where ( MesesComConsumo = 0 ) '
    exec(@cSQL)
  end
  
  -- Selecionar os Registros
  if IsNull(@nm_fantasia_produto,'') <> ''
  begin
    set @cSQL = ' Select * From ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO Order by nm_fantasia_produto'
    exec(@cSQL)
  end
  else
  begin
    set @cSQL = ' Select * From ' + @nm_usuario_logado + '.' + 'EVOLUCAO_CONSUMO Order by cd_mascara_produto, nm_fantasia_produto '
    exec(@cSQL)
  end

end



