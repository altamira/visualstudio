
create procedure pr_grava_geracao_contabilizacao_nota_saida

@cd_nota_saida            int, 
@cd_item_nota_saida       int,
@dt_nota_saida            datetime,
@vl_contab_nota_saida     float,   
@nm_atributo              varchar(25),
@cd_produto               int,
@cd_grupo_produto         int,
@cd_tipo_mercado          int,
@cd_conta_debito          int,
@cd_conta_credito         int,
@nm_historico_nota_saida  varchar(40),
@cd_tipo_destinatario     int,
@cd_cliente               int, 
@nm_fantasia_destinatario varchar(15),
@cd_operacao_fiscal       int,
@cd_usuario               int,
@cd_categoria_produto     int, --Usado somente para notas de pedido de venda SMO.
@qt_lancamento_gerado     int output         

as

-- print 'Entrou na rotina de gravação'

declare @cd_lancamento_padrao      int
declare @cd_historico_contabil     int
declare @cd_lote_contabil          int
declare @nm_tabela                 varchar(50)
declare @vl_ipi                    float
declare @vl_icms                   float
declare @vl_nota_saida             float

-- print('@cd_grupo_produto '+cast(@cd_grupo_produto as varchar))

set @cd_historico_contabil     = 0
set @cd_lote_contabil          = 0

-- Nome da Tabela usada na geração e liberação de códigos
set @nm_tabela = cast((select top 1 nm_banco_empresa
                       from egisadmin.dbo.empresa
                       where cd_empresa = dbo.fn_empresa()) +
                       '.dbo.Nota_Saida_Contabil' as varchar(50))


--Atualiza as variáveis de valor

--Valor Total da Nota

if @nm_atributo = 'cd_nota_saida' 
   set @vl_nota_saida = isNull(@vl_contab_nota_saida ,0)
else 
   set @vl_nota_saida = 0

-- Valor do ICMS

if @nm_atributo = 'vl_icms_item_nota_saida'
   set @vl_icms = isNull(@vl_contab_nota_saida ,0)
else 
   set @vl_icms = 0

-- Valor do IPI
 
if @nm_atributo = 'vl_ipi_item_nota_saida'
   set @vl_ipi = isNull(@vl_contab_nota_saida ,0)
else 
   set @vl_ipi = 0


--===================================
-- Verifica se a operação fiscal definida para o item da nota
-- não possui uma contabilização própria
--===================================

if not exists(Select top 1 'x'
              from operacao_fiscal_contabilizacao
              where cd_operacao_fiscal = @cd_operacao_fiscal)
begin

--   print 'A CFOP não possui contabilização própria'

  -------------------------------
  --Caso seja PRODUTO 'NORMAL'
  -------------------------------
  if (IsNull(@cd_produto,0) <> 0) 
  begin

--     print 'É um produto "normal"'

    select top 1
      @cd_lancamento_padrao  = IsNull(lp.cd_lancamento_padrao, -1),
      @cd_historico_contabil = lp.cd_historico_contabil,
      @cd_conta_debito       = case when lp.cd_conta_debito>0  then lp.cd_conta_debito  else @cd_conta_debito  end,
      @cd_conta_credito      = case when lp.cd_conta_credito>0 then lp.cd_conta_credito else @cd_conta_credito end,
      @cd_lote_contabil      = lp.cd_lote_contabil_padrao
    from
      lancamento_padrao lp

      left outer join Produto_Contabilizacao pc
      on   pc.cd_lancamento_padrao=lp.cd_lancamento_padrao

      left outer join tipo_contabilizacao tc
      on   tc.cd_tipo_contabilizacao = pc.cd_tipo_contabilizacao
    where
      tc.nm_atributo     = @nm_atributo and
      pc.cd_produto      = @cd_produto  and
      pc.cd_tipo_mercado = @cd_tipo_mercado
						
  end
  else
  --------------------------------
  --Caso seja PRODUTO 'ESPECIAL'
  --------------------------------
  begin

--     print 'É um produto "Especial"'
-- 
--     print 'Operação fiscal:' + convert( varchar, @cd_operacao_fiscal )
--     print 'Atributo:' + @nm_atributo
--     print 'Tipo de Mercado:' + convert( varchar, @cd_tipo_mercado )
--     print 'Lançamento Padrão:' + convert( varchar, @cd_lancamento_padrao )

    --Tratamento para notas provenientes de pedidos SMO
    if exists(Select top 1 'x'
              from Servico_Contabilizacao
              where cd_grupo_produto = @cd_grupo_produto)
    begin

--       print 'É do grupo SMO'

      --Define as informações dos lançamentos contábeis
      --em função do grupo especial do SMO

      select top 1
        @cd_lancamento_padrao  = IsNull(lp.cd_lancamento_padrao,-1),
        @cd_historico_contabil = lp.cd_historico_contabil,
        @cd_conta_debito       = case when lp.cd_conta_debito>0  then lp.cd_conta_debito  else @cd_conta_debito  end,
        @cd_conta_credito      = case when lp.cd_conta_credito>0 then lp.cd_conta_credito else @cd_conta_credito end,
        @cd_lote_contabil      = lp.cd_lote_contabil_padrao
      from
        lancamento_padrao lp

        inner join Servico_Contabilizacao sc
        on    sc.cd_lancamento_padrao=lp.cd_lancamento_padrao

        inner join tipo_contabilizacao tc
        on    tc.cd_tipo_contabilizacao = sc.cd_tipo_contabilizacao
      where
        tc.nm_atributo          = @nm_atributo and
        sc.cd_grupo_produto     = @cd_grupo_produto and
        sc.cd_tipo_mercado      = @cd_tipo_mercado and
        sc.cd_categoria_produto = @cd_categoria_produto

    end
    else
    begin

--       print @nm_atributo
--       print cast(@cd_grupo_produto as varchar)
--       print cast(@cd_tipo_mercado as varchar)      

      select top 1
        @cd_lancamento_padrao  = IsNull(lp.cd_lancamento_padrao,-1),
        @cd_historico_contabil = lp.cd_historico_contabil,
        @cd_conta_debito       = case when lp.cd_conta_debito>0  then lp.cd_conta_debito  else @cd_conta_debito  end,
        @cd_conta_credito      = case when lp.cd_conta_credito>0 then lp.cd_conta_credito else @cd_conta_credito end,
        @cd_lote_contabil      = lp.cd_lote_contabil_padrao
      from
        lancamento_padrao lp

        left outer join Grupo_Produto_Contabilizacao gpc
        on   gpc.cd_lancamento_padrao=lp.cd_lancamento_padrao

        left outer join tipo_contabilizacao tc
        on   tc.cd_tipo_contabilizacao = gpc.cd_tipo_contabilizacao
      where
        tc.nm_atributo       = @nm_atributo and
        gpc.cd_grupo_produto = @cd_grupo_produto and
        gpc.cd_tipo_mercado  = @cd_tipo_mercado
    end
  end

--   print 'Operação fiscal:' + convert( varchar, @cd_operacao_fiscal )
--   print 'Atributo:' + @nm_atributo
--   print 'Tipo de Mercado:' + convert( varchar, @cd_tipo_mercado )
--   print 'Lançamento Padrão:' + convert( varchar, @cd_lancamento_padrao )

end
else
--===================================
--Contabilização Própria da CFOP
--===================================
begin

--   print 'A CFOP POSSUI contabilização própria'

  select top 1
    @cd_lancamento_padrao  = IsNull(lp.cd_lancamento_padrao,-1),
    @cd_historico_contabil = lp.cd_historico_contabil,
    @cd_conta_debito       = case when lp.cd_conta_debito>0  then lp.cd_conta_debito  else @cd_conta_debito  end,
    @cd_conta_credito      = case when lp.cd_conta_credito>0 then lp.cd_conta_credito else @cd_conta_credito end,
    @cd_lote_contabil      = lp.cd_lote_contabil_padrao
  from
    Lancamento_padrao lp

    left outer join Operacao_Fiscal_Contabilizacao opc
    on   opc.cd_lancamento_padrao=lp.cd_lancamento_padrao

    left outer join tipo_contabilizacao tc
    on   tc.cd_tipo_contabilizacao = opc.cd_tipo_contabilizacao
  where
    tc.nm_atributo          = @nm_atributo and
    opc.cd_operacao_fiscal  = @cd_operacao_fiscal and
    opc.cd_tipo_mercado     = @cd_tipo_mercado

--   print 'Operação fiscal:' + convert( varchar, @cd_operacao_fiscal )
--   print 'Atributo:' + @nm_atributo
--   print 'Tipo de Mercado:' + convert( varchar, @cd_tipo_mercado )
--   print 'Lançamento Padrão:' + convert( varchar, @cd_lancamento_padrao )

end

--===================================
-- Checa os parâmetros para validar a inserção
--===================================

--  if ((@cd_conta_credito      is not null) or
--      (@cd_conta_debito       is not null))
--      and (@cd_historico_contabil is not null)   
      --and (@cd_lancamento_padrao  is not null)

if (@cd_lancamento_padrao > 0) or (@qt_lancamento_gerado = -1)
begin


--   print 'Pegar próximo número para o registro'

  -- pegar a chave primária da tabela  
  exec EgisADMIN.dbo.sp_PegaCodigo
         @nm_tabela,
         'cd_item_contab_nota_saida',
         @codigo = @cd_item_nota_saida output
    
--   print 'Gravar usando o lançamento padrão ' + convert( varchar, @cd_lancamento_padrao )

  Insert into Nota_Saida_Contabil
    ( cd_nota_saida,
      cd_item_contab_nota_saida,
      dt_contab_nota_Saida,
      cd_lancamento_padrao,
      cd_conta_credito,
      cd_conta_debito,
      vl_contab_nota_saida,
      vl_icms_nota_saida,
      vl_ipi_nota_saida,
      cd_historico_contabil,
      nm_historico_nota_saida,
      ic_sct_contab_nota_saida,
      cd_tipo_destinatario,
      cd_cliente,
      nm_fantasia_destinatario,
      cd_operacao_fiscal,
      cd_usuario,
      dt_usuario )  
  Values
    ( @cd_nota_saida,
      @cd_item_nota_saida,
      @dt_nota_saida,
      @cd_lancamento_padrao,
      @cd_conta_credito,   
      @cd_conta_debito, 
      @vl_nota_saida,
      @vl_icms, 
      @vl_ipi, 
      @cd_historico_contabil,        
      @nm_historico_nota_saida,
      'N',
      @cd_tipo_destinatario,
      @cd_cliente,
      @nm_fantasia_destinatario,
      @cd_operacao_fiscal,
      @cd_usuario,
      getdate() )
        
  set @qt_lancamento_gerado = 1 --Define que foi gerado um lançamento 


--   print 'Liberar o número usado pelo registro'

  -- liberação do código gerado p/ PegaCodigo
  exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_item_nota_saida, 'D'

end
else
begin

  set @qt_lancamento_gerado = 0 --Define que não foi gerado lançamento

end

