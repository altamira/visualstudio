

create procedure pr_selecao_documento_banco
@ic_parametro           int,      -- tipo de operação executada p/ esta stored procedure
@dt_envio               datetime, -- data de envio p/ banco
@cd_documento_receber   int,      -- código do documento p/ envio p/ banco
@cd_portador            int,      -- código do portador p/ envio
@cd_conta_banco_remessa int = 0   -- conta bancária da remessa

as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Listar os Documentos a Receber p/ seleção
-------------------------------------------------------------------------------
begin

  --Verifica o Cadastro de CEP Para não ter problema no processamento

  if exists( select top 1 cd_cep from cep where substring(cd_cep,6,1)='-' )
  begin
    update
      cep
    set
      cd_cep = replace(cd_cep,'-','')

    update
      cliente_endereco
    set
      cd_cep_cliente = replace(cd_cep_cliente,'-','')  

  end

  --select * from cliente_informacao_credito

  declare @qt_dias_envio            int      -- qtde de dias p/ envio
  declare @qt_dias_vencimento       int      -- qtde de dias entre emissão e vencimento
  declare @ic_envia_doc_emitido     char(1)  -- Define que irá enviar o documento mesmo se este foi impresso
  declare @qt_dia_limite_cnab_banco int      -- Dias Limite para o Banco aceitar o Documento
  declare @ic_bloqueio_cnab_banco   char(1)  -- Bloqueio do documento
  declare @dt_hoje                  datetime -- Data de Hoje

  set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

  -- alterar futuramente o carregamento destas variáveis
  -- informações deverão ser configuradas em parametro_empresa

  Select 
    @qt_dias_envio        = isnull(qt_min_dia_envio_magnetic,2),
    @ic_envia_doc_emitido = IsNull(ic_envia_doc_emitido,'N')
  from 
    parametro_financeiro with (nolock) 
  where 
    cd_empresa=dbo.fn_empresa()

  set @qt_dias_vencimento = 10

  --Verifica se foi passado uma conta---------------------------------------------------------------

  if @cd_conta_banco_remessa>0 
  begin
    select
      top 1
      @qt_dia_limite_cnab_banco = isnull(qt_dia_limite_cnab_banco,0),
      @ic_bloqueio_cnab_banco   = isnull(ic_bloqueio_cnab_banco,'N')
    from
      Banco b
      inner join Conta_Agencia_Banco cab on cab.cd_banco = b.cd_banco
    where
      cab.cd_conta_banco = @cd_conta_banco_remessa     

  end


  --if @qt_dia_limite_cnab_banco = 0
  -- begin
  --
  --  set @qt_dia_limite_cnab_banco = 365 * 2
  --end
  
  select distinct
    r.cd_nota_saida,
    'N'                       as 'Enviar', -- campo p/ armazenamento temporário
    r.dt_vencimento_documento as 'Vencimento',
    -- condições p/ envio:
    --  1. - A data de envio deve ser superior a quantidade de
    --       dias especificado em configuração da empresa em
    --       relação a data de emissão. 
    --  2. - Somente os documentos em que o período entre a
    --       data de vencimento e data de emissão forem superiores
    --       ao configurado na empresa.
    --  3. - Somente aqueles clientes que estão configurado p/
    --       receber cobrança eletrônica.
    --  4. - Se a data de vencimento for inferior ao configurado p/
    --       empresa então habilitar para selecionar
    case when
      ((r.dt_vencimento_documento - r.dt_emissao_documento) < @qt_dias_vencimento) and
      (isnull(inf.ic_cobranca_eletronica,'S') = 'S') 
      then 'S'
    else
      case when

        (@qt_dias_envio > 0 and @dt_envio < (r.dt_emissao_documento + @qt_dias_envio)) or
        (isnull(inf.ic_cobranca_eletronica,'S') = 'N') --(3)
      then 'N' else 'S' end
    end                                                              as 'Status',
    /*
    case when 
      (@dt_envio < (r.dt_emissao_documento + @qt_dias_envio)) or --(1)
      ((r.dt_vencimento_documento - r.dt_emissao_documento) < @qt_dias_vencimento) or --(2)
      (isnull(inf.ic_cobranca_eletronica,'S') = 'N') --(3)
    then 'N' else 'S' end  as 'Status', 
    */
    r.cd_cliente                                                     as 'CodCliente',
    c.nm_fantasia                                                    as 'FantCliente',

    (select 
       top 1
       cid.nm_cidade 
     from 
       Cidade cid  with (nolock) 
     where
       c.cd_pais   = cid.cd_pais and 
       c.cd_estado = cid.cd_estado and              
       c.cd_cidade = cid.cd_cidade)                                  as 'Cidade', 

    (select 
       top 1
       est.sg_estado
     from 
       Estado est with (nolock) 
     where
       c.cd_pais = est.cd_pais and 
       c.cd_estado = est.cd_estado) as 'Estado', 

    r.vl_documento_receber          as 'VlrDocumento',
    r.cd_identificacao              as 'IdentDocumento',
    r.cd_documento_receber          as 'CodIntDocumento',
    r.dt_emissao_documento          as 'Emissao',

    case 
      when @qt_dia_limite_cnab_banco > 0 and r.dt_vencimento_documento > (@dt_hoje + @qt_dia_limite_cnab_banco) then 'Vencimento está acima do Limite do Banco'
      when (@dt_envio < (r.dt_emissao_documento + @qt_dias_envio))  then 'Emissão < que '+cast(@qt_dias_envio as varchar(2))+' dias do envio.'
      when ((r.dt_vencimento_documento - r.dt_emissao_documento) < @qt_dias_vencimento) then 'Vencimento < que '+cast(@qt_dias_vencimento as varchar(2))+' dias da emissão.'
      when (isnull(inf.ic_cobranca_eletronica, 'S') = 'N') then 'Sem cobrança eletrônica.'
      when ( select count(*) from Cliente_Endereco x where x.cd_cliente = r.cd_cliente and
                                                           x.cd_tipo_endereco = 3) > 1 then
        ' Cliente tem mais que um Endereço de Cobrança. Favor Verificar.'
      else null 
    end                             as 'Observacao',
    r.cd_banco_documento_recebe,
    r.ic_emissao_documento,
    ( select case when count(*) > 0 then 'S' else 'N' end from Cliente_Endereco x with (nolock) 
                                                               where x.cd_cliente = r.cd_cliente and
                                                    x.cd_tipo_endereco = 3 and
                                                    (
                                                    --isnull(x.nm_endereco_cliente,'') = '' or
                                                    isnull(x.cd_cep_cliente,0) = 0 or
                                                    isnull(x.cd_cidade,0)      = 0 or
                                                    isnull(x.cd_estado,0)      = 0
                                                    )
    ) as 'EnderecoCobrancaInvalido',
    cab.nm_conta_banco,
    --complemento dos campos
    isnull(inf.ic_credito_suspenso,'N') as ic_credito_suspenso,
    isnull(inf.ic_deposito_cliente,'N') as ic_deposito_cliente,
    p.nm_portador,
    ns.ic_status_nota_saida,
    @qt_dia_limite_cnab_banco            as DiasLimite,
    @dt_hoje + @qt_dia_limite_cnab_banco as VctoLimite,
    @ic_bloqueio_cnab_banco              as ic_bloqueio_cnab_banco
     
  from 
    Documento_receber r                                  with (nolock) 
    inner join  vw_destinatario_rapida c                 with (nolock) on c.cd_destinatario      = r.cd_cliente and
                                                                          c.cd_tipo_destinatario = r.cd_tipo_destinatario 
    left outer join Cliente_Informacao_credito inf       with (nolock) on r.cd_cliente           = inf.cd_cliente 
    left outer join Nota_Saida ns                        with (nolock) on ns.cd_nota_saida       = r.cd_nota_saida
    left outer join Conta_Agencia_Banco cab              with (nolock) on cab.cd_conta_banco     = r.cd_conta_banco_remessa
    left outer join Portador p                           with (nolock) on p.cd_portador          = inf.cd_portador
    left outer join Tipo_Cobranca tc                     with (nolock) on tc.cd_tipo_cobranca    = r.cd_tipo_cobranca

--select * from Conta_Agencia_Banco

  where    
    r.cd_portador   = 999               and  --Carteira
    r.dt_cancelamento_documento is null and  --Cancelamento
    r.dt_devolucao_documento    is null and  --Devolução
    cast(str(r.vl_saldo_documento,25,2) as decimal(25,2)) > 0 and
   (((@ic_envia_doc_emitido = 'N')  and (isnull(r.ic_emissao_documento,'N')= 'N'))or 
     (@ic_envia_doc_emitido = 'S'))  and
    isnull(r.ic_credito_icms_documento,'N')<> 'S'  
    --Caso Exista Nota Fiscal, verifica se ela está emitida
    and 'E' = (case when IsNull(r.cd_nota_saida,0) <> 0 and isnull(ns.cd_nota_saida,0)<>0
              then
                case when r.cd_nota_saida = ns.cd_nota_saida 
                then
                   IsNull(ns.ic_status_nota_saida,'')
                else
                   'E'
                end
              else 
               'E' 
              end )
    --filtro por tipo de cobrança
   and isnull(tc.ic_cnab_tipo_cobranca,'S')='S'
 
  order by
    Vencimento,
    IdentDocumento,
    FantCliente

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Configuração do registro p/ envio 
-------------------------------------------------------------------------------
begin

  update
    Documento_receber
  set
    ic_envio_documento       = 'S',
    cd_portador              = @cd_portador,
    dt_selecao_documento     = @dt_envio,
    cd_conta_banco_remessa   = @cd_conta_banco_remessa
  where
    cd_documento_receber     = @cd_documento_receber

end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Acerto do Documento para nova Remessa 
-------------------------------------------------------------------------------
begin

  update Documento_receber 
  set
    ic_emissao_documento     ='N',        
    ic_envio_documento       ='N',
    cd_portador              = 999,       --Carteira
    dt_envio_banco_documento = null,
    cd_conta_banco_remessa   = null
  where 
    dt_envio_banco_documento between @dt_envio and @dt_envio+1 and
    cd_portador               = @cd_portador   and
    vl_saldo_documento>0         
end     

