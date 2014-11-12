
CREATE PROCEDURE pr_geracao_automatica_recibo
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

as
begin

--*********************** Usado Somente na Tela principal *****************************
--*********************** Usado Somente na Tela principal *****************************
if @ic_parametro = 1 
--**************************************************************************************
begin
  --select cd_recibo,* from documento_receber

  select 
    dr.cd_cliente,
    dr.cd_identificacao,
    dr.cd_documento_receber,
    dr.dt_emissao_documento,
    dr.dt_vencimento_documento,
    case when isnull(drp.vl_pagamento_documento,0)>0 then
      drp.vl_pagamento_documento
    else
      dr.vl_documento_receber
    end                               as vl_documento_receber,
    dr.ds_documento_receber,
    cli.nm_fantasia_cliente,
    --dr.ic_emissao_documento,
    case when isnull(r.cd_recibo,0)>0 then
      'S'
    else
       cast('' as char(1))
    end                                as ic_emissao_documento,

    dr.cd_tipo_destinatario

  from 
    Documento_receber dr with (nolock) 
    left outer join Documento_Receber_Pagamento drp on drp.cd_documento_receber = dr.cd_documento_receber
    left outer join Cliente cli                     on (dr.cd_cliente = cli.cd_cliente) 
    left outer join Recibo r                        on r.cd_documento_receber = dr.cd_documento_receber
  where
    --dt_emissao_documento between @dt_inicial and @dt_final and
    
    dt_vencimento_documento between @dt_inicial and @dt_final and
    dt_cancelamento_documento is null        and  --Cancelamento
    dt_devolucao_documento    is null             --Devolução

end

else

--**************************** Usado na Impressão **************************************
if @ic_parametro = 2 
--**************************************************************************************
begin
  select 
    dr.cd_cliente,
    dr.cd_identificacao,
    dr.cd_documento_receber,
    dr.dt_emissao_documento,
    dr.dt_vencimento_documento,
    dr.vl_documento_receber,
    dr.ds_documento_receber,
    cli.nm_fantasia_cliente,
    dr.ic_emissao_documento,
    dr.cd_tipo_destinatario
  from 
    Documento_receber dr with (nolock) 
    left outer join Cliente cli on (dr.cd_cliente = cli.cd_cliente) 

  where
   dr.ic_emissao_documento = 'S' and
   --dt_emissao_documento between @dt_inicial and @dt_final
   dt_vencimento_documento between @dt_inicial and @dt_final and
   dt_cancelamento_documento is null        and  --Cancelamento
   dt_devolucao_documento    is null             --Devolução


end

end

