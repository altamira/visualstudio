
CREATE PROCEDURE pr_atualiza_preco_minimo_maximo_produto
@ic_parametro            int           = 0,
@cd_produto              int           = 0,                   --Código do Produto
@cd_tipo_faixa_preco     int           = 1,
@vl_minimo_produto       decimal(25,4) = 0.0000,
@vl_maximo_produto       decimal(25,4) = 0.0000,
@nm_obs_preco_produto    varchar(40)   = '' ,
@cd_usuario              int           = 0,
@pc_desconto_faixa_preco float         = 0,
@cd_moeda                int           = 1
as

-------------------------------------------------------------------------------------------------------------------
--Deleta o Registro
-------------------------------------------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  delete from produto_faixa_preco where cd_produto          = @cd_produto and
                                        cd_tipo_faixa_preco = @cd_tipo_faixa_preco

end

else

-------------------------------------------------------------------------------------------------------------------
--Inclusão/Alteração
-------------------------------------------------------------------------------------------------------------------
begin

  if not exists(Select top 1 cd_produto from Produto_Faixa_Preco with (nolock) 
            where cd_produto          = @cd_produto and
                  cd_tipo_faixa_preco = @cd_tipo_faixa_preco)
  begin
    insert into Produto_Faixa_Preco
    ( cd_produto, cd_tipo_faixa_preco )
    select
      @cd_produto,
      @cd_tipo_faixa_preco

  end

  update Produto_Faixa_Preco
  set
    vl_minimo_produto         = @vl_minimo_produto,
    vl_maximo_produto         = @vl_maximo_produto,
    nm_obs_preco_produto      = @nm_obs_preco_produto,
    cd_usuario                = @cd_usuario,
    dt_usuario                = getdate(),
    pc_desconto_faixa_preco   = @pc_desconto_faixa_preco,
    cd_moeda                  = @cd_moeda
  where 
    cd_produto          = @cd_produto and
    cd_tipo_faixa_preco = @cd_tipo_faixa_preco

end

