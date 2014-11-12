
CREATE PROCEDURE pr_laudo
-------------------------------------------------------------------------------------------------
--pr_laudo
-------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------------------------------------

--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		:  Realizar consulta para Controle de Laudo
--Data		        : 09.03.2004
--                      : 26/07/2004 - Inclusão de parâmetros e do parâmetro 5 - 
--                                   - Daniel C. Neto
--                      : 17/11/2004 - Inclusao do campo ds_produto no select
--                                   - Roberto Mendonça
--Atualização           : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 09.05.2005 - Colocado o resultado obtido pela empresa - Carlos Fernandes
--                      : 24.05.2005 - Ordem de Apresentação - Data Laudo Desc - Carlos / Rafael
--			: 07/10/2005 - Ajuste para impressão do laudo.
--                      : 18.03.2006 - Origem do Produto - carlos fernandes
--                      : 23.07.2007 - Cliente - Carlos Fernandes
--                      : 06.08.2007 - Acertos para Laudo - Carlos Fernandes
-- 03.01.2008 - Acerto da Variável com os itens do Laudo - estava estourando - Carlos Fernandes
-- 04.02.2008 - Novo Atributo - Fabricante - Carlos Fernandes
-- 11.04.2008 - Complemento dos novos atributos - Carlos Fernandes.
-- 08.07.2008 - Complemento dos campos - Carlos Fernandes
-- 19.09.2008 - Ajuste do CAS - Carlos Fernandes
-- 14.10.2008 - Verificação da Pedido de Venda - Carlos Fernandes
-- 07.02.2009 - Complemento dos Dados para Laudo - Carlos Fernandes
-- 18.03.2009 - Ajustes Diversos - Carlos Fernandes
-- 09.11.2009 - Verificação da descrição de laudo sem Produto - Carlos Fernandes
-- 23.08.2010 - Ajuste do número da Nota Fiscal - Carlos Fernandes 
-- 08.10.2010 - Descrição da Nota Fiscal de Entrada - Carlos Fernandes
-- 08.11.2010 - Nota / Lote Interno - Carlos Fernandes
-- 11.11.2010 - Ajuste da identificacao da Nota de saida - Carlos Fernandes
-- 01.12.2010 - Lote do Fabricante - Carlos Fernandes
-- 19.01.2011 - Pesquisa de Laudo por Lote - Carlos Fernandes
-------------------------------------------------------------------------------------------------
@ic_parametro           as int = 0,
@dt_inicial             as DateTime,
@dt_final               as DateTime,
@cd_laudo               as int,
@nm_fantasia_fornecedor as varchar(50),
@nm_fantasia_produto    as varchar(50),
@cd_nota_entrada        as Int          = 0,
@cd_nota_saida          as int          = 0 ,
@cd_item_nota_saida     as int          = 0 ,
@cd_chave               as varchar(500) = '',
@cd_lote                as varchar(25)  = ''

as


set @cd_chave = rtrim(ltrim(@cd_chave))

-------------------------------------------------------------------
if @ic_parametro = 5 -- Imprime laudos relacionados com Nota.
-------------------------------------------------------------------
-- Obs: - Cuidado ao mudar a ordem do parâmetro 5, ele refelirá
-- na tela de seleção de Impressão de laudos e, para isso, será
-- necessário mudar também a pr_impressao_laudo.
-------------------------------------------------------------------

begin

  declare @SQL varchar(8000)

  set @SQL = ' select ' +
--      IDENTITY(int, 1, 1) as cd_chave,
     'n.cd_chave, d.nm_fantasia, d.nm_razao_social, d.cd_cnpj, ns.cd_identificacao_nota_saida, '+
     'n.cd_nota_saida, n.cd_item_nota_saida, n.cd_nota_saida_item_lote, '+
      'ns.dt_nota_saida,sn.nm_status_nota, '+
      'l.*, '+
      'ol.nm_origem_laudo, f.nm_fantasia_fornecedor, '+
      't.nm_tecnico, '+
      'case when p.nm_produto is not null then p.nm_produto else l.nm_produto_especial_laudo end as nm_produto, p.cd_mascara_produto, '+
      'p.nm_fantasia_produto, '+
      'p.ds_produto, '+
      ' um.nm_unidade_medida, '+
      ' isnull(po.nm_pais,op.nm_pais)       as nm_origem_produto, '+
      ' pp.nm_procedencia_produto, '+
      ' cast(fab.nm_razao_social as varchar(40)) as nm_fabricante_laudo,  '+
      ' isnull(lpq.cd_dcb_produto,pq.cd_dcb_produto) as cd_dcb_produto, '+
      ' isnull(lpq.cd_dci_produto,pq.cd_dci_produto) as cd_dci_produto, '+
      ' isnull(lpq.cd_cas_produto,pq.cd_cas_produto) as cd_cas_produto, '+
      ' case when isnull(l.cd_pedido_venda,0)>0 then l.cd_pedido_venda else prod.cd_pedido_venda end as cd_pedido_venda_laudo, '+
      ' case when isnull(l.cd_item_pedido_venda,0)>0 then l.cd_item_pedido_venda else prod.cd_item_pedido_venda end as cd_item_pedido_venda_laudo, '+
      ' mi.nm_metodo_inspecao, i.nm_inspetor, p.cd_laudo_padrao, 0 as cd_pedido_compra, 0 as cd_item_pedido_compra, cast(null as datetime) as dt_item_receb_nota_entrad, '+
      ' 0 as cd_rem, cast(null as varchar) as nm_laudo_padrao, cast(null as varchar) as nm_produto_nota_entrada, '+
      ' ns.nm_fantasia_nota_saida as nm_fantasia_cliente ' +
      ' into #Nota '+
    'from '+
      ' Nota_Saida ns with (nolock) inner join '+
   '   Nota_saida_item_lote n with (nolock) on n.cd_nota_saida = ns.cd_nota_saida left outer join '+
   '   Laudo l on l.cd_laudo = n.cd_laudo left outer join '+
   '   vw_Destinatario d on d.cd_destinatario = ns.cd_cliente and '+
   '                        d.cd_tipo_destinatario = ns.cd_tipo_destinatario left outer join '+
   '   Status_Nota sn on sn.cd_status_nota = ns.cd_status_nota left outer join '+
   '   Origem_laudo ol on (l.cd_origem_laudo = ol.cd_origem_laudo) left outer join    '+
   '   Fornecedor f    on (l.cd_fornecedor = f.cd_fornecedor) left outer join '+
   '   Tecnico t on (l.cd_tecnico = t.cd_tecnico) left outer join '+
   '   Produto p  on (l.cd_produto = p.cd_produto) left outer join '+
   '   Produto_Fiscal pf on (l.cd_produto = pf.cd_produto) LEFT OUTER JOIN '+
   '   Procedencia_Produto pp on (pf.cd_procedencia_produto = pp.cd_procedencia_produto) LEFT OUTER JOIN '+
   '   unidade_medida um   on (l.cd_unidade_medida = um.cd_unidade_medida) '+
   '   left outer join Pais op on (op.cd_pais = p.cd_origem_produto) '+
   '   left outer join Pais po on po.cd_pais = l.cd_origem_produto  '+
   '   left outer join Fabricante fab on fab.cd_fabricante = l.cd_fabricante '+
   '   left outer join Laudo_Produto_Quimico lpq on lpq.cd_laudo = l.cd_laudo '+
   '   left outer join Produto_Quimico pq on pq.cd_produto = p.cd_produto '+
   '   left outer join Processo_Producao prod on prod.cd_processo = l.cd_processo '+
   '   left outer join Metodo_Inspecao mi on mi.cd_metodo_inspecao = l.cd_metodo_inspecao '+
   '   left outer join Inspetor i on i.cd_inspetor = l.cd_inspetor '+       
  '  where ' 

--select * from laudo  
--select * from inspetor
--select * from produto_quimico

  if isnull(@cd_nota_saida,0) <> 0 
     set @SQL = @SQL + ' IsNull(ns.cd_nota_saida,0) = ' + cast(@cd_nota_saida as varchar) + ' and ' 
  else
     set @SQL = @SQL + ' 1 = 1 and ' 

  if isnull(@cd_item_nota_saida,0) <> 0 
     set @SQL = @SQL + ' IsNull(n.cd_item_nota_saida,0) = ' + cast(@cd_item_nota_saida as varchar)  
  else
     set @SQL = @SQL + ' 1 = 1 ' 

  set @SQL = @SQL + ' order by n.cd_nota_saida desc, n.cd_item_nota_saida '

  --Apresentação da Tabela Temporária

  if @cd_chave <> ''
     set @SQL = @SQL + ' select * from #Nota where cd_chave in ( ' + @cd_chave + ')'
  else
     set @SQL = @SQL + ' select * from #Nota where cd_chave is null ' -- Um valor qualquer pra não trazer nada.

--  print @sql

  exec(@SQL)

end

--------------------------------------------------------------------
else -- Imprime como estava antes.
--------------------------------------------------------------------
begin

  declare @filtro varchar(8000)

  /*set @cd_laudo = isnull(@cd_laudo,0)
  set @nm_fantasia_fornecedor = isnull(@nm_fantasia_fornecedor,'')
  set @cd_nota_entrada = isnull(@cd_nota_entrada,0)
  
  if @ic_parametro <> 3 
    set @nm_fantasia_fornecedor = ''

  if @ic_parametro <> 4
    set @nm_fantasia_produto = ''*/

 --select cd_nota_saida,* from laudo
 --nota_entrada_item
 --select * from origem_laudo

 set  @filtro = 'Select ' +
    'l.*, ol.nm_origem_laudo, '+
    ' case when isnull(f.nm_fantasia_fornecedor,'''''+')<>'+''''''+' then f.nm_fantasia_fornecedor else c.nm_fantasia_cliente end as nm_fantasia_fornecedor, '+
    't.nm_tecnico, '+ 
    'case when nei.nm_produto_nota_entrada is not null then nei.nm_produto_nota_entrada else '+
    '  case when p.nm_produto is not null then p.nm_produto else l.nm_produto_especial_laudo end end as nm_produto, p.ds_produto, '+
    'p.nm_fantasia_produto, p.cd_mascara_produto, um.nm_unidade_medida, '+
    'cast(null as varchar) as nm_razao_social, cast(null as varchar) as cd_cnpj, '+
--    'cast(null as integer) as cd_nota_saida, '
    'case when ol.ic_laudo_entrada = ''S'' then 0 else isnull((select top 1 ni.cd_nota_saida from '+
    ' produto px 
      left outer join pedido_venda_item i on case when isnull(i.cd_produto_servico,0)>0 then i.cd_produto_servico else i.cd_produto end  = p.cd_produto
      left outer join nota_saida_item ni  on ni.cd_pedido_venda      = i.cd_pedido_venda      and
                                             ni.cd_item_pedido_venda = i.cd_item_pedido_venda
      where
        px.cd_produto = l.cd_produto ),0) end as cd_nota_saida, '+

    'case when ol.ic_laudo_entrada = ''S'' then 0 else isnull((select top 1 ns.cd_identificacao_nota_saida from '+
    ' produto px 
      left outer join pedido_venda_item i on case when isnull(i.cd_produto_servico,0)>0 then i.cd_produto_servico else i.cd_produto end  = p.cd_produto
      left outer join nota_saida_item ni  on ni.cd_pedido_venda      = i.cd_pedido_venda      and
                                             ni.cd_item_pedido_venda = i.cd_item_pedido_venda 
      left outer join nota_saida ns on ns.cd_nota_saida = ni.cd_nota_saida 
      where
        px.cd_produto = l.cd_produto ),0) end as cd_identificacao_nota_saida, '+

    'cast(null as integer) as cd_item_nota_saida, '+
    'cast(null as integer) as cd_nota_saida_item_lote, cast(null as varchar) as nm_status_nota, '+
    'isnull(po.nm_pais,op.nm_pais)       as nm_origem_produto, '+
    'pp.nm_procedencia_produto, c.nm_fantasia_cliente, '+
    'cast(fab.nm_razao_social as varchar(40)) as nm_fabricante_laudo, '+
    'isnull(lpq.cd_dcb_produto,pq.cd_dcb_produto) as cd_dcb_produto, '+
    'isnull(lpq.cd_dci_produto,pq.cd_dci_produto) as cd_dci_produto, '+
    'isnull(lpq.cd_cas_produto,pq.cd_cas_produto) as cd_cas_produto, '+
    'case when isnull(l.cd_pedido_venda,0)>0 then l.cd_pedido_venda else '+
    ' case when isnull(prod.cd_pedido_venda,0)>0 then prod.cd_pedido_venda else pci.cd_pedido_venda end end as cd_pedido_venda_laudo, '+
    'case when isnull(l.cd_item_pedido_venda,0)>0 then l.cd_item_pedido_venda else prod.cd_item_pedido_venda end as cd_item_pedido_venda_laudo, '+
    ' mi.nm_metodo_inspecao, i.nm_inspetor, nei.cd_pedido_compra,nei.cd_item_pedido_compra, nei.dt_item_receb_nota_entrad, '+
    ' p.cd_laudo_padrao, ne.cd_rem, lp.nm_laudo_padrao, nei.nm_produto_nota_entrada '+
   
    ' From '+
    ' Laudo l with(nolock) '+
    ' left outer join Origem_laudo ol on (l.cd_origem_laudo = ol.cd_origem_laudo) '+
    ' left outer join Fornecedor f on (l.cd_fornecedor = f.cd_fornecedor) '+
    ' left outer join Cliente c    on (l.cd_cliente    = c.cd_cliente )'+
    ' left outer join Tecnico t on (l.cd_tecnico = t.cd_tecnico) '+
    ' left outer join Produto p         on (l.cd_produto = p.cd_produto) '+
    ' left outer join Produto_Fiscal pf on (l.cd_produto = pf.cd_produto) '+ 
    ' LEFT OUTER JOIN Procedencia_Produto pp on (pf.cd_procedencia_produto = pp.cd_procedencia_produto) '+
    ' LEFT OUTER JOIN unidade_medida um on (l.cd_unidade_medida = um.cd_unidade_medida) '+
    ' left outer join Pais op on (op.cd_pais = p.cd_origem_produto) '+
    ' left outer join Pais po on po.cd_pais = l.cd_origem_produto '+
    ' left outer join Fabricante fab on fab.cd_fabricante = l.cd_fabricante '+
    ' left outer join Laudo_Produto_Quimico lpq on lpq.cd_laudo = l.cd_laudo '+
    ' left outer join Produto_Quimico pq on pq.cd_produto = p.cd_produto '+
    ' left outer join Processo_Producao prod on prod.cd_processo = l.cd_processo '+
    ' left outer join Metodo_Inspecao mi on mi.cd_metodo_inspecao = l.cd_metodo_inspecao '+
    ' left outer join Inspetor i on i.cd_inspetor = l.cd_inspetor       '+
    ' left outer join Nota_Entrada_Item nei on nei.cd_nota_entrada = l.cd_nota_entrada and nei.cd_item_nota_entrada = l.cd_item_nota_entrada and '+
    '                                         nei.cd_fornecedor   = l.cd_fornecedor '+
    ' left outer join Pedido_Compra_Item pci on pci.cd_pedido_compra = nei.cd_pedido_compra and pci.cd_item_pedido_compra = nei.cd_item_pedido_compra '+
    ' left outer join Nota_Entrada ne on ne.cd_nota_entrada = l.cd_nota_entrada and ne.cd_fornecedor = l.cd_fornecedor  '+
--                                                            ' and l.cd_operacao_fiscal = ne.cd_operacao_fiscal  '+
    ' left outer join Laudo_Padrao lp on lp.cd_laudo_padrao = p.cd_laudo_padrao '+
  ' where    ' 
--    +
--antes de 18.03.2009
--    ' l.dt_laudo between ' + '''' + cast(@dt_inicial  as varchar)+ '''' + ' and ' + '''' + cast(@dt_final as varchar)+ '''' + 'and '

--  select @filtro

--select * from nota_entrada_item

  set @filtro = @filtro + (case when @ic_parametro = 1	then
					'l.cd_laudo = '+cast(@cd_laudo as varchar)
				when @ic_parametro = 2	then
					'l.cd_nota_entrada = '+cast(@cd_nota_entrada as  varchar)
				when @ic_parametro = 3	then
					'f.nm_fantasia_fornecedor like ' +''''+ @nm_fantasia_fornecedor +'%'+''''
				when  @ic_parametro = 4	then
					'p.nm_fantasia_produto like ' +''''+ @nm_fantasia_produto +'%'+''''

				when  @ic_parametro = 7	then
					'l.cd_lote like ' +''''+ @cd_lote +'%'+''''
				when  @ic_parametro = 8	then
					'l.cd_lote_interno like ' +''''+ @cd_lote +'%'+''''
				else
                                    ' l.dt_laudo between ' + '''' + cast(@dt_inicial  as varchar)+ '''' + ' and ' + '''' + cast(@dt_final as varchar)+ '''' + ' and '
                                  + ' l.cd_laudo = l.cd_laudo'
    				end)

	set @filtro = @filtro + ' order by l.dt_laudo desc'

--  print @filtro

 	exec(@filtro)

end

