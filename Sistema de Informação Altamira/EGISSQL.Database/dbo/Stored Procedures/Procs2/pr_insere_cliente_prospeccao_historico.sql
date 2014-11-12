
CREATE PROCEDURE pr_insere_cliente_prospeccao_historico

--------------------------------------------------------------------------
--pr_insere_cliente_prospeccao_historico
--------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda     	                      2004
--------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)		     : Rodolpho
--Banco de Dados	 : EGISSQL
--Objetivo		     : Consultar Classificação do Fornecedor 
--Data		   	     : 01/09/2004
--                 : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--Atualização      : 11/01/2005 - Inserido o parâmetro @ds_historico_lancamento - Psantos 
--                   10/03/2005 - Paulo Souza
--                                Gravar Prospeccao.ds_prospeccao em Cliente_prospeccao_historio.ds_historico_lancamento
----------------------------------------------------------------------------
@cd_cliente_prospeccao   int,
@Sequencia							 int ,
@dt_historico_lancamento DateTime ,
@cd_vendedor 		         int ,
@dt_historico_retorno 	 DateTime

AS

declare @ds_historico_lancamento varchar(8000)

--select @ds_historico_lancamento = nm_obs_prospeccao 
select @ds_historico_lancamento = ds_prospeccao 
  from prospeccao 
 where cd_cliente_prospeccao = @cd_cliente_prospeccao 
   and dt_prospeccao = @dt_historico_lancamento

Insert into Cliente_prospeccao_historico
		(cd_cliente_prospeccao, 
		 cd_sequecia_historico, 
		 dt_historico_lancamento, 
		 cd_vendedor, 
		 dt_historico_retorno,
     ds_historico_lancamento)
Values 
		(@cd_cliente_prospeccao ,
  	 @Sequencia,
		 @dt_historico_lancamento,
		 @cd_vendedor,
		 @dt_historico_retorno,
     @ds_historico_lancamento)
