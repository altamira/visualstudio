

create procedure pr_gera_contabilizacao_nota_entrada

@cd_nota_entrada      int,     -- Código da Nota de Entrada
@cd_item_nota_entrada int,     -- Código do Item da Nota de Entrada
@ic_tipo_atualizacao  char(1), -- Manual / Automatica
@cd_usuario           int      -- Usuário

as


declare @dt_nota_entrada              datetime
declare @cd_produto                   int
declare @cd_grupo_produto             int
declare @cd_categoria_produto	      int
declare @vl_contab_nota_entrada       money
declare @cd_conta_debito              int
declare @cd_conta_credito             int
declare @cd_historico_contabil        int
declare @vl_item_nota_entrada         money
declare @vl_ipi_item                  money
declare @vl_icms_item                 money
declare @ic_razao_fornecedor_empresa  char(1)
declare @cd_conta_fornecedor          int
declare @cd_fornecedor                int
declare @cd_operacao_fiscal           int
declare @cd_tipo_mercado              int
declare @nm_atributo                  varchar(25)
declare @nm_historico_nota_entrada    varchar(40)
declare @nm_fantasia_destinatario     varchar(15)
declare @ic_simples_fornecedor        char(1) 
declare @qt_lancamento_gerado_count   int --Define que gerou lançamento
declare @qt_lancamento_gerado         int --Enviar o parametro
declare @cd_conta_padrao              int --Plano de conta do Fornecedor

set @cd_conta_debito       = 0
set @cd_conta_credito      = 0
set @cd_historico_contabil = 0

set @nm_atributo                 = ''
set @nm_historico_nota_entrada   = ''
set @nm_fantasia_destinatario    = ''
   
-- Seleciona o documento para contabilização

select top 1
  @cd_nota_entrada        = ne.cd_nota_entrada,
  @cd_item_nota_entrada   = isnull(nei.cd_item_nota_entrada,0),
  @dt_nota_entrada        = ne.dt_nota_entrada,
  @cd_produto             = isnull(nei.cd_produto,0),
  @cd_grupo_produto       = isnull(p.cd_grupo_produto,0),
  @cd_categoria_produto   = isnull( (Select top 1 cd_categoria_produto
                                     from Pedido_Compra_Item
                                     where cd_pedido_compra = nei.cd_pedido_compra and
                                           cd_item_pedido_compra = nei.cd_item_pedido_compra),
                                    isnull(p.cd_categoria_produto,0) ),

  @vl_item_nota_entrada   =   /* Operações de Serviço */                             
                             case when (isnull(op.ic_servico_operacao,'N')='S') and (isnull(nei.ic_tipo_nota_entrada_item,'P')='S') then
                               (isnull(nei.qt_item_nota_entrada,1) * isnull(nei.vl_item_nota_entrada,0))
                             else 
                               /* Devolução de Matéria Prima */
                               case when (isnull(op.ic_devmp_operacao_fiscal,'N')='S') then
                                 /* Se não existir item */
                                 case when (nei.cd_nota_entrada is not null) then 
                                   isnull(nei.vl_total_nota_entr_item,0) + 
                                   isnull(nei.vl_ipiobs_nota_entrada,0) 
                                 else 
                                   isnull(ne.vl_total_nota_entrada,0)
                                 end
                               else
                                 /* Produtos */ 
                                 case when (nei.cd_nota_entrada is not null) then 
                                   isnull(nei.vl_total_nota_entr_item,0) + 
                                   isnull(nei.vl_ipi_nota_entrada,0)
                                 else 
                                   isnull(ne.vl_total_nota_entrada,0)
                                 end 
                               end
                             end,

  @vl_ipi_item            = case when (isnull(op.ic_devmp_operacao_fiscal,'N')='S') then
  		 	      case when (nei.cd_nota_entrada is not null) 
                              then isnull(nei.vl_ipiobs_nota_entrada,0)
                              else isnull(nei.vl_ipi_nota_entrada,0)
                              end
                            else 
                              case when (nei.cd_nota_entrada is not null) 
                              then isnull(nei.vl_ipi_nota_entrada,0)
                              else isnull(ne.vl_ipi_nota_entrada,0)
                              end 
                            end, 

  @vl_icms_item           = case when (nei.cd_nota_entrada is not null) 
                            then isnull(nei.vl_ipi_nota_entrada,0)
                            else isnull(ne.vl_icms_nota_entrada,0)
                            end,

  @cd_fornecedor          = ne.cd_fornecedor,

  @cd_operacao_fiscal     = case when isnull(nei.cd_operacao_fiscal,0)>0
                            then nei.cd_operacao_fiscal
                            else ne.cd_operacao_fiscal
                            end,

  @cd_tipo_mercado        = ( select top 1 cd_tipo_mercado from Fornecedor where ne.cd_fornecedor=cd_fornecedor),

  @nm_fantasia_destinatario = f.nm_fantasia_fornecedor,

  @cd_conta_fornecedor    = ( select top 1 cd_conta from Fornecedor where ne.cd_fornecedor=cd_fornecedor),
  @ic_simples_fornecedor  = isnull(ic_simples_fornecedor,'N')
from
  nota_entrada ne

  left outer join nota_entrada_item nei  on   nei.cd_nota_entrada      = ne.cd_nota_entrada and
                                              nei.cd_item_nota_entrada = @cd_item_nota_entrada
  left outer join operacao_fiscal op     on   op.cd_operacao_fiscal    = nei.cd_operacao_fiscal
  left outer join fornecedor f           on   f.cd_fornecedor          = ne.cd_fornecedor
  left outer join produto p              on   p.cd_produto             = nei.cd_produto

where
  ne.cd_nota_entrada = @cd_nota_entrada


--Checa o Parâmetro Contabil para saber se a Contabilização :
--Única ou por Fornecedor

select top 1
  @ic_razao_fornecedor_empresa = isnull(ic_razao_cliente_empresa,'N'),
  @cd_conta_padrao             = isnull(cd_conta_cliente,0)
from
  Parametro_Financeiro
where
  cd_empresa = dbo.fn_empresa() -- funcao que pega a empresa automaticamente.


--Checa se o código contábil é por fornecedor
if @ic_razao_fornecedor_empresa = 'S'
   set @cd_conta_fornecedor = isnull(@cd_conta_padrao,0)


--Define que foi gerado algum lançamento
set @qt_lancamento_gerado_count = 0

--------------------------------------------------------
-- Contabilizar o valor do ICMS se existir
--------------------------------------------------------
if isnull(@vl_icms_item,0) > 0 
begin

  print 'Tentar contabilizar ICMS no valor de ' + convert( varchar, @vl_icms_item )

  set @vl_contab_nota_entrada    = @vl_icms_item
  set @nm_atributo               = 'vl_icms_item_nota_entrada' --Verificar no Cadastro de Tipo de Contabilização
  set @cd_conta_debito           = 0
  set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario

  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          @qt_lancamento_gerado OUTPUT

   --Define a quantidade de lançamentos gerados
   set @qt_lancamento_gerado_count =
          @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)

end


--------------------------------------------------------
-- Contabilizar o valor do IPI se existir
--------------------------------------------------------
if isnull(@vl_ipi_item,0) > 0
begin

  print 'Tentar contabilizar IPI no valor de ' + convert( varchar, @vl_ipi_item )

  set @vl_contab_nota_entrada    = @vl_ipi_item
  set @nm_atributo               = 'vl_ipi_item_nota_entrada' --Verificar no Cadastro de Tipo de Contabilização
  set @cd_conta_debito           = 0
  set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario

  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          @qt_lancamento_gerado OUTPUT

   --Define a quantidade de lançamentos gerados
   set @qt_lancamento_gerado_count =
          @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)

end


--------------------------------------------------------
-- Contabilizar o valor da Nota de Saída
--------------------------------------------------------
if isnull(@vl_item_nota_entrada,0) > 0
begin

  print 'Tentar contabilizar Nota no valor de ' + convert( varchar, @vl_item_nota_entrada )

  set @vl_contab_nota_entrada    = @vl_item_nota_entrada
  set @nm_atributo               = 'cd_nota_entrada'
  set @cd_conta_debito           = 0
  set @cd_conta_credito          = @cd_conta_fornecedor
  set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario

  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          @qt_lancamento_gerado OUTPUT

   --Define a quantidade de lançamentos gerados
   set @qt_lancamento_gerado_count =
          @qt_lancamento_gerado_count + IsNull(@qt_lancamento_gerado,0)

end

--=================================================================================
--Caso não tenha gerado nenhum lançamento, pois a nota não possui lancamento_padrao
--=================================================================================
if @qt_lancamento_gerado_count = 0
begin

  print 'Nenhum lançamento foi gerado inicialmente. A nota não possui lançamento padrão'

  --------------------------------------------------------
  -- Contabilizar o valor do ICMS se existir
  --------------------------------------------------------
  if isnull(@vl_icms_item,0) > 0 
  begin

    print 'Tentar contabilizar ICMS no valor de ' + convert( varchar, @vl_icms_item )

    set @vl_contab_nota_entrada    = @vl_icms_item
    set @nm_atributo               = 'vl_icms_item_nota_entrada' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito           = 0
    set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario		
	
  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          -1

  end


  --------------------------------------------------------
  -- Contabilizar o valor do IPI se existir
  --------------------------------------------------------
  if isnull(@vl_ipi_item,0) > 0
  begin

    print 'Tentar contabilizar IPI no valor de ' + convert( varchar, @vl_ipi_item )

    set @vl_contab_nota_entrada    = @vl_ipi_item
    set @nm_atributo               = 'vl_ipi_item_nota_entrada' --Verificar no Cadastro de Tipo de Contabilização
    set @cd_conta_debito           = 0
    set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario
		
  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          -1 --Define que deve gravar

  end


  --------------------------------------------------------
  -- Contabilizar o valor da Nota de Saída
  --------------------------------------------------------
  if isnull(@vl_item_nota_entrada,0) > 0
  begin

    print 'Tentar contabilizar a Nota no valor de ' + convert( varchar, @vl_item_nota_entrada )

    set @vl_contab_nota_entrada    = @vl_item_nota_entrada
    set @nm_atributo               = 'cd_nota_entrada'
    set @cd_conta_debito           = 0
    set @cd_conta_credito          = @cd_conta_fornecedor
    set @nm_historico_nota_entrada ='-NF '+cast(@cd_nota_entrada as varchar(10))+'-'+@nm_fantasia_destinatario
		
  -- Essa stored procedure insere na tabela nota_entrada_contabil
  exec pr_grava_geracao_contabilizacao_nota_entrada
          @cd_nota_entrada,
          @cd_item_nota_entrada,
          @dt_nota_entrada,
          @vl_contab_nota_entrada,
          @nm_atributo,
          @cd_produto,
          @cd_grupo_produto,
          @cd_tipo_mercado,
          @cd_conta_debito,
          @cd_conta_credito,      
          @nm_historico_nota_entrada, 				
          @cd_fornecedor,
          @nm_fantasia_destinatario,
          @cd_operacao_fiscal,
          @cd_usuario,
          @cd_categoria_produto,
          -1

  end

end

