Create procedure pr_movimenta_NF_sem_movimento
-----------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama 
--Banco de Dados: Egissql
--Objetivo: Realiza o movimento completo das NF´s que não foram movimentadas
--Data: 15/05/2003
-----------------------------------------------------------------
  @cd_nota_saida      int,
  @cd_item_nota_saida int
As

  Declare
    @pedido_venda          Int,
    @item_pedido_venda     Int,
    @produto               Int,
    @fase_produto          Int,
    @qt_item               Float,
    @dt_nota_saida         DateTime,
    @vl_total              Float,
    @vl_unitario           Float,
    @cd_dest               Int,
    @cd_user               Int,
    @cd_tipo_dest          Int,
    @nm_fantasia_dest      Varchar(20),
    @cd_tipo_operacao      Int,
    @cd_status             Int,

    @cd_tipo_movimento     Int,
    @cd_tipo_documento     Int,

    @ic_movimenta_reserva  char(1),
    @cd_tipo_movimento_r   Int,
    @cd_tipo_documento_r   Int,


    @documento             Int,
    @Item                  Int,
    @Now                   DateTime


  Select @Now = Getdate()
    
  select
    gop.cd_tipo_operacao_fiscal,
    tof.nm_tipo_operacao_fiscal,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    nsi.cd_produto,
    nsi.cd_fase_produto,
    nsi.qt_item_nota_saida,
    ns.dt_nota_saida,
    ns.cd_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.vl_total_item,
    nsi.vl_unitario_item_nota,
    ns.cd_cliente,
    ns.cd_usuario,
    ns.cd_tipo_destinatario,
    ns.nm_fantasia_destinatario,
    ns.cd_status_nota
  Into
    #Tabela
  From
    Nota_Saida ns
      Inner Join
    Nota_Saida_Item nsi
      on ns.cd_nota_saida = nsi.cd_nota_saida
      Left Outer Join
    Operacao_Fiscal op
      on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      Left Outer Join
    Grupo_Operacao_Fiscal gop
      on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
      Left Outer Join
    Tipo_Operacao_Fiscal tof
      on gop.cd_tipo_operacao_fiscal = tof.cd_tipo_operacao_fiscal
  Where
    ns.cd_nota_saida           = @cd_nota_saida
    and nsi.cd_item_nota_saida = @cd_item_nota_saida


  Select top 1
    @cd_status        = cd_status_nota,
    @cd_tipo_operacao = cd_tipo_operacao_fiscal,
    @pedido_venda     = cd_pedido_venda,
    @cd_nota_saida    = cd_nota_saida
  From
    #Tabela

  If (@cd_status = 5) and  --Fechado
     (@cd_tipo_operacao = 2)  --Saída
  Begin

    Set @cd_tipo_movimento = 11
    Set @cd_tipo_documento = 4

    If IsNull(@pedido_venda,0) = 0
    Begin
      Set @ic_movimenta_reserva = 'S'
      Set @cd_tipo_movimento_r  = 2
      Set @cd_tipo_documento_r  = 4
    End
    Else
      Set @ic_movimenta_reserva = 'N'

  End Else
  If (@cd_status = 5) and  --Fechado
     (@cd_tipo_operacao = 1)  --Entrada
  Begin

    Set @cd_tipo_movimento = 1
    Set @cd_tipo_documento = 3
    Set @ic_movimenta_reserva = 'N'

  End Else
  If (@cd_status = 7) and  --Cancelado
     (@cd_tipo_operacao = 2)  --Saída
  Begin

    Set @cd_tipo_movimento = 1
    Set @cd_tipo_documento = 4

    If IsNull(@pedido_venda,0) = 0
    Begin
      Set @ic_movimenta_reserva = 'S'
      Set @cd_tipo_movimento_r  = 3
      Set @cd_tipo_documento_r  = 4
    End
    Else
      Set @ic_movimenta_reserva = 'N'

  End Else
  If (@cd_status = 7) and  --Cancelado
     (@cd_tipo_operacao = 1)  --Entrada
  Begin

    Set @cd_tipo_movimento = 11
    Set @cd_tipo_documento = 3
    Set @ic_movimenta_reserva = 'N'

  End


  --Cursor para realizar a movimentação da Nota_Fiscal
  --Foi inativado, pois no delphi será passado realmente os intes da NF que não movimentaram.
  /*
  declare cCursor cursor for
    Select
      cd_nota_saida,
      cd_item_nota_saida
    From #Tabela

  open cCursor
  fetch next from cCursor into @documento,  @Item

  while (@@FETCH_STATUS =0)
  begin

*/
    select
      @item_pedido_venda = cd_item_pedido_venda,
      @produto           = cd_produto,
      @fase_produto      = cd_fase_produto,
      @qt_item           = qt_item_nota_saida,
      @dt_nota_saida     = dt_nota_saida,
      @vl_total          = vl_total_item,
      @vl_unitario       = vl_unitario_item_nota,
      @cd_dest           = cd_cliente,
      @cd_user           = cd_usuario,
      @cd_tipo_dest      = cd_tipo_destinatario,
      @nm_fantasia_dest  = nm_fantasia_destinatario
    From
      #Tabela
    Where
      cd_nota_saida          = @cd_nota_saida       --@documento
      and cd_item_nota_saida = @cd_item_nota_saida  --@item

    --Executa a Procedure para Movimentação do Estoque
    exec pr_movimenta_estoque
      @ic_parametro              = 1,
      @cd_tipo_movimento_estoque = @cd_tipo_movimento,
      @cd_tipo_movimento_estoque_old = 0,
      @nm_historico_movimento    = 'Movimentação de estoque da NF',
      @cd_produto                = @produto,
      @cd_fase_produto           = @fase_produto,
      @qt_produto_atualizacao    = @qt_item,
      @qt_produto_atualizacao_old = 0,
      @cd_centro_custo           = 0,
      @dt_movimento_estoque      = @Now,
      @cd_documento_movimento    = @cd_nota_saida,
      @cd_item_documento         = @cd_item_nota_saida,
      @cd_tipo_documento_estoque = @cd_tipo_documento,
      @dt_documento_movimento    = @dt_nota_saida,
      @vl_unitario_movimento     = @vl_unitario,
      @vl_total_movimento        = @vl_total,
      @ic_peps_movimento_estoque = 'S',
      @ic_terceiro_movimento     = 'N',
      @ic_consig_movimento       = 'N',
      @ic_mov_movimento          = 'S',
      @cd_fornecedor             = @cd_dest,
      @ic_fase_entrada_movimento = '',
      @cd_fase_produto_entrada   = 0,
      @cd_usuario                = @cd_user,
      @dt_usuario                = @Now,
      @cd_tipo_destinatario      = @cd_tipo_dest,
      @nm_destinatario           = @nm_fantasia_dest

    If @cd_tipo_operacao = 1 --Entrada
    Begin
      --Atualiza o Saldo da Reserva
      exec pr_movimenta_estoque
        @ic_parametro                 = 3,
        @cd_tipo_movimento_estoque    = 3, --Cancelamento da reserva para movimento de entrada
        @cd_tipo_movimento_estoque_old = 0,
        @dt_movimento_estoque         = @Now,
        @cd_produto                   = @Produto,
        @cd_fase_produto              = @Fase_Produto,
        @qt_produto_atualizacao       = @qt_item,
        @qt_produto_atualizacao_old   = 0,
        @cd_centro_custo              = 0
    End

    If @ic_movimenta_reserva = 'S'
    Begin
      exec pr_movimenta_estoque
        @ic_parametro              = 1,
        @cd_tipo_movimento_estoque = @cd_tipo_movimento_r,
        @cd_tipo_movimento_estoque_old = 0,
        @nm_historico_movimento    = 'Movimentação de estoque da NF',
        @cd_produto                = @produto,
        @cd_fase_produto           = @fase_produto,
        @qt_produto_atualizacao    = @qt_item,
        @qt_produto_atualizacao_old = 0,
        @cd_centro_custo           = 0,
        @dt_movimento_estoque      = @Now,
        @cd_documento_movimento    = @cd_nota_saida,
        @cd_item_documento         = @cd_item_nota_saida,
        @cd_tipo_documento_estoque = @cd_tipo_documento_r,
        @dt_documento_movimento    = @dt_nota_saida,
        @vl_unitario_movimento     = @vl_unitario,
        @vl_total_movimento        = @vl_total,
        @ic_peps_movimento_estoque = 'S',
        @ic_terceiro_movimento     = 'N',
        @ic_consig_movimento       = 'N',
        @ic_mov_movimento          = 'S',
        @cd_fornecedor             = @cd_dest,
        @ic_fase_entrada_movimento = '',
        @cd_fase_produto_entrada   = 0,
        @cd_usuario                = @cd_user,
        @dt_usuario                = @Now,
        @cd_tipo_destinatario      = @cd_tipo_dest,
        @nm_destinatario           = @nm_fantasia_dest
    End

/*
    fetch next from cCursor into @documento,  @Item
  end
  close cCursor
  deallocate cCursor
*/
