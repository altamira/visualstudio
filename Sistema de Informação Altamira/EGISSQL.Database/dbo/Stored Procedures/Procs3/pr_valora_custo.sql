
----------------------------------------------------------------------------------
--pr_valora_custo
----------------------------------------------------------------------------------
--Global Business Solution Ltda                                               2004
----------------------------------------------------------------------------------
--Stored Procedure     : SQL Server Microsoft 2000
--Autor (es)           : Carlos Cardoso Fernandes         
--Banco Dados          : EGISSQL
--Objetivo             : Cálculo do Peps - Valoração do Estoque
--Data                 : 02.05.2001
--Atualizado           : 10.07.2001
--                     : 12.02.2003 
--                     : 01.07.2003 - Reestruturação da SP. Parametro cd_grupo_produto não era usado. 
--                     : 05.08.2003 - Otimização no Desempenho da SP. (DUELA)
--                                  - Acerto na Fase de Produto Default
--                     : 07.08.2003 - Validação na Unidade de Medida (DUELA)
--		       : 11.08.2003 - Utilização do Item de NF para filtro (Ludinei)
--                     : 18.08.2003 - Validação conforme Parametro_Custo 
--                                  - ´F´- Valoração pelo Saldo Final do Fechamento
-- 		       : 24/09/2003 - Daniel C. Neto. - Implantação dos parâmetros de Consistência.
--                     : 20/10/2003 - Implementação de Cursor para otimizar processamento (por Grupo) - ELIAS
--                     : 04/11/2003 - Implementação do Filtro por Fase do Produto - DUELA
--                     : 12/11/2003 - Ajustes para quando o fornecedor for 0 (zero) - Danilo
--                     : 03/03/2004 - Acerto no Order by para que na listagem apareça sempre 
--                                    ordenado por grupo principalmente - ELIAS
--                     : 16/04/2004 - Filtrando o update da tabela Produto_Fechamento para atualizar somente
--                                    o registro referentes a data de fechamento, anteriormente estava
--                                    atualizando toda a tabela e causando grande demora :-( - ELIAS
--                     : 28/04/2004 - Corrigido atualização do custo do produto na tabela Produto_fechamento que
--                                    anteriormente atualizava o produto com o último custo e não o custo total - ELIAS
--                     : 02/07/2004 - Arredandado as quantidades para até 4 casas decimais para evitar erro de 
--                                    valoração de saldo, que ocorria devido a subtração da qtde atual - qtde valorada,
--                                    dois campos tipo float - ELIAS
--                     : 30/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 04/02/2005 - Gravacao na tabela fechamento do atributo : qt_peps_prod_fechamento
--                     : 01.08.2005 - Fase do Produto
--                                  - Checagem da Unidade de Valoração
--                                  - Verificarção do Parametro_Custo para mostrar o Peso do Bruto - Carlos Fernandes
--                                  - 
--                     : 10.08.2005 - Cálculo do Peps por Peso / Checagem do Grupo de Valoração - Carlos Fernandes
--                     : 22/09/2005 - Passa a utilizar o Grupo de Valoração como filtro - ELIAS
--                     : 05/10/2005 - Acertos em toda a procedure para Otimização e performace - ELIAS
--                     : 10/10/2005 - Passa a se chamar pr_valora_custo, antiga pr_custo_peps - ELIAS
--                     : 26/10/2005 - Ajuste na ordem de processamento das NFs PEPS que estavam divergindo entre
--                                    Duas NFs de uma mesma Data - ELIAS
--                     : 03/11/2005 - Valoração do 1 1/2 Custo ( ESPECIAL ) - ELIAS
--                     : 25/11/2005 - Valoração do 70% do Preço de Venda ( ESPECIAL ) - ELIAS 
--                     : 01/12/2005 - Desenvolvimento da Pesquisa de Composição de Compra do PVE para Valoração de
--                                    1x1/2 e 70% - ELIAS
--                     : 20/12/2005 - Ajuste na Rotina PEPS para Apresentar Produtos com Saldo, mesmo sem nenhuma NFE - ELIAS
--                     : 10/01/2006 - Ajuste para buscar os Pesos e Custos Totais proporcionais as quantidades dos PVEs
--                                    em aberto na Listagem dos Especiais de 1/2 e 70%. - ELIAS
--                     : 13/01/2006 - Ajuste de arredondamento para fechar com o Registro de Inventário - ELIAS
--                     : 30/01/2006 - Ajuste para listagem correta de PVEs cancelados após o Período Final - ELIAS
----------------------------------------------------------------------------------------------------------------------
create procedure pr_valora_custo
@ic_parametro              int,         --Parâmetros
@dt_inicial                datetime,
@dt_final                  datetime,
@cd_produto                int,
@cd_grupo_inicial          int,
@cd_grupo_final            int,
@cd_fase_produto           int,
@ic_filtro_divergencia     char(1) = 'N',
@ic_resumo_grupo           char(1) = 'N',
@ic_resumo_fase            char(1) = 'N',
@ic_atualiza_custo         char(1) = 'S',
@cd_pedido_venda           int = 0,
@cd_item_pedido_venda      int = 0

as


SET LOCK_TIMEOUT 25000

-- NECESSÁRIO PARA DEBUGAÇÃO
declare @ic_debug char(1)
set @ic_debug = 'N'

if @ic_debug = 'N'
  SET NOCOUNT ON
else
  SET NOCOUNT OFF

-- Não adianta colocar os valores Default, se a procedure
-- for rodada do dentro do Egis sem passar os valores, os 
-- parâmetros continuarão vindo Nulos

set @ic_filtro_divergencia = isnull(@ic_filtro_divergencia,'N')
set @ic_resumo_grupo       = isnull(@ic_resumo_grupo,'N')
set @ic_resumo_fase        = isnull(@ic_resumo_fase,'N')

if (isnull(@ic_atualiza_custo,'') = '')
  set @ic_atualiza_custo = 'S'

--Definicao de Variáveis para Processamento

declare @mm_calculo          int
declare @aa_calculo          int
declare @cd_fase             int
declare @nm_aux_mes          char(2)
declare @qt_saldo_produto    float  
declare @cmdsql              varchar(255)
declare @cd_nota_fiscal      varchar(100)
declare @cd_item_nota_fiscal float -- Ludinei (11/08)
declare @qt_nota_fiscal      float
declare @qt_peso_nota_fiscal float
declare @qt_peps_aux         float
declare @qt_peps             float
declare @vl_custo_peps       decimal(25,2)
declare @cd_mascara_produto  varchar(20)
declare @ic_tipo_valoracao   char(1)
declare @qt_valorado_peps    float
declare @qt_itens_peps       decimal(25,4)
declare @dt_documento_peps   datetime
declare @fator               char(1) 
declare @ic_divergencia_saldo char(1)

declare @cd_seq_peps               float
declare @cd_produto_first          float
declare @cd_nota_fiscal_first      varchar(20)
declare @cd_item_nota_fiscal_first float
declare @qt_nota_fiscal_first      float
declare @qt_peso_nota_fiscal_first float
declare @qt_saldo_estoque          decimal(25,4)
declare @qt_registros              int

declare @ic_forma_ordenacao        char(1)
declare @ic_peso_peps              char(1) --Apresenta o Peso do produto no Cálculo do Peps
declare @vl_preco_entrada_peps_produto  float

declare @cd_fase_produto_comercial int
declare @cd_movimento_estoque int

declare @dt_custo datetime
declare @ic_movimento char(1)

set @ic_tipo_valoracao = 'F' 
set @mm_calculo        = month( @dt_final )
set @aa_calculo        = year ( @dt_final )
set @qt_peps_aux       = 0
set @vl_custo_peps     = 0
set @qt_valorado_peps  = 0
set @qt_itens_peps     = 0
set @qt_registros      = 0
set @vl_preco_entrada_peps_produto = 0

--Define a forma de exibição
select @ic_forma_ordenacao = IsNull(ic_exibicao_padrao_prod,'F') from Parametro_Custo with(nolock) where cd_empresa = dbo.fn_empresa()

--Define fase comercial a ser atualizada no custo contabil do produto
select top 1 @cd_fase_produto_comercial = cd_fase_produto from Parametro_Comercial with(nolock)where cd_empresa = dbo.fn_empresa()

if ( IsNull(@ic_forma_ordenacao,'') = '' )
  set @ic_forma_ordenacao = 'F'

create table #TEMP_PEPS (
  cd_movimento_estoque      int Null,
  cd_produto                int Null,
  cd_fornecedor             int Null,
  cd_documento_entrada_peps varchar(15) Null,
  cd_item_documento_entrada int Null,
  qt_entrada_peps           float Null,
  vl_preco_entrada_peps     float Null,
  vl_custo_total_peps       float null,
  qt_valorizacao_peps       float null,
  qt_valoracao_peps_peso    float null,  
  vl_custo_valorizacao_peps decimal(25,2) null,
  vl_fob_entrada_peps       float null,
  cd_usuario                int null,
  dt_usuario                datetime null,
  dt_documento_entrada_peps datetime null,
  cd_fase_produto           int null,
  cd_controle_nota_entrada  int null,
  dt_controle_nota_entrada  datetime null,
  unitario                  float null,
  fornecedor                varchar(40) null,
  grupoProduto              varchar(40) null,
  codigo                    varchar(15) null,
  produto                   varchar(30) null,
  descricao                 varchar(60) null,
  unidade                   varchar(2) null,
  qt_peso_entrada_peps      float null,
  ic_fator_valoracao        char(1) null,
  ic_divergencia_saldo      char(1) null)

-- Ludinei (27/10/2003) Ajustar a data final para entender até a ultima hora do dia.
set @dt_custo = @dt_final
set @dt_final = convert(datetime,left(convert(varchar,@dt_final,121),10)+' 23:59:00',121)

select @ic_tipo_valoracao = isnull(ic_parametro_peps_empresa,'F'),
       @ic_peso_peps      = isnull(ic_peso_peps,'N')
from Parametro_Custo with(nolock)
where
  cd_empresa = dbo.fn_empresa()

--Fase do Produto
select cd_fase_produto into #Fase_Temp
from Fase_Produto with(nolock)
where 
  cd_fase_produto = @cd_fase_produto or @cd_fase_produto = 0

-------------------------------------------------------------------------------
if @ic_parametro in (1,2) -- PROCESSAMENTO DO PEPS
-------------------------------------------------------------------------------
begin

  declare cProdutoPEPS cursor for
  -----------------------------------------------------------------------------
  -- CASO ESCOLHIDO SOMENTE O PRODUTO - @IC_PARAMETRO = 1
  -----------------------------------------------------------------------------
  select pf.cd_produto,
    p.cd_mascara_produto,
    pf.cd_fase_produto,
    isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0) as qt_saldo_produto
  from Produto_Fechamento pf with(nolock)
    inner join Metodo_Valoracao mv with(nolock) on pf.cd_metodo_valoracao    = mv.cd_metodo_valoracao     
    left outer join Produto p with(nolock)      on p.cd_produto              = pf.cd_produto
    left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto      = p.cd_grupo_produto
  where @ic_parametro = 1 and
    pf.dt_produto_fechamento between @dt_inicial and @dt_final and
    mv.ic_peps_metodo = 'S' and
    isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0) > 0 and
    pf.cd_produto = @cd_produto and
    -- Caso o usuário tenha informado uma fase específica, então a utilizar
    pf.cd_fase_produto = case when (@cd_fase_produto = 0) 
                         then pf.cd_fase_produto 
                         else @cd_fase_produto end 
  union
  -----------------------------------------------------------------------------
  -- CASO ESCOLHIDO UM RANGE DE GRUPOS - @IC_PARAMETRO = 2
  -----------------------------------------------------------------------------
  select pf.cd_produto,
    p.cd_mascara_produto, 
    pf.cd_fase_produto,
    isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0) as qt_saldo_produto
  from Produto_Fechamento pf with(nolock)
    inner join Metodo_Valoracao mv with(nolock) on pf.cd_metodo_valoracao    = mv.cd_metodo_valoracao     
    left outer join Produto p with(nolock)      on p.cd_produto              = pf.cd_produto
    left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto      = p.cd_grupo_produto
  where @ic_parametro = 2 and
    pf.dt_produto_fechamento between @dt_inicial and @dt_final and
    mv.ic_peps_metodo = 'S' and
    isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0) > 0 and
    p.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final and
    -- Caso o usuário tenha informado uma fase específica, então a utilizar
    pf.cd_fase_produto = case when (@cd_fase_produto = 0) 
                         then pf.cd_fase_produto 
                         else @cd_fase_produto end
  order by pf.cd_fase_produto, p.cd_mascara_produto
    
  open cProdutoPEPS
  
  fetch next from cProdutoPEPS into @cd_produto, @cd_mascara_produto, @cd_fase, @qt_saldo_produto

  while @@fetch_status = 0
  begin                      

    -- Inicialização das Variáveis
    set @qt_itens_peps             = 0
    set @qt_saldo_estoque          = 0
    set @cd_produto_first          = 0
    set @cd_nota_fiscal_first      = 0
    set @cd_item_nota_fiscal_first = 0
    set @qt_nota_fiscal_first      = 0
    set @qt_peso_nota_fiscal_first = 0
    set @qt_peps                   = 0
    set @qt_peps_aux               = 0

    if @ic_debug = 'S'
    begin
      print('Produto Processado');
      print('------------------'); 
      print('Produto: '+cast(@cd_produto as varchar)+' '+@cd_mascara_produto)
      print('Fase: '+cast(@cd_fase as varchar))
      print('Saldo: '+cast(@qt_saldo_produto as varchar))
    end
 
    -- Zera as Variáveis de Cálculo da Tabela de PEPS
    update Nota_Entrada_Peps
    set 
      qt_valorizacao_peps = 0,
      qt_valoracao_peps_peso = 0,
      vl_custo_valorizacao_peps = 0
    where cd_produto = @cd_produto and
      cd_fase_produto = @cd_fase

    -- Cria Tabela Temporária para Cálculo, baseada na própria tabela de PEPS
    select identity (int,1,1) as 'cd_seq_peps',
      nep.cd_produto,
      nep.cd_documento_entrada_peps,
      isnull(nep.qt_entrada_peps,0) as qt_entrada_peps, 
      case when (isnull(um.ic_fator_conversao,'P') = 'K') then
        isnull(nep.qt_peso_entrada_peps, (nep.qt_entrada_peps * isnull(p.qt_peso_bruto,0))) 
      else 
        0.0000 
      end as qt_peso_entrada_peps,
      isnull(nep.vl_custo_total_peps,0) as vl_custo_total_peps,
      nep.dt_documento_entrada_peps,
      nep.cd_movimento_estoque,
      isnull(nep.cd_item_documento_entrada,0) as 'cd_item_documento_aux', -- Ludinei 11/08
      isnull(um.ic_fator_conversao,'P')   as 'fator'
    into #Aux_peps
    from Nota_Entrada_Peps nep with(nolock)
      --left outer join Produto_Custo pc        on pc.cd_produto             = nep.cd_produto 
      left outer join Produto p with(nolock)        on p.cd_produto              = nep.cd_produto
      left outer join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto       = p.cd_grupo_produto
      left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto      = gp.cd_grupo_produto
      left outer join Unidade_Medida um with(nolock) on um.cd_unidade_medida      = gpc.cd_unidade_valoracao
     where nep.cd_produto = @cd_produto and
      nep.cd_fase_produto = @cd_fase and
      dt_documento_entrada_peps <= @dt_final --and
      --isnull(pc.ic_peps_produto,'S')='S'
    order by dt_documento_entrada_peps desc

    set @ic_divergencia_saldo = 'N'

    set @ic_movimento = 'N'

    while exists ( select top 1 * from #Aux_peps )
    begin

      set @ic_movimento = 'S'

      select top 1
        @cd_seq_peps          = cd_seq_peps,
        @cd_nota_fiscal       = cd_documento_entrada_peps,
        @cd_item_nota_fiscal  = cd_item_documento_aux, -- Ludinei 11/08
        @qt_nota_fiscal       = isnull(qt_entrada_peps,0), 
        @qt_peso_nota_fiscal  = isnull(qt_peso_entrada_peps,0),
        @vl_custo_peps        = isnull(vl_custo_total_peps,0),
        @dt_documento_peps    = dt_documento_entrada_peps,
        @fator                = fator,
        @cd_movimento_estoque = cd_movimento_estoque
      from #Aux_peps
      order by cd_seq_peps

      if @ic_debug = 'S'
      begin
        print('  Nota Processada');
        print('  ---------------');
        print('  Seq: '+cast(@cd_seq_peps as varchar))
        print('  NF: '+cast(@cd_nota_fiscal as varchar))
        print('  Item: '+cast(@cd_item_nota_fiscal as varchar))
        print('  Qt NF: '+cast(@qt_nota_fiscal as varchar))
        print('  Qt Peso: '+cast(@qt_peso_nota_fiscal as varchar))
        print('  Vl Custo: '+cast(@vl_custo_peps as varchar))
        print('  Data: '+cast(@dt_documento_peps as varchar))
        print('  Fator: '+cast(@fator as varchar))
      end

      -- Inicializa nova sequência de PEPS
      if @cd_seq_peps = 1
      begin  
        set @cd_produto_first               = @cd_produto
        set @cd_nota_fiscal_first           = @cd_nota_fiscal
        set @cd_item_nota_fiscal_first      = @cd_item_nota_fiscal
        set @qt_nota_fiscal_first           = @qt_nota_fiscal
        set @qt_peso_nota_fiscal_first      = @qt_peso_nota_fiscal
      
        if @ic_debug = 'S'
        begin
          print('    Sequencia PEPS'); 
          print('    --------------');
          print('    ProdutoFirst: '+cast(@cd_produto as varchar))
          print('    NotaFiscalFirst: '+cast(@cd_nota_fiscal as varchar))
          print('    ItemNotaFirst: '+cast(@cd_item_nota_fiscal as varchar))
          print('    QtdeNotaFirst: '+cast(@qt_nota_fiscal as varchar))
          print('    PesoNotaFirst: '+cast(@qt_peso_nota_fiscal as varchar))
        end
      end  -- if

      --Verifica a Quantidade ou o Peso para Valoração
      set @qt_peps = @qt_nota_fiscal

      if @ic_debug = 'S'
        print('    QtdePEPS: '+cast(@qt_peps as varchar));

      if @qt_saldo_produto < (@qt_peps_aux + @qt_nota_fiscal)
      begin        

        set @vl_custo_peps = (@vl_custo_peps/@qt_nota_fiscal) * (@qt_saldo_produto - @qt_peps_aux)

        if @vl_custo_peps < 0.01
          set @vl_custo_peps = 0.01                    

        set @qt_peps     = round(@qt_saldo_produto, 4) - round(@qt_peps_aux, 4)
        set @qt_peps_aux = round(@qt_saldo_produto, 4)

        if @ic_debug = 'S'
        begin 
          print('    SaldoProduto < (PepsAux + QtdNF)');
          print('    --------------------------------');
          print('    Vl Custo2: '+cast(@vl_custo_peps as varchar));
          print('    QtdePEPS2: '+cast(@qt_peps as varchar));
          print('    QtdePEPSAux: '+cast(@qt_peps_aux as varchar));
        end

      end -- if
      else
      begin 
        set @qt_peps_aux = round(@qt_peps_aux,4) + round(@qt_nota_fiscal,4)

        if @ic_debug = 'S'
        begin 
          print('    SaldoProduto > (PepsAux + QtdNF)');
          print('    --------------------------------');
          print('    QtdePEPSAux2: '+cast(@qt_peps_aux as varchar));
        end

      end 


      -- Atualiza o CADPEPS com Valores para PEPS
      set @qt_valorado_peps = round(@qt_saldo_produto,4) - 
                              round((@qt_saldo_produto - @qt_peps),4)  
            
      set @qt_itens_peps = round(@qt_itens_peps,4) + round(@qt_peps,4)

      if (select count(*) from #aux_peps) = 1
        set @qt_saldo_estoque = @qt_saldo_produto - @qt_itens_peps

      if @ic_debug = 'S'
      begin 
        print('  Atualizacao do Nota_Entrada_PEPS');
        print('  --------------------------------');
        print('  Qt Saldo Produto: '+cast(@qt_saldo_produto as varchar));
        print('  Qt Valorado: '+cast(@qt_valorado_peps as varchar));
        print('  Qt Item PEPS: '+cast(@qt_itens_peps as varchar));
        print('  Qt Saldo Estoque: '+cast(@qt_saldo_estoque as varchar));
        print('  Qt PEPS: '+cast(@qt_peps as varchar));
        print('  Qt NFE: '+cast(@qt_nota_fiscal as varchar));
        print('  Peso NFE: '+cast(@qt_peso_nota_fiscal as varchar));
        print('  Movimento Estoque: '+cast(@cd_movimento_estoque as varchar));
      end

      update Nota_Entrada_Peps
      set qt_valorizacao_peps = case when @ic_tipo_valoracao = 'F' then 
                                  round(@qt_valorado_peps,4) 
	      		        else round(@qt_peps,4) end,
          qt_valoracao_peps_peso = case when @ic_tipo_valoracao = 'F' then 
                                     round((@qt_peso_nota_fiscal / @qt_nota_fiscal) * @qt_valorado_peps,4) 
   	      		           else 
                                     round((@qt_peso_nota_fiscal / @qt_nota_fiscal) * @qt_peps,4) end,
          vl_custo_valorizacao_peps = case when @fator = 'P' then 
                                        case when @ic_tipo_valoracao = 'F' then 
                                          case when isnull(round(@qt_peps,4),0) = 0 then 
                                            ((@vl_custo_peps/1) * isnull(round(@qt_valorado_peps,4),1)) 
                                          else
                                            ((@vl_custo_peps/@qt_peps) * isnull(round(@qt_valorado_peps,4), 
                                                                                round(@qt_peps,4)))
                                          end
                                        else 
                                          @vl_custo_peps 
                                        end
                                      else  
                                        case when @ic_tipo_valoracao = 'F' then 
                                          round(round((round(@qt_peso_nota_fiscal / @qt_nota_fiscal,4) * @qt_itens_peps),4) * 
                                                round(@vl_custo_peps / (round(@qt_peso_nota_fiscal / @qt_nota_fiscal,4) * @qt_itens_peps),4),2)
                                        else 
                                          @vl_custo_peps
                                        end                                         
                                      end 
      where cd_movimento_estoque = @cd_movimento_estoque

      -- Indica que não Existe NF para Valorar a Quantidade
      if (select count(*) from #aux_peps) = 1
      begin

        if @ic_debug = 'S'
          print('Ajustando Nota PEPS c/ Quantidade para Fechar o Saldo!'); 

        if (@qt_saldo_estoque > 0) 
          set @ic_divergencia_saldo = 'S'
        else
          set @ic_divergencia_saldo = 'N'

      end  -- if  
  
      -- Deleta Nota Fiscal do Arquivo Auxilar
      delete #Aux_Peps 
      where (cd_produto = @cd_produto) and
        @cd_nota_fiscal = cd_documento_entrada_peps and
        @cd_item_nota_fiscal = cd_item_documento_aux and 
        @qt_nota_fiscal = qt_entrada_peps

      if (@qt_valorado_peps = 0)
        break

    end  -- WHILE

    drop table #aux_peps

    ---------------------------------------------------------------------------
    -- TABELA TEMPORÁRIA COM OS CÁLCULOS DO PEPS
    ---------------------------------------------------------------------------

    if @ic_debug = 'S'
    begin 
      print('Gravando PEPS em Tabela Temporária');
      print('----------------------------------');
    end

    if (@ic_movimento = 'N')
    begin

      if @ic_debug = 'S'
      begin 
        print('  Gravando Item de Registro de NFE Inexistente');
        print('  --------------------------------------------');
      end

      insert into #TEMP_PEPS
      select 999999999, @cd_produto, 0, 'INVALIDA', 0, @qt_saldo_produto, 0, 0, @qt_saldo_produto, 0, 0, 0, 0, getdate(), 
        0, @cd_fase, 0, 0, 0, 'INVALIDO', gp.nm_grupo_produto, 
        isnull(dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto),'') as 'Codigo',
        c.nm_fantasia_produto as 'Produto',
        c.nm_produto as 'Descricao',
        case when isnull(gpc.cd_unidade_valoracao,0) > 0 then 
          isnull(umv.sg_unidade_medida,'') 
        else 
          isnull(um.sg_unidade_medida,'') end as 'Unidade',
        0, 
        isnull(umv.ic_fator_conversao,'P')   as 'Fator',    
        'S'
      from Produto c with(nolock)
        left outer join Grupo_Produto gp with(nolock) on   c.cd_grupo_produto     = gp.cd_grupo_produto
        left outer join Unidade_Medida um with(nolock) on   c.cd_unidade_medida    = um.cd_unidade_medida
        left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto     = gp.cd_grupo_produto
        left outer join Unidade_Medida umv with(nolock) on umv.cd_unidade_medida    = gpc.cd_unidade_valoracao
      where c.cd_produto = @cd_produto

    end
    else
    begin    
      insert into #TEMP_PEPS
      select a.cd_movimento_estoque, a.cd_produto, a.cd_fornecedor, a.cd_documento_entrada_peps, a.cd_item_documento_entrada,
        a.qt_entrada_peps, a.vl_preco_entrada_peps, a.vl_custo_total_peps, 
        a.qt_valorizacao_peps, a.qt_valoracao_peps_peso,
        a.vl_custo_valorizacao_peps,
        a.vl_fob_entrada_peps, a.cd_usuario, a.dt_usuario, a.dt_documento_entrada_peps, a.cd_fase_produto, a.cd_controle_nota_entrada,
        a.dt_controle_nota_entrada,
        case when @fator = 'P' then
          isnull(a.vl_custo_valorizacao_peps,0) / a.qt_valorizacao_peps
        else
          isnull(a.vl_custo_valorizacao_peps,0) / a.qt_valoracao_peps_peso
        end as 'Unitario',
        isnull(b.nm_fantasia_fornecedor,'Ajuste') as 'Fornecedor' ,
        gp.nm_grupo_produto as 'GrupoProduto',
        IsNull(dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto),'') as 'Codigo',
        c.nm_fantasia_produto as 'Produto',
        c.nm_produto as 'Descricao',
        case when isnull(gpc.cd_unidade_valoracao,0) > 0 then 
          isnull(umv.sg_unidade_medida,'') 
        else 
          isnull(um.sg_unidade_medida,'') end as 'Unidade',
        a.qt_peso_entrada_peps,  
        isnull(umv.ic_fator_conversao,'P')   as 'fator',
        @ic_divergencia_saldo as ic_divergencia_saldo
      from Nota_Entrada_Peps a with(nolock)
        left outer join Movimento_Estoque mv with(nolock) on a.cd_movimento_estoque = mv.cd_movimento_estoque and
                                                             mv.cd_fase_produto     = @cd_fase 
        left outer join Fornecedor b with(nolock)         on   a.cd_fornecedor        = b.cd_fornecedor
        left outer join Produto c with(nolock)            on   a.cd_produto           = c.cd_produto
        left outer join Produto_Custo pc with(nolock)     on   a.cd_produto           = pc.cd_produto
        left outer join Materia_Prima mp with(nolock)     on   pc.cd_mat_prima        = mp.cd_mat_prima
        left outer join Grupo_Produto gp with(nolock)     on   c.cd_grupo_produto     = gp.cd_grupo_produto
        left outer join Unidade_Medida um with(nolock)    on   c.cd_unidade_medida    = um.cd_unidade_medida
        left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto     = gp.cd_grupo_produto
        left outer join Unidade_Medida umv with(nolock)   on umv.cd_unidade_medida    = gpc.cd_unidade_valoracao
      where (a.cd_produto = @cd_produto) and
        (a.cd_fase_produto = @cd_fase) and
        isnull(a.qt_valorizacao_peps,0 ) > 0 and
        a.dt_documento_entrada_peps <= @dt_final
      order by
        a.dt_documento_entrada_peps desc
    end 

    if (@ic_atualiza_custo = 'S') and (@ic_movimento = 'S')
    begin

      -------------------------------------------------------------------------- 
      -- Atualiza a Produto_Custo
      --------------------------------------------------------------------------
      if (@cd_fase_produto_comercial = @cd_fase)
      begin
        update Produto_Custo
        set vl_custo_contabil_produto = peps.unitario
        from Produto_Custo pc with(nolock)
          inner join (select cd_produto, cast(sum(isnull(unitario, 0)) as decimal(18,2)) as unitario
                      from #TEMP_PEPS
                      where cd_fase_produto = @cd_fase and
                            cd_produto = @cd_produto
                      group by cd_produto) peps on pc.cd_produto = peps.cd_produto
      end

      --------------------------------------------------------------------------
      -- Atualiza a Produto_Fechamento
      --------------------------------------------------------------------------
      -- Armazena também o campo de custo peps do fechamento (??? não sei por que dois campos e por
      -- não saber qual dos dois é realmente utilizado o melhor é atualizar os dois ??? - ELIAS
      update Produto_Fechamento
      set vl_custo_prod_fechamento = peps.vl_custo,
        vl_custo_peps_fechamento = peps.vl_custo,
        qt_peps_prod_fechamento  = peps.qt_valorizacao
      from Produto_Fechamento pf with(nolock)
        inner join (select cd_produto, 
                      cast(sum(isnull(unitario,0) * (case when ic_fator_valoracao = 'P' then 
                                                       isnull(qt_valorizacao_peps,0)
                                                     else 
                                                       isnull(qt_valoracao_peps_peso,0) 
                                                     end)) as decimal(25,2)) as vl_custo,
                      cast(sum(case when ic_fator_valoracao = 'P' then 
                                 isnull(qt_valorizacao_peps,0)
                               else 
                                 isnull(qt_valoracao_peps_peso,0) 
                               end) as decimal(25,2)) as qt_valorizacao
                    from #TEMP_PEPS
                    where cd_fase_produto = @cd_fase and
                      cd_produto = @cd_produto
                    group by cd_produto) peps on pf.cd_produto = peps.cd_produto 
      where pf.cd_fase_produto = @cd_fase and 
        pf.cd_produto = @cd_produto and 
        pf.dt_produto_fechamento between @dt_inicial and @dt_final

      --------------------------------------------------------------------------
      -- Atualiza a Produto_Saldo
      --------------------------------------------------------------------------
      update Produto_Saldo
      set vl_custo_contabil_produto = peps.unitario
      from Produto_Saldo ps with(nolock)
          inner join (select cd_produto, cast(sum(isnull(unitario, 0)) as decimal(18,2)) as unitario
                      from #TEMP_PEPS
                      where cd_fase_produto = @cd_fase and
                        cd_produto = @cd_produto
                      group by cd_produto) peps on ps.cd_produto = peps.cd_produto
      where ps.cd_fase_produto = @cd_fase

    end
   
    fetch next from cProdutoPEPS into @cd_produto, @cd_mascara_produto, @cd_fase, @qt_saldo_produto

  end  -- While Cursor

  close cProdutoPEPS
  deallocate cProdutoPEPS

  -----------------------------------------------------------------------------
  if (@ic_filtro_divergencia = 'S')  -- LISTAGEM DE DIVERGÊNCIAS
  -----------------------------------------------------------------------------
  begin

    select 
      a.cd_produto,
      sum(IsNull(a.qt_valorizacao_peps,0)) as 'Saldo_Peps',
      a.GrupoProduto,
      dbo.fn_mascara_produto(a.cd_produto) as 'Codigo',
      a.Produto,
      -- SALDO DE FECHAMENTO
      (select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
       from Produto_Fechamento pf with(nolock)
       where pf.cd_produto = a.cd_produto and
         pf.cd_fase_produto = @cd_fase and
         pf.dt_produto_fechamento between @dt_inicial and @dt_final
       order by pf.dt_produto_fechamento desc) as 'Saldo_Fechamento',

      -- SALDO DE TERCEIROS
      (select top 1 pf.qt_terc_prod_fechamento
       from Produto_Fechamento pf with(nolock)
       where pf.cd_produto = a.cd_produto and
         pf.cd_fase_produto = @cd_fase and
         pf.dt_produto_fechamento between @dt_inicial and @dt_final
       order by pf.dt_produto_fechamento desc) as 'Terceiros',

      -- QUANTIDADE DIVERGENTE
      (sum(IsNull(a.qt_valorizacao_peps,0)) - 
	((select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
          from Produto_Fechamento pf with(nolock) 
          where pf.cd_produto = a.cd_produto and
            pf.cd_fase_produto = @cd_fase and
            pf.dt_produto_fechamento between @dt_inicial and @dt_final
	  order by pf.dt_produto_fechamento desc) +
      (select top 1 IsNull(pf.qt_terc_prod_fechamento,0)
       from Produto_Fechamento pf with(nolock)
       where pf.cd_produto = a.cd_produto and
         pf.cd_fase_produto = @cd_fase and
         pf.dt_produto_fechamento between @dt_inicial and @dt_final
         order by pf.dt_produto_fechamento desc))) AS 'Divergencia'

    from #TEMP_PEPS a 
    group by a.cd_produto, a.GrupoProduto, a.Produto 
    having 

      ((sum(IsNull(a.qt_valorizacao_peps,0)) <> 
        (select top 1 IsNull(pf.qt_atual_prod_fechamento ,0)
         from Produto_Fechamento pf with(nolock)
          where pf.cd_produto = a.cd_produto and
            pf.cd_fase_produto = @cd_fase and
            pf.dt_produto_fechamento between @dt_inicial and @dt_final
	 order by pf.dt_produto_fechamento desc)) and
      (@ic_filtro_divergencia = 'C')) or

        ((sum(IsNull(a.qt_valorizacao_peps,0)) <> 
    	  ((select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
            from Produto_Fechamento pf with(nolock)
            where pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
            order by pf.dt_produto_fechamento desc) +
          (select top 1 IsNull(pf.qt_terc_prod_fechamento ,0)
           from Produto_Fechamento pf with(nolock)
           where pf.cd_produto = a.cd_produto and
             pf.cd_fase_produto = @cd_fase and
             pf.dt_produto_fechamento between @dt_inicial and @dt_final
	   order by pf.dt_produto_fechamento desc))) and
      (@ic_filtro_divergencia = 'D'))     
   
  end
  -----------------------------------------------------------------------------
  else -- LISTAGEM DE DIVERGÊNCIAS (NÃO APLICA ATUALIZAÇÕES EM BANCO)
  -----------------------------------------------------------------------------
  begin


    -- SEM RESUMOS
    if (@ic_resumo_grupo = 'N') and (@ic_resumo_fase = 'N')
    begin

      -- APRESENTAÇÃO POR FANTASIA OU MÁSCARA
      if @ic_forma_ordenacao <> 'F'
        select * from #TEMP_PEPS order by codigo asc, dt_documento_entrada_peps desc
      else
        select * from #TEMP_PEPS order by Produto asc, dt_documento_entrada_peps desc

    end
    -- COM RESUMO POR GRUPO
    else if (@ic_resumo_grupo = 'S')
    begin

      select tp.grupoproduto,
        sum(tp.qt_entrada_peps) as Qtd,
        fp.nm_fase_produto,
        sum(tp.vl_custo_valorizacao_peps) as Total
      from #TEMP_PEPS tp
        left outer join Fase_Produto fp with(nolock) on fp.cd_fase_produto = tp.cd_fase_produto
      group by tp.grupoproduto, fp.nm_fase_produto        

    end
    -- COM RESUMO POR FASE
    else if (@ic_resumo_fase = 'S')
    begin

      select
        fp.nm_fase_produto,
        sum(tp.qt_entrada_peps) as Qtd,
        sum(tp.vl_custo_valorizacao_peps) as Total
      from #TEMP_PEPS tp
        left outer join Fase_Produto fp with(nolock) on fp.cd_fase_produto = tp.cd_fase_produto
      group by fp.nm_fase_produto        

    end

  end

  drop table #TEMP_PEPS

end 
-------------------------------------------------------------------------------
if @ic_parametro in (3,4) -- NOTAS FISCAIS DOS PVEs
-------------------------------------------------------------------------------
begin


  -- NOTAS FISCAIS FATURADAS APÓS O PERÍODO FINAL
  select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, 
    sum(nsi.qt_item_nota_saida - (case when (nsi.dt_cancel_item_nota_saida is null) then
                                    case when (nsi.dt_restricao_item_nota < @dt_final) then 
                                      isnull(nsi.qt_devolucao_item_nota,0) 
                                    else
                                      0
                                    end
                                  else
                                    nsi.qt_item_nota_saida
                                  end)) as qt_item_faturado
  into #NotaSaidaCustoFaturado
  from Nota_Saida_Item nsi with(nolock)
    inner join Nota_Saida ns with(nolock) on nsi.cd_nota_saida = ns.cd_nota_saida 
    inner join Pedido_Venda_Item pvi with(nolock) on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                                     nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
    inner join Grupo_Produto gp with(nolock) on pvi.cd_grupo_produto = gp.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on pvi.cd_grupo_produto = gpc.cd_grupo_produto 
  where (nsi.dt_nota_saida > @dt_final) and 
    (not (isnull(nsi.dt_cancel_item_nota_saida, isnull(dt_restricao_item_nota, @dt_final)) > @dt_final)) and
    gp.ic_especial_grupo_produto = 'S' and
    gpc.ic_custo = 'S' and
    op.ic_estoque_op_fiscal = 'S' and
    op.ic_comercial_operacao = 'S' 
  group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

  -- NOTAS CANCELADAS/DEVOLVIDAS APÓS O PERÍODO FINAL MAS 
  -- QUE ESTAVAM FATURADAS ATÉ O PERIODO FINAL
  select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, 
    sum(case when (isnull(nsi.qt_devolucao_item_nota,0) <> 0) 
        then nsi.qt_devolucao_item_nota
        else nsi.qt_item_nota_saida
        end) as qt_item_devolvido
  into #NotaSaidaCustoDevolvido
  from Nota_Saida_Item nsi with(nolock)
    inner join Nota_Saida ns with(nolock) on nsi.cd_nota_saida = ns.cd_nota_saida 
    inner join Pedido_Venda_Item pvi with(nolock) on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                                     nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
    inner join Grupo_Produto gp with(nolock) on pvi.cd_grupo_produto = gp.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on pvi.cd_grupo_produto = gpc.cd_grupo_produto 
  where (isnull(nsi.dt_cancel_item_nota_saida, dt_restricao_item_nota) > @dt_final) and
    gp.ic_especial_grupo_produto = 'S' and
    gpc.ic_custo = 'S' and
    op.ic_estoque_op_fiscal = 'S' and
    op.ic_comercial_operacao = 'S' and
    ns.dt_nota_saida <= @dt_final 
  group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

  -----------------------------------------------------------------------------
  if @ic_parametro = 3 -- PROCESSAMENTO DO 1 x 1/2 Custo do Período
  -----------------------------------------------------------------------------
  begin

    if @cd_fase_produto = 2 -- PROCESSO
    /* Entende-se PVE em Processo quando existe Compra para o PV e o mesmo encontra-se
       em aberto até a data final, e também não está em Prévia de Faturamento */
    begin
 
      select 
        pvihc.cd_pedido_venda as PVE,
        pvihc.cd_item_pedido_venda as PVEItem, 
        isnull(pvi.nm_produto_pedido,(select nm_produto_pedido
                                        from Pedido_Venda_Item with(nolock)
                                        where cd_pedido_venda = pvihc.cd_pedido_venda and
                                              cd_item_pedido_venda = 1)) as Produto,
        pvihc.qt_peso_bruto_saldo as PesoBruto,
        mp.nm_fantasia_mat_prima as MP,
        mp.nm_mat_prima as NomeMP,
        pvihc.cd_grupo_produto as CodGrupo,
        gp.nm_grupo_produto as GrupoProduto,
        cast(pvihc.vl_custo_total_item_ped_venda as decimal(25,2)) as CustoTotal
      from Pedido_Venda_Item_Historico_Custo pvihc with(nolock)
        inner join Materia_Prima mp with(nolock) on mp.cd_mat_prima = pvihc.cd_materia_prima
        inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvihc.cd_grupo_produto
        left outer join Pedido_Venda_Item pvi with(nolock) on pvihc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                              pvihc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      where pvihc.dt_apuracao_custo <= @dt_final and
        isnull(pvihc.dt_baixa_estoque, @dt_final) >= @dt_final and
        pvihc.cd_fase_produto = @cd_fase_produto and
        pvihc.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final 
      union all     
      select 
        pci.cd_pedido_venda as PVE,
        pci.cd_item_pedido_venda as PVEItem,
        pvi.nm_produto_pedido	as Produto,
        (sum(nei.qt_pesbru_nota_entrada) / 
           pvi.qt_item_pedido_venda *
          ((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0))) as PesoBruto,
        mp.nm_fantasia_mat_prima as MP,
        mp.nm_mat_prima as NomeMP,
        pvi.cd_grupo_produto as CodGrupo,
        gp.nm_grupo_produto as GrupoProduto,
        cast(
        case when (op.ic_imp_operacao_fiscal = 'S') then
          -- SE IMPORTAÇÃO
          sum(isnull(nei.vl_total_nota_entr_item,0) * 1.5)
        else
          -- SE COMPRA MERCADO NACIONAL
          sum(isnull(nei.vl_total_nota_entr_item,0) *
            ((100-nei.pc_icms_nota_entrada)/100) * 1.5)
        end / 
           pvi.qt_item_pedido_venda *
          ((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0)) as decimal(25,2)) as CustoTotal
      from Nota_Entrada_Item nei with(nolock)
        inner join Pedido_Compra_Item pci with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                          nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
        inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                         pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        inner join Pedido_Venda pv with(nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
        inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
        inner join Operacao_Fiscal op with(nolock) on nei.cd_operacao_fiscal = op.cd_operacao_fiscal
        inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
        inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
        left outer join #NotaSaidaCustoFaturado nsf on nsf.cd_pedido_venda = pvi.cd_pedido_venda and
                                                       nsf.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        left outer join #NotaSaidaCustoDevolvido nsd on nsd.cd_pedido_venda = pvi.cd_pedido_venda and
                                                        nsd.cd_item_pedido_venda = pvi.cd_item_pedido_venda      
      where 
        -- QUE TENHAM COMPRA ATÉ A DATA ATUAL
        nei.dt_item_receb_nota_entrad <= @dt_final and
        -- QUE NÃO SEJAM ROSCAS
        isnull(nei.cd_produto,0) <> 53786 and 
        -- QUE NÃO ESTEJAM CANCELADOS
        ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_final))  and
        -- QUE TENHAM QUANTIDADE
        (((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0)) > 0) and
        -- QUE NÃO FORAM FABRICADOS ATÉ A DATA FINAL
        (pvi.dt_entrega_fabrica_pedido is null or pvi.dt_entrega_fabrica_pedido > @dt_final) and
        -- NAO BUSCAR SMO
        isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
        -- NÃO BUSCAR PEDIDOS DE VENDA COM VALOR SIMBÓLICO (R$ 0,01)
        pvi.vl_unitario_item_pedido <> 0.01 and
        -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
        gpc.ic_custo = 'S' and
        gp.ic_especial_grupo_produto = 'S' and
        pvi.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final
      group by pci.cd_pedido_venda, pci.cd_item_pedido_venda, pvi.nm_produto_pedido, 
        mp.nm_fantasia_mat_prima, mp.nm_mat_prima, op.ic_imp_operacao_fiscal, pvi.cd_grupo_produto,
        pvi.qt_item_pedido_venda, pvi.qt_saldo_pedido_venda, pvi.dt_cancelamento_item,
        nsf.qt_item_faturado, nsd.qt_item_devolvido, gp.nm_grupo_produto
      order by GrupoProduto, MP, PVE, PVEItem

      drop table #NotaSaidaCustoFaturado
      drop table #NotaSaidaCustoDevolvido
    end
    else
      select
        cast(null as int) as PVE,
        cast(null as int) as PVEItem, 
        cast(null as varchar) as Produto,
        cast(null as decimal(25,2)) as PesoBruto,
        cast(null as varchar) as MP,
        cast(null as varchar) as NomeMP,
        cast(null as int) as CodGrupo,
        cast(null as varchar) as GrupoProduto,
        cast(null as decimal(25,2)) as CustoTotal
  end
  -------------------------------------------------------------------------------
  else if @ic_parametro = 4 -- PROCESSAMENTO DO 70 % DO PREÇO DE VENDA - PEDIDOS DE VENDA 
  -------------------------------------------------------------------------------
  begin

    -----------------------------------------------------------------------------
    -- FASE 3 - ESPECIAIS FABRICADOS E NÃO FATURADOS
    -----------------------------------------------------------------------------
    if (@cd_fase_produto = 3)
    begin

      ---------------------------------------------------------------------------
      -- HISTÓRICO DE PEDIDOS - EM NOSSO PODER - NACIONAIS
      ---------------------------------------------------------------------------
      select 
        gi.nm_grupo_inventario as GrupoInventario,
        pvihc.cd_pedido_venda as PVE,
        pvihc.cd_item_pedido_venda as PVEItem, 
        isnull(pvi.nm_produto_pedido,(select nm_produto_pedido
                                      from Pedido_Venda_Item
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Produto,
        pvihc.qt_peso_bruto_saldo as PesoBruto,
        mp.nm_fantasia_mat_prima as MP,
        mp.nm_mat_prima as NomeMP,
        pvihc.cd_grupo_produto as CodGrupo,
        gp.nm_grupo_produto as GrupoProduto,
        cast(sum(pvihc.vl_custo_total_item_ped_venda) as decimal(25,2)) as ValorBase,
        cast(pvihc.vl_preco_lista_pedido as decimal(25,2)) as Preco
      into #CustoItem
      from Pedido_Venda_Item_Historico_Custo pvihc with(nolock)
        inner join Materia_Prima mp with(nolock) on mp.cd_mat_prima = pvihc.cd_materia_prima
        inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvihc.cd_grupo_produto
        inner join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = pvihc.cd_grupo_inventario
        left outer join Pedido_Venda_Item pvi with(nolock) on pvihc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                              pvihc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      where pvihc.dt_apuracao_custo <= @dt_final and
        isnull(pvihc.dt_baixa_estoque, @dt_final) >= @dt_final and
        pvihc.cd_fase_produto = @cd_fase_produto and
        pvihc.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final and
        -- SOMENTE PRODUTOS DE ESTOQUE
        pvihc.cd_grupo_inventario = 1 
      group by
        gi.nm_grupo_inventario,
        pvihc.cd_pedido_venda,
        pvihc.cd_item_pedido_venda, 
        pvi.nm_produto_pedido,
        pvihc.qt_peso_bruto_saldo,
        mp.nm_fantasia_mat_prima,
        mp.nm_mat_prima,
        pvihc.cd_grupo_produto,
        gp.nm_grupo_produto,
        pvihc.vl_preco_lista_pedido
      union all
      ---------------------------------------------------------------------------
      -- HISTÓRICO DE PEDIDOS - EM PODER DE TERCEIROS - EXPORTAÇÃO
      ---------------------------------------------------------------------------
      select 
        gi.nm_grupo_inventario as GrupoInventario,
        pvihc.cd_pedido_venda as PVE,
        pvihc.cd_item_pedido_venda as PVEItem, 
        isnull(pvi.nm_produto_pedido,(select nm_produto_pedido
                                      from Pedido_Venda_Item with(nolock)
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Produto,
        pvihc.qt_peso_bruto_saldo as PesoBruto,
        mp.nm_fantasia_mat_prima as MP,
        mp.nm_mat_prima as NomeMP,
        c.cd_cliente as CodGrupo,
        c.nm_fantasia_cliente as GrupoProduto,
        cast(sum(pvihc.vl_custo_total_item_ped_venda) as decimal(25,2)) as ValorBase,
        cast(pvihc.vl_preco_lista_pedido as decimal(25,2)) as Preco
      from Pedido_Venda_Item_Historico_Custo pvihc with(nolock)
        inner join Materia_Prima mp with(nolock) on mp.cd_mat_prima = pvihc.cd_materia_prima
        inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvihc.cd_grupo_produto
        inner join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = pvihc.cd_grupo_inventario      
        left outer join Pedido_Venda_Item pvi with(nolock) on pvihc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                              pvihc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        left outer join Pedido_Venda pv with(nolock) on pv.cd_pedido_venda = pvihc.cd_pedido_venda
        left outer join Cliente c with(nolock) on c.cd_cliente = pv.cd_cliente
      where pvihc.dt_apuracao_custo <= @dt_final and
        isnull(pvihc.dt_baixa_estoque, @dt_final) >= @dt_final and
        pvihc.cd_fase_produto = @cd_fase_produto and
        pvihc.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final and
        -- SOMENTE PRODUTOS EM PODER DE TERCEIROS
        pvihc.cd_grupo_inventario = 2 
      group by
        gi.nm_grupo_inventario, 
        pvihc.cd_pedido_venda,
        pvihc.cd_item_pedido_venda, 
        pvi.nm_produto_pedido,
        pvihc.qt_peso_bruto_saldo,
        mp.nm_fantasia_mat_prima,
        mp.nm_mat_prima,
        c.cd_cliente,
        c.nm_fantasia_cliente,
        pvihc.vl_preco_lista_pedido
      union all
      ---------------------------------------------------------------------------
      -- PEDIDOS EM ABERTO FABRICADOS E NÃO FATURADOS 
      ---------------------------------------------------------------------------
      select
        gi.nm_grupo_inventario as GrupoInventario,
        pci.cd_pedido_venda as PVE,
        pci.cd_item_pedido_venda as PVEItem,
        pvi.nm_produto_pedido	as Produto,
        (sum(nei.qt_pesbru_nota_entrada) / 
           pvi.qt_item_pedido_venda *
          ((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0))) as PesoBruto,
        mp.nm_fantasia_mat_prima as MP,
        mp.nm_mat_prima as NomeMP,
        pvi.cd_grupo_produto as CodGrupo,
        gp.nm_grupo_produto as GrupoProduto,  

        cast(sum(nei.vl_total_nota_entr_item) as decimal(25,2)) as ValorBase,

        cast(case when isnull(pvi.vl_unitario_item_pedido, 0.00) between 0.00 and 0.01 
          then cast(pvi.vl_lista_item_pedido as decimal(25,2))
          else cast(pvi.vl_unitario_item_pedido as decimal(25,2)) end *
          ((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0)) as decimal(25,2)) as Preco
      from Nota_Entrada_Item nei with(nolock)
        inner join Nota_Entrada ne with(nolock) on nei.cd_nota_entrada = ne.cd_nota_entrada and
                                                   nei.cd_fornecedor = ne.cd_fornecedor and
                                                   nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                                   nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal      
        inner join Pedido_Compra_Item pci with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                          nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
        inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                         pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        inner join Pedido_Venda pv with(nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
        inner join Cliente c with(nolock) on c.cd_cliente = pv.cd_cliente
        inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
        inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
        inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
        inner join Tipo_Pedido tp with(nolock) on pv.cd_tipo_pedido = tp.cd_tipo_pedido
        inner join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = 1
        left outer join #NotaSaidaCustoFaturado nsf on nsf.cd_pedido_venda = pvi.cd_pedido_venda and
                                                       nsf.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        left outer join #NotaSaidaCustoDevolvido nsd on nsd.cd_pedido_venda = pvi.cd_pedido_venda and
                                                        nsd.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      where 
        -- QUE TENHAM SIDO FABRICADOS ATÉ O MÊS
        (pvi.dt_entrega_fabrica_pedido <= @dt_final) and  
        -- QUE NÃO SEJAM ROSCAS
        isnull(nei.cd_produto,0) <> 53786 and -- ROSCAS
        -- QUE TENHAM SALDO
        (((case when pvi.dt_cancelamento_item is null then
              pvi.qt_saldo_pedido_venda
            else
              pvi.qt_item_pedido_venda
            end) + isnull(nsf.qt_item_faturado,0) - 
                   isnull(nsd.qt_item_devolvido,0)) > 0) and
        -- QUE NÃO ESTEJAM CANCELADOS
        ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_final)) and
        -- GRUPOS ESPECIAIS
        gp.ic_especial_grupo_produto = 'S' and
        -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
        gpc.ic_custo = 'S' and
        -- SOMENTE SE ESTIVER FECHADO
        pv.ic_fechamento_total = 'S' and
        -- SOMENTE PVE ABERTOS OU LIQUIDADOS
        pv.cd_status_pedido in (1,2) and
        -- SOMENTE TIPO ESPECIAL PEDIDOS ESPECIAIS
        isnull(tp.ic_especial_tipo_pedido,'S') = 'S' and
        -- NÃO BUSCAR ITENS 99 - PEDIDOS DE VENDA MERCADO EXTERNO
        pvi.cd_item_pedido_venda <= (case isnull(c.cd_pais,1) 
                                     when 1 then 80
                                     else  pvi.cd_item_pedido_venda
                                     end) and
        -- NAO BUSCAR SMO
        isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
        -- NÃO BUSCAR PEDIDOS DE VENDA COM VALOR SIMBÓLICO (R$ 0,01)
        pvi.vl_unitario_item_pedido <> 0.01 and
        -- FILTRAR POR GRUPO DE PRODUTO
        pvi.cd_grupo_produto between @cd_grupo_inicial and @cd_grupo_final and
        -- QUE NÃO ESTEJAM CADASTRADOS NO HISTÓRICO ACIMA
        pvi.cd_pedido_venda not in (select distinct cd_pedido_venda 
                                    from Pedido_Venda_Item_Historico_Custo with(nolock)
                                    where cd_fase_produto = @cd_fase_produto)
      group by gi.nm_grupo_inventario, pci.cd_pedido_venda, pci.cd_item_pedido_venda, pvi.nm_produto_pedido, 
        mp.nm_fantasia_mat_prima, mp.nm_mat_prima, pvi.cd_grupo_produto,
        gp.nm_grupo_produto, pv.vl_total_pedido_venda, pvi.vl_unitario_item_pedido,
        pvi.vl_lista_item_pedido, pvi.dt_cancelamento_item, pvi.qt_item_pedido_venda, 
        pvi.qt_saldo_pedido_venda, nsf.qt_item_faturado, nsd.qt_item_devolvido

      select 
        ci.GrupoInventario,
        ci.PVE,
        ci.PVEItem,
        ci.Produto,
        ci.PesoBruto,
        ci.MP,
        ci.NomeMP,
        ci.CodGrupo,
        ci.GrupoProduto,  
        cast((ci.Preco * (ci.ValorBase / (select sum(aux.ValorBase) 
                                          from #CustoItem aux 
                                          where aux.PVE = ci.PVE and
                                            aux.PVEItem = ci.PVEItem)) * 0.7) as decimal(25,2)) as CustoTotal,
        ci.Preco
      from #CustoItem ci
      order by ci.GrupoInventario, ci.GrupoProduto, ci.MP, ci.PVE, ci.PVEItem 

      drop table #NotaSaidaCustoFaturado
      drop table #NotaSaidaCustoDevolvido

    end
    else
      select
        cast(null as varchar) as GrupoInventario,
        cast(null as int) as PVE,
        cast(null as int) as PVEItem, 
        cast(null as varchar) as Produto,
        cast(null as decimal(25,2)) as PesoBruto,
        cast(null as varchar) as MP,
        cast(null as varchar) as NomeMP,
        cast(null as int) as CodGrupo,
        cast(null as varchar) as GrupoProduto,
        cast(null as decimal(25,2)) as CustoTotal,
        cast(null as decimal(25,2)) as Preco

  end
end
------------------------------------------------------------------------------
else if @ic_parametro = 5 -- DETALHE DE CUSTO DAS COMPRAS DO PEDIDO  - 1 1/2
-------------------------------------------------------------------------------
begin

  select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, sum(nsi.qt_item_nota_saida - isnull(nsi.qt_devolucao_item_nota,0)) as qt_item_nota_saida
  into #NotaSaidaPV
  from Nota_Saida_Item nsi with(nolock)
    inner join Nota_Saida ns with(nolock) on nsi.cd_nota_saida = ns.cd_nota_saida 
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
    inner join Grupo_Produto gp with(nolock) on nsi.cd_grupo_produto = gp.cd_grupo_produto
  where nsi.dt_cancel_item_nota_saida is null and
    gp.ic_especial_grupo_produto = 'S' and
    op.ic_estoque_op_fiscal = 'S' and
    ns.dt_nota_saida > @dt_final and
    nsi.cd_pedido_venda = @cd_pedido_venda and
    nsi.cd_item_pedido_venda = @cd_item_pedido_venda
  group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

  select 
    pci.cd_pedido_venda as PVE,
    pci.cd_item_pedido_venda as PVEItem,
    pvi.nm_produto_pedido as Produto,
    pci.cd_pedido_compra as PC,
    pci.cd_item_pedido_compra as PCItem,
    nei.cd_nota_entrada as NFE,
    nei.cd_item_nota_entrada as NFEItem,
    f.nm_fantasia_fornecedor as Fornecedor,
    nei.qt_pesbru_nota_entrada as PesoBruto,
    nei.nm_produto_nota_entrada as ProdutoCompra,
    mp.nm_fantasia_mat_prima as MP,
    mp.nm_mat_prima as NomeMP,
    pvi.cd_grupo_produto as CodGrupo,
    gp.nm_grupo_produto as GrupoProduto,
    case when (op.ic_imp_operacao_fiscal = 'S') then
      -- SE IMPORTAÇÃO
      cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2)) * 1.5
    else
      -- SE COMPRA MERCADO NACIONAL
      cast(cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2)) *
           cast(((100-nei.pc_icms_nota_entrada)/100) as decimal(25,2)) as decimal(25,2)) * 1.5
    end as CustoTotal
  from Nota_Entrada_Item nei with(nolock)
    inner join Pedido_Compra_Item pci with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                      nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
    inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                     pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    inner join Pedido_Venda pv with(nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
    inner join Fornecedor f with(nolock) on nei.cd_fornecedor = f.cd_fornecedor 
    inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
    inner join Operacao_Fiscal op with(nolock) on nei.cd_operacao_fiscal = op.cd_operacao_fiscal
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
    left outer join #NotaSaidaPV ns with(nolock) on ns.cd_pedido_venda = pvi.cd_pedido_venda and
                                                    ns.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  where 
    -- QUE TENHAM COMPRA ATÉ A DATA ATUAL
    nei.dt_item_receb_nota_entrad <= @dt_final and
    -- QUE NÃO SEJAM ROSCAS
    isnull(nei.cd_produto,0) <> 53786 and 
    -- QUE NÃO ESTEJAM CANCELADOS
    ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_final)) and
    -- QUE TENHAM QUANTIDADE
    ((pvi.qt_saldo_pedido_venda + isnull(ns.qt_item_nota_saida,0)) > 0) and
    -- QUE NÃO FORAM FABRICADOS ATÉ A DATA FINAL
    (pvi.dt_entrega_fabrica_pedido is null or pvi.dt_entrega_fabrica_pedido > @dt_final) and
    -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
    gpc.ic_custo = 'S' and
    gp.ic_especial_grupo_produto = 'S' and
    -- NAO BUSCAR SMO
    isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
    pvi.cd_pedido_venda = @cd_pedido_venda and
    pvi.cd_item_pedido_venda = @cd_item_pedido_venda
  order by GrupoProduto, MP, PVE, PVEItem

end
-------------------------------------------------------------------------------
else if @ic_parametro = 6 -- DETALHE DE CUSTO DAS COMPRAS DO PEDIDO - 70%
-------------------------------------------------------------------------------
begin

  select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, 
    sum(nsi.qt_item_nota_saida - isnull(nsi.qt_devolucao_item_nota,0)) as qt_item_nota_saida
  into #NotaSaidaPrecoNacionalPV
  from Nota_Saida_Item nsi with(nolock)
    inner join Nota_Saida ns with(nolock) on nsi.cd_nota_saida = ns.cd_nota_saida 
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
    inner join Grupo_Produto gp with(nolock) on nsi.cd_grupo_produto = gp.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on nsi.cd_grupo_produto = gpc.cd_grupo_produto 
  where nsi.dt_cancel_item_nota_saida is null and
    gp.ic_especial_grupo_produto = 'S' and
    gpc.ic_custo = 'S' and
    op.ic_estoque_op_fiscal = 'S' and
    op.ic_comercial_operacao = 'S' and
    ns.dt_nota_saida > @dt_final and
    nsi.cd_pedido_venda = @cd_pedido_venda and
    nsi.cd_item_pedido_venda = @cd_item_pedido_venda
  group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

  select
    pci.cd_pedido_venda as PVE,
    pci.cd_item_pedido_venda as PVEItem,
    pvi.nm_produto_pedido as Produto,
    pci.cd_pedido_compra as PC,
    pci.cd_item_pedido_compra as PCItem,
    nei.cd_nota_entrada as NFE,
    nei.cd_item_nota_entrada as NFEItem,
    f.nm_fantasia_fornecedor as Fornecedor,
    nei.qt_pesbru_nota_entrada as PesoBruto,
    nei.nm_produto_nota_entrada as ProdutoCompra,
    mp.nm_fantasia_mat_prima as MP,
    mp.nm_mat_prima as NomeMP,
    pvi.cd_grupo_produto as CodGrupo,
    gp.nm_grupo_produto as GrupoProduto,
    cast(nei.vl_total_nota_entr_item as decimal(25,2)) as ValorBase,
    case when isnull(pvi.vl_unitario_item_pedido,0.00) between 0.00 and 0.01 
      then cast(pvi.vl_lista_item_pedido as decimal(25,2)) 
    else cast(pvi.vl_unitario_item_pedido as decimal(25,2)) end as Preco
  from Nota_Entrada_Item nei with(nolock)
    inner join Nota_Entrada ne with(nolock) on nei.cd_nota_entrada = ne.cd_nota_entrada and
                                               nei.cd_fornecedor = ne.cd_fornecedor and
                                               nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                               nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal      
    inner join Fornecedor f with(nolock) on f.cd_fornecedor = nei.cd_fornecedor 
    inner join Pedido_Compra_Item pci with(nolock) on pci.cd_pedido_compra = nei.cd_pedido_compra and
                                                      pci.cd_item_pedido_compra = nei.cd_item_pedido_compra
    inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
    inner join Pedido_Venda_Item pvi with(nolock) on pvi.cd_pedido_venda = pci.cd_pedido_venda and
                                                     pvi.cd_item_pedido_venda = pci.cd_item_pedido_venda
    inner join Pedido_Venda pv with(nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
    inner join Cliente c with(nolock) on c.cd_cliente = pv.cd_cliente
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
    inner join Tipo_Pedido tp with(nolock) on pv.cd_tipo_pedido = tp.cd_tipo_pedido
    left outer join #NotaSaidaPrecoNacionalPV ns with(nolock) on ns.cd_pedido_venda = pvi.cd_pedido_venda and
                                                                 ns.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  where 
    -- QUE TENHAM SIDO FABRICADOS ATÉ O MÊS
    (pvi.dt_entrega_fabrica_pedido <= @dt_final) and  
    -- QUE NÃO SEJAM ROSCAS
    isnull(nei.cd_produto,0) <> 53786 and -- ROSCAS
    -- QUE TENHAM SALDO
    ((pvi.qt_saldo_pedido_venda + isnull(ns.qt_item_nota_saida,0)) > 0) and
    -- QUE NÃO ESTEJAM CANCELADOS
    ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_final)) and
    -- GRUPOS ESPECIAIS
    gp.ic_especial_grupo_produto = 'S' and
    -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
    gpc.ic_custo = 'S' and
    -- SOMENTE SE ESTIVER FECHADO
    pv.ic_fechamento_total = 'S' and
    -- SOMENTE PVE ABERTOS OU LIQUIDADOS
    pv.cd_status_pedido in (1,2) and
    -- SOMENTE TIPO ESPECIAL PEDIDOS ESPECIAIS
    isnull(tp.ic_especial_tipo_pedido,'S') = 'S' and
    -- NÃO BUSCAR ITENS 99 - PEDIDOS DE VENDA MERCADO EXTERNO
    pvi.cd_item_pedido_venda <= (case isnull(c.cd_pais,1) 
                                 when 1 then 80
                                 else  pvi.cd_item_pedido_venda
                                 end) and
    -- NAO BUSCAR SMO
    isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
    pvi.cd_pedido_venda = @cd_pedido_venda and
    pvi.cd_item_pedido_venda = @cd_item_pedido_venda
  order by GrupoProduto, MP, PVE, PVEItem
end
-------------------------------------------------------------------------------
else if @ic_parametro = 7 -- PRODUTOS PADRÃO - 1 x 1/2 CUSTO DA COMPRA
-------------------------------------------------------------------------------
begin

  select 
    pf.cd_fase_produto as CodFaseProduto,
    fp.nm_fase_produto as FaseProduto,
    mp.nm_mat_prima as MP,
    p.nm_fantasia_produto as Fantasia,
    p.nm_produto as Produto,
    pf.qt_atual_prod_fechamento as Qtde,
    bmch.vl_custo_historico as CustoUnitario,
    (pf.qt_atual_prod_fechamento * qt_peso_bruto) as PesoBruto,
    cast(((isnull(cast(bmch.vl_custo_historico as decimal(25,2)),0) * (pf.qt_atual_prod_fechamento * qt_peso_bruto)) * 1.5) as decimal(25,2)) as ValorCusto,
    p.cd_produto as CodProduto
  into #ProdutoPadraoCompra
  from Produto_Fechamento pf with(nolock)
    inner join Produto p with(nolock) on pf.cd_produto = p.cd_produto
    inner join Produto_Custo pc with(nolock) on pc.cd_produto = pf.cd_produto
    inner join Fase_Produto fp with(nolock) on pf.cd_fase_produto = fp.cd_fase_produto
    inner join Materia_Prima mp with(nolock) on pc.cd_mat_prima = mp.cd_mat_prima
    inner join Metodo_Valoracao mv with(nolock) on pf.cd_metodo_valoracao = mv.cd_metodo_valoracao
    left outer join Bitola_Maior_Custo_Historico bmch with(nolock) on pc.cd_bitola = bmch.cd_bitola and
                                                                      bmch.dt_custo_historico = @dt_custo
  where pf.dt_produto_fechamento = @dt_custo and
     pf.qt_atual_prod_fechamento > 0 and
     mv.cd_metodo_valoracao = 2

  -----------------------------------------------------------------------------
  -- ATUALIZAÇÕES DE CUSTO
  -----------------------------------------------------------------------------
  if (@ic_atualiza_custo = 'S')
  begin

    -------------------------------------------------------------------------- 
    -- Atualiza a Produto_Custo
    --------------------------------------------------------------------------
    update Produto_Custo
    set vl_custo_contabil_produto = custo.CustoUnitario
    from Produto_Custo pc with(nolock)
      inner join #ProdutoPadraoCompra custo with(nolock) on custo.CodProduto = pc.cd_produto and
                                                            custo.CodFaseProduto = @cd_fase_produto_comercial
        
    --------------------------------------------------------------------------
    -- Atualiza a Produto_Fechamento
    --------------------------------------------------------------------------
    update Produto_Fechamento
    set vl_custo_prod_fechamento = custo.ValorCusto
    from Produto_Fechamento pf with(nolock)
      inner join #ProdutoPadraoCompra custo with(nolock) on custo.CodProduto = pf.cd_produto and
                                                            custo.CodFaseProduto = pf.cd_fase_produto
    where pf.dt_produto_fechamento between @dt_inicial and @dt_final

    --------------------------------------------------------------------------
    -- Atualiza a Produto_Saldo
    --------------------------------------------------------------------------
    update Produto_Saldo
    set vl_custo_contabil_produto = custo.CustoUnitario
    from Produto_Saldo ps with(nolock) 
      inner join #ProdutoPadraoCompra custo on custo.CodProduto = ps.cd_produto and 
                                               custo.CodFaseProduto = ps.cd_fase_produto
        
  end

  select FaseProduto, MP, Fantasia, Produto, Qtde, PesoBruto, ValorCusto
  from #ProdutoPadraoCompra
  order by 1, 2, 3

  drop table #ProdutoPadraoCompra

end
-------------------------------------------------------------------------------
else if @ic_parametro = 8 -- PRODUTOS PADRÃO - 70% DO MAIOR PREÇO DE VENDA OU 
--                           DO PREÇO DE LISTA
-------------------------------------------------------------------------------
begin

  declare @dt_inicio_ano datetime

  set @dt_inicio_ano = cast('01/01/'+cast(year(@dt_custo) as varchar) as datetime)

  select pf.cd_fase_produto as CodFaseProduto,
    fp.nm_fase_produto as FaseProduto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Mascara,
    p.nm_fantasia_produto as Fantasia,
    p.nm_produto as Produto,
    um.sg_unidade_medida as UN,

    isnull((select top 1 cast(cd_nota_saida as varchar)
     from Nota_Saida_Item nsi with(nolock), Operacao_Fiscal op with(nolock)
     where nsi.cd_produto = p.cd_produto and
       cast(nsi.vl_unitario_item_nota as decimal(25,2)) = 
            (select cast(max(isnull(aux.vl_unitario_item_nota,0)) as decimal(25,2)) 
             from nota_saida_item aux with(nolock), operacao_fiscal op with(nolock)
             where aux.cd_operacao_fiscal = op.cd_operacao_fiscal and
               aux.dt_nota_saida between @dt_inicio_ano and @dt_custo and
               aux.dt_restricao_item_nota is null and
               aux.dt_cancel_item_nota_saida is null and
               op.ic_comercial_operacao = 'S' and
               isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' and
               aux.cd_produto = p.cd_produto) and
       nsi.dt_nota_saida between @dt_inicio_ano and @dt_custo and
       nsi.dt_restricao_item_nota is null and
       nsi.dt_cancel_item_nota_saida is null and
       op.ic_comercial_operacao = 'S' and
       isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' 
     order by cd_nota_saida desc), 'LISTA') as Referencia,

    (select top 1 dt_nota_saida 
     from Nota_Saida_Item nsi with(nolock), Operacao_Fiscal op with(nolock)
     where nsi.cd_produto = p.cd_produto and
       cast(nsi.vl_unitario_item_nota as decimal(25,2)) = 
       (select cast(max(isnull(aux.vl_unitario_item_nota,0)) as decimal(25,2)) 
        from nota_saida_item aux with(nolock), operacao_fiscal op with(nolock)
        where aux.cd_operacao_fiscal = op.cd_operacao_fiscal and
          aux.cd_produto = p.cd_produto and
          aux.dt_restricao_item_nota is null and
          aux.dt_cancel_item_nota_saida is null and
          op.ic_comercial_operacao = 'S' and
          isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' and
          aux.dt_nota_saida between @dt_inicio_ano and @dt_custo) and
       nsi.dt_nota_saida between @dt_inicio_ano and @dt_custo and
       nsi.dt_restricao_item_nota is null and
       nsi.dt_cancel_item_nota_saida is null and
       op.ic_comercial_operacao = 'S' and
       isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' 
     order by cd_nota_saida desc) as DataReferencia,

    isnull((select cast(max(isnull(aux.vl_unitario_item_nota,0)) as decimal(25,2)) 
            from nota_saida_item aux with(nolock), operacao_fiscal op with(nolock)
            where aux.cd_operacao_fiscal = op.cd_operacao_fiscal and
              aux.cd_produto = p.cd_produto and
              aux.dt_restricao_item_nota is null and
              aux.dt_cancel_item_nota_saida is null and
              op.ic_comercial_operacao = 'S' and
              isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' and
              aux.dt_nota_saida between @dt_inicio_ano and @dt_custo),
            cast(pf.vl_maior_lista_produto as decimal(25,2))) as Preco,

    cast((isnull((select cast(max(isnull(aux.vl_unitario_item_nota,0)) as decimal(25,2)) 
                  from nota_saida_item aux with(nolock), operacao_fiscal op with(nolock)
                  where aux.cd_operacao_fiscal = op.cd_operacao_fiscal and
                    aux.cd_produto = p.cd_produto and
                    aux.dt_restricao_item_nota is null and
                    aux.dt_cancel_item_nota_saida is null and
                    op.ic_comercial_operacao = 'S' and
                    isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' and
                    aux.dt_nota_saida between @dt_inicio_ano and @dt_custo),
                    cast(pf.vl_maior_lista_produto as decimal(25,2))) * 0.7) as decimal(25,2)) as CustoUnitario,  

    pf.qt_atual_prod_fechamento as Qtde,

    cast((cast((isnull((select cast(max(isnull(aux.vl_unitario_item_nota,0)) as decimal(25,2)) 
                   from nota_saida_item aux with(nolock), operacao_fiscal op with(nolock)
                   where aux.cd_operacao_fiscal = op.cd_operacao_fiscal and
                     aux.cd_produto = p.cd_produto and
                     aux.dt_restricao_item_nota is null and
                     aux.dt_cancel_item_nota_saida is null and
                     op.ic_comercial_operacao = 'S' and
                     isnull(op.ic_exportacao_op_fiscal, 'N') = 'N' and
                     aux.dt_nota_saida between @dt_inicio_ano and @dt_custo),
                     cast(pf.vl_maior_lista_produto as decimal(25,2))) * 0.7) as decimal(25,2)) * 
      pf.qt_atual_prod_fechamento) as decimal(25,2)) as ValorCusto,

    p.cd_produto as CodProduto
  into #ProdutoPadraoVenda
  from Produto_Fechamento pf with(nolock)
    inner join Produto p with(nolock) on pf.cd_produto = p.cd_produto
    inner join Fase_Produto fp with(nolock) on pf.cd_fase_produto = fp.cd_fase_produto
    inner join Metodo_Valoracao mv with(nolock) on pf.cd_metodo_valoracao = mv.cd_metodo_valoracao
    inner join Unidade_Medida um with(nolock) on p.cd_unidade_medida = um.cd_unidade_medida
    inner join Grupo_Produto gp with(nolock) on p.cd_grupo_produto = gp.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on p.cd_grupo_produto = gpc.cd_grupo_produto
  where pf.dt_produto_fechamento = @dt_custo and
    pf.qt_atual_prod_fechamento > 0 and
    mv.cd_metodo_valoracao = 3 and
    gpc.ic_peps = 'S' and 
    gpc.ic_custo = 'S' and
    isnull(p.ic_producao_produto, 'N') = 'N' and
    isnull(gp.ic_revenda_grupo_produto, 'N') = 'S' 
  order by 1, 2

  -----------------------------------------------------------------------------
  -- ATUALIZAÇÕES DE CUSTO
  -----------------------------------------------------------------------------
  if (@ic_atualiza_custo = 'S')
  begin

    -------------------------------------------------------------------------- 
    -- Atualiza a Produto_Custo
    --------------------------------------------------------------------------
    update Produto_Custo
    set vl_custo_contabil_produto = custo.CustoUnitario
    from Produto_Custo pc with(nolock)
      inner join #ProdutoPadraoVenda custo on custo.CodProduto = pc.cd_produto and
                                              custo.CodFaseProduto = @cd_fase_produto_comercial

    --------------------------------------------------------------------------
    -- Atualiza a Produto_Fechamento
    --------------------------------------------------------------------------
    update Produto_Fechamento
    set vl_custo_prod_fechamento = custo.ValorCusto
    from Produto_Fechamento pf with(nolock)
      inner join #ProdutoPadraoVenda custo on custo.CodProduto = pf.cd_produto and
                                              custo.CodFaseProduto = pf.cd_fase_produto
    where pf.dt_produto_fechamento between @dt_inicial and @dt_final

    --------------------------------------------------------------------------
    -- Atualiza a Produto_Saldo
    --------------------------------------------------------------------------
    update Produto_Saldo
    set vl_custo_contabil_produto = custo.CustoUnitario
    from Produto_Saldo ps with(nolock)
      inner join #ProdutoPadraoVenda custo on custo.CodProduto = ps.cd_produto and 
                                              custo.CodFaseProduto = ps.cd_fase_produto
        
  end

  select FaseProduto, Mascara, Fantasia, Produto, UN, Referencia,
    DataReferencia, Preco, CustoUnitario, Qtde, ValorCusto
  from #ProdutoPadraoVenda
  order by 1, 2

  drop table #ProdutoPadraoVenda

end

