
CREATE PROCEDURE pr_orcamento_furo_bucha_adicional

@cd_serie_produto      int,
@cd_tipo_serie_produto int,
@cd_montagem           int,
@cd_tipo_montagem      int,
@ic_montagem_g         char(1), 
@cd_placa              int

as

  -- Buscar nro. de furos adicionais e buchas

  Select cd_placa,
         sum(qt_furo_adic_serie_prod)  as qt_furo_adicional,
         sum(qt_bucha_adic_serie_prod) as qt_bucha_adicional
  -------
  from Serie_Produto_Furo_Adicional
  -------
  where cd_serie_produto = @cd_serie_produto and
        cd_tipo_serie_produto   <= @cd_tipo_serie_produto and
        cd_placa         = @cd_placa and
        cd_montagem             <= @cd_montagem and
        cd_tipo_montagem        <= @cd_tipo_montagem and
        ic_montagem_g_furo_adic <= @ic_montagem_g 

  group by cd_serie_produto,
           cd_tipo_serie_produto,
           cd_placa

