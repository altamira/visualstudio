
--------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE pr_consulta_programacao_faturamento
--------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Johnny Mendes de Souza
--                      : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar Programação de Faturamento através dos pedidos
--Data			: 05/06/2002
--Alteração		: 07/07/2002 -- Seleção de Pedidos
--			: 25/07/2003 -- Montagem deste cabeçalho que havia se perdido - ELIAS
--                      : 25/07/2003 -- Incluída opção de 3 tipos de Filtro ( por Data de Prévia, 
--                                      Por Entrega de PCP e Entrega Comercial ) - ELIAS
-- 28/05/2004 - Incluído campos de qt_peso_liquido, qt_peso_bruto e cd_produto - Daniel C. Neto.
-- 18.06.2004 - Alteração do parametro 3 para verificar o saldo e não as quantidades. Carlos/Igor
-- 01/03/2005 - Incluído fase de produto - Daniel C. Neto.
-- 07.06.2005 - Checagem do Parâmetro Comercial para Identificar se a Empresa Opera com Prévia-Faturamento
-- 14.07.2005 - A Restrição de Estoque apenas para Produto Padrão - Carlos Fernandes.             
-- 03.09.3005 - Verificação do flag do Produto/Grupo de Produto que identifica que o Estoque será gerado
--              na Emissão da Nota Fiscal, portanto, o Produto não possuirá restrição de estoque
--              Carlos Fernandes
-- 27.04.2006 - Tipo de Entrega do Produto para faturamento - Paulo Souza
-- 12.06.2006 - Novo flag para controle da restricação da condição de pagamento - Carlos Fernandes
-- 24/07/2006 - Estava tratando a variavel errada de fase ao buscar o saldo do produto - Paulo Souza
-- 14.08.2006 - Oficial GBS - Carlos Fernandes
-- 13/09/2006 - Mostrar o estoque disponivel do item - Paulo Souza
-- 12.12.2006 - Ajustes - Carlos Fernandes
-- 02.04.2007 - Coluna de Total de Saldo de Item de Pedido em Aberto - Carlos Fernandes
-- 06.07.2007 - Acertado o Flag de Estoque estoque - Carlos Fernandes
-- 04.01.2008 - Mostrar a última OP do Pedido de Venda / Status - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------
  @ic_parametro       int      = 0,
  @dt_inicial         datetime = '',
  @dt_final           datetime = '',
  @cd_empresa         int      = 1,     -- Utiliza para definir se a empresa realiza ou não o controle de desconto
  @cd_pedido_venda    int      = 0,     -- Define um pedido de venda específico para ser apresentado
  @ic_filtro_prog_fat char(1)  = '1'  -- 1 Entrega Comercial/2 Entrega PCP/3 Data Prévia / 4-Data de Emissão

AS

  declare
    @ic_controla_desconto    char(1), --Variavel para checar se a empresa trabalha com controle de desconto
    @qt_dia_imediato_empresa int,
    @cd_fase_venda_produto   int,
    @sSQL                    varchar(8000),
    @sSQL_Complemento        varchar(8000),
    @sSQL_Where              varchar(8000),
    @sSQL_OrderBy            varchar(8000),
    @ic_previa_faturamento   char(1),
    @sSQLTemp                varchar(8000),
    @sSqlCompl1              varchar(8000)

  --Buscando informação para verificar se empresa trabalha com controle de desconto

  select
    @ic_controla_desconto = isnull(ic_controla_desconto,'N')
  from
    EgisAdmin.dbo.Parametro_Empresa
  where
    cd_empresa = @cd_empresa

  if @ic_parametro = 3
  begin
      --Buscando data de pedido mais antigo
      select
         @dt_inicial = min(dt_item_pedido_venda) 
      from
         Pedido_Venda_Item
      where
        qt_saldo_pedido_venda > 0 and dt_cancelamento_item is null
   end

  --Checagem do Parâmetro comercial

  select 
    --Buscando quantidade de dias imediato que a empresa definiu
    @qt_dia_imediato_empresa = qt_dia_imediato_empresa,
    --Buscando fase de venda do produto definido no parametro comercial
    @cd_fase_venda_produto   = cd_fase_produto,
    --Prévia de Faturamento
    @ic_previa_faturamento = isnull(ic_previa_faturamento,'N')
  from 
    Parametro_Comercial 
  where 
    cd_empresa = @cd_empresa

-----------------------------------------------------------------------------------------------------
--Verifica todas as Notas Fiscais Geradas mas não Emitidas
--Portanto não movimentou o estoque
-----------------------------------------------------------------------------------------------------

set @sSQLTemp = 'select nsi.cd_fase_produto, nsi.cd_produto,
    	             IsNull(Sum(nsi.qt_item_nota_saida),0) as qt_item_nota_saida
                 Into #Notas
                 from nota_saida_item nsi with (nolock)
            	        inner join nota_saida ns with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
	                    left outer join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
                            left outer join grupo_operacao_fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                 where IsNull(ns.ic_emitida_nota_saida,''N'') = ''N'' and
	                    ns.dt_cancel_nota_saida is null and
	                    IsNull(nsi.ic_movimento_estoque,''N'') = ''N'' and
	                    IsNull(opf.ic_estoque_op_fiscal,''N'') = ''S'' and
                            gof.cd_tipo_operacao_fiscal = 2
                 group by nsi.cd_produto, nsi.cd_fase_produto '

  if ( @ic_parametro <> 2 )
    set @cd_pedido_venda = 0

/**/
/*            'case when pv.dt_credito_pedido_venda is null then 1 
                  else case 
                       when (select isnull(ic_credito_suspenso,''N'') from Cliente_Informacao_Credito where cd_cliente = pv.cd_cliente) = ''S'' then 1
                       else 0 end
             end as ic_credito, '+*/

set @sSQL = 'SELECT cast(pvi.cd_pedido_venda as varchar) + ''Ident'' + cast(pvi.cd_item_pedido_venda as varchar) as cd_identificante, '+
            --Crédito
            'case when pv.dt_credito_pedido_venda is null then 1 
                  else 0
             end as ic_credito, '+
            'case when (select isnull(ic_credito_suspenso,''N'') from Cliente_Informacao_Credito with (nolock) where cd_cliente = pv.cd_cliente) = ''S'' then 1
                  else 0 
             end as ic_credito_suspenso, '+
             --Desconto    
              'case 
                when ''' + IsNull(@ic_controla_desconto,'S') + ''' = ''S'' and pvi.ic_desconto_item_pedido = ''S'' and pvi.dt_desconto_item_pedido is null then 1 else 0 
              end as ic_desconto, '+

             --Restrição de Estoque = Saldo Disponível qt_saldo_reserva_produto       

              'case when (isnull(pv.cd_tipo_entrega_produto,1) = 1) and (IsNull(pvi.ic_pedido_venda_item,''P'') = ''P'') and isnull(pvi.cd_produto,0)>0 then
               (case 
                  when isnull(pvi.qt_saldo_pedido_venda,0) > 
                       (case when isnull(p.cd_produto_baixa_estoque,0)=0 then
                             isnull((select isnull(qt_saldo_atual_produto,0) 
                                     from Produto_Saldo with (nolock)
                                     where cd_produto = p.cd_produto and cd_fase_produto = dbo.fn_fase_produto(p.cd_produto, '+ cast(IsNull(@cd_fase_venda_produto,0) as varchar)+'  )),0) - IsNull(n.qt_item_nota_saida,0)
                        else
                             isnull((select isnull(qt_saldo_atual_produto,0) 
                                     from Produto_Saldo with (nolock)
                                     where cd_produto = p.cd_produto_baixa_estoque and cd_fase_produto = dbo.fn_fase_produto(p.cd_produto, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0) - IsNull(n.qt_item_nota_saida ,0)
                        end)
                then 
                  1 
                else 
                  0
                end)
              else
                (case when
                       ((
                       case 
                        when (isnull(p.cd_produto_baixa_estoque,0)=0) then
                           isnull((select isnull(qt_saldo_atual_produto,0) 
                                   from Produto_Saldo with (nolock)
                                   where cd_produto = p.cd_produto and 
        			         cd_fase_produto = dbo.fn_fase_produto(p.cd_produto, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0) - IsNull(n.qt_item_nota_saida ,0)
        		else 
                	    isnull((select isnull(qt_saldo_atual_produto,0) 
                                    from Produto_Saldo with (nolock)
                 	            where cd_produto = p.cd_produto_baixa_estoque and 
                                    cd_fase_produto  = dbo.fn_fase_produto(p.cd_produto, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0) - IsNull(n.qt_item_nota_saida,0)
                        end) <= 0) and (IsNull(pvi.ic_pedido_venda_item,''P'') = ''P'') and isnull(pvi.cd_produto,0)>0 then
                  1
                else
                  0
                end)
              end as ic_saldo_real, '+

              --Restrição do Pedido de Venda       	

              'case 
                when (IsNull(pv.cd_tipo_restricao_pedido,0) > 0) then 1 else 0
              end as ic_restricao, '       

--Checa se o Cliente opera com Prévia de Faturamento

if @ic_previa_faturamento='S' 
begin
   set @sSQL = @sSql + 'case ' +
                        ' when exists(select top 1 ''X'' from Previa_Faturamento_Composicao with (nolock)
                             where cd_pedido_venda = pv.cd_pedido_venda and 
                                  cd_item_pedido_venda = pvi.cd_item_pedido_venda and 
                                  ic_fatura_previa_faturam = ''N'') then 1 else 0
                        end as ic_producao,'
end
else
begin
   set @sSQL = @sSql + 'case when exists(select top 1 ''X'' from Processo_Producao with (nolock)
                             where cd_pedido_venda = pv.cd_pedido_venda and 
                                  cd_item_pedido_venda = pvi.cd_item_pedido_venda and 
                                  dt_canc_processo is null) then 1 else 0 end as ic_producao,'
end
  
   set @sSQL = @sSql 
           + 'case 
                when exists(select top 1 0 from Pedido_Importacao_Item pii with (nolock) where pvi.cd_pedido_venda = pii.cd_pedido_venda AND pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda) then 1 else 0
              end as ic_importacao,       
              case 
                when exists(select top 1 ''X'' from Pedido_Compra_Item with (nolock) where cd_pedido_venda = pv.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda and qt_saldo_item_ped_compra > 0) then 1 else 0
              end as ic_compra,       
              case 
                when pvi.dt_entrega_vendas_pedido <= getdate() then 1 else 0
              end as ic_atraso,        
              case
                when exists(select top 1 ''X'' from Cliente with (nolock) where cd_cliente = pv.cd_cliente and ic_liberado_pesq_credito = ''S'') then 0 else 1
              end as ic_consulta_credito,        
              case
                when (pvi.dt_item_pedido_venda = pvi.dt_entrega_vendas_pedido) or (pvi.dt_entrega_vendas_pedido - pvi.dt_item_pedido_venda) <= ' + cast(IsNull(@qt_dia_imediato_empresa,0) as varchar)+' then 1 else 0
              end as ic_imediato,        
              case
                when isnull(pv.ic_fatsmo_pedido, ''N'') = ''S'' then 1 else 0
              end as ic_smo_item_pedido_venda,
              case
                when isnull(pv.ic_operacao_triangular, ''N'') = ''S'' then 1 else 0
              end as ic_operacao_triangular,        
              case
                when isnull(pv.ic_outro_cliente, ''N'') = ''S'' then 1 else 0
              end as ic_outro_cliente,        
              case
                when isnull(pv.ic_outro_cliente, ''N'') = ''S'' then (select nm_fantasia_cliente from Cliente with (nolock) where cd_cliente = pv.cd_cliente_entrega)
              end as ''nm_cliente_entrega'',        
              case
          	    when isNull(pvi.ic_sel_fechamento,IsNull(pv.ic_fechamento_total,''N'')) = ''S'' then 1 else 0
                end as ic_fechado,
              case 
                when isnull(t.ic_sedex, ''N'') = ''S'' then 1 else 0
              end as ic_sedex,              
              case
                when (IsNull(tep.ic_fataut_entrega_produto,''N'') = ''N'') then 
                  0
        	else        
                --Caso é total verifica se todos os itens do pedido possui saldo em estoque
                  case when exists((Select 0
            		       from Pedido_Venda_Item with (nolock) left outer Join
            			    Produto_Saldo  with (nolock)   on Produto_Saldo.cd_produto = Pedido_Venda_Item.cd_produto
            		                              and Produto_Saldo.cd_fase_produto = dbo.fn_fase_produto(Pedido_Venda_Item.cd_produto, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')
            		            where             (IsNull(Pedido_Venda_Item.ic_pedido_venda_item,''P'') = ''P'') and
             			                       Pedido_Venda_Item.cd_pedido_venda = pvi.cd_pedido_venda and
            			                      (IsNull(Pedido_Venda_Item.qt_saldo_pedido_venda,0) > 0) and
            			                      (isNull(Produto_Saldo.qt_saldo_atual_produto,0) - IsNull(Pedido_Venda_Item.qt_saldo_pedido_venda,0)) < 0 and pedido_venda_item.cd_produto <> 0))
                  then
                    1
                  else
                    0
                  end
            	end as ic_pedido_total_n_permitido,        
              (cast(pvi.dt_entrega_vendas_pedido as int) - cast(getdate()as int) + 1) as qt_dias,
              c.nm_fantasia_cliente,
              pv.cd_cliente, pv.dt_pedido_venda, pv.cd_pedido_venda, pvi.cd_item_pedido_venda, 
              pvi.qt_item_pedido_venda, 
              pvi.qt_saldo_pedido_venda,
              pvi.vl_unitario_item_pedido, '+'
              isnull(pvi.vl_unitario_item_pedido, 0) * isnull(pvi.qt_saldo_pedido_venda, 0) as vl_total_saldo_item, ' +
              'isnull(pvi.vl_unitario_item_pedido, 0) * isnull(pvi.qt_item_pedido_venda, 0) as vl_total_item, '+
              ' case
        		  when (IsNull(pvi.ic_pedido_venda_item,''P'')  = ''P'') then        
                 pvi.nm_fantasia_produto 
              else
                 (Select top 1 nm_servico from Servico with (nolock) where cd_servico = pvi.cd_servico)
              end as nm_fantasia_produto, '

--Saldo do Produto
--                 isnull((select isnull(qt_saldo_atual_produto,0) 
--                  from Produto_Saldo with (nolock)
--                  where cd_produto = p.cd_produto and cd_fase_produto = IsNull(p.cd_fase_produto_baixa, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0) - IsNull(n.qt_item_nota_saida,0)                                                        

Set @sSqlCompl1 = ' case when (IsNull(pvi.ic_pedido_venda_item,''P'') = ''P'') then
                       (case when isnull(p.cd_produto_baixa_estoque,0)=0 then
                           isnull((select isnull(qt_saldo_atual_produto,0) 
                                     from Produto_Saldo with (nolock)
                                     where cd_produto = p.cd_produto and cd_fase_produto = dbo.fn_fase_produto(p.cd_produto, '+ cast(IsNull(@cd_fase_venda_produto,0) as varchar)+'  )),0) 
                        else
                             isnull((select isnull(qt_saldo_atual_produto,0) 
                                     from Produto_Saldo with (nolock)
                                     where cd_produto = p.cd_produto_baixa_estoque and cd_fase_produto = dbo.fn_fase_produto(p.cd_produto, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0) 
                        end)

              else
                 IsNull(pvi.qt_saldo_pedido_venda,0) - IsNull(n.qt_item_nota_saida,0)
              end as qt_saldo_atual_produto, 
              pvi.dt_entrega_vendas_pedido, 
              pvi.dt_entrega_fabrica_pedido, (select top 1 cd_processo from processo_producao pp
              where pp.cd_pedido_venda = pvi.cd_pedido_venda and pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda
              order by pp.dt_processo desc ) as cd_processo, '

set @sSQL_Complemento = 
              --Condição de Pagamento
               'case when pv.dt_cond_pagto_pedido is null then 1 else 0 end as ic_cond_pagto, '
              +' pvi.dt_reprog_item_pedido, '
              +'(select top 1 pii.dt_entrega_ped_imp from Pedido_Importacao_Item pii with (nolock) where pvi.cd_pedido_venda = pii.cd_pedido_venda AND pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda order by pii.dt_entrega_ped_imp) as dt_entrega_ped_imp, '
              +' tep.nm_tipo_entrega_produto, '
              +' case when tep.cd_tipo_entrega_produto = 1 then ''S'' else ''N'' end as ic_entrega_total, '
              +' pvi.ic_progfat_item_pedido, '
              +' pvi.dt_progfat_item_pedido, '
              +' pvi.qt_progfat_item_pedido, '
              +' pvi.qt_bruto_item_pedido, pv.qt_volume_pedido_venda, pv.qt_fatpliq_pedido_venda, '
              +' pv.qt_fatpbru_pedido_venda, p.qt_peso_liquido, p.qt_peso_bruto, p.cd_produto, '
              +' p.cd_fase_produto_baixa, fp.nm_fase_produto, pvi.qt_liquido_item_pedido, pv.cd_tipo_entrega_produto,	  
              tep.ic_fataut_entrega_produto,
              trp.nm_tipo_restricao_pedido,
              Case isnull(pvi.cd_produto,0) 
                When 0 Then ''S''
              Else IsNull((Select top 1 ''S'' from Movimento_estoque me with (nolock) where me.cd_documento_movimento = cast(pvi.cd_pedido_venda as varchar(30)) and me.cd_item_documento = pvi.cd_item_pedido_venda), ''N'')
              End as ic_reservado, 
              IsNull((select top 1 ic_sce_tipo_pedido from tipo_pedido with (nolock) where cd_tipo_pedido = pv.cd_tipo_pedido),''S'') as ic_sce_tipo_pedido,
              t.nm_fantasia as nm_transportadora,
              tle.sg_tipo_local_entrega,
              IsNull((Select top 1 dt_previa_faturamento 
                      from previa_faturamento with (nolock)
                      where cd_previa_faturamento = 
                      (Select top 1 cd_previa_faturamento 
                       from previa_faturamento_composicao with (nolock)
                       where cd_pedido_venda = pvi.cd_pedido_venda 
                             and cd_item_pedido_venda = pvi.cd_item_pedido_venda
                      )
                     ),NULL) as dt_previa_faturamento,        
              case when isnull(pvi.cd_produto,0)>0 then ''N'' else ''S'' end as ic_produto_especial,
              pvi.ic_ordsep_pedido_venda,nm_condicao_pagamento,
              case 
                 when (IsNull(pvi.ic_pedido_venda_item,''P'')  = ''P'') then  0 else 1 end as ic_servico,
              case
                when exists (select top 1 0 from Nota_Saida_Item with (nolock) where cd_pedido_venda = pvi.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda and isnull(qt_devolucao_item_nota,0) > 0) then 1 else 0
              end as ic_devolvido,
              case
                when exists (select top 1 0 from Nota_Saida_Item nsi with (nolock), Nota_Saida ns with (nolock) where nsi.cd_nota_saida = ns.cd_nota_saida and nsi.cd_pedido_venda = pvi.cd_pedido_venda and nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and ns.dt_cancel_nota_saida is not null) then 1 else 0
              end as ic_cancelado,
              case when (IsNull(pvi.ic_pedido_venda_item,''P'') = ''P'') then
                isnull((select isnull(qt_saldo_reserva_produto,0) 
                 from Produto_Saldo with (nolock)
                 where cd_produto = p.cd_produto and cd_fase_produto = IsNull(p.cd_fase_produto_baixa, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')),0)
              else
                 IsNull(pvi.qt_saldo_pedido_venda,0)
              end as qt_saldo_reserva_produto 
            FROM
              Pedido_Venda_Item pvi with (nolock) LEFT OUTER JOIN
              Pedido_Venda pv with (nolock) ON pvi.cd_pedido_venda = pv.cd_pedido_venda LEFT OUTER JOIN
              Cliente c with (nolock) ON pv.cd_cliente = c.cd_cliente left outer join
              Transportadora t with (nolock) on t.cd_transportadora = pv.cd_transportadora left outer join
              Tipo_Local_Entrega tle with (nolock) on tle.cd_tipo_local_entrega = pv.cd_tipo_local_entrega left outer join
              Tipo_Entrega_Produto tep with (nolock) on pv.cd_tipo_entrega_produto = tep.cd_tipo_entrega_produto left outer join
              Produto p with (nolock) on pvi.cd_produto = p.cd_produto left outer join
              Tipo_Restricao_Pedido trp with (nolock) on pv.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido left outer join
              Fase_Produto fp on fp.cd_fase_produto = p.cd_fase_produto_baixa left outer join
              condicao_pagamento cp with (nolock) on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
              left outer join #Notas n on n.cd_produto = p.cd_produto and n.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, ' + cast(IsNull(@cd_fase_venda_produto,0) as varchar)+')'

  SET DATEFORMAT mdy

  set @sSQL_Where = ' where pv.dt_cancelamento_pedido is null 
                   and IsNull(pvi.qt_saldo_pedido_venda,0) > 0 and 
                   pvi.dt_cancelamento_item is null'

  -------------------------------------------------------------------------------------------------------
  -- FILTRO POR DATA DE ENTREGA COMERCIAL, UTILIZANDO O CAMPO DT_ENTREGA_VENDAS_PEDIDO
  -------------------------------------------------------------------------------------------------------
  If (@ic_filtro_prog_fat = '1')
  begin
    if @ic_parametro = 2 
      set @sSQL_Where = @sSQL_Where + ' and pvi.cd_pedido_venda = ' + cast(@cd_pedido_venda as varchar)
    else
      set @sSQL_Where = @sSQL_Where + ' and (pvi.dt_entrega_vendas_pedido BETWEEN ''' + convert (varchar, @dt_inicial,101) + ''' AND ''' + convert(varchar, @dt_final, 101) + ''')'
    
    set @sSQL_OrderBy =  ' ORDER BY  pvi.dt_entrega_vendas_pedido, pvi.cd_pedido_venda, pvi.cd_item_pedido_venda'
  end
  else       
  -------------------------------------------------------------------------------------------------------
  -- FILTRO POR DATA DE ENTREGA DA PRODUÇÃO (PCP), UTILIZANDO O CAMPO DT_ENTREGA_FABRICA_PEDIDO
  -------------------------------------------------------------------------------------------------------
  If (@ic_filtro_prog_fat = '2')
  begin
    if @ic_parametro = 2 
      set @sSQL_Where = @sSQL_Where + ' and pvi.cd_pedido_venda = ' + cast(@cd_pedido_venda as varchar)
    else
      set @sSQL_Where = @sSQL_Where + ' and (pvi.dt_entrega_fabrica_pedido BETWEEN ''' + convert (varchar, @dt_inicial,101) + ''' AND ''' + convert(varchar, @dt_final, 101) + ''')'
    
    set @sSQL_OrderBy =  ' ORDER BY  pvi.dt_entrega_fabrica_pedido, pvi.cd_pedido_venda, pvi.cd_item_pedido_venda'
  end
  else
  -------------------------------------------------------------------------------------------------------
  -- FILTRO POR DATA DE PRÉVIA, UTILIZANDO O CAMPO DT_PREVIA_FATURAMENTO
  -------------------------------------------------------------------------------------------------------
  If (@ic_filtro_prog_fat = '3')
  begin
    set @sSQL_Complemento = @sSQL_Complemento + ' left outer join Previa_Faturamento_Composicao pfc with (nolock) on pfc.cd_pedido_venda = pvi.cd_pedido_venda and
                          pfc.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
                          left outer join Previa_Faturamento pf with (nolock) on pf.cd_previa_faturamento = pfc.cd_previa_faturamento'
    if @ic_parametro = 2 
      set @sSQL_Where = @sSQL_Where + ' and pvi.cd_pedido_venda = ' + cast(@cd_pedido_venda as varchar)
    else
      set @sSQL_Where = @sSQL_Where + ' and (pf.dt_previa_faturamento BETWEEN ''' + convert (varchar, @dt_inicial,101) + ''' AND ''' + convert(varchar, @dt_final, 101) + ''')'
    
    set @sSQL_OrderBy =  ' ORDER BY  pvi.cd_pedido_venda, pvi.cd_item_pedido_venda, pf.dt_previa_faturamento'
  end
  else
  -------------------------------------------------------------------------------------------------------
  -- FILTRO POR DATA DE EMISSÃO
  -------------------------------------------------------------------------------------------------------
  If (@ic_filtro_prog_fat = '4')
  begin
    if @ic_parametro = 2 
      set @sSQL_Where = @sSQL_Where + ' and pvi.cd_pedido_venda = ' + cast(@cd_pedido_venda as varchar)
    else
      set @sSQL_Where = @sSQL_Where + ' and (pv.dt_pedido_venda BETWEEN ''' + convert (varchar, @dt_inicial,101) + ''' AND ''' + convert(varchar, @dt_final, 101) + ''')'
    
    set @sSQL_OrderBy =  ' ORDER BY  pv.dt_pedido_venda, pvi.cd_pedido_venda, pvi.cd_item_pedido_venda'
  end

--  print @sSQLTemp 
--  print @sSQL 
--  print @sSqlCompl1
--  print @sSQL_Complemento 
--  print @sSQL_Where 
--  print @sSQL_OrderBy
   
 --Exec para Rodar a Stored Procedure ( Macro Substituição) ( Atenção, não pode ser comentado a linha abaixo--
  
 exec (@sSQLTemp + @sSQL + @sSqlCompl1 + @sSQL_Complemento + @sSQL_Where + @sSQL_OrderBy)

