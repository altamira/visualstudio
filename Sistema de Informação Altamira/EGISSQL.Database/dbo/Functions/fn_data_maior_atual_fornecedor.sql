
create FUNCTION fn_data_maior_atual_fornecedor
  ( @dt_exportacao_registro datetime, @dt_Fornecedor datetime, @dt_Fornecedor_Endereco datetime, @dt_Fornecedor_Contato datetime, @dt_Estado datetime )
RETURNS datetime

--fn_data_maior_atual_fornecedor
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Alexandre Del Soldato
--Banco de Dados: EgisSql
--Objetivo: Verifica a maior data de Atualização da tabela de Fornecedores
--Data: 22/12/2003
-----------------------------------------------------------------------------------------

AS
BEGIN

  declare @dt_atual datetime

  if ( @dt_exportacao_registro is not null ) set @dt_atual = @dt_exportacao_registro

  if ( @dt_atual is null ) or ( @dt_Fornecedor > @dt_atual ) set @dt_atual = @dt_Fornecedor

  if ( @dt_atual is null ) or ( @dt_Fornecedor_Endereco > @dt_atual ) set @dt_atual = @dt_Fornecedor_Endereco

  if ( @dt_atual is null ) or ( @dt_Fornecedor_Contato > @dt_atual ) set @dt_atual = @dt_Fornecedor_Contato

  if ( @dt_atual is null ) or ( @dt_Estado > @dt_atual ) set @dt_atual = @dt_Estado

  return(@dt_atual)

end

