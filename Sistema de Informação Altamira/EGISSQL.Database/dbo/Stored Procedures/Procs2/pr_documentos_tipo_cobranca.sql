
-------------------------------------------------------------------------------
--pr_documentos_tipo_cobranca
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
-- 22.12.2010 - Conta - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_documentos_tipo_cobranca
@cd_tipo_cobranca int = 0,
@dt_inicial datetime,  
@dt_final datetime  
AS




   SELECT
     C.nm_fantasia_cliente,
     TM.nm_tipo_mercado,
     TC.nm_tipo_cobranca,
     CD.cd_tipo_cobranca,
     V.nm_vendedor,
     P.nm_portador,
     CD.cd_identificacao,
     CD.cd_documento_receber,
     CD.dt_emissao_documento,
     CD.dt_vencimento_documento,
     CD.vl_documento_receber,
     CD.vl_saldo_documento,
     CD.cd_portador,
     CD.cd_cliente,
     CD.cd_vendedor,
     vwc.conta    

   FROM
     Documento_Receber CD                  with (nolock)
     left outer join Cliente C             with (nolock) on CD.cd_cliente         = C.cd_cliente
     left outer join Tipo_Mercado TM       with (nolock) on C.cd_tipo_mercado     = TM.cd_tipo_mercado
     left outer join Portador P            with (nolock) on P.cd_portador         = CD.cd_portador
     left outer join vendedor V            with (nolock) on V.cd_vendedor         = CD.cd_vendedor
     left outer join Tipo_Cobranca TC      with (nolock) on CD.cd_tipo_cobranca   = TC.cd_tipo_cobranca
     left outer join vw_conta_corrente vwc with (nolock) on vwc.cd_conta_banco    = cd.cd_conta_banco_remessa

   WHERE
     isnull(CD.cd_tipo_cobranca,0) = case when @cd_tipo_cobranca = 0 then isnull(CD.cd_tipo_cobranca,0) else @cd_tipo_cobranca end and
     CD.dt_vencimento_documento between @dt_inicial and @dt_final and
     cd.vl_saldo_documento > 0
   ORDER BY
     TC.nm_tipo_cobranca,
     CD.dt_vencimento_documento



