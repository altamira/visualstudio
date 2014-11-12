
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_previsao_pagar
-------------------------------------------------------------------------------
--pr_mapa_previsao_pagar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Previsão do Contas a Pagar
--Data             : 22.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_mapa_previsao_pagar
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  --dp.*
      d.cd_documento_pagar,  
      d.dt_vencimento_documento,  
      c.nm_tipo_conta_pagar,  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then   
          cast((select top 1 z.sg_empresa_diversa   
             from empresa_diversa z with (nolock)   
                where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
             
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then   
              cast((select top 1 w.nm_fantasia_fornecedor   
                from contrato_pagar w   with (nolock)   
                  where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
  
           when (isnull(d.cd_funcionario, 0) <> 0) then   
              cast((select top 1 k.nm_funcionario   
                 from funcionario k with (nolock)     
                   where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then   
              cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',  
  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then d.cd_empresa_diversa  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then d.cd_contrato_pagar  
           when (isnull(d.cd_funcionario, 0) <> 0) then d.cd_funcionario  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then d.cd_fornecedor  
      end                             as 'cd_favorecido_chave',  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then 'E'  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then 'C'  
           when (isnull(d.cd_funcionario, 0) <> 0) then 'U'  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then 'F'   
      end                             as 'ic_tipo_favorecido',  

      cast(case when isnull(d.cd_favorecido_empresa,0)=0
      then 
         ''
      else
        ( select top 1 fe.nm_favorecido_empresa 
          from 
             favorecido_empresa fe with (nolock) 
          where
             fe.cd_empresa_diversa        = d.cd_empresa_diversa and 
             fe.cd_favorecido_empresa_div = d.cd_favorecido_empresa )
      end as varchar(30))             as 'nm_favorecido_empresa',

      d.cd_favorecido_empresa,
      d.cd_identificacao_document,  
      d.dt_emissao_documento_paga,  
      d.vl_documento_pagar,  
      case when d.dt_cancelamento_documento is null 
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  
      t.nm_tipo_documento,  
      pf.cd_plano_financeiro,  
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,  
      m.sg_moeda,  
      l.nm_fantasia_loja,  
      i.nm_invoice,  
      d.vl_documento_pagar_moeda,  
      u.nm_fantasia_usuario,  
      d.vl_juros_documento,  
      d.vl_abatimento_documento,  
      d.vl_desconto_documento,  
      d.nm_observacao_documento,
      d.dt_cancelamento_documento,
      d.nm_cancelamento_documento,  
      pt.nm_portador,

      --Busca Data de Entrada da Nota Fiscal 
      --Carlos 27.04.2007

      ( Select Top 1
          ne.dt_receb_nota_entrada 
        from
          Nota_Entrada ne with (nolock)           
        Where
          cast(d.cd_nota_fiscal_entrada as int) = ne.cd_nota_entrada and
          d.cd_fornecedor          = ne.cd_fornecedor   and
          d.cd_serie_nota_fiscal   = ne.cd_serie_nota_fiscal ) as dt_rem,
 
--       ( Select Top 1
--           isnull(ner.dt_rem,ne.dt_receb_nota_entrada) 
--         from
--           Nota_Entrada_Parcela nep
-- 
--           left outer join Nota_Entrada_Registro ner on cast(d.cd_nota_fiscal_entrada as int ) = ner.cd_nota_entrada and
--                                                        d.cd_fornecedor = ner.cd_fornecedor and
--                                                        nep.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal
-- 
--           left outer join Nota_Entrada ne           on cast(d.cd_nota_fiscal_entrada as int) = ne.cd_nota_entrada and
--                                                        d.cd_fornecedor          = ne.cd_fornecedor   and
--                                                        d.cd_serie_nota_fiscal   = ne.cd_serie_nota_fiscal
-- 
--         Where
--           d.cd_documento_pagar = nep.cd_documento_pagar
--       )                              as dt_rem,

      d.cd_moeda,
      sd.nm_situacao_documento,
      d.cd_portador,
      d.cd_tipo_conta_pagar,
      d.cd_ap,
      ap.dt_aprovacao_ap,    
      d.cd_cheque_pagar,
      ( select
          sum ( isnull(vl_adto_fornecedor,0)) 
        from 
          fornecedor_adiantamento fa with (nolock) 
        where
          fa.cd_fornecedor = d.cd_fornecedor and
          fa.dt_baixa_adto_fornecedor is null ) as TotalAdiantamento,
      d.vl_multa_documento,
      ip.nm_imposto,
      d.nm_complemento_documento,
      cc.nm_centro_custo,

      --Fornecedor
      case when fo.cd_tipo_pessoa = 1 then
        dbo.fn_Formata_Mascara('99.999.999/9999-99', fo.cd_cnpj_fornecedor)  
      else
        dbo.fn_Formata_Mascara('999.999.999-99',
                         fo.cd_cnpj_fornecedor)  
      end                   as cd_cnpj,
      fo.nm_razao_social    as nm_razao_social    
 
    from  
      Documento_Pagar d                           with (nolock) 
      left outer join Fornecedor fo               with (nolock) on fo.cd_fornecedor         = d.cd_fornecedor 
      left outer join Fornecedor_Contato f        with (nolock) on d.cd_fornecedor          = f.cd_fornecedor and
                                                                   f.cd_contato_fornecedor  = 1   
      left outer join Tipo_conta_pagar c          with (nolock) on c.cd_tipo_conta_pagar    = d.cd_tipo_conta_pagar   
      left outer join Tipo_documento t            with (nolock) on t.cd_tipo_documento      = d.cd_tipo_documento   
      left outer join Plano_Financeiro pf         with (nolock) on pf.cd_plano_financeiro   = d.cd_plano_financeiro   
      left outer join Moeda m                     with (nolock) on d.cd_moeda               = m.cd_moeda  
      left outer join Loja l                      with (nolock) on l.cd_loja                = d.cd_loja   
      left outer join invoice i                   with (nolock) on i.cd_invoice             = d.cd_invoice  
      left outer join EgisAdmin.dbo.Usuario u     with (nolock) on d.cd_usuario             = u.cd_usuario  
      left outer join Portador pt                 with (nolock) on pt.cd_portador           = d.cd_portador
      left outer join situacao_documento_pagar sd with (nolock) on sd.cd_situacao_documento = d.cd_situacao_documento
      left outer join Autorizacao_Pagamento ap    with (nolock) on ap.cd_ap                 = d.cd_ap
      left outer join Imposto ip                  with (nolock) on ip.cd_imposto            = d.cd_imposto
      left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo       = d.cd_centro_custo

  where
     isnull(d.ic_previsao_documento,'N') = 'S' and
     d.dt_vencimento_documento   between @dt_inicial and @dt_final and
     d.dt_cancelamento_documento is null

  order by
     d.dt_vencimento_documento



