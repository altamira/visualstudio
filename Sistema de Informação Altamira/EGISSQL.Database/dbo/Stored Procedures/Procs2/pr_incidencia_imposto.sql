


CREATE  PROCEDURE pr_incidencia_imposto
@cd_tributacao int

as

  declare @IncideICMS char(1)
  declare @IncideIPI  char(1)

  -- ICMS

  select 
    @IncideICMS = ic_evento_tributacao
  from
    Composicao_Tributacao
  where
    cd_tributacao        = @cd_tributacao and
    cd_imposto           = 1              and --ICMS
    cd_evento_tributacao = 1                  -- Cálculo

  -- IPI

  select
    @IncideIPI = ic_evento_tributacao
  from
    Composicao_Tributacao
  where
    cd_tributacao        = @cd_tributacao and
    cd_imposto           = 2              and --IPI
    cd_evento_tributacao = 1                  -- Cálculo
 
  select
    isnull(@IncideICMS,'N') as 'ICMS',
    isnull(@IncideIPI,'N')  as 'IPI'
  



