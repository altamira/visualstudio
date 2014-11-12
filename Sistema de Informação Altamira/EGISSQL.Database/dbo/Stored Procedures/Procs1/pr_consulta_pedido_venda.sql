
------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_consulta_pedido_venda
-------------------------------------------------------------------------------
--pr_consulta_pedido_venda
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                        	           2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Igor Gama
--Banco de Dados        : EgisSql
--Objetivo              : Realizar uma consulta de Pedido_Venda
--Data                  : 14/03/2002
--Atualizado            : 15/03/2002 - Igor Gama
--                      : 23/04/2003 - Daniel C. Neto. - Verificação de Serviço.
--                      : 30/07/2003 - Rafael M. Santiago - Incluido o Local de Entrega, Endereço de Faturamento, Amostra,
--                                     Consignacao, Transportadora, Destinação
--                      : 04.08.2003 - Fabio - Apresentar a última nota impressa para o 
-- 				       pedido de venda, caso exista mais de uma coluna 
-- 				       com a quantidade total faturada em mais de uma nota
--                      : 08.08.2003 - Carlos - Acerto Geral
--                      : 11/08/2003 - INCLUSÃO DE COLUNA QT_VOLUME_NOTA_SAIDA TEMPORÁRIAMENTE - ELIAS
--                      : 19/08/2003 - Acerto de Filtro do Endereço de Entrega - ELIAS
--	                : 07.01.2004 - Incluido a Mascara do Produto - RAFAEL 
--                      : 27.02.2004 - Igor Gama - Inclusão de parametros para a procedure
--                                   - Param 1 - Continua inalterado a query
--                                   - Param 2 - Nova query para retornar dados da NF selecionada atravéz do pedido
--                      : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 05/05/2005 - Acerto na Listagem das Colunas referentes a Última NF Faturada para o PV - ELIAS
--                      : 01.06.2005 - Revisão - Carlos Fernandes
--                      : 27.10.2005 - Area do Produto - Márcio
--                      : 24.02.2007 - Verificação do Item de Serviço - Carlos Fernandes
-- 01.04.2008 - Acerto do Serviço/Produto - Carlos Fernandes
-- 03.12.2008 - Complementos de informações - Carlos Fernandes
-- 05.10.2010 - Identificação da Nota Fiscal --> ( Nota_Saida --> cd_identificacao_nota_saida ) - Carlos Fernandes

----------------------------------------------------------------------------------------------
@ic_parametro    as int = 1,
@cd_pedido_venda as int,
@dt_inicial      as DateTime,
@dt_final        as DateTime,
@cd_usuario      as int = 0

AS

  -- Tipo de Endereço utilizado na Consulta - ENTREGA 
  -- ELIAS 19/08/2003

  declare @cd_tipo_endereco int
  declare @cd_tipo_endereco_pedido int

  select
    top 1
    @cd_tipo_endereco = cd_tipo_endereco
  from
    Tipo_Endereco with (nolock) 
  where
    sg_tipo_endereco = 'E'

  --Verificando se foi selecionado o endereço de Entrega no pedido
  Select 
    @cd_tipo_endereco_pedido = cd_tipo_endereco 
  From 
    Pedido_venda with (nolock) 
  Where cd_pedido_venda = @cd_pedido_venda

  if @cd_tipo_endereco_pedido > 0
  begin
    set @cd_tipo_endereco = @cd_tipo_endereco_pedido
  end 
   
  If IsNull(@ic_parametro, 1) = 1
  BEGIN
    IF (@cd_pedido_venda = 0)
    BEGIN
		  SELECT     
		    ped.cd_pedido_venda,
		    ped.dt_pedido_venda,
		    ped.cd_vendedor as cd_vendedor_pedido,
		    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
		    ped.cd_vendedor_interno,
		    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
		    ped.dt_cancelamento_pedido,
		    ped.ds_cancelamento_pedido,
		    IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
		    CAST((qt_item_pedido_venda * vl_unitario_item_pedido) as numeric(25,2)) as 'vl_total_pedido_venda', 
		    ped.qt_liquido_pedido_venda, 
		    ped.qt_bruto_pedido_venda, 
		    pvi.cd_item_pedido_venda, 
		    pvi.dt_item_pedido_venda, 
		    pvi.qt_item_pedido_venda, pvi.pc_desconto_item_pedido, 
		    pvi.qt_saldo_pedido_venda, 
		    pvi.dt_entrega_vendas_pedido,
		    pvi.dt_entrega_fabrica_pedido, 
		    CAST(pvi.vl_unitario_item_pedido as numeric(25,2)) as 'vl_unitario_item_pedido', 
		    ped.nm_alteracao_pedido_venda,
		    CONVERT(char(10),ped.dt_alteracao_pedido_venda, 103) as 'dt_ult_alteracao',
		    cli.cd_cliente, 
		    cli.nm_fantasia_cliente, 
		    cli.nm_razao_social_cliente,
		    ped.cd_tipo_restricao_pedido, 
		    trp.nm_tipo_restricao_pedido, 
		    trp.sg_tipo_restricao,  
		    tp.cd_tipo_pedido, 
		    tp.nm_tipo_pedido,
		    st.sg_status_pedido,
		    st.nm_status_pedido,
		    ped.cd_vendedor, 
		    ped.cd_contato, 
		    (Select top 1 nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',

                     case when isnull(pvi.cd_servico,0)>0 then
                             cast(pvi.cd_servico as varchar(25)) 
                        else
                           case when isnull(dbo.fn_mascara_produto(pvi.cd_produto),0) = '0' then
 		      cast(pvi.cd_grupo_produto as varchar(15)) 
		    else
		      dbo.fn_mascara_produto(pvi.cd_produto) end 
                    end as cd_mascara_produto,--prod.cd_mascara_produto,
	
 	            prod.cd_produto,

                    case when isnull(pvi.cd_servico,0)>0 then
                       cast(s.nm_servico as varchar(25))
                    else
                       pvi.nm_fantasia_produto
                    end                      as 'nm_fantasia_produto', 

                    case when isnull(pvi.cd_servico,0)>0 then
                         case when cast(pvi.ds_produto_pedido_venda as varchar(50))=''
                              then cast(s.nm_servico as varchar(50))
                              else cast(pvi.ds_produto_pedido_venda as varchar(50))
                         end
                     else   
                         pvi.nm_produto_pedido 
                     end as nm_produto_pedido,  

--		    IsNull(pvi.nm_produto_pedido, cast(s.ds_servico as varchar(240))) as 'nm_produto_pedido', 

		    cop.nm_condicao_pagamento,
		    cop.sg_condicao_pagamento,
		    cop.qt_parcela_condicao_pgto,
		    --Trazer a última nota impressa para o pedido
		    nst.cd_nota_saida,
	  		--Trazer a data da última nota impressa para o pedido
                    nst.dt_nota_saida,
	  	    --Trazer as quantidades da última nota impressa para o pedido
                    nst.qt_Qtdade,
	  	    --Trazer o total de quantidades da última nota impressa para o pedido
		    nst.qt_Qtdade_Faturada,
		    IsNull(pvi.ic_pedido_venda_item, 'P') as ic_pedido_venda,
-- 		    cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' - ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado as 'EndFat',
-- 		    case when cliend.nm_endereco_cliente is null then
-- 		      cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' - ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado
-- 		    else
-- 		      cliend.nm_endereco_cliente + ', ' + ltrim(rtrim(cliend.cd_numero_endereco)) + ' - ' + ltrim(rtrim(cliend.cd_complemento_endereco)) + ' - ' + cliend.nm_bairro_cliente + ' - ' + ltrim(rtrim(cidend.nm_cidade)) + ' - ' + estend.sg_estado 
-- 		    end as 'LocalEntrega',
		    cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado as 'EndFat',
		    case when cliend.nm_endereco_cliente is null then
		      cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado
		    else
		      cliend.nm_endereco_cliente + ', ' + ltrim(rtrim(cliend.cd_numero_endereco)) + ' ' + ltrim(rtrim(cliend.nm_complemento_endereco)) + ' - ' + cliend.nm_bairro_cliente + ' - ' + ltrim(rtrim(cidend.nm_cidade)) + ' - ' + estend.sg_estado 
		    end as 'LocalEntrega',
		    tr.nm_fantasia                          as nm_fantasia_trasportadora,
		    dest.nm_destinacao_produto,
		    ISNULL(ped.ic_consignacao_pedido,'N')   as ic_consignacao_pedido,
		    ISNULL(ped.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,
		
		   -- COLOCADO TEMPORÁRIAMENTE ATÉ A ATUALIZAÇÀO DE VERSÃO - ELIAS 11/08/2003
		    (Select top 1 nfs.qt_volume_nota_saida
		     from Nota_Saida_Item nsi Left Outer Join
		          Nota_Saida nfs on nsi.cd_nota_saida = nfs.cd_nota_saida and
		                            IsNull(nfs.cd_status_nota,6) in (1,2,3,5,6)  
		     where nsi.cd_pedido_venda = pvi.cd_pedido_venda and
		           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
		           IsNull(nsi.cd_status_nota,6) in (1,2,3,5,6) 
		     order by nfs.dt_nota_saida desc) as qt_volume_nota_saida,
           isnull(pvi.qt_area_produto,0) as qt_area_produto,
			  isnull(pvi.qt_area_produto,0) * isnull(qt_item_pedido_venda,0)                          as qt_total_area,
			  dbo.fn_ultima_ordem_producao_item_pedido(ped.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo,
			  isnull(ped.ic_entrega_futura,'N') as ic_entrega_futura,
                          tpr.sg_tabela_preco,
                          vei.nm_veiculo
                          
--select * from tabela_preco
                          
		  FROM
		    Pedido_venda ped          with (nolock) 
                    inner join Pedido_Venda_Item pvi     with (nolock) on ped.cd_pedido_venda = pvi.cd_pedido_Venda 
                                                                         and isnull(pvi.cd_produto_servico,0)=0
                    left outer join Tabela_Preco tpr          with (nolock) on tpr.cd_tabela_preco = pvi.cd_tabela_preco
                    left Outer Join Cliente cli               with (nolock) on ped.cd_cliente      = cli.cd_cliente     
                    left outer Join Tipo_Restricao_Pedido trp with (nolock) on ped.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido 
                    Left Outer Join Produto prod              with (nolock) on pvi.cd_produto = prod.cd_produto and IsNull(pvi.ic_pedido_venda_item,'P') = 'P' 
                    Left Outer Join Condicao_Pagamento cop    with (nolock) on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento   
                    Left Outer Join Status_Pedido st          with (nolock) on st.cd_status_pedido = ped.cd_status_pedido 
                    Left Outer Join Tipo_Pedido tp            with (nolock) on tp.cd_tipo_pedido = ped.cd_tipo_pedido 
                    left outer join Servico s                 with (nolock) on s.cd_servico = pvi.cd_servico and IsNull(pvi.ic_pedido_venda_item,'P') = 'S' 
                    left outer join Transportadora tr         with (nolock) on ped.cd_transportadora = tr.cd_transportadora 
                    LEFT OUTER JOIN Destinacao_Produto dest   with (nolock) on ped.cd_destinacao_produto = dest.cd_destinacao_produto 
                    LEFT OUTER JOIN Cidade cid                with (nolock) on cli.cd_cidade = cid.cd_cidade and cli.cd_pais = cid.cd_pais and cli.cd_estado = cid.cd_estado 
                    left outer join Estado est                with (nolock) on cli.cd_pais = est.cd_pais and cli.cd_estado = est.cd_estado 
                    left outer join Cliente_Endereco cliend   with (nolock) on cliend.cd_cliente = cli.cd_cliente and cliend.cd_tipo_endereco = @cd_tipo_endereco 
                    left outer join Estado estend             with (nolock)   on cliend.cd_pais = estend.cd_pais and cliend.cd_estado = estend.cd_estado 
                    left outer join Cidade cidend             with (nolock)   on cliend.cd_pais = cidend.cd_pais and cliend.cd_estado = cidend.cd_estado and cliend.cd_cidade = cidend.cd_cidade 
                    left outer join Pedido_Venda_Transporte pvt with (nolock) on pvt.cd_pedido_venda = ped.cd_pedido_venda
                    left outer join Veiculo vei                 with (nolock) on vei.cd_veiculo      = pvt.cd_veiculo

              left outer join

	      -- Tabela com as informações necessárias da última Nota Fiscal do Pedido
	      (select 
                     --ns.cd_nota_saida, 
                    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
                    then
                      ns.cd_identificacao_nota_saida
                    else ns.cd_nota_saida 
                    end as cd_nota_saida,     
                     ns.dt_nota_saida, sum(nsi.qt_item_nota_saida) as qt_Qtdade,
	             nsit.qt_Qtdade_Faturada, nsi.cd_pedido_venda, nsi.cd_item_pedido_venda
	       from Nota_Saida ns with (nolock) inner join
	            Nota_Saida_Item nsi               with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida 
	            inner join Pedido_Venda_Item pvi  with (nolock) on pvi.cd_pedido_venda = @cd_pedido_venda
	            inner join (select max(cd_nota_saida) as cd_nota_saida,
	                               cd_item_pedido_venda
	                        from Nota_Saida_Item with (nolock)
	                        where cd_pedido_venda = @cd_pedido_venda and
	                              IsNull(cd_status_nota,6) in (1,2,3,5,6)
	                        group by cd_item_pedido_venda) nsix on nsix.cd_nota_saida = ns.cd_nota_saida 
	            left outer join (select cd_pedido_venda, cd_item_pedido_venda, sum(qt_item_nota_saida) as qt_Qtdade_Faturada 
	                             from Nota_Saida_Item
	                             where cd_pedido_venda = @cd_pedido_venda and
	                                   IsNull(cd_status_nota,6) in (1,2,3,5,6) 
	                             group by cd_pedido_venda, cd_item_pedido_venda) nsit on nsit.cd_pedido_venda = nsi.cd_pedido_venda and 
	                                                                                     nsit.cd_item_pedido_venda = nsi.cd_item_pedido_venda
	       where nsix.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
	             nsit.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
	             nsi.cd_pedido_venda       = pvi.cd_pedido_venda and
	             nsi.cd_item_pedido_venda  = pvi.cd_item_pedido_venda and
	             IsNull(nsi.cd_status_nota,6) in (1,2,3,5,6) 				 
	       group by ns.cd_nota_saida,
                        ns.cd_identificacao_nota_saida,
                        ns.dt_nota_saida, nsit.qt_Qtdade_Faturada,
	                nsi.cd_pedido_venda, nsi.cd_item_pedido_venda) nst
	         on nst.cd_pedido_venda = pvi.cd_pedido_venda and 
	         nst.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
		
		  WHERE         
		    ped.dt_pedido_venda BETWEEN @dt_inicial AND @dt_final and
	        ( dbo.fn_vendedor_pedido_internet(@cd_usuario, pvi.cd_pedido_venda ) = 'S' )	

		  ORDER BY
		    ped.dt_pedido_venda desc,
		    ped.cd_pedido_venda desc, 
		    pvi.cd_item_pedido_venda

    END
    -- Caso o PV Tenha Sido Informado, Trazer Somente Ele
    ELSE
    BEGIN
		  SELECT     
		    ped.cd_pedido_venda,
		    ped.dt_pedido_venda,
		    ped.cd_vendedor as cd_vendedor_pedido,
		    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
		    ped.cd_vendedor_interno,
		    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
		    ped.dt_cancelamento_pedido,
		    ped.ds_cancelamento_pedido,
		    IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
		    CAST((qt_item_pedido_venda * vl_unitario_item_pedido) as numeric(25,2)) as 'vl_total_pedido_venda', 
		    ped.qt_liquido_pedido_venda, 
		    ped.qt_bruto_pedido_venda, 
		    pvi.cd_item_pedido_venda, 
		    pvi.dt_item_pedido_venda, 
		    pvi.qt_item_pedido_venda, pvi.pc_desconto_item_pedido, 
		    pvi.qt_saldo_pedido_venda, 
		    pvi.dt_entrega_vendas_pedido,
		    pvi.dt_entrega_fabrica_pedido, 
		    CAST(pvi.vl_unitario_item_pedido as numeric(25,2)) as 'vl_unitario_item_pedido', 
		    ped.nm_alteracao_pedido_venda,
		    CONVERT(char(10),ped.dt_alteracao_pedido_venda, 103) as 'dt_ult_alteracao',
		    cli.cd_cliente, 
		    cli.nm_fantasia_cliente, 
		    cli.nm_razao_social_cliente,
		    ped.cd_tipo_restricao_pedido, 
		    trp.nm_tipo_restricao_pedido, 
		    trp.sg_tipo_restricao,  
		    tp.cd_tipo_pedido, 
		    tp.nm_tipo_pedido,
		    st.sg_status_pedido,
		    st.nm_status_pedido,
		    ped.cd_vendedor, 
		    ped.cd_contato, 
		    (Select top 1 nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',
                     case when isnull(pvi.cd_servico,0)>0 then
                             cast(pvi.cd_servico as varchar(25)) 
                        else
                           case when isnull(dbo.fn_mascara_produto(pvi.cd_produto),0) = '0' then
 		      cast(pvi.cd_grupo_produto as varchar(15)) 
		    else
		      dbo.fn_mascara_produto(pvi.cd_produto) end 
                    end as cd_mascara_produto,--prod.cd_mascara_produto,
	
		    prod.cd_produto,
                    case when isnull(pvi.cd_servico,0)>0 then
                       cast(s.nm_servico as varchar(25))
                    else
                       pvi.nm_fantasia_produto
                    end                      as 'nm_fantasia_produto', 

                    case when isnull(pvi.cd_servico,0)>0 then
                         case when cast(pvi.ds_produto_pedido_venda as varchar(50))=''
                              then cast(s.nm_servico as varchar(50))
                              else cast(pvi.ds_produto_pedido_venda as varchar(50))
                         end
                     else   
                         pvi.nm_produto_pedido 
                     end as nm_produto_pedido,  

		    cop.nm_condicao_pagamento,
		    cop.sg_condicao_pagamento,
		    cop.qt_parcela_condicao_pgto,
		    --Trazer a última nota impressa para o pedido
		    nst.cd_nota_saida,
                    --Trazer a data da última nota impressa para o pedido
	      nst.dt_nota_saida,
	  	  --Trazer as quantidades da última nota impressa para o pedido
	      nst.qt_Qtdade,
	  	  --Trazer o total de quantidades da última nota impressa para o pedido
		    nst.qt_Qtdade_Faturada,
		    IsNull(pvi.ic_pedido_venda_item, 'P') as ic_pedido_venda,
-- 		    cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado as 'EndFat',
-- 		    case when cliend.nm_endereco_cliente is null then
-- 		      cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado
-- 		    else
-- 		      cliend.nm_endereco_cliente + ', ' + ltrim(rtrim(cliend.cd_numero_endereco)) + ' - ' + cliend.nm_bairro_cliente + ' - ' + ltrim(rtrim(cidend.nm_cidade)) + ' - ' + estend.sg_estado 
-- 		    end as 'LocalEntrega',
		    cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado as 'EndFat',
		    case when cliend.nm_endereco_cliente is null then
		      cli.nm_endereco_cliente + ', ' + ltrim(rtrim(cli.cd_numero_endereco)) + ' ' + ltrim(rtrim(cli.nm_complemento_endereco)) + ' - ' + cli.nm_bairro + ' - ' + ltrim(rtrim(cid.nm_cidade)) + ' - ' + est.sg_estado
		    else
		      cliend.nm_endereco_cliente + ', ' + ltrim(rtrim(cliend.cd_numero_endereco)) + ' ' + ltrim(rtrim(cliend.nm_complemento_endereco)) + ' - ' + cliend.nm_bairro_cliente + ' - ' + ltrim(rtrim(cidend.nm_cidade)) + ' - ' + estend.sg_estado 
		    end as 'LocalEntrega',
		    tr.nm_fantasia                          as nm_fantasia_trasportadora,
		    dest.nm_destinacao_produto,
		    ISNULL(ped.ic_consignacao_pedido,'N')   as ic_consignacao_pedido,
		    ISNULL(ped.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,
		
		   -- COLOCADO TEMPORÁRIAMENTE ATÉ A ATUALIZAÇÀO DE VERSÃO - ELIAS 11/08/2003
		    (Select top 1 nfs.qt_volume_nota_saida
		     from Nota_Saida_Item nsi Left Outer Join
		          Nota_Saida nfs on nsi.cd_nota_saida = nfs.cd_nota_saida and
		                            IsNull(nfs.cd_status_nota,6) in (1,2,3,5,6)  
		     where nsi.cd_pedido_venda = pvi.cd_pedido_venda and
		           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
		           IsNull(nsi.cd_status_nota,6) in (1,2,3,5,6) 
		     order by nfs.dt_nota_saida desc) as qt_volume_nota_saida,
         case IsNull(nst.cd_nota_saida,0)
           when 0 then
             IsNull( (Select top 1 'S' from Nota_Saida_item with (nolock) 
                      where cd_pedido_venda = pvi.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda),'N')
           else
              'N'
         end ic_possui_nf_canc_dev, --Campo utilizado para saber se o item não possui uma nota		
           isnull(pvi.qt_area_produto,0) as qt_area_produto,
			  isnull(pvi.qt_area_produto,0) * isnull(qt_item_pedido_venda,0)  as qt_total_area,
			  dbo.fn_ultima_ordem_producao_item_pedido(ped.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo,
			  isnull(ped.ic_entrega_futura,'N') as ic_entrega_futura,
                          tpr.sg_tabela_preco,
                          vei.nm_veiculo
		  FROM
		    Pedido_venda ped          with (nolock) 
                    inner join Pedido_Venda_Item pvi     with (nolock) on ped.cd_pedido_venda = pvi.cd_pedido_Venda 
                                                                         and isnull(pvi.cd_produto_servico,0)=0
                    left outer join Tabela_Preco tpr          with (nolock) on tpr.cd_tabela_preco = pvi.cd_tabela_preco
                    left Outer Join Cliente cli               with (nolock) on ped.cd_cliente      = cli.cd_cliente     
                    left outer Join Tipo_Restricao_Pedido trp with (nolock) on ped.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido 
                    Left Outer Join Produto prod              with (nolock) on pvi.cd_produto = prod.cd_produto and IsNull(pvi.ic_pedido_venda_item,'P') = 'P' 
                    Left Outer Join Condicao_Pagamento cop    with (nolock) on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento   
                    Left Outer Join Status_Pedido st          with (nolock) on st.cd_status_pedido = ped.cd_status_pedido 
                    Left Outer Join Tipo_Pedido tp            with (nolock) on tp.cd_tipo_pedido = ped.cd_tipo_pedido 
                    left outer join Servico s                 with (nolock) on s.cd_servico = pvi.cd_servico and IsNull(pvi.ic_pedido_venda_item,'P') = 'S' 
                    left outer join Transportadora tr         with (nolock) on ped.cd_transportadora = tr.cd_transportadora 
                    LEFT OUTER JOIN Destinacao_Produto dest   with (nolock) on ped.cd_destinacao_produto = dest.cd_destinacao_produto 
                    LEFT OUTER JOIN Cidade cid                with (nolock) on cli.cd_cidade = cid.cd_cidade and cli.cd_pais = cid.cd_pais and cli.cd_estado = cid.cd_estado 
                    left outer join Estado est                with (nolock) on cli.cd_pais = est.cd_pais and cli.cd_estado = est.cd_estado 
                    left outer join Cliente_Endereco cliend   with (nolock) on cliend.cd_cliente = cli.cd_cliente and cliend.cd_tipo_endereco = @cd_tipo_endereco 
                    left outer join Estado estend             with (nolock)   on cliend.cd_pais = estend.cd_pais and cliend.cd_estado = estend.cd_estado 
                    left outer join Cidade cidend             with (nolock)   on cliend.cd_pais = cidend.cd_pais and cliend.cd_estado = cidend.cd_estado and cliend.cd_cidade = cidend.cd_cidade 
                    left outer join Pedido_Venda_Transporte pvt with (nolock) on pvt.cd_pedido_venda = ped.cd_pedido_venda
                    left outer join Veiculo vei                 with (nolock) on vei.cd_veiculo      = pvt.cd_veiculo

              left outer join

	      -- Tabela com as informações necessárias da última Nota Fiscal do Pedido
              --select cd_identificacao_nota_saida,* from nota_saida

	      (select 
                     --ns.cd_nota_saida,
                    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
                    then
                      ns.cd_identificacao_nota_saida
                    else ns.cd_nota_saida 
                    end as cd_nota_saida,     

                     ns.dt_nota_saida, sum(nsi.qt_item_nota_saida) as qt_Qtdade,
	             nsit.qt_Qtdade_Faturada, nsi.cd_pedido_venda, nsi.cd_item_pedido_venda
	       from Nota_Saida ns with (nolock) inner join
	            Nota_Saida_Item nsi with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida 
	            inner join Pedido_Venda_Item pvi with (nolock) on pvi.cd_pedido_venda = @cd_pedido_venda
	            inner join (select max(cd_nota_saida) as cd_nota_saida,
	                               cd_item_pedido_venda
	                        from Nota_Saida_Item with (nolock) 
	                        where cd_pedido_venda = @cd_pedido_venda and
	                              IsNull(cd_status_nota,6) in (1,2,3,5,6)
	                        group by cd_item_pedido_venda) nsix on nsix.cd_nota_saida = ns.cd_nota_saida 
	            left outer join (select cd_pedido_venda, cd_item_pedido_venda, sum(qt_item_nota_saida) as qt_Qtdade_Faturada 
	                             from Nota_Saida_Item with (nolock) 
	                             where cd_pedido_venda = @cd_pedido_venda and
	                                   IsNull(cd_status_nota,6) in (1,2,3,5,6) 
	                             group by cd_pedido_venda, cd_item_pedido_venda) nsit on nsit.cd_pedido_venda = nsi.cd_pedido_venda and 
	                                                                                     nsit.cd_item_pedido_venda = nsi.cd_item_pedido_venda
	       where nsix.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
	             nsit.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
	             nsi.cd_pedido_venda = pvi.cd_pedido_venda and
	             nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
	             IsNull(nsi.cd_status_nota,6) in (1,2,3,5,6) 
	       group by ns.cd_nota_saida, 
                        ns.cd_identificacao_nota_saida,
                        ns.dt_nota_saida, nsit.qt_Qtdade_Faturada,
	                nsi.cd_pedido_venda, nsi.cd_item_pedido_venda) nst
	      on nst.cd_pedido_venda = pvi.cd_pedido_venda and 
	         nst.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
		
		  WHERE         
		    ped.cd_pedido_venda = @cd_pedido_venda and
    		( dbo.fn_vendedor_pedido_internet(@cd_usuario, pvi.cd_pedido_venda ) = 'S' )	
		  ORDER BY
		    ped.dt_pedido_venda desc,
		    ped.cd_pedido_venda desc, 
		    pvi.cd_item_pedido_venda

    END

  END

  Else if IsNull(@ic_parametro,1) = 2
    SELECT
      --ns.cd_nota_saida,
      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
                    then
                      ns.cd_identificacao_nota_saida
                    else ns.cd_nota_saida 
      end as cd_nota_saida,     

      ns.dt_nota_saida,
      ns.dt_saida_nota_saida,
      nsi.cd_item_nota_saida,
      nsi.qt_devolucao_item_nota,
      nsi.qt_item_nota_saida,
      ns.dt_cancel_nota_saida,
      ns.nm_mot_cancel_nota_saida,
      nsi.cd_item_pedido_venda     
    FROM
      Nota_Saida ns       with (nolock) Inner Join
      Nota_Saida_Item nsi with (nolock) ON ns.cd_nota_saida = nsi.cd_nota_saida
    WHERE
      ns.cd_pedido_venda = @cd_pedido_venda and
      ( dbo.fn_vendedor_pedido_internet(@cd_usuario, @cd_pedido_venda ) = 'S' )
    ORDER BY 
      1 desc

