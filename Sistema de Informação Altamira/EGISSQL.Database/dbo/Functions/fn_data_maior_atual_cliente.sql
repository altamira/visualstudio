
create FUNCTION fn_data_maior_atual_cliente
  ( @dt_exportacao_registro datetime, @dt_Cliente datetime, @dt_Cliente_Endereco datetime, @dt_Cliente_Contato datetime, @dt_Cliente_Informacao_Credito datetime, @dt_Estado datetime )
RETURNS datetime


--fn_data_maior_atual_cliente
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Alexandre Del Soldato
--Banco de Dados: EgisSql
--Objetivo: Verifica a maior data de Atualização da tabela de Cliente
--Data: 22/12/2003
-----------------------------------------------------------------------------------------

AS
BEGIN

  declare @dt_atual datetime

  if ( @dt_exportacao_registro is not null ) set @dt_atual = @dt_exportacao_registro

  if ( @dt_atual is null ) or ( @dt_Cliente > @dt_atual ) set @dt_atual = @dt_Cliente

  if ( @dt_atual is null ) or ( @dt_Cliente_Endereco > @dt_atual ) set @dt_atual = @dt_Cliente_Endereco

  if ( @dt_atual is null ) or ( @dt_Cliente_Contato > @dt_atual ) set @dt_atual = @dt_Cliente_Contato

  if ( @dt_atual is null ) or ( @dt_Cliente_Informacao_Credito > @dt_atual ) set @dt_atual = @dt_Cliente_Informacao_Credito

  if ( @dt_atual is null ) or ( @dt_Estado > @dt_atual ) set @dt_atual = @dt_Estado

  return(@dt_atual)

end

