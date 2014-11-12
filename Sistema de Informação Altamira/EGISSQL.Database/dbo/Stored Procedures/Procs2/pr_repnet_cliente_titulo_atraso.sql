







--pr_repnet_cliente_titulo_atraso
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Títulos em Atraso por Cliente/Vendedor
--Data          : 07.04.2002
--Atualizado    : 
----------------- ---------------------------------------------------------------------
CREATE    procedure pr_repnet_cliente_titulo_atraso
@ic_tipo_usuario char(10),
@cd_tipo_usuario int 
as

if @ic_tipo_usuario = 'Vendedor'
begin
select
  cli.nm_fantasia_cliente         as 'cliente', 
  isnull(sum(doc.vl_saldo_documento),0)     as 'TotalAtraso',
  isnull(min(doc.dt_vencimento_documento),0) as 'Vencimento',
  count(*)                        as 'Qtd'
from
   Cliente cli
left outer join Documento_Receber doc
   on (doc.cd_cliente=cli.cd_cliente)
Where
   cli.cd_vendedor = @cd_tipo_usuario             and
   cli.cd_cliente  = doc.cd_cliente           and
   doc.dt_pagto_document_receber is null     and -- data do pagamento
   doc.dt_vencimento_documento < getdate()-1  and -- data do vencimento
   doc.vl_saldo_documento  > 0
Group by 
   cli.nm_fantasia_cliente
order by 3,1
end


if @ic_tipo_usuario = 'Cliente'
begin
select
  cli.nm_fantasia_cliente         as 'cliente', 
  isnull(sum(doc.vl_saldo_documento),0)     as 'TotalAtraso',
  isnull(min(doc.dt_vencimento_documento),0) as 'Vencimento',
  count(*)                        as 'Qtd'
from
   Cliente cli
left outer join Documento_Receber doc
   on (doc.cd_cliente=cli.cd_cliente)
Where
   cli.cd_cliente  = doc.cd_cliente           and
   cli.cd_cliente  = @cd_tipo_usuario           and
   doc.dt_pagto_document_receber is null     and -- data do pagamento
   doc.dt_vencimento_documento < getdate()-1  and -- data do vencimento
   doc.vl_saldo_documento  > 0
Group by 
   cli.nm_fantasia_cliente
order by 3,1
end


if @ic_tipo_usuario = 'Supervisor'
begin
select
  cli.nm_fantasia_cliente         as 'cliente', 
  isnull(sum(doc.vl_saldo_documento),0)     as 'TotalAtraso',
  isnull(min(doc.dt_vencimento_documento),0) as 'Vencimento',
  count(*)                        as 'Qtd'
from
   Cliente cli
left outer join Documento_Receber doc
   on (doc.cd_cliente=cli.cd_cliente)
Where
   doc.dt_pagto_document_receber is null     and -- data do pagamento
   doc.dt_vencimento_documento < getdate()-1  and -- data do vencimento
   doc.vl_saldo_documento  > 0
Group by 
   cli.nm_fantasia_cliente
order by 3,1
end




