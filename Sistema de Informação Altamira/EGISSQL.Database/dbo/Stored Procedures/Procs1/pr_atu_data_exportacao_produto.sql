
CREATE PROCEDURE pr_atu_data_exportacao_produto
---------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Alexandre Del Soldato
--Banco de Dados  : EGISSQL
--Objetivo        : Atualizar a Data de Exportação de Registro na tabela Produto
--Data            : 17/12/2003
--Atualizado      : 
--------------------------------------------------------------------
@cd_produto	int

AS

  SET DATEFORMAT mdy

  print convert(varchar(10), getdate(), 101)

  -- Atualizar a Data de Exportação de Registro na tabela Produto
  update
    Produto
  set
    dt_exportacao_registro = cast( convert(varchar(10), getdate(), 101) as datetime )
  where
    cd_produto = @cd_produto


