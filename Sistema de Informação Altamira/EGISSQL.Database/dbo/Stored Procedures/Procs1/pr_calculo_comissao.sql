
CREATE procedure pr_calculo_comissao  
  
@cd_parametro             int,             -- Parâmetro para chamada de procedimentos  
@cd_vendedor              int,             -- Vendedor  
@dt_inicial               datetime,        -- Data Inicial do Cálculo (Período da nota fiscal)  
@dt_final                 datetime,        -- Data Final   do Cálculo  
@dt_perc_smo              datetime,        -- Data de Mudança da alíquota do cálculo ICMS-SMO  
@cd_tipo_vendedor         int,             -- Vendedor Externo=2, Representante=3, os dois=2 até 3  
@ic_mostrar_deducoes      char(1) = 'N',   -- Controle de Deduções  
@ic_arredondamento        char(1) = 'N',   -- Fórmula Especial de Arrendamento Específico, quando o processo é por desconto  
@cd_usuario               int     = 0,     -- Usuário  
@ic_tipo_calculo          char(1) = 'P'    -- Tipo de Cálculo Padrão (P) / Pagamento do Contas a Receber  (R)

as  
  
-- setar parâmetros DEFAULT  

set @ic_mostrar_deducoes = isnull(@ic_mostrar_deducoes,'N')  
  
declare @vl_zero               float  
declare @cd_tipo_calculo_price int  
  
set @vl_zero = 0  
set @cd_tipo_calculo_price = 1   -- Default considerando "over"  
  
-- Verifica o Parâmetro de Cálculo do Preço Orçado  
  
-- 1 : Parâmetro de cálculo é com "Over" - Preço Lista Bruto  
-- 2 : Parâmetro de cálculo é sem "Over" - Preço Líquido  
  
-- Buscar a Data Base para Comissão  
  
select  
  @cd_tipo_calculo_price = isnull(cd_tipo_parametro_comis,1)  
from  
  parametro_comissao  with (nolock)  
where  
  dt_base_comissao = @dt_final  
  
-- Buscar as informações específicas da Empresa  
--select * from parametro_comissao_empresa  
  
  
declare @cd_aplicacao_markup          int  
declare @ic_descontar_frete           char(1)  
declare @ic_local_frete               char(1)  
declare @ic_descontar_embalagem       char(1)  
declare @ic_estrutura_comissao        char(1) --Carlos 25/1/2004  
declare @ic_sempre_descontar_custofin char(1)  
declare @ic_visita_comissao           char(1)  
declare @qt_dia_visita_comissao       int  
declare @nm_vendedor                  varchar(40)  
declare @ic_deducao_zona_franca       char(1)   
declare @ic_movimento_caixa_comissao  char(1)  
declare @pc_comissao_empresa          float  
declare @ic_atualiza_preco_custo      char(1)  
declare @ic_deducao_icms_comissao     char(1)
declare @ic_pagamento_duplicata       char(1) 
declare @ic_deducao_ipi_comissao      char(1)
declare @ic_icms_zona_franca          char(1)
  
--select * from parametro_comissao_empresa  
  
select  
  @cd_aplicacao_markup          = isnull(cd_aplicacao_markup,0),  
  @ic_descontar_frete           = isnull(ic_descontar_frete,'N'),  
  @ic_local_frete               = ic_local_frete,  
  @ic_descontar_embalagem       = isnull(ic_descontar_embalagem,'N'),  
  @ic_sempre_descontar_custofin = isnull(ic_sempre_descontar_custofin,'N'),  
  @ic_estrutura_comissao        = isnull(ic_estrutura_comissao,'N'),  
  @ic_visita_comissao           = isnull(ic_visita_comissao,'N'),  
  @qt_dia_visita_comissao       = isnull(qt_dia_visita_comissao,0),  
  @ic_deducao_zona_franca       = isnull(ic_deducao_zona_franca,'N'),  
  @ic_movimento_caixa_comissao  = isnull(ic_movimento_caixa_comissao,'N'),  
  @pc_comissao_empresa          = isnull(pc_comissao_empresa     ,0),  
  @ic_atualiza_preco_custo      = isnull(ic_atualiza_preco_custo ,'N'),
  @ic_deducao_icms_comissao     = isnull(ic_deducao_icms_comissao,'N'),
  @ic_pagamento_duplicata       = isnull(ic_pagamento_duplicata  ,'N'),
  @ic_deducao_ipi_comissao      = isnull(ic_deducao_ipi_comissao ,'N'),
  @ic_icms_zona_franca          = isnull(ic_icms_zona_franca,    'N')
  
from  
  parametro_comissao_empresa  with (nolock) 

where  
  cd_empresa = dbo.fn_empresa()  
  
set @cd_aplicacao_markup          = isnull(@cd_aplicacao_markup         ,0)  
set @ic_descontar_frete           = isnull(@ic_descontar_frete          ,'N')  
set @ic_local_frete               = isnull(@ic_local_frete              ,'N') -- "N"ota ou "P"edido  
set @ic_descontar_embalagem       = isnull(@ic_descontar_embalagem      ,'N')  
set @ic_sempre_descontar_custofin = isnull(@ic_sempre_descontar_custofin,'N')  
set @ic_estrutura_comissao        = isnull(@ic_estrutura_comissao       ,'N')  
  
-----------------------------------------------------------------------------------------------  
-- Cálculo do Preço de Custo dos Produtos  
-----------------------------------------------------------------------------------------------  
  
if @ic_atualiza_preco_custo = 'S'  
begin  
  
  --Stored Procedure de Cálculo de Custo da Composição  
  
  exec pr_geracao_preco_custo_composicao_produto   
    1,  
    0,  
    @cd_usuario  
  
end  
  
-----------------------------------------------------------------------------------------------  
-- Cálculo da Comissão pela baixa do Contas a Receber
-----------------------------------------------------------------------------------------------  

  --select * from documento_receber
  --select * from documento_receber_pagamento

  select
    --select * from documento_receber
    --select * from documento_receber_pagamento

    ns.cd_identificacao_nota_saida,
    d.cd_nota_saida,
    ns.dt_nota_saida,
    d.cd_pedido_venda,
    d.vl_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    drp.dt_pagamento_documento,
    drp.vl_pagamento_documento,
    drp.vl_abatimento_documento,

    isnull(cp.qt_parcela_condicao_pgto,0) as 'qtd_parcela',

    case when isnull(cp.qt_parcela_condicao_pgto,0) > 0 
    then
      ( ns.vl_total - isnull(ns.vl_ipi,0)  )
      /
      isnull(cp.qt_parcela_condicao_pgto,0)
    else
      d.vl_documento_receber
    end                                    as 'Valor_Parcela_Sem_IPI',
    ns.nm_fantasia_nota_saida,
    ns.nm_razao_social_nota,
    ns.cd_vendedor

  into
    #DocumentoReceberPago

  from
    Documento_Receber_Pagamento     drp     with (nolock) 
    inner join Documento_Receber    d       with (nolock) on (drp.cd_documento_receber = d.cd_documento_receber)
    left outer join Nota_Saida      ns      with (nolock) on ns.cd_nota_saida          = d.cd_nota_saida
    left outer join Condicao_Pagamento cp   with (nolock) on cp.cd_condicao_pagamento  = ns.cd_condicao_pagamento
    
--select * from nota_saida

  where
      (drp.dt_pagamento_documento between @dt_inicial and @dt_final)                        and
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final )) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final )) 

  --Mostrar a Tabela c/Documentos Pagos
  --select * from #DocumentoReceberPago

if @ic_pagamento_duplicata = 'N'
begin
  delete from #DocumentoReceberPago
end
  
-----------------------------------------------------------------------------------------------  
-- Cálculo da Comissão com dados dos itens da nota fiscal  
-----------------------------------------------------------------------------------------------  
--select cd_vendedor_interno,* from pedido_venda
  
select  
   a.cd_vendedor                          as 'setor',  
   d.cd_vendedor_interno,
   a.cd_cliente,  
   b.cd_categoria_produto                 as 'codigocategoria',  
   i.nm_fantasia_cliente                  as 'cliente',  
   b.cd_pedido_venda                      as 'pedido',  
   b.cd_item_pedido_venda                 as 'item',  
   d.dt_pedido_venda                      as 'emissao',  
   b.qt_item_nota_saida                   as 'qtd',  
  
   'venda' =   
   ( case when a.ic_zona_franca='S' and @ic_icms_zona_franca='S' then   
          --(b.vl_total_item-(b.vl_total_item*b.pc_icms_desc_item/100))  
          (b.vl_total_item-(b.vl_total_item*b.pc_icms/100))  
        else  
           b.vl_total_item  
   end  )  
  
   --Desconto no Cadastro do cliente / bonificação  
  
   - ( case when isnull(i.pc_desconto_cliente,0)>0 then b.vl_total_item*(i.pc_desconto_cliente/100)  
                                                   else 0.00 end )  
  
   --Desconto do PIS para Zona Franca  
   - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) then isnull(b.vl_pis,0)  
                                                                              else 0.00 end )  
  
   --Desconto do COFINS para Zona Franca  
   - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) then isnull(b.vl_cofins,0)  
                                                                              else 0.00 end )  
  
   --Icms de Zona Franca de Manaus  
   - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) and @ic_icms_zona_franca='S'
                                                                              then isnull(b.vl_icms_desc_item,0)  
                                                                              else 0.00 end )

   - case when @ic_deducao_icms_comissao='S'
     then
       (b.vl_unitario_item_nota*b.pc_icms/100)
     else
       0.00
   end,  
    
   ----- Duplicar este código logo abaixo no cálculo do Valor de Venda p/ Comissão ---  
--    'IcmsDescontado' =  
--      b.pc_icms - ( case when ( a.ic_zona_franca = 'S' ) then isnull(b.pc_icms_desc_item,0) else 0 end ),  
  
   'IcmsDescontado' =  
     b.pc_icms - ( case when ( a.ic_zona_franca = 'S' ) then isnull(b.pc_icms,0) else 0.00 end ),  
  
   'CustoFinanceiroDescontado' =  
     ( case when ( isnull( d.ic_custo_financeiro, 'N' ) = 'S' ) or  
                 ( @ic_sempre_descontar_custofin = 'S' ) then isnull(d.vl_custo_financeiro,0) else 0.00 end ),  
  
   'FreteDescontado' =  
     ( case when ( @ic_descontar_frete = 'S' )  
            then b.qt_item_nota_saida * isnull( case when (@ic_local_frete = 'P')  
                                                     then c.vl_frete_item_pedido  
                                                     else b.vl_frete_item  
                                                end, 0.00 )  
            else 0.00  
       end ),  
  
   'EmbalagemDescontada' =  
     ( case when ( @ic_descontar_embalagem = 'S' ) then dbo.fn_vl_produto_embalagem( b.cd_pedido_venda, b.cd_item_pedido_venda ) else 0.00 end ),  
  
   ------------------------------------------------------------------------------------  
   --Carlos 20.1.2006  
   --b.vl_total_item as 'venda_comissao', --Valor Original do Item da Nota fiscal  
  ------------------------------------------------------------------------------------  
  
  
   --Correto  
   
   'venda_comissao' =   

   case when @ic_pagamento_duplicata = 'N' then 
     dbo.fn_vl_venda_sem_impostos(  
       @cd_aplicacao_markup,  
       'F' ,  
       b.vl_total_item,  
       b.pc_icms - ( case when ( a.ic_zona_franca = 'S' ) then isnull(b.pc_icms,0) else 0 end ), -- Zona Franca : ICMS com desconto  
       ( case when ( isnull( d.ic_custo_financeiro, 'N' ) = 'S' ) or  
                   ( @ic_sempre_descontar_custofin = 'S' ) then isnull(d.vl_custo_financeiro,0) else 0 end )  
     )  
  
     --Frete  
     - ( case when ( @ic_descontar_frete = 'S' )  
              then b.qt_item_nota_saida * isnull( case when (@ic_local_frete = 'P')  
                                                       then c.vl_frete_item_pedido  
                                                       else b.vl_frete_item  
                                                  end, 0.00 )  
              else 0.00  
         end )  
  
     --Embalagem  
     - ( case when ( @ic_descontar_embalagem = 'S' ) then   
               dbo.fn_vl_produto_embalagem( b.cd_pedido_venda, b.cd_item_pedido_venda ) else 0.00 end )  
  
     --Carlos 12.07.2006   
     --(%) de Desconto do Cadastro do Cliente  
  
      - ( case when isnull(i.pc_desconto_cliente,0)>0 then b.vl_total_item*(i.pc_desconto_cliente/100)  
                                                      else 0.00 end )  
  
      --Desconto do PIS para Zona Franca  
       - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) then isnull(b.vl_pis,0)  
                                                                                  else 0.00 end )  
  
      --Desconto do COFINS para Zona Franca  
      - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) then isnull(b.vl_cofins,0)  
                                                                                 else 0.00 end )  
  
      --Icms de Zona Franca de Manaus  
      - ( case when ( a.ic_zona_franca = 'S' and @ic_deducao_zona_franca = 'S' ) and @ic_icms_zona_franca='S'
                                                                                 then isnull(b.vl_icms_desc_item,0)  
                                                                                 else 0.00 end )

      - case when @ic_deducao_icms_comissao='S'
        then
          (b.vl_unitario_item_nota*b.pc_icms/100)
        else
          0.00
        end

  else
     bx.Valor_Parcela_Sem_IPI
  end,
     
  --select * from pedido_venda_item  

  'orcado' =  

   case   
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido)-  
            ((b.qt_item_nota_saida*c.vl_lista_item_pedido)*11/100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido)-  
              ((b.qt_item_nota_saida*c.vl_lista_item_pedido)*8.8/100)  
        else  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido)  
     end  
   when @cd_tipo_calculo_price = 2 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido))-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido))*11/100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido))-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido))*8.8/100)  
        else  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido))  
     end  
   end

   --Verificar se a Venda é realizada em outra Moeda

   * 

   case when isnull(c.cd_moeda_cotacao,1)>1 then
     isnull(c.vl_moeda_cotacao,1)
   else
     1
   end,  
  
   a.cd_identificacao_nota_saida,
   b.cd_nota_saida                     as 'nota',  
   b.cd_item_nota_saida                as 'itemnota',  
   a.dt_nota_saida                     as 'datanota',  
  
  'descto' =   
   case  
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido * 

                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end ))*100)  
     end  
   when @cd_tipo_calculo_price = 2 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido) *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end
               ))*100)  
     end  
   end,  
  
  'codprod' =  
   cast( (case when ( f.cd_produto is null ) then  
           b.cd_produto else f.cd_produto end) as varchar(20)),  
  
  'codant' =  
   case when ( f.cd_produto is null ) then  
      b.nm_fantasia_produto else f.nm_fantasia_produto end,  
  
  'descricao' =  
   case when ( f.cd_produto is null ) then  
      b.nm_produto_item_nota else f.nm_produto end,  
  
   c.dt_entrega_fabrica_pedido          as 'dtentrpcp',  
   d.ic_smo_pedido_venda                as 'smo',  
   h.sg_status                          as 'status',  
   b.dt_cancel_item_nota_saida          as 'datacanc',  
   a.nm_mot_cancel_nota_saida           as 'devolucao', -- Pegando motivo devolução do cabeçalho  
  '1 - NOTAS FATURADAS            '     as 'devolvido',  
   e.cd_tipo_vendedor                   as 'tipovendedor',  
   e.pc_comissao_vendedor,              
   d.pc_comissao_pedido_venda           as 'ppedido',  
   f.pc_comissao_produto                as 'pproduto',  
   gr.pc_comissao_grupo_produto         as 'pgrupo',  
   @vl_zero                             as 'devolucaomes',  
   @vl_zero                             as 'devolucaomesant',  
   @vl_zero                             as 'qtdevolucao',  
   isnull(d.pc_comissao_especifico,0)   as 'pc_comissao_especifico',  
   b.vl_total_item,  
   b.pc_icms,  
   b.pc_icms_desc_item,  
   cast(0 as int)                       as 'cd_estrutura_comissao',  
   cast(0 as float)                     as 'pc_comissao_estrutura',  
   cp.ic_comissao_categoria,  
   cp.ic_resumo_comissao_categ,  
   d.ic_custo_financeiro,  
   d.vl_custo_financeiro,  
   e.nm_fantasia_vendedor               as 'NomeSetor',  
   cast ( 0 as int )                    as 'SetorEstrutura',  
   isnull(pc.vl_custo_produto,0)        as 'CustoProduto',  

   --Dedução do ICMS conforme parâmetro
   case when @ic_deducao_icms_comissao='S'
   then
     (b.vl_unitario_item_nota-(b.vl_unitario_item_nota*isnull(b.pc_icms,0)/100))  
   else
    isnull(b.vl_unitario_item_nota,0)
   end                                  as 'VendaUnitario',
   isnull(pc.vl_custo_comissao,0)       as 'CustoComissao',
   case when isnull(mp.nm_marca_produto,'')<>'' 
   then
     mp.nm_marca_produto
   else
     f.nm_marca_produto end             as 'MarcaProduto',
   isnull(c.pc_comissao_item_pedido,0)  as pc_comissao_item_pedido,
   case when b.dt_restricao_item_nota is null or b.dt_restricao_item_nota>@dt_final
   then
     null
   else
     b.dt_restricao_item_nota
   end                                  as dt_restricao_item_nota,
   cast(b.nm_motivo_restricao_item      as varchar(60)) as nm_motivo_restricao_item,
   c.cd_tabela_preco,
   isnull(tpp.pc_comissao_tabela_produto,0)             as pc_comissao_tabela,
   vi.nm_fantasia_vendedor             as 'VendedorInterno'  


--select * from produto_custo  
--select * from nota_saida_item  
--select * from marca_produto
--select * from nota_saida_parcela

-------------------------------------------------------
into #Comissao  
-------------------------------------------------------  
  
from  
     nota_saida a                        with (nolock) 
     inner join nota_saida_item b        with (nolock) on a.cd_nota_saida    = b.cd_nota_saida  
     inner join cliente i                with (nolock) on a.cd_cliente       = i.cd_cliente  
     inner join vendedor e               with (nolock) on a.cd_vendedor      = e.cd_vendedor  
     inner join tipo_vendedor tv         with (nolock) on e.cd_tipo_vendedor = tv.cd_tipo_vendedor  
                                                          and IsNull(ic_comissao_tipo_vendedor,'N') = 'S'  
  
     inner join operacao_fiscal o            with (nolock)  on b.cd_operacao_fiscal = o.cd_operacao_fiscal  
  
     inner join Categoria_Produto cp         with (nolock)  on cp.cd_categoria_produto = b.cd_categoria_produto  
  
     left outer join pedido_venda d          with (nolock)  on b.cd_pedido_venda       = d.cd_pedido_venda  
  
     left outer join pedido_venda_item c     with (nolock)  on  b.cd_pedido_venda      = c.cd_pedido_venda and  
                                                                b.cd_item_pedido_venda = c.cd_item_pedido_venda  
  
     left outer join produto f                with (nolock) on  b.cd_produto           = f.cd_produto  
     left outer join produto_custo pc         with (nolock) on  pc.cd_produto          = b.cd_produto  
     left outer join grupo_produto gr         with (nolock) on  c.cd_grupo_produto     = gr.cd_grupo_produto  
     left outer join status_nota h            with (nolock) on  a.cd_status_nota       = h.cd_status_nota 
     left outer join Marca_Produto mp         with (nolock) on  mp.cd_marca_produto    = f.cd_marca_produto 
     left outer join #DocumentoReceberPago bx with (nolock) on  bx.cd_nota_saida       = a.cd_nota_saida  
     left outer join Tabela_Preco_Produto tpp with (nolock) on tpp.cd_produto          = b.cd_produto and
                                                               tpp.cd_tabela_preco     = c.cd_tabela_preco
     left outer join Vendedor vi              with (nolock) on vi.cd_vendedor          = d.cd_vendedor_interno      

--select * from tabela_preco_produto

Where  
    --Não Filtrar porque existe a estrutura gerencial

--     IsNull(a.cd_vendedor,0) = (case @cd_vendedor   
--                                  when 0 then IsNull(a.cd_vendedor,0)  
--                                  else @cd_vendedor   
--                                end)   
--     and  

   --Verifica se o Cálculo é por Documentos pagos
   (a.cd_nota_saida = case when @ic_pagamento_duplicata = 'N' then a.cd_nota_saida else bx.cd_nota_saida end )      and
 
   (a.dt_nota_saida between ( case when @ic_pagamento_duplicata = 'N' then @dt_inicial else a.dt_nota_saida end )   and  
                            ( case when @ic_pagamento_duplicata = 'N' then @dt_final   else a.dt_nota_saida end ) ) and  
  
    --Verifica se o Pedido de Venda deve ser pago Comissão, conforme alteração manual do usuário  
    --Carlos 30.07.2005  
  
    isnull(d.ic_comissao_pedido_venda,'S')='S'     and  
   (isnull(o.ic_comercial_operacao,'N')   ='S' or isnull(o.ic_comissao_op_fiscal,'N')='S' ) and  
    isnull(a.vl_total,0) > 0                       and  
    isnull(b.cd_status_nota,0) <> 7                and  -- 7 = Notas Canceladas  

--    b.dt_restricao_item_nota is null               and

   (b.qt_item_nota_saida*(case ic_tipo_nota_saida_item when 'S' then   
                          isnull(b.vl_servico,0) else isnull(b.vl_unitario_item_nota,0) end)) > 0 and  

    -- comissão é feita pelo preço orçado (isnull para os casos de nota sem pedido)  

   isnull(c.vl_lista_item_pedido,1) > 0  
   and     
   ((isnull(cp.ic_comissao_categoria,'N')='S') -- Categoria do Produto realiza o Pagamento de Comissão
   or  
   ((@cd_parametro in (1,6)) and (isnull(cp.ic_resumo_comissao_categ,'N')='S'))) -- Eduardo - 11/02/2004  
   --and c.cd_pedido_venda = 3011

--select * from nota_saida_item    

Union All  
  
-----------------------------------------------------------------------------------------------  
-- Movimento de Caixa  
-----------------------------------------------------------------------------------------------  
  
select  
   a.cd_vendedor                          as 'setor',  
   d.cd_vendedor_interno,
   a.cd_cliente,  
   cp.cd_categoria_produto                as 'codigocategoria',  
   i.nm_fantasia_cliente                  as 'cliente',  
   b.cd_pedido_venda                      as 'pedido',  
   b.cd_item_pedido_venda                 as 'item',  
   d.dt_pedido_venda                      as 'emissao',  
   b.qt_item_movimento_caixa              as 'qtd',  
  
   b.vl_total_item                     

   - case when @ic_deducao_icms_comissao='S'
     then
       (b.vl_item_movimento_caixa*b.pc_icms/100)
     else
       0.00
     end                                   as 'venda',  
  
   'IcmsDescontado'            = 0.00,  
  
   'CustoFinanceiroDescontado' = 0.00,  
  
   'FreteDescontado'           = 0.00,  
  
   'EmbalagemDescontada'       = 0.00,  
  
   --Correto  
   
   'venda_comissao' =   
     dbo.fn_vl_venda_sem_impostos(  
       @cd_aplicacao_markup,  
       'F' ,  
       b.vl_total_item,  
       b.pc_icms,  
       0 )
     - case when @ic_deducao_icms_comissao='S'
       then
         (b.vl_item_movimento_caixa*b.pc_icms/100)
       else
         0.00
       end,
  
  'orcado'                      = vl_total_item,  
  
   b.cd_movimento_caixa                as 'cd_identificacao_nota_saida',
   b.cd_movimento_caixa                as 'nota',  
   b.cd_item_movimento_caixa           as 'itemnota',  
   a.dt_movimento_caixa                as 'datanota',  
  
  'descto'                      = 0.00,  
  
  'codprod' =  
   cast( (case when ( f.cd_produto is null ) then  
           b.cd_produto else f.cd_produto end) as varchar(20)),  
  
  'codant'    = f.nm_fantasia_produto,  
  
  'descricao' = f.nm_produto,  
  
   c.dt_entrega_fabrica_pedido          as 'dtentrpcp',  
   d.ic_smo_pedido_venda                as 'smo',  
   'OK'                                 as 'status',  
   b.dt_cancel_item                     as 'datacanc',  
   a.nm_motivo_cancel_mov               as 'devolucao', -- Pegando motivo devolução do cabeçalho  
  '1 - MOVIMENTO DE CAIXA         '     as 'devolvido',  
   e.cd_tipo_vendedor                   as 'tipovendedor',  
   e.pc_comissao_vendedor,              
   d.pc_comissao_pedido_venda           as 'ppedido',  
   f.pc_comissao_produto                as 'pproduto',  
   gr.pc_comissao_grupo_produto         as 'pgrupo',  
   @vl_zero                             as 'devolucaomes',  
   @vl_zero                             as 'devolucaomesant',  
   @vl_zero                             as 'qtdevolucao',  
   isnull(d.pc_comissao_especifico,0)   as 'pc_comissao_especifico',  
   b.vl_total_item,  
   b.pc_icms,  
   b.pc_reducao_icms                    as 'pc_icms_desc_item',  
   cast(0 as int)                       as 'cd_estrutura_comissao',  
   cast(0 as float)                     as 'pc_comissao_estrutura',  
   cp.ic_comissao_categoria,  
   cp.ic_resumo_comissao_categ,  
   d.ic_custo_financeiro,  
   d.vl_custo_financeiro,  
   e.nm_fantasia_vendedor               as 'NomeSetor',  
   cast ( 0 as int )                    as 'SetorEstrutura',  
   isnull(pc.vl_custo_produto,0)        as 'CustoProduto',  

   --select * from movimento_caixa_item
   case when @ic_deducao_icms_comissao='S'
   then
     (b.vl_item_movimento_caixa-(b.vl_item_movimento_caixa*b.pc_icms/100))  
   else
    isnull(b.vl_item_movimento_caixa,0)
   end                                 as 'VendaUnitario',
   isnull(pc.vl_custo_comissao,0)      as 'CustoComissao',
   case when isnull(mp.nm_marca_produto,'')<>'' 
   then
     mp.nm_marca_produto
   else
     f.nm_marca_produto end             as 'MarcaProduto',
   isnull(c.pc_comissao_item_pedido,0)  as pc_comissao_item_pedido,
   null as dt_restricao_item_nota,
   cast('' as varchar(60)) as nm_motivo_restricao_item,
   c.cd_tabela_preco,
   isnull(tpp.pc_comissao_tabela_produto,0)             as pc_comissao_tabela,
   vi.nm_fantasia_vendedor             as 'VendedorInterno'  

  
   --isnull(b.vl_item_movimento_caixa,0)  as 'VendaUnitario'  
  
--select * from movimento_caixa  
--select * from movimento_caixa_item  
  
from  
     movimento_caixa a                 with (nolock) 
  
     inner join movimento_caixa_item b with (nolock) on a.cd_movimento_caixa = b.cd_movimento_caixa  
     inner join cliente i              with (nolock) on a.cd_cliente  = i.cd_cliente  
     inner join vendedor e             with (nolock) on a.cd_vendedor = e.cd_vendedor  
     inner join tipo_vendedor tv       with (nolock) on e.cd_tipo_vendedor = tv.cd_tipo_vendedor  
                                                        and IsNull(ic_comissao_tipo_vendedor,'N') = 'S'  
  
     --inner join operacao_fiscal o    on b.cd_operacao_fiscal = o.cd_operacao_fiscal  
     left outer join produto f            with (nolock) on  b.cd_produto  = f.cd_produto  
  
     left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = f.cd_categoria_produto  
  
     left outer join pedido_venda d       with (nolock) on b.cd_pedido_venda = d.cd_pedido_venda  
  
     left outer join pedido_venda_item c  with (nolock) on  b.cd_pedido_venda = c.cd_pedido_venda and  
                                                            b.cd_item_pedido_venda = c.cd_item_pedido_venda  
  
     left outer join produto_custo pc    with (nolock) on  pc.cd_produto = b.cd_produto  
     left outer join grupo_produto gr    with (nolock) on  c.cd_grupo_produto = gr.cd_grupo_produto  
     left outer join Marca_Produto mp    with (nolock) on  mp.cd_marca_produto = f.cd_marca_produto 
     left outer join Tabela_Preco_Produto tpp with (nolock) on tpp.cd_produto          = b.cd_produto and
                                                               tpp.cd_tabela_preco     = c.cd_tabela_preco

     left outer join Vendedor vi              with (nolock) on vi.cd_vendedor          = d.cd_vendedor_interno      

     --left outer join status_nota h       on  a.cd_status_nota = h.cd_status_nota  
  
Where  
    @ic_movimento_caixa_comissao = 'S' and  

    --09.09.2008

--     IsNull(a.cd_vendedor,0) = (case @cd_vendedor   
--                                  when 0 then IsNull(a.cd_vendedor,0)  
--                                  else @cd_vendedor   
--                                end)   
--     and  

   (a.dt_movimento_caixa between @dt_inicial and  
                                 @dt_final ) and  
  
    --Verifica se o Pedido de Venda deve ser pago Comissão, conforme alteração manual do usuário  
    --Carlos 30.07.2005  
    isnull(d.ic_comissao_pedido_venda,'S')='S'     and  
    --o.ic_comercial_operacao = 'S'                  and  
    isnull(a.vl_movimento_caixa,0) > 0                       and  
    a.dt_cancel_movimento_caixa is null            and  
    -- comissão é feita pelo preço orçado (isnull para os casos de nota sem pedido)  
   isnull(c.vl_lista_item_pedido,1) > 0  
   and     
   ((isnull(cp.ic_comissao_categoria,'N')='S') -- PADRÃO POLIMOLD - Solicitado pelo Carlos - (DUELA)  
    or  
    ((@cd_parametro in (1,6)) and (isnull(cp.ic_resumo_comissao_categ,'N')='S'))) -- Eduardo - 11/02/2004  
  
Union All  
  
-----------------------------------------------------------------------------------------------  
-- Devolução de notas fiscais que ocorreram no período selecionado  
-- Mês Corrente  
-----------------------------------------------------------------------------------------------  
  
select  
   a.cd_vendedor                          as 'setor',  
   d.cd_vendedor_interno,
   a.cd_cliente,  
   b.cd_categoria_produto                 as 'codigocategoria',  
   i.nm_fantasia_cliente                  as 'cliente',  
   b.cd_pedido_venda                      as 'pedido',  
   b.cd_item_pedido_venda                 as 'item',  
   d.dt_pedido_venda                      as 'emissao',  
   qtd =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
             b.qt_devolucao_item_nota   
       else  b.qt_item_nota_saida  
     end,  
  
   'venda' =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
            (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1   
       else (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                               b.vl_servico else b.vl_unitario_item_nota end)) * -1  
     end,  
  
   'IcmsDescontado'            = 0.00,  
   'CustoFinanceiroDescontado' = 0.00,  
   'FreteDescontado'           = 0.00,  
   'EmbalagemDescontada'       = 0.00,  
  
   'venda_comissao' =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
            (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1   
       else (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                               b.vl_servico else b.vl_unitario_item_nota end)) * -1  
     end,  
  
  'orcado' =  
 case   
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-  
            ((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*11/100)  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-  
              ((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-  
            ((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*11/100)  
        when (b.qt_devolucao_item_nota = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-  
              ((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota > 0) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)  
        else  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)  
     end  
       

   when @cd_tipo_calculo_price = 2 then  
     case  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*11/100)  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*8.8/100)  
        when (b.qt_item_nota_saida = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*11/100)  
        when (b.qt_item_nota_saida = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota > 0) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)  
        else  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)  
     end  
   end

   --Preço de Lista em Outra Moeda

   *

                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end,  

   a.cd_identificacao_nota_saida,
   b.cd_nota_saida                     as 'nota',  
   b.cd_item_nota_saida                as 'itemnota',  
   a.dt_nota_saida                     as 'datanota',  

  'descto' =   
   case  
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end
               ))*100)  
     end  
   when @cd_tipo_calculo_price = 2 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido) *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end
               ))*100)  
     end  
   end,  
  
  'codprod' =  
   cast( (case when ( f.cd_produto is null ) then  
           b.cd_produto else f.cd_produto end) as varchar(20)),  
  
  'codant' =  
   case when ( f.cd_produto is null ) then  
      b.nm_fantasia_produto else f.nm_fantasia_produto end,  
  
  'descricao' =  
   case when ( f.cd_produto is null ) then  
      b.nm_produto_item_nota else f.nm_produto end,  
   c.dt_entrega_fabrica_pedido          as 'dtentrpcp',  
   d.ic_smo_pedido_venda                as 'smo',  
   h.sg_status                          as 'status',  
   b.dt_cancel_item_nota_saida          as 'datacanc',  
   a.nm_mot_cancel_nota_saida           as 'devolucao', -- Pegando motivo devolução do cabeçalho  
  '2 - DEVOLUÇÕES MÊS ATUAL       '     as 'devolvido',  
   e.cd_tipo_vendedor                   as 'tipovendedor',  
   e.pc_comissao_vendedor,              
   d.pc_comissao_pedido_venda           as 'ppedido',  
   f.pc_comissao_produto                as 'pproduto',  
   gr.pc_comissao_grupo_produto         as 'pgrupo',  
   devolucaomes =  
   case   
     when b.qt_devolucao_item_nota > 0 then   
           (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end))  
     else  (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end))  
   end,  
   @vl_zero                             as 'devolucaomesant',  
   qtdevolucao =  
   case  
     when b.qt_devolucao_item_nota > 0 then   
           b.qt_devolucao_item_nota  
     else  b.qt_item_nota_saida  
   end,  
   isnull(d.pc_comissao_especifico,0)   as 'pc_comissao_especifico',  
   b.vl_total_item,  
   b.pc_icms,  
   b.pc_icms_desc_item,  
   cast(0 as int)                       as 'cd_estrutura_comissao',  
   cast(0 as float)                     as 'pc_comissao_estrutura',  
   cp.ic_comissao_categoria,  
   cp.ic_resumo_comissao_categ,  
   d.ic_custo_financeiro,  
   d.vl_custo_financeiro,  
   e.nm_fantasia_vendedor               as 'NomeSetor',  
   cast ( 0 as int )                    as 'SetorEstrutura',  
   isnull(pc.vl_custo_produto,0)        as 'CustoProduto',  
   --isnull(b.vl_unitario_item_nota,0)    as 'VendaUnitario'  
   case when @ic_deducao_icms_comissao='S'
   then
     (b.vl_unitario_item_nota-(b.vl_unitario_item_nota*b.pc_icms/100))  
   else
    isnull(b.vl_unitario_item_nota,0)
   end                                  as 'VendaUnitario',
   isnull(pc.vl_custo_comissao,0)       as 'CustoComissao',
   case when isnull(mp.nm_marca_produto,'')<>'' 
   then
     mp.nm_marca_produto
   else
     f.nm_marca_produto end             as 'MarcaProduto',
   isnull(c.pc_comissao_item_pedido,0)  as pc_comissao_item_pedido,
   case when b.dt_restricao_item_nota is null or b.dt_restricao_item_nota>@dt_final
   then
     null
   else
     b.dt_restricao_item_nota
   end                                  as dt_restricao_item_nota,
   cast(b.nm_motivo_restricao_item      as varchar(60)) as nm_motivo_restricao_item,
   c.cd_tabela_preco,
   isnull(tpp.pc_comissao_tabela_produto,0)             as pc_comissao_tabela,
   vi.nm_fantasia_vendedor             as 'VendedorInterno'  

from  
     nota_saida a                 with (nolock) 
  
     inner join nota_saida_item b with (nolock) on  a.cd_nota_saida = b.cd_nota_saida  
  
     inner join cliente i         with (nolock) on  a.cd_cliente = i.cd_cliente  
  
     inner join vendedor e        with (nolock) on  a.cd_vendedor = e.cd_vendedor  
  
     inner join tipo_vendedor tv  with (nolock) on  e.cd_tipo_vendedor = tv.cd_tipo_vendedor  
                                                    and IsNull(ic_comissao_tipo_vendedor,'N') = 'S'  
  
     inner join operacao_fiscal o with (nolock) on  b.cd_operacao_fiscal = o.cd_operacao_fiscal  
  
     inner join Categoria_Produto cp with (nolock) on  cp.cd_categoria_produto = b.cd_categoria_produto  
  
     left outer join pedido_venda d  with (nolock) on  b.cd_pedido_venda = d.cd_pedido_venda  
  
     left outer join pedido_venda_item c with (nolock) on  b.cd_pedido_venda = c.cd_pedido_venda and  
                                                           b.cd_item_pedido_venda = c.cd_item_pedido_venda  
  
     left outer join produto f        with (nolock) on b.cd_produto  = f.cd_produto  
     left outer join produto_custo pc with (nolock) on pc.cd_produto = b.cd_produto  
  
     left outer join grupo_produto gr with (nolock) on c.cd_grupo_produto = gr.cd_grupo_produto  
  
     left outer join status_nota h    with (nolock) on a.cd_status_nota = h.cd_status_nota  
     left outer join Marca_Produto mp with (nolock) on  mp.cd_marca_produto = f.cd_marca_produto 
     left outer join Tabela_Preco_Produto tpp with (nolock) on tpp.cd_produto          = b.cd_produto and
                                                               tpp.cd_tabela_preco     = c.cd_tabela_preco
  
     left outer join Vendedor vi              with (nolock) on vi.cd_vendedor          = d.cd_vendedor_interno      

Where  

--     IsNull(a.cd_vendedor,0) = (case @cd_vendedor   
--                                  when 0 then IsNull(a.cd_vendedor,0)  
--                                  else @cd_vendedor   
--                                end)   
--     and  

   (a.dt_nota_saida between @dt_inicial and  
                            @dt_final )              

    and  

   (isnull(o.ic_comercial_operacao,'N')   ='S' or isnull(o.ic_comissao_op_fiscal,'N')='S' ) and  
    a.vl_total > 0                                 and  
   (isnull(b.cd_status_nota,0) = 3 or                    -- Devolução Parcial  
    isnull(b.cd_status_nota,0) = 4)                and   -- Devolução Total  
   (b.dt_restricao_item_nota between @dt_inicial and   
                                     @dt_final) and  

   (b.qt_item_nota_saida*(case ic_tipo_nota_saida_item when 'S' then   
                          b.vl_servico else b.vl_unitario_item_nota end)) > 0 and  

    -- comissão é feita pelo preço orçado (isnull para os casos de nota sem pedido)  
   (isnull(c.vl_lista_item_pedido,1) > 0)  
   and     
   ((isnull(cp.ic_comissao_categoria,'N')='S') -- PADRÃO POLIMOLD - Solicitado pelo Carlos - (DUELA)  
    or  
    ((@cd_parametro in (1,6)) and (isnull(cp.ic_resumo_comissao_categ,'N')='S'))) -- Eduardo - 11/02/2004  
  
Union All  
  
-----------------------------------------------------------------------------------------------  
-- Devolução de notas fiscais que ocorreram no período selecionado  
-- Meses Anteriores  
-----------------------------------------------------------------------------------------------  
  
select  
   a.cd_vendedor                          as 'setor',  
   d.cd_vendedor_interno,
   a.cd_cliente,  
   b.cd_categoria_produto                 as 'codigocategoria',  
   i.nm_fantasia_cliente                  as 'cliente',  
   b.cd_pedido_venda                      as 'pedido',  
   b.cd_item_pedido_venda                 as 'item',  
   d.dt_pedido_venda                      as 'emissao',  
  
   qtd =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
             b.qt_devolucao_item_nota   
       else  b.qt_item_nota_saida  
     end,  
  
   'venda' =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
            (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1   
       else (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1  
     end,  
  
   'IcmsDescontado'            = 0.00,  
   'CustoFinanceiroDescontado' = 0.00,  
   'FreteDescontado'           = 0.00,  
   'EmbalagemDescontada'       = 0.00,  
  
   'venda_comissao' =  
     case   
       when b.qt_devolucao_item_nota > 0 then   
            (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1   
       else (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end)) * -1  
     end,  
  
  'orcado' =  
   case   
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-  
            ((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*11/100)  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-  
              ((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-  
            ((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*11/100)  
        when (b.qt_devolucao_item_nota = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-  
              ((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota > 0) then  
               (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)  
        else  
               (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)  
     end  
   when @cd_tipo_calculo_price = 2 then  
     case  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*11/100)  
        when (b.qt_devolucao_item_nota > 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*8.8/100)  
        when (b.qt_item_nota_saida = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*11/100)  
        when (b.qt_item_nota_saida = 0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)-  
              ((b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)*8.8/100)  
        when (b.qt_devolucao_item_nota > 0) then  
               (b.qt_devolucao_item_nota*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)  
        else  
               (b.qt_item_nota_saida*isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*-1)  
     end  
   end
   --Preço Orcado em Outra Moeda
   *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end,  

   a.cd_identificacao_nota_saida,
   b.cd_nota_saida                     as 'nota',  
   b.cd_item_nota_saida                as 'itemnota',  
   a.dt_nota_saida                     as 'datanota',  
  
  'descto' =   
   case  
   when @cd_tipo_calculo_price = 1 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end
               ))*100)  
     end  
   when @cd_tipo_calculo_price = 2 and isnull(c.vl_lista_item_pedido,0) > 0 then  
     case  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*11/100)))*100)  
        when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)-(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido)*8.8/100)))*100)  
        else  
               (100-(b.vl_unitario_item_nota/(isnull(c.vl_lista_item_pedido,c.vl_lista_item_pedido) *
                     case when isnull(c.cd_moeda_cotacao,1)>1 then
                        isnull(c.vl_moeda_cotacao,1)
                     else
                        1
                     end
                ))*100)  
     end  
   end,  
  
  'codprod' =  
   cast( (case when ( f.cd_produto is null ) then  
           b.cd_produto else f.cd_produto end) as varchar(20)),  
  
  'codant' =  
   case when ( f.cd_produto is null ) then  
      b.nm_fantasia_produto else f.nm_fantasia_produto end,  
  
  'descricao' =  
   case when ( f.cd_produto is null ) then  
      b.nm_produto_item_nota else f.nm_produto end,  
   c.dt_entrega_fabrica_pedido          as 'dtentrpcp',  
   d.ic_smo_pedido_venda  as 'smo',  
   h.sg_status                          as 'status',  
   b.dt_cancel_item_nota_saida          as 'datacanc',  
   a.nm_mot_cancel_nota_saida           as 'devolucao', -- Pegando motivo devolução do cabeçalho  
  '3 - DEVOLUÇÕES MESES ANTERIORES'     as 'devolvido',  
   e.cd_tipo_vendedor                   as 'tipovendedor',  
   e.pc_comissao_vendedor,              
   d.pc_comissao_pedido_venda           as 'ppedido',  
   f.pc_comissao_produto                as 'pproduto',  
   gr.pc_comissao_grupo_produto         as 'pgrupo',  
   @vl_zero                             as 'devolucaomes',  
   devolucaomesant =   
   case   
     when b.qt_devolucao_item_nota > 0 then   
           (b.qt_devolucao_item_nota * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end))  
     else  (b.qt_item_nota_saida * (case when b.vl_unitario_item_nota is null then  
                                                   b.vl_servico else b.vl_unitario_item_nota end))  
   end,  
   qtdevolucao =  
   case  
     when isnull(b.qt_devolucao_item_nota,0) > 0 then   
           b.qt_devolucao_item_nota  
     else  b.qt_item_nota_saida  
   end,  
   isnull(d.pc_comissao_especifico,0)   as 'pc_comissao_especifico',  
   b.vl_total_item,  
   b.pc_icms,  
   b.pc_icms_desc_item,  
   cast(null as int)                    as 'cd_estrutura_comissao',  
   cast(0 as float)                     as 'pc_comissao_estrutura',  
   cp.ic_comissao_categoria,  
   cp.ic_resumo_comissao_categ,  
   d.ic_custo_financeiro,  
   d.vl_custo_financeiro,  
   e.nm_fantasia_vendedor               as 'NomeSetor',  
   cast ( 0 as int )                    as 'SetorEstrutura',  
   isnull(pc.vl_custo_produto,0)        as 'CustoProduto',  
   -- isnull(b.vl_unitario_item_nota,0)    as 'VendaUnitario'  
   case when @ic_deducao_icms_comissao='S'
   then
     (b.vl_unitario_item_nota-(b.vl_unitario_item_nota*b.pc_icms/100))  
   else
    isnull(b.vl_unitario_item_nota,0)
   end                                  as 'VendaUnitario',
   isnull(pc.vl_custo_comissao,0)       as 'CustoComissao',
   case when isnull(mp.nm_marca_produto,'')<>'' 
   then
     mp.nm_marca_produto
   else
     f.nm_marca_produto end             as 'MarcaProduto',
   isnull(c.pc_comissao_item_pedido,0)  as pc_comissao_item_pedido,
   case when b.dt_restricao_item_nota is null or b.dt_restricao_item_nota>@dt_final
   then
     null
   else
     b.dt_restricao_item_nota
   end                                  as dt_restricao_item_nota,
   cast(b.nm_motivo_restricao_item      as varchar(60)) as nm_motivo_restricao_item,
   c.cd_tabela_preco,
   isnull(tpp.pc_comissao_tabela_produto,0)             as pc_comissao_tabela,
   vi.nm_fantasia_vendedor             as 'VendedorInterno'  
  
from  
     nota_saida a                  with (nolock) 
  
     inner join nota_saida_item b  with (nolock) on     a.cd_nota_saida = b.cd_nota_saida  
     inner join cliente i          with (nolock) on     a.cd_cliente = i.cd_cliente  
     inner join vendedor e         with (nolock) on     a.cd_vendedor = e.cd_vendedor  
     inner join tipo_vendedor tv   with (nolock) on     e.cd_tipo_vendedor = tv.cd_tipo_vendedor  
                                                        and IsNull(ic_comissao_tipo_vendedor,'N') = 'S'  
  
     inner join operacao_fiscal o  with (nolock) on     b.cd_operacao_fiscal = o.cd_operacao_fiscal  
  
     inner join Categoria_Produto cp     with (nolock) on cp.cd_categoria_produto = b.cd_categoria_produto  
  
     left outer join pedido_venda d      with (nolock) on b.cd_pedido_venda = d.cd_pedido_venda  
  
     left outer join pedido_venda_item c with (nolock) on b.cd_pedido_venda      = c.cd_pedido_venda and  
                                                          b.cd_item_pedido_venda = c.cd_item_pedido_venda  
     left outer join produto f           with (nolock) on b.cd_produto       = f.cd_produto  
     left outer join produto_custo pc    with (nolock) on pc.cd_produto      = b.cd_produto  
     left outer join grupo_produto gr    with (nolock) on c.cd_grupo_produto = gr.cd_grupo_produto  
     left outer join status_nota h       with (nolock) on a.cd_status_nota   = h.cd_status_nota  
     left outer join Marca_Produto mp    with (nolock) on  mp.cd_marca_produto = f.cd_marca_produto 
     left outer join Tabela_Preco_Produto tpp with (nolock) on tpp.cd_produto          = b.cd_produto and
                                                               tpp.cd_tabela_preco     = c.cd_tabela_preco
     left outer join Vendedor vi              with (nolock) on vi.cd_vendedor          = d.cd_vendedor_interno      

Where  

    --09.09.2008
    --Não Filtrar

    IsNull(a.cd_vendedor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.cd_vendedor,0)  
                                 else @cd_vendedor   
                               end)   
    and  
   (a.dt_nota_saida < @dt_inicial)                 and  
   (isnull(o.ic_comercial_operacao,'N')   ='S' or isnull(o.ic_comissao_op_fiscal,'N')='S' ) and  
    isnull(a.vl_total,0) > 0                       and  
   (isnull(b.cd_status_nota,0) = 3 or                    -- Devolução Parcial  
    isnull(b.cd_status_nota,0) = 4)                and   -- Devolução Total  
   (b.dt_restricao_item_nota between @dt_inicial and   
                                     @dt_final) and  
   (b.qt_item_nota_saida*(case ic_tipo_nota_saida_item when 'S' then   
                          b.vl_servico else b.vl_unitario_item_nota end)) > 0 and  
    -- comissão é feita pelo preço orçado (isnull para os casos de nota sem pedido)  
   (isnull(c.vl_lista_item_pedido,1) > 0)     and     
   ((isnull(cp.ic_comissao_categoria,'N')='S') -- PADRÃO POLIMOLD - Solicitado pelo Carlos - (DUELA)  
    or  
    ((@cd_parametro in (1,6)) and (isnull(cp.ic_resumo_comissao_categ,'N')='S'))) -- Eduardo - 11/02/2004  
  
Order by 'setor',  
         'codigocategoria',  
         'cliente'  
  

--print 'Selecionou as Notas/Pedidos'  
  
--------------------------------------------------------------------------------  
--Montagem do Cálculo de comissão de Vendas pela Estrutura comercial de Vendas  
--------------------------------------------------------------------------------  
  
if ( @ic_estrutura_comissao = 'S' )  
begin  
  
--  print 'Inserindo registros dos Vendedores da Estrutura.'  
  
  --Tabela Auxiliar que irá gerar a tabela de vendedores que  
  --recebem e repassam comissao pela Estrutura Comercial  
  --select * from estrutura_venda

  select distinct  
    c.setor,  
    ev.cd_estrutura_venda,
    ev.cd_mascara_estrutura_vend  
  into  
    #Vendedor_Estrutura  
  from  
    #Comissao c  
  
    inner join  
      Vendedor v    
      with (nolock) on v.cd_vendedor = c.setor  
  
    inner join  
      Estrutura_Venda ev with (nolock) on ev.cd_estrutura_venda = v.cd_estrutura_venda  
  
  where  
    --Verifica se no Cálculo existe Pedido de Vendedor que repassa a Comissão  
    isnull(ev.ic_recebe_comissao,'N')  = 'S' and  
    isnull(ev.ic_repassa_comissao,'N') = 'S'  
  
--  select * from #Vendedor_Estrutura  
  
  
  --Tabela Auxilar que Monta a Estrutura que receberá comissão em função  
  --das Vendas dos Vendedores acima  
  --select * from estrutura_venda_comissao
  
  select  
    ve.setor,  
    ve.cd_mascara_estrutura_vend,
    evc.cd_estrutura_comissao,  
    v.cd_vendedor                     as 'VendedorComissao',  
    isnull(v.pc_comissao_vendedor, 0) as pc_comissao_vendedor, 
    v.cd_tipo_vendedor,
    evc.cd_estrutura_venda,
    v.cd_estrutura_venda              as cd_estrutura_venda_vendedor  
  into  
    #Comissao_Estrutura  

  from  
    #Vendedor_Estrutura ve  
  
    inner join Estrutura_Venda_Comissao evc  with (nolock) on evc.cd_estrutura_venda = ve.cd_estrutura_venda  
    inner join Vendedor v                    with (nolock) on v.cd_estrutura_venda   = evc.cd_estrutura_comissao  
  
--   select * from #Comissao_Estrutura  
  
--   drop table #Vendedor_Estrutura  
  
  -- Incluir os registros de comissão dos vendedores que recebem  
  -- pela estrutura na tabela temporária de registros  
  -- de comissões "#Comissao"    

  insert into  
    #Comissao  
  select  
    --Vendedor que recebe a comissão  
    ce.VendedorComissao   as 'Setor',  
    c.cd_vendedor_interno,
    c.cd_cliente,  
    c.codigocategoria,  
    c.cliente,  
    c.pedido,  
    c.item,  
    c.emissao,  
    c.qtd,  
    c.venda,  
    c.IcmsDescontado,  
    c.CustoFinanceiroDescontado,  
    c.FreteDescontado,  
    c.EmbalagemDescontada,  
    c.venda_comissao,  
    c.orcado,  
    c.cd_identificacao_nota_saida,
    c.nota,  
    c.itemnota,  
    c.datanota,  
    c.descto,  
    c.codprod,  
    c.codant,  
    c.descricao,  
    c.dtentrpcp,  
    c.smo,  
    c.status,  
    c.datacanc,  
    c.devolucao,  
    c.devolvido,  
    ce.cd_tipo_vendedor               as 'tipovendedor',  
    isnull(ce.pc_comissao_vendedor,0) as 'pc_comissao_vendedor',  
    cast(0 as float)                  as 'ppedido',  
    c.pproduto,  
    c.pgrupo,  
    c.devolucaomes,  
    c.devolucaomesant,  
    c.qtdevolucao,  
    cast(0 as float)                     as 'pc_comissao_especifico',  
    c.vl_total_item,  
    c.pc_icms,  
    c.pc_icms_desc_item,  
    ce.cd_estrutura_comissao,   
    isnull(pvev.pc_comissao_estrutura,0) as 'pc_comissao_estrutura',  
    c.ic_comissao_categoria,  
    c.ic_resumo_comissao_categ,  
    c.ic_custo_financeiro,  
    c.vl_custo_financeiro,  
    v.nm_fantasia_vendedor               as 'NomeSetor',  
    c.Setor                              as 'SetorEstrutura',   --Vendedor de Origem da Comissão  
    c.CustoProduto,  
    c.VendaUnitario,
    c.CustoComissao,  
    c.MarcaProduto,
    c.pc_comissao_item_pedido,
    c.dt_restricao_item_nota,
    c.nm_motivo_restricao_item,
    c.cd_tabela_preco,
    c.pc_comissao_tabela,
    c.VendedorInterno

  from  
    #Comissao c  
    inner join     #comissao_estrutura ce             on ce.setor                = c.setor  
    left outer join Pedido_Venda_Estrutura_Venda pvev on pvev.cd_pedido_venda    = c.pedido and  
                                                         pvev.cd_estrutura_venda = ce.cd_estrutura_comissao  

    left outer join Vendedor v  with (nolock)         on v.cd_vendedor           = ce.VendedorComissao  
  where  
( isnull(pvev.ic_pagamento_comissao,'S') = 'S' )  

--   select * from #Vendedor_Estrutura
--   select * from #Comissao_estrutura
--   select * from #Comissao
  
  drop table #Comissao_Estrutura     
  drop table #Vendedor_Estrutura  
  
--  print 'Inseriu os registros da Estrutura Comercial'   
  
end  
  
--Para debugar, mostrar o que foi selecionado  
--delete from #Comissao where nota not in (57955)  
--select * from nota_saida where cd_nota_saida in (57364,57368)  
  
-- select * from #Comissao order by nota  
--drop table #Comissao  
--return  
  
--Verifica se a empresa checa visita de vendedor para pagamento de comissão  

if @ic_visita_comissao = 'S'   
begin  
  
--   Select *  From  #Comissao  
--   where @qt_dia_visita_comissao >=  
--    (select DATEDIFF(day,Max(dt_visita),#Comissao.emissao) from visita v  
--    where v.cd_cliente = #Comissao.cd_cliente and v.dt_visita <= #Comissao.emissao and v.cd_vendedor = #Comissao.setor)  
  
  
--  print 'Deleta'  
  
    
  Delete From  #Comissao  
  where @qt_dia_visita_comissao >=  
   (select DATEDIFF(day,Max(dt_visita),#Comissao.emissao ) from visita v  
   where v.cd_cliente = #Comissao.cd_cliente and v.dt_visita <= #Comissao.emissao and v.cd_vendedor = #Comissao.setor)  

end  
  
-------  
-- Realiza os Cálculos das comissões dos vendedores / Representantes  
-------  
  
select  
  
       vc.cd_tipo_desconto_comissao as 'tabelacomissao',  
       vc.cd_regiao_venda           as 'regiao',   
       vc.cd_tipo_comissao          as 'tipocalculo',  
  
       cp.cd_mascara_categoria      as 'Categoria',  
       cp.sg_categoria_produto      as 'Sigla',  
       cp.cd_mascara_categoria      as 'MascaraCategoria',    
       cp.nm_categoria_produto      as 'DescricaoCategoria',    
       IsNull(cp.cd_ordem_categoria, cp.cd_categoria_produto) as 'Ordem',  
  
       c.*,  
  
       c.pc_comissao_especifico        as 'Comissao_pelo_Pedido',  
       c.pc_comissao_estrutura         as 'Comissao_Especifica_pela_Estrutura',  
       cli.pc_comissao_cliente         as 'Comissao_pelo_Cliente',  
       c.pc_comissao_vendedor          as 'Comissao_pelo_Cadastro_do_Vendedor',  
       catdc.pc_comissao_desc_comissao as 'Comissao_pela_Categoria',  
       vc.pc_comissao_vendedor         as 'Comissao_pela_Comissao_do_Vendedor',         
  
       --(%) de comissão  
  
       percomissao =  
       case   
         --Se a Comissão está no item do Pedido de Venda
         when isnull(c.pc_comissao_item_pedido,0) <> 0   then  c.pc_comissao_item_pedido  

         -- Se a Categoria deve sair no Resumo mas não recebe comissão  
         when isnull(c.ic_comissao_categoria,'N') <> 'S' then 0.00  
  
         --Pegar comissão Específica definida no Pedido de Venda  
         when isnull(c.pc_comissao_especifico,0) > 0 then c.pc_comissao_especifico  
  
         --Pegar comissão Específica definida para este item na Estrutura  
         when isnull(c.pc_comissao_estrutura,0) > 0 then c.pc_comissao_estrutura  
  
         --Pegar comissão definida no cadastro do cliente  
         when isnull(cli.pc_comissao_cliente,0) > 0 then cli.pc_comissao_cliente  
  
         --Pegar comissão definida no cadastro do vendedor  
         when isnull(c.pc_comissao_vendedor,0) > 0 then c.pc_comissao_vendedor  
  
         --Pegar comissão definida na Categoria do Produto  
         when isnull(catdc.pc_comissao_desc_comissao,0) > 0 then catdc.pc_comissao_desc_comissao  

         --Tabela de Preço do Produto

         when isnull(c.pc_comissao_tabela,0)>0 then c.pc_comissao_tabela           
       else  
         case  
           when vc.cd_tipo_comissao = 1 then dc.pc_comissao_desc_comissao  -- Por desconto  
           when vc.cd_tipo_comissao = 2 then vc.pc_comissao_vendedor       -- (%) Fixo  
           when vc.cd_tipo_comissao = 3 then 0                             -- Salário Fixo   
           when vc.cd_tipo_comissao = 4 then c.pproduto                    -- Por produto  
           when vc.cd_tipo_comissao = 5 then c.pgrupo                      -- Por grupo de produto  
           when vc.cd_tipo_comissao = 6 then c.ppedido                     -- Por pedido  

           --Vendedor x Categoria Produto  
           when vc.cd_tipo_comissao = 7 then ( select pc_comissao_prod_vendedor from Vendedor_produto_comissao where c.setor = cd_vendedor and c.codigocategoria = cd_categoria_produto) --VendedorxCategoria Produto  

           --when vc.cd_tipo_comissao = 8 then isnull(cli.pc_comissao_cliente,0)       --Por Cliente

           --Faixa de Comissão        
           when vc.cd_tipo_comissao = 9 then isnull(fc.pc_comissao_faixa_comissao,0) --faixa de Comissão  

           --Tabela de Preço do Produto
           when vc.cd_tipo_comissao = 14 then isnull(c.pc_comissao_tabela,0)         --Tabela de Preço do Produto

           --Margem de Lucro por Custo de Reposição
           when vc.cd_tipo_comissao = 11 and c.custoProduto>0 then   
              case when ((c.vendaunitario/c.custoproduto)-1)*4<=10  
                 then case when round(((c.vendaunitario/c.custoproduto)-1)*4,4)>0  
                      then  
                        round(((c.vendaunitario/c.custoproduto)-1)*4,4)  
                      else 0.00 end   
                 else @pc_comissao_empresa end  

           --Margem de Lucro por Custo de Comissão

           when vc.cd_tipo_comissao = 12 and c.custoComissao>0 then   
              case when ((c.vendaunitario/c.custoComissao)-1)*4<=10  
                 then case when round(((c.vendaunitario/c.custoComissao)-1)*4,4)>0  
                      then  
                        round(((c.vendaunitario/c.custoComissao)-1)*4,4)  
                      else 0.00 end   
                 else @pc_comissao_empresa end  

           else 0.00  
         end  
       end,  
  
       --Valor da Comissão  
  
       comissao =  
       case   
         --Se a Comissão está no item do Pedido de Venda
         when isnull(c.pc_comissao_item_pedido,0) <> 0   then  c.venda_comissao * (c.pc_comissao_item_pedido/100)  

         -- Se a Categoria deve sair no Resumo mas não recebe comissão  
         when isnull(c.ic_comissao_categoria,'N') <> 'S' then 0  
  
         --Pegar comissão Específica definida no Pedido de Venda  
         when isnull(c.pc_comissao_especifico,0) > 0 then c.venda_comissao * (c.pc_comissao_especifico/100)  
  
         --Pegar comissão Específica definida para este item na Estrutura  
         when isnull(c.pc_comissao_estrutura,0) > 0 then c.venda_comissao * (c.pc_comissao_estrutura/100)  
  
         --Pegar comissão definida no cadastro do cliente  
         when isnull(cli.pc_comissao_cliente,0) > 0 then c.venda_comissao * (cli.pc_comissao_cliente/100)  
  
         --Pegar comissão definida no cadastro do vendedor  
         when isnull(c.pc_comissao_vendedor,0) > 0 then c.venda_comissao * (c.pc_comissao_vendedor/100)   
  
         --Pegar comissão definida na Categoria do Produto  
         when isnull(catdc.pc_comissao_desc_comissao,0) > 0 then c.venda_comissao * (catdc.pc_comissao_desc_comissao/100)  

         --Tabela de Preço do produto
         when isnull(c.pc_comissao_tabela,0)>0 then c.venda_comissao * ( c.pc_comissao_tabela/100)  
       else  
         case  
           when vc.cd_tipo_comissao = 1  then c.venda_comissao * (dc.pc_comissao_desc_comissao/100)  --Desconto
           when vc.cd_tipo_comissao = 2  then c.venda_comissao * (vc.pc_comissao_vendedor/100)       --   
           when vc.cd_tipo_comissao = 3  then 0  
           when vc.cd_tipo_comissao = 4  then c.venda_comissao * (c.pproduto/100)  
           when vc.cd_tipo_comissao = 5  then c.venda_comissao * (c.pgrupo/100)  
           when vc.cd_tipo_comissao = 6  then c.venda_comissao * (c.ppedido/100)  
           when vc.cd_tipo_comissao = 7  then c.venda_comissao *   
                                             (( select pc_comissao_prod_vendedor from Vendedor_produto_comissao where c.setor = cd_vendedor and c.codigocategoria = cd_categoria_produto)/100)  
  
           when vc.cd_tipo_comissao = 9  then c.venda_comissao * (fc.pc_comissao_faixa_comissao/100)   
           when vc.cd_tipo_comissao = 14 then c.venda_comissao * isnull(c.pc_comissao_tabela,0) --Tabela de Preço do Produto

           when vc.cd_tipo_comissao = 11 and c.custoproduto>0 then  
             case when ((c.vendaunitario/c.custoproduto)-1)*4<=10  
                  then  
                    case when ((c.vendaunitario/c.custoproduto)-1)*4<=10  
                         then  
                           (c.venda_comissao * round(((((c.vendaunitario/c.custoproduto)-1)*4)/100),4))  
                         else   
                           0.00 end  
                  else   
                    c.venda_comissao * (@pc_comissao_empresa/100) end  

           when vc.cd_tipo_comissao = 12 and c.custocomissao>0 then  
             case when ((c.vendaunitario/c.custocomissao)-1)*4<=10  
                  then  
                    case when ((c.vendaunitario/c.custocomissao)-1)*4<=10  
                         then  
                           (c.venda_comissao * round(((((c.vendaunitario/c.custocomissao)-1)*4)/100),4))  
                         else   
                           0.00 end  
                  else   
                    c.venda_comissao * (@pc_comissao_empresa/100) end  
  
           else 0.00    
         end  
       end,  
  
       --Valor da Comissão sem Desconto  
  
       sdescto =  
       isnull(  
         case   

          --Se a Comissão está no item do Pedido de Venda
          when isnull(c.pc_comissao_item_pedido,0) <> 0   then  c.orcado * (c.pc_comissao_item_pedido/100)  

          -- Se a Categoria deve sair no Resumo mas não recebe comissão  
           when isnull(c.ic_comissao_categoria,'N') <> 'S' then 0  
  
          --Pegar comissão Específica definida no Pedido de Venda  
           when isnull(c.pc_comissao_especifico,0) > 0 then c.orcado * (c.pc_comissao_especifico/100)  
  
          --Pegar comissão Específica definida para este item na Estrutura  
          when isnull(c.pc_comissao_estrutura,0) > 0 then c.orcado * (c.pc_comissao_estrutura/100)  
  
          --Pegar comissão definida no cadastro do cliente  
           when isnull(cli.pc_comissao_cliente,0) > 0 then c.orcado * (cli.pc_comissao_cliente/100)  
  
          --Pegar comissão definida no cadastro do vendedor  
           when isnull(c.pc_comissao_vendedor,0) > 0 then c.orcado * (c.pc_comissao_vendedor/100)   
  
          --Pegar comissão definida na Categoria do Produto  
           when isnull(catdc.pc_comissao_desc_comissao,0) > 0 then c.orcado * (catdc.pc_comissao_desc_comissao/100)  
  
         --Tabela de Preço do produto
         when isnull(c.pc_comissao_tabela,0)>0 then c.venda_comissao * ( c.pc_comissao_tabela/100)  

         else  
           case   
             when vc.cd_tipo_comissao = 1 then c.orcado * (dsc.pc_comissao_desc_comissao /100)  
             when vc.cd_tipo_comissao = 2 then c.orcado * (vc.pc_comissao_vendedor/100)  
             when vc.cd_tipo_comissao = 3 then 0  
             when vc.cd_tipo_comissao = 4 then c.orcado * (c.pproduto/100)  
             when vc.cd_tipo_comissao = 5 then c.orcado * (c.pgrupo/100)  
             when vc.cd_tipo_comissao = 6 then c.orcado * (c.ppedido/100)  
             when vc.cd_tipo_comissao = 7 then c.orcado *   
                                          (( select pc_comissao_prod_vendedor from Vendedor_produto_comissao where c.setor = cd_vendedor and c.codigocategoria = cd_categoria_produto)/100)  
             when vc.cd_tipo_comissao = 9 then c.orcado *( fc.pc_comissao_faixa_comissao/100)               

             when vc.cd_tipo_comissao = 14 then c.orcado * isnull(c.pc_comissao_tabela,0) --Tabela de Preço do Produto
             --Margem de Lucro por Custo de Reposição 
             when vc.cd_tipo_comissao = 11 and c.custoproduto>0  
                  then  
                    case when ((((c.vendaunitario/c.custoproduto)-1)*4)/100)<=10  
                    then  
                      case when (c.orcado * round(((((c.vendaunitario/c.custoproduto)-1)*4)/100),4))>0   
                           then  
                             (c.orcado * round(((((c.vendaunitario/c.custoproduto)-1)*4)/100),4))  
                           else  
                             0.00  
                           end  
                    else  
                      c.orcado * (@pc_comissao_empresa/100) end  

             --Margem de Lucro por Custo da Comissão
             when vc.cd_tipo_comissao = 12 and c.custocomissao>0  
                  then  
                    case when ((((c.vendaunitario/c.custocomissao)-1)*4)/100)<=10  
                    then  
                      case when (c.orcado * round(((((c.vendaunitario/c.custocomissao)-1)*4)/100),4))>0   
                           then  
                             (c.orcado * round(((((c.vendaunitario/c.custocomissao)-1)*4)/100),4))  
                           else  
                             0.00  
                           end  
                    else  
                      c.orcado * (@pc_comissao_empresa/100) end  

             else 0.00  
           end  
         end, 0.00),  
  
       vc.ic_calcula_data_final,  
       c.emissao                       as  'data_calculo',  
       vc.dt_base_pagto_comissao,  
       vc.dt_base_final_comissao,  
       catdc.pc_comissao_desc_comissao as 'pc_comissao_desc_categoria',  
  
       -- Colunas das Deduções via Markup  
       cast(0.00 as float)             as 'ICMS_DEDUZIDO',  
       cast(0.00 as float)             as 'PISCOFINS_DEDUZIDO',  
       cast(0.00 as float)             as 'CPMF_DEDUZIDO',  
       cast(0.00 as float)             as 'CUSTOFIN_DEDUZIDO',  
       vc.cd_tipo_comissao
  
  
-------  
into   
  #Calculo_Comissao  
-------  
from  
   #Comissao c  
  
   Inner Join categoria_produto cp with (nolock) on cp.cd_categoria_produto = c.codigocategoria  
   Inner Join cliente cli          with (nolock) on cli.cd_cliente = c.cd_cliente  
  
   --Tabela onde está definido o tipo de comissão que será calculada para o Vendedor  
   --select * from vendedor_comissao  
  
   Left Outer join vendedor_comissao vc on c.setor = vc.cd_vendedor  
  
   -- faixas de descontos por categoria  
   -- select * from categoria_desconto_comissao  
  
   Left Outer join categoria_desconto_comissao catdc   
         on IsNull(catdc.cd_categoria_produto,1) = IsNull(c.codigocategoria,1)  
         and  
         (IsNull(catdc.cd_tipo_desconto_comissao,1) = IsNull( vc.cd_tipo_desconto_comissao, 1 )) -- se não estiver definido, pegar a tabela de desconto PADRÃO  
         and  
         ((IsNull(c.descto,0) = 0 and catdc.cd_desconto_comissao=1)  
         or  
         (round(c.descto,2) between catdc.pc_ini_desconto_comissao and  -- (%) descto.   
                                    catdc.pc_fim_desconto_comissao))  
  
  --Select * from desconto_comissao  
  
  Left outer join desconto_comissao dc  
  on   
    ( IsNull( vc.cd_tipo_desconto_comissao, 1 ) = IsNull(dc.cd_tipo_desconto_comissao,1) ) and -- se não estiver definido, pegar a tabela de desconto PADRÃO  
    (   
      (IsNull(c.descto,0) = 0 and IsNull(dc.cd_desconto_comissao,1) = 1)  
       or  
      (round(c.descto,2) between dc.pc_ini_desconto_comissao and  -- (%) descto.   
                                 dc.pc_fim_desconto_comissao)  
    )  
  Left outer join desconto_comissao dsc -- comissão sem desconto  
    on   
    ((IsNull(dsc.cd_tipo_desconto_comissao,1) = IsNull( vc.cd_tipo_desconto_comissao, 1 )) and  
     (IsNull(dsc.pc_fim_desconto_comissao,0) = 0)) -- % comissão se não tiver dado desconto  
  
    
  --Faixa de Valores  
  --17.01.2005  
  --Carlos Fernandes  
  
  --select * from faixa_comissao  
  --select * from vendedor_comissao  
  Left outer join Faixa_Comissao fc on fc.cd_tipo_faixa_comissao = vc.cd_tipo_faixa_comissao and  
                                       round(c.venda_comissao,2) between vl_inicial_faixa_comissao and vl_final_faixa_comissao                               
  
where  
  
  (isnull(c.emissao, c.datanota) >= IsNull(vc.dt_base_pagto_comissao,isnull(c.emissao, c.datanota)))  
  and  
  ((IsNull(vc.ic_calcula_data_final,'N') = 'N')  
    or  
   (isnull(c.emissao, c.datanota) <= vc.dt_base_final_comissao))  
  and  
  IsNull(c.TipoVendedor,0) = (case ( @cd_tipo_vendedor )  
                     when 0 then IsNull(c.TipoVendedor,0)  
                     else @cd_tipo_vendedor  
                    end)  
Order by c.setor,  
         vc.cd_regiao_venda,   
         cp.cd_ordem_categoria,  
         c.devolvido,  
         c.cliente,  
         c.pedido,  
         c.item  
  
  
--print 'Realizou os cálculos das Comissões'  
  
--Para debugar, mostrar o que foi selecionado  
--select * from #Calculo_Comissao  
-- drop table #Calculo_Comissao  
-- return  
  
-----------------------------------------------------------------------------------------------  
-- Calcular as Deduções  
-----------------------------------------------------------------------------------------------  
  
if ( @cd_parametro in ( 0, 6 )) and   
  ( @ic_mostrar_deducoes = 'S' ) and ( @cd_aplicacao_markup > 0 )  
begin  
   
  -- criar um índice temporário para agilizar os UPDATES  
  create index IX_Temp_Calculo_Comissao on  
    #Calculo_Comissao (nota, itemnota)  
  
  declare @nota         int  
  declare @itemnota     int  
  declare @custofin     float  
  declare @icms         float  
  declare @campodeducao varchar(30)  
  declare @pcdeduzido   float  
  declare @valorvenda   float  
  declare @sql          varchar(800)  
  
  declare cr cursor for  
    select nota, itemnota, CustoFinanceiroDescontado, IcmsDescontado, venda  
    from #Calculo_Comissao  
  
  open cr  
  fetch next from cr into @nota, @itemnota, @custofin, @icms, @valorvenda  
  
  /*  
     select tm.* from Formacao_markup fm  
       inner join tipo_markup tm  
        on fm.cd_tipo_markup = tm.cd_tipo_markup  
     where fm.cd_aplicacao_markup = 4  
  */  
  
  while ( @@FETCH_STATUS = 0 )  
  begin  
  
    declare crDeducoes cursor for      
      select  
        tm.sg_tipo_markup,  
        'pc_formacao_markup' =  
          -- tipo de cálculo  
          case when IsNull(fm.ic_tipo_formacao_markup,'A') = 'A'  
               then  
                 -- puxar percentuais da nota ou do Pedido  
                 case when ( IsNull(tm.ic_nota_tipo_markup,'N') = 'S' )  
                      then  
                        -- puxar o percentual depedendo do tipo do Markup  
                        case when ( upper(tm.sg_tipo_markup) = 'CUSTOFIN' )  
                             then IsNull( @custofin, 0 )  
                             else IsNull( @icms, 0 )  
                        end  
                      else  
                        IsNull(fm.pc_formacao_markup,0)  
                 end  
               else  
                 0  
          end        
      from   
        Formacao_markup fm         with (nolock)  
        inner join tipo_markup tm  with (nolock) on fm.cd_tipo_markup = tm.cd_tipo_markup  
        
      where   
        cd_aplicacao_markup = @cd_aplicacao_markup  
  
    open crDeducoes  
    fetch next from crDeducoes into @campodeducao, @pcdeduzido  
  
    while ( @@FETCH_STATUS = 0 )  
    begin  
  
      set @sql =  
        'update #Calculo_Comissao ' +  
          'set ' + rtrim( @campodeducao ) + '_DEDUZIDO = ' +   
            cast( @valorvenda * @pcdeduzido / 100 as varchar) + ' ' +  
        'where ' +  
          'nota = ' + cast(@nota as varchar) + ' and ' +  
          'itemnota = ' + cast(@itemnota as varchar)  
  
--    print '-----------------'  
--    print @sql  
      exec( @sql )  
  
      -- puxar próximos valores  
      fetch next from crDeducoes into @campodeducao, @pcdeduzido  
    end  
  
    close crDeducoes  
    deallocate crDeducoes  
  
    -- puxar próximos valores  
    fetch next from cr into @nota, @itemnota, @custofin, @icms, @valorvenda  
  end -- while  
  
  close cr  
  deallocate cr  
  
--  print 'Calculou as Deduções'  
  
end -- if  
  
-----------------------------------------------------------------------------------------------  
--  
-- Verifica o Tipo de Parâmetro para o retorno  
--  
-----------------------------------------------------------------------------------------------  
  
begin transaction  
  
-----------------------------------------------------------------------------------------------  
-- Analítico da Comissão - Geral  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 0   
begin  
  
  -- Retornar os Dados   
  select   
    cc.*,  
    v.nm_fantasia_vendedor as VendedorOrigem
           
  from  
    #Calculo_Comissao cc  
    left outer join Vendedor V on v.cd_vendedor = cc.SetorEstrutura  

  where
      IsNull(cc.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(cc.setor,0)  
                                 else @cd_vendedor   
                               end)   
  Order by cc.setor,  
           cc.regiao,  
        --   cc.ordem,  
           cc.mascaracategoria,  
           cc.devolvido,  
           cc.cliente,  
           cc.pedido,  
           cc.item  
  
   goto TrataErro  
  
end  
  
-----------------------------------------------------------------------------------------------  
-- Fechamento Mensal do processamento da Comissão  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 9  
begin  
  
  -- Retornar os Dados   
  select   
    cc.*,  
    v.nm_fantasia_vendedor as VendedorOrigem       
  from  
    #Calculo_Comissao cc  
    left outer join Vendedor V on v.cd_vendedor = cc.SetorEstrutura  
  where
      IsNull(cc.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(cc.setor,0)  
                                 else @cd_vendedor   
                               end)   

  Order by cc.setor,  
           cc.regiao,  
        --   cc.ordem,  
           cc.mascaracategoria,  
           cc.devolvido,  
           cc.cliente,  
           cc.pedido,  
           cc.item  
  
   --Geração da Tabela de Histórico do Cálculo da Comissão  
   --Carlos 27.06.2005  
  
  
  
   goto TrataErro  
  
end  
  
  
-----------------------------------------------------------------------------------------------  
-- Atualiza a tabela de cálculo do movimento de comissões e retorna resumo por categoria   
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 1    
begin  
  
   -- Monta Tabela Agrupada por Vendedor  
  
   select setor,  
          regiao,  
          sum(venda)                        as 'TotalVendas',     -- Total Comissionável  
          sum(comissao)                     as 'TotalComissao',   -- Total Comissão  
          sum(sdescto)                      as 'TotalSDesconto',  -- Total sem Desconto  
         (100-(sum(venda)/sum(orcado))*100) as 'Desconto'         -- % Aplicado  
   -------  
   into #Resumo  
   -------  
   from  
       #Calculo_Comissao  
  
   group by setor, regiao  
   order by setor, regiao  
  
--   print 'Agrupou por Vendedor'  
  
   --Atualiza a tabela de movimento  
  
   declare @cd_parametro_comissao     int  
   declare @cd_vendedor_lancamento    int  
   declare @cd_regiao_venda           int  
   declare @vl_comissionavel          float  
   declare @vl_comissao               float  
   declare @vl_comissao_sem_desconto  float  
   declare @pc_desconto               float  
   declare @cd_categoria_produto      int  
   declare @cd_vendedor_localizado    int  
  
   set @cd_parametro_comissao = (select top 1 cd_parametro_comissao   
                                 from parametro_comissao  
                                 where dt_base_comissao = @dt_final)     
  
   set @cd_vendedor_lancamento   = 0  
   set @cd_regiao_venda          = 0  
   set @vl_comissionavel         = 0  
   set @vl_comissao              = 0  
   set @vl_comissao_sem_desconto = 0  
   set @pc_desconto              = 0  
   set @cd_vendedor_localizado   = 0  
  
   while exists ( select top 1 * from #Resumo )  
   begin  
  
      select Top 1  
             @cd_vendedor_lancamento   = Setor,  
             @cd_regiao_venda          = Regiao,  
             @vl_comissionavel         = TotalVendas,  
             @vl_comissao              = TotalComissao,  
             @vl_comissao_sem_desconto = TotalSDesconto,  
             @pc_desconto              = Desconto  
  
      from #Resumo  
  
      -- Verificar se foi definida a Região de Venda  
      if ( @cd_regiao_venda is null )  
      begin  
        select top 1  
          @nm_vendedor = nm_vendedor  
        from  
          Vendedor  with (nolock) 
        where  
          cd_vendedor = @cd_vendedor_lancamento  
  
        raiserror('Não foi possível calcular pois o Vendedor "%s" (%d) não possui Região de Venda definida!',  
                  16, 1, @nm_vendedor, @cd_vendedor_lancamento)  
        goto TrataErro  
      end  
  
      -- Verifica se já foi feito os lançamentos para o vendedor  
  
      Select   
        @cd_vendedor_localizado = cd_vendedor  
      from  
        Movimento_Comissao  with (nolock) 
      where  
         cd_parametro_comissao = @cd_parametro_comissao and   
         cd_vendedor           = @cd_vendedor_lancamento and  
         cd_regiao_venda       = @cd_regiao_venda  
  
      -- Insere registro novo de cálculo  
  
      if @@rowcount = 0  
      begin       
                                     
         -- Parâmetros : O primeiro UM é o tipo de lançamento (1=Valor comissionável, 2=Valor da comissão)  
         --            : O segundo UM faz parte do índice, é o identificador  
  
         insert into Movimento_Comissao  
         values (@cd_parametro_comissao, @cd_vendedor_lancamento, @cd_regiao_venda, 1, 1, null, @vl_comissionavel, null, 0, GetDate())  
  
         insert into Movimento_Comissao   
         values (@cd_parametro_comissao, @cd_vendedor_lancamento, @cd_regiao_venda, 2, 1, null, @vl_comissao, null, 0, GetDate())  
  
--       print 'Inseriu Movimentos para o Vendedor nr. ' + cast(@cd_vendedor_lancamento as varchar)  
  
      end  
  
      else  
  
      begin  
           
         -- Valor Total Comissionavel  
           
         update Movimento_Comissao  
         set vl_lancamento_comissao = @vl_comissionavel  
         where  
  
            @cd_parametro_comissao = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda = cd_regiao_venda and  
            cd_ocorrencia_comissao = 1  
  
         -- Valor Total da Comissão  
  
         update Movimento_comissao  
         set vl_lancamento_comissao = @vl_comissao  
         where  
  
            @cd_parametro_comissao  = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda        = cd_regiao_venda and  
            cd_ocorrencia_comissao  = 2  
  
--         print 'Atualizou Movimentos do Vendedor nr. ' + cast(@cd_vendedor_lancamento as varchar)  
  
      end  
  
      -- Deletar o registro atualizado  
  
      delete from   
         #Resumo  
      where   
         setor  = @cd_vendedor_lancamento and  
         regiao = @cd_regiao_venda  
  
   end  
  
   --  
   --Atualiza a tabela de resumos de comissão  
   --  
  
   -- Monta Tabela Agrupada por Vendedor e Categoria  
  
   Select setor,  
          regiao,  
          isnull(codigocategoria,0) as 'CodigoCategoria',  
          sum(venda)                as 'TotalVendas',       -- Total Comissionável  
          sum(comissao)             as 'TotalComissao',     -- Total Comissão  
          sum(sdescto)              as 'TotalSDesconto',    -- Total sem Desconto  
         'Desconto' =                                 -- % Aplicado de Desconto  
          case when (sum(venda) > 0) and (sum(orcado) > 0) then  
             (100-(sum(venda) / sum(orcado))*100)  
          else 0 end  
   -------  
   into   
      #ResumoVendedorCategoria  
   -------  
   from  
      #Calculo_Comissao  
   group by   
      setor,  
      regiao,  
  codigocategoria  
   order by   
      setor,  
      regiao,  
      codigocategoria  
  
--   print 'Agrupou os totais por Vendedor/Categoria'  
  
   while exists ( select top 1 * from #ResumoVendedorCategoria )  
   begin  
  
      select Top 1  
             @cd_vendedor_lancamento   = Setor,  
             @cd_categoria_produto     = CodigoCategoria,  
             @cd_regiao_venda          = Regiao,  
             @vl_comissionavel         = TotalVendas,  
             @vl_comissao              = TotalComissao,  
             @vl_comissao_sem_desconto = TotalSDesconto,  
             @pc_desconto              = Desconto  
  
      from #ResumoVendedorCategoria  
  
      -- Verifica se já foi feito os lançamentos de resumos  
  
      select @cd_vendedor_localizado = cd_vendedor  
      from  
         Resumo_Comissao  with (nolock) 
      where  
         cd_parametro_comissao = @cd_parametro_comissao and   
         cd_vendedor           = @cd_vendedor_lancamento and  
         cd_regiao_venda       = @cd_regiao_venda and  
         cd_categoria_produto  = @cd_categoria_produto  
  
      -- Insere registro novo no resumo se não localizou  
  
      if @@rowcount = 0  
      begin       
                                     
         insert Resumo_Comissao   
         values (@cd_parametro_comissao, @cd_vendedor_lancamento, @cd_regiao_venda, @cd_categoria_produto,  
                 @vl_comissao, @vl_comissao_sem_desconto, @pc_desconto, getdate(), 0, getdate() )  
  
--         print 'Inseriu Resumo para o Vendedor nr. ' + cast(@cd_vendedor_lancamento as varchar) +  
--               ' na categoria nr. ' + cast(@cd_categoria_produto as varchar)  
  
      end  
  
      else  
  
      begin  
  
         update Resumo_Comissao  
         set vl_comissao = @vl_comissao  
         where  
            @cd_parametro_comissao = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda = cd_regiao_venda and  
            @cd_categoria_produto = cd_categoria_produto  
  
         update Resumo_Comissao  
         set vl_comissao_sem_desconto = @vl_comissao_sem_desconto  
         where  
            @cd_parametro_comissao  = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda        = cd_regiao_venda and  
            @cd_categoria_produto   = cd_categoria_produto  
  
         update Resumo_Comissao  
         set pc_desconto = @pc_desconto  
         where  
            @cd_parametro_comissao = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda = cd_regiao_venda and  
            @cd_categoria_produto = cd_categoria_produto  
  
         update Resumo_Comissao  
         set dt_calculo = GetDate()  
         where  
            @cd_parametro_comissao = cd_parametro_comissao and  
            @cd_vendedor_lancamento = cd_vendedor and  
            @cd_regiao_venda = cd_regiao_venda and  
            @cd_categoria_produto = cd_categoria_produto  
  
--         print 'Atualizou Resumo do Vendedor nr. ' + cast(@cd_vendedor_lancamento as varchar) +  
--               ' na categoria nr. ' + cast(@cd_categoria_produto as varchar)  
  
      end  
  
      -- Deletar o registro atualizado  
  
      delete from   
         #ResumoVendedorCategoria  
      where setor = @cd_vendedor_lancamento and  
            codigocategoria = @cd_categoria_produto and  
            regiao = @cd_regiao_venda  
  
   end  
  
   -- Mostra resumo total por categoria  
  
   select a.ordem,  
          Max(a.categoria)                            as 'Categoria',  
          Max(a.DescricaoCategoria)                   as 'DescricaoCategoria',  
          Max(a.sigla)                                as 'Sigla',  
          sum(a.qtd)-sum(2*a.qtdevolucao)             as 'TotalQtd',  
          sum(a.venda)                                as 'Faturamento',  
          sum(a.devolucaomes)+sum(a.devolucaomesant)  as 'TotalDevolucao',  
          sum(a.orcado)                               as 'TotalOrcado',  
          sum(a.qtdevolucao)                          as 'TotalQtdDev',  
          sum(a.comissao)                             as 'TotalComissao',  
          sum(a.sdescto)                              as 'TotalSDescto',  
         'desconto' =   
          case when (sum(venda) > 0) and (sum(orcado) > 0) then  
             (100-(sum(venda)/sum(orcado))*100)  
          else 0 end  
  
   from  
      #Calculo_Comissao a  
  
   group by a.ordem,a.categoria  
   order by a.ordem  
  
   goto TrataErro  
  
end  
  
-----------------------------------------------------------------------------------------------  
-- Resumo das comissões por vendedor  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 2    
begin  
  
   select a.Setor,  
          a.NomeSetor                        as 'NomeSetor',  
          max(a.Setor)                       as 'Codigo',  
          sum(a.orcado)                      as 'TotalOrcado',  
          sum(a.qtd)-  
          sum(2 * a.qtdevolucao)             as 'TotalQtd',  
          sum(a.devolucaomes)+  
          sum(a.devolucaomesant)             as 'TotalDevolucao',  
          sum(a.venda)                       as 'Faturamento',  
          sum(a.comissao)                    as 'TotalComissao',  
          sum(a.sdescto)                     as 'TotalSDescto'  
   from  
      #Calculo_Comissao a  
  
  where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   
   group by   
      a.Setor,  
      a.NomeSetor  
   order by   
      a.NomeSetor  
  
   goto TrataErro  

end  
  
-----------------------------------------------------------------------------------------------  
-- Resumo das comissões por categoria (Agrupado por Setor e Categoria)  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 3   
begin  
  
   select a.Setor,  
          a.NomeSetor                        as 'NomeSetor',  
          a.ordem,  
          Max(a.categoria)                   as 'Categoria',  
          Max(a.sigla)                       as 'Sigla',  
          Max(a.descricaocategoria)          as 'DescricaoCategoria',  
          sum(a.orcado)                      as 'TotalOrcado',  
          sum(a.qtd)-  
          sum(2*a.qtdevolucao)               as 'TotalQtd',  
          sum(a.devolucaomes)+  
          sum(a.devolucaomesant)             as 'TotalDevolucao',  
          sum(a.venda)                       as 'Faturamento',  
          sum(a.comissao)                    as 'TotalComissao',  
          sum(a.sdescto)                     as 'TotalSDescto'  
   from  
      #Calculo_Comissao a  
   where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   

   group by   
      a.Setor,  
      a.NomeSetor,   
      a.ordem  
   order by   
      a.NomeSetor,  
      a.ordem  
  
   goto TrataErro  
  
end  
  
-----------------------------------------------------------------------------------------------  
-- Analítico da comissão por Categoria Selecionada  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 4    
begin  
   select   
      a.*,  
      v.nm_fantasia_vendedor as VendedorOrigem       
   from  
      #Calculo_Comissao a  
      left outer join Vendedor V on v.cd_vendedor = a.SetorEstrutura  
  where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   

   order by a.ordem,  
            a.devolvido,  
            a.datanota,  
            a.nota  
  
   goto TrataErro  
end  
  
-----------------------------------------------------------------------------------------------  
-- Resumo das comissões por categoria (Agrupado pela Categoria)  
-----------------------------------------------------------------------------------------------  
if @cd_parametro = 5   
begin  
   select a.ordem,  
          Max(a.categoria)                   as 'Categoria',  
          Max(a.sigla)                       as 'Sigla',  
          Max(a.descricaocategoria)          as 'DescricaoCategoria',  
          sum(a.orcado)                      as 'TotalOrcado',  
          sum(a.qtd)-  
          sum(2*a.qtdevolucao)               as 'TotalQtd',  
          sum(a.devolucaomes)+  
          sum(a.devolucaomesant)             as 'TotalDevolucao',  
          sum(a.venda)                       as 'Faturamento',  
          sum(a.comissao)                    as 'TotalComissao',  
          sum(a.sdescto)                     as 'TotalSDescto'  
   from  
      #Calculo_Comissao a  

  where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   
  
   group by a.ordem  
   order by a.ordem  
  
   goto TrataErro  
end  
  
-----------------------------------------------------------------------------------------------  
-- Detalhado (usado apenas para DEBUG)  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 6  
begin  
  
-- --   select ns.cd_nota_saida, ns.dt_nota_saida, nsi.cd_pedido_venda, vw.nm_razao_social, v.nm_vendedor, cast(ns.vl_total as money)  
-- --   from nota_saida ns  
-- --   inner join nota_saida_item nsi on nsi.cd_nota_saida = ns.cd_nota_saida  
-- --   inner join operacao_fiscal o on o.cd_operacao_fiscal = nsi.cd_operacao_fiscal  
-- --   left outer join #Calculo_Comissao c on c.nota = nsi.cd_nota_saida and c.item = nsi.cd_item_nota_saida  
-- --   left outer join vw_destinatario_rapida vw on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and  
-- --     vw.cd_destinatario = ns.cd_cliente  
-- --   left outer join Vendedor v on v.cd_vendedor = ns.cd_vendedor  
-- --   where   
-- --   ( c.nota is null )  
-- --   and ( ns.dt_nota_saida between @dt_inicial and @dt_final )     
-- --   and ( isnull( nsi.cd_status_nota , 0 ) <> 7 )  
-- --   and ( o.ic_comercial_operacao = 'S' )  
  
   select a.NomeSetor as nm_fantasia_vendedor,  
          a.Setor     as cd_vendedor,  
          a.codigocategoria,  
          a.ic_comissao_categoria,  
          a.ic_resumo_comissao_categ,  
          a.pedido,  
          a.item,  
          a.cd_identificacao_nota_saida,
          a.nota,  
          a.descto,   
  
          a.tipocalculo,  
  
          a.Comissao_pelo_Pedido,  
          a.Comissao_Especifica_pela_Estrutura,  
          a.Comissao_pelo_Cliente,  
          a.Comissao_pelo_Cadastro_do_Vendedor,  
          a.Comissao_pela_Categoria,  
          a.Comissao_pela_Comissao_do_Vendedor,  
  
          a.percomissao,  
          a.cd_estrutura_comissao,   
  
          a.orcado,  
          a.venda,  
          a.venda_comissao,  
          a.comissao,  
          a.sdescto,  
  
          a.ic_custo_financeiro,  
          a.vl_custo_financeiro,  
  
          a.vl_total_item,  
          a.pc_icms,  
          a.pc_icms_desc_item,  
  
          a.IcmsDescontado,  
          a.CustoFinanceiroDescontado,  
          a.FreteDescontado,  
          a.EmbalagemDescontada,  
  
          -- Colunas das Deduções via Markup  
          ICMS_DEDUZIDO,  
          PISCOFINS_DEDUZIDO,  
          CPMF_DEDUZIDO,  
          CUSTOFIN_DEDUZIDO  
   from  
      #Calculo_Comissao a  

  where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   

   order by a.nota  
  
   goto TrataErro  
  
end  
  
-----------------------------------------------------------------------------------------------  
-- Sintético da comissão por Categoria Selecionada por Nota Fiscal  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 7  
begin  
   select   
     max(a.ordem)                as ordem,  
     max(a.devolvido)            as devolvido,  
     a.cliente                   as cliente,  
     max(a.pedido)               as pedido,
     a.nota                      as nota,        
     max(a.cd_identificacao_nota_saida) as cd_identificacao_nota_saida,
     max(a.datanota)             as datanota,         
     sum( isnull(a.qtd,0) )      as qtd,  
     sum( isnull(a.venda,0))     as venda,  
     sum( isnull(a.comissao,0))  as comissao,   
     (((sum( isnull(a.comissao,0))) * 100) /   
     sum( case when isnull( a.venda,0)> 0 then a.venda else 1 end ))    as pc_comissao_vendedor,  
     max(a.percomissao)          as percomissao,   
     a.Setor,
     max(a.dt_restricao_item_nota)   as datadevolucao,
     max(a.nm_motivo_restricao_item) as motivodev
   from  
      #Calculo_Comissao a  

   where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   

   group by   
     a.cliente,  
     a.nota,  
     a.Setor  
    order by a.Setor,  
--             a.Cliente,  
             a.datanota,  
             a.nota  
  
   goto TrataErro  
  
end  


-----------------------------------------------------------------------------------------------  
-- Sintético da comissão por Categoria Selecionada por Nota Fiscal  
-----------------------------------------------------------------------------------------------  
  
if @cd_parametro = 8
begin  

   select   

    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_pagamento_documento,
    d.vl_pagamento_documento,
    d.vl_documento_receber,
    d.vl_abatimento_documento,
    d.Valor_Parcela_Sem_IPI,
    d.cd_identificacao_nota_saida,
    d.dt_nota_saida                     as datanota,         
    d.cd_pedido_venda                   as pedido,
    d.nm_fantasia_nota_saida,

    --d.nm_razao_social_nota

     max(a.devolvido)            as devolvido,  
     max(a.pedido)               as pedido,
     max(a.percomissao)          as percomissao,   
     a.Setor,
     max(a.dt_restricao_item_nota)   as datadevolucao,
     max(a.nm_motivo_restricao_item) as motivodev,
     Comissao = round(( d.Valor_Parcela_Sem_IPI * max(a.percomissao)/100),2)
   from  
    #DocumentoReceberPago d
    inner join #Calculo_Comissao a  on a.nota = d.cd_nota_saida

   where
      IsNull(a.setor,0) = (case @cd_vendedor   
                                 when 0 then IsNull(a.setor,0)  
                                 else @cd_vendedor   
                               end)   

   group by   
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_pagamento_documento,
    d.vl_pagamento_documento,
    d.vl_documento_receber,
    d.vl_abatimento_documento,
    d.Valor_Parcela_Sem_IPI,
    d.cd_identificacao_nota_saida,
    d.dt_nota_saida,
    d.cd_pedido_venda,
    d.nm_fantasia_nota_saida,
    a.cliente,  
    a.nota,  
    a.Setor  

    order by a.Setor,  
--             a.Cliente,  
             a.datanota,  
             a.nota  
  

   goto TrataErro  

end  


  
TrataErro:  
  if @@Error = 0  
    commit transaction  
  else  
    rollback transaction  

