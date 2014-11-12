CREATE PROCEDURE pr_gerar_reserva_pedido_aberto
@dt_dia_util_mes_seguinte datetime,
@cd_fase_produto int,
@cd_usuario int
as

declare
    @cd_documento_movimento_om int,
    @cd_item_documento_om int,
    @dt_documento_movimento_om datetime,
    @qt_movimento_estoque_om float,
    @cd_fornecedor_om int,
    @cd_produto_om int,
		@cd_produto_composicao int, 
    @qt_produto_composicao float, 
    @dt_fechamento_pedido datetime, 
    @cd_pedido_venda int, 
    @cd_item_pedido_venda int, 
    @dt_pedido_venda datetime,
    @cd_cliente int,
	  @cd_produto_pai_reserva int, 
    @cd_produto_reserva int, 
    @qt_produto_reserva float, 
    @cd_fase_produto_reserva int,
    @cd_codigo int,
    @Tabela varchar(30),
    @cd_movimento_estoque int


if IsNull(@cd_fase_produto,0) = 0
   Select top 1 @cd_fase_produto = cd_fase_produto from parametro_comercial where cd_empresa = dbo.fn_empresa()


set @Tabela = Db_Name() + '.dbo.Movimento_Estoque'

delete from 
  Movimento_Estoque
from 
  Movimento_Estoque      me  left outer join 
  Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
where 
  tme.nm_atributo_produto_saldo = 'qt_saldo_reserva_produto'


update produto_saldo
set qt_saldo_reserva_produto = qt_saldo_atual_produto
where cd_fase_produto = @cd_fase_produto

    select 
      identity(int, 1, 1)         							as codigo,
      0                           							as cd_movimento_estoque, --@cd_movimento_estoque
      --Se data de fechamento do pedido for maior que data final colocar no movimento
      --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
      @dt_dia_util_mes_seguinte                 as dt_movimento_estoque,
      2                           							as cd_tipo_movimento_estoque,
      cast(pv.cd_pedido_venda as varchar)       as cd_documento_movimento,
      pvi.cd_item_pedido_venda    							as cd_item_documento,
      7 		                        						as cd_tipo_documento_estoque, 
      pv.dt_pedido_venda 		        						as dt_documento_movimento,
      0      		                        				as cd_centro_custo, 
      pvi.qt_saldo_pedido_venda
      - IsNull((Select top 1 qt_item_om from OM where cd_pedido_venda = pvi.cd_pedido_venda
                and cd_item_pedido_venda = pvi.cd_item_pedido_venda and ic_movimentado = 'N'),0) as qt_movimento_estoque,
      pvi.vl_unitario_item_pedido 							as vl_unitario_movimento,
      (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as vl_total_movimento, 
      'S'                         							as ic_peps_movimento_estoque, 
      'N'                         							as ic_terceiro_movimento, 
      'PV ' + cast(pv.cd_pedido_venda as varchar) + ' It. ' + cast(pvi.cd_item_pedido_venda as varchar) as nm_historico_movimento, 
      'S'                         							as ic_mov_movimento, 
      1                           							as cd_tipo_destinatario,
      pv.cd_cliente               							as cd_fornecedor,
      Cast(null as varchar(40))   							as nm_destinatario,
      0     		                								as cd_origem_baixa_produto,
      pvi.cd_produto              							as cd_produto, 
      @cd_fase_produto            							as cd_fase_produto, 
      'N'                         							as ic_fase_entrada_movimento, 
      0 		                        						as cd_fase_produto_entrada, 
      pv.cd_usuario               							as cd_usuario, 
      Getdate()                   							as dt_usuario
    into
      #Movimento_Reserva
    from
      Pedido_Venda      pv  inner join
      Pedido_Venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
      Tipo_Pedido       tp  on pv.cd_tipo_pedido = tp.cd_tipo_pedido
    where
      --Trazer somente pedidos que tenham saldo a faturar
      IsNull(pvi.qt_saldo_pedido_venda, 0) > 0 and
      --Trazer somente pedidos que não foram cancelados
      pvi.dt_cancelamento_item is null and
      --Trazer somente pedidos que a data do pedido seja inferior a data final do fechamento
      --Trazer somente pedidos que o tipo movimenta o estoque
      tp.ic_sce_tipo_pedido    = 'S' and
      --Trazer somente pedidos que a data de fechamento não seja nula
      pv.dt_fechamento_pedido  is not null and
      --Somente produtos padronizados
      isnull(pvi.cd_produto,0) > 0



insert into #Movimento_Reserva
(
        cd_movimento_estoque, 
        dt_movimento_estoque, 
        cd_tipo_movimento_estoque,
        cd_documento_movimento,
        cd_item_documento,
        cd_tipo_documento_estoque, 
        dt_documento_movimento,
        cd_centro_custo, 
        qt_movimento_estoque,
        vl_unitario_movimento,
        vl_total_movimento, 
        ic_peps_movimento_estoque, 
        ic_terceiro_movimento, 
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
        cd_usuario, 
        dt_usuario
)
Select
      0                           							as cd_movimento_estoque, --@cd_movimento_estoque
      --Se data de fechamento do pedido for maior que data final colocar no movimento
      --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
      @dt_dia_util_mes_seguinte                 as dt_movimento_estoque,
      2                           							as cd_tipo_movimento_estoque,
      cast(ns.cd_nota_saida as varchar)         as cd_documento_movimento,
      nsi.cd_item_nota_saida      							as cd_item_documento,
      4 		                        						as cd_tipo_documento_estoque, 
      ns.dt_nota_saida   		        			   		as dt_documento_movimento,
      0      		                        				as cd_centro_custo, 
      (IsNull(nsi.qt_item_nota_saida,0) - 
       IsNull(nsi.qt_devolucao_item_nota,0))    as qt_movimento_estoque,
      nsi.vl_unitario_item_nota 					   		as vl_unitario_movimento,
      (nsi.vl_unitario_item_nota * 
      (IsNull(nsi.qt_item_nota_saida,0) - 
      IsNull(nsi.qt_devolucao_item_nota,0)))    as vl_total_movimento, 
      'S'                         							as ic_peps_movimento_estoque, 
      'N'                         							as ic_terceiro_movimento, 
      'NF Saída ' + cast(ns.cd_nota_saida as varchar) + ' ' + (Select top 1 nm_fantasia_cliente from cliente where cd_cliente = ns.cd_cliente) as nm_historico_movimento, 
      'S'                         							as ic_mov_movimento, 
      1                           							as cd_tipo_destinatario,
      ns.cd_cliente               							as cd_fornecedor,
      Cast(null as varchar(40))   							as nm_destinatario,
      0     		                								as cd_origem_baixa_produto,
      nsi.cd_produto              							as cd_produto, 
      @cd_fase_produto            							as cd_fase_produto, 
      'N'                         							as ic_fase_entrada_movimento, 
      0 		                        						as cd_fase_produto_entrada, 
      ns.cd_usuario               							as cd_usuario, 
      Getdate()                   							as dt_usuario
		from 
			Nota_Saida ns 
  		inner join 
		  Operacao_fiscal op
		  on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
			left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
		where ns.dt_nota_saida  >= @dt_dia_util_mes_seguinte
					and ns.cd_status_nota <> 7
					and (IsNull(nsi.qt_item_nota_saida,0) - IsNull(nsi.qt_devolucao_item_nota,0)) > 0
		      and op.cd_tipo_movimento_estoque = 11
		      --Somente produtos padronizados
		      and isnull(nsi.cd_produto,0) > 0



    --Buscando produtos em ordens de montagem para serem reservados
    declare cPedido_OM cursor for
    select 
      pv.cd_pedido_venda                			as cd_documento_movimento_om,
      pvi.cd_item_pedido_venda								as cd_item_documento_om,
      pv.dt_pedido_venda											as dt_documento_movimento_om,
      omc.qt_item_om                  	      as qt_movimento_estoque_om,
      pv.cd_cliente														as cd_fornecedor_om,
      omc.cd_produto													as cd_produto_om
    from
      Pedido_Venda      pv                                              inner join
      Pedido_Venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda inner join
      Tipo_Pedido       tp  on pv.cd_tipo_pedido = tp.cd_tipo_pedido    inner join
      om                om  on pv.cd_pedido_venda = om.cd_pedido_venda and pvi.cd_item_pedido_venda = om.cd_item_pedido_venda inner join
      om_composicao     omc on om.cd_om = omc.cd_om
    where
      --Trazer somente pedidos que tenham saldo a faturar
      IsNull(pvi.qt_saldo_pedido_venda, 0) > 0 and
      --Trazer somente pedidos que não foram cancelados
      pvi.dt_cancelamento_item is null and
      --Trazer somente pedidos que o tipo movimenta o estoque
      isnull(tp.ic_sce_tipo_pedido, 'S') = 'S' and
      --Trazer somente pedidos que a data de fechamento não seja nula
      pv.dt_fechamento_pedido  is not null
    order by
      1    

    open cPedido_OM
    fetch next from cPedido_OM into
      @cd_documento_movimento_om,
      @cd_item_documento_om,
      @dt_documento_movimento_om,
      @qt_movimento_estoque_om,
      @cd_fornecedor_om,
      @cd_produto_om

    print('Pedidos com OM')

    --Varrendo todos os componentes dos itens especiais dos pedido de venda
    --e adicionando na tabela de reservas
    while (@@FETCH_STATUS = 0)
    begin

      insert into
        #Movimento_Reserva
        (
        cd_movimento_estoque, 
        dt_movimento_estoque, 
        cd_tipo_movimento_estoque,
        cd_documento_movimento,
        cd_item_documento,
        cd_tipo_documento_estoque, 
        dt_documento_movimento,
        cd_centro_custo, 
        qt_movimento_estoque,
        vl_unitario_movimento,
        vl_total_movimento, 
        ic_peps_movimento_estoque, 
        ic_terceiro_movimento, 
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
        cd_usuario, 
        dt_usuario
        )
      values(
       0,
      --Se data de fechamento do pedido for maior que data final colocar no movimento
      --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
      @dt_dia_util_mes_seguinte,
      2,
      cast(@cd_documento_movimento_om as varchar(20)),
      @cd_item_documento_om,
      7, 
      @dt_documento_movimento_om,
      0, 
      @qt_movimento_estoque_om,
      0,
      0, 
      'S', 
      'N', 
      'PV ' + cast(@cd_documento_movimento_om as varchar(20)) + ' It. ' + cast(@cd_item_documento_om as varchar), 
      'S', 
      1,
      @cd_fornecedor_om,
      '',
      0,
      @cd_produto_om, 
      @cd_fase_produto, 
      'N', 
      0, 
      @cd_usuario, 
      getdate())       

      fetch next from cPedido_OM into
        @cd_documento_movimento_om,
        @cd_item_documento_om,
        @dt_documento_movimento_om,
        @qt_movimento_estoque_om,
        @cd_fornecedor_om,
        @cd_produto_om
    end

    close cPedido_OM
    deallocate cPedido_OM


    --Declarado cursor para buscar a composição
    print('Declarando cursor com as reservas')

    declare cReserva_Composicao cursor for
    select
      cd_produto,
      qt_movimento_estoque,
      dt_movimento_estoque,
      cd_documento_movimento, 
      cd_item_documento,
      dt_documento_movimento,
      cd_fornecedor
    from
      #Movimento_Reserva
   
    open cReserva_Composicao
    fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, @dt_fechamento_pedido, @cd_pedido_venda, @cd_item_pedido_venda, @dt_pedido_venda, @cd_cliente

    while (@@FETCH_STATUS = 0)
    begin      
      if exists(select '1' from fn_composicao_produto(@cd_produto_composicao))
      begin
        
       --Declarando cursor para buscar a composição
        print('Declarando cursor para buscar a composição')

        declare cReserva_Comp_Movimento cursor for
        select
          cd_produto_pai,
          cd_produto,
          qt_produto_composicao,
          cd_fase_produto
        from
          fn_composicao_produto(@cd_produto_composicao)

        open  cReserva_Comp_Movimento
        fetch next from cReserva_Comp_Movimento into @cd_produto_pai_reserva, @cd_produto_reserva, @qt_produto_reserva, @cd_fase_produto_reserva

        while (@@FETCH_STATUS = 0)
        begin

          insert into
            #Movimento_Reserva
            (
            cd_movimento_estoque, 
            dt_movimento_estoque, 
            cd_tipo_movimento_estoque,
            cd_documento_movimento,
            cd_item_documento,
            cd_tipo_documento_estoque, 
            dt_documento_movimento,
            cd_centro_custo, 
            qt_movimento_estoque,
            vl_unitario_movimento,
            vl_total_movimento, 
            ic_peps_movimento_estoque, 
            ic_terceiro_movimento, 
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
            cd_usuario, 
            dt_usuario
            )
          values(
           0,
          --Se data de fechamento do pedido for maior que data final colocar no movimento
          --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
          @dt_dia_util_mes_seguinte,
          2,
          cast(@cd_pedido_venda as varchar),
          @cd_item_pedido_venda,
          7, 
          @dt_pedido_venda,
          0, 
          @qt_produto_composicao * @qt_produto_reserva,
          0,
          0, 
          'S', 
          'N', 
          'PV ' + cast(@cd_pedido_venda as varchar) + ' It. ' + cast(@cd_item_pedido_venda as varchar),
          'S', 
          1,
          @cd_cliente,
          '',
          0,
          @cd_produto_reserva, 
          @cd_fase_produto_reserva, 
          'N', 
          0, 
          @cd_usuario, 
          getdate())

          fetch next from cReserva_Comp_Movimento into @cd_produto_pai_reserva, @cd_produto_reserva, @qt_produto_reserva, @cd_fase_produto_reserva   
        end
        close cReserva_Comp_Movimento
        deallocate cReserva_Comp_Movimento
      end
      fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, @dt_fechamento_pedido, @cd_pedido_venda, @cd_item_pedido_venda, @dt_pedido_venda, @cd_cliente
    end        

    close cReserva_Composicao
    deallocate cReserva_Composicao

    -- GRAVAÇÃO DO CÓDIGO DA TABELA DE MOVIMENTO ESTOQUE
    declare cCursor cursor for
    select
      codigo
    from
      #Movimento_Reserva
			
    open cCursor
    fetch next from cCursor into @cd_codigo
			
    while (@@FETCH_STATUS = 0)
    begin
      
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output
	
      Update 
        #Movimento_Reserva
      set 
        cd_movimento_estoque = @cd_movimento_estoque
      Where 
        codigo = @cd_codigo
	
      fetch next from cCursor into @cd_codigo

    end

    close cCursor
    deallocate cCursor

    -- GRAVAÇÃO DOS MOVIMENTOS DE ESTOQUE
    Insert into 
      Movimento_Estoque
        (cd_movimento_estoque, 
         dt_movimento_estoque, 
         cd_tipo_movimento_estoque, 
         cd_documento_movimento,
         cd_item_documento, 
         cd_tipo_documento_estoque, 
         dt_documento_movimento, 
         cd_centro_custo, 
         qt_movimento_estoque, 
         vl_unitario_movimento, 
         vl_total_movimento, 
         ic_peps_movimento_estoque, 
         ic_terceiro_movimento, 
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
         cd_usuario, 
         dt_usuario)
    Select
      cd_movimento_estoque, 
      dt_movimento_estoque, 
      cd_tipo_movimento_estoque, 
      cd_documento_movimento,
      cd_item_documento, 
      cd_tipo_documento_estoque, 
      dt_documento_movimento, 
      cd_centro_custo, 
      qt_movimento_estoque, 
      vl_unitario_movimento, 
      vl_total_movimento, 
      ic_peps_movimento_estoque, 
      ic_terceiro_movimento, 
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
      cd_usuario, 
      dt_usuario
    from
      #Movimento_Reserva

    -- LIMPEZA DOS CÓDIGOS GERADOS PARA O MOVIMENTO DE ESTOQUE
    declare cLimpaCodigo cursor for
    select 
      cd_movimento_estoque
    from 
      #Movimento_Reserva
 
    open cLimpaCodigo
    fetch next from cLimpaCodigo into @cd_movimento_estoque

    while (@@FETCH_STATUS =0)
    begin
         
     -- limpeza da tabela de código
     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'	

     fetch next from cLimpaCodigo into @cd_movimento_estoque
  
    end

    close cLimpaCodigo
    deallocate cLimpaCodigo
