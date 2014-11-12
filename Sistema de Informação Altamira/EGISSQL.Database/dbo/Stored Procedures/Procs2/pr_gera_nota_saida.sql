
-------------------------------------------------------------------------------
--sp_helptext pr_gera_nota_saida
-------------------------------------------------------------------------------
--pr_gera_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Nota Fiscal de Saída Automaticamente
--                   a Partir do Pedido de Venda
--Data             : 12.01.2009
--Alteração        : 22.01.2009 - Saldo/Status do Pedido de Venda 
--
-- 30.01.2009 - Ajuste de novos atributos - Carlos Fernandes
-- 01.04.2009 - Verificação do Pedido de Compra - Carlos Fernandes
-- 06.04.2009 - Transportadora - Carlos Fernandes 
-- 07.04.2009 - Data de Saída  da Nota Fiscal - Carlos Fernandes
-- 11.04.2009 - Pedido de Venda de Bonificação - Carlos Fernandes
-- 04.05.2009 - Bloqueia o Faturamento de Nota com Produto sem Estoque - Carlos Fernandes
-- 05.05.2009 - Tirado o Bloqueio de Estoque - Carlos Fernandes
-----------------------------------------------------------------------------------------
create procedure pr_gera_nota_saida
@cd_pedido_venda     int       = 0,
@cd_usuario          int       = 0,
@dt_nota_saida       datetime  = null,
@cd_operacao_fiscal  int       = 0,
@dt_saida_nota_saida datetime  = null

as

if @dt_nota_saida is null
begin
   --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)
   set @dt_nota_saida = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

if @dt_saida_nota_saida is null
begin
   --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)
   set @dt_saida_nota_saida = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

--declare @cd_operacao_fiscal  int

declare @Tabela		     varchar(80)
declare @cd_nota_saida       int
declare @cd_fase_produto     int

--Fase do Produto------------------------------

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  Parametro_Comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

  --declare @cd_pedido_venda     int

  -- Nome da Tabela usada na geração e liberação de códigos

  set @Tabela          = cast(DB_NAME()+'.dbo.Nota_Saida' as varchar(80))
  set @cd_nota_saida = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_nota_saida', @codigo = @cd_nota_saida output
	
  while exists(Select top 1 'x' from nota_saida 
               where cd_nota_saida = @cd_nota_saida 
               order by cd_nota_saida)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_nota_saida', @codigo = @cd_nota_saida output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_nota_saida, 'D'
  end

  --Geração da Operação Fiscal---------------------------------------------------

  if @cd_operacao_fiscal is null 
  begin
     set @cd_operacao_fiscal = 0
  end

--Verifica se Pedido de Venda já Possui Nota Fiscal de Saída

--Checar se o Pedido está em algum item de Nota Fiscal de Saída
--Nota_Saida_Item

if exists ( select top 1 cd_pedido_venda 
            from
              Nota_Saida_Item with (nolock) 
            where
              cd_pedido_venda = @cd_pedido_venda and
              dt_cancel_item_nota_saida is null )
    
begin
  --print '05/05/2009' Foi comentado apenas este dia..... a linha abaixo......
  set @cd_pedido_venda = 0
end
  

--Geração da Nota Fiscal


if @cd_pedido_venda > 0
begin
  
  -------------------------------------------------------------------------------
  --Nota de Saída
  -------------------------------------------------------------------------------
  --nota_saida
  --select * from Nota_saida
  --select * from Pedido_Venda
  --select * from Cliente
  --select * from operacao_fiscal

  --Operação Fiscal


  -------------------------------------------------------------------------------
  --Buscar o Número do Formulário
  -------------------------------------------------------------------------------

  select
    @cd_nota_saida                               as cd_nota_saida,
    @cd_nota_saida                               as cd_num_formulario_nota,
    @dt_nota_saida                               as dt_nota_saida,
    null                                         as cd_requisicao_faturamento,
    --Operação Fiscal

    @cd_operacao_fiscal                          as cd_operacao_fiscal,

--      (select
--        top 1 
--        --Consignação
--        case when isnull(pv.ic_consignacao_pedido,'N')='S' and isnull(ofi.cd_oper_fiscal_consig,0)>0 then
--             isnull(ofi.cd_oper_fiscal_consig,0)
--        else      
--           --Operação Triangular
--           case when isnull(pv.ic_operacao_triangular,'N')='S' and isnull(ofi.cd_oper_fiscal_op_triang,0)>0 then
--             isnull(ofi.cd_oper_fiscal_op_triang,0)
--           else
--             --Substituição Tributária
--             case when isnull(ofi.cd_oper_fiscal_subtrib,0)>0 and isnull(pf.ic_substrib_produto,'N')='S' then
--                 isnull(ofi.cd_oper_fiscal_subtrib,0) 
--             else
--                --Amostra
--                case when isnull(ofi.cd_oper_fiscal_amostra,0)>0 and isnull(pv.ic_amostra_pedido_venda,'N')='S' then
--                    isnull(ofi.cd_oper_fiscal_amostra,0)     
--                else
--                   case when isnull(ofi.cd_oper_entrega_futura,0)>0 and isnull(pv.ic_entrega_futura,'N')='S' then
--                       isnull(ofi.cd_oper_entrega_futura,0)
--                   --Operação Fiscal
--                   else
--                     isnull(ofi.cd_operacao_fiscal,0) end
--                end
--             end
--          end
--        end
--      from
--        Operacao_Fiscal ofi with (nolock) 
--      where
--        replace(ofi.cd_mascara_operacao,'.','')  =  (cast(case when e.sg_estado = 'EX' then 7 
--                                                                                  else ep.cd_digito_fiscal_saida end as char(1)) 
--                                                     + 
--                                                     
--                                                     cast(tp.cd_fiscal_tipo_produto as char(5) ))
-- 
--                                                                                               and
-- 
-- 
--        ofi.cd_destinacao_produto                = pv.cd_destinacao_produto                    and
--        isnull(ofi.ic_zfm_operacao_fiscal,'N')   = isnull(ep.ic_zona_franca,'N')               and
--        isnull(ofi.ic_consignacao_op_fiscal,'N') = isnull(pv.ic_consignacao_pedido,'N')        and
--        isnull(ofi.ic_entrega_futura,'N')        = isnull(pv.ic_entrega_futura,'N') 
-- 
--      order by ofi.cd_operacao_fiscal )                     as cd_operacao_fiscal,
-- 

    c.nm_fantasia_cliente                        as nm_fantasia_nota_saida,
    pv.cd_transportadora,
    pv.cd_destinacao_produto,
    null                                         as cd_obs_padrao_nf,
    pv.cd_tipo_pagamento_frete,
    cast('' as varchar)                          as ds_obs_compl_nota_saida,
    null                                         as qt_peso_liq_nota_saida,
    null                                         as qt_peso_bruto_nota_saida,
    null                                         as qt_volume_nota_saida,
    null                                         as cd_especie_embalagem,
    null                                         as nm_especie_nota_saida,
    null                                         as nm_marca_nota_saida,
    null                                         as cd_placa_nota_saida,
    null                                         as nm_numero_emb_nota_saida,
    'N'                                          as ic_emitida_nota_saida,
    null                                         as nm_mot_cancel_nota_saida,
    null                                         as dt_cancel_nota_saida,
    @dt_saida_nota_saida                         as dt_saida_nota_saida,
    @cd_usuario                                  as cd_usuario,
    getdate()                                    as dt_usuario,
    null                                         as vl_bc_icms,
    null                                         as vl_icms,
    null                                         as vl_bc_subst_icms,
    null                                         as vl_produto,
    null                                         as vl_frete,
    null                                         as vl_seguro,
    null                                         as vl_desp_acess,
    null                                         as vl_total,
    null                                         as vl_icms_subst,
    null                                         as vl_ipi,
    pv.cd_vendedor,
    null                                         as cd_fornecedor,
    pv.cd_cliente, 
    null                                         as cd_itinerario,
    null                                         as nm_obs_entrega_nota_saida,
    null                                         as nm_entregador_nota_saida,
    null                                         as cd_observacao_entrega,
    null                                         as cd_entregador,
    null                                         as ic_entrega_nota_saida,
    null                                         as sg_estado_placa,
    pv.cd_pdcompra_pedido_venda                  as cd_pedido_cliente,
    --null                                       as cd_pedido_cliente,
    1                                            as cd_status_nota,
    null                                         as cd_tipo_calculo,
    null                                         as cd_num_formulario,
    c.cd_cnpj_cliente                            as cd_cnpj_nota_saida,
    c.cd_inscestadual                            as cd_inscest_nota_saida,
    c.cd_inscMunicipal                           as cd_inscmunicipal_nota,
    --Entrega
    c.cd_cep                                     as cd_cep_entrega,
    c.nm_endereco_cliente                        as nm_endereco_entrega,
    c.cd_numero_endereco                         as cd_numero_endereco_ent,
    c.nm_complemento_endereco                    as nm_complemento_end_ent,
    c.nm_bairro                                  as nm_bairro_entrega,
    c.cd_ddd                                     as cd_ddd_nota_saida,
    c.cd_telefone                                as cd_telefone_nota_saida,
    c.cd_fax                                     as cd_fax_nota_saida,
    p.nm_pais                                    as nm_pais_nota_saida,
    e.sg_estado                                  as sg_estado_entrega,
    cid.nm_cidade                                as nm_cidade_entrega,
    null                                         as hr_saida_nota_saida,
    c.nm_endereco_cliente                        as nm_endereco_cobranca,
    c.nm_bairro                                  as nm_bairro_cobranca,
    c.cd_cep                                     as cd_cep_cobranca,
    cid.nm_cidade                                as nm_cidade_cobranca,
    e.sg_estado                                  as sg_estado_cobranca,
    c.cd_numero_endereco                         as cd_numero_endereco_cob,
    c.nm_complemento_endereco                    as nm_complemento_end_cob,
    null                                         as qt_item_nota_saida,
    'N'                                          as ic_outras_operacoes,
    @cd_pedido_venda                             as cd_pedido_venda,
    'A'                                          as ic_status_nota_saida,
    cast('' as varchar)                          as ds_descricao_servico,
    null                                         as vl_iss,
    null                                         as vl_servico,
    'N'                                          as ic_minuta_nota_saida,
    @dt_nota_saida + 1                           as dt_entrega_nota_saida,
    e.sg_estado                                  as sg_estado_nota_saida,
    cid.nm_cidade                                as nm_cidade_nota_saida,
    c.nm_bairro                                  as nm_bairro_nota_saida,
    c.nm_endereco_cliente                        as nm_endereco_nota_saida,
    c.cd_numero_endereco                         as cd_numero_end_nota_saida,
    c.cd_cep                                     as cd_cep_nota_saida,
    c.nm_razao_social_cliente                    as nm_razao_social_nota,
    c.nm_razao_social_cliente_c                  as nm_razao_social_c,
    opf.cd_mascara_operacao                      as cd_mascara_operacao,
    opf.nm_operacao_fiscal                       as nm_operacao_fiscal,
    1                                            as cd_tipo_destinatario,
    null                                         as cd_contrato_servico,
    pv.cd_condicao_pagamento,
    null                                         as vl_irrf_nota_saida,
    null                                         as pc_irrf_serv_empresa,
    c.nm_fantasia_cliente                        as nm_fantasia_destinatario,
    c.nm_complemento_endereco                    as nm_compl_endereco_nota,
    'N'                                          as ic_sedex_nota_saida,
    null                                         as ic_coleta_nota_saida,
    null                                         as dt_coleta_nota_saida,
    null                                         as nm_coleta_nota_saida,
    pv.cd_tipo_local_entrega                     as cd_tipo_local_entrega,
    null                                         as ic_dev_nota_saida,
    null                                         as cd_nota_dev_nota_saida,
    null                                         as dt_nota_dev_nota_saida,
    c.nm_razao_social_cliente,
    c.nm_razao_social_cliente_c,
    gof.cd_tipo_operacao_fiscal,
    null                                         as vl_bc_ipi,
    null                                         as cd_mascara_operacao3,
    null                                         as cd_mascara_operacao2,
    null                                         as cd_operacao_fiscal3,
    null                                         as cd_operacao_fiscal2,
    null                                         as nm_operacao_fiscal2,
    null                                         as nm_operacao_fiscal3,
    null                                         as cd_tipo_operacao_fiscal2,
    null                                         as cd_tipo_operacao_fiscal3,
    null                                         as cd_tipo_operacao3,
    null                                         as cd_tipo_operacao2,
    null                                         as ic_zona_franca,
    null                                         as cd_nota_fiscal_origem,
    'A'                                          as ic_forma_nota_saida,
    1                                            as cd_serie_nota,
    pv.cd_vendedor                               as cd_vendedor_externo,
    null                                         as nm_local_entrega_nota,
    c.cd_cnpj_cliente                            as cd_cnpj_entrega_nota,
    c.cd_inscestadual                            as cd_inscest_entrega_nota,
    null                                         as vl_base_icms_reduzida,
    null                                         as vl_bc_icms_reduzida,
    null                                         as cd_dde_nota_saida,
    null                                         as dt_dde_nota_saida,
    null                                         as nm_fat_com_nota_saida,
    null                                         as vl_icms_isento,
    null                                         as vl_icms_outros,
    null                                         as vl_icms_obs,
    null                                         as vl_ipi_isento,
    null                                         as vl_ipi_outros,
    null                                         as vl_ipi_obs,
    'N'                                          as ic_mp66_item_nota_saida,
    'N'                                          as ic_fiscal_nota_saida,
    c.cd_pais,
    1                                            as cd_moeda,
    null                                         as dt_cambio_nota_saida,
    null                                         as vl_cambio_nota_saida,
    null                                         as qt_desconto_nota_saida,
    null                                         as vl_desconto_nota_saida,
    null                                         as qt_peso_real_nota_saida,
    cast('' as varchar)                          as ds_obs_usuario_nota_saida,
    null                                         as ic_obs_usuario_nota_saida,
    null                                         as cd_requisicao_fat_ant,
    null                                         as qt_ord_entrega_nota_saida,
    'N'                                          as ic_credito_icms_nota,
    null                                         as ic_locacao_cilindro_nota,
    null                                         as ic_smo_nota_saida,
    null                                         as cd_di,
    null                                         as cd_guia_trafego_nota_said,
    null                                         as dt_lancamento_entrega,
    null                                         as vl_iss_retido,
    null                                         as vl_cofins,
    null                                         as vl_pis,
    null                                         as vl_csll,
    null                                         as nm_mot_ativacao_nota_saida,
    null                                         as vl_desp_aduaneira,
    null                                         as ic_di_carregada,
    null                                         as vl_ii,
    null                                         as pc_ii,
    null                                         as ic_cupom_fiscal,
    null                                         as cd_cupom_fiscal,
    null                                         as cd_loja,
    null                                         as vl_simbolico,
    cast(@cd_nota_saida as varchar)              as cd_identificacao_nota_saida,
    null                                         as cd_coleta_nota_saida,
    null                                         as qt_ord_entregador_saida,
    null                                         as vl_inss_nota_saida,
    null                                         as pc_inss_servico,
    1                                            as cd_serie_nota_fiscal,
    null                                         as vl_icms_desconto,
    null                                         as ic_etiqueta_nota_saida,
    null                                         as ic_imposto_nota_saida,
    null                                         as qt_cubagem_nota_saida,
    null                                         as ic_peso_recalcular,
    null                                         as qt_formulario_nota_saida,
    null                                         as ic_reprocessar_dados_adic,
    null                                         as vl_mp_aplicada_nota,
    null                                         as vl_mo_aplicada_nota,
    null                                         as ic_reprocessar_parcela,
    null                                         as ic_sel_nota_saida,
    null                                         as cd_ordem_carga,
    pvt.cd_veiculo,
    pvt.cd_motorista,
    ci.cd_forma_pagamento,
   'N'                                            as ic_nfe_nota_saida,
    null                                          as cd_motivo_dev_nota

--select top 1 * from nota_saida
--select * from cliente_informacao_credito

  into
    #Nota_Saida

  from
    Pedido_Venda pv                                with (nolock) 
    inner join Cliente c                           with (nolock) on c.cd_cliente                 = pv.cd_cliente
    left outer join Cliente_Informacao_Credito  ci with (nolock) on ci.cd_cliente                = c.cd_cliente
    left outer join Pedido_Venda_Transporte pvt    with (nolock) on pvt.cd_pedido_venda          = pv.cd_pedido_venda  
    left outer join Pais p                         with (nolock) on p.cd_pais                    = c.cd_pais
    left outer join Estado e                       with (nolock) on e.cd_estado                  = c.cd_estado
    left outer join Cidade cid                     with (nolock) on cid.cd_cidade                = c.cd_cidade
    left outer join Operacao_Fiscal opf            with (nolock) on opf.cd_operacao_fiscal       = @cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof      with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join Estado_Parametro ep            WITH (NOLOCK) on ep.cd_pais                 = c.cd_pais and
                                                                    ep.cd_estado               = c.cd_estado


--select * from pedido_venda
   
  where
    pv.cd_pedido_venda = @cd_pedido_venda

  insert into
    Nota_Saida
  select
    *
  from
    #Nota_Saida

  -------------------------------------------------------------------------------
  --Itens Nota de Saída
  -------------------------------------------------------------------------------
  --select * from nota_saida_item
  --select * from pedido_venda_item
  --select * from produto_fiscal
  --select * from classificacao_fiscal

  select
    @cd_nota_saida                                   as cd_nota_saida,
    identity(int,1,1)                                as cd_item_nota_saida,
    @cd_nota_saida                                   as cd_num_formulario_nota,
    p.nm_fantasia_produto,
    cast('' as varchar)                              as ds_item_nota_saida,
    cast(pvi.cd_pdcompra_item_pedido as varchar(40)) as cd_pd_compra_item_nota,
    pvi.cd_posicao_item_pedido                       as cd_posicao_item_nota,
    pvi.cd_os_tipo_pedido_venda                      as cd_os_item_nota_saida,
    pvi.vl_unitario_item_pedido                      as vl_unitario_item_nota,
    null                                             as dt_restricao_item_nota,
    'A'                                              as ic_status_item_nota_saida,
    cast('' as varchar)                              as nm_motivo_restricao_item,
    null                                             as qt_devolucao_item_nota,
    null                                             as cd_requisicao_faturamento,
    null                                             as cd_item_requisicao,
    pvi.cd_produto,
    pf.cd_procedencia_produto,
    pf.cd_tributacao,

    --Total do Item

    pvi.qt_item_pedido_venda
    * pvi.vl_unitario_item_pedido                    as vl_total_item,
    pvi.cd_unidade_medida,
    pf.pc_aliquota_icms_produto                  as pc_icms,
    cf.pc_ipi_classificacao                      as pc_ipi,
    cf.vl_ipi_classificacao                      as vl_ipi,
    @cd_usuario                                  as cd_usuario,
    getdate()                                    as dt_usuario,
    qt_saldo_pedido_venda                        as qt_item_nota_saida,
    pvi.qt_liquido_item_pedido                   as qt_liquido_item_nota,
    pvi.qt_bruto_item_pedido                     as qt_bruto_item_nota_saida,
    pvi.cd_item_pedido_venda,
    pvi.cd_pedido_venda,
    p.cd_categoria_produto,
    pf.cd_classificacao_fiscal,

    --Situação

    cast(cast(isnull(pp.cd_digito_procedencia,'0') as varchar(1)) + 
        ti.cd_digito_tributacao_icms  as varchar(3)) as cd_situacao_tributaria,

    pvi.vl_frete_item_pedido                     as vl_frete_item,
    null                                         as vl_seguro_item,
    null                                         as vl_desp_acess_item,
    null                                         as pc_icms_desc_item,
    null                                         as dt_cancel_item_nota_saida,
    null                                         as pc_desconto_item,
    null                                         as cd_tipo_calculo,
    null                                         as cd_lote_produto,
    null                                         as cd_numero_serie_produto,
    1                                            as cd_status_nota,
    p.nm_produto                                 as nm_produto_item_nota,
    null                                         as qt_saldo_atual_produto,
    null                                         as cd_servico,
    cast(null as varchar)                        as ds_servico,
    null                                         as pc_iss_servico,
    null                                         as vl_servico,
    null                                         as pc_irrf_serv_empresa,
    null                                         as vl_irrf_nota_saida,
    null                                         as vl_iss_servico,
    null                                         as pc_reducao_icms,
    null                                         as cd_pdcompra_item_nota,
  --pvi.cd_pdcompra_item_pedido                  as cd_pdcompra_item_nota,
    null                                         as cd_registro_exportacao,
--  @cd_operacao_fiscal                          as cd_operacao_fiscal,

     (select
       top 1 
       --Consignação
       case when isnull(pv.ic_consignacao_pedido,'N')='S' and isnull(ofi.cd_oper_fiscal_consig,0)>0 then
            isnull(ofi.cd_oper_fiscal_consig,0)
       else      
          --Operação Triangular
          case when isnull(pv.ic_operacao_triangular,'N')='S' and isnull(ofi.cd_oper_fiscal_op_triang,0)>0 then
            isnull(ofi.cd_oper_fiscal_op_triang,0)
          else
            --Substituição Tributária
            case when isnull(ofi.cd_oper_fiscal_subtrib,0)>0 and isnull(pf.ic_substrib_produto,'N')='S' then
                isnull(ofi.cd_oper_fiscal_subtrib,0) 
            else
               --Amostra
               case when isnull(ofi.cd_oper_fiscal_amostra,0)>0 and isnull(pv.ic_amostra_pedido_venda,'N')='S' then
                   isnull(ofi.cd_oper_fiscal_amostra,0)     
               else
                 --Bonificação---
                   case when isnull(ofi.cd_oper_fiscal_bonif,0)>0 and isnull(pv.ic_bonificacao_pedido_venda,'N')='S' then
                      isnull(ofi.cd_oper_fiscal_bonif,0)     
                   else 
                    --Entrega Futura
                     case when isnull(ofi.cd_oper_entrega_futura,0)>0 and isnull(pv.ic_entrega_futura,'N')='S' then
                         isnull(ofi.cd_oper_entrega_futura,0)
                    --Operação Fiscal
                     else
                       isnull(ofi.cd_operacao_fiscal,0) 
                     end
                   end
               end
            end
         end
       end
     from
       Operacao_Fiscal ofi with (nolock) 
     where
       replace(ofi.cd_mascara_operacao,'.','')  =  (cast(case when e.sg_estado = 'EX' then 7 
                                                                                 else ep.cd_digito_fiscal_saida end as char(1)) 
                                                    + 
                                                    
                                                    cast(tp.cd_fiscal_tipo_produto as char(5) ))

                                                                                              and


       ofi.cd_destinacao_produto                = pv.cd_destinacao_produto                    and
       isnull(ofi.ic_zfm_operacao_fiscal,'N')   = isnull(ep.ic_zona_franca,'N')               and
       isnull(ofi.ic_consignacao_op_fiscal,'N') = isnull(pv.ic_consignacao_pedido,'N')        and
       isnull(ofi.ic_entrega_futura,'N')        = isnull(pv.ic_entrega_futura,'N') 

     order by ofi.cd_operacao_fiscal )

                                                 as cd_operacao_fiscal,

    'P'                                          as ic_tipo_nota_saida_item,
    null                                         as qt_saldo_estoque,
    null                                         as cd_di,
    null                                         as nm_di,
    null                                         as nm_invoice,
    'N'                                          as ic_movimento_estoque,
    null                                         as qt_ant_item_nota_saida,
    null                                         as nm_kardex_item_nota_saida,
    null                                         as ic_dev_nota_saida,
    null                                         as cd_nota_dev_nota_saida,
    null                                         as cd_pedido_importacao,
    null                                         as cd_item_ped_imp,
    null                                         as dt_nota_saida,
    p.cd_grupo_produto,
    null                                         as vl_icms_item,
    null                                         as vl_base_icms_item,
    null                                         as vl_base_ipi_item,
    null                                         as pc_subs_trib_item,
    null                                         as cd_reg_exportacao_item,
    null                                         as vl_icms_isento_item,
    null                                         as vl_icms_outros_item,
    null                                         as vl_icms_obs_item,
    null                                         as vl_ipi_isento_item,
    null                                         as vl_ipi_outros_item,
    null                                         as vl_ipi_obs_item,
    case when isnull(p.cd_fase_produto_baixa,0)>0
    then
      p.cd_fase_produto_baixa
    else
      @cd_fase_produto
    end                                          as cd_fase_produto,
    'N'                                          as ic_mp66_item_nota_saida,
    p.cd_mascara_produto,
    null                                         as cd_conta,
    null                                         as cd_produto_smo,
    null                                         as cd_grupo_produto_smo,
    null                                         as vl_ipi_corpo_nota_saida,
    null                                         as ic_icms_zerado_item,
    null                                         as ic_ipi_zerado_item,
    null                                         as vl_bc_subst_icms_item,
    null                                         as cd_tributacao_anterior,
    null                                         as cd_di_item,
    null                                         as ic_iss_servico,
    null                                         as vl_cofins,
    null                                         as vl_pis,
    null                                         as vl_csll,
    null                                         as dt_ativacao_nota_saida,
    null                                         as cd_moeda_cotacao,
    null                                         as vl_moeda_cotacao,
    null                                         as dt_moeda_cotacao,
    null                                         as cd_lote_item_nota_saida,
    null                                         as cd_num_serie_item_nota,
    null                                         as vl_ii,
    null                                         as pc_ii,
    null                                         as vl_desp_aduaneira_item,
    null                                         as pc_cofins,
    null                                         as pc_pis,
    null                                         as ic_cambio_fixado_pedido_venda,
    null                                         as ic_perda_item_nota_saida,
    null                                         as cd_lote_item_nota,
    null                                         as vl_inss_nota_saida,
    null                                         as pc_inss_servico,
    null                                         as vl_icms_desc_item,
    null                                         as vl_icms_subst_icms_item,
    null                                         as qt_cubagem_item_nota,
    null                                         as cd_rnc,
    null                                         as cd_nota_entrada,
    null                                         as cd_item_nota_entrada,
    null                                         as ic_subst_tributaria_item,
    null                                         as cd_nota_saida_origem,
    null                                         as cd_item_nota_origem,
    null                                         as vl_unitario_ipi_produto,
    null                                         as qt_multiplo_embalagem,
    null                                         as cd_motivo_dev_nota,
    null                                         as pc_reducao_icms_st

--select top 1 * from nota_saida_item

  into
    #Nota_Saida_Item

  from
    Pedido_Venda_Item pvi                   with (nolock) 
    inner join Pedido_Venda pv              with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda
--  inner join Nota_Saida ns                with (nolock) on ns.cd_nota_saida           = @cd_nota_saida
    inner join Produto p                    with (nolock) on pvi.cd_produto             = p.cd_produto
    left outer join Produto_Fiscal pf       with (nolock) on pf.cd_produto              = p.cd_produto 
    left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal 
    left outer join Procedencia_Produto  pp with (nolock) on pp.cd_procedencia_produto  = pf.cd_procedencia_produto
    left outer join Tipo_Produto         tp WITH(NOLOCK)  on tp.cd_tipo_produto         = pf.cd_tipo_produto   

    left outer join tributacao           tr with (nolock) on tr.cd_tributacao           = pf.cd_tributacao
    left outer join Tributacao_ICMS      ti with (nolock) on ti.cd_tributacao_icms      = tr.cd_tributacao_icms
    left outer join Cliente c               WITH (NOLOCK) on c.cd_cliente               = pv.cd_cliente         

    left outer join Estado e                with(nolock)  on e.cd_estado                = c.cd_estado and
                                                             e.cd_pais                  = c.cd_pais

    left outer join Estado_Parametro ep     WITH (NOLOCK) on ep.cd_pais                 = c.cd_pais and
                                                             ep.cd_estado               = c.cd_estado

    left outer join Unidade_Medida um       with (nolock) on um.cd_unidade_medida       = pvi.cd_unidade_medida

-- Comentado 5/5/2009
--     left outer join Produto_Saldo pso        with (nolock) on pso.cd_produto              = p.cd_produto and
--                                                              pso.cd_fase_produto         = 
--                                                              case when isnull(p.cd_fase_produto_baixa,0)>0 then 
--                                                                  p.cd_fase_produto_baixa 
--                                                                else
--                                                                  @cd_fase_produto
--                                                                end
-- 
--     left outer join Produto_Saldo ps        with (nolock) on ps.cd_produto              = p.cd_produto and
--                                                              ps.cd_fase_produto         = 
--                                                              case when isnull(um.cd_fase_produto,0)>0 then
--                                                                um.cd_fase_produto
--                                                              else
--                                                                case when isnull(p.cd_fase_produto_baixa,0)>0 then 
--                                                                  p.cd_fase_produto_baixa 
--                                                                else
--                                                                  @cd_fase_produto
--                                                                end
--                                                              end


--select cd_pais,cd_estado_nota_saida,* from nota_saida
--select * from procedencia_produto
--select * from tributacao_icms

  where
    pvi.cd_pedido_venda = @cd_pedido_venda and
    isnull(pvi.qt_saldo_pedido_venda,0)>0  --Somente os pedidos com Saldo

    --Saldo do Produto
    --(isnull(pso.qt_saldo_atual_produto,0)>=pvi.qt_saldo_pedido_venda or 
    -- isnull(ps.qt_saldo_atual_produto,0)>=pvi.qt_saldo_pedido_venda )


--select * from #Nota_Saida_Item

--select * from pedido_venda_item
--select * from produto_fiscal
--select * from procedencia_produto
--select * from tributacao_icms
--select * from nota_saida_item

  insert into Nota_Saida_Item
    select * from #Nota_Saida_item

  --Verifica se Existe itens na Tabela de Itens ( Se não tiver deleta a Nota e Não ajusta o Pedido de Venda )
  
  if exists ( select top 1 cd_nota_saida
              from
                 nota_saida_item
              where
                 cd_pedido_venda = @cd_pedido_venda )
  begin

    --Atualiza o Pedido de Venda

    update
      pedido_venda
    set
      cd_status_pedido = 2  --Pedido Fechado
    where
      cd_pedido_venda = @cd_pedido_venda


    --Atualiza o Saldo dos Itens do Pedido de Venda

    update
      pedido_venda_item
    set
      qt_saldo_pedido_venda = 0 --Saldo Zerado do Item do Pedido de Venda
    where
      cd_pedido_venda = @cd_pedido_venda

  end

  else
    --Deleta a Nota Fiscal que foi gerada sem Itens
    begin
      delete from nota_saida where cd_nota_saida = @cd_nota_saida
    end

  --select * from status_pedido


  --Atualiza a Situação do Pedido


  
  -------------------------------------------------------------------------------
  --Cálculo da Nota Fiscal de Saída
  --Valores Totais, Peso e Impostos
  -------------------------------------------------------------------------------

  declare @cd_item_nota_saida   int
  declare @vl_total             decimal(25,2)
  declare @vl_bc_icms           decimal(25,2)
  declare @vl_icms              decimal(25,2)
  declare @vl_bc_subst_icms     decimal(25,2)
  declare @vl_produto           decimal(25,2)
  declare @vl_frete             decimal(25,2)
  declare @vl_seguro            decimal(25,2)
  declare @vl_desp_acess        decimal(25,2)
  declare @vl_icms_subst        decimal(25,2)
  declare @vl_ipi               decimal(25,2)

  set @vl_total             = 0.00
  set @vl_bc_icms           = 0.00
  set @vl_icms              = 0.00
  set @vl_bc_subst_icms     = 0.00
  set @vl_produto           = 0.00
  set @vl_frete             = 0.00
  set @vl_seguro            = 0.00
  set @vl_desp_acess        = 0.00
  set @vl_icms_subst        = 0.00
  set @vl_ipi               = 0.00

  while exists( select top 1 cd_item_nota_saida 
                from #Nota_Saida_Item
                where
                  cd_nota_saida = @cd_nota_saida)
  begin

    --select * from nota_saida_item

    select
      top 1
      @cd_item_nota_saida = isnull(cd_item_nota_saida,0),
      @cd_operacao_fiscal = case when isnull(cd_operacao_fiscal,0)=0 then @cd_operacao_fiscal else cd_operacao_fiscal end,
      @vl_produto         = @vl_produto + isnull(vl_total_item,0),
      @vl_total           = @vl_total   + isnull(vl_total_item,0)
    from
      #Nota_Saida_item
    where
      cd_nota_saida      = @cd_nota_saida      

  
    --Cálculo

    --Cálculo do Peso / Volumes


    --Atualiza o Item da Nota fiscal


    --Próximo Item / Deleta da Tabela Temporária

    Delete from #Nota_Saida_item
    where
      cd_nota_saida      = @cd_nota_saida      and
      cd_item_nota_saida = @cd_item_nota_saida
    
  end

  --Verifica se a Natureza de Operação
  declare @cd_operacao int

  select 
    top 1
    @cd_operacao = case when isnull(cd_operacao_fiscal,0)=0 then @cd_operacao_fiscal else cd_operacao_fiscal end
  from
    nota_saida_item with (nolock) 
  where
      cd_nota_saida      = @cd_nota_saida       
      ---and
      --cd_item_nota_saida = @cd_item_nota_saida
  order by 
      cd_item_nota_saida

  if @cd_operacao>0 and @cd_operacao_fiscal <> @cd_operacao
     set @cd_operacao_fiscal = @cd_operacao

  --select * from nota_saida_item

  --Atualiza a Nota Fiscal Dados e Cálculo da Nota Fiscal

  update
    Nota_Saida
  set
    cd_operacao_fiscal      = opf.cd_operacao_fiscal,
    cd_mascara_operacao     = opf.cd_mascara_operacao,
    nm_operacao_fiscal      = opf.nm_operacao_fiscal,
    cd_tipo_operacao_fiscal = gof.cd_tipo_operacao_fiscal,
    vl_total                = @vl_total,
    vl_bc_icms              = @vl_bc_icms,
    vl_icms                 = @vl_icms,
    vl_bc_subst_icms        = @vl_bc_subst_icms,
    vl_produto              = @vl_produto,
    vl_frete                = @vl_frete,
    vl_seguro               = @vl_seguro,
    vl_desp_acess           = @vl_desp_acess,
    vl_icms_subst           = @vl_icms_subst,
    vl_ipi                  = @vl_ipi

  from
    Nota_Saida ns                             
    inner join Operacao_Fiscal opf            on opf.cd_operacao_fiscal       = @cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal

  where
    cd_nota_saida = @cd_nota_saida

--  print 'parcela'  

  -------------------------------------------------------------------------------
  --Parcelas Nota de Saída
  -------------------------------------------------------------------------------
  --Nota_Saida_Parcela

  if @cd_nota_saida > 0 and @vl_total>0 
  begin

     --drop table controle_nota_saida
     --CREATE TABLE controle_nota_saida(cd_nota_saida INT )

     insert into
       controle_nota_saida
     select
       @cd_nota_saida as cd_nota_saida

     --Deleta a Parcela
     delete from nota_saida_parcela 
     where
       cd_nota_saida = @cd_nota_saida

     --Geração da Parcela

     while not exists ( select top 1 cd_nota_saida 
                        from 
                          nota_saida_parcela with (nolock) 
                     where
                        cd_nota_saida = @cd_nota_saida )
     begin

        exec pr_gerar_parcela 3, @cd_nota_saida, @cd_usuario

     end

  end

--  print 'fim parcela'

  -------------------------------------------------------------------------------

--  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_nota_saida, 'D'
--  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_nota_saida, 'D'

end
  
