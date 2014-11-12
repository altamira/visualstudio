
CREATE PROCEDURE pr_dados_fiscais_pedido_compra
@cd_pedido_compra int = 0,
@cd_cotacao       int = 0 --Caso informado o código da cotação
as
begin

  set nocount on

  declare @cd_item_pedido_compra            int,
          @cd_classificacao_fiscal          int,
          @cd_produto                       int,
          @cd_estado                        int,
          @pc_reducao_icms                  numeric(18,2),
          @cd_item_anterior                 int,
          @cd_classificacao_fiscal_anterior int


  --Define o Estado do Fornecedor
  if ( IsNull(@cd_cotacao,0) = 0 )
    --Define o estado do fornecedor
    Select top 1 
      @cd_estado = f.cd_estado
    from
      Pedido_Compra pc        with (nolock, index(PK_Pedido_Compra))  
      inner join Fornecedor f with (nolock, index(pk_fornecedor))
        on f.cd_fornecedor = pc.cd_fornecedor
    where
      pc.cd_pedido_compra = @cd_pedido_compra
  else
    --Define o estado do fornecedor
    Select top 1 
      @cd_estado = f.cd_estado
    from
      Cotacao c               with (nolock, index(PK_Cotacao))  
      inner join Fornecedor f with (nolock, index(pk_fornecedor))
        on f.cd_fornecedor = c.cd_fornecedor
    where
      c.cd_cotacao = @cd_cotacao

  --Define a origem dos itens  

  Select
    pci.cd_pedido_compra,
    pci.cd_item_pedido_compra,
    pci.cd_produto,
    pci.cd_classificacao_fiscal,
    pci.ic_pedido_compra_item
  into
    #Item
  from
    Pedido_Compra_Item pci with (nolock, index(PK_Pedido_Compra_Item))
  where
    ( IsNull(@cd_cotacao,0) = 0 ) and
    ( pci.cd_pedido_compra = @cd_pedido_compra ) and
    ( IsNull(ic_pedido_compra_item,'P') = 'P' )
  UNION
  Select
    ci.cd_cotacao      as cd_pedido_compra,
    ci.cd_item_cotacao as cd_item_pedido_compra,
    cd_produto,
    0                  as cd_classificacao_fiscal,
    'P'                as ic_pedido_compra_item
  from
    Cotacao_Item ci with (nolock, index(PK_Cotacao_Item))
  where
    ( IsNull(@cd_cotacao,0) > 0 ) and
    ( ci.cd_cotacao = @cd_cotacao )

  Select
    pci.cd_item_pedido_compra,
    pci.cd_produto,
    pci.cd_classificacao_fiscal,
    IsNull(p.ic_especial_produto,'N') as ic_especial_produto
  into
    #Produto
  from
    #Item pci
    inner join Produto p with (nolock, index(pk_produto))
      on p.cd_produto = pci.cd_produto

  --Tratamento para os produtos especiais, código "0"

  Select
    pci.cd_item_pedido_compra,
    pci.cd_classificacao_fiscal,
    cast(0 as decimal(25,2)) as pc_reducao_icms
  into
    #Classificacao
  from
    #Item pci
  where
    IsNull(ic_pedido_compra_item,'P') = 'P'
    and IsNull(cd_produto,0) = 0

  --Tratamento para os produtos especiais, código padrão
  Insert into #Classificacao
  Select
    cd_item_pedido_compra,
    cd_classificacao_fiscal,
    0.00 as pc_reducao_icms   
  from
    #Produto 
  where 
    ic_especial_produto = 'S'
  
  While exists(Select top 1 'x' from #Produto where ic_especial_produto = 'N')
  begin
    --Define o item do pedido de compra que será tratado  
    Select top 1 
      @cd_item_pedido_compra   = cd_item_pedido_compra,
      @cd_produto              = cd_produto,
      @cd_classificacao_fiscal = 0
    from 
      #Produto 
    where 
      ic_especial_produto = 'N'

    --Define a classificação fiscal
    Select 
      @cd_classificacao_fiscal = cd_classificacao_fiscal,
      @pc_reducao_icms         = IsNull(pc_reducao_icms,0)
    from 
      dbo.fn_imposto_produto_compra(@cd_produto,@cd_estado,0)

    Insert into #Classificacao
    ( cd_item_pedido_compra, cd_classificacao_fiscal, pc_reducao_icms )
    values (@cd_item_pedido_compra, IsNull(@cd_classificacao_fiscal,0),  @pc_reducao_icms)

    delete from #Produto
    where cd_item_pedido_compra = @cd_item_pedido_compra
      
  end

  --Organizar a informação
  Select
    cast('' as varchar(2000)) as nm_item,
    cd_classificacao_fiscal,
    max(pc_reducao_icms) as pc_reducao_icms
  into
    #Obs_Fiscal
  from
    #Classificacao
  group by
    cd_classificacao_fiscal

  Select top 1 
    @cd_item_anterior = 0,
    @cd_classificacao_fiscal_anterior = cd_classificacao_fiscal
  from 
    #Classificacao 
  order by
    cd_classificacao_fiscal
  
  While exists(Select top 1 'x' from #Classificacao)
  begin

    Select top 1 
      @cd_item_pedido_compra = cd_item_pedido_compra,
      @cd_classificacao_fiscal = cd_classificacao_fiscal,
      @cd_item_anterior = ( case 
                              when ( cd_classificacao_fiscal <> @cd_classificacao_fiscal_anterior ) then
                                0
                              else
                                @cd_item_anterior
                           end)
    from 
      #Classificacao 
    order by
      cd_classificacao_fiscal,
      cd_item_pedido_compra

    update #Obs_Fiscal
    set nm_item = 
        (
          case 
            when (@cd_item_anterior = 0) then
              nm_item + cast(@cd_item_pedido_compra as varchar)          
            when ( ( @cd_item_anterior + 1 ) = @cd_item_pedido_compra ) then
              case 
                --Caso exista um "-" remove o número anterior e o traço e adiciona o novo número
                when (substring(nm_item,charindex(cast(@cd_item_anterior as varchar),nm_item)-1,1) = '-' ) then
                  substring(nm_item,1,charindex(cast(@cd_item_anterior as varchar),nm_item)-2)
                  + + '-' + cast(@cd_item_pedido_compra as varchar)
                else --caso for o início da sequencia somente adiciona o traço e o novo número
                  nm_item + '-' + cast(@cd_item_pedido_compra as varchar)
              end
            else
              nm_item + ';' + cast(@cd_item_pedido_compra as varchar)
          end
         )
    where cd_classificacao_fiscal = @cd_classificacao_fiscal
    
    select 
      @cd_item_anterior = @cd_item_pedido_compra,
      @cd_classificacao_fiscal_anterior = @cd_classificacao_fiscal

    delete from #Classificacao where cd_item_pedido_compra = @cd_item_pedido_compra 

  end


  Select 
    o.nm_item,
    cf.cd_mascara_classificacao,
    o.pc_reducao_icms
  from 
    #Obs_Fiscal o 
    inner join Classificacao_Fiscal cf with (nolock)
      on cf.cd_classificacao_fiscal = o.cd_classificacao_fiscal
    order by nm_item

  set nocount off

end

