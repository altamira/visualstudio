
CREATE PROCEDURE pr_analise_conferencia_baixa
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar 
--Banco de Dados: Egissql
--Objetivo      : Lista as notas fiscais onde não foi encontrado um movimento de estoque
--                correspondente ao mesmo
--Data          : 28.04.2003
--              : 21/07/2003 - Inclusão de Rotina para apresentar Movimentos duplicados - ELIAS
--              : 30/07/2003 - Acertada para Listar todas as NFs de um período - ELIAS
--              : 13.05.2004 - Implementação da validação de venda de kit. (caixa)
--              : 06.09.2007 - Novos Flag para facilitar a checagem - Carlos Fernandes
-- 21.09.2010 - Ajustes Diveros e novos campos na procedure - Carlos Fernandes
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
-------------------------------------------------------------------------------------------------
@cd_nota_saida int = 0,
@dt_inicial    datetime,
@dt_final      datetime
as

declare @cd_fase_produto int,
        @ic_baixa_estoque_processo char(1)

--Define a fase padrão
Select 
  @cd_fase_produto = iSNull(cd_fase_produto,3)
from
  Parametro_Comercial with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

select
  @ic_baixa_estoque_processo = isnull(ic_baixa_estoque_processo,'N')
from
  Parametro_Manufatura with (nolock) 
where
  cd_empresa = dbo.fn_empresa()  


-------------------------------------------------------------------------------
-- Seleciona todas as notas emitidas e que estão marcadas que movimentaram o 
-- estoque e não movimentou corretamente
-------------------------------------------------------------------------------
select 		

  (select top 1 nm_fantasia_cliente from Cliente with (nolock) 
   where cd_cliente = ns.cd_cliente) 		as nm_fantasia_cliente,

   nsi.cd_nota_saida,
   ns.cd_identificacao_nota_saida,

--    case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
--        ns.cd_identificacao_nota_saida
--    else
--        ns.cd_nota_saida                  
--    end                                   as 'cd_nota_saida',

  convert(varchar(20), ns.dt_nota_saida, 103) 	as dt_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  nsi.qt_devolucao_item_nota,
  nsi.nm_fantasia_produto,
  nsi.nm_produto_item_nota,
  nsi.cd_produto,
  nsi.vl_unitario_item_nota,
  isnull(nsi.cd_pedido_venda,0) as cd_pedido_venda,
  me.cd_movimento_estoque,
  op.ic_estoque_op_fiscal,
  nsi.ic_movimento_estoque,
  ns.cd_operacao_fiscal,
  ns.cd_mascara_operacao,
  nsi.vl_total_item,
  ns.cd_fornecedor,
  ns.cd_cliente,
  ns.cd_tipo_destinatario,
  ns.nm_fantasia_destinatario,
  nsi.cd_grupo_produto,
  nsi.cd_item_pedido_venda,
  sn.nm_status_nota,
  ns.cd_status_nota,
  ns.dt_cancel_nota_saida,
  nsi.dt_restricao_item_nota,

  -- Verfica se o item possui composição

  	  case 
	    when ( IsNull(nsi.cd_produto,0) = 0 ) then --Especial
	      IsNull((Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda), 'N')
            --Código Adicionado para o Caixa
      when (exists(Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda)) then
       'S'
	    else --Padrão
	          ( case IsNull(@ic_baixa_estoque_processo,'N')
              when 'S' then 'N'
              else
                IsNull((Select top 1 'S' from Produto_Composicao 
                        where cd_produto_pai = nsi.cd_produto), 'N')
        	    end )
      end as ic_possui_composicao,


  IsNull(ic_estoque_grupo_prod, 'N') 		as ic_estoque_grupo_prod,
  nsi.cd_tipo_movimento_estoque,
  op.ic_estoque_reserva_op_fis
--  isnull(pc.ic_estoque_produto,'N')             as ic_estoque_produto

into
  #Reservado

from 
  (select 
    a.cd_nota_saida, 
    b.cd_identificacao_nota_saida,
--     case when isnull(b.cd_identificacao_nota_saida,0)>0 then
--        b.cd_identificacao_nota_saida
--     else
--        b.cd_nota_saida                  
--     end                                   as 'cd_nota_saida',

    a.cd_item_nota_saida,
    a.qt_item_nota_saida,
    a.qt_devolucao_item_nota,
    a.nm_fantasia_produto,
    a.nm_produto_item_nota,
    a.cd_produto,
    a.vl_unitario_item_nota,
    isnull(a.cd_pedido_venda,0) as cd_pedido_venda,
    a.ic_movimento_estoque,
    a.vl_total_item,
    a.cd_grupo_produto,
    a.cd_item_pedido_venda,
    a.dt_restricao_item_nota,
    a.cd_produto_smo,
    o.cd_tipo_movimento_estoque,
    IsNull(o.cd_fase_produto, IsNull(p.cd_fase_produto_baixa, @cd_fase_produto)) as cd_fase_produto_baixa
    
   from Nota_Saida_Item a, nota_saida b, Produto p, operacao_fiscal o
    where (((@cd_nota_saida  = 0) and (b.dt_nota_saida between @dt_inicial and @dt_final)) or
           ((@cd_nota_saida <> 0) and (b.cd_nota_saida = @cd_nota_saida)))
	  and a.cd_nota_saida=b.cd_nota_saida
	  and a.cd_produto is not null and  a.cd_produto = p.cd_produto and
    IsNull(b.cd_operacao_fiscal, a.cd_operacao_fiscal) = o.cd_operacao_fiscal) nsi 

  inner join Nota_Saida ns with (nolock)  on nsi.cd_nota_saida = ns.cd_nota_saida 
  left outer join Movimento_estoque me    on cast(ns.cd_identificacao_nota_saida as varchar(30)) = me.cd_documento_movimento and 
       nsi.cd_item_nota_saida        = me.cd_item_documento and 
       nsi.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque and
       nsi.cd_produto                = me.cd_produto and --Precisa ser o produto em questão
       nsi.cd_fase_produto_baixa     = me.cd_fase_produto --Na fase correta
  left outer join Operacao_fiscal op      on op.cd_operacao_fiscal = ns.cd_operacao_fiscal 
  left outer join Pedido_Venda pv         on pv.cd_pedido_venda    = nsi.cd_pedido_venda 
  left outer join Tipo_Pedido tp          on tp.cd_tipo_pedido     = pv.cd_tipo_pedido 
  left outer join Status_Nota sn          on sn.cd_status_nota     = ns.cd_status_nota 
  left outer join Grupo_Produto_Custo gpc on nsi.cd_grupo_produto  = gpc.cd_grupo_produto
--  left outer join Produto_Custo       pc  on pc.cd_produto         = nsi.cd_produto
  
--select * from operacao_fiscal
--select * from produto_custo

where
  --Filtro de acordo com os parametros informados
  (((@cd_nota_saida = 0) and (ns.dt_nota_saida between @dt_inicial and @dt_final))
  or ((@cd_nota_saida <> 0) and (nsi.cd_nota_saida = @cd_nota_saida))) and
  IsNull(tp.ic_sce_tipo_pedido,'S') = 'S' and
  --Considerar somente os que a Operação Fiscal Movimenta Estoque
  ( isnull(op.ic_estoque_op_fiscal,'S') = 'S' or (nsi.cd_produto_smo is not null) ) and
  --Não trazer as NFs que ainda Não Foram Impressas (Status Faturada)
  ns.cd_status_nota = 5

--select * from status_nota

--Mostra a Tabela Temporária

Select  
  distinct
  0 as selecionado,
  cast('Falta Movimento' as varchar(20)) as nm_historico, 
  nm_fantasia_cliente,
  cd_nota_saida,
  cd_identificacao_nota_saida,
  cd_item_nota_saida,
  qt_item_nota_saida,
  qt_devolucao_item_nota,
  nm_fantasia_produto,
  dt_nota_saida,
  nm_produto_item_nota,
  vl_unitario_item_nota,
  cd_pedido_venda,
  cd_produto,
  ic_estoque_op_fiscal,
  ic_movimento_estoque,
  cd_operacao_fiscal,
  cd_mascara_operacao,
  vl_total_item,
  case when IsNull(cd_fornecedor,0) > 0 then IsNull(cd_fornecedor,0) 
       when IsNull(cd_cliente,0) > 0 then IsNull(cd_cliente,0) 
  end 				as 'cd_fornecedor',
  cd_tipo_destinatario,
  nm_fantasia_destinatario,
  cd_grupo_produto,
  cd_item_pedido_venda,
  nm_status_nota,
  cd_status_nota,
  dt_cancel_nota_saida,
  dt_restricao_item_nota,
  ic_possui_composicao,             --Define que o item possui árvore
  'S' as ic_composicao_movimentada, --Define que a composição foi movimentada
  cd_tipo_movimento_estoque         --Define o tipo de movimento de estoque

into
  #MovimentoErroneo

from
  #Reservado

where
  ((cd_movimento_estoque is null) and (cd_produto > 0)) or 
  ((ic_possui_composicao = 'S')  and (cd_movimento_estoque is null) and (cd_produto = 0)) or
  ((ic_possui_composicao = 'S')  and (cd_produto > 0))


--Para todos os movimentos que possuem composição

if exists(Select top 1 'x' from #MovimentoErroneo where ic_possui_composicao = 'S')
  begin
    --Gera uma tabela temporária de todas as composições não movimentadas
    --Tratar Produtos que possuem árvore.

    select distinct 
      mverro.selecionado,
      mverro.nm_historico, 
      mverro.nm_fantasia_cliente,
      mverro.cd_nota_saida,
      mverro.cd_identificacao_nota_saida,
      mverro.cd_item_nota_saida,
      mverro.qt_item_nota_saida,
      mverro.qt_devolucao_item_nota,
      mverro.nm_fantasia_produto,
      mverro.dt_nota_saida,
      mverro.nm_produto_item_nota,
      mverro.vl_unitario_item_nota,
      mverro.cd_pedido_venda,
      mverro.cd_produto,
      mverro.ic_estoque_op_fiscal,
      mverro.ic_movimento_estoque,
      mverro.cd_operacao_fiscal,
      mverro.cd_mascara_operacao,
      mverro.vl_total_item,
      mverro.cd_fornecedor,
      mverro.cd_tipo_destinatario,
      mverro.nm_fantasia_destinatario,
      mverro.cd_grupo_produto,
      mverro.cd_item_pedido_venda,
      mverro.nm_status_nota,
      mverro.cd_status_nota,
      mverro.dt_cancel_nota_saida,
      mverro.dt_restricao_item_nota,
      mverro.ic_possui_composicao, --Define que o item possui árvore
      mverro.ic_composicao_movimentada, --Define que a composição foi movimentada
      mverro.cd_tipo_movimento_estoque, 
      mverro.cd_produto_comp,
      mverro.cd_item_produto,
      mverro.cd_fase_produto_comp

    into
      #COMP1

    From
      (Select
         distinct 
         merror.selecionado,
         merror.nm_historico, 
         merror.nm_fantasia_cliente,
         merror.cd_nota_saida,
         merror.cd_identificacao_nota_saida,
         merror.cd_item_nota_saida,
         merror.qt_item_nota_saida,
         merror.qt_devolucao_item_nota,
         merror.nm_fantasia_produto,
         merror.dt_nota_saida,
         merror.nm_produto_item_nota,
         merror.vl_unitario_item_nota,
         merror.cd_pedido_venda,
         merror.cd_produto,
         merror.ic_estoque_op_fiscal,
         merror.ic_movimento_estoque,
         merror.cd_operacao_fiscal,
         merror.cd_mascara_operacao,
         merror.vl_total_item,
         merror.cd_fornecedor,
         merror.cd_tipo_destinatario,
         merror.nm_fantasia_destinatario,
         merror.cd_grupo_produto,
         merror.cd_item_pedido_venda,
         merror.nm_status_nota,
         merror.cd_status_nota,
         merror.dt_cancel_nota_saida,
         merror.dt_restricao_item_nota,
         merror.ic_possui_composicao, --Define que o item possui árvore
         merror.ic_composicao_movimentada, --Define que a composição foi movimentada
         merror.cd_tipo_movimento_estoque, 
	       pc.cd_produto          as cd_produto_comp, 
         pc.cd_item_produto	as cd_item_produto,
         pc.cd_fase_produto 	as cd_fase_produto_comp
       from 
         #MovimentoErroneo merror 
         inner join Produto_Composicao pc on merror.cd_produto = pc.cd_produto_pai
         --Desconsidera os kit´s
         and not exists(Select 'x' from Pedido_Venda_Composicao where cd_pedido_venda = 
                    merror.cd_pedido_venda and 
                    cd_item_pedido_venda = merror.cd_item_pedido_venda)) as mverro
	     left outer join produto p on mverro.cd_produto = p.cd_produto
       left outer join Movimento_Estoque me on --isnull(p.cd_produto_baixa_estoque,p.cd_produto)=me.cd_produto and 
				mverro.cd_produto_comp = me.cd_produto and 
        mverro.cd_fase_produto_comp = me.cd_fase_produto and 
        mverro.cd_item_produto = me.cd_item_composicao and 
        cast(mverro.cd_identificacao_nota_saida as varchar(30)) = me.cd_documento_movimento and 
        mverro.cd_item_nota_saida = me.cd_item_documento and 
        mverro.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque

    where 
      mverro.cd_produto <> 0 and mverro.ic_possui_composicao = 'S'
      and me.cd_movimento_estoque is null



    --Tratar Produtos Especiais.

    Select 
      distinct 
      mverro.selecionado,
      mverro.nm_historico, 
      mverro.nm_fantasia_cliente,
      mverro.cd_nota_saida,
      mverro.cd_identificacao_nota_saida,
      mverro.cd_item_nota_saida,
      mverro.qt_item_nota_saida,
      mverro.qt_devolucao_item_nota,
      mverro.nm_fantasia_produto,
      mverro.dt_nota_saida,
      mverro.nm_produto_item_nota,
      mverro.vl_unitario_item_nota,
      mverro.cd_pedido_venda,
      mverro.cd_produto,
      mverro.ic_estoque_op_fiscal,
      mverro.ic_movimento_estoque,
      mverro.cd_operacao_fiscal,
      mverro.cd_mascara_operacao,
      mverro.vl_total_item,
      mverro.cd_fornecedor,
      mverro.cd_tipo_destinatario,
      mverro.nm_fantasia_destinatario,
      mverro.cd_grupo_produto,
      mverro.cd_item_pedido_venda,
      mverro.nm_status_nota,
      mverro.cd_status_nota,
      mverro.dt_cancel_nota_saida,
      mverro.dt_restricao_item_nota,
      mverro.ic_possui_composicao, 
      mverro.ic_composicao_movimentada,
      mverro.cd_tipo_movimento_estoque, 
      mverro.cd_produto_comp,
      mverro.cd_fase_produto_comp,
      mverro.cd_id_item_pedido_venda

    into
      #COMP2

    From (Select 
            distinct 
            merro.*, 
            IsNull((Select top 1 cd_produto_baixa_estoque from Produto p where p.cd_produto = pvc.cd_produto), pvc.cd_produto) as cd_produto_comp, 
            pvc.cd_fase_produto as cd_fase_produto_comp,
            pvc.cd_id_item_pedido_venda
          from 
            #MovimentoErroneo merro 
          left outer join Pedido_venda_composicao pvc on merro.cd_pedido_venda = pvc.cd_pedido_venda and
                                                    merro.cd_item_pedido_venda = pvc.cd_item_pedido_venda) as mverro
          left outer join Movimento_Estoque as me on cast(mverro.cd_identificacao_nota_saida as varchar(30)) = me.cd_documento_movimento and 
                                                    mverro.cd_item_nota_saida = me.cd_item_documento and 
                                                    mverro.cd_id_item_pedido_venda = me.cd_item_composicao and 
                                                    mverro.cd_produto_comp = me.cd_produto and 
                                                    mverro.cd_fase_produto_comp = me.cd_fase_produto and 
                                                    mverro.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
    where 
--       mverro.cd_produto = 0 and  --Foi comentado para funcionar para o Caixa também
      mverro.ic_possui_composicao = 'S' and 
      me.cd_movimento_estoque is null


    delete from #MovimentoErroneo where ic_possui_composicao = 'S'

    --Inserir as composições de produto que movimentaram pela Pedido_Venda_Composição (Especial / Kit)
    insert into #MovimentoErroneo
      select  
        selecionado,
        nm_historico,  
        nm_fantasia_cliente,
        cd_nota_saida,
        cd_identificacao_nota_saida,
        cd_item_nota_saida,
        qt_item_nota_saida,
        qt_devolucao_item_nota,
        nm_fantasia_produto,
        dt_nota_saida,
        nm_produto_item_nota,
        vl_unitario_item_nota,
        cd_pedido_venda,
        cd_produto,
        ic_estoque_op_fiscal,
        ic_movimento_estoque,
        cd_operacao_fiscal,
        cd_mascara_operacao,
        vl_total_item,
        cd_fornecedor,
        cd_tipo_destinatario,
        nm_fantasia_destinatario,
        cd_grupo_produto,
        cd_item_pedido_venda,
        nm_status_nota,
        cd_status_nota,
        dt_cancel_nota_saida,
        dt_restricao_item_nota,
        ic_possui_composicao,
        'N' as ic_composicao_movimentada,
        cd_tipo_movimento_estoque

      from 
        #COMP2

    --Inserir as composições de produto que movimenta árvore
    Insert into #MovimentoErroneo
      Select  
        selecionado, 
        nm_historico,
        nm_fantasia_cliente,
        cd_nota_saida,
        cd_identificacao_nota_saida,
        cd_item_nota_saida,
        qt_item_nota_saida,
        qt_devolucao_item_nota,
        nm_fantasia_produto,
        dt_nota_saida,
        nm_produto_item_nota,
        vl_unitario_item_nota,
        cd_pedido_venda,
        cd_produto,
        ic_estoque_op_fiscal,
        ic_movimento_estoque,
        cd_operacao_fiscal,
        cd_mascara_operacao,
        vl_total_item,
        cd_fornecedor,
        cd_tipo_destinatario,
        nm_fantasia_destinatario,
        cd_grupo_produto,
        cd_item_pedido_venda,
        nm_status_nota,
        cd_status_nota,
        dt_cancel_nota_saida,
        dt_restricao_item_nota,
        ic_possui_composicao,
        'N' as ic_composicao_movimentada,
        cd_tipo_movimento_estoque

      from 
        #COMP1

  end

  -----------------------------------------------------------------------------
  -- Verifica a existência de Registros Duplicados / Produtos Padrão
  -----------------------------------------------------------------------------
  declare @cd_nota_saida_cursor int
  declare @cd_item_nota_saida int

  declare cCursor cursor for
  select ni.cd_nota_saida, ni.cd_item_nota_saida
  from nota_saida n with (nolock)  
    inner join nota_saida_item ni   on n.cd_nota_saida      = ni.cd_nota_saida 
    inner join operacao_fiscal o    on o.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join pedido_venda pv on ni.cd_pedido_venda   = pv.cd_pedido_venda 
    left outer join tipo_pedido tp  on pv.cd_tipo_pedido    = tp.cd_tipo_pedido
  where               
    IsNull(tp.ic_sce_tipo_pedido,'S') = 'S' and
    isnull(o.ic_estoque_op_fiscal,'S') = 'S' and
    n.cd_status_nota = 5 and
    ni.cd_nota_saida = n.cd_nota_saida and
    (((@cd_nota_saida = 0) and (n.dt_nota_saida between @dt_inicial and @dt_final)) or 
    ((@cd_nota_saida <> 0) and (ni.cd_nota_saida = @cd_nota_saida)))

  open cCursor

  fetch next from cCursor into @cd_nota_saida_cursor, @cd_item_nota_saida
  while @@Fetch_Status = 0
  begin

    -- VERIFICANDO OS PRODUTOS PADRÃO

    print('Verificando Duplicidade NF '+cast(@cd_nota_saida_cursor as varchar(6))+' Item '+cast(@cd_item_nota_saida as varchar(6)))

    if exists(select   
	         nsi.cd_pedido_venda,
                me.nm_destinatario,
                me.dt_movimento_estoque,
                me.cd_documento_movimento,
                me.cd_produto,
                nsi.cd_item_pedido_venda,
                nsi.cd_produto
      	      from
      	        Movimento_Estoque me,
      	        Nota_Saida_Item nsi,
                Nota_Saida ns,
                Operacao_Fiscal op
      	      where 
      	        nsi.cd_nota_saida         = @cd_nota_saida_cursor and
                nsi.cd_item_nota_saida    = @cd_item_nota_saida and
      	        me.cd_documento_movimento = cast(ns.cd_identificacao_nota_saida as varchar(30)) and
                me.cd_item_documento = nsi.cd_item_nota_saida and
                -- Acrescentado Filtro de Operação Fiscal 
                op.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
                isnull(op.ic_estoque_op_fiscal,'S') = 'S' and
      	        me.cd_tipo_documento_estoque = 4 and
      	        me.cd_tipo_movimento_estoque = 11 and
            	  (case 
            	    when ( IsNull(nsi.cd_produto,0) = 0 ) then --Especial
            	      IsNull((Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda), 'N')
                        --Código Adicionado para o Caixa
                  when (exists(Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda)) then
                   'S'
            	    else --Padrão
            	          ( case IsNull(@ic_baixa_estoque_processo,'N')
                          when 'S' then 'N'
                          else
                            IsNull((Select top 1 'S' from Produto_Composicao 
                                    where cd_produto_pai = nsi.cd_produto), 'N')
                    	    end ) 
            	  end ) = 'N'
            group by
              nsi.cd_pedido_venda,
         	  me.nm_destinatario,
              me.dt_movimento_estoque,
              me.cd_documento_movimento,
              me.cd_produto,
              nsi.cd_item_pedido_venda,
              nsi.cd_produto                    
            having 
              count('x') > 1)
    begin

        insert into
          #MovimentoErroneo                         
        select
          0 as selecionado,
          cast('Movimento Duplicado' as varchar(20)) as nm_historico,
      	  (Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = ns.cd_cliente) as nm_fantasia_cliente,
      	  nsi.cd_nota_saida,
          ns.cd_identificacao_nota_saida,

--           case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
--              ns.cd_identificacao_nota_saida
--           else
--              ns.cd_nota_saida                  
--           end                                   as 'cd_nota_saida',

          @cd_item_nota_saida,
      	  nsi.qt_item_nota_saida,
          nsi.qt_devolucao_item_nota,
          nsi.nm_fantasia_produto,
          convert(varchar(20), ns.dt_nota_saida, 103) as dt_nota_saida,
      	  nsi.nm_produto_item_nota,
      	  nsi.vl_unitario_item_nota,
      	  nsi.cd_pedido_venda,
      	  nsi.cd_produto,
          op.ic_estoque_op_fiscal,
       	  nsi.ic_movimento_estoque,
      	  nsi.cd_operacao_fiscal,
          ns.cd_mascara_operacao,
      	  nsi.vl_total_item,
       	  case when IsNull(ns.cd_fornecedor,0) > 0 then IsNull(ns.cd_fornecedor,0) 
  	       when IsNull(ns.cd_cliente,0) > 0 then IsNull(ns.cd_cliente,0)
      	  end as 'cd_fornecedor',
      	  ns.cd_tipo_destinatario,
      	  ns.nm_fantasia_destinatario,
      	  nsi.cd_grupo_produto,
      	  nsi.cd_item_pedido_venda,
          sn.nm_status_nota,
          ns.cd_status_nota,
          ns.dt_cancel_nota_saida,
          nsi.dt_restricao_item_nota,
      	  case 
      	    when ( IsNull(nsi.cd_produto,0) = 0 ) then --Especial
      	      IsNull((Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda), 'N')
                  --Código Adicionado para o Caixa
            when (exists(Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda)) then
             'S'
      	    else --Padrão
      	          ( case IsNull(@ic_baixa_estoque_processo,'N')
                    when 'S' then 'N'
                    else
                      IsNull((Select top 1 'S' from Produto_Composicao 
                              where cd_produto_pai = nsi.cd_produto), 'N')
              	    end ) 
      	  end as ic_possui_composicao,
          'S' as ic_composicao_movimentada,
          me.cd_tipo_movimento_estoque
        from
          Movimento_Estoque me,
          Nota_Saida_Item nsi,
          Nota_Saida ns,
          Operacao_Fiscal op,
          Status_Nota sn
	where   
	  me.cd_tipo_documento_estoque = 4 and
	  me.cd_tipo_movimento_estoque = 11 and
	  me.cd_documento_movimento = cast(ns.cd_identificacao_nota_saida as varchar(30)) and

    me.cd_item_documento = nsi.cd_item_nota_saida and
    nsi.cd_operacao_fiscal = op.cd_operacao_fiscal and
    me.cd_produto = nsi.cd_produto and           
    ns.cd_status_nota = sn.cd_status_nota and
    ns.cd_nota_saida = nsi.cd_nota_saida and
    nsi.cd_nota_saida = @cd_nota_saida_cursor and
    nsi.cd_item_nota_saida = @cd_item_nota_saida

  end       

  
  if (Select count('x') from movimento_estoque me inner join nota_saida_item nsi on me.cd_item_documento = cast(nsi.cd_item_nota_saida as varchar(6)) and
      me.cd_documento_movimento = cast(nsi.cd_nota_saida as varchar(6)) left outer join pedido_venda_composicao pvc on 
      pvc.cd_id_item_pedido_venda = me.cd_item_composicao and pvc.cd_pedido_venda = nsi.cd_pedido_venda and 
      pvc.cd_item_pedido_venda = nsi.cd_item_pedido_venda and me.cd_produto = pvc.cd_produto
      inner join Produto p on nsi.cd_produto = p.cd_produto
      where me.cd_tipo_movimento_estoque = 11 and me.cd_tipo_documento_estoque = 4 and 
      nsi.cd_nota_saida = @cd_nota_saida_cursor and nsi.cd_item_nota_saida = @cd_item_nota_saida and me.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_produto) )  > 
     (select count('x') from pedido_venda_composicao pvc, nota_saida_item nsi 
      where pvc.cd_pedido_venda = nsi.cd_pedido_venda and pvc.cd_item_pedido_venda = nsi.cd_item_pedido_venda and 
      nsi.cd_nota_saida = @cd_nota_saida_cursor and nsi.cd_item_nota_saida = @cd_item_nota_saida and
      pvc.cd_fase_produto = @cd_fase_produto)
  begin

    insert into
      #MovimentoErroneo                         
    select
      distinct
      0 as selecionado,
      cast('Comp. PV Duplicado' as varchar(20)) as nm_historico,
  	  (Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = ns.cd_cliente) as nm_fantasia_cliente,
  	  nsi.cd_nota_saida,

      ns.cd_identificacao_nota_saida,

--       case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
--          ns.cd_identificacao_nota_saida
--       else
--          ns.cd_nota_saida                  
--       end                                   as 'cd_nota_saida',

      @cd_item_nota_saida,
      nsi.qt_item_nota_saida,
      nsi.qt_devolucao_item_nota,
      nsi.nm_fantasia_produto,
  	  convert(varchar(20), ns.dt_nota_saida, 103) as dt_nota_saida,
  	  nsi.nm_produto_item_nota,
  	  nsi.vl_unitario_item_nota,
  	  nsi.cd_pedido_venda,
  	  nsi.cd_produto,
      op.ic_estoque_op_fiscal,
   	  nsi.ic_movimento_estoque,
  	  nsi.cd_operacao_fiscal,
          ns.cd_mascara_operacao,
  	  nsi.vl_total_item,
   	  case when IsNull(ns.cd_fornecedor,0) > 0 then IsNull(ns.cd_fornecedor,0) 
	       when IsNull(ns.cd_cliente,0) > 0 then IsNull(ns.cd_cliente,0)
  	  end as 'cd_fornecedor',
  	  ns.cd_tipo_destinatario,
  	  ns.nm_fantasia_destinatario,
  	  nsi.cd_grupo_produto,
  	  nsi.cd_item_pedido_venda,
      sn.nm_status_nota,
      ns.cd_status_nota,
      ns.dt_cancel_nota_saida,
      nsi.dt_restricao_item_nota,
  	  case 
  	    when ( IsNull(nsi.cd_produto,0) = 0 ) then --Especial
  	      IsNull((Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda), 'N')
              --Código Adicionado para o Caixa
        when (exists(Select top 1 'S' from Pedido_Venda_Composicao where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda)) then
         'S'
  	    else --Padrão
  	          ( case IsNull(@ic_baixa_estoque_processo,'N')
                when 'S' then 'N'
                else
                  IsNull((Select top 1 'S' from Produto_Composicao 
                          where cd_produto_pai = nsi.cd_produto), 'N')
          	    end ) 
  	  end as ic_possui_composicao,
      'S' as ic_composicao_movimentada,
      me.cd_tipo_movimento_estoque
   from
      Movimento_Estoque me,
      Nota_Saida_Item nsi,
      Nota_Saida ns,
      Pedido_Venda_Composicao pvc,
      Operacao_Fiscal op,
      Status_Nota sn,
      Produto p
	 where   
      nsi.cd_nota_saida = @cd_nota_saida_cursor and
      nsi.cd_item_nota_saida = @cd_item_nota_saida and
      p.cd_produto = nsi.cd_produto and
      me.cd_documento_movimento = cast(nsi.cd_nota_saida as varchar(30)) and
      me.cd_item_documento = nsi.cd_item_nota_saida and
      me.cd_tipo_documento_estoque = 4 and
      me.cd_tipo_movimento_estoque = 11 and
      me.cd_produto = pvc.cd_produto and                     
      me.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_produto) and
      nsi.cd_operacao_fiscal = op.cd_operacao_fiscal and
      ns.cd_status_nota = sn.cd_status_nota and
      ns.cd_nota_saida = nsi.cd_nota_saida and
      pvc.cd_pedido_venda = nsi.cd_pedido_venda and
      pvc.cd_item_pedido_venda = nsi.cd_item_pedido_venda

  end

    fetch next from cCursor into @cd_nota_saida_cursor, @cd_item_nota_saida

  end

  close cCursor
  deallocate cCursor 

  Select 
    distinct 
       mer.*, 
       pb.nm_fantasia_produto as nm_fantasia_produto_baixa,
       isnull(pc.ic_estoque_produto,'N')             as ic_estoque_produto

  from 
    -- Anderson 25/01/2007
    -- pegando o produto baixa do cadastro do produto,
    -- fiz assim para nnão ter que modificar toda a procedure
    #MovimentoErroneo mer
    left outer join Produto p        on p.cd_produto  = mer.cd_produto
    left outer join Produto pb       on pb.cd_produto = p.cd_produto_baixa_estoque
    left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
  order by 
    dt_nota_saida,
    cd_nota_saida

