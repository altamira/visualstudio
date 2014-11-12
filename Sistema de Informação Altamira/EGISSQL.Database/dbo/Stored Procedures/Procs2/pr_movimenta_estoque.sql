-- IF EXISTS (SELECT name 
-- 	   FROM   sysobjects 
-- 	   WHERE  name = N'pr_movimenta_estoque' 
-- 	   AND 	  type = 'P')
--     DROP PROCEDURE pr_movimenta_estoque
-- GO

CREATE PROCEDURE pr_movimenta_estoque
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : GBS
--Banco de Dados   : Egissql
--Objetivo         : Realizar as movimentações em estoque
--Data             : 01/03/2002
-- 25/04/2003 - Procedimento para gerar o campo para ocorrer erro. - Igor Gama
-- 17.06.2003 - Acertos, inclusão do campo para definir que o item é composição. - Fabio Cesar.
-- 22.07.2003 - Acertos, inclusão do campo para retornar o código do movimento gerado - Fabio Cesar.
-- 07/11/2003 - Atualizando os saldos de Consignação e Terceiros - ELIAS
-- 06/01/2004 - Armazenar o histórico do movimento de estoque - Fabio Cesar.
-- 09/03/2004 - Inclusão dos campos "cd_operacao_fiscal" e "cd_serie_nota_fiscal" que serão gravados
--              quando a Nota entra pelo SRE, e serão usados na rotina de Importação de Notas para PEPS - Eduardo.
-- 09.03.2004 - A pedido do Carlos foi mudado para o flag consignação e terceiro não movimentar o saldo de consignação, apenas
-- movimentar o padrão e guardar como informativo
-- 26/03/2004 - Não movimentar estoque de Fases Inativas - Eduardo.
-- 14/01/2005 - Parâmetro cd_lote, modificado para varchar(20) - ELIAS
-- 07.02.2005 - Conversão de Unidade de Medida - Carlos Fernandes
-- 25/02/2005 - Não gerar Movimentação de Entrada de Transferência para
-- 							a Reserva, pois o Lançamento de Entrada no Físico também é
-- 							o Utilizado para esse fim - ELIAS 25/02/2005  
-- 01/03/2005 - Acerto na Atualização do Saldo de Reserva, quanto ocorre Transferência entre Fases - ELIAS 
-- 07.05.2005 - Criação da Rotina de Movimentação de Saldo de Lote de Produto - Carlos Fernandes
-- 24.05.2005 - Novo parâmetro para movimentar o Saldo do Lote ( Carlos / Rafael )
-- 29.10.2005 - Lote - Carlos Fernandes
-- 21.07.2006 - Realizar a atualização do código do produto old quando esse baixar em outro produto
-- 14.03.2007 - Retirado o Comentário de Movimentação de Lote - Carlos Fernades
-- 05.09.2007 - Checagem da procedure para Lote - Carlos Fernandes
-- 29.09.2008 - Ajustes Diversos - Carlos Fernandes
-- 05.03.2009 - Verificação se é possível movimentar o estoque de 3o. automaticamente - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------

-- Utilizado na atualizacao de saldo

@ic_parametro                   int         = 0, 
@cd_tipo_movimento_estoque      int         = 0,
@cd_tipo_movimento_estoque_old  int         = 0,
@cd_produto                     int         = 0,
@cd_fase_produto                int         = 0 ,
@qt_produto_atualizacao         float       = 0,
@qt_produto_atualizacao_old     float       = 0,
@dt_movimento_estoque           datetime    = '', 
@cd_documento_movimento         int         = 0, 
@cd_item_documento              int         = 0, 
@cd_tipo_documento_estoque      int         = 0, 
@dt_documento_movimento         datetime    = '',
@cd_centro_custo                int         = 0, 
@vl_unitario_movimento          float       = 0, 
@vl_total_movimento             float       = 0, 
@ic_peps_movimento_estoque      char(1)     = 'N', 
@ic_terceiro_movimento          char(1)     = 'N', 
@nm_historico_movimento         varChar(60) = '', 
@ic_mov_movimento               char (1)    = '', 
@cd_fornecedor                  int         = 0, 
@ic_fase_entrada_movimento      char(1)     = '', 
@cd_fase_produto_entrada        char(1)     = '', 
@cd_usuario                     int         = 0, 
@dt_usuario                     datetime    = '',
@cd_tipo_destinatario           int         = 0,
@nm_destinatario                varchar(40) = '',
@vl_fob_produto                 float       = 0.00,
@vl_custo_contabil_produto      float       = 0.00,
@vl_fob_convertido              float       = 0.00,
@cd_produto_old                 int         = 0,
@cd_fase_produto_old            int         = 0,
@ic_consig_movimento            char(1)     = 'N',
@ic_amostra_movimento           char(1)     = 'N',
@ic_tipo_lancto_movimento       char(1)     = 'A',
@cd_item_composicao             int         = 0, -- Define o código do item da composição
@cd_historico_estoque           int         = 0, -- Define que não possui histórico
@cd_operacao_fiscal             int         = null,
@cd_serie_nota_fiscal           int         = null,
@cd_movimento_estoque           int         = 0 output,-- Será tratado
@cd_lote_produto                varchar(25) = '',  -- Guarda o Numero do Lote do Movimento
@ic_tipo_mov_transf             char(1)     = '',  -- Tipo de movimento realizado na transferência
@cd_unidade_medida              int         = 0,   -- Unidade de Medida
@cd_unidade_origem              int         = 0,   -- Unidade de Medida Origem
@qt_fator_produto_unidade       float       = 0,   -- Fator Utilizado na Conversão
@qt_origem_movimento            float       = 0,   -- Quantidade Original que foi Utilizada para Conversão
@ic_atualiza_saldo_lote         char(1)     = 'N', -- Atualiza o Saldo do Lote
@cd_lote_produto_old            varchar(25) = '',  -- Guarda o Numero do Lote do Movimento,
@vl_custo_comissao              float       = 0.00 -- Valor do Custo Comissão

as

-- Quando a procedure é rodada de dentro do Egis,
-- os parâmetros DEFAULT devem ser preechidos "na mão"

set @cd_tipo_destinatario      = isnull(@cd_tipo_destinatario,0)
set @nm_destinatario           = isnull(@nm_destinatario,'')
set @vl_fob_produto            = isnull(@vl_fob_produto,0)
set @vl_custo_contabil_produto = isnull(@vl_custo_contabil_produto,0)
set @vl_fob_convertido         = isnull(@vl_fob_convertido,0)
set @cd_produto_old            = isnull(@cd_produto_old,0)
set @cd_fase_produto_old       = isnull(@cd_fase_produto_old,0)
set @ic_consig_movimento       = isnull(@ic_consig_movimento,'N')
set @ic_amostra_movimento      = isnull(@ic_amostra_movimento,'N')
set @ic_tipo_lancto_movimento  = isnull(@ic_tipo_lancto_movimento,'A')
set @cd_item_composicao        = isnull(@cd_item_composicao, 0)
set @cd_lote_produto           = isnull(@cd_lote_produto,0)
set @cd_operacao_fiscal        = isnull(@cd_operacao_fiscal,0)
set @cd_lote_produto_old       = isnull(@cd_lote_produto_old,0)


declare @SQL                         varchar(8000)
declare @ic_tipo_calculo             char(1)
declare @vl_tipo_atualizacao         int
declare @nm_atributo                 char (40) 
declare @ic_composicao               char (1) 
declare @cd_origem_baixa_produto     int
declare @cd_produto_aux              int
declare @tabela                      varchar(100)
declare @ic_calculo                  int 
declare @ic_alocacao_estoque_reserva char(1) 

--select * from parametro_estoque

--Para Transferência de Estoque

declare @TransferenciaFase        int, -- Indica ao final da sp se vai fazer a transferência da fase
        @AtualizaSaldoTranf       int, -- Faz a Atualização do Saldo de Reserva na Entrada quando Transferência
        @cd_fase_transf           int,
        @nm_historico_transf      varChar(60),
        @nm_historico_transf_2    varChar(60),
        @cd_tipo_movimento_transf int,
        @ic_mov_transf            Char(1),
        @cd_tipo_mov_transf       int,
        @cd_fase_entrada          int, 
        @cd_fase_saida            int,
        @nm_fase_saida            varchar(40),
        @nm_fase_entrada          varchar(40)

set  @cd_movimento_estoque    = 0
set  @SQL                     = ''
set  @ic_tipo_calculo         = ''
set  @vl_tipo_atualizacao     = 0
set  @nm_atributo             = '' 
set  @ic_composicao           = 'N' 
set  @TransferenciaFase       = 0 --Deixa Padrão como Zero para não passar na transferência de estoque
set  @AtualizaSaldoTranf      = 0
set  @ic_tipo_mov_transf      = isnull(@ic_tipo_mov_transf,'')

if @cd_historico_estoque = 0
  set @cd_historico_estoque = null

if isnull(@cd_produto,0) = 0 and isnull(@cd_produto_old,0) = 0 
begin
  print 'Não Movimenta o Estoque'
  return
end

--Altera o produto "Old" quando esse realiza baixa em outro produto

if ( isnull(@cd_produto_old,0) > 0 )
begin
  if exists(select 'x' From Produto with (nolock) 
            where cd_produto = @cd_produto_old and isnull(cd_produto_baixa_estoque, 0) > 0)
  begin
    Select top 1 @cd_produto_old = cd_produto_baixa_estoque
    from Produto with (nolock) 
    where cd_produto = @cd_produto_old
  end
end

-- Não Movimentar o Estoque se a fase tiver sido Desativada

if exists ( select cd_fase_produto from fase_produto with (nolock) 
            where cd_fase_produto = @cd_fase_produto and isnull(ic_fase_inativa,'N') = 'S' )
begin
  if ( isnull(@cd_produto_old,0) > 0 )
  begin
     if exists ( select cd_fase_produto from fase_produto with (nolock) 
            where cd_fase_produto = @cd_fase_produto_old and isnull(ic_fase_inativa,'N') = 'S' )
	return
  end
  else
   return
end                 

-----------------------------------------------------------------------------------------------------------
--Carlos
--07.05.2005
--Verificar se a Empresa Opera com Controle de Lote
-----------------------------------------------------------------------------------------------------------

declare @ic_opera_controle_lote char(1)

select 
  @ic_opera_controle_lote      = isnull(ic_estoque_lote_empresa,'N'),
  @ic_alocacao_estoque_reserva = isnull(ic_alocacao_estoque_reserva,'N')
from 
  parametro_estoque with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

-----------------------------------------------------------------------------------------------------------


--Verificando se o valor no Campo cd_produto_baixa_estoque

if not (select isnull(cd_produto_baixa_estoque, 0) From Produto with (nolock) 
        where cd_produto = @cd_produto) = 0  
begin
  set  @cd_origem_baixa_produto = @cd_produto
  set  @cd_produto = (select cd_produto_baixa_estoque from Produto with (nolock) 
                      where cd_produto = @cd_produto)
end

--Pega o nome do database atual
Set @Tabela = Db_Name() + '.dbo.Movimento_Estoque'

if @cd_operacao_fiscal <> 0
begin

  -- TRANSFERÊNCIA ENTRE FASES
  if (select isnull(cd_fase_produto,0) from operacao_fiscal with (nolock) 
      where 
        cd_operacao_fiscal = @cd_operacao_fiscal) = 0
  begin

    if (((select isnull(cd_fase_entrada_op_fiscal, 0) from operacao_fiscal where cd_operacao_fiscal = @cd_operacao_fiscal) <> 0) and
        ((select isnull(cd_fase_saida_op_fiscal, 0)   from operacao_fiscal where cd_operacao_fiscal = @cd_operacao_fiscal) <> 0)) 
    begin
  
      --Selecionar as fases para movimentação
      Select @cd_fase_entrada = cd_fase_entrada_op_fiscal,
             @cd_fase_saida = cd_fase_saida_op_fiscal
      From Operacao_Fiscal with (nolock) 
      Where cd_operacao_fiscal = @cd_operacao_fiscal

      --Caso tenha definido uma fase no cadastro de produto para baixa. Pegar esta para movimentar
      select @cd_fase_saida = isnull(cd_fase_produto_baixa, @cd_fase_saida) 
      From Produto with (nolock) 
      where cd_produto = @cd_produto

      select @nm_fase_saida = nm_fase_produto from Fase_produto with (nolock) 
      where cd_fase_produto = @cd_fase_saida

      select @nm_fase_entrada = nm_fase_produto from Fase_produto with (nolock) 
      where cd_fase_produto = @cd_fase_entrada

      Select 
        @cd_fase_produto = case ic_mov_tipo_movimento
	        when 'S' then case when @ic_tipo_mov_transf <> 'X' then @cd_fase_saida else @cd_fase_entrada end
	        when 'E' then case when @ic_tipo_mov_transf <> 'X' then @cd_fase_entrada else @cd_fase_saida end end,
        @cd_fase_transf = case ic_mov_tipo_movimento
	        when 'S' then case when @ic_tipo_mov_transf <> 'X' then @cd_fase_entrada else @cd_fase_saida end
	        when 'E' then case when @ic_tipo_mov_transf <> 'X' then @cd_fase_saida else @cd_fase_entrada end end,
	@nm_historico_transf = @nm_historico_movimento + ' Trans. Aut. p/ ' + 
	        case ic_mov_tipo_movimento
	          when 'E' then case when @ic_tipo_mov_transf <> 'X' then @nm_fase_saida else @nm_fase_entrada end
	          when 'S' then case when @ic_tipo_mov_transf <> 'X' then @nm_fase_entrada else @nm_fase_saida end end,
	@nm_historico_transf_2 = @nm_historico_movimento + ' Trans. Aut. de ' + 
	        case ic_mov_tipo_movimento
	          when 'S' then case when @ic_tipo_mov_transf <> 'X' then @nm_fase_saida else @nm_fase_entrada end
	          when 'E' then case when @ic_tipo_mov_transf <> 'X' then @nm_fase_entrada else @nm_fase_saida end end,
        @cd_tipo_movimento_transf = 
        	case nm_atributo_produto_saldo 
	          when 'qt_saldo_atual_produto' then case ic_mov_tipo_movimento
	                                               when 'S' then 1 
	                                               when 'E' then 11 end
            	  when 'qt_saldo_reserva_produto' then case ic_mov_tipo_movimento
	                                               when 'S' then 3 
	                                               when 'E' then 2 end end,
        @ic_mov_movimento = case ic_mov_tipo_movimento
                              when 'S' then 'S'
                              when 'E' then 'E' end,
        @ic_mov_transf = case ic_mov_tipo_movimento
                           when 'E' then 'S'
                  when 'S' then 'E' end
      from 
        tipo_movimento_estoque with (nolock) 
      where 
        cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

      Set @nm_historico_movimento = @nm_historico_transf
      Set @nm_historico_transf    = @nm_historico_transf_2
	  
      -- SOMENTE SE FOR UMA MOVIMENTAÇÃO DE ENTRADA NO REAL É FEITO TAMBÉM
      -- A ATUALIZAÇÃO DO SALDO DE RESERVA - ELIAS 01/03/05

      if ((select ic_mov_tipo_movimento     from tipo_movimento_estoque with (nolock) 
           where cd_tipo_movimento_estoque = @cd_tipo_movimento_transf) = 'E') and
         ((select nm_atributo_produto_saldo from tipo_movimento_estoque with (nolock) 
           where cd_tipo_movimento_estoque = @cd_tipo_movimento_transf) = 'qt_saldo_reserva_produto')
      begin
        Set @TransferenciaFase  = 0
        Set @AtualizaSaldoTranf = 1
      end
      else
      begin
        Set @TransferenciaFase  = 1
        set @AtualizaSaldoTranf = 0
      end

    end else
    begin
      --caso não tenha definido nenhuma fase para movimentação ele pega a do parâmetro comercial
      Select @cd_fase_produto = isnull(cd_fase_produto,0) 
      from parametro_comercial with (nolock) 
      where 
        cd_empresa = dbo.fn_empresa()
    end      
  end
end

-------------------------------------------------------------------------------
if (@ic_parametro = 4)    -- Insere Registro na Tabela "Produto_Saldo"
                          -- referente a fase inexistente usada na Movimentação
-------------------------------------------------------------------------------
begin

  set @SQL = 'insert into Produto_Saldo
                (
                cd_produto,  
                cd_fase_produto,
                dt_atual_produto, 
                dt_reserva_produto,
                dt_ultima_entrada_produto, 
                dt_ultima_saida_produto,
                cd_usuario, 
                dt_usuario) 
              values
                ('+
                convert (varchar (15),@cd_produto)+','+

                convert (varchar (15),@cd_fase_produto)+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                convert (varchar (15),@cd_usuario)+','+
                quotename(@dt_usuario,'''')+')' 
  
  if ( @cd_produto > 0 ) and ( @cd_fase_produto>0 )
  begin
    exec(@SQL)
  end

end 

-------------------------------------------------------------------------------
-- Todos outros parâmetros, com excessão do 4
-------------------------------------------------------------------------------
else
begin

  if not exists(Select top 1 'x' from produto_saldo where cd_produto = @cd_produto and cd_fase_produto = @cd_fase_produto)
  begin
    set @SQL = 'insert into Produto_Saldo
     (
                cd_produto,  
                cd_fase_produto,
                dt_atual_produto, 
                dt_reserva_produto,
                dt_ultima_entrada_produto, 
                dt_ultima_saida_produto,
                cd_usuario, 
                dt_usuario) 
              values
                ('+
                convert (varchar (15),@cd_produto)+','+

                convert (varchar (15),@cd_fase_produto)+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                convert (varchar (15),@cd_usuario)+','+
                quotename(@dt_usuario,'''')+')' 
    
    if ( @cd_produto > 0 ) and ( @cd_fase_produto>0 )
    begin
      exec(@SQL)
    end
  end
end

-------------------------------------------------------------------------------
-- Atualização do Saldo do Produto na Inclusao
-------------------------------------------------------------------------------
if (IsNull(@qt_produto_atualizacao_old, 0) <> 0)
begin

  -----------------------------------------------------------------------------
  -- INCLUSÃO DE MOVIMENTO
  -----------------------------------------------------------------------------

  if (@ic_parametro = 1)
  begin 


    -- Verifica o tipo de movimento de estoque
    -- e pega o nome do atributo a ser atualizado
    select @ic_tipo_calculo = ic_mov_tipo_movimento,
           @nm_atributo     = nm_atributo_produto_saldo
    from 
      tipo_movimento_estoque with (nolock) 
    where 
      cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque_old


    if ( @cd_produto > 0 ) or ( @cd_produto_old > 0 )
    begin
    	-- Pega a ultima sequencia do movimento de estoque
    	exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output	     

	    insert into movimento_estoque
	      (cd_movimento_estoque, 
	       dt_movimento_estoque, 
	       cd_tipo_movimento_estoque, 
	       cd_documento_movimento, 
	       cd_operacao_fiscal, 
	       cd_serie_nota_fiscal, 
	       cd_item_documento, 
	       cd_tipo_documento_estoque, 
	       dt_documento_movimento, 
	       cd_centro_custo, 
	       qt_movimento_estoque, 
	       vl_unitario_movimento,
	       vl_total_movimento, 
	       ic_peps_movimento_estoque, 
	       ic_terceiro_movimento, 
	       ic_consig_movimento,
	       nm_historico_movimento, 
	       ic_mov_movimento, 
	       cd_tipo_destinatario,
	       cd_fornecedor,
	       nm_destinatario,
	       cd_origem_baixa_produto,
	       cd_produto, 
	       cd_fase_produto, 
	       ic_fase_entrada_movimento, 
	       cd_fase_produto_entrada, 
	       vl_fob_produto,
	       vl_custo_contabil_produto,
	       vl_fob_convertido,
	       ic_amostra_movimento,
	       ic_tipo_lancto_movimento,
	       cd_item_composicao,
	       cd_historico_estoque,
	       cd_lote_produto,
	       cd_unidade_medida,
	       cd_unidade_origem,
	       qt_fator_produto_unidade,
	       qt_origem_movimento,
	       cd_usuario, 
	       dt_usuario,
               vl_custo_comissao)
	    values 
	      (@cd_movimento_estoque, 
	       @dt_movimento_estoque, 
	       @cd_tipo_movimento_estoque_old, 
	       @cd_documento_movimento, 
	       @cd_operacao_fiscal, 
	       @cd_serie_nota_fiscal, 
	       @cd_item_documento, 
	       @cd_tipo_documento_estoque, 
	       @dt_documento_movimento, 
	       @cd_centro_custo, 
	       @qt_produto_atualizacao_old, 
	       @vl_unitario_movimento, 
	       @vl_total_movimento, 
	       @ic_peps_movimento_estoque, 
	       @ic_terceiro_movimento, 
	       @ic_consig_movimento,
	       @nm_historico_movimento, 
	       @ic_tipo_calculo, 
	       @cd_tipo_destinatario,
	       @cd_fornecedor,
	       @nm_destinatario, 
	       @cd_origem_baixa_produto,
	       @cd_produto_old, 
	       @cd_fase_produto_old, 
	       @ic_fase_entrada_movimento, 
	       @cd_fase_produto_entrada, 
	       @vl_fob_produto,
	       @vl_custo_contabil_produto,
	       @vl_fob_convertido,
	       @ic_amostra_movimento,
	       @ic_tipo_lancto_movimento,
	       @cd_item_composicao,
	       @cd_historico_estoque,
               @cd_lote_produto_old,
-- teste ccf              case when @cd_tipo_movimento_estoque_old=3 then @cd_lote_produto_old else @cd_lote_produto end,
	       @cd_unidade_medida,
	       @cd_unidade_origem,
	       @qt_fator_produto_unidade,
	       @qt_origem_movimento,
	       @cd_usuario, 
	       @dt_usuario,
               @vl_custo_comissao)
	
	    -- limpeza da tabela de código
	    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'

	    --Atualiza o movimento de saída após o cancelamento da nota de saída
	    if ( @cd_tipo_movimento_estoque in (10, 12)) and
	       ( @cd_tipo_documento_estoque = 3 )
	      exec pr_atualiza_movimento_nota_saida_com_entrada
	             @cd_documento_movimento, 
	             @cd_item_documento, 
	             @cd_movimento_estoque,
	             @cd_produto,
	             @cd_fase_produto	

            --Atualiza o Saldo do Lote do Produto

            if ( @ic_opera_controle_lote='S' ) and ( isnull(@cd_lote_produto_old,'') <>'' ) and ( @ic_atualiza_saldo_lote='S')
            begin

              set @ic_calculo =1 --Entrada

              if @ic_tipo_calculo = 'E' and @nm_atributo='qt_saldo_reserva_produto'  --Entrada Reserva    
                 set @ic_calculo = 11

              --Saida
              if @ic_tipo_calculo = 'S' --Saida
                 set @ic_calculo =2
 
              if @ic_tipo_calculo = 'S' and @nm_atributo='qt_saldo_reserva_produto'  --Saida Reserva
                 set @ic_calculo =22
  
              exec dbo.pr_atualiza_saldo_lote 0,0,@cd_produto_old,@qt_produto_atualizacao_old,'N',@ic_calculo,@cd_usuario,@cd_lote_produto_old
  
            end

            if @ic_alocacao_estoque_reserva='S' 
            begin
              exec pr_geracao_alocacao_disponibilidade 
                   0,
                   @cd_produto,
                   @cd_usuario,
                   null,
                   null,
                   'N'
            end             

       end
  end

  -----------------------------------------------------------------------------
  -- MODIFICAÇÃO DE MOVIMENTO
  -----------------------------------------------------------------------------

  if (@ic_parametro = 2)
  begin 

    -- Busca o Tipo de Calculo E/S
    select 
      @ic_tipo_calculo = ic_mov_tipo_movimento,
      @nm_atributo     = nm_atributo_produto_saldo
    from 
      tipo_movimento_estoque with (nolock) 
    where 
      cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

    update 
      movimento_estoque
    set 
      cd_movimento_estoque      = @cd_movimento_estoque,
      dt_movimento_estoque      = @dt_movimento_estoque,
      cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque_old,
      cd_documento_movimento    = @cd_documento_movimento,
      cd_operacao_fiscal        = @cd_operacao_fiscal,
      cd_serie_nota_fiscal      = @cd_serie_nota_fiscal,
      cd_item_documento         = @cd_item_documento,
      cd_tipo_documento_estoque = @cd_tipo_documento_estoque,
      dt_documento_movimento    = @dt_documento_movimento,
      cd_centro_custo           = @cd_centro_custo,
      qt_movimento_estoque      = @qt_produto_atualizacao_old,
      vl_unitario_movimento     = @vl_unitario_movimento,
      vl_total_movimento        = @vl_total_movimento,
      ic_peps_movimento_estoque = @ic_peps_movimento_estoque,
      ic_terceiro_movimento     = @ic_terceiro_movimento,
      ic_consig_movimento       = @ic_consig_movimento,
      nm_historico_movimento    = @nm_historico_movimento,
      ic_mov_movimento          = @ic_tipo_calculo,
      cd_tipo_destinatario      = @cd_tipo_destinatario,
      cd_fornecedor             = @cd_fornecedor,
      nm_destinatario           = @nm_destinatario,
      cd_origem_baixa_produto   = @cd_origem_baixa_produto,
      cd_produto                = @cd_produto_old,
      cd_fase_produto           = @cd_fase_produto_old,
      ic_fase_entrada_movimento = @ic_fase_entrada_movimento,
      cd_fase_produto_entrada   = @cd_fase_produto_entrada,
      vl_fob_produto            = @vl_fob_produto,
      vl_custo_contabil_produto = @vl_custo_contabil_produto,
      vl_fob_convertido         = @vl_fob_convertido,
      ic_amostra_movimento      = @ic_amostra_movimento,
      ic_tipo_lancto_movimento  = @ic_tipo_lancto_movimento,
      cd_historico_estoque      = @cd_historico_estoque,
      cd_lote_produto           = @cd_lote_produto,
      cd_unidade_medida         = @cd_unidade_medida,
      cd_unidade_origem         = @cd_unidade_origem,
      qt_fator_produto_unidade  = @qt_fator_produto_unidade,
      qt_origem_movimento       = @qt_origem_movimento,
      cd_usuario                = @cd_usuario,
      dt_usuario                = @dt_usuario,
      vl_custo_comissao         = @vl_custo_comissao
    where
      cd_movimento_estoque = @cd_movimento_estoque

   --Atualiza o Saldo do Lote do Produto

    if ( @ic_opera_controle_lote='S' ) and ( isnull(@cd_lote_produto,'') <>'' ) and ( @ic_atualiza_saldo_lote='S')
    begin

      set @ic_calculo =1 --Entrada

      if @ic_tipo_calculo = 'E' and @nm_atributo='qt_saldo_reserva_produto'  --Entrada Reserva    
         set @ic_calculo = 11

     --Saida
     if @ic_tipo_calculo = 'S' --Saida
         set @ic_calculo =2
 
      if @ic_tipo_calculo = 'S' and @nm_atributo='qt_saldo_reserva_produto'  --Saida Reserva
         set @ic_calculo =22
  
      exec dbo.pr_atualiza_saldo_lote 0,0,@cd_produto_old,@qt_produto_atualizacao_old,'N',@ic_calculo,@cd_usuario,@cd_lote_produto
  
     end

    end

    if @ic_alocacao_estoque_reserva='S' 
    begin
      exec pr_geracao_alocacao_disponibilidade 
           0,
           @cd_produto,
           @cd_usuario,
           null,
           null,
           'N'
    end

  -----------------------------------------------------------------------------
  -- ATUALIZAÇÃO DO SALDO
  -------------------------------------------------------

  if @ic_tipo_calculo = 'E'
    set @vl_tipo_atualizacao = 1
  else 
    set @vl_tipo_atualizacao = (-1)
      
  if @nm_Atributo<>''
  begin

    set @SQL = ''
    set @SQL = ' update produto_saldo set ' + @nm_Atributo + 
               ' = isnull (' + @nm_atributo + ',0) + (' + 
               convert (varchar (15),isnull (@qt_produto_atualizacao_old,0)) + '*' +  
               convert (varchar (15),isnull(@vl_tipo_atualizacao,0))+ '),' 

    if @vl_fob_produto > 0
      set @SQL = @SQL + ' vl_fob_produto = ' + Str(@vl_fob_produto, 8) + ', '

    if @vl_custo_contabil_produto > 0
      set @SQL = @SQL + ' vl_custo_contabil_produto = '+ Str(@vl_custo_contabil_produto, 8) + ', '

    if @vl_fob_convertido > 0
      set @SQL = @SQL +  ' vl_fob_convertido = '+ Str(@vl_fob_convertido, 8) + ', '

    set @SQL = @SQL + ' dt_atual_produto = ' + quotename(getdate(),'''') +
             ' where cd_produto = ' + convert (varchar (15),@cd_produto_old) + ' and ' +
             ' cd_fase_produto = '+ convert (varchar (15),@cd_fase_produto_old)
  
    if ( @cd_produto_old > 0 ) and ( @cd_fase_produto>0 )
      exec(@SQL)
  end
  
end

--
--
--

if (@ic_parametro = 1) and (IsNull(@qt_produto_atualizacao,0) > 0)
begin 

--    print @ic_parametro

    -- Busca o Tipo de Calculo E/S
    select 
      @ic_tipo_calculo = ic_mov_tipo_movimento,
      @nm_atributo     = nm_atributo_produto_saldo
    from 
      tipo_movimento_estoque with (nolock) 
    where 
      cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

    if ( @cd_produto > 0 ) or ( @cd_produto_old > 0 )
    begin
      -- Pega a ultima sequencia do movimento de estoque
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output	     

       -- limpeza da tabela de código
       exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'
    
       --Verifica se o valor da movimentação é superior a zero caso contrário não grava o registro

       insert into movimento_estoque
	   (cd_movimento_estoque, 
	    dt_movimento_estoque, 
	    cd_tipo_movimento_estoque, 
	    cd_documento_movimento, 
            cd_operacao_fiscal, 
            cd_serie_nota_fiscal, 
	    cd_item_documento, 
	    cd_tipo_documento_estoque, 
	    dt_documento_movimento, 
	    cd_centro_custo, 
	    qt_movimento_estoque, 
	    vl_unitario_movimento,
	    vl_total_movimento, 
	    ic_peps_movimento_estoque, 
	    ic_terceiro_movimento, 
            ic_consig_movimento,
	    nm_historico_movimento, 
	    ic_mov_movimento, 
            cd_tipo_destinatario,
	    cd_fornecedor, 
            nm_destinatario,
	    cd_produto, 
	    cd_origem_baixa_produto,
	    cd_fase_produto, 
	    ic_fase_entrada_movimento, 
	    cd_fase_produto_entrada, 
	    vl_fob_produto,
	    vl_custo_contabil_produto,
            vl_fob_convertido,
            ic_amostra_movimento,
            ic_tipo_lancto_movimento,
	    cd_item_composicao,
            cd_historico_estoque,
            cd_lote_produto,
            cd_unidade_medida,
            cd_unidade_origem,
            qt_fator_produto_unidade,
            qt_origem_movimento,
	    cd_usuario, 
	    dt_usuario,
            vl_custo_comissao)
	
	values (@cd_movimento_estoque, 
  	    @dt_movimento_estoque, 
	    @cd_tipo_movimento_estoque, 
	    @cd_documento_movimento, 
            @cd_operacao_fiscal, 
            @cd_serie_nota_fiscal, 
	    @cd_item_documento, 
	    @cd_tipo_documento_estoque, 
	    @dt_documento_movimento, 
	    @cd_centro_custo, 
	    @qt_produto_atualizacao, 
	    @vl_unitario_movimento, 
	    @vl_total_movimento, 
	    @ic_peps_movimento_estoque, 
	    @ic_terceiro_movimento, 
            @ic_consig_movimento,
	    @nm_historico_movimento, 
	    @ic_mov_movimento, 
            @cd_tipo_destinatario,
	    @cd_fornecedor, 
            @nm_destinatario,
	    @cd_produto, 
	    @cd_origem_baixa_produto,
	    @cd_fase_produto, 
	    @ic_fase_entrada_movimento, 
	    @cd_fase_produto_entrada, 
	    @vl_fob_produto,
	    @vl_custo_contabil_produto,
	    @vl_fob_convertido,
            @ic_amostra_movimento,
            @ic_tipo_lancto_movimento,
	    @cd_item_composicao,
            @cd_historico_estoque,
            @cd_lote_produto,
            @cd_unidade_medida,
            @cd_unidade_origem,
            @qt_fator_produto_unidade,
            @qt_origem_movimento,
	    @cd_usuario, 
	    @dt_usuario,
            @vl_custo_comissao)

      --Muda o tipo de parametro para 3 afim de realizar a atualização do produto_saldo
      set @ic_parametro = 3

      --Atualiza o movimento de saída após o cancelamento da nota de saída

      if ( @cd_tipo_movimento_estoque in (10, 12)) and (@cd_produto > 0)
      begin
        exec pr_atualiza_movimento_nota_saida_com_entrada
             @cd_documento_movimento, 
             @cd_item_documento, 
             @cd_movimento_estoque,
             @cd_produto,
             @cd_fase_produto
      end

    --Atualiza o Saldo do Lote do Produto
    --esta Atualização já ocorre abaixo no parâmetro 3

--     if ( @ic_opera_controle_lote='S' ) and ( isnull(@cd_lote_produto,'')<>'' ) and ( @ic_atualiza_saldo_lote='S')
--     begin
-- 
--       set @ic_calculo =1 --Entrada
-- 
--       if @ic_tipo_calculo = 'E' and @nm_atributo='qt_saldo_reserva_produto'  --Entrada Reserva    
--          set @ic_calculo = 11
-- 
--      --Saida
--       if @ic_tipo_calculo = 'S' --Saida
--          set @ic_calculo =2
--  
--       if @ic_tipo_calculo = 'S' and @nm_atributo='qt_saldo_reserva_produto'  --Saida Reserva
--          set @ic_calculo =22
--   
--       exec dbo.pr_atualiza_saldo_lote 0,0,@cd_produto,@qt_produto_atualizacao,'N',@ic_calculo,@cd_usuario,@cd_lote_produto
--   
--     end

   end

end

--
--
--

if (@ic_parametro = 2) and (@qt_produto_atualizacao > 0)
begin 

    -- Busca o Tipo de Calculo E/S
    select 
      @ic_tipo_calculo = ic_mov_tipo_movimento,
      @nm_atributo     = nm_atributo_produto_saldo
    from 
      tipo_movimento_estoque with (nolock) 
    where 
      cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

    update  movimento_estoque
    set cd_movimento_estoque      = @cd_movimento_estoque,
        dt_movimento_estoque      = @dt_movimento_estoque,
        cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque,
        cd_documento_movimento    = @cd_documento_movimento,
        cd_operacao_fiscal        = @cd_operacao_fiscal,
        cd_serie_nota_fiscal      = @cd_serie_nota_fiscal,
        cd_item_documento         = @cd_item_documento,
        cd_tipo_documento_estoque = @cd_tipo_documento_estoque,
        dt_documento_movimento    = @dt_documento_movimento,
        cd_centro_custo           = @cd_centro_custo,
        qt_movimento_estoque      = @qt_produto_atualizacao,
        vl_unitario_movimento     = @vl_unitario_movimento,
        vl_total_movimento        = @vl_total_movimento,
        ic_peps_movimento_estoque = @ic_peps_movimento_estoque,
        ic_terceiro_movimento     = @ic_terceiro_movimento,
        ic_consig_movimento       = @ic_consig_movimento, 
        nm_historico_movimento    = @nm_historico_movimento,
        ic_mov_movimento          = @ic_mov_movimento,
        cd_tipo_destinatario      = @cd_tipo_destinatario,
        cd_fornecedor             = @cd_fornecedor,
        nm_destinatario           = @nm_destinatario,
        cd_produto                = @cd_produto,
        cd_origem_baixa_produto   = @cd_origem_baixa_produto,
        cd_fase_produto           = @cd_fase_produto,
        ic_fase_entrada_movimento = @ic_fase_entrada_movimento,
        cd_fase_produto_entrada   = @cd_fase_produto_entrada,
        vl_fob_produto            = @vl_fob_produto,
        vl_custo_contabil_produto = @vl_custo_contabil_produto,
        vl_fob_convertido         = @vl_fob_convertido,
        ic_amostra_movimento      = @ic_amostra_movimento,
        ic_tipo_lancto_movimento  = @ic_tipo_lancto_movimento,
        cd_historico_estoque      = @cd_historico_estoque,
        cd_lote_produto           = @cd_lote_produto,
        cd_unidade_medida         = @cd_unidade_medida,
        cd_unidade_origem         = @cd_unidade_origem,
        qt_fator_produto_unidade  = @qt_fator_produto_unidade,
        qt_origem_movimento       = @qt_origem_movimento,
        cd_usuario                = @cd_usuario,
        dt_usuario                = @dt_usuario,
        vl_custo_comissao         = @vl_custo_comissao
      where
        cd_movimento_estoque      = @cd_movimento_estoque

--     --Atualiza o Saldo do Lote do Produto

    if ( @ic_opera_controle_lote='S' ) and ( isnull(@cd_lote_produto,'') <>'' ) and ( @ic_atualiza_saldo_lote='S')
    begin

      set @ic_calculo =1 --Entrada

      if @ic_tipo_calculo = 'E' and @nm_atributo='qt_saldo_reserva_produto'  --Entrada Reserva    
         set @ic_calculo = 11

     --Saida
      if @ic_tipo_calculo = 'S' --Saida
         set @ic_calculo =2
 
      if @ic_tipo_calculo = 'S' and @nm_atributo='qt_saldo_reserva_produto'  --Saida Reserva
         set @ic_calculo =22
  
      exec dbo.pr_atualiza_saldo_lote 0,0,@cd_produto_old,@qt_produto_atualizacao_old,'N',@ic_calculo,@cd_usuario,@cd_lote_produto
  
    end

    if @ic_alocacao_estoque_reserva='S' 
    begin
      exec pr_geracao_alocacao_disponibilidade 
      0,
      @cd_produto,
      @cd_usuario,
      null,
      null,
      'N'
    end             

 end

------------------------------------------------------------------------------------------------------------------
--
--Atualização do Saldo
--
------------------------------------------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  if not exists(Select top 1 'x' from produto_saldo with (nolock) 
                where (cd_produto = @cd_produto) and
                      (cd_fase_produto = @cd_fase_produto) )
  begin
    set @SQL = 'insert into Produto_Saldo
                (
                cd_produto,  
                cd_fase_produto,
                dt_atual_produto, 
                dt_reserva_produto,
                dt_ultima_entrada_produto, 
                dt_ultima_saida_produto,
                cd_usuario, 
                dt_usuario) 
              values
                ('+
                convert (varchar (15),@cd_produto)+','+

                convert (varchar (15),@cd_fase_produto)+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                quotename(getdate(),'''')+','+
                convert (varchar (15),@cd_usuario)+','+
                quotename(@dt_usuario,'''')+')'

      if @cd_produto>0 and @cd_fase_produto>0
      begin
        exec(@SQL)
      end

  end

-- Atualiza Saldo do Produto no Estoque
--select * from tipo_movimento_estoque

  select 
    @ic_tipo_calculo = ic_mov_tipo_movimento,
    @nm_atributo     = nm_atributo_produto_saldo
  from 
    tipo_movimento_estoque with (nolock) 
  where 
    cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

  if @ic_tipo_calculo = 'E'
    set @vl_tipo_atualizacao = 1
  else 
    set @vl_tipo_atualizacao = (-1)

  set @SQL = ''

  set @SQL = ' update produto_saldo set ' 

  -- 09.03,2004 - Comentado a pedido do Carlos, onde informou que o erro estava no conceito
--   if (@ic_consig_movimento = 'S' and @nm_Atributo = 'qt_saldo_atual_produto')
--     set @SQL = @SQL + ' qt_consig_produto = isnull(qt_consig_produto,0) + ('+
--                convert (varchar (15),isnull (@qt_produto_atualizacao,0)) + '*' +  
--                convert (varchar (15),isnull(@vl_tipo_atualizacao,0))+ '),' 

--   if (@ic_terceiro_movimento = 'S' and @nm_Atributo = 'qt_saldo_atual_produto')
--     set @SQL = @SQL + ' qt_terceiro_produto = isnull(qt_terceiro_produto,0) + ('+
--                convert (varchar (15),isnull (@qt_produto_atualizacao,0)) + '*' +  
--                convert (varchar (15),isnull(@vl_tipo_atualizacao,0))+ '),' 

  set @SQL = @SQL + @nm_Atributo + ' = isnull (' + @nm_atributo + ',0) + (' + 
               convert (varchar (15),isnull (@qt_produto_atualizacao,0)) + '*' +  
  convert (varchar (15),isnull(@vl_tipo_atualizacao,0))+ '),' 

          If @vl_fob_produto > 0
            set @SQL = @SQL + ' vl_fob_produto = ' + Str(@vl_fob_produto, 8) + ', '

          If @vl_custo_contabil_produto > 0
            set @SQL = @SQL + ' vl_custo_contabil_produto = '+ Str(@vl_custo_contabil_produto, 8) + ', '

          If @vl_fob_convertido > 0
            set @SQL = @SQL +  ' vl_fob_convertido = '+ Str(@vl_fob_convertido, 8) + ', '


    set @SQL = @SQL + ' dt_atual_produto = '+ quotename(getdate(),'''') +
             ' where cd_produto = ' + convert (varchar (15),@cd_produto) + ' and ' +
             ' cd_fase_produto = '+ convert (varchar (15),@cd_fase_produto)

  if @cd_produto>0 and @cd_fase_produto>0
  begin
    exec(@SQL)
  end

  --Atualiza o Saldo do Lote do Produto

  if ( @ic_opera_controle_lote='S' ) and ( isnull(@cd_lote_produto,'')<>'' ) and ( @ic_atualiza_saldo_lote='S')
  begin

    set @ic_calculo =1 --Entrada

    if @ic_tipo_calculo = 'E' and @nm_atributo='qt_saldo_reserva_produto'  --Entrada Reserva    
        set @ic_calculo = 11

     --Saida
      if @ic_tipo_calculo = 'S' --Saida
         set @ic_calculo =2
 
      if @ic_tipo_calculo = 'S' and @nm_atributo='qt_saldo_reserva_produto'  --Saida Reserva
         set @ic_calculo =22
  
      exec dbo.pr_atualiza_saldo_lote 0,0,@cd_produto,@qt_produto_atualizacao,'N',@ic_calculo,@cd_usuario,@cd_lote_produto
  
    end

    if @ic_alocacao_estoque_reserva='S' 
    begin
      exec pr_geracao_alocacao_disponibilidade 
      0,
      @cd_produto,
      @cd_usuario,
      null,
      null,
      'N'
    end             

end

--Executa novamente a movimentação de estoque para gerar a transferência de estoque

If @TransferenciaFase = 1
Begin

  exec pr_Movimenta_estoque
		1, --@ic_parametro
		@cd_tipo_movimento_transf, --@cd_tipo_movimento_estoque
		@cd_tipo_movimento_estoque_old, --@cd_tipo_movimento_estoque_old
		@cd_produto, --@cd_produto
		@cd_fase_transf, --@cd_fase_produto
		@qt_produto_atualizacao, --@qt_produto_atualizacao
		@qt_produto_atualizacao_old, --@qt_produto_atualizacao_old
    @dt_movimento_estoque, --@dt_movimento_estoque
    @cd_documento_movimento, --@cd_documento_movimento
    @cd_item_documento, --@cd_item_documento
    @cd_tipo_documento_estoque, --@cd_tipo_documento_estoque
    @dt_documento_movimento, --@dt_documento_movimento
    @cd_centro_custo, --@cd_centro_custo
    @vl_unitario_movimento, --@vl_unitario_movimento
    @vl_total_movimento, --@vl_total_movimento
    @ic_peps_movimento_estoque, --@ic_peps_movimento_estoque
    @ic_terceiro_movimento, --@ic_terceiro_movimento
    @nm_historico_transf, --@nm_historico_movimento
    @ic_mov_transf, --@ic_mov_movimento
    @cd_fornecedor, --@cd_fornecedor
    @ic_fase_entrada_movimento, --@ic_fase_entrada_movimento
    @cd_fase_produto_entrada, --@cd_fase_produto_entrada
    @cd_usuario, --@cd_usuario
    @dt_usuario, --@dt_usuario
    @cd_tipo_destinatario, --@cd_tipo_destinatario
    @nm_destinatario, --@nm_destinatario
    @vl_fob_produto, --@vl_fob_produto
    @vl_custo_contabil_produto, --@vl_custo_contabil_produto
    @vl_fob_convertido, --@vl_fob_convertido
    @cd_produto_old, --@cd_produto_old
    @cd_fase_produto_old, --@cd_fase_produto_old
    @ic_consig_movimento, --@ic_consig_movimento
    @ic_amostra_movimento, --@ic_amostra_movimento
    @ic_tipo_lancto_movimento, --@ic_tipo_lancto_movimento
    @cd_item_composicao, --@cd_item_composicao
    @cd_historico_estoque, --@cd_historico_estoque
    0, --@cd_operacao_fiscal
    @cd_serie_nota_fiscal, --@cd_serie_nota_fiscal
    @cd_movimento_estoque, --@cd_movimento_estoque
    @cd_lote_produto, --@cd_lote_produto
    @ic_atualiza_saldo_lote,
    @vl_custo_comissao
   

  --Seta a transferência para "0", para não ficar em LOOP.
  Set @TransferenciaFase = 0

End

-- Atualiza Somente o Saldo no Lançamento de Entrada de Transferência
-- na Reserva - ELIAS 01/03/05
if (@AtualizaSaldoTranf = 1)
begin
  exec pr_Movimenta_estoque
 	 3, -- SOMENTE ATUALIZAÇÃO DO SALDO @ic_parametro
	 3, -- Tipo de Entrada na Reserva - @cd_tipo_movimento_estoque
	 @cd_tipo_movimento_estoque_old, --@cd_tipo_movimento_estoque_old
	 @cd_produto, --@cd_produto
	 @cd_fase_transf, --@cd_fase_produto
	 @qt_produto_atualizacao, --@qt_produto_atualizacao
	 @qt_produto_atualizacao_old, --@qt_produto_atualizacao_old
         @dt_movimento_estoque, --@dt_movimento_estoque
         @cd_documento_movimento, --@cd_documento_movimento
         @cd_item_documento, --@cd_item_documento
	 @cd_tipo_documento_estoque, --@cd_tipo_documento_estoque
	 @dt_documento_movimento, --@dt_documento_movimento
	 @cd_centro_custo, --@cd_centro_custo
	 @vl_unitario_movimento, --@vl_unitario_movimento
	 @vl_total_movimento, --@vl_total_movimento
	 @ic_peps_movimento_estoque, --@ic_peps_movimento_estoque
	 @ic_terceiro_movimento, --@ic_terceiro_movimento
	 @nm_historico_transf, --@nm_historico_movimento
	 @ic_mov_transf, --@ic_mov_movimento
	 @cd_fornecedor, --@cd_fornecedor
	 @ic_fase_entrada_movimento, --@ic_fase_entrada_movimento
	 @cd_fase_produto_entrada, --@cd_fase_produto_entrada
	 @cd_usuario, --@cd_usuario
	 @dt_usuario, --@dt_usuario
	 @cd_tipo_destinatario, --@cd_tipo_destinatario
	 @nm_destinatario, --@nm_destinatario
	 @vl_fob_produto, --@vl_fob_produto
	 @vl_custo_contabil_produto, --@vl_custo_contabil_produto
	 @vl_fob_convertido, --@vl_fob_convertido
	 @cd_produto_old, --@cd_produto_old
	 @cd_fase_produto_old, --@cd_fase_produto_old
	 @ic_consig_movimento, --@ic_consig_movimento
	 @ic_amostra_movimento, --@ic_amostra_movimento
	 @ic_tipo_lancto_movimento, --@ic_tipo_lancto_movimento
	 @cd_item_composicao, --@cd_item_composicao
	 @cd_historico_estoque, --@cd_historico_estoque
	 0, --@cd_operacao_fiscal
	 @cd_serie_nota_fiscal, --@cd_serie_nota_fiscal
	 @cd_movimento_estoque, --@cd_movimento_estoque
	 @cd_lote_produto, --@cd_lote_produto
         @ic_atualiza_saldo_lote,
         @vl_custo_comissao

  Set @AtualizaSaldoTranf = 0

end

