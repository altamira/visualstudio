
CREATE PROCEDURE pr_atualiza_minimo_maximo_produto
@cd_produto int,                   --Código do Produto
@cd_fase_produto int,              --Fase do Produto
@qt_minimo_produto float,          --Quantidade Mínima
@qt_maximo_produto float,          --Quantidade Máxima
@ic_controlar_montagem_pv int,     -- 1 = "S", 2 = "N" Realizar controle de montagem no cadastro de produto
@ic_fixo_estoque_minimo int        -- 1 = "S", 2 = "N" Realizar controle de montagem no cadastro de produto
as
begin

--Atualiza a tabela Produto_Saldo

  --Caso for uma alteração: Maioria dos casos
  if exists(Select 'x' from Produto_Saldo with (nolock) where cd_produto = @cd_produto
            and cd_fase_produto = @cd_fase_produto)
      update Produto_Saldo
      set
        qt_minimo_produto = @qt_minimo_produto,
        qt_maximo_produto = @qt_maximo_produto,
        ic_fixo_estoque_minimo = ( case @ic_fixo_estoque_minimo
                                     when 1 then 'S'
                                     else 'N'
                                   end )
    where
      cd_produto = @cd_produto and
      cd_fase_produto = @cd_fase_produto
  else 
    Insert into Produto_Saldo
      (cd_produto, cd_fase_produto, qt_minimo_produto, qt_maximo_produto, ic_fixo_estoque_minimo)
    values
      (@cd_produto, @cd_fase_produto, @qt_minimo_produto, @qt_maximo_produto, @ic_fixo_estoque_minimo)

  --Atualiza o produto
  update Produto
  set
    ic_controlar_montagem_pv = 
      ( case @ic_controlar_montagem_pv
          when 1 then 'S'
          else 'N'
        end )
  where
    cd_produto = @cd_produto

end
