
--sp_helptext pr_mapa_orcamento_compra
-------------------------------------------------------------------------------
-- pr_mapa_orcamento_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Orçamento de compras
--Data             : 10.02.2007
--Alteração        : 20.08.2007 - Data de Emissão    = Competência
--                   20.08.2007 - Data de Vencimento = Previsto    ( Correto )
-- 20.08.2008 - Ajuste do Campo de Total - Carlos Fernandes
------------------------------------------------------------------------------
create procedure  pr_mapa_orcamento_compra
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@ic_atualiza     char(1) = 'N',
@cd_usuario      int     = 0,
@cd_plano_compra int     = 0,  
@ic_parametro    int     = 0   --0 = Data de Emissão  1 = Data de Vencimento Conforme Desdobramento Pagamento
as

--select * from plano_compra
--select * from plano_compra_orcamento

--Atualização do Valor Realizado

if @ic_atualiza = 'S' 
begin


------------------------------------------------------------------------------
--Data de Emissão do pedido = Data de Compra
------------------------------------------------------------------------------

    --select * from pedido_compra

    select  
      pc.cd_plano_compra,
      sum( isnull(pc.vl_total_pedido_ipi,0) )   as TotalCompra,
      max( isnull(p.vl_limite_plano_compra,0) ) as Estimado
    into
      #OrcamentoAux
    from
      Pedido_Compra pc with (nolock) 
      left outer join Plano_Compra p on p.cd_plano_compra = pc.cd_plano_compra 

    where
       pc.cd_plano_compra = case when @cd_plano_compra = 0 then pc.cd_plano_compra else @cd_plano_compra end and
       pc.dt_pedido_compra between @dt_inicial and @dt_final and
       pc.dt_cancel_ped_compra is null                       and
       isnull(pc.ic_fechado_pedido_compra,'N')='S'           and
       isnull(pc.cd_plano_compra,0)>0
    group by
      pc.cd_plano_compra


------------------------------------------------------------------------------
--Por data de Vencimento/Data do Pagamento
------------------------------------------------------------------------------

    select
      pc.cd_plano_compra,
      sum( isnull( (pci.qt_saldo_item_ped_compra * pci.vl_item_unitario_ped_comp ) * 
                 (cpp.pc_condicao_parcela_pgto/100),0)
         ) as TotalCompra,
      max(isnull(p.vl_limite_plano_compra,0) )          as Estimado

    into
      #PrevisaoCompra
    from
      pedido_compra pc with (nolock) 
      inner join pedido_compra_item pci         with (nolock) on pci.cd_pedido_compra      = pc.cd_pedido_compra
      inner join condicao_pagamento cp          with (nolock) on cp.cd_condicao_pagamento  = pc.cd_condicao_pagamento
      inner join condicao_pagamento_parcela cpp with (nolock) on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
      left outer join Plano_Compra p            with (nolock) on p.cd_plano_compra         = pc.cd_plano_compra 
 
    where
      --pc.dt_pedido_compra between @dt_inicial and @dt_final and
      isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto between @dt_inicial and @dt_final and
      pci.dt_item_canc_ped_compra is null and
      isnull(pci.qt_saldo_item_ped_compra,0)>0
    group by
      pc.cd_plano_compra


    --Atualizando a Tabela Auxiliar

    --
    if @ic_parametro=0 
    begin
      update
        #PrevisaoCompra
      set
        TotalCompra = 0.00

    end

    --Zera data de compra=Data Pedido 
    if @ic_parametro=1 
    begin
      update
        #OrcamentoAux
      set
        TotalCompra = 0.00

    end




  --Montagem da Tabela com os Planos Zerados

  select
    pc.cd_plano_compra,
    isnull(a.TotalCompra,0) +
    isnull(pv.TotalCompra,0)              as TotalCompra,
    isnull(pc.vl_limite_plano_compra,0)  as Estimado

  into
    #Orcamento
  from
    Plano_Compra pc with (nolock) 
    left outer join #OrcamentoAux   a  on a.cd_plano_compra  = pc.cd_plano_compra
    left outer join #Previsaocompra pv on pv.cd_plano_compra = pc.cd_plano_compra  

  --select * from #Orcamento

  --select * from plano_compra_orcamento
 
  declare @cd_plano_compra_aux int
  declare @vl_limite           float
  declare @vl_realizado        float
 
  while exists ( select top 1 cd_plano_compra from #Orcamento  )
  begin
    select top 1
      @cd_plano_compra_aux  = cd_plano_compra,
      @vl_limite            = estimado,
      @vl_realizado         = TotalCompra
    from
      #Orcamento

    --Verifica se existe

    if not exists ( select cd_plano_compra from Plano_compra_Orcamento 
                where
                  cd_plano_compra         = @cd_plano_compra_aux and
                  dt_inicial_plano_compra = @dt_inicial          and 
                  dt_final_plano_compra   = @dt_final )
    begin

      --select * from plano_compra_orcamento
      
      insert into Plano_Compra_Orcamento
      select
        @cd_plano_compra_aux,
        @dt_inicial,
        @dt_final,
        @vl_limite,
        @vl_realizado,
        @cd_usuario,
        getdate()
         
    end
 
   --Atualização

   update
     plano_compra_orcamento
   set
     vl_realizado_plano_compra = @vl_realizado
   where
     cd_plano_compra         = @cd_plano_compra_aux and
     dt_inicial_plano_compra = @dt_inicial          and
     dt_final_plano_compra   = @dt_final  

    --Deleção

    delete from #Orcamento where cd_plano_compra = @cd_plano_compra_aux

  end

  
end

select
  p.cd_plano_compra,
  p.cd_mascara_plano_compra                                as Codigo,
  p.nm_plano_compra                                        as Descricao,
  isnull(p.vl_limite_plano_compra,0)                       as Limite,
  isnull(o.vl_previsto_plano_compra,0)                     as Previsto,
  isnull(o.vl_realizado_plano_compra,0)                    as Realizado,
  isnull(o.vl_previsto_plano_compra,0)-
 (isnull(o.vl_realizado_plano_compra,0))                    as Saldo,
  case when isnull(o.vl_previsto_plano_compra,0)>0
  then
    (isnull(o.vl_realizado_plano_compra,0)/isnull(o.vl_previsto_plano_compra,0))*100
  else
    0.00 end                                                as PercRealizado

from
  Plano_Compra p with (nolock) 
  left outer join Plano_Compra_Orcamento o on o.cd_plano_compra = p.cd_plano_compra

where
  p.cd_plano_compra = case when @cd_plano_compra = 0 then p.cd_plano_compra else @cd_plano_compra end and
  o.dt_inicial_plano_compra >=@dt_inicial and
  o.dt_final_plano_compra   <=@dt_final  

order by
  p.cd_mascara_plano_compra  

