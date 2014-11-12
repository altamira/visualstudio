

CREATE PROCEDURE pr_operacao_fiscal_nota_entrada
@ic_parametro int,
@cd_fornecedor int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1       -- Retorna uma lista com todas as CFOP p/ o Fornecedor
-------------------------------------------------------------------------------
  begin

    -- campos de pesquisa do fornecedor
    declare @cd_destinacao_produto int
    declare @cd_estado		   int
    declare @cd_pais               int

    -- campos de pesquisa do Estado
    declare @cd_digito_grupo       int

    select
      @cd_destinacao_produto = cd_destinacao_produto,
      @cd_estado             = cd_estado,
      @cd_pais               = cd_pais
    from
      Fornecedor
    where
      cd_fornecedor = @cd_fornecedor

    select
      @cd_digito_grupo = cd_digito_fiscal_entrada
    from 
      estado_parametro
    where 
      cd_pais = @cd_pais and      cd_estado = @cd_estado

    -- se não existir cadastro de destinação de produto do fornecedor
    -- trazer todas as possíveis
    if (isnull(@cd_destinacao_produto,0)=0)
      begin

        select
          dp.nm_destinacao_produto,
          op.cd_operacao_fiscal,
          op.cd_mascara_operacao,
          op.nm_operacao_fiscal,
          op.cd_tributacao
        from
          Operacao_Fiscal op
        left outer join
          Grupo_Operacao_Fiscal g
        on
          g.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
        left outer join
          Destinacao_Produto dp
        on
          dp.cd_destinacao_produto = op.cd_destinacao_produto
        where
          op.cd_tipo_destinatario = 1 and   -- Fornecedor
          g.cd_tipo_operacao_fiscal = 1 and -- Entradas
          g.cd_digito_grupo = @cd_digito_grupo
        order by
          op.cd_mascara_operacao
      
      end
    else
      begin

        select
          dp.nm_destinacao_produto,
          op.cd_operacao_fiscal,
          op.cd_mascara_operacao,
          op.nm_operacao_fiscal,
          op.cd_tributacao
        from
          Operacao_Fiscal op
        left outer join
          Grupo_Operacao_Fiscal g
        on
          g.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
        left outer join
          Destinacao_Produto dp
        on
          dp.cd_destinacao_produto = op.cd_destinacao_produto
        where
          op.cd_destinacao_produto = @cd_destinacao_produto and
          op.cd_tipo_destinatario = 1 and   -- Fornecedor
          g.cd_tipo_operacao_fiscal = 1 and -- Entradas
          g.cd_digito_grupo = @cd_digito_grupo
        order by
          op.cd_mascara_operacao

      end
  end
else
  return


