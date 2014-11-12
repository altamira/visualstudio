
create procedure pr_gera_produto_fechamento
as

  --Monta Tabela Auxiliar de Fase de Produto

  select cd_fase_produto
  into #Fase
  from
     Fase_Produto

  declare @cd_produto      int
  declare @cd_fase_produto int

  set @cd_fase_produto = 0
  set @cd_produto      = 0

begin tran

  delete from produto_fechamento

  while exists ( select top 1 * from #Fase )
  begin

    --Seleciona a Fase da Tabela para atualização

    select top 1
      @cd_fase_produto = cd_fase_produto
    from
      #Fase

    -- Monta Tabela Auxiliar de Produto

    select cd_produto 
    into #Produto    
    from
         Produto

    -- Seleciona o Produto
 
    while exists ( select top 1 * from #Produto )
    begin

      -- Seleciona o Produto

      select 
        top 1
        @cd_produto = cd_produto
      from
        #Produto

      --Insere novo Registro na Tabela Produto Saldo

      Insert Produto_Fechamento (
        cd_produto,
        cd_fase_produto ) values (
        @cd_produto,
        @cd_fase_produto )

       --deleta Produto

       delete from #Produto where cd_produto = @cd_produto

    end

    drop table #produto
        
    delete 
      from #fase
    where
      cd_fase_produto = @cd_fase_produto

  end

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Atualização da Tabela Produto Saldo, não processado !',16,1)
     rollback tran
   end

