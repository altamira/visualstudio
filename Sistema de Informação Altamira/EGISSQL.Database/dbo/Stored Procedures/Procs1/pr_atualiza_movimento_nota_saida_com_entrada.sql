
CREATE PROCEDURE pr_atualiza_movimento_nota_saida_com_entrada
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar
--Banco de Dados: Egissql
--Objetivo: Marca o movimento de saída antecedente ao movimento de entrada com o código do movimento de entrada
--Data: 19.02.2003
--Atualizado: 
---------------------------------------------------
@cd_nota_saida int,
@cd_item_nota_saida int,
@cd_movimento_estoque_entrada int,
@cd_produto int,
@cd_fase_produto int
as 
Begin
  
  declare @cd_movimento_estoque_saida int,         --Código do movimento de saída que antecedeu o movimento de entrada
          @cd_tipo_movimento_estoque int,          --Tipo do Movimento de saída
          @cd_tipo_movimento_estoque_ativacao int, --Tipo de Movimento para entrada por ativação
          @cd_tipo_documento_estoque int           --Tipo do documento deve ser nota de saída


  --Por definição saída é código 11
  set @cd_tipo_movimento_estoque = 11
  --Por definição ativação é código 13
  set @cd_tipo_movimento_estoque_ativacao = 13
  --Por definição o documento de nota fiscal é 4
  set @cd_tipo_documento_estoque = 4
  
  --Encontra o movimento de saída
  Select 
    top 1
    @cd_movimento_estoque_saida = cd_movimento_estoque
  From
    Movimento_Estoque
  where
    cd_tipo_movimento_estoque in (@cd_tipo_movimento_estoque, @cd_tipo_movimento_estoque_ativacao) and
    cd_documento_movimento = @cd_nota_saida and
    cd_item_documento = @cd_item_nota_saida and
    cd_tipo_documento_estoque = @cd_tipo_documento_estoque and
    cd_produto = @cd_produto and
    cd_fase_produto = @cd_fase_produto and
    cd_movimento_estoque < @cd_movimento_estoque_entrada
  order by 
    cd_movimento_estoque desc
     
  Update 
    Movimento_Estoque
  set 
    cd_movimento_saida_original = @cd_movimento_estoque_saida
  where
    cd_movimento_estoque = @cd_movimento_estoque_entrada
end
