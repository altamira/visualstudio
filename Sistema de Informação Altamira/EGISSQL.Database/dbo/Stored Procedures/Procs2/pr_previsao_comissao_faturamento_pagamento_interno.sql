
-------------------------------------------------------------------------------
--sp_helptext pr_previsao_comissao_faturamento_pagamento_interno
-------------------------------------------------------------------------------
--pr_previsao_comissao_faturamento_pagamento_interno
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Cálculo da Comissão Especial por Faturamento
--                   e Baixa do Contas a Receber
--
--Data             : 01.10.2009
--Alteração        : 13.10.2009 - Finalização do Desenvolvimento
--                   15.10.2009 - Vendedor Interno
-- 28.10.2009 - Processamento do Vendedor Interno
-- 04.05.2010 - Desenvolvimento 
-- 06.05.2010 - Ajuste no Desenvolvimento - Carlos Fernandes
-- 09.11.2010 - Número da Nota Fiscal - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_previsao_comissao_faturamento_pagamento_interno
@cd_vendedor   int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = '',
@cd_usuario    int      = 0

as

declare @Tabela                    varchar(80)
declare @cd_comissao_nota          int 
declare @vl_base_comissao_nota     float
declare @vl_comissao_nota          float
declare @pc_comissao_nota          float
declare @cd_vendedor_nota          int
declare @vl_ipi_comissao_nota      float
declare @vl_icms_comissao_nota     float
declare @vl_red_piscofins_comissao float
declare @qt_parcela_comissao_nota  int
declare @pc_red_comissao_vendedor  float
declare @pc_red_comissao_nota      float
declare @pc_fin_comissao_nota      float

--Cálculo da Comissão---------------------------------------------------------

--passo 1 --rateio do (%) de comissão

--select * from categoria_produto
--select * from nota_saida_item where cd_nota_saida = 14840
--select * from vendedor_parametro
--select * from vw_faturamento

select
  vw.cd_nota_saida
into
  #CalculoComissao
from
  vw_faturamento vw
where
  vw.cd_vendedor_interno = case when @cd_vendedor = 0 then vw.cd_vendedor_interno else @cd_vendedor end and
  vw.dt_nota_saida between @dt_inicial and @dt_final                                    and
  vw.ic_comercial_operacao = 'S'                                                        and
  vw.cd_status_nota        = 5 --Nota Fechada

group by
  vw.cd_nota_saida


--select * from #CalculoComissao

declare @cd_nota_saida int

set @cd_nota_saida = 0

while exists ( select top 1 cd_nota_saida from #CalculoComissao )
begin

  select top 1
    @cd_nota_saida = cd_nota_saida
  from
    #CalculoComissao
  
  if @cd_nota_saida > 0 
  begin

    select
      vw.cd_nota_saida,
      vw.cd_vendedor_interno                            as cd_vendedor,
      vw.cd_produto,
      isnull(pf.pc_reducao_piscofins,0)                 as pc_reducao_piscofins,
      --cp.pc_comissao_cat_produto                        as pc_comissao_cat_produto,

      case when isnull(vpc.pc_comissao_prod_vendedor,0)>0 then
        vpc.pc_comissao_prod_vendedor
      else
        cp.pc_comissao_cat_produto
      end                                               as pc_comissao_cat_produto,

      vw.vl_unitario_item_total,
      100-isnull(nsi.pc_reducao_icms,0)                 as pc_reducao_icms,

      nsi.vl_base_icms_item,
      
      isnull(vp.pc_emissao_nota_comissao,0)             as pc_emissao_nota_comissao,
      isnull(nsi.vl_ipi,0)                              as vl_ipi,
      isnull(nsi.vl_icms_item,0)                        as vl_icms_item,
      isnull(nsi.vl_pis,0)                              as vl_pis,
      isnull(nsi.vl_cofins,0)                           as vl_cofins,

      --Base de Cálculo

      vl_base_comissao = --( vw.vl_unitario_item_total-isnull(nsi.vl_icms_item,0)-isnull(nsi.vl_ipi,0)) * 
                         ((vw.vl_unitario_item_total - isnull(nsi.vl_icms_item,0) - isnull(nsi.vl_ipi,0))
                         * case when isnull(pf.pc_reducao_piscofins,1)<>0 then pf.pc_reducao_piscofins else 1 end )
                         *
                         (case when isnull(vp.pc_emissao_nota_comissao,0)>0 then
                            vp.pc_emissao_nota_comissao/100
                         else
                            1
                         end),

 
      --Comissão
 
     ((vw.vl_unitario_item_total - isnull(nsi.vl_icms_item,0) - isnull(nsi.vl_ipi,0))
     * isnull(pf.pc_reducao_piscofins,1) )
     --* ( vp.pc_emissao_nota_comissao / 100 )
     *                    (case when isnull(vp.pc_emissao_nota_comissao,0)>0 then
                            vp.pc_emissao_nota_comissao/100
                         else
                            1
                         end)
     *  
 
     case when isnull(vpc.pc_comissao_prod_vendedor,0)>0 then
       (vpc.pc_comissao_prod_vendedor/100)
     else
       (cp.pc_comissao_cat_produto/100) 
     end                                              as vl_comissao_vendedor,

     vw.cd_pedido_venda,
     vw.cd_item_pedido_venda,

     ( 
     (vw.vl_unitario_item_total - isnull(nsi.vl_icms_item,0) - isnull(nsi.vl_ipi,0) )
     - 
     (vw.vl_unitario_item_total - isnull(nsi.vl_icms_item,0) - isnull(nsi.vl_ipi,0) )
     * isnull(pf.pc_reducao_piscofins,1) )                                 as vl_reducao,

     isnull(vp.pc_red_comissao_vendedor,0)                                 as pc_red_comissao_vendedor
     

   into
     #RateioProduto

   from
     vw_faturamento vw                            with (nolock) 

     left outer join categoria_produto cp         with (nolock) on cp.cd_categoria_produto = vw.cd_categoria_produto

     left outer join produto_fiscal    pf         with (nolock) on pf.cd_produto           = vw.cd_produto

     left outer join nota_saida_item  nsi         with (nolock) on nsi.cd_nota_saida       = vw.cd_nota_saida and
                                                                   nsi.cd_item_nota_saida  = vw.cd_item_nota_saida

     left outer join vendedor_parametro vp         with (nolock) on vp.cd_vendedor           = vw.cd_vendedor_interno

     left outer join vendedor_produto_comissao vpc with (nolock) on vpc.cd_vendedor          = vw.cd_vendedor_interno and
                                                                    vpc.cd_categoria_produto = vw.cd_categoria_produto


--select * from vendedor_produto_comissao
     
   where
     vw.cd_vendedor_interno = case when @cd_vendedor = 0 then vw.cd_vendedor_interno else @cd_vendedor end and
     vw.dt_nota_saida between @dt_inicial and @dt_final                                    and
     vw.ic_comercial_operacao = 'S'                                                        and
     vw.cd_status_nota        = 5 --Nota Fechada
     and vw.cd_nota_saida     = @cd_nota_saida

   --select * from #RateioProduto
 
   select
     @vl_base_comissao_nota     = sum( isnull(vl_base_comissao,0) ),
     @cd_vendedor_nota          = max(cd_vendedor),
     @vl_comissao_nota          = sum( case when isnull(pc_emissao_nota_comissao,0)>0 then
                                       isnull(vl_comissao_vendedor,0)
                                       else
                                         0.00
                                       end
                                      ),    
     @vl_red_piscofins_comissao = sum( isnull(vl_reducao,0) ), 
     @vl_ipi_comissao_nota      = sum( isnull(vl_ipi,0)       ),
     @vl_icms_comissao_nota     = sum( isnull(vl_icms_item,0) ),
     @pc_red_comissao_nota      = max(pc_red_comissao_vendedor) 

   from
     #RateioProduto

   group by
     cd_nota_saida
     
   select 
     @pc_comissao_nota = 
         sum(case when isnull(pc_emissao_nota_comissao,0)>0 
             then
               round((vl_comissao_vendedor/case when isnull(@vl_base_comissao_nota,0)>0 then @vl_base_comissao_nota else 1 end * 100),2) 
             else
               0.00
             end )
   from
     #RateioProduto

   --Atualiza as Parcelas da Nota
   set @pc_fin_comissao_nota     = 0

   set @qt_parcela_comissao_nota = 1

   select
     @qt_parcela_comissao_nota = isnull(count(*),1)
   from
     documento_receber with (nolock) 
   where
     cd_nota_saida = @cd_nota_saida

  if @qt_parcela_comissao_nota is null or @qt_parcela_comissao_nota = 0
     set @qt_parcela_comissao_nota = 1

   --Grava a Tabela de Pedido de Venda / Comissão
   -- ** Desenvolver quando tiver pedido de venda/item

   --Grava a Tabela de Nota / Comissão
   -- Nome da Tabela usada na geração e liberação de códigos

   delete from nota_saida_comissao where cd_nota_saida = @cd_nota_saida

   if not exists( select top 1 cd_nota_saida from nota_saida_comissao 
                  where
                    cd_nota_saida = @cd_nota_saida )

   begin
     set @Tabela = cast(DB_NAME()+'.dbo.Nota_Saida_Comissao' as varchar(50)) 

     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_comissao_nota', @codigo = @cd_comissao_nota output
	
     while exists(Select top 1 'x' from Nota_Saida_Comissao where cd_comissao_nota= @cd_comissao_nota)
     begin
       exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_comissao_nota', @codigo = @cd_comissao_nota output
       -- limpeza da tabela de código
       exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_comissao_nota, 'D'
     end

     insert into
       Nota_Saida_Comissao
     select
       @cd_comissao_nota          as cd_comissao_nota,
       @cd_nota_saida             as cd_nota_saida,
       @cd_vendedor_nota          as cd_vendedor,
       @vl_base_comissao_nota     as vl_base_comissao_nota,
       @vl_comissao_nota          as vl_comissao_nota,
       @pc_comissao_nota          as pc_comissao_nota,
       'Cálculo Comissão'         as nm_obs_comissao_nota,
       @cd_usuario                as cd_usuario,
       getdate()                  as dt_usuario,
       @vl_ipi_comissao_nota      as vl_ipi_comissao_nota,
       @vl_icms_comissao_nota     as vl_icms_comissao_nota,
       @vl_red_piscofins_comissao as vl_red_piscofins_comissao,

       case when @qt_parcela_comissao_nota is null or @qt_parcela_comissao_nota < 1 then 1
       else
         isnull(@qt_parcela_comissao_nota,1)
       end                        as qt_parcela_comissao_nota,
       @pc_red_comissao_nota      as pc_red_comissao_nota,
       @pc_fin_comissao_nota      as pc_fin_comissao_nota

     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_comissao_nota, 'D'

   end

   drop table #RateioProduto

  end

  delete from #CalculoComissao 
  where
    cd_nota_saida = @cd_nota_saida

end


--Documentos com Vencimento no Período - Previsão

--     select
--       --drp.cd_documento_receber       as 'DocumentoReceber',
--       --drp.cd_item_documento_receber  as 'ItemDocumento', 
-- 
--       --identity(int,1,1)                      as cd_controle,
-- 
--       IsNull(v.cd_vendedor,0)          as cd_vendedor,
--       Case 
--          When v.nm_fantasia_vendedor is null 
--          Then
--           'Sem Vendedor'
--          Else
--            v.nm_fantasia_vendedor
--       End                                    as nm_vendedor_externo,
-- 
--       ns.cd_nota_saida,
--       ns.dt_nota_saida,
-- 
--       case when isnull(c.cd_interface,0)>0 then
--         c.cd_interface
--       else
--         c.cd_cliente
--       end                                   as cd_cliente,
-- 
--       isnull(c.cd_cliente_filial,0)         as cd_cliente_filial,
--       c.nm_fantasia_cliente                 as nm_fantasia_destinatario,
--       c.nm_razao_social_cliente             as nm_razao_social_nota,
--       drp.dt_pagamento_documento            as dt_base_comissao,       
--       d.dt_vencimento_documento	            as dt_vencimento,
--       drp.dt_pagamento_documento            as dt_baixa,
--       drp.dt_pagamento_documento            as dt_pagamento,
--       d.cd_pedido_venda,
--       0 as cd_item_pedido_venda,    
--  
--       d.cd_identificacao	            as 'Documento',
-- 
-- --      d.dt_emissao_documento	     as 'Emissao',
-- --      drp.vl_pagamento_documento     as 'Valor',
--       drp.vl_pagamento_documento            
-- --      - 
-- --       isnull(drp.vl_juros_pagamento     ,0) -
-- --       isnull(drp.vl_despesa_bancaria    ,0) -
-- --       isnull(drp.vl_credito_pendente    ,0) -
-- --       isnull(drp.vl_reembolso_documento ,0) +
-- --       isnull(drp.vl_desconto_documento  ,0) +
-- --       isnull(drp.vl_abatimento_documento,0) 
-- 
--                                             as 'vl_documento',
-- 
-- 
--       (drp.vl_pagamento_documento           
-- --        - 
-- --       isnull(drp.vl_juros_pagamento     ,0) -
-- --       isnull(drp.vl_despesa_bancaria    ,0) -
-- --       isnull(drp.vl_credito_pendente    ,0) -
-- --       isnull(drp.vl_reembolso_documento ,0) +
-- --       isnull(drp.vl_desconto_documento  ,0) +
-- --       isnull(drp.vl_abatimento_documento,0)
-- 
--       - (nsc.vl_icms_comissao_nota/nsc.qt_parcela_comissao_nota)
--       - (nsc.vl_ipi_comissao_nota /nsc.qt_parcela_comissao_nota)
--       - (nsc.vl_red_piscofins_comissao/nsc.qt_parcela_comissao_nota)
--       )
--       *
--       case when isnull(vp.pc_baixa_comissao,0)>0 then
--         isnull(vp.pc_baixa_comissao/100,1)
--       else
--         1
--       end             as vl_base_comissao,
-- 
-- --      isnull(0,0))                             as vl_base_comissao,
-- 
--       case when isnull(nsc.pc_comissao_nota,0)>0 then
--          nsc.pc_comissao_nota
--       else
--          0.00
--       end                                      as pc_comissao,
-- 
--       (
--       ((drp.vl_pagamento_documento            
-- --       - 
-- -- 
-- --       isnull(drp.vl_juros_pagamento     ,0) -
-- --       isnull(drp.vl_despesa_bancaria    ,0) -
-- --       isnull(drp.vl_credito_pendente    ,0) -
-- --       isnull(drp.vl_reembolso_documento ,0) +
-- --       isnull(drp.vl_desconto_documento  ,0) +
-- --       isnull(drp.vl_abatimento_documento,0) 
--       - (nsc.vl_icms_comissao_nota/nsc.qt_parcela_comissao_nota)
--       - (nsc.vl_ipi_comissao_nota /nsc.qt_parcela_comissao_nota)
--       - (nsc.vl_red_piscofins_comissao/nsc.qt_parcela_comissao_nota)
--       )
--       *
--       case when isnull(vp.pc_baixa_comissao,0)>0 then
--         isnull(vp.pc_baixa_comissao/100,1)
--       else
--         1
--       end)
-- 
--       *
-- 
--       case when isnull(nsc.pc_comissao_nota,0)>0 then
--         (nsc.pc_comissao_nota/100)
--       else
--         1
--       end)
--                                                  as vl_comissao,
-- 
-- --      isnull(0,0)                              as vl_comissao,
--       isnull(vp.pc_baixa_comissao,0)           as pc_emissao_nota_comissao,
--       'B'                                      as ic_tipo_comissao
-- 
-- --      dr.vl_saldo_documento	            as 'Saldo',
-- --      drp.vl_juros_pagamento	            as 'Juros',
-- --      drp.vl_desconto_documento	            as 'Desconto',
-- --      drp.vl_abatimento_documento           as 'Abatimento',
-- --      c.nm_fantasia_cliente	            as 'Fantasia',
-- --      c.nm_razao_social_cliente,
-- 
--        
-- --       ns.vl_total                           as 'ValorNota',
-- --       ns.dt_nota_saida                      as 'EmissaoNota',
-- --       ns.vl_ipi                             as 'IpiNota',
-- --       cp.sg_condicao_pagamento              as 'CondicaoPagamento',
-- --       d.cd_pedido_venda                     as 'PedidoVenda',
-- --       ns.cd_nota_saida,
-- --       d.cd_documento_receber,
-- --       drp.cd_item_documento_receber,
-- --       isnull(cp.qt_parcela_condicao_pgto,0) as 'qtd_parcela',
-- -- 
-- --       case when isnull(cp.qt_parcela_condicao_pgto,0) > 0 
-- --       then
-- --         ( ns.vl_total - isnull(ns.vl_ipi,0)  )
-- --         /
-- --         isnull(cp.qt_parcela_condicao_pgto,0)
-- --       else
-- --         0.00
-- --       end                                    as 'Valor_Parcela_Sem_IPI',
-- --       isnull(vp.pc_baixa_comissao,0)         as pc_baixa_comissao
-- 
--     --select * from documento_receber_pagamento
--     --select * from condicao_pagamento
--     --select * from vendedor_parametro
--    
--     into
--       #Comissao_Documentos_Pagos
-- 
--     from
--       Documento_Receber_Pagamento drp         with (nolock) 
--       inner join Documento_Receber d          with (nolock) on (drp.cd_documento_receber = d.cd_documento_receber)
--       left outer join Cliente	c             with (nolock) on (d.cd_cliente             = c.cd_cliente          ) 
--       left outer join Portador p              with (nolock) on (p.cd_portador            = d.cd_portador         )
--       left outer join Tipo_Liquidacao tl      with (nolock) on (drp.cd_tipo_liquidacao   = tl.cd_tipo_liquidacao )
--       left outer join Banco b                 with (nolock) on (drp.cd_banco             = b.cd_banco            )
--       left outer join Conta_Agencia_Banco cab with (nolock) on (drp.cd_banco             = cab.cd_banco and drp.cd_conta_banco = cab.cd_conta_banco)
--       left outer join Documento_Receber	dr    with (nolock) on (drp.cd_documento_receber = dr.cd_documento_receber)
--       left outer join Nota_Saida ns           with (nolock) on (ns.cd_nota_saida         = dr.cd_nota_saida)
--       left outer join nota_saida_comissao nsc with (nolock) on nsc.cd_nota_saida         = ns.cd_nota_saida
--       left outer join Condicao_Pagamento cp   with (nolock) on (cp.cd_condicao_pagamento = ns.cd_condicao_pagamento)
--       left outer join Vendedor v              with (nolock) on (v.cd_vendedor            = 
--                                                                 case when isnull(ns.cd_nota_saida,0)>0 and
--                                                                   ns.cd_vendedor_interno<>d.cd_vendedor_interno then ns.cd_vendedor_interno
--                                                                 else
--                                                                   case when isnull(d.cd_vendedor_interno,0)>0 then
--                                                                      d.cd_vendedor_interno else c.cd_vendedor_interno
--                                                                   end
--                                                                 end)
--       left outer join Vendedor_Parametro vp   with (nolock) on vp.cd_vendedor = v.cd_vendedor_interno
-- 
-- 
--     where
--       (drp.dt_pagamento_documento between @dt_inicial and @dt_final) and
--       ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final )) and
--       ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final )) and
--       ( d.cd_vendedor_interno = case when @cd_vendedor = 0 then d.cd_vendedor_interno else @cd_vendedor end )
--       and ns.cd_status_nota = 5
--     order by
--       v.nm_fantasia_vendedor,
--       drp.dt_pagamento_documento

--select * from nota_saida
-- 
-- 
-- --Mostra a Tabela de Documentos Pagos
-- 
-- select *  from  #Comissao_Documentos_Pagos
-- order by
--   vendedor,
--   pagamento
-- 

--Mostra os Documentos Faturados no Período

--select * from categoria_produto
--select * from vw_faturamento
--select * from cliente
--select * from pedido_venda_comissao

select
  --identity(int,1,1)                    as cd_controle,
  max(vw.cd_vendedor_interno)          as cd_vendedor,
  max(vw.nm_vendedor_interno)          as nm_vendedor_externo,
--  vw.cd_nota_saida,

--   max(case when isnull(vw.cd_identificacao_nota_saida,0)>0 then
--      vw.cd_identificacao_nota_saida
--   else
--      vw.cd_nota_saida                  
--   end)                                  as 'cd_nota_saida',
 
  vw.cd_identificacao_nota_saida       as 'cd_nota_saida',

  max(vw.dt_nota_saida)                as dt_nota_saida,

  max(case when isnull(c.cd_interface,0)>0 
  then  
    c.cd_interface
  else
    c.cd_cliente
  end)                                      as cd_cliente,

  max(isnull(c.cd_cliente_filial,0))        as cd_cliente_filial,


  max(vw.nm_fantasia_destinatario)          as nm_fantasia_destinatario,
  max(vw.nm_razao_social_nota)              as nm_razao_social_nota,

  max(vw.dt_nota_saida)                     as dt_base_comissao,  
  max(cast(null as datetime))               as dt_vencimento,
  max(cast(null as datetime))               as dt_baixa,
  max(cast(null as datetime))               as dt_pagamento,

  max(vw.cd_pedido_venda)                   as cd_pedido_venda,
  max(vw.cd_item_pedido_venda)              as cd_item_pedido_venda,

  max( cast(vw.cd_identificacao_nota_saida as varchar(25))) as 'Documento',

  sum(vw.vl_unitario_item_total)            as vl_documento,

  max(isnull(nsc.vl_base_comissao_nota,0))  as vl_base_comissao,

  max(case when isnull(nsc.pc_comissao_nota,0)>0 then
    nsc.pc_comissao_nota
  else
     --isnull(cp.pc_comissao_cat_produto,0) 
     case when isnull(vpc.pc_comissao_prod_vendedor,0)>0 then
       vpc.pc_comissao_prod_vendedor
     else
       cp.pc_comissao_cat_produto
     end

  end )                                      as pc_comissao,

  max(isnull(nsc.vl_comissao_nota,0))        as vl_comissao,
  max(isnull(vp.pc_emissao_nota_comissao,0)) as pc_emissao_nota_comissao,
  max('E')                                   as ic_tipo_comissao,
  max(cast('' as varchar(30)))               as 'Tipo_Liquidacao'



into
  #ComissaoFaturamento  

--select * from vendedor_parametro
--documento_receber
  
from
  vw_faturamento vw                       with (nolock) 
  left outer join cliente c               with (nolock) on c.cd_cliente            = vw.cd_cliente
  left outer join produto p               with (nolock) on p.cd_produto            = vw.cd_produto
  left outer join categoria_produto  cp   with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join vendedor_parametro vp   with (nolock) on vp.cd_vendedor          = vw.cd_vendedor_interno
  left outer join nota_saida_comissao nsc with (nolock) on nsc.cd_nota_saida       = vw.cd_nota_saida
  left outer join vendedor_produto_comissao vpc with (nolock) on vpc.cd_vendedor          = vw.cd_vendedor_interno and
                                                                 vpc.cd_categoria_produto = vw.cd_categoria_produto

where
  vw.cd_vendedor_interno = case when @cd_vendedor = 0 then vw.cd_vendedor_interno else @cd_vendedor end and
  vw.dt_nota_saida between @dt_inicial and @dt_final                                    and
  vw.ic_comercial_operacao = 'S'                                                       
  and vw.cd_status_nota = 5

group by
  vw.cd_identificacao_nota_saida
  
-- select * from #Comissao_Documentos_Pagos
-- 
-- select * from #ComissaoFaturamento  

--Insere as baixas---------------------------------------------------------------------------

-- insert into
--   #ComissaoFaturamento  
-- select
--   *
-- from
--   #Comissao_Documentos_Pagos
-- 

select
  identity(int,1,1) as cd_controle,
  *
into
  #ComissaoFaturamentoFinal

from
  #ComissaoFaturamento  
  
--Apresenta a Tabela Final do Cálculo de comissão---------------------------------------------

select
  *
from
  #ComissaoFaturamentoFinal  

order by
  ic_tipo_comissao,
  nm_vendedor_externo,
  dt_nota_saida  

