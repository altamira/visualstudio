
create FUNCTION fn_data_maior_atual
  ( @dt_exportacao_registro datetime, @dt_Produto datetime, @dt_produto_fiscal datetime, @dt_Grupo_Produto datetime, @dt_Unidade_Medida datetime, @dt_Produto_Compra datetime,
   @dt_tributacao datetime, @dt_tributacao_icms datetime, @dt_procedencia_produto datetime, @dt_classificacao_fiscal datetime )
RETURNS datetime


--fn_data_maior_atual
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Alexandre Del Soldato
--Banco de Dados: EgisSql
--Objetivo: Verifica a maior data de Atualização da tabela de Produtos
--Data             : 18/12/2003
--Histórico        : 19/03/2004 - Retirada da Data do Produto_Saldo da função
-----------------------------------------------------------------------------------------

AS
BEGIN

  declare @dt_atual datetime

  if ( @dt_exportacao_registro is not null ) set @dt_atual = @dt_exportacao_registro

  if ( @dt_atual is null ) or ( @dt_Produto > @dt_atual ) set @dt_atual = @dt_Produto

  if ( @dt_atual is null ) or ( @dt_produto_fiscal > @dt_atual ) set @dt_atual = @dt_produto_fiscal

  if ( @dt_atual is null ) or ( @dt_Grupo_Produto > @dt_atual ) set @dt_atual = @dt_Grupo_Produto

  if ( @dt_atual is null ) or ( @dt_Unidade_Medida > @dt_atual ) set @dt_atual = @dt_Unidade_Medida

  if ( @dt_atual is null ) or ( @dt_Produto_Compra > @dt_atual ) set @dt_atual = @dt_Produto_Compra

  if ( @dt_atual is null ) or ( @dt_tributacao > @dt_atual ) set @dt_atual = @dt_tributacao

  if ( @dt_atual is null ) or ( @dt_tributacao_icms > @dt_atual ) set @dt_atual = @dt_tributacao_icms

  if ( @dt_atual is null ) or ( @dt_procedencia_produto > @dt_atual ) set @dt_atual = @dt_procedencia_produto

  if ( @dt_atual is null ) or ( @dt_classificacao_fiscal > @dt_atual ) set @dt_atual = @dt_classificacao_fiscal

  return(@dt_atual)

end

