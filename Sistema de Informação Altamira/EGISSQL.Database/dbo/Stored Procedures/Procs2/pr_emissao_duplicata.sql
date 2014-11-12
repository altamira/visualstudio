



CREATE   PROCEDURE pr_emissao_duplicata
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@Duplicatas   varchar(8000) = '',
@cd_usuario   int           = 0

as

  declare @SQL       varchar(8000)
  declare @SQL_From  varchar(8000)
  declare @SQL_Where varchar(8000)
  declare @SQL_And   varchar(8000)
  declare @SQL_Order varchar(8000)


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista duplicatas NÃO impressas
-------------------------------------------------------------------------------
  begin
    select
      n.ic_dup_parcela_nota_saida,
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         isnull(d.cd_nota_saida,0)
      end                                          as cd_nota_saida,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      isnull(d.vl_documento_receber,0)             as vl_documento_receber,
      v.nm_fantasia                                as nm_fantasia_cliente,
      cast(d.ds_documento_receber as varchar(256)) as 'ds_documento_receber',
      d.cd_identificacao                           as 'cd_ident_parc_nota_saida',
      d.ic_emissao_documento,
      d.cd_documento_receber,
      isnull(ns.vl_total,0)                        as vl_total,
      po.nm_portador,
      n.nm_obs_parcela_nota_saida,
      d.cd_pedido_venda                            as Pedido_Venda,
      c.cd_inscestadual                             


    from
      Documento_Receber d                      with (nolock) 
      left outer join Nota_Saida_Parcela n     with (nolock) on d.cd_nota_saida        = n.cd_nota_saida and
                                                                d.cd_identificacao     = n.cd_ident_parc_nota_saida 

      left outer join Nota_Saida ns            with (nolock) on ns.cd_nota_saida       = d.cd_nota_saida 
      left outer join vw_Destinatario_Rapida v with (nolock) on v.cd_destinatario      = d.cd_cliente and
                                                                v.cd_tipo_destinatario = d.cd_tipo_destinatario
      left outer join Portador Po              with (nolock) on po.cd_portador         = d.cd_portador
      left outer join cliente  c                with (nolock) on c.cd_cliente           = d.cd_cliente

    where
      d.dt_emissao_documento between @dt_inicial and @dt_final and
      IsNull(n.ic_dup_parcela_nota_saida,'N') = 'N' and
      IsNull(d.ic_emissao_documento,'N')      = 'N' and
      dt_cancelamento_documento is null and
      dt_devolucao_documento    is null
    order by
      d.dt_emissao_documento

  end 
-------------------------------------------------------------------------------
if @ic_parametro = 2    -- lista duplicatas impressas ( REEMISSÃO )
-------------------------------------------------------------------------------
  begin
    select
      'N' as 'Selecionado', 
      n.ic_dup_parcela_nota_saida,
--      isnull(d.cd_nota_saida,0)                    as cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         isnull(d.cd_nota_saida,0)
      end                                          as cd_nota_saida,

      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      isnull(d.vl_documento_receber,0)             as vl_documento_receber,
      v.nm_fantasia as nm_fantasia_cliente,
      cast(d.ds_documento_receber as varchar(256)) as 'ds_documento_receber',
      d.cd_identificacao as 'cd_ident_parc_nota_saida',
      d.ic_emissao_documento,
      d.cd_documento_receber,
      isnull(ns.vl_total,0)                        as vl_total,
      po.nm_portador,
      n.nm_obs_parcela_nota_saida,
      d.cd_pedido_venda                            as Pedido_Venda,
      c.cd_inscestadual                             

    from
      Documento_Receber d                      with (nolock) 
      left outer join Nota_Saida_Parcela n     with (nolock) on d.cd_nota_saida        = n.cd_nota_saida and
                                                                d.cd_identificacao     = n.cd_ident_parc_nota_saida 

      left outer join vw_Destinatario_Rapida v with (nolock) on v.cd_destinatario      = d.cd_cliente and
                                                                v.cd_tipo_destinatario = d.cd_tipo_destinatario 
      left outer join Nota_Saida ns            with (nolock) on ns.cd_nota_saida       = d.cd_nota_saida
      left outer join Portador Po              with (nolock) on po.cd_portador         = d.cd_portador
      left outer join cliente  c               with (nolock) on c.cd_cliente           = d.cd_cliente
    where
      d.dt_emissao_documento between @dt_inicial and @dt_final and
      ((IsNull(n.ic_dup_parcela_nota_saida,'N') = 'S') or (IsNull(d.ic_emissao_documento,'N') = 'S')) and
      dt_cancelamento_documento is null and
      dt_devolucao_documento is null
    order by
      d.dt_emissao_documento
  end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- lista duplicatas para formulário personalizado
-------------------------------------------------------------------------------
  begin

--    print '1'
--                d.cd_nota_saida as NotaSaida,
    
    set @SQL = 'select
                n.ic_dup_parcela_nota_saida as TipoDuplicataParcelaSaida,

               case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         isnull(d.cd_nota_saida,0)
      end                                          as NotaSaida,

                d.dt_emissao_documento as EmissaoDocumento, 
                d.dt_vencimento_documento as VencimentoDocumento,
                d.vl_documento_receber as ValorDocumentoReceber,
                d.ds_documento_receber as DescricaoDocumentoReceber,
                d.cd_identificacao as Identificacao,
                d.ic_emissao_documento as TipoEmissaoDocumento,
                d.cd_documento_receber as DocumentoReceber,
                d.cd_pedido_venda         as Pedido_Venda,
                c.nm_razao_social_cliente as Cliente,
                c.cd_cnpj_cliente         as CNPJ_Cliente,
                c.cd_inscestadual         as cd_inscestadual,
                c.nm_fantasia_cliente     as NomeFantasia,
                c.nm_endereco_cliente     as Endereco_Cliente,
                c.cd_numero_endereco      as Numero_Cliente,
                c.nm_complemento_endereco as Complemento_Cliente,
                c.nm_bairro as Bairro_Cliente,
                c.cd_cep as Cep_Cliente,
                cidC.nm_cidade as Cidade_Cliente,       
                estC.sg_estado as Estado_Cliente,  
                ns.vl_total as ValorTotal,
                IsNull(clie.nm_endereco_cliente,c.nm_endereco_cliente)          as Endereco_Cobranca,
                IsNull(clie.cd_numero_endereco,c.cd_numero_endereco)            as Numero_Cobranca,
                IsNull(clie.nm_complemento_endereco,c.nm_complemento_endereco)  as Complemento_Cobranca,
                IsNull(clie.nm_bairro_cliente,c.nm_bairro)                      as Bairro_Cobranca,
                IsNull(clie.cd_cep_cliente,c.cd_cep)                            as Cep_Cobranca,
                IsNull(clie.cd_cnpj_cliente,c.cd_cnpj_cliente)                  as CNPJ_Cobranca,     
                IsNull(cid.nm_cidade,cidC.nm_cidade)                            as Cidade_Cobranca,       
                IsNull(est.sg_estado,estC.sg_estado)                            as Estado_Cobranca,
                n.nm_obs_parcela_nota_saida, '+
                '''(''' + '+c.cd_ddd+' +''')-'''+' +c.cd_telefone as cd_telefone_cliente, '+
                ' cast(ns.cd_vendedor as varchar(03)) +'+'''-'''+' +v.nm_fantasia_vendedor as nm_vendedor'

--   print @sql

--select * from cliente

    set @SQL_From = ' from '+
                     ' Documento_Receber d with (nolock)     '+
                     ' left outer join Nota_Saida_Parcela n on d.cd_nota_saida = n.cd_nota_saida '+
                     '                                    and d.cd_identificacao = n.cd_ident_parc_nota_saida '+
                     'left outer join Nota_Saida ns on ns.cd_nota_saida = d.cd_nota_saida '+ 
                     'left outer join Cliente c on d.cd_cliente = c.cd_cliente '+
                     'left outer join cidade cidC on cidC.cd_cidade = c.cd_cidade '+
                     'left outer join estado estC on estC.cd_estado = c.cd_estado '+
                     'left outer join cliente_endereco clie on clie.cd_cliente = c.cd_cliente and ' +
                                                             'clie.cd_tipo_endereco = 3 '+
                     'left outer join cidade cid on cid.cd_cidade = clie.cd_cidade '+
                     'left outer join estado est on est.cd_estado = clie.cd_estado '+
                     'left outer join Vendedor v on v.cd_vendedor = ns.cd_vendedor '
--    print @SQL_From

    --Antes de 25.09.2010

--    set @SQL_Where = ' where d.cd_documento_receber in (' + @duplicatas + ')'
--select * from documento_receber_duplicata

    set @SQL_Where = ' where d.cd_documento_receber in ( select cd_documento_receber from documento_receber_duplicata x
                                                         where
                                                           d.cd_documento_receber = x.cd_documento_receber and
                                                           x.cd_usuario_selecao   = '+cast(@cd_usuario as varchar) + ')'

--    print @SQL_Where
                   
    set @SQL_Order = ' order by d.dt_emissao_documento '

--    print @SQL_Order
--    print @SQL_And

--    print(@SQL + @SQL_From + @SQL_Where + @SQL_And + @SQL_Order)

    exec(@SQL + @SQL_From + @SQL_Where + @SQL_Order)

  end

else  
-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Atualiza as duplicatas emitidas.
-------------------------------------------------------------------------------
  begin

   
--    set @SQL = 'update Documento_Receber set dt_impressao_documento = convert(varchar,GetDate(),103) , ic_emissao_documento = ''S'' where cd_documento_receber in (' + @duplicatas + ')'

    set @SQL = 'update Documento_Receber set dt_impressao_documento = convert(varchar,GetDate(),103) , ic_emissao_documento = ''S'' from documento_receber d where cd_documento_receber in ( select cd_documento_receber from documento_receber_duplicata x
                                                         where
                                                           d.cd_documento_receber = x.cd_documento_receber and
                                                           x.cd_usuario_selecao   = '+cast(@cd_usuario as varchar) + ')'



    --print(@SQL)
    exec(@SQL)

    --Antes 25.09.2010

--     set @SQL = 'update Nota_Saida_Parcela set ic_dup_parcela_nota_saida = ''S'' where cd_nota_saida in ( ' +
--                ' select cd_nota_saida from
--                   Documento_Receber d 
--                  where cd_documento_receber in ('  + @duplicatas + ')' + ')'

    set @SQL = 'update Nota_Saida_Parcela set ic_dup_parcela_nota_saida = ''S'' where cd_nota_saida in ( ' +
               ' select cd_nota_saida from
                  Documento_Receber d 
                 where d.cd_documento_receber in ( select cd_documento_receber from documento_receber_duplicata x
                                                         where
                                                           d.cd_documento_receber = x.cd_documento_receber and
                                                           x.cd_usuario_selecao   = '+cast(@cd_usuario as varchar) + ')' + ')'

    --print(@SQL)
    exec(@SQL) 

  end
else
  return
    


