
CREATE PROCEDURE pr_exclusao_pedido
-------------------------------------------------------------------------------
--pr_exclusao_pedido
-------------------------------------------------------------------------------
-- GBS - Global Business Sollution  Ltda                                   2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Daniel C. Neto / Victor
--Banco de Dados          : EgisSql
--Objetivo                : Exclusão de Pedido de Venda de todas as tabelas
--                          relacionadas. 
--Data                    : 05/02/2003
--Atualizado              : 
--                        : 04.03.2004 - Inclusão de novo parametro para apagar duplicatas do 
--                                       pedido gerados automaticamente. Igor Gama.
--                        : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                        : 14.09.2007 - Exclusão da Programação de Entrega - Carlos Fernandes
-----------------------------------------------------------------------------------------------

@ic_parametro         integer = 0,
@cd_pedido            Integer = 0,
@ic_gera_parcela_auto char(1) = 'N'
AS

  if @ic_parametro = 1
     delete from Pedido_Venda_Agrupamento where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 2
    delete from Pedido_Venda_Composicao where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 3
    delete from Pedido_Venda_Cond_Pagto where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 4
    delete from Pedido_Venda_Historico where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 5
    delete from Pedido_Venda_Item_Acessorio where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 6
    delete from Pedido_Venda_Item_Desconto where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 7
    delete from Pedido_Venda_Item_Especial where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 8
    delete from Pedido_Venda_Item_Grade where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 9
    delete from Pedido_Venda_Item_Observacao where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 10
    delete from Pedido_Venda_Item_Desconto where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 11
    delete from Pedido_Venda_Parcela where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 12
    delete from Pedido_Venda_Programacao where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 13
    delete from Pedido_Venda_Smo where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 14
  begin
 
    declare @cd_codigo int

    declare cCursor cursor for

	    select 
        cd_processo 
	    from 
        Processo_Producao 
	    where 
        cd_pedido_venda = @cd_pedido

    open cCursor
    fetch next from cCursor into @cd_codigo

    while (@@FETCH_STATUS =0)
    begin

      delete 
        Processo_Producao_Composicao 
      where 
        cd_processo = @cd_codigo
 
      fetch next from cCursor into @cd_codigo
    end
    close cCursor
    deallocate cCursor

  end	
  else if @ic_parametro = 15
    delete from Processo_Producao where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 16
    delete from Pedido_Venda_Item where cd_pedido_venda = @cd_pedido

  else if @ic_parametro = 17
  begin

    delete
      Pedido_Venda 
    where 
      cd_pedido_venda = @cd_pedido

    --Atualizando todos os orçamentos que estava ligado a um pedido.

    update 
      Consulta_Itens
    set cd_pedido_venda      = Null,
        cd_item_pedido_venda = Null
    where 
      cd_pedido_venda = @cd_pedido

    --Atualizando a Programação de Entrega

    update
      Programacao_Entrega
    set
      cd_pedido_venda      = null,
      cd_item_pedido_venda = null
    where 
      cd_pedido_venda = @cd_pedido

  end

  else if @ic_parametro = 18
  begin
  
    --Apagando todos os movimentos de estoque gerados para aquele pedido.
		delete movimento_estoque
		where cd_tipo_documento_estoque = 7
		      and Str(cd_documento_movimento) = Str(@cd_pedido)

  end

  else if (@ic_parametro = 19) and (@ic_gera_parcela_auto = 'S')
  Begin
    --Apagando as duplicatas vinculadas ao pedido que gerar as mesmas automaticamente
    delete documento_receber
    where cd_pedido_Venda = @cd_pedido
  end

