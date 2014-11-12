

/****** Object:  Stored Procedure dbo.pr_etiqueta_embalagem    Script Date: 13/12/2002 15:08:29 ******/

CREATE procedure pr_etiqueta_embalagem

@ic_parametro     int, -- 1 = Pedido , 2 = Data de Programação / Reprogramação
@cd_pedido_venda  int,
@dt_inicial       datetime,
@dt_final         datetime,
@cd_empresa       int

as

  Select
    a.cd_cliente                as 'CodCliente',
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    a.qt_bruto_pedido_venda     as 'BrutoPedido', 
    a.qt_liquido_pedido_venda   as 'LiquidoPedido',
    TipoPedido = 
    Case when a.cd_tipo_pedido = 1 then 'PV' 
         when a.cd_tipo_pedido = 2 then 'PVE' 
    else Null end,
    b.ic_controle_pcp_pedido    as 'Pcp',
    Descricao =
    Case when a.cd_tipo_pedido = 1 then
      (Select max(nm_produto) from produto where cd_produto = b.CD_PRODUTO)
         when a.cd_tipo_pedido = 2 then  
      (Select max(nm_produto_pedido_venda) from pedido_venda_item_especial 
              where cd_pedido_venda = b.CD_PEDIDO_VENDA and
                    cd_item_pedido_venda = b.CD_ITEM_PEDIDO_VENDA)
    else Null end,
    MascaraProduto =
    Case when a.cd_tipo_pedido = 1 then
      (Select max(cd_mascara_produto) from produto where cd_produto = b.CD_PRODUTO)
         when a.cd_tipo_pedido = 2 then  
      (cast(b.cd_grupo_produto as char(2)) + '9999999')
    else Null end,
    Entrega = 
    case when (b.dt_reprog_item_pedido is not null) then b.dt_reprog_item_pedido
    else b.dt_entrega_fabrica_pedido end,
    b.cd_item_pedido_venda      as 'Item',
    b.qt_item_pedido_venda      as 'Qtde',
    b.qt_saldo_pedido_venda     as 'Saldo',
    b.qt_bruto_item_pedido      as 'BrutoItem', 
    b.qt_liquido_item_pedido    as 'LiquidoItem',
    c.nm_fantasia_cliente       as 'Cliente',
    Emitir =    
    case when (b.ic_etiqueta_emb_pedido = 'S') then 'N' else 'S' end

  into #TmpItensGeral

  From
    Pedido_Venda a

    Left Outer Join Pedido_Venda_Item b on
      a.cd_pedido_venda = b.cd_pedido_venda
    Left Outer Join Cliente c on
      a.cd_cliente = c.cd_cliente

  Where
   (a.cd_pedido_venda = @cd_pedido_venda or
    b.dt_entrega_fabrica_pedido between @dt_inicial and @dt_final or
    b.dt_reprog_item_pedido between @dt_inicial and @dt_final) and
    b.dt_cancelamento_item is null       and  
    a.ic_consignacao_pedido = 'N'        and
    b.cd_item_pedido_venda < 80          and
   (b.qt_item_pedido_venda *
    b.vl_unitario_item_pedido) > 0 

declare @razao    varchar(50)
declare @cgc      varchar(20)
declare @endereco varchar(50)
declare @cidade   varchar(30)
declare @uf       char(02)
declare @fone     varchar(15)
declare @fax      varchar(15)

select @razao    = a.nm_empresa,
       @endereco = a.nm_endereco_empresa,
       @cgc      = a.cd_cgc_empresa,
       @fone     = a.cd_telefone_empresa,
       @fax      = a.cd_fax_empresa,
       @cidade   = b.nm_cidade,
       @uf       = c.sg_estado  
from SapAdmin.Dbo.Empresa a, SapAdmin.Dbo.Cidade b, SapAdmin.Dbo.Estado c
where a.cd_empresa = @cd_empresa and
      a.cd_cidade = b.cd_cidade and
      b.cd_estado = c.cd_estado

--------------------------------------------------------------------------------------------
if @ic_parametro = 1
--------------------------------------------------------------------------------------------
begin
   select *,
          Polimold =
          case when Substring(MascaraProduto,7,1) < '4' then 'POLIMOLD EM AÇO 0' else
                                                             'POLIMOLD EM AÇO' end,
          @razao    as 'RazaoEmp',
          @endereco as 'EnderecoEmp',
          @cgc      as 'CgcEmp',
          @fone     as 'FoneEmp',
          @fax      as 'FaxEmp',
          @cidade   as 'CidadeEmp',
          @uf       as 'UfEmp'
   from #TmpItensGeral 
   where Pcp = 'S' and
         Pedido = @cd_pedido_venda
   order by Item
end
else
--------------------------------------------------------------------------------------------
if @ic_parametro = 2
--------------------------------------------------------------------------------------------
begin
   select *,
          Polimold =
          case when Substring(MascaraProduto,7,1) < '4' then 'POLIMOLD EM AÇO 0' else
                                                             'POLIMOLD EM AÇO' end,
          @razao    as 'RazaoEmp',
          @endereco as 'EnderecoEmp',
          @cgc      as 'CgcEmp',
          @fone     as 'FoneEmp',
          @fax      as 'FaxEmp',
          @cidade   as 'CidadeEmp',
          @uf       as 'UfEmp'
   from #TmpItensGeral 
   where Pcp = 'S' and
         Entrega between @dt_inicial and @dt_final
   order by Pedido, Item
end



