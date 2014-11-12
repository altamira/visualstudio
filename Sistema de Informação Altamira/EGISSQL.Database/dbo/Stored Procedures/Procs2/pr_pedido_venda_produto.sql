
CREATE   PROCEDURE pr_pedido_venda_produto
----------------------------------------------------------------------------------------------------------
--pr_pedido_venda_produto
----------------------------------------------------------------------------------------------------------
--GBS - Global Business Sollution Ltda                                                                2004
----------------------------------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server  2000
--Autor(es)              : Daniel C. Neto
--Banco de Dados         : SAPSQL
--Objetivo               : Listar todos os pedidos de vendas por
--                         produto no Período.
--Data                   : 01/04/2002
--Atualizado             : 24/02/2003 
-- Observaçao            : - Incluído Item da Nota de Saída.
--Atualização            : 27.03.2003 - Fabio - 
--                       : 09/12/2003 - Incluído valor total
--                                    - Daniel c. Neto.
--                       : 30/03/2004 - Acertos para bater com a Consulta de Pedido.
--                                    - Daniel C. Neto.
--                       : 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--                                    - Daniel C. Neto.
--                       : 15/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 04/03/2005 - Incluído filtro e coluna de data de entrega - Daniel C. Neto
--                       : 31/08/2005 - Relacionamento entre as tabelas Cliente - Cliente_Grupo e inserção do campo
--                                      nm_cliente_grupo
--                       : 27.11.2005 - Status do Pedido de Venda - Carlos Fernandes
--                       : 03.01.2006 - Verificação do preço de venda unitário/Outra Moeda - Diego Santiago
--                       : 30.01.2006 - Lote buscando do item da Nota Fiscal - Carlos Fernandes
--                       : 25.10.2006 - Area Produto = Márcio Rodrigues
--                       : 11.12.2006 - Itens de Exportação - Carlos Fernandes
--                       : 27.02.2007 - Ajuste da Descrição do Serviço - Carlos Fernandes
--                       : 28.02.2007 - Acrescentando Pais Origem, Pais Destini, exportador, Perc Geral, Perc Cliente - Anderson
--                                      Referente a custimizações para a mellon
--                       : 28.05.2007 - Categoria do Produto - Carlos Fernandes 
-- 02.04.2009 - Unidade de medida - Carlos Fernanes
-------------------------------------------------------------------------------------------------------------------
@cd_produto     varchar(40),
@dt_inicial     datetime,
@dt_final       datetime,
@cd_moeda       int = 1,
@consignacao    char(1) = 'S',
@nt_cancelados  char(1) = 'N',
@ic_tipo_filtro int     = 0, -- Filtrar por data de emissão ou por data de entrega ( 1)
@ic_exportacao  char(1) = 'S',
@ic_mostar_perc char(1) = 'N'
AS

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

select distinct
  identity( int, 1, 1 )         as cd_posicao,
  cf.cd_mascara_classificacao   as 'Classificação Fiscal',
  cf.pc_ipi_classificacao       as 'IPI',
  CAST(dt_cancelamento_item AS VARCHAR(18))AS 'dt_cancelamento_item',
  ped.ic_consignacao_pedido,
  pit.cd_produto,
  pit.nm_fantasia_produto       as 'Produto',

  case when isnull(pit.cd_servico,0)>0 then
       case when cast(pit.ds_produto_pedido_venda as varchar(50))=''
            then cast(s.nm_servico as varchar(50))
            else cast(pit.ds_produto_pedido_venda as varchar(50))
       end
  else   
       pit.nm_produto_pedido 
  end                           as 'Descricao',

  case when isnull(pit.cd_lote_item_pedido,'')<>'' 
       then pit.cd_lote_item_pedido
       else   
           (Select top 1 isnull(x.cd_lote_item_nota_saida,'')
              from Nota_Saida_Item x 
                   Left Outer Join Nota_Saida nfs on x.cd_nota_saida = nfs.cd_nota_saida 
              where x.cd_pedido_venda = pit.cd_pedido_venda and
                    x.cd_item_pedido_venda = pit.cd_item_pedido_venda and
                   (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
                   and x.cd_status_nota not in (7,4) )
  end                           as 'Lote',

  cli.cd_cliente,
  cli.nm_fantasia_cliente       as 'Cliente',
  ped.cd_vendedor,
 (Select top 1 nm_fantasia_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
  ped.cd_vendedor_interno,
 (Select top 1 nm_fantasia_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',

  pit.dt_item_pedido_venda     as 'Emissao',
  ped.cd_pedido_venda          as 'Pedido',
  pit.cd_item_pedido_venda     as 'Item',
  pit.qt_item_pedido_venda     as 'Qtd',
  pit.qt_saldo_pedido_venda    as 'Saldo', 
  pit.pc_desconto_item_pedido  as 'PCDescto',
  pit.vl_lista_item_pedido     as 'PrecoLista',
  --(pit.vl_unitario_item_pedido / @vl_moeda) as 'Preco_Venda',
  pit.vl_unitario_item_pedido  as 'Preco_Venda',

  --Trazer as quantidades da última nota impressa para o pedido
  (Select top 1 nfs.cd_nota_saida
   from Nota_Saida_Item x Left Outer Join
        Nota_Saida nfs on x.cd_nota_saida = nfs.cd_nota_saida
   where x.cd_pedido_venda = pit.cd_pedido_venda and
         x.cd_item_pedido_venda = pit.cd_item_pedido_venda and
         (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
         and x.cd_status_nota not in (7,4) 
   order by nfs.dt_nota_saida desc) as 'Nota',
	
  --Trazer as quantidades devolvidas das nota impressa para o pedido
  (Select top 1 x.cd_item_nota_saida 
   from Nota_Saida_Item x Left Outer Join
        Nota_Saida nfs on x.cd_nota_saida = nfs.cd_nota_saida
   where x.cd_pedido_venda = pit.cd_pedido_venda and
         x.cd_item_pedido_venda = pit.cd_item_pedido_venda and
         (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
         and x.cd_status_nota not in (7,4) )   as 'Item_Nota',

  --Trazer o total de quantidades da última nota impressa para o pedido
  (Select top 1 nfs.dt_nota_saida
   from Nota_Saida_Item x Left Outer Join
        Nota_Saida nfs on x.cd_nota_saida = nfs.cd_nota_saida 
   where x.cd_pedido_venda = pit.cd_pedido_venda and
         x.cd_item_pedido_venda = pit.cd_item_pedido_venda and
         (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
         and x.cd_status_nota not in (7,4) )    as 'EmissaoNota',

  case 
    when(pit.dt_cancelamento_item is null) then  
        (pit.qt_item_pedido_venda * pit.vl_unitario_item_pedido) 
    --cast(pit.qt_item_pedido_venda*(pit.vl_unitario_item_pedido / @vl_moeda) as decimal(25,2)) 
    else 
      0 
  end as 'Total',
  dt_entrega_vendas_pedido,
  cg.nm_cliente_grupo, 
  IsNull(pit.vl_unitario_item_pedido,0) / ( case when IsNull((pit.vl_moeda_cotacao),1) = 0 then
   	   1 else IsNull((pit.vl_moeda_cotacao),1) end ) as 'Outra_Moeda',
  sp.sg_status_pedido,
  pit.qt_area_produto,
  isnull(pit.qt_item_pedido_venda,0) * isnull( pit.qt_area_produto,0) as qt_total_area,
  dbo.fn_ultima_ordem_producao_item_pedido(pit.cd_pedido_venda, pit.cd_item_pedido_venda) as cd_processo,
  po.nm_pais                            as nm_origem_pais,
  pd.nm_pais                            as nm_destino_pais,
  ex.nm_fantasia                        as nm_fantasia_exportador,
  cast(0 as float)                      as vl_perc_cliente,
  case when isnull(pit.cd_servico,0)>0 then
    isnull(cps.nm_categoria_produto,cpg.nm_categoria_produto) 
  else
    case when isnull(pit.cd_produto,0)>0 then
      isnull(cp.nm_categoria_produto,cpg.nm_categoria_produto)
    else
       cp.nm_categoria_produto end
  end                                   as nm_categoria_produto,

  um.sg_unidade_medida

into
  #Pedido_Venda_Item_Tmp

from
  Pedido_Venda_Item pit with (nolock) 
  Left Outer join Pedido_Venda ped with (nolock) on  ped.cd_pedido_venda = pit.cd_pedido_venda
  left outer join Produto p        with (nolock) on  p.cd_produto = pit.cd_produto
  left outer join Servico s        with (nolock) on  s.cd_servico = pit.cd_servico
  inner join
   (Select y.cd_cliente,
           y.cd_cliente_grupo,
           y.nm_fantasia_cliente
    from 
      Cliente y 
      left outer join Tipo_Mercado u on y.cd_tipo_mercado = u.cd_tipo_mercado
    Where IsNull(u.ic_exportacao_tipo_mercado,'N') = (case IsNull(@ic_exportacao,'N')
                                                      when 'N' then
                                                        IsNull(@ic_exportacao,'N')
                                                      else
                                                        isnull(u.ic_exportacao_tipo_mercado,'N')
                                                      end)) cli 
  on cli.cd_cliente = ped.cd_cliente
  left outer join Nota_Saida_Item nsi with (nolock) on nsi.cd_pedido_venda = pit.cd_pedido_venda and 
                                         nsi.cd_item_pedido_venda = pit.cd_item_pedido_venda and
                                        (IsNull(nsi.qt_item_nota_saida,0) > IsNull(nsi.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
                                        (nsi.cd_status_nota not in (7,4)) --Desconsidera as notas canceladas ou totalmente devolvidas 

  left outer join Nota_Saida ns               with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
  left outer join produto_fiscal pf           with (nolock) on pf.cd_produto = p.cd_produto
  left outer join Classificacao_fiscal cf     with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  left outer join cliente_grupo cg            with (nolock) on cli.cd_cliente_grupo       = cg.cd_cliente_grupo
  left outer join status_pedido sp            with (nolock) on sp.cd_status_pedido        = ped.cd_status_pedido
  left outer join pedido_venda_exportacao pve with (nolock) on pve.cd_pedido_venda        = pit.cd_pedido_venda
  left outer join Pais po                     with (nolock) on po.cd_pais                 = pve.cd_origem_pais
  left outer join Pais pd                     with (nolock) on pd.cd_pais                 = pve.cd_destino_pais
  left outer join Exportador ex               with (nolock) on ex.cd_exportador           = ped.cd_exportador
  left outer join Grupo_produto gp            with (nolock) on gp.cd_grupo_produto        = pit.cd_grupo_produto
  left outer join Categoria_Produto cp        with (nolock) on cp.cd_categoria_produto    = p.cd_categoria_produto
  left outer join Categoria_Produto cpg       with (nolock) on cpg.cd_categoria_produto   = gp.cd_categoria_produto
  left outer join Categoria_Produto cps       with (nolock) on cps.cd_categoria_produto   = s.cd_categoria_produto
  left outer join Unidade_Medida um           with (nolock) on um.cd_unidade_medida       = pit.cd_unidade_medida
where 
  (case 
     when @ic_tipo_filtro = 0 then
       ped.dt_pedido_venda
     else 
       pit.dt_entrega_vendas_pedido 
   end ) between @dt_inicial and @dt_final and
  (case 
     when @nt_cancelados = 'S' then 
       ''
     else
       ISNULL(CAST(dt_cancelamento_item AS VARCHAR(18)),'') 
   end ) = ISNULL(CAST(dt_cancelamento_item AS VARCHAR(18)),'') 
  and

  ------------------------------------------------------
  
  (case 
     when @consignacao = 'S' then --mostra consignados
       'N'     
     else -- mostra nao consignados
       isnull(ped.ic_consignacao_pedido,'N') 
   end) = isnull(ped.ic_consignacao_pedido,'N')
  
  and
  ------------------------------------------------------

  IsNull(pit.nm_Fantasia_produto,'') like isnull(@cd_produto,'') + '%'

if @ic_mostar_perc = 'N'
begin
  select 
    *, 
    cast(0 as float) as vl_perc_geral
  from 
    #Pedido_Venda_Item_Tmp
  order by 
    Produto, 
    Emissao desc, 
    Pedido, 
    Item
end
else
begin

  declare @vl_total_cliente as float
  declare @cd_posicao       as int
  declare @cd_cliente       as int
  declare @cd_cliente_dif   as int
  declare @total            as float

  DECLARE pvi_cursor CURSOR FOR
  select 
    cd_posicao, 
    cd_cliente, 
    total
  from 
    #Pedido_Venda_Item_Tmp
  order by 
    Cliente,
    Produto, 
    Emissao desc, 
    Pedido, 
    Item

  OPEN pvi_cursor

  FETCH NEXT FROM pvi_cursor
  INTO @cd_posicao, @cd_cliente, @total

  set @cd_cliente_dif = @cd_cliente 
  select @vl_total_cliente = sum(Total) from #Pedido_Venda_Item_Tmp where cd_cliente = @cd_cliente_dif

  WHILE @@FETCH_STATUS = 0
  BEGIN
    if isnull(@vl_total_cliente,0) = 0
    begin
       set @vl_total_cliente = 1
    end

    update #Pedido_Venda_Item_Tmp set vl_perc_cliente = (( @Total / @vl_total_cliente ) * 100 )
    where cd_posicao = @cd_posicao 
    
    FETCH NEXT FROM pvi_cursor
    INTO @cd_posicao, @cd_cliente, @total

    if @cd_cliente_dif <> @cd_cliente 
    begin
      set @cd_cliente_dif = @cd_cliente
      select @vl_total_cliente = sum(Total) from #Pedido_Venda_Item_Tmp where cd_cliente = @cd_cliente_dif
    end
  END

  CLOSE pvi_cursor
  DEALLOCATE pvi_cursor

  -- Gerando Percentual Geral
  declare @vl_total_geral   as float
  
  select @vl_total_geral = sum(Total) from #Pedido_Venda_Item_Tmp

  select 
    *,
    (( Total / @vl_total_geral ) * 100 ) as vl_perc_geral
  from 
    #Pedido_Venda_Item_Tmp
  order by 
    Cliente,
    Produto, 
    Emissao desc, 
    Pedido, 
    Item
end

--print @cd_produto

