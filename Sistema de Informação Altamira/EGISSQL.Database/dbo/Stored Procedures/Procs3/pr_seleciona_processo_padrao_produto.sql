
create procedure pr_seleciona_processo_padrao_produto  
@ic_parametro  int,
@cd_produto    int,
@qt_necessaria float
as

Declare
  @vl_custo              float,
  @vl_custo_ok           float, --indica o valor do processo padrão ideal
  @cd_processo_padrao    int,
  @cd_processo_padrao_ok int, --indica o processo padrão ideal
  @cod_produto           int,
  @nm_restricao          varchar(40),
  @restricao             integer --p/ indicar se tem alguma restrição com os componentes 0 = não tem e >1 = tem.

set @vl_custo_ok = 99999999 --Apenas para pegar o mais ideal

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Lista todos os Produtos e Restrições
-------------------------------------------------------------------------------
begin

	select
	  isnull(ppp.cd_produto,0) cd_produto,
	  p.nm_fantasia_produto,
	  pp.cd_processo_padrao,
	  pp.nm_processo_padrao,
    pp.nm_identificacao_processo,
	  pp.dt_processo_padrao,
	  pp.vl_custo_componente,
	  Sum(isnull(@qt_necessaria, 1) * isnull(ppp.qt_produto_processo, 1)) as 'qt_necessaria',
	  ps.qt_saldo_reserva_produto as 'qt_disponivel',
    cast(null as int) as 'cd_pedido_compra',
    cast(null as DateTime) as 'dt_pedido_compra',
    cast(null as Float) as 'qt_pedido_compra',
    cast(null as char(1)) as 'ic_processo_ideal',
	  cast((case 
         when (sum(isnull(@qt_necessaria, 1) * isnull(ppp.qt_produto_processo, 1)) > ps.qt_saldo_reserva_produto) then 'Estoque Insuficiente'
         --when (@qt_necessaria > ps.qt_saldo_reserva_produto) then 'Estoq. Insuficiente'
	       when ps.qt_saldo_reserva_produto = 0 then 'Sem Estoque'
	       when ppp.cd_produto is null then 'Sem Componente'
	       else 'Sem Restrição' end) as varchar(40)) as 'nm_restricao',
        max(fp.nm_fase_produto) as nm_fase_produto
  Into
    #Tabela
	From
	  Produto_Producao prp WITH(NOLOCK)
	    Inner Join
	  Processo_Padrao pp WITH(NOLOCK)
	    on prp.cd_processo_padrao = pp.cd_processo_padrao
	    left outer join
	  Processo_Padrao_Produto ppp WITH(NOLOCK)
	    on pp.cd_processo_padrao = ppp.cd_processo_padrao
	    left outer join
	  Produto p WITH(NOLOCK)
	    on ppp.cd_produto = p.cd_produto
	    Left outer Join
	  Produto_saldo ps
	    on ppp.cd_produto = ps.cd_produto and
	       ppp.cd_fase_produto = ps.cd_fase_produto
          left outer join fase_produto fp on fp.cd_fase_produto = ppp.cd_fase_produto
	where
	  prp.cd_produto = @cd_produto
	group by 
	  ppp.cd_produto,
	  p.nm_fantasia_produto,
	  pp.cd_processo_padrao,
	  pp.nm_processo_padrao,
	  pp.nm_identificacao_processo,
    pp.dt_processo_padrao,
	  pp.vl_custo_componente,
--    pp.qt_processo_padrao,
--	  ppp.qt_produto_processo,
	  ps.qt_saldo_reserva_produto
	order by pp.cd_processo_padrao, p.nm_fantasia_produto

  Select * into #TabelaOK from #Tabela

  truncate table #TabelaOK

  declare cProcessoPadrao cursor for
    Select distinct
      cd_processo_padrao
    from
      #Tabela

  open cProcessoPadrao
  fetch next from cProcessoPadrao into @cd_processo_padrao
  while (@@FETCH_STATUS =0)
  begin
    
    Set @restricao = 0

	  declare cProduto cursor for
	    Select distinct
	      isnull(cd_produto,0) cd_produto
	    from
	      #Tabela
	    where
	      cd_processo_padrao = @cd_processo_padrao

	  open cProduto
	  fetch next from cProduto into @cod_produto
	  while (@@FETCH_STATUS =0)
	  begin

      select @nm_restricao = nm_restricao from #Tabela
      where cd_processo_padrao = @cd_processo_padrao and
            isnull(cd_produto,0) = @cod_produto

--	    if @nm_restricao <> 'Sem Restrição'
--      begin
        set @restricao = @restricao + 1
		    Insert Into #TabelaOK
         (cd_produto, nm_fantasia_produto, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao,
				  vl_custo_componente, qt_necessaria, qt_disponivel, nm_restricao, nm_fase_produto)
		    select distinct
				  cd_produto, nm_fantasia_produto, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao,
				  vl_custo_componente, qt_necessaria, qt_disponivel, nm_restricao, nm_fase_produto
				from #Tabela where cd_processo_padrao = @cd_processo_padrao and cd_produto = @cod_produto
--      end
	
	    fetch next from cProduto into @cod_produto
	  end
	  close cProduto
    deallocate cProduto

    select @vl_custo = vl_custo_componente from #tabela where cd_processo_padrao = @cd_processo_padrao

    if @restricao = 0
    Insert Into #TabelaOK
     (cd_produto, nm_fantasia_produto, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao,
		  vl_custo_componente, qt_necessaria, qt_disponivel, nm_restricao, nm_fase_produto)
    select distinct
		  0 cd_produto, '' nm_fantasia_produto, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao,
		  vl_custo_componente, 0 qt_necessaria, 0 qt_disponivel, nm_restricao, nm_fase_produto
		from #Tabela where cd_processo_padrao = @cd_processo_padrao

    --Indica que este processo padrão é o indicado
    if (@restricao = 0) --and (@vl_custo < @vl_custo_ok)
      set @cd_processo_padrao_ok = @cd_processo_padrao

    fetch next from cProcessoPadrao into @cd_processo_padrao
  end
  close cProcessoPadrao
  deallocate cProcessoPadrao


  --Inclui os dados do PC
  select 
    0 as sel, t.cd_produto, t.nm_fantasia_produto, t.cd_processo_padrao, t.nm_processo_padrao, t.nm_identificacao_processo, t.dt_processo_padrao,
	  t.vl_custo_componente, t.qt_necessaria, t.qt_disponivel, t.nm_restricao, t.ic_processo_ideal,
    pc.cd_pedido_compra, pc.dt_nec_pedido_compra, pc.qt_item_pedido_compra, t.nm_fase_produto
  into
    #TabelaPC
  from 
    #TabelaOK t
      left outer join
    (select top 1 pc.cd_pedido_compra, pc.dt_nec_pedido_compra, pci.qt_item_pedido_compra, pci.cd_produto
     from pedido_compra pc inner join pedido_compra_item pci
          on pc.cd_pedido_compra = pci.cd_pedido_compra
--     where cd_produto = t.cd_produto 
       and pc.cd_status_pedido <> 14 and pc.cd_status_pedido = 8
		order by pc.dt_nec_pedido_compra desc) pc
      on t.cd_produto = pc.cd_produto 

  --Seta o Processo padrão ideal
  Update #TabelaPC
  set ic_processo_ideal = 'S',
        sel = 1
  where cd_processo_padrao = @cd_processo_padrao_ok

  select * from #TabelaPC

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Lista somente os Processos
-------------------------------------------------------------------------------
begin

	select
    0 as sel,
	  isnull(ppp.cd_produto,0) cd_produto,
	  pp.cd_processo_padrao,
	  pp.nm_processo_padrao,
    pp.nm_identificacao_processo,
	  pp.dt_processo_padrao,
	  pp.vl_custo_componente,
    cast(null as char(1)) as 'ic_processo_ideal',
	  cast((case 
         when (sum(isnull(@qt_necessaria, 1) * isnull(ppp.qt_produto_processo, 1)) > ps.qt_saldo_reserva_produto) then 'Estoque Insuficiente'     
         --when (@qt_necessaria > ps.qt_saldo_reserva_produto) then 'Estoq. Insuficiente'
	       when ps.qt_saldo_reserva_produto = 0 then 'Sem Estoque'
	       when ppp.cd_produto is null then 'Sem Componente'
	       else 'Sem Restrição' end) as varchar(40)) as 'nm_restricao',
        max(fp.nm_fase_produto) as nm_fase_produto

  Into
    #Tabela_Proc
	From
	  Produto_Producao prp WITH(NOLOCK)
	    Inner Join
	  Processo_Padrao pp WITH(NOLOCK)
	    on prp.cd_processo_padrao = pp.cd_processo_padrao
	    left outer join
	  Processo_Padrao_Produto ppp WITH(NOLOCK)
	    on pp.cd_processo_padrao = ppp.cd_processo_padrao
	    left outer join
	  Produto p WITH(NOLOCK)
	    on ppp.cd_produto = p.cd_produto
	    Left outer Join
	  Produto_saldo ps
	    on ppp.cd_produto = ps.cd_produto and
	       ppp.cd_fase_produto = ps.cd_fase_produto
          left outer join fase_produto fp on fp.cd_fase_produto = ppp.cd_fase_produto
	where
	  prp.cd_produto = @cd_produto
	group by 
    ppp.cd_produto,
	  pp.cd_processo_padrao,
	  pp.nm_processo_padrao,
	  pp.nm_identificacao_processo,
    pp.dt_processo_padrao,
	  pp.vl_custo_componente,
    ps.qt_saldo_reserva_produto
	order by pp.cd_processo_padrao

  Select * into #TabelaOK_Proc from #Tabela_Proc

  declare cProcessoPadrao_Proc cursor for
    Select distinct
      cd_processo_padrao
    from
      #Tabela_Proc

  open cProcessoPadrao_Proc
  fetch next from cProcessoPadrao_Proc into @cd_processo_padrao
  while (@@FETCH_STATUS =0)
  begin
    
    Set @restricao = 0

	  declare cProduto_Proc cursor for
	    Select distinct
	      isnull(cd_produto,0) cd_produto
	    from
	      #Tabela_Proc
	    where
	      cd_processo_padrao = @cd_processo_padrao

	  open cProduto_Proc
	  fetch next from cProduto_Proc into @cod_produto
	  while (@@FETCH_STATUS =0)
	  begin

      select @nm_restricao = nm_restricao from #Tabela_Proc
      where cd_processo_padrao = @cd_processo_padrao and
            isnull(cd_produto,0) = @cod_produto

	    if @nm_restricao <> 'Sem Restrição'
        set @restricao = @restricao + 1
	
	    fetch next from cProduto_Proc into @cod_produto
	  end
	  close cProduto_Proc
    deallocate cProduto_Proc

    --Indica que este processo padrão é o indicado
    if (@restricao = 0) --and (@vl_custo < @vl_custo_ok)
      set @cd_processo_padrao_ok = @cd_processo_padrao

    fetch next from cProcessoPadrao_Proc into @cd_processo_padrao
  end
  close cProcessoPadrao_Proc
  deallocate cProcessoPadrao_Proc

  --Seta o Processo padrão ideal
  Update #TabelaOK_Proc
  set ic_processo_ideal = 'S',
      sel = 1
  where cd_processo_padrao = @cd_processo_padrao_ok

  select sel, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao
  from #TabelaOK_Proc group by sel, cd_processo_padrao, nm_processo_padrao, nm_identificacao_processo, dt_processo_padrao
  order by 2

end

--select * from processo_padrao_produto


