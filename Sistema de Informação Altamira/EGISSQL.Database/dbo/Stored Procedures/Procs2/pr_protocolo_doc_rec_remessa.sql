

create procedure pr_protocolo_doc_rec_remessa
@ic_parametro       int,
@cd_identificacao   varchar(15),
@cd_banco           int = 0,
@cd_instrucao_banco int = 0

as

  declare @pc_taxa_cobranca_banco float

  -- taxa de cobrança bancária
  select
    @pc_taxa_cobranca_banco = isnull(pc_taxa_cobranca_banco,0)
  from
    Parametro_Financeiro with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Traz Informações do Documento_Receber
-------------------------------------------------------------------------------
  begin    

    --select * from vw_destinatario
    
    select
      d.cd_identificacao,
      --isnull(c.cd_cliente_sap,d.cd_cliente) as 'cd_cliente',

      isnull(d.cd_cliente,0)                  as 'cd_cliente',
      --c.nm_razao_social_cliente               as 'nm_fantasia_cliente',

      vw.nm_razao_social                      as 'nm_fantasia_cliente',

      --Consistência do Endereço Cobrança/Faturamento
      case when vw.nm_endereco <> vw.nm_endereco_cob
      then
        --Cobrança
        case when vw.cd_numero_endereco_cob is not null then
           vw.nm_endereco_cob+', '+cast(vw.cd_numero_endereco_cob as varchar)
        else
           vw.nm_endereco_cob 
        end           
      else
        --Faturamento
        case when vw.cd_numero_endereco is not null then
           vw.nm_endereco+', '+cast(vw.cd_numero_endereco as varchar)
        else
           vw.nm_endereco 
        end           
      
--         case when cd_numero_endereco is not null then
--         c.nm_endereco_cliente+', '+cast(cd_numero_endereco as varchar)
--       else
--         c.nm_endereco_cliente end           

       end                     as 'nm_endereco_cliente',

      case when cid.nm_cidade <> cidcob.nm_cidade then
        --Cobrança
        cidcob.nm_cidade
      else
        --Faturamento
        cid.nm_cidade
      end                      as 'nm_cidade',

      
      --cid.nm_cidade,
      --c.cd_cep,

      case when vw.cd_cep_cob <> vw.cd_cep then
         vw.cd_cep_cob
      else
         vw.cd_cep
      end                      as 'cd_cep',

      case when @pc_taxa_cobranca_banco <> 0 then
        (((d.vl_documento_receber * @pc_taxa_cobranca_banco)/100) / 30)
      end as vl_mora_documento,

      d.dt_vencimento_documento,
      d.dt_emissao_documento,
      --c.cd_cnpj_cliente,

      vw.cd_cnpj             as 'cd_cnpj_cliente',

      cast(null as varchar)  as 'nm_instrucao',
      cast(null as float)    as 'vl_instrucao',
      cast(null as datetime) as 'dt_instrucao',

      d.vl_documento_receber,
      d.cd_banco_documento_recebe,
      d.cd_nosso_numero_documento

    from

      documento_receber d                with (nolock) 
      left outer join vw_destinatario vw with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                          vw.cd_tipo_destinatario = d.cd_tipo_destinatario

      left outer join Cliente c          with (nolock) on c.cd_cliente            = d.cd_cliente
      left outer join Cidade cid         with (nolock) on vw.cd_cidade             = cid.cd_cidade and
                                                          vw.cd_estado             = cid.cd_estado and
                                                          vw.cd_pais               = cid.cd_pais

      left outer join Cidade cidcob      with (nolock) on vw.cd_cidade_cob = cidcob.cd_cidade and
                                                          vw.cd_estado_cob = cidcob.cd_estado and
                                                          vw.cd_pais_cob   = cidcob.cd_pais

    where
      replace(d.cd_identificacao,'-','') = replace(@cd_identificacao,'-','')  

  end

--select * from vw_destinatario

-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- Traz Informações da Instrução Bancária
-------------------------------------------------------------------------------
  begin    

    select top 1
      d.cd_identificacao,
--      isnull(c.cd_cliente_sap,d.cd_cliente) as 'cd_cliente',
      isnull(d.cd_cliente,0)                  as 'cd_cliente',
--        c.nm_razao_social_cliente as 'nm_fantasia_cliente',
      vw.nm_razao_social                      as 'nm_fantasia_cliente',


--       case when cd_numero_endereco is not null then
--         c.nm_endereco_cliente+', '+cast(cd_numero_endereco as varchar)
--       else
--         c.nm_endereco_cliente end as 'nm_endereco_cliente',
--       cid.nm_cidade,
--       c.cd_cep,

      --Consistência do Endereço Cobrança/Faturamento
      case when vw.nm_endereco <> vw.nm_endereco_cob
      then
        --Cobrança
        case when vw.cd_numero_endereco_cob is not null then
           vw.nm_endereco_cob+', '+cast(vw.cd_numero_endereco_cob as varchar)
        else
           vw.nm_endereco_cob 
        end           
      else
        --Faturamento
        case when vw.cd_numero_endereco is not null then
           vw.nm_endereco+', '+cast(vw.cd_numero_endereco as varchar)
        else
           vw.nm_endereco 
        end           
      
--         case when cd_numero_endereco is not null then
--         c.nm_endereco_cliente+', '+cast(cd_numero_endereco as varchar)
--       else
--         c.nm_endereco_cliente end           

       end                     as 'nm_endereco_cliente',

      case when cid.nm_cidade <> cidcob.nm_cidade then
        --Cobrança
        cidcob.nm_cidade
      else
        --Faturamento
        cid.nm_cidade
      end                      as 'nm_cidade',

      
      --cid.nm_cidade,
      --c.cd_cep,

      case when vw.cd_cep_cob <> vw.cd_cep then
         vw.cd_cep_cob
      else
         vw.cd_cep
      end                      as 'cd_cep',



      case when @pc_taxa_cobranca_banco <> 0 then
        (((d.vl_documento_receber * @pc_taxa_cobranca_banco)/100) / 30)
      end as vl_mora_documento,
      d.dt_vencimento_documento,      
      ib.nm_instrucao + IsNull('-'+ic.nm_instrucao_banco_compos,'') as 'nm_instrucao',
      ic.vl_instrucao_banco_compos as 'vl_instrucao',
      ic.dt_instrucao_banco_comp   as 'dt_instrucao',
      d.dt_emissao_documento,
--      c.cd_cnpj_cliente
      vw.cd_cnpj             as 'cd_cnpj_cliente'


    from
      documento_receber d with (nolock) 
    left outer join
      Instrucao_Banco iba
    on 
      iba.cd_banco = @cd_banco and
      iba.cd_instrucao_banco = @cd_instrucao_banco
    left outer join
      Cliente c
    on
      c.cd_cliente = d.cd_cliente
    left outer join vw_destinatario vw with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                          vw.cd_tipo_destinatario = d.cd_tipo_destinatario

    left outer join
      Cidade cid
    on
      vw.cd_cidade = cid.cd_cidade and
      vw.cd_estado = cid.cd_estado and
      vw.cd_pais = cid.cd_pais

      left outer join Cidade cidcob
    on
      vw.cd_cidade_cob = cidcob.cd_cidade and
      vw.cd_estado_cob = cidcob.cd_estado and
      vw.cd_pais_cob   = cidcob.cd_pais

    left outer join
      Documento_Instrucao_Bancaria i
    on
      d.cd_documento_receber = i.cd_documento_receber
    left outer join
      Doc_Instrucao_Banco_Composicao ic
    on
      ic.cd_doc_instrucao_banco = i.cd_doc_instrucao_banco      
    left outer join
      Instrucao_Bancaria ib
    on
      ib.cd_instrucao = iba.cd_instrucao
 
    where
      replace(d.cd_identificacao,'-','') = replace(@cd_identificacao,'-','')


  end

else
  return

