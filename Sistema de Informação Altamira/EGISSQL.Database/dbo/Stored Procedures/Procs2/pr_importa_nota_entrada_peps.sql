
CREATE PROCEDURE pr_importa_nota_entrada_peps
@dt_inicial datetime,
@dt_final   datetime
AS

  set nocount on

  begin transaction

  declare @ic_ipi_custo_produto char(1)

  --Define se para as Notas de Entradas pelo Recebimento o IPI é incluso
  select 
    top 1 @ic_ipi_custo_produto = IsNull(ic_ipi_custo_produto,'N') 
  from 
    Parametro_Custo 
  where   
    cd_empresa = dbo.fn_empresa()

  --Limpando a tabela Nota_Entrada_PEPS
  delete
    nota_entrada_peps
  where 
    dt_documento_entrada_peps between @dt_inicial and @dt_final and
    IsNull(ic_tipo_lancamento,'A') = 'A' --Lançamento Automático

  print 'Tabela Nota_Entrada_PEPS Limpa'

  --Tabela temporária com todas as invoices para rateio
  select
    distinct ltrim(rtrim(nsi.nm_invoice)) as nm_invoice,
    ofi.cd_mascara_operacao
  into
    #Invoice
  from
    Nota_Saida_Item 	nsi,
    Nota_Saida 		ns,
    Operacao_Fiscal     ofi
  where
    ns.cd_nota_saida 	= nsi.cd_nota_saida 	and
    ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
    ltrim(rtrim(IsNull(nsi.nm_invoice,''))) <> '' and
    ns.dt_nota_saida 	between @dt_inicial and @dt_final and
    ns.dt_cancel_nota_saida is null and
    isnull(nsi.cd_produto,0) > 0
  order by 1

  print 'Tabela emporária com todas as invoices'

  --**********************************************************************************************************
  --Gera os Lançamentos na Tabela de Nota_Entrada_PEPS prevenientes do Faturamento****************************
  --**********************************************************************************************************


  --Tabela temporária com todas as invoices de notas complementares e valores do período
  select 
    ltrim(rtrim(substring(ns.ds_obs_compl_nota_saida, charindex('INVOICE', ns.ds_obs_compl_nota_saida) + 8, abs(charindex('DI',ns.ds_obs_compl_nota_saida) - (charindex('INVOICE', ns.ds_obs_compl_nota_saida) + 8))))) as nm_invoice,
    ltrim(rtrim(substring(ns.ds_obs_compl_nota_saida, (charindex('DI', ns.ds_obs_compl_nota_saida) + 3), 13))) as nm_di,
    ofi.cd_mascara_operacao,
    ns.vl_total
  into
    #Invoice_Complementar
  from 
    nota_saida ns,
    operacao_fiscal ofi,
    grupo_operacao_fiscal gof
  where 
    ns.cd_operacao_fiscal 		= ofi.cd_operacao_fiscal 	and
    ofi.cd_grupo_operacao_fiscal 	= gof.cd_grupo_operacao_fiscal 	and
    isnull(ofi.ic_complemento_op_fiscal,'N') = 'S' 			and
    gof.cd_tipo_operacao_fiscal 	= 1 				and --Entrada 
    ns.dt_nota_saida 			between @dt_inicial and @dt_final

  print 'Tabela temporária com todas as invoices complementares e valores'

  --Tabela temporária com todas as invoices e valores para rateio para serem incluídas na tabela nota_entrada_peps
  select
    i.nm_invoice,
    i.cd_mascara_operacao,
    c.vl_total as vl_total_complementar
  into
    #Invoice_Valor
  from
    #Invoice i,
    #Invoice_Complementar c
  where
    ltrim(rtrim(i.nm_invoice)) *= ltrim(rtrim(c.nm_invoice)) and
    i.cd_mascara_operacao *= c.cd_mascara_operacao

  print 'Tabela com valores para rateio'

  --Variáveis para guardar dados da nota complementar
  declare @cd_nota_complementar		int
  declare @nm_invoice 			varchar(50)
  declare @cd_mascara_operacao		varchar(10)
  declare @vl_total_complementar	float

  --Lendo cada invoice e ratear valor dela para cada nota amarrada a ela
  while exists(select 1 from #Invoice_Valor)
  begin

    --Pegando invoice e valor da nota complementar para rateio
    select
      top 1
      @nm_invoice 		= ltrim(rtrim(nm_invoice)),
      @cd_mascara_operacao      = ltrim(rtrim(cd_mascara_operacao)),
      @vl_total_complementar	= isnull(vl_total_complementar,0)
    from
      #Invoice_Valor

    print @nm_invoice
    print @cd_mascara_operacao

    --Verificando se existe valor para executar o rateio
    if @vl_total_complementar > 0
    begin
      --Buscando notas para rateio
      select
        distinct ns.cd_nota_saida
      into
        #Nota_Rateio
      from
        nota_saida_item nsi,
        nota_saida 	ns,
        operacao_fiscal ofi
      where
        nsi.cd_nota_saida = ns.cd_nota_saida and
        ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
        ltrim(rtrim(nsi.nm_invoice)) = @nm_invoice and
        ltrim(rtrim(ofi.cd_mascara_operacao)) = @cd_mascara_operacao and
        isnull(nsi.cd_produto,0) > 0

      --Varrendo todas as notas da invoice e fazendo o rateio do valor da nota complementar
      while exists (select 1 from #Nota_Rateio)
      begin
        select
          top 1
          @cd_nota_complementar = cd_nota_saida
        from
          #Nota_Rateio


        print @cd_nota_complementar        

        --Calculando o rateio e inserindo na tabela #Nota_Entrada_PEPS
        insert into nota_entrada_peps
        (
         cd_movimento_estoque,
         cd_fase_produto,
         cd_produto,
         cd_fornecedor,
         cd_documento_entrada_peps,
         cd_item_documento_entrada,
         qt_entrada_peps,
         vl_preco_entrada_peps,
         vl_custo_total_peps,
         --qt_valorizacao_peps
         --vl_custo_valorizacao_peps
         --vl_fob_entrada_peps
         cd_usuario,
         dt_usuario,
         dt_documento_entrada_peps,
         --cd_controle_nota_entrada
         --dt_controle_nota_entrada
         ic_tipo_lancamento
        )
        select 
          me.cd_movimento_estoque,
          me.cd_fase_produto,
          nsi.cd_produto,
          ns.cd_cliente,
          ns.cd_nota_saida,
          nsi.cd_item_nota_saida,

          --Convertendo quantidade
          case when isnull(p.vl_fator_conversao_produt,0) <> 0 then 
            nsi.qt_item_nota_saida * p.vl_fator_conversao_produt
          else
            nsi.qt_item_nota_saida
          end,

          --Convertendo valor unitário com o rateio na nota complementar
          case when isnull(p.vl_fator_conversao_produt,0) <> 0 then 
            ((@vl_total_complementar /  
            (select 
               sum(nsi.vl_total_item)
             from
               nota_saida_item nsi,
               nota_saida 	ns,
               operacao_fiscal ofi
             where
               nsi.cd_nota_saida = ns.cd_nota_saida and
               ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
               ltrim(rtrim(nsi.nm_invoice)) = @nm_invoice and
               ltrim(rtrim(ofi.cd_mascara_operacao)) = @cd_mascara_operacao and
               isnull(nsi.cd_produto,0) > 0) * nsi.vl_total_item
             +
             nsi.vl_total_item) / nsi.qt_item_nota_saida) / p.vl_fator_conversao_produt
          else
            ((@vl_total_complementar /  
            (select 
               sum(nsi.vl_total_item)
             from
               nota_saida_item nsi,
               nota_saida 	ns,
               operacao_fiscal ofi
             where
               nsi.cd_nota_saida = ns.cd_nota_saida and
               ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
               ltrim(rtrim(nsi.nm_invoice)) = @nm_invoice and
               ltrim(rtrim(ofi.cd_mascara_operacao)) = @cd_mascara_operacao and
               isnull(nsi.cd_produto,0) > 0) * nsi.vl_total_item
             +
             nsi.vl_total_item) / nsi.qt_item_nota_saida)
          end,

          --Calculando total do item considerando rateio da nota complementar
          ((@vl_total_complementar /  
            (select 
               sum(nsi.vl_total_item)
             from
               nota_saida_item nsi,
               nota_saida 	ns,
               operacao_fiscal ofi
             where
               nsi.cd_nota_saida = ns.cd_nota_saida and
               ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
               ltrim(rtrim(nsi.nm_invoice)) = @nm_invoice and
               ltrim(rtrim(ofi.cd_mascara_operacao)) = @cd_mascara_operacao and
               isnull(nsi.cd_produto,0) > 0) * nsi.vl_total_item
           +
           nsi.vl_total_item) / nsi.qt_item_nota_saida) * nsi.qt_item_nota_saida,
           
           1,
           getdate(),
           ns.dt_nota_saida,
           'A'
        from 
          nota_saida_item 	nsi,
          nota_saida		ns,
          operacao_fiscal	ofi,
          produto 		p,
          movimento_estoque me
        where 
          ns.cd_nota_saida	= nsi.cd_nota_saida   	and
          nsi.cd_produto	= p.cd_produto		and
          ltrim(rtrim(nsi.nm_invoice)) 	= @nm_invoice 		and
          ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
          ofi.cd_mascara_operacao = @cd_mascara_operacao and
          nsi.cd_nota_saida 	= @cd_nota_complementar and
          ns.dt_nota_saida 	between @dt_inicial and @dt_final and
          isnull(nsi.cd_produto,0) > 0 and
          nsi.cd_produto 		  = me.cd_produto 		and
          cast(nsi.cd_nota_saida as varchar)  = me.cd_documento_movimento	and
          nsi.cd_item_nota_saida = me.cd_item_documento and
          me.cd_tipo_movimento_estoque not in (10,12,13) and --Desconsidera os movimentos de cancelamento e devolução
          not exists(Select 'x' from nota_entrada_peps where cd_movimento_estoque = me.cd_movimento_estoque)

        delete
          #Nota_Rateio
        where
          cd_nota_saida = @cd_nota_complementar          
      end

      drop table #Nota_Rateio
    end
    else
    begin
      --Buscando notas com o mesmo invoice para incluir na tabela Nota_Entrada_PEPS
      --Estas notas não possuem nota complementar, então será inclúido o valor de custo o valor que veio na nota

      insert into nota_entrada_peps
      (
       cd_movimento_estoque,
       cd_fase_produto,
       cd_produto,
       cd_fornecedor,
       cd_documento_entrada_peps,
       cd_item_documento_entrada,
       qt_entrada_peps,
       vl_preco_entrada_peps,
       vl_custo_total_peps,
       --qt_valorizacao_peps
       --vl_custo_valorizacao_peps
       --vl_fob_entrada_peps
       cd_usuario,
       dt_usuario,
       dt_documento_entrada_peps,
       --cd_controle_nota_entrada
       --dt_controle_nota_entrada
       ic_tipo_lancamento
     )
     select
       me.cd_movimento_estoque,
       me.cd_fase_produto,
       nsi.cd_produto,
       ns.cd_cliente,
       nsi.cd_nota_saida,
       nsi.cd_item_nota_saida,
       --Convertendo quantidade
       case when isnull(p.vl_fator_conversao_produt,0) <> 0 then 
         nsi.qt_item_nota_saida * p.vl_fator_conversao_produt
       else
         nsi.qt_item_nota_saida
       end,
       --Convertendo valor unitário
       case when isnull(p.vl_fator_conversao_produt,0) <> 0 then 
         nsi.vl_unitario_item_nota / p.vl_fator_conversao_produt
       else
         nsi.vl_unitario_item_nota
       end,
       nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota,
       1,
       getdate(),
       ns.dt_nota_saida,
       'A'
     from
       nota_saida_item 	nsi,
       nota_saida	ns,
       operacao_fiscal	ofi,
       produto		p,
       movimento_estoque me
     where
       ns.cd_nota_saida = nsi.cd_nota_saida 	and
       nsi.cd_produto   = p.cd_produto		and
       ltrim(rtrim(nsi.nm_invoice))   = @nm_invoice		and
       ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
       ofi.cd_mascara_operacao = @cd_mascara_operacao and       
       ns.dt_nota_saida between @dt_inicial and @dt_final and
       isnull(nsi.cd_produto,0) > 0 and
       nsi.cd_produto 		  = me.cd_produto 		and
       cast(nsi.cd_nota_saida as varchar)  = me.cd_documento_movimento	and
       nsi.cd_item_nota_saida = me.cd_item_documento and
       me.cd_tipo_movimento_estoque not in (10,12,13) and --Desconsidera os movimentos de cancelamento e devolução
       not exists(Select 'x' from nota_entrada_peps where cd_movimento_estoque = me.cd_movimento_estoque)
    end 


    delete 
      #Invoice_Valor
    where  
      ltrim(rtrim(nm_invoice)) = @nm_invoice and
      ltrim(rtrim(cd_mascara_operacao)) = @cd_mascara_operacao
  end

  --Colocando custo de entrada nos movimentos de estoque
--   update
--     Movimento_Estoque
--   set
--     vl_custo_contabil_produto = nep.vl_preco_entrada_peps
--   from
--     Movimento_Estoque me  inner join
--     Nota_Entrada_PEPS nep on me.cd_movimento_estoque = nep.cd_movimento_estoque
--   where
--     me.dt_movimento_estoque between @dt_inicial and @dt_final


  --**********************************************************************************************************
  --Gera os Lançamentos na Tabela de Nota_Entrada_PEPS prevenientes do Recebimento****************************
  --**********************************************************************************************************

print 'Recebimento...'

  Insert into nota_entrada_peps
  (
    cd_movimento_estoque,
    cd_produto,
    cd_fornecedor,
    cd_documento_entrada_peps,
    cd_item_documento_entrada,
    qt_entrada_peps,
    vl_preco_entrada_peps,
    vl_custo_total_peps,     
    qt_valorizacao_peps,
    cd_usuario,
    dt_usuario,
    dt_documento_entrada_peps,
    cd_fase_produto,
    dt_controle_nota_entrada,
    cd_controle_nota_entrada,
    vl_custo_valorizacao_peps,
    vl_fob_entrada_peps
  )
  Select 
    me.cd_movimento_estoque,
    nei.cd_produto,
    nei.cd_fornecedor,
    nei.cd_nota_entrada,      --cd_documento_entrada_peps
    nei.cd_item_nota_entrada, --cd_item_documento_entrada
    nei.qt_item_nota_entrada, --qt_entrada_peps
    -- ELIAS 04/06/2004 - é necessário dividir pela quantidade
    -- para encontrar o custo unitário
    ((case @ic_ipi_custo_produto 
      when 'S' then
        isnull(nei.vl_total_nota_entr_item,0)
        + IsNull(nei.vl_ipi_nota_entrada,0)
        - IsNull(nei.vl_icms_nota_entrada,0)
      else
        -- ELIAS 21/07/2004 - DEDUZIR O ICMS
        isnull(nei.vl_total_nota_entr_item,0)
        - isnull(nei.vl_icms_nota_entrada,0)
     end
    ) / isnull(nei.qt_item_nota_entrada,1)) as vl_preco_entrada_peps, --vl_preco_entrada_peps    
    -- ELIAS 04/06/2004 - Utilizar o valor Total para o Custo total
    -- quando o IPI não entrar no Custo
    (case @ic_ipi_custo_produto 
      when 'S' then
        isnull(nei.vl_total_nota_entr_item,0)
        + IsNull(nei.vl_ipi_nota_entrada,0)
        - IsNull(nei.vl_icms_nota_entrada,0)
      else
        -- ELIAS 21/07/2004 - DEDUZIR O ICMS
        isnull(nei.vl_total_nota_entr_item,0)
        - isnull(nei.vl_icms_nota_entrada,0)
     end
    ) as vl_custo_total_peps, --vl_custo_total_peps      
    nei.qt_item_nota_entrada, -- qt_valorizacao_peps
    1 as cd_usuario, --cd_usuario
    getdate() as dt_usuario, --dt_usuario
    ne.dt_receb_nota_entrada, --dt_documento_entrada_peps
    me.cd_fase_produto, -- cd_fase_produto
    ne.dt_receb_nota_entrada, --dt_controle_nota_entrada
    0,--cd_controle_nota_entrada
    0,--vl_custo_valorizacao_peps
    0 --vl_fob_entrada_peps
  From 
    Nota_Entrada ne,
    Nota_Entrada_Item 	nei,
    Operacao_Fiscal     ofi,
    Movimento_Estoque me
  where
    ne.dt_nota_entrada 	between @dt_inicial and @dt_final and
    ne.cd_nota_entrada = nei.cd_nota_entrada and
    ne.cd_fornecedor = nei.cd_fornecedor and
    ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
    nei.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
    me.cd_tipo_movimento_estoque = 1 and
    me.cd_tipo_documento_estoque = 3 and
    me.cd_documento_movimento = ne.cd_nota_entrada and
    me.cd_item_documento = nei.cd_item_nota_entrada and
    me.cd_fornecedor = ne.cd_fornecedor and
    -- ELIAS 22/07/2004
    -- me.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
    me.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    not exists(Select 'x' from Nota_Entrada_PEPS where cd_movimento_estoque = me.cd_movimento_estoque)

print 'Estoque...'

--**********************************************************************************************************
--Gera os Lançamentos na Tabela de Nota_Entrada_PEPS dos Movimentos de Estoque  ****************************
--**********************************************************************************************************
  Insert into nota_entrada_peps
  (
    cd_movimento_estoque,
    cd_produto,
    cd_fornecedor,
    cd_documento_entrada_peps,
    cd_item_documento_entrada,
    qt_entrada_peps,
    vl_preco_entrada_peps,
    vl_custo_total_peps,     
    qt_valorizacao_peps,
    cd_usuario,
    dt_usuario,
    dt_documento_entrada_peps,
    cd_fase_produto,
    dt_controle_nota_entrada,
    cd_controle_nota_entrada,
    vl_custo_valorizacao_peps,
    vl_fob_entrada_peps
  )
  Select 
    me.cd_movimento_estoque,
    me.cd_produto,
    me.cd_fornecedor,
    IsNull(me.cd_documento_movimento,1),      --cd_documento_entrada_peps
    IsNull(me.cd_item_documento,1), --cd_item_documento_entrada

    -- LUDINEI 22/07/2004
    me.qt_movimento_estoque, --qt_entrada_peps
    IsNull(me.vl_unitario_movimento,0), ---custo_contabil_produto,0), --vl_preco_entrada_peps    
    me.qt_movimento_estoque * IsNull(me.vl_unitario_movimento,0), -- custo_contabil_produto,0), --vl_custo_total_peps  

    me.qt_movimento_estoque, -- qt_valorizacao_peps
    1 as cd_usuario, --cd_usuario
    getdate() as dt_usuario, --dt_usuario
    me.dt_movimento_estoque, --dt_documento_entrada_peps
    me.cd_fase_produto, -- cd_fase_produto
    me.dt_movimento_estoque, --dt_controle_nota_entrada
    0,--cd_controle_nota_entrada
    me.vl_custo_contabil_produto,--vl_custo_valorizacao_peps
    0 --vl_fob_entrada_peps
  From 
    Movimento_Estoque me
  where
    me.dt_movimento_estoque	between @dt_inicial and @dt_final and
    cd_tipo_movimento_estoque in (1,5) and
    not exists(Select 'x' from Nota_Entrada_PEPS where cd_movimento_estoque = me.cd_movimento_estoque)

  delete from nota_entrada_peps where IsNull(cd_produto,0) = 0 and dt_documento_entrada_peps between @dt_inicial and @dt_final

  if @@Error <> 0
    rollback transaction
  else
    commit transaction

  set nocount off
