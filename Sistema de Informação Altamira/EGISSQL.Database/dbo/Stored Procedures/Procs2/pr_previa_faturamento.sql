
Create procedure pr_previa_faturamento
@ic_parametro int,
@cd_pedido_venda int,
--Item do pedido de venda para exclusão.
@cd_pedido_venda_item int = -1,
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
  declare @dt_historico_pedido_venda datetime

  -- REGRAS PARA A GERAÇÃO DE AUTOMÁTICA PRÉVIA
  -- 1º TEM DE SER IMEDIATO
  -- 2º NÃO PODE SER PRODUTO ESPECIAL
  -- 3º DEVE ESTAR FECHADO
  -- 4º NÃO PODE ESTAR CANCELADO
  -- 5º DEVE TER O DESCONTO E CREDITO LIBERADOS
  -- 6º NÃO DEVE TER SIDO INCLUÍDA EM PRÉVIAS ANTERIORES


  -- DEPARTAMENTO DO USUÁRIO
  select @cd_departamento = cd_departamento 
  from egisadmin.dbo.usuario
  where cd_usuario = @cd_usuario

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Insere novos Pedidos a Prévia de Faturamento - IMEDIATOS
-------------------------------------------------------------------------------
begin

  -----------------------------------------------------------------------------
  -- ITENS DO PEDIDO QUE SE TORNARÃO ITENS DE PRÉVIA DE FATURAMENTO
  -----------------------------------------------------------------------------

  select  
    a.cd_pedido_venda             as 'Pedido',
    a.dt_fechamento_pedido        as 'Data',
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

  ---Marcio Begin
  if @cd_pedido_venda_item <> -1 
  begin
		Delete from #Previa
      where item <> @cd_pedido_venda_item
  end	  
  ---Marcio End
 

 -- DATA DA PRÉVIA
  select @dt_previa_faturamento = max(Data)
  from #Previa
  
  -----------------------------------------------------------------------------
  -- GRAVANDO A PREVIA_FATURAMENTO
  -----------------------------------------------------------------------------

  -- Verifica a existência de uma Prévia para o Dia de Fechamento do Pedido de Venda
  if not exists(select 'x' from previa_faturamento 
                where dt_previa_faturamento in (select Data from #Previa) and
                      ic_previa_imediato = 'S')
  begin

    -- Caso não Exista, cria um novo Registro para a Prévia

    set @nm_tabela = Db_Name() + '.dbo.Previa_Faturamento'  
    exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_previa_faturamento', @codigo = @cd_previa_faturamento output

    insert into Previa_Faturamento
    (cd_previa_faturamento, dt_previa_faturamento, qt_pedido_previa_faturam,
     vl_pedido_previa_faturam, ds_pedido_previa_faturam, cd_usuario, dt_usuario,
     vl_previa_faturamento, nm_previa_faturamento, ic_fatura_previa_faturam, ic_previa_imediato)
    select @cd_previa_faturamento, @dt_previa_faturamento, 
           (select count('x') from #Previa), 
           (select sum(VlrTotal) from #Previa), 'IMEDIATO',
           @cd_usuario, getDate(), 
           (select sum(VlrTotal) from #Previa), 'IMEDIATO', 'N', 'S'

    exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_previa_faturamento, 'D'	

  end
  else
  begin
    
    -- Caso Exista, atualiza o Registro de Prévia
    update Previa_Faturamento 
    set qt_pedido_previa_faturam = qt_pedido_previa_faturam + (select count('x') from #Previa),
        vl_pedido_previa_faturam = vl_pedido_previa_faturam + (select sum(VlrTotal) from #Previa),
        vl_previa_faturamento = vl_previa_faturamento + (select sum(VlrTotal) from #Previa),
        cd_usuario = @cd_usuario,
        dt_usuario = getDate()
    where dt_previa_faturamento = @dt_previa_faturamento and
          ic_previa_imediato = 'S'

    select @cd_previa_faturamento = cd_previa_faturamento
    from previa_faturamento  
    where dt_previa_faturamento in (select Data from #Previa)
    
  end

  -- HISTÓRICO DA PRÉVIA
  set @nm_historico = 'Prévia Nº '+cast(@cd_previa_faturamento as varchar)+' de '+
                                   cast(datepart(dd,@dt_previa_faturamento) as varchar)+'/'+
                                   cast(datepart(mm,@dt_previa_faturamento) as varchar)+'/'+
                                   cast(datepart(yy,@dt_previa_faturamento) as varchar)

  -----------------------------------------------------------------------------
  -- GRAVANDO A PREVIA_FATURAMENTO_COMPOSICAO
  -----------------------------------------------------------------------------

  -- ITEM DA PRÉVIA
  set @cd_item_previa = isnull((select max(cd_item_previa_faturam) + 1
                                from Previa_Faturamento_Composicao
                                where cd_previa_faturamento = @cd_previa_faturamento),1)

  declare cPrevia cursor for
  select Item, Qtde, Etiqueta, VlrTotal, BrutoSaldo, LiquidoSaldo from #Previa
  order by Item

  open cPrevia
  fetch next from cPrevia into
  @cd_item_pedido_venda, @qt_previa_faturamento, @ic_etiqueta_emb_previa, 
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

    --Atualiza campo informando que o pedido encontra-se em prévia

  update pedido_venda_item 
  set ic_fatura_item_pedido = 'S',
      ic_libpcp_item_pedido = 'S' 
  where 
	  cd_pedido_venda = @cd_pedido_venda 
	  and cd_item_pedido_venda = @cd_item_pedido_venda

    set @cd_item_previa = @cd_item_previa + 1

    fetch next from cPrevia into
    @cd_item_pedido_venda, @qt_previa_faturamento, @ic_etiqueta_emb_previa, 
    @vl_item_previa_faturam, @qt_bruto_previa_faturam, @qt_liquido_previa_faturam

  end

  close cPrevia
  deallocate cPrevia

  --Define a data para o histórico do PV (Data + Hora)
  select 
      @dt_historico_pedido_venda = DateAdd(n, 1, getdate())

  ---------------------------------------------------------------------------
  -- HISTÓRICO DO PEDIDO DE VENDA
  ---------------------------------------------------------------------------
  exec pr_atualiza_situacao_pedido_venda
    @cd_modulo = 0,
    @cd_processo = 3,        
    @cd_departamento = @cd_departamento,
    @cd_pedido_venda = @cd_pedido_venda,        
    @cd_item_pedido_venda = 0,
    @dt_pedido_venda_historico = @dt_historico_pedido_venda,
    @cd_historico_pedido = 26,
    @nm_pedido_venda_histor_1 = @nm_historico,
    @nm_pedido_venda_histor_2 = null,
    @nm_pedido_venda_histor_3 = null,
    @nm_pedido_venda_histor_4 = null,
    @cd_usuario = @cd_usuario,
    @cd_tipo = 1

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Exclui Pedido de Venda da Prévia
-------------------------------------------------------------------------------
begin

  -----------------------------------------------------------------------------
  -- ITENS DO PEDIDO QUE SERÃO EXCLUÍDOS DA PRÉVIA DE FATURAMENTO
  -----------------------------------------------------------------------------
  select 
    	pvi.cd_item_pedido_venda        as 'Item',
    	pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido  as 'VlrTotal'
  into
		#PreviaExclusao
  from
    Pedido_Venda pv with (nolock)
		inner join Pedido_Venda_Item pvi with (nolock)
      on pv.cd_pedido_venda = pvi.cd_pedido_venda
	  inner join Previa_Faturamento_Composicao pcf with (nolock)
		  on pvi.cd_pedido_venda = pcf.cd_pedido_venda 
		  and pvi.cd_item_pedido_venda = pcf.cd_item_pedido_venda     
    inner join Previa_Faturamento pf with (nolock)
      on pcf.cd_previa_faturamento = pf.cd_previa_faturamento
  where 
		pv.cd_pedido_venda = @cd_pedido_venda and
    pv.dt_pedido_venda = pf.dt_previa_faturamento
  

 ---Marcio Begin
  if @cd_pedido_venda_item <> -1 
  begin
		Delete from #PreviaExclusao 
      where item <> @cd_pedido_venda_item
  end	  
 ---Marcio End

  --Caso não exista mais nenhum item sai da proce
  if ( ( Select Count('x') from #PreviaExclusao ) = 0 )
    return

  -- ENCONTRANDO CÓDIGO E DATA DA PRÉVIA
  select @cd_previa_faturamento = pf.cd_previa_faturamento,
         @dt_previa_faturamento = pf.dt_previa_faturamento
  from Previa_Faturamento_Composicao pfc, Previa_Faturamento pf
  where pf.cd_previa_faturamento = pfc.cd_previa_faturamento and
        pfc.cd_pedido_venda = @cd_pedido_venda

  -----------------------------------------------------------------------------
  -- ATUALIZANDO A PREVIA_FATURAMENTO
  -----------------------------------------------------------------------------

  if exists(select 'x' from #PreviaExclusao)
  begin
    update Previa_Faturamento
    set qt_pedido_previa_faturam = qt_pedido_previa_faturam - (select count('x') from #PreviaExclusao),
        vl_previa_faturamento = vl_previa_faturamento - (select sum(VlrTotal) from #PreviaExclusao),
        vl_pedido_previa_faturam = vl_pedido_previa_faturam - (select sum(VlrTotal) from #PreviaExclusao),
        cd_usuario = @cd_usuario,
        dt_usuario = getDate()
    where cd_previa_faturamento = @cd_previa_faturamento
  end

  -----------------------------------------------------------------------------
  -- EXCLUINDO O ITEM DA PRÉVIA
  -----------------------------------------------------------------------------
  if @cd_pedido_venda_item = -1 
  begin  

		--Exclui o pedido inteiro da prévia de faturamento
		delete from Previa_Faturamento_Composicao
  		where cd_previa_faturamento = @cd_previa_faturamento and
        		cd_pedido_venda = @cd_pedido_venda
		
		--Atualiza campo informando que o pedido não encontra-se mais em prévia
    update pedido_venda_item 
    set ic_fatura_item_pedido = 'N',
        ic_libpcp_item_pedido = 'N' 
    where 
		  cd_pedido_venda = @cd_pedido_venda 
  end
  else	
  begin

		--Exclui somente um item do pedido da prévia de faturamento
		delete from Previa_Faturamento_Composicao
  		where cd_previa_faturamento = @cd_previa_faturamento and
        		cd_pedido_venda = @cd_pedido_venda and	 
        		cd_item_pedido_venda = @cd_pedido_venda_item 

		--Atualiza campo informando que o pedido não encontra-se mais em prévia
    update pedido_venda_item 
    set ic_fatura_item_pedido = 'N',
        ic_libpcp_item_pedido = 'N' 
    where 
		  cd_pedido_venda = @cd_pedido_venda 
	    and cd_item_pedido_venda = @cd_pedido_venda_item
  end
  -----------------------------------------------------------------------------
  -- EXCLUINDO PRÉVIA  -- CASO NÃO TENHA MAIS NENHUM PEDIDO DE VENDA
  -----------------------------------------------------------------------------
  if ((select count('x') from previa_faturamento_composicao
       where cd_previa_faturamento = @cd_previa_faturamento) = 0)
    delete from previa_faturamento 
    where cd_previa_faturamento = @cd_previa_faturamento

  ----------------------------------------------------------------------------
  -- ATUALIZANDO O HISTÓRICO DO PEDIDO DE VENDA
  ----------------------------------------------------------------------------
  if exists(select 'x' from #PreviaExclusao)
  begin
    declare cPreviaExclusao cursor for
    select Item from #PreviaExclusao
    order by Item
  
    open cPreviaExclusao
    fetch next from cPreviaExclusao into @cd_item_pedido_venda
  
    while (@@FETCH_STATUS = 0)
    begin
  
      -- HISTÓRICO DA PRÉVIA
      set @nm_historico = 'Item: '+cast(@cd_item_pedido_venda as varchar)+' excluído da Prévia '
  
      ---------------------------------------------------------------------------
      -- HISTÓRICO DO PEDIDO DE VENDA
      ---------------------------------------------------------------------------
      if @cd_previa_faturamento <> 0 
      begin
        --Define a data para o histórico do PV (Data + Hora)
        select 
            @dt_historico_pedido_venda = DateAdd(n, 1, getdate())

        exec pr_atualiza_situacao_pedido_venda
          @cd_modulo = 0,
          @cd_processo = 3,        
          @cd_departamento = @cd_departamento,
          @cd_pedido_venda = @cd_pedido_venda,        
          @cd_item_pedido_venda = @cd_item_pedido_venda,
          @dt_pedido_venda_historico = @dt_historico_pedido_venda,
          @cd_historico_pedido = 33,
          @nm_pedido_venda_histor_1 = @nm_historico,
          @nm_pedido_venda_histor_2 = null,
          @nm_pedido_venda_histor_3 = null,
          @nm_pedido_venda_histor_4 = null,
          @cd_usuario = @cd_usuario,
          @cd_tipo = 1
      end

      fetch next from cPreviaExclusao into @cd_item_pedido_venda
  
    end
  
    close cPreviaExclusao
    deallocate cPreviaExclusao
  end          

end

