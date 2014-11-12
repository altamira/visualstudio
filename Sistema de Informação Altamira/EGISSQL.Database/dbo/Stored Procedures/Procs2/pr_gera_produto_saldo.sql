
create procedure pr_gera_produto_saldo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Geração da Tabela Produto_Saldo de acordo com todas as fases
--                 : da empresa da Tabela : Fase_Produto 
--                 : Zerando os Saldos de Produto
--Data             : 21.02.2003
--Atualizado       : 24.02.2003 - Igor Gama -- Modificação para cursor
--                 : 
-----------------------------------------------------------------------------------
as

  --Monta Tabela Auxiliar de Fase de Produto

  declare @cd_produto      int,
          @cd_fase_produto int

begin tran

  delete from produto_saldo
  --Inicio do Cursor para gerar o registro na tabela produto_saldo de todas as fases cadastradas
  declare cCursor cursor for

	  select cd_fase_produto
	  from
	     Fase_Produto

  open cCursor
  fetch next from cCursor into @cd_fase_produto

  while (@@FETCH_STATUS =0)
  begin


    -- Busca o próximo produto para atualizar
    declare cProduto cursor for
	    select cd_produto 
	    from Produto
 
    open cProduto
    fetch next from cProduto into @cd_produto

    while (@@FETCH_STATUS =0)
    begin


      --Insere novo Registro na Tabela Produto Saldo
      Insert Produto_Saldo (
        cd_produto,
        cd_fase_produto ) values (
        @cd_produto,
        @cd_fase_produto )

      fetch next from cProduto into @cd_produto
    end
    close cProduto
    deallocate cProduto

    fetch next from cCursor into @cd_fase_produto
  end
  close cCursor
  deallocate cCursor


if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Atualização da Tabela Produto Saldo, não processado !',16,1)
     rollback tran
   end

