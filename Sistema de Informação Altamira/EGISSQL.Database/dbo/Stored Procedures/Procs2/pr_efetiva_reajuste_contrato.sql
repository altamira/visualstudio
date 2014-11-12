
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--pr_efetiva_reajuste_contrato
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Efetivar Reajustes no Contrato anteriormente calculados.
--Data			: 12/04/2004
---------------------------------------------------

CREATE PROCEDURE pr_efetiva_reajuste_contrato

@cd_contrato_servico  int,
@cd_motivo_reajuste   int,
@cd_indice_reajuste   int,
@vl_valor_novo        float,
@cd_usuario           int

AS

  declare @cd_item_reajuste int
  declare @vl_valor_antigo float
  
  set @cd_item_reajuste = IsNull(( select cd_item_contrato_reajuste 
                            from Contrato_Servico_Reajuste
                            where cd_contrato_servico = @cd_contrato_servico ),0) + 1

  set @vl_valor_antigo = IsNull(( select vl_contrato_servico
                                  from Contrato_Servico
                                  where cd_contrato_servico = @cd_contrato_servico ),0)

  insert into Contrato_Servico_Reajuste
  ( cd_contrato_servico,
    dt_reajuste_contrato,
    cd_indice_reajuste,
    cd_motivo_reajuste,
    vl_reajuste_contrato,
    cd_usuario, 
    dt_usuario,
    cd_item_contrato_reajuste )
  values
   ( @cd_contrato_servico,
     GetDate(),
     @cd_indice_reajuste,
     @cd_motivo_reajuste,
     @vl_valor_antigo,
     @cd_usuario,
     GetDate(),
     @cd_item_reajuste )

  update Contrato_Servico
  set vl_contrato_servico = @vl_valor_novo
  where
    cd_contrato_servico = @cd_contrato_servico


