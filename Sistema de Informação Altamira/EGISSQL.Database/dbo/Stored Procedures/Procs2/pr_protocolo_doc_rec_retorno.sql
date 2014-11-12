

create procedure pr_protocolo_doc_rec_retorno
@ic_parametro     int         = 0,
@cd_identificacao varchar(15) = ''

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Traz Informações do Documento_Receber
-------------------------------------------------------------------------------
  begin

    select
      d.cd_identificacao,
      --isnull(c.cd_cliente_sap,d.cd_cliente) as 'cd_cliente',
      isnull(c.cd_cliente,c.cd_cliente_sap)   as 'cd_cliente',
      c.nm_razao_social_cliente               as 'nm_fantasia_cliente',
      d.dt_vencimento_documento,
      d.cd_portador
    from
      documento_receber d with (nolock, index(IX_documento_receber_Identificacao))
    left outer join
      Cliente c with (nolock, index(pk_cliente))
    on
      c.cd_cliente = d.cd_cliente
    where
      replace(d.cd_identificacao,'-','') = replace(@cd_identificacao,'-','')  
  end
else
  return

