
-------------------------------------------------------------------------------
--pr_selecao_nota_etiqueta_item_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Emissão de Etiqueta para Item da Nota
--Data             : 
--Alteração        : 20.03.2007 - Geração conforme a Embalagem - Carlos Fernandes
--                 : 09.04.2007 - Top 1 para selecionar a etiqueta - Anderson Dino
-- 18.09.2008 - Acerto da Procedure - Carlos Fernandes
-- 11.12.2009 - Complemento de Campos - Carlos Fernands
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes
----------------------------------------------------------------------------------------------
create procedure pr_selecao_nota_etiqueta_item_nota
@ic_parametro       int      = 0,
@cd_nota_saida      int      = 0,
@cd_nota_saida_item int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@cd_etiqueta        int      = 0

as

declare @ic_tipo char(1)
declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

if @ic_parametro = 1 --Não Impressas
begin
  set @ic_tipo      = 'N'   
  set @ic_parametro = 0
end

if @ic_parametro = 2 --Reimpressão
begin
  set @ic_tipo      = 'S'
  set @ic_parametro = 0
end

if @ic_parametro = 0 --Nota Fiscal
begin

  --select * from nota_saida

  select
    0                                                       as Selecao,
--    ns.cd_nota_saida                                        as Nota,
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                                                     as Nota,

    ns.dt_nota_saida                                        as Emissao,
    ns.nm_fantasia_nota_saida                               as Destinatario,
    ns.vl_total                                             as Total,
    ns.cd_mascara_operacao                                  as CFOP,
    ns.nm_operacao_fiscal                                   as Operacao,
    u.nm_fantasia_usuario                                   as Usuario,
    '('+ns.cd_ddd_nota_saida+')-'+ns.cd_telefone_nota_saida as Telefone,
    ns.sg_estado_nota_saida,
    ns.nm_cidade_nota_saida,
    ns.qt_peso_liq_nota_saida,
    ns.qt_peso_bruto_nota_saida,
    ns.qt_volume_nota_saida           

--select * from nota_saida
    
  from
    Nota_Saida ns                           with (nolock) 
    left outer join egisadmin.dbo.Usuario u on u.cd_usuario = ns.cd_usuario
  where
    ns.cd_nota_saida = case when @cd_nota_saida=0 then ns.cd_nota_saida else @cd_nota_saida end and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.dt_cancel_nota_saida is null                    and --Somente as Nota não Canceladas
    isnull(ns.ic_etiqueta_nota_saida,'N') = @ic_tipo       --Etiquetas não impressas p/ Impressão ou Reimpressão

end

------------------------------------------------------------------------------------------
--Itens da Nota
------------------------------------------------------------------------------------------

if @ic_parametro = 3 --Item da Nota Fiscal
begin
  --select * from nota_saida_item
  --select * from produto
  --select * from lote_produto

  select
--    ns.cd_nota_saida                                         as Nota,
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                                                      as Nota,

    nsi.cd_item_nota_saida                                   as Item,
    nsi.nm_fantasia_produto                                  as Produto,
    nsi.nm_produto_item_nota                                 as DescricaoProduto,
    nsi.cd_mascara_produto                                   as CodigoProduto,
   
    --Soma da Capacidade da Embalagem
    isnull(te.qt_peso_tipo_embalagem,0) + 
    isnull(nsi.qt_item_nota_saida,0)                         as PesoBruto,
    isnull(nsi.qt_item_nota_saida,0)                         as PesoLiquido,
    --(nsi.qt_item_nota_saida * nsi.qt_bruto_item_nota_saida)  as PesoBruto,
    --(nsi.qt_item_nota_saida * nsi.qt_liquido_item_nota)      as PesoLiquido,
    ns.nm_fantasia_nota_saida                                as Destinatario,
    nsi.cd_pedido_venda                                      as PedidoVenda,
    nsi.cd_lote_item_nota_saida                              as LoteProduto,
    p.nm_marca_produto                                       as Marca,
    lp.dt_inicial_lote_produto                               as InicioValidade,
    lp.dt_final_lote_produto                                 as FinalValidade,
    Mensagem = 'Armazenar em lugar fresco e seco, protegido do calor e umidade.',
    isnull(te.qt_unidade_tipo_embalagem,0)                   as qt_capacidade,
    isnull(te.qt_peso_tipo_embalagem,0)                      as qt_peso_embalagem,

    case when isnull(te.qt_unidade_tipo_embalagem,0)>0 
    then
      --(nsi.qt_item_nota_saida * nsi.qt_bruto_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0)
      case
        when (nsi.qt_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0) > cast((nsi.qt_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0) as int ) then
          cast((nsi.qt_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0) as int ) +1
        else
          cast((nsi.qt_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0) as int )
      end 
    else
      1
     --nsi.qt_item_nota_saida
    end                                                     as qt_etiqueta,

    nsi.cd_pd_compra_item_nota                              as pedido_compra,
    ns.sg_estado_nota_saida                                 as estado,
    ns.nm_cidade_nota_saida                                 as cidade,
    ns.qt_volume_nota_saida                                 as volume,
    @dt_hoje                                                as dt_impressao,    
    nsi.cd_pedido_venda                                     as Pedido,
    nsi.cd_item_pedido_venda                                as ItemPedido,
    ns.nm_razao_social_nota                                 as Razao_Social

    --select * from tipo_embalagem

--select * from nota_saida
--select * from nota_saida_item 

  into
    #etiqueta

  from
    Nota_Saida ns                     with (nolock) 
    inner join Nota_Saida_Item nsi    with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
    left outer join Produto    p      with (nolock) on p.cd_produto      = nsi.cd_produto
    left outer join Lote_Produto lp   with (nolock) on lp.nm_ref_lote_produto = nsi.cd_lote_item_nota_saida
    left outer join Tipo_Embalagem te with (nolock) on te.cd_tipo_embalagem   = p.cd_tipo_embalagem

  where
    ns.cd_nota_saida       = case when @cd_nota_saida=0        then ns.cd_nota_saida       else @cd_nota_saida                        end and
    nsi.cd_item_nota_saida = case when @cd_nota_saida_item = 0 then nsi.cd_item_nota_saida else @cd_nota_saida_item end and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.dt_cancel_nota_saida is null                       --Somente as Nota não Canceladas

  select
    identity( int,1,1) as cd_etiqueta,
    * 
  into
    #etiquetaItens
  from 
    #etiqueta

  delete from #etiquetaItens

  declare @nota         int
  declare @item         int
  declare @i            int
  declare @qt_saldo     float
  declare @qt_embalagem float

  while exists ( select top 1 nota, item from #etiqueta )
  begin
    select top 1 
      @nota         = nota, 
      @item         = item, 
      @i            = qt_etiqueta, 
      @qt_saldo     = PesoLiquido,
      @qt_embalagem = qt_capacidade
    from 
      #etiqueta
    
    while @i > 0
    begin
       
      if @i > 1
      begin
        set @qt_saldo = @qt_saldo - @qt_embalagem
        
        insert into
          #etiquetaItens(
            Nota,
            Item,
            Produto,
            DescricaoProduto,
            CodigoProduto,
            PesoBruto,
            PesoLiquido,
            Destinatario,
            PedidoVenda,
            LoteProduto,
            Marca,
            InicioValidade,
            FinalValidade,
            Mensagem,
            qt_capacidade,
            qt_peso_embalagem,
            qt_etiqueta,
            pedido_compra,
            estado,
            cidade,
            volume,
            dt_impressao,
            Pedido,
            ItemPedido,
            Razao_Social
          )
        select
            Nota,
            Item,
            Produto,
            DescricaoProduto,
            CodigoProduto,
            (qt_capacidade + qt_peso_embalagem),
            qt_capacidade,
            Destinatario,
            PedidoVenda,
            LoteProduto,
            Marca,
            InicioValidade,
            FinalValidade,
            Mensagem,
            qt_capacidade,
            qt_peso_embalagem,
            qt_etiqueta,
            pedido_compra, 
            estado,
            cidade,
            volume,
            dt_impressao,
            Pedido,
            ItemPedido,
            Razao_Social


        from
          #etiqueta

        where
          nota = @nota and
          item = @item              

      end
      else
      begin

        insert into
          #etiquetaItens(
            Nota,
            Item,
            Produto,
            DescricaoProduto,
            CodigoProduto,
            PesoBruto,
            PesoLiquido,
            Destinatario,
            PedidoVenda,
            LoteProduto,
            Marca,
            InicioValidade,
            FinalValidade,
            Mensagem,
            qt_capacidade,
            qt_peso_embalagem,
            qt_etiqueta,
            pedido_compra, 
            estado,
            cidade,
            volume,
            dt_impressao,
            Pedido,
            ItemPedido,
            Razao_Social

          )
        select
            Nota,
            Item,
            Produto,
            DescricaoProduto,
            CodigoProduto,
            ( @qt_saldo + qt_peso_embalagem ),
            @qt_saldo,
            Destinatario,
            PedidoVenda,
            LoteProduto,
            Marca,
            InicioValidade,
            FinalValidade,
            Mensagem,
            qt_capacidade,
            qt_peso_embalagem,
            qt_etiqueta,
            pedido_compra, 
            estado,
            cidade,
            volume,
            dt_impressao,
            Pedido,
            ItemPedido,
            Razao_Social


        from
          #etiqueta

        where
          nota = @nota and
          item = @item              

      end
     
      set @i = @i-1

    end
    
    delete from #etiqueta where nota = @nota and item = @item

  end


  -- Não mudar a pesquisa do Peso liquido pois o peso é o filtro pois o
  -- cd_etiqueta é inviável - Anderson.

  if isnull(@cd_etiqueta,0) > 0
  begin
    select top 1
      *
    from
      #etiquetaitens
    where
      PesoLiquido = @cd_etiqueta
  end
  else
  begin
    select
      *
    from
      #etiquetaitens
  end
end

