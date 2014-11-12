
CREATE   procedure pr_repnet_posicao_financeira_cliente
--------------------------------------------------------------------------------------
--                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Movimento de duplicatas do Cliente-posicao financeira
--Data            : 21.03.2000
--Atualizado      : 07.04.2002
--------------------------------------------------------------------------------------

--@cd_vendedor         int,
@nm_fantasia_cliente varchar(15),
@dt_inicial          datetime,
@dt_final            datetime,
@ic_tipo_usuario     char(10),
@cd_tipo_usuario     int,
@ic_somente_aberto   char(1) = 'N'
as

if @ic_tipo_usuario = 'Vendedor'
begin
select 
   cli.nm_fantasia_cliente                  as 'Fantasia',
   doc.cd_identificacao                     as 'Documento',
   doc.dt_emissao_documento                 as 'DtEmissao',
   doc.dt_vencimento_documento              as 'DtVcto',
	 IsNull(doc.vl_documento_receber,0)       as 'VlDocumento',
   isnull(doc.vl_saldo_documento,0)         as 'Saldo',
   doc.dt_cancelamento_documento  as 'DtCanc',
   doc.dt_pagto_document_receber  as 'DtPagto',
   isnull(doc.vl_pagto_document_receber,0)  as 'ValorPagto',
   isnull(doc.cd_pedido_venda,0)            as 'Pedido',
   isnull(doc.cd_nota_saida,0)              as 'NotaFiscal'
from
   Cliente cli, Documento_Receber doc
Where
   cli.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and
   cli.cd_cliente          = doc.cd_cliente       and   --Cliente
   cli.cd_vendedor         = @cd_tipo_usuario and   --Vendedor
   doc.dt_emissao_documento between @dt_inicial and @dt_final   
   and 
   (
   ((@ic_somente_aberto = 'S')              and 
    (doc.dt_cancelamento_documento is null) and
    (doc.dt_devolucao_documento is null)    and
    (doc.vl_saldo_documento) > 0
   )
   or 
   ((@ic_somente_aberto = 'N'))
   )
order by 
   doc.dt_pagto_document_receber desc
end

if @ic_tipo_usuario = 'Cliente'
begin
select 
   cli.nm_fantasia_cliente        as 'Fantasia',
   doc.cd_identificacao           as 'Documento',
   doc.dt_emissao_documento       as 'DtEmissao',
   doc.dt_vencimento_documento    as 'DtVcto',
	 IsNull(doc.vl_documento_receber,0)       as 'VlDocumento',
   isnull(doc.vl_saldo_documento,0)         as 'Saldo',
   doc.dt_cancelamento_documento  as 'DtCanc',
   doc.dt_pagto_document_receber  as 'DtPagto',
   isnull(doc.vl_pagto_document_receber,0)  as 'ValorPagto',
   isnull(doc.cd_pedido_venda,0)            as 'Pedido',
   isnull(doc.cd_nota_saida,0)              as 'NotaFiscal'
from
   Cliente cli, Documento_Receber doc
Where
   cli.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and
   cli.cd_cliente          = doc.cd_cliente       and   --Cliente
   cli.cd_cliente          = @cd_tipo_usuario and   --Vendedor
   doc.dt_emissao_documento between @dt_inicial and @dt_final   
   and 
   (
   ((@ic_somente_aberto = 'S')              and 
    (doc.dt_cancelamento_documento is null) and
    (doc.dt_devolucao_documento is null)    and
    (doc.vl_saldo_documento) > 0
   )
   or 
   ((@ic_somente_aberto = 'N'))
   )
order by 
   doc.dt_pagto_document_receber desc
end

if @ic_tipo_usuario = 'Supervisor'
begin
select 
   cli.nm_fantasia_cliente        as 'Fantasia',
   doc.cd_identificacao           as 'Documento',
   doc.dt_emissao_documento       as 'DtEmissao',
	 IsNull(doc.vl_documento_receber,0)       as 'VlDocumento',
   doc.dt_vencimento_documento    as 'DtVcto',
   isnull(doc.vl_saldo_documento,0)         as 'Saldo',
   doc.dt_cancelamento_documento  as 'DtCanc',
   doc.dt_pagto_document_receber  as 'DtPagto',
   isnull(doc.vl_pagto_document_receber,0)  as 'ValorPagto',
   isnull(doc.cd_pedido_venda,0)            as 'Pedido',
   isnull(doc.cd_nota_saida,0)              as 'NotaFiscal'
from
   Cliente cli, Documento_Receber doc
Where
   cli.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and
   cli.cd_cliente          = doc.cd_cliente       and   --Cliente
   doc.dt_emissao_documento between @dt_inicial and @dt_final   
   and 
   (
   ((@ic_somente_aberto = 'S')              and 
    (doc.dt_cancelamento_documento is null) and
    (doc.dt_devolucao_documento is null)    and
    (doc.vl_saldo_documento) > 0
   )
   or 
   ((@ic_somente_aberto = 'N'))
   )
order by 
   doc.dt_pagto_document_receber desc
end







