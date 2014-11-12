
create procedure pr_exclusao_cotacao_compra

@cd_requisicao_compra int

as

declare @Cotacao int
declare @Item_Cotacao int
declare @Requisicao int
declare @Historico int

/* Consulta pedido de compra à partir da requisição passada como parâmetro */

if not exists(select cd_requisicao_compra 
              from pedido_compra_item
              where cd_requisicao_compra = @cd_requisicao_compra 
              and dt_item_canc_ped_compra is null)
  begin
    
    declare cCotacaoCompra cursor for
    
    /* Consulta cotação à partir da requisicao */ 
    
    select ct.cd_cotacao as Cotacao,
           ci.cd_item_cotacao as Item_Cotacao, 
           ci.cd_requisicao_compra as Requisicao, 
           hi.cd_historico_compra as Historico
      from cotacao ct 
      left outer join cotacao_item ci 
        on ct.cd_cotacao = ci.cd_cotacao
      left outer join historico_compra_produto hi 
        on ci.cd_requisicao_compra = hi.cd_requisicao_compra
      where ci.cd_requisicao_compra = @cd_requisicao_compra
    
    open cCotacaoCompra

    fetch next from cCotacaoCompra 
               into @Cotacao, @Item_Cotacao, @Requisicao, @Historico

    while @@fetch_status = 0
      begin
        
        delete from cotacao where cd_cotacao = @Cotacao
        delete from cotacao_item where cd_cotacao = @Cotacao
        delete from historico_compra_produto where cd_historico_compra = @Historico
        
        fetch next from cCotacaoCompra 
                   into @Cotacao, @Item_Cotacao, @Requisicao, @Historico

      end

    close cCotacaoCompra
    deallocate cCotacaoCompra 

  end
