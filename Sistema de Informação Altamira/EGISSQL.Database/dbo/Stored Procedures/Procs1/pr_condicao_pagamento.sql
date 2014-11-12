
CREATE PROCEDURE pr_condicao_pagamento
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Fábio César Magalhães
--Banco de Dados   : EGISSQL
--Objetivo         : Apresentar de forma centralizada as regras para apresentação das condições de pagamento
--Data             : 25.07.2006
--                 : 03.09.2007
--                 : 05.09.2007 - Inclusão de Novo Campo para Pagamento Antecipado - Carlos Fernandes
-- 30.09.2008 - Ajuste diversos - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------

@cd_tipo_mercado  int = 1,
@ic_tipo_consulta char(1) = 'V' --V -Vendas / C - Compras

as
begin

  --Filtragem para os casos de Vendas
  Select 
    cd_condicao_pagamento, 
    rtrim(ltrim(nm_condicao_pagamento))         as nm_condicao_pagamento,
    --rtrim(ltrim(nm_condicao_pagamento))
    -- + ' - No. Pac. ' + 
    --cast(qt_parcela_condicao_pgto as varchar) as nm_condicao_pagamento,
    isnull(qt_parcela_condicao_pgto,0)          as qt_parcela_condicao_pgto,
    isnull(ic_padrao_cond_pagamento,'N')        as ic_padrao_cond_pagamento,
    isnull(ic_antecipado,'N')                   as ic_antecipado 
  From 
    Condicao_Pagamento with(nolock)
  where 
    ( @ic_tipo_consulta = 'V' )
    and
    ( 
      --Vendas *****
      --Mercado Nacional
      ( (     ( isNull(ic_ativo,'S') = 'S' )
          and ( @cd_tipo_mercado <= 1 )
        ) or
      --Mercado Internacional
        --(     ( isNull(ic_importacao_cond_pagto,'S') = 'S' ) and
        (
          ( @cd_tipo_mercado > 1 )
        )
      )
      and 
      (  ( IsNull(ic_tipo_cond_pagamento,'V')    = 'V' )
         or ( IsNull(ic_tipo_cond_pagamento,'V') = 'A' )
         or ( IsNull(ic_tipo_cond_pagamento,'V') = 'T' ) 
  	)	
    )
  UNION ALL
  --Filtragem para os casos de Compras

  Select 
    cd_condicao_pagamento, 
    rtrim(ltrim(nm_condicao_pagamento))         as nm_condicao_pagamento,
    --rtrim(ltrim(nm_condicao_pagamento))
    -- + ' - No. Pac. ' + 
    --cast(qt_parcela_condicao_pgto as varchar) as nm_condicao_pagamento,
    isnull(qt_parcela_condicao_pgto,0)          as qt_parcela_condicao_pgto,
    isnull(ic_padrao_cond_pagamento,'N')        as ic_padrao_cond_pagamento,
    isnull(ic_antecipado,'N') as ic_antecipado 

  From 
    Condicao_Pagamento with(nolock)
  where 
    ( @ic_tipo_consulta = 'C' )
    and
    (
      --Compras *****
      --Mercado Nacional
      ( (     ( isNull(ic_ativo,'S') = 'S' )
          and ( @cd_tipo_mercado = 0 )
        ) or
      --Mercado Internacional
        (     ( isNull(ic_importacao_cond_pagto,'S') = 'S' )
          and ( @cd_tipo_mercado > 1 )
        )
      )
      and 
        (
          ( IsNull(ic_tipo_cond_pagamento,'V') = 'C' )
          or ( IsNull(ic_tipo_cond_pagamento,'V') = 'A' )
          or ( IsNull(ic_tipo_cond_pagamento,'V') = 'T' ) 
        )
    )
  order by 
    nm_condicao_pagamento

end

