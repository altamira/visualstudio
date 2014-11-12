

----------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_valida_data_emissao_nota
----------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Fabio Cesar Magalhães
--Banco de Dados	: EGISSQL
--Objetivo		: Realizar a validação da data de emissão da nota fiscal.
--                        irá ser retornado 0 caso possa ser utilizada e 1 para não
--Data			: 02.06.2004
--Alteração		: 
--Desc. Alteração	: 22/06/2004 - Alterado devido ao não funcionamento quando
--                                     a empresa já trabalhou com séries diferentes.
--                      : 18.04.2006 - Colocado consistências novamente - Carlos Fernandes
----------------------------------------------------------------------------------------------

@dt_emissao           datetime, --1 liberados, 2 não liberados
@cd_nota_saida        int = 0,
@cd_serie_nota_fiscal int = 0

AS
begin

  --**********************************************************************************
  -- Nota Emitida com data anterior mas numeração superior
  --**********************************************************************************
  if exists ( Select 
                top 1 'x' 
              from 
                nota_saida with (nolock)
              where
                cd_serie_nota = @cd_serie_nota_fiscal
                and dt_nota_saida < @dt_emissao 
                and cd_identificacao_nota_saida > @cd_nota_saida )
    Select
      0 as Retorno
      --1 as Retorno
  --**********************************************************************************
  -- Nota Emitida com data superior mas numeração inferior
  --**********************************************************************************
  else if exists ( Select 
                     top 1 'x' 
                   from 
                     nota_saida with (nolock) 
                   where
                     cd_serie_nota = @cd_serie_nota_fiscal
                     and dt_nota_saida > @dt_emissao 
                     and cd_identificacao_nota_saida < @cd_nota_saida)
    Select
      0 as Retorno
      --1 as Retorno
  else
    Select
      1 as Retorno


-- select
--   @cd_serie_nota_fiscal,
--   @cd_nota_saida,
--   @dt_emissao
-- 
-- Select 
--   *
-- from 
--  nota_saida with (nolock) 
-- where
--   cd_serie_nota = @cd_serie_nota_fiscal
--   and dt_nota_saida > @dt_emissao 
--   and cd_identificacao_nota_saida < @cd_nota_saida


end

