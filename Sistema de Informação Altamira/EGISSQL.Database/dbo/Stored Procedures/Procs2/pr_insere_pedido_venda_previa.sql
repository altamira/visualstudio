
create procedure pr_insere_pedido_venda_previa
@ic_parametro int,
@cd_pedido_venda int,
@cd_usuario int

as

  declare @cd_previa_faturamento int
  declare @nm_tabela varchar(100)
  declare @nm_historico varchar(100)
  declare @cd_item_pedido_venda int
  declare @dt_previa_faturamento datetime
  declare @qt_previa_faturamento float
  declare @ic_etiqueta_emb_previa char(1)
  declare @vl_item_previa_faturam decimal(25,2)
  declare @qt_volume_previa_faturam float
  declare @qt_bruto_previa_faturam float
  declare @qt_liquido_previa_faturam float
  declare @cd_departamento int
  declare @cd_item_previa int

  -- REGRAS PARA A GERAÇÃO DE AUTOMÁTICA PRÉVIA
  -- 1º TEM DE SER IMEDIATO
  -- 2º NÃO PODE SER PRODUTO ESPECIAL
  -- 3º DEVE ESTAR FECHADO
  -- 4º NÃO PODE ESTAR CANCELADO
  -- 5º DEVE TER O DESCONTO E CREDITO LIBERADOS
  -- 6º NÃO DEVE TER SIDO INCLUÍDA EM PRÉVIAS ANTERIORES



-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Insere novos Pedidos a Prévia de Faturamento - IMEDIATOS
-------------------------------------------------------------------------------
begin

--    begin transaction

  -----------------------------------------------------------------------------
  -- ITENS DO PEDIDO QUE SE TORNARÃO ITENS DE PRÉVIA DE FATURAMENTO
  -----------------------------------------------------------------------------

  select  
    a.cd_pedido_venda             as 'Pedido',
    b.dt_fechamento_pedido        as 'Data',
    c.nm_fantasia_cliente         as 'Cliente',
    b.cd_item_pedido_venda        as 'Item',
    b.qt_item_pedido_venda        as 'Qtde',
    b.qt_saldo_pedido_venda       as 'Saldo',
    isnull(b.ic_etiqueta_emb_pedido,'N')      as 'Etiqueta',
    qt_liquido_item_pedido        as 'LiquidoItem',
    BrutoUnitario = 
       Case when (qt_bruto_item_pedido > 0) and (qt_item_pedido_venda > 0) then
          qt_bruto_item_pedido / qt_item_pedido_venda
       else 0 end,
    LiquidoUnitario = 
       Case when (qt_liquido_item_pedido > 0) and (qt_item_pedido_venda > 0) then
          qt_liquido_item_pedido / qt_item_pedido_venda
       else 0 end,
    qt_bruto_item_pedido          as 'BrutoItem',
    b.qt_saldo_pedido_venda * qt_bruto_item_pedido       as 'BrutoSaldo',
    b.qt_saldo_pedido_venda * qt_liquido_item_pedido     as 'LiquidoSaldo',
    b.vl_unitario_item_pedido     as 'VlrUnitario',
    b.qt_saldo_pedido_venda * b.vl_unitario_item_pedido  as 'VlrTotal'
  into
    #Previa
  from Pedido_Venda a, Pedido_Venda_Item b, Cliente c
  where b.cd_pedido_venda                     = @cd_pedido_venda and
        b.cd_pedido_venda                     = a.cd_pedido_venda and
        a.cd_cliente                          = c.cd_cliente and
        isnull(b.ic_produto_especial,'N')     = 'N' and
        isnull(b.qt_dia_entrega_pedido,0)     = 0 and
        isnull(b.ic_sel_fechamento,'N')       = 'S' and
-- COMENTADO, POIS O CRÉDITO SOMENTE É FEITO DEPOIS DO PEDIDO FECHADO
--        a.dt_credito_pedido_venda is not null and   
        b.dt_cancelamento_item is null and
        isnull(b.ic_fatura_item_pedido,'N')   = 'N' and
        not exists (select 'x' from Previa_Faturamento_Composicao pfc
                    where pfc.cd_pedido_venda = b.cd_pedido_venda and
                          pfc.cd_item_pedido_venda = b.cd_item_pedido_venda)

  if not exists(select 'x' from #Previa)
  begin
   -- raiserror('Pedido de Venda Informado não Pode Participar de Prévia de Faturamento. Verifique!', 16, 1)
   return
  end


  -- DEPARTAMENTO DO USUÁRIO
  select @cd_departamento = cd_departamento 
  from egisadmin.dbo.usuario
  where cd_usuario = @cd_usuario
  
  -----------------------------------------------------------------------------
  -- GRAVANDO A PREVIA_FATURAMENTO
  -----------------------------------------------------------------------------

  -- Verifica a existência de uma Prévia para o Dia de Fechamento do Pedido de Venda
  if not exists(select 'x' from previa_faturamento 
                where dt_previa_faturamento in (select Data from #Previa))
  begin

    -- Caso não Exista, cria um novo Registro para a Prévia

    print('Criou a Prévia')

    set @nm_tabela = Db_Name() + '.dbo.Previa_Faturamento'  
    exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_previa_faturamento', @codigo = @cd_previa_faturamento output

    insert into Previa_Faturamento
    (cd_previa_faturamento, dt_previa_faturamento, qt_pedido_previa_faturam,
     vl_pedido_previa_faturam, ds_pedido_previa_faturam, cd_usuario, dt_usuario,
     vl_previa_faturamento, nm_previa_faturamento, ic_fatura_previa_faturam)
    select @cd_previa_faturamento, (select max(Data) from #Previa), 
           (select count('x') from #Previa), 
           (select sum(VlrTotal) from #Previa), 'IMEDIATO',
           @cd_usuario, getDate(), 
           (select sum(VlrTotal) from #Previa), 'IMEDIATO', 'N'

    exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_previa_faturamento, 'D'	

  end
  else
  begin
    
    print('Atualizou a Prévia')

    -- Caso Exista, atualiza o Registro de Prévia
    update Previa_Faturamento
    set qt_pedido_previa_faturam = qt_pedido_previa_faturam + (select count('x') from #Previa),
        vl_previa_faturamento = vl_previa_faturamento + (select sum(VlrTotal) from #Previa),
        cd_usuario = @cd_usuario,
        dt_usuario = getDate()
    from #Previa 
    where dt_previa_faturamento = Data

    select @cd_previa_faturamento = cd_previa_faturamento
    from previa_faturamento  
    where dt_previa_faturamento = (select Data from #Previa)
    
  end

  -- HISTÓRICO DA PRÉVIA
  set @nm_historico = 'Prévia Nº '+cast(@cd_previa_faturamento as varchar)+' de '+
                                   cast(datepart(dd,getDate()) as varchar)+'/'+
                                   cast(datepart(mm,getDate()) as varchar)+'/'+
                                   cast(datepart(yy,getDate()) as varchar)

  print(@nm_historico)

  -----------------------------------------------------------------------------
  -- GRAVANDO A PREVIA_FATURAMENTO_COMPOSICAO
  -----------------------------------------------------------------------------

  -- ITEM DA PRÉVIA
  set @cd_item_previa = isnull((select max(cd_item_previa_faturam) + 1
                                from Previa_Faturamento_Composicao
                                where cd_previa_faturamento = @cd_previa_faturamento),1)

  declare cPrevia cursor for
  select Item, Data, Qtde, Etiqueta, VlrTotal, BrutoSaldo, LiquidoSaldo from #Previa
  order by Item

  open cPrevia
  fetch next from cPrevia into
  @cd_item_pedido_venda, @dt_previa_faturamento, @qt_previa_faturamento, @ic_etiqueta_emb_previa, 
  @vl_item_previa_faturam, @qt_bruto_previa_faturam, @qt_liquido_previa_faturam

  while (@@FETCH_STATUS = 0)
  begin
    
    insert into Previa_Faturamento_Composicao
    (cd_previa_faturamento, cd_item_previa_faturam, cd_pedido_venda, cd_item_pedido_venda,
     qt_previa_faturamento, ic_etiqueta_emb_previa, nm_obs_item_previa_fatura, cd_usuario,
     dt_usuario, vl_item_previa_faturam, qt_volume_previa_faturam, qt_bruto_previa_faturam,
     qt_liquido_previa_faturam, ic_total_previa_faturam, ic_fatura_previa_faturam)
    values (@cd_previa_faturamento, @cd_item_previa, @cd_pedido_venda, @cd_item_pedido_venda,
            @qt_previa_faturamento, @ic_etiqueta_emb_previa, 'IMEDIATO', @cd_usuario, 
            getDate(), @vl_item_previa_faturam, 1, @qt_bruto_previa_faturam, 
            @qt_liquido_previa_faturam, 'N', 'N')

    ---------------------------------------------------------------------------
    -- HISTÓRICO DO PEDIDO DE VENDA
    ---------------------------------------------------------------------------
    exec pr_atualiza_situacao_pedido_venda
      @cd_modulo = 0,
      @cd_processo = 3,        
      @cd_departamento = @cd_departamento,
      @cd_pedido_venda = @cd_pedido_venda,        
      @cd_item_pedido_venda = @cd_item_pedido_venda,
      @dt_pedido_venda_historico = @dt_previa_faturamento,
      @cd_historico_pedido = 26,
      @nm_pedido_venda_histor_1 = @nm_historico,
      @nm_pedido_venda_histor_2 = null,
      @nm_pedido_venda_histor_3 = null,
      @nm_pedido_venda_histor_4 = null,
      @cd_usuario = @cd_usuario,
      @cd_tipo = 1

    set @cd_item_previa = @cd_item_previa + 1

    fetch next from cPrevia into
    @cd_item_pedido_venda, @dt_previa_faturamento, @qt_previa_faturamento, @ic_etiqueta_emb_previa, 
    @vl_item_previa_faturam, @qt_bruto_previa_faturam, @qt_liquido_previa_faturam

  end

  close cPrevia
  deallocate cPrevia

--   if @@Error = 0
--     commit transaction
--   else
--     rollback transaction  

end

