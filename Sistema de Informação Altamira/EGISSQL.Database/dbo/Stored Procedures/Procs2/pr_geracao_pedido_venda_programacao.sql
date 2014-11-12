
CREATE PROCEDURE pr_geracao_pedido_venda_programacao
@cd_cliente            int = 0,
@cd_usuario            int = 0,
@dt_entrega            datetime = null,
@dt_pedido_venda       datetime 

as

if @dt_entrega is null
begin
   set @dt_entrega = cast(convert(int,getdate(),103) as datetime)
end

if @dt_pedido_venda is null
begin
  set @dt_pedido_venda =  cast(convert(int,getdate()-1,103) as datetime)
end

--select * from cliente

select
  pe.cd_cliente,
  max(ep.pc_aliquota_icms_estado) as pc_icms_estado_cliente
into
  #ClientePedido
from
  programacao_entrega_remessa per   with (nolock)
  inner join Programacao_Entrega pe with (nolock) on pe.cd_programacao_entrega = per.cd_programacao_entrega
  inner join Cliente c              with (nolock) on c.cd_cliente              = pe.cd_cliente
  inner join Estado_Parametro ep    with (nolock) on c.cd_pais                 = ep.cd_pais and c.cd_estado = ep.cd_estado
where
  pe.cd_cliente = case when @cd_cliente = 0 then pe.cd_cliente else @cd_cliente end and
  isnull(pe.ic_selecao_programacao,'N')='S' and
  isnull(per.cd_pedido_venda,0)        = 0
group by
  pe.cd_cliente


--select * from #ClientePedido

declare @cd_pedido_venda        int
--declare @dt_pedido_venda        datetime
declare @pc_icms_estado_cliente float

declare @sg_estado_cliente            varchar(2),  
        @cd_destinacao_produto        integer,
        @cd_estado                    int,
        @cd_pais                      int

set @cd_pedido_venda = 0


declare @Tabela	     varchar(50)

set @Tabela      = cast(DB_NAME()+'.dbo.Pedido_Venda' as varchar(50))


while exists ( select top 1 cd_cliente from #ClientePedido )
begin
  select top 1
    @cd_cliente             = cd_cliente,
    @pc_icms_estado_cliente = isnull(pc_icms_estado_cliente,0)
  from
    #ClientePedido

  while @cd_pedido_venda = 0 
  begin

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_pedido_venda output

    --Verifica se Existe o Pedido na Tabela

    if not exists(select cd_pedido_venda from pedido_venda where @cd_pedido_venda=cd_pedido_venda )
    begin

      --set @dt_pedido_venda = dbo.fn_data( getdate() )
      --set @dt_pedido_venda = convert(nvarchar, getdate() - Convert(nvarchar, getdate(),114),101)
      --set @dt_pedido_venda = getdate()      

      set @dt_pedido_venda =  cast(convert(int,getdate()-1,103) as datetime)

      --Montagem da Tabela Temporária

      select
        @cd_pedido_venda                                             as cd_pedido_venda,
        @dt_pedido_venda                                             as dt_pedido_venda,
        c.cd_vendedor                                                as cd_vendedor_pedido,
        c.cd_vendedor_interno                                        as cd_vendedor_interno,
        'N'                                                          as ic_emitido_pedido_venda,
        cast('Geração Automática Programação de Entrega' as varchar) as ds_pedido_venda,
        cast('' as varchar)                                          as ds_pedido_venda_fatura,
        cast('' as varchar)                                          as ds_cancelamento_pedido,
        @cd_usuario                                                  as cd_usuario_credito_pedido,
        getdate()                                                    as dt_credito_pedido_venda,
        'N'                                                          as ic_smo_pedido_venda,
        0.00                                                         as vl_total_pedido_venda,
        0.00                                                         as qt_liquido_pedido_venda,
        0.00                                                         as qt_bruto_pedido_venda,
        getdate()                                                    as dt_conferido_pedido_venda,
        'S'                                                          as ic_pcp_pedido_venda,
        'N'                                                          as ic_lista_pcp_pedido_venda,
        'S'                                                          as ic_processo_pedido_venda,
        'N'                                                          as ic_lista_processo_pedido,
        'N'                                                          as ic_imed_pedido_venda,
        'N'                                                          as ic_lista_imed_pedido,
        null                                                         as nm_alteracao_pedido_venda,
        'N'                                                          as ic_consignacao_pedido,
        null                                                         as dt_cambio_pedido_venda,
        null                                                         as cd_cliente_entrega,
        'N'                                                          as ic_op_triang_pedido_venda,
        'N'                                                          as ic_nf_op_triang_pedido,
        null                                                         as nm_contato_op_triang,
        null                                                         as cd_pdcompra_pedido_venda,
        null                                                         as cd_processo_exportacao,
        @cd_cliente                                                  as cd_cliente,
        null                                                         as cd_tipo_frete,
        null                                                         as cd_tipo_restricao_pedido,
        c.cd_destinacao_produto,
        1                                                            as cd_tipo_pedido,
        c.cd_transportadora,
        c.cd_vendedor,
        1                                                            as cd_tipo_endereco,
        isnull(c.cd_moeda,1)                                         as cd_moeda,
        --Contato Verificar como buscar o contato responsável pela programação
        null                                                         as cd_contato,
      
        @cd_usuario                                                  as cd_usuario,
        getdate()                                                    as dt_usuario,
        null                                                         as dt_cancelamento_pedido,
        c.cd_condicao_pagamento,
        1                                                            as cd_status_pedido,
        --Total
        1                                                            as cd_tipo_entrega_produto,
        null                                                         as nm_referencia_consulta,
        0.00                                                         as vl_custo_financeiro,
        null                                                         as ic_custo_financeiro,
        0.00                                                         as vl_tx_mensal_cust_fin,
        c.cd_tipo_pagamento_frete,
        null                                                         as nm_assina_pedido,
        'N'                                                          as ic_fax_pedido,
        'N'                                                          as ic_mail_pedido,
        0.00                                                         as vl_total_pedido_ipi,
        0.00                                                         as vl_total_ipi,
        cast('' as varchar)                                          as ds_observacao_pedido,
        @cd_usuario                                                  as cd_usuario_atendente,
        'S'                                                          as ic_fechado_pedido,
        'N'                                                          as ic_vendedor_interno,
        null                                                         as cd_representante,
        'N'                                                          as ic_transf_matriz,
        'N'                                                          as ic_digitacao,
        'S'                                                          as ic_pedido_venda,
         null                                                        as hr_inicial_pedido,
        'N'                                                          as ic_outro_cliente,
        'S'                                                          as ic_fechamento_total,
        'N'                                                          as ic_operacao_triangular,
        'N'                                                          as ic_fatsmo_pedido,
        cast('' as varchar)                                          as ds_ativacao_pedido,
        null                                                         as dt_ativacao_pedido,
        cast('' as varchar)                                          as ds_obs_fat_pedido,
        'N'                                                          as ic_obs_corpo_nf,
        getdate()                                                    as dt_fechamento_pedido,
        null                                                         as cd_cliente_faturar,
        1                                                            as cd_tipo_local_entrega,
        'N'                                                          as ic_etiq_emb_pedido_venda,
        null                                                         as cd_consulta,
        null                                                         as dt_alteracao_pedido_venda,
        null                                                         as ic_dt_especifica_ped_vend,
        null                                                         as ic_dt_especifica_consulta,
        'N'                                                          as ic_fat_pedido_venda,
        'N'                                                          as ic_fat_total_pedido_venda,
        0.00                                                         as qt_volume_pedido_venda,
        0.00                                                         as qt_fatpbru_pedido_venda,
        'N'                                                          as ic_permite_agrupar_pedido,
        0.00                                                         as qt_fatpliq_pedido_venda,
        0.00                                                         as vl_indice_pedido_venda,
        0.00                                                         as vl_sedex_pedido_venda,
        0.00                                                         as pc_desconto_pedido_venda,
        0.00                                                         as pc_comissao_pedido_venda,
        null                                                         as cd_plano_financeiro,
       cast('' as varchar)                                           as ds_multa_pedido_venda,
        0.00                                                         as vl_freq_multa_ped_venda,
        0.00                                                         as vl_base_multa_ped_venda,
        0.00                                                         as pc_limite_multa_ped_venda,
        0.00                                                         as pc_multa_pedido_venda,
        null                                                         as cd_fase_produto_contrato,
        null                                                         as nm_obs_restricao_pedido,
        null                                                         as cd_usu_restricao_pedido,
        null                                                         as dt_lib_restricao_pedido,
        null                                                         as nm_contato_op_triang_ped,
        'N'                                                          as ic_amostra_pedido_venda,
        'N'                                                          as ic_alteracao_pedido_venda,
        'N'                                                          as ic_calcula_sedex,
        0.00                                                         as vl_frete_pedido_venda,
        'N'                                                          as ic_calcula_peso,
        'N'                                                          as ic_subs_trib_pedido_venda,
        'N'                                                          as ic_credito_icms_pedido,
        null                                                         as cd_usu_lib_fat_min_pedido,
        null                                                         as dt_lib_fat_min_pedido,
        null                                                         as cd_identificacao_empresa,
        0.00                                                         as pc_comissao_especifico,
        null                                                         as dt_ativacao_pedido_venda,
        null                                                         as cd_exportador,
        'N'                                                          as ic_atualizar_valor_cambio_fat,
        null                                                         as cd_tipo_documento,
        null                                                         as cd_loja,
        null                                                         as cd_usuario_alteracao,
        'N'                                                          as ic_garantia_pedido_venda,
        null                                                         as cd_aplicacao_produto,
        'N'                                                          as ic_comissao_pedido_venda,
        null                                                         as cd_motivo_liberacao,
        'N'                                                          as ic_entrega_futura,
        null                                                         as modalidade,
        null                                                         as modalidade1,
        null                                                         as cd_modalidade,
        null                                                         as cd_pedido_venda_origem,
        getdate()                                                    as dt_entrada_pedido,
        null                                                         as dt_cond_pagto_pedido,
        null                                                         as cd_usuario_cond_pagto_ped,
        0.00                                                         as vl_credito_liberacao,
        0.00                                                         as vl_credito_liberado,
        null                                                         as cd_centro_custo,
        'N'                                                          as ic_bloqueio_licenca,
        null                                                         as cd_licenca_bloqueada,
        null                                                         as nm_bloqueio_licenca,
        null                                                         as dt_bloqueio_licenca,
        null                                                         as cd_usuario_bloqueio_licenca,
        null                                                         as vl_mp_aplicacada_pedido,
        null                                                         as vl_mo_aplicada_pedido,
        null                                                         as cd_usuario_impressao,
        null                                                         as cd_cliente_origem,
        null                                                         as cd_situacao_pedido,
        null                                                         as qt_total_item_pedido,
        null                                                         as ic_bonificacao_pedido_venda,
        null                                                         as pc_promocional_pedido

--select * from pedido_venda
       
      into #Pedido_Venda
      from
       Cliente c with (nolock) 
      where
        c.cd_cliente = @cd_cliente

      --select * from cliente
      --select * from #Pedido_Venda

      insert into
         Pedido_Venda
      select
        *
      from
        #Pedido_Venda

      --Geração da Situação do Pedido de Venda

      --Entrada do Pedido

      exec pr_gera_historico_pedido
         1,
         @cd_pedido_venda,
         0,
         570,                     --Histórico
         @dt_pedido_venda,      
         '',
         'Gerado na Programação',
         '',
         '',
         @cd_usuario

      --Itens do Pedido de Venda
      Select top 1 @sg_estado_cliente     = e.sg_estado,  
                   @cd_destinacao_produto = c.cd_destinacao_produto,
                   @cd_estado             = cli.cd_estado,
                   @cd_pais               = cli.cd_pais 
      from   
 		Pedido_Venda c 
                inner join  Cliente cli on c.cd_cliente = cli.cd_cliente 
                inner join  Estado e    on cli.cd_estado = e.cd_estado  
      where  
        c.cd_pedido_venda = @cd_pedido_venda and
        cli.cd_cliente    = @cd_cliente 

      --select * from programacao_entrega
      --select * from programacao_entrega_remessa

      select
        pe.cd_produto,
--        sum(isnull(qt_programacao_entrega,0)) as qt_programacao_entrega,
        --Quantidade Selecionada
        sum(isnull(per.qt_remessa_produto,0)) as qt_programacao_entrega,
        max(pe.cd_programacao_entrega)        as cd_programacao_entrega,
        max(pe.dt_necessidade_entrega)        as dt_necessidade_entrega,
        max(pe.dt_usuario)                    as dt_usuario,
        max(pe.cd_pedido_compra_programacao)  as cd_pedido_compra_programacao,
        max(pe.cd_movimento_estoque)          as cd_movimento_estoque,
        max(pe.dt_programacao_entrega)        as dt_programacao_entrega,
        max(pe.cd_cliente)                    as cd_cliente
      into
        #ItemAgrupado
      from
        programacao_entrega_remessa per   with (nolock)
        inner join programacao_entrega pe with (nolock) on pe.cd_programacao_entrega = per.cd_programacao_entrega
      where
        pe.cd_cliente                         = @cd_cliente and
        isnull(per.cd_pedido_venda,0)         = 0 and
        isnull(pe.ic_selecao_programacao,'N') = 'S'
      group by
        pe.cd_produto

      --Programações geradadas

      select
        pe.cd_programacao_entrega,
        pe.cd_produto
      into
        #AtualizacaoProgramacao
      from
        Programacao_Entrega_Remessa per
        inner join programacao_entrega pe on pe.cd_programacao_entrega = per.cd_programacao_entrega
  
      where
        pe.cd_cliente                         = @cd_cliente and
        isnull(per.cd_pedido_venda,0)          = 0 and
        isnull(pe.ic_selecao_programacao,'N') = 'S'

      --Itens do Pedido de Venda 

      select
        @cd_pedido_venda                as cd_pedido_venda,
        identity(int,1,1)               as cd_item_pedido_venda,
        @dt_pedido_venda                as dt_item_pedido_venda,
        pe.qt_programacao_entrega       as qt_item_pedido_venda,
        pe.qt_programacao_entrega       as qt_saldo_pedido_venda,
        pe.dt_necessidade_entrega       as dt_entrega_vendas_pedido,
        @dt_entrega                     as dt_entrega_fabrica_pedido,
        cast('' as varchar)             as ds_produto_pedido_venda,
        p.vl_produto                    as vl_unitario_item_pedido,
        p.vl_produto                    as vl_lista_item_pedido,
        0.00                            as pc_desconto_item_pedido,
        null                            as dt_cancelamento_item,
        pe.dt_usuario                   as dt_estoque_item_pedido,
        pe.cd_pedido_compra_programacao as cd_pdcompra_item_pedido,
        null                            as dt_reprog_item_pedido,
        p.qt_peso_liquido               as qt_liquido_item_pedido,
        p.qt_peso_bruto                 as qt_bruto_item_pedido,
       'N'                              as ic_fatura_item_pedido,
        case when isnull(pe.cd_movimento_estoque,0)>0
        then 'S'
        else 'N' end                      as ic_reserva_item_pedido,
        null                              as ic_tipo_montagem_item,
        null                              as ic_montagem_g_item_pedido,
        null                              as ic_subs_tributaria_item,
        null                              as cd_posicao_item_pedido,
        null                              as cd_os_tipo_pedido_venda,
        null                              as ic_desconto_item_pedido,
        null                              as dt_desconto_item_pedido,
        null                              as vl_indice_item_pedido,
        p.cd_grupo_produto,
        p.cd_produto,
        p.cd_grupo_categoria,
        p.cd_categoria_produto,
        null                                  as cd_pedido_rep_pedido,
        null                                  as cd_item_pedidorep_pedido,
        null                                  as cd_ocorrencia,
        null                                  as cd_consulta,
        @cd_usuario                           as cd_usuario,
        getdate()                             as dt_usuario,
        null                                  as nm_mot_canc_item_pedido,
        null                                  as nm_obs_restricao_pedido,
        null                                  as cd_item_consulta,
        null                                  as ic_etiqueta_emb_pedido,
--select * from classificacao_fiscal
        isnull(cf.pc_ipi_classificacao,0)     as pc_ipi_item,
        isnull(@pc_icms_estado_cliente,0)     as pc_icms_item,
        0.00                                  as pc_reducao_base_item,
        @dt_entrega                           as dt_necessidade_cliente,
        cast(@dt_entrega - pe.dt_programacao_entrega as int ) as qt_dia_entrega_cliente,
        @dt_entrega                                           as dt_entrega_cliente,
        'N'                                                   as ic_smo_item_pedido_venda,
        null                                                  as cd_om,
       'S'                                                    as ic_controle_pcp_pedido,
        null                                                  as nm_mat_canc_item_pedido,
        null                                                  as cd_servico,
        'N'                                                   as ic_produto_especial,
        null                                                  as cd_produto_concorrente,
        null                                                  as ic_orcamento_pedido_venda,
        cast('' as varchar)                                   as ds_produto_pedido,
        p.nm_produto                                          as nm_produto_pedido,
        p.cd_serie_produto,
        isnull(cf.pc_ipi_classificacao,0)                     as pc_ipi,
        isnull(@pc_icms_estado_cliente,0)                     as pc_icms,
        cast(@dt_entrega - pe.dt_programacao_entrega as int ) as qt_dia_entrega_pedido,
        'S'                                                   as ic_sel_fechamento,
        null                                                  as dt_ativacao_item,
        null                                                  as nm_mot_ativ_item_pedido,
        p.nm_fantasia_produto,
        'N'                                                   as ic_etiqueta_emb_ped_venda,
        getdate()                                             as dt_fechamento_pedido,
        cast('' as varchar)                                   as ds_progfat_pedido_venda,
        'P'                                                   as ic_pedido_venda_item,
        null                                                  as ic_ordsep_pedido_venda,
        null                                                  as ic_progfat_item_pedido,
        null                                                  as qt_progfat_item_pedido,
        null                                                  as cd_referencia_produto,
        'S'                                                   as ic_libpcp_item_pedido,
        cast('' as varchar)                                   as ds_observacao_fabrica,
        null                                                  as nm_observacao_fabrica1,
        null                                                  as nm_observacao_fabrica2,
        p.cd_unidade_medida,
        null                                                  as pc_reducao_icms,
        null                                                  as pc_desconto_sobre_desc,
        null                                                  as nm_desconto_item_pedido,
        null                                                  as cd_item_contrato,
        null                                                  as cd_contrato_fornecimento,
        null                                                  as nm_kardex_item_ped_venda,
        null                                                  as ic_gprgcnc_pedido_venda,
        null                                                  as cd_pedido_importacao,
        null                                                  as cd_item_pedido_importacao,
        null                                                  as dt_progfat_item_pedido,
        null                                                  as qt_cancelado_item_pedido,
        null                                                  as qt_ativado_pedido_venda,
        null                                                  as cd_mes,
        null                                                  as cd_ano,
        null                                                  as ic_mp66_item_pedido,
        null                                                  as ic_montagem_item_pedido,
        null                                                  as ic_reserva_estrutura_item,
        null                                                  as ic_estrutura_item_pedido,
        null                                                  as vl_frete_item_pedido,
        null                                                  as cd_usuario_lib_desconto,
        null                                                  as dt_moeda_cotacao,
        null                                                  as vl_moeda_cotacao,
        null                                                  as cd_moeda_cotacao,
        null                                                  as dt_zera_saldo_pedido_item,
        null                                                  as cd_lote_produto,
        null                                                  as cd_num_serie_item_pedido,
        null                                                  as cd_lote_item_pedido,
        'S'                                                   as ic_controle_mapa_pedido,
        null                                                  as cd_tipo_embalagem,
        null                                                  as dt_validade_item_pedido,
        null                                                  as cd_movimento_caixa,
        null                                                  as vl_custo_financ_item,
        null                                                  as qt_garantia_item_pedido,
        null                                                  as cd_tipo_montagem,
        null                                                  as cd_montagem,
        null                                                  as cd_usuario_ordsep,
        null                                                  as ic_kit_grupo_produto,
        null                                                  as cd_sub_produto_especial,
        null                                                  as cd_plano_financeiro,
        null                                                  as dt_fluxo_caixa,
        null                                                  as ic_fluxo_caixa,
        cast('' as varchar)                                   as ds_servico_item_pedido,
        null                                                  as dt_reservado_montagem,
        null                                                  as cd_usuario_montagem,
        null                                                  as ic_imediato_produto,
        cf.cd_mascara_classificacao,
        null                                                  as cd_desenho_item_pedido,
        null                                                  as cd_rev_des_item_pedido,
        null                                                  as cd_centro_custo,
        null                                                  as qt_area_produto,
        null                                                  as cd_produto_estampo,
        null                                                  as vl_digitado_item_desconto,
        null                                                  as cd_lote_Item_anterior,
        pe.cd_programacao_entrega,
        isnull(pc.ic_estoque_fatura_produto,'N')              as ic_estoque_fatura,
        isnull(pc.ic_estoque_venda_produto,'N')               as ic_estoque_venda,
        null                                                  as ic_manut_mapa_producao,
        null                                                  as pc_comissao_item_pedido,
        null                                                  as cd_produto_servico,
        null                                                  as ic_baixa_composicao_item,
        null                                                  as vl_unitario_ipi_produto,
        null                                                  as ic_desc_prom_item_pedido,
        null                                                  as cd_tabela_preco,
        null                                                  as cd_motivo_reprogramacao

         
--select * from pedido_venda_item
--select * from produto_custo

      into
        #Pedido_Venda_Item
      from
        #ItemAgrupado pe                        with (nolock)
        inner join Produto p                    with (nolock) on p.cd_produto               = pe.cd_produto 
        left outer join Produto_Fiscal       pf with (nolock) on pf.cd_produto              = p.cd_produto
        left outer join Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
        left outer join Produto_Custo        pc with (nolock) on p.cd_produto               = pc.cd_produto

--       where
--         pe.cd_cliente = @cd_cliente and
--         isnull(pe.cd_pedido_venda,0)=0
  

      insert into pedido_venda_item
      select * from #pedido_venda_item
      
      --Calculo do Pedido de Venda
 
      --1.Pedido
  
      select
         pv.cd_pedido_venda,
         vl_total_pedido_venda = sum( isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0) ),
         vl_total_pedido_ipi   = sum((isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)) + 
                                     (isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)  * isnull(pvi.pc_ipi,0)/100 ) ),
         vl_total_ipi          = sum( isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)  * isnull(pvi.pc_ipi,0)/100 )
       into
         #CalculoPV
       from
         Pedido_Venda pv
         inner join pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
       where
         pv.cd_pedido_venda = @cd_pedido_venda    
       group by
         pv.cd_pedido_venda

       update
         Pedido_Venda
       set
         vl_total_pedido_venda = x.vl_total_pedido_venda,
         vl_total_pedido_ipi   = x.vl_total_pedido_ipi,
         vl_total_ipi          = x.vl_total_ipi
       from
         pedido_venda pv
         inner join #calculopv x on x.cd_pedido_venda = pv.cd_pedido_venda
       where
         @cd_pedido_venda = pv.cd_pedido_venda

      --2. Atualização da Programação da Entrega
      update
         programacao_entrega
      set
        cd_pedido_venda      = x.cd_pedido_venda,
        cd_item_pedido_venda = x.cd_item_pedido_venda
      from
        programacao_entrega pe
        inner join #pedido_venda_item x      on x.cd_produto             = pe.cd_produto 
        inner join #AtualizacaoProgramacao a on a.cd_programacao_entrega = pe.cd_programacao_entrega and
                                                a.cd_produto             = x.cd_produto                               
      where
         x.cd_pedido_venda = @cd_pedido_venda 

      update
        programacao_entrega_remessa
      set
        cd_pedido_venda      = x.cd_pedido_venda,
        cd_item_pedido_venda = x.cd_item_pedido_venda
      from
        programacao_entrega_remessa per
        inner join programacao_entrega pe    on pe.cd_programacao_entrega = per.cd_programacao_entrega

        inner join #pedido_venda_item x      on x.cd_produto              = pe.cd_produto 
        inner join #AtualizacaoProgramacao a on a.cd_programacao_entrega  = per.cd_programacao_entrega and
                                                a.cd_produto              = x.cd_produto                               

      where
         isnull(per.cd_pedido_venda,0) = 0 and
         x.cd_pedido_venda = @cd_pedido_venda 
        
--      select * from #AtualizacaoProgramacao

      drop table #ItemAgrupado
      drop table #AtualizacaoProgramacao
     
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'

    end
      else
        begin
          -- limpeza da tabela de código
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'
          set @cd_pedido_venda=0
        end

  end

  delete from #ClientePedido where cd_cliente = @cd_cliente

  
end

--select @cd_pedido_venda as cd_pedido_venda


--select * from status_proposta

