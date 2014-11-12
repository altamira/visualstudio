
-------------------------------------------------------------------------------
--sp_helptext pr_caixa_diario_veiculo
-------------------------------------------------------------------------------
--pr_caixa_diario_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Diário de Veículo para Controle de Caixa 
--
--Data             : 26.12.2009
--Alteração        : 05.02.2009 - Ajustes Diversos - Carlos Fernandes
--
-- 23.03.2009 - Geração Automática - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_caixa_diario_veiculo
@ic_parametro      int      = 0,
@dt_base           datetime = '',
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@cd_usuario        int      = 0,
@cd_diario         int      = 0,
@cd_veiculo        int      = 0,
@dt_faturamento    datetime = '',
@dt_entrega        datetime = ''

as

--Data do Faturamento

if @dt_faturamento is null
begin
  set @dt_faturamento = @dt_base
end

--Data de Entrega ( Próximo Dia Útil )

set @dt_entrega = dbo.fn_dia_util(@dt_faturamento + 1,'S','U')


------------------------------------------------------------------------------
--Geração Diário de Caixa do Veículo------------------------------------------
------------------------------------------------------------------------------

if @ic_parametro = 0
begin

  select 
    cd_diario_caixa
  into
    #Deleta_Diario
  from
    Diario_Caixa_Veiculo
  where
    dt_diario_caixa between @dt_inicial and @dt_final  

  delete from Diario_Caixa_Veiculo_Pagamento where cd_diario_caixa in ( select cd_diario_caixa from #Deleta_Diario)

  delete from Diario_Caixa_Veiculo
  where
    dt_diario_caixa between @dt_inicial and @dt_final

  drop table #Deleta_Diario
  
  --select * from Diario_Caixa_Veiculo
  --select * from Diario_Caixa_Veiculo_Pagamento

  declare @cd_diario_caixa int

  select 
    @cd_diario_caixa = isnull( max(cd_diario_caixa),0 )
  from
    Diario_Caixa_Veiculo with (nolock)

  if @cd_diario_caixa is null
  begin
    set @cd_diario_caixa = 0
  end

  --Geração do Diário de Caixa para o Veículo
  --delete from diario_caixa_veiculo
  --select * from nota_saida
  --select * from diario_caixa_veiculo

  select
    @cd_diario_caixa                              as cd_diario_caixa,
    @dt_base                                      as dt_diario_caixa,
    dbo.fn_dia_util(ns.dt_nota_saida + 1,'S','U') as dt_entrega_diario,
    ns.cd_veiculo,
    ns.cd_motorista,

    0.00                          as vl_estorno_diario,
    0.00                          as vl_devolucao_diario,
    0.00                          as vl_repasse_diario,

    sum( isnull(ns.vl_total,0) )  as vl_total_diario,

    sum(case when isnull(fcp.ic_avista_forma_condicao,'N')='N' then
       isnull(ns.vl_total,0) 
    else
       0.00
    end)                           as vl_total_prazo_diario,

    sum(case when isnull(fcp.ic_avista_forma_condicao,'N')='S' then
        isnull(ns.vl_total,0) 
    else
       0.00
    end)                           as vl_total_vista_diario,

    --0.00                          as vl_saldo_diario,

    sum( isnull(ns.vl_total,0) )  as vl_saldo_diario,
    
    0.00                          as vl_recebido_diario,

    'Gerado Automaticamente'      as nm_obs_diario_caixa,

    @cd_usuario                   as cd_usuario,
    getdate()                     as dt_usuario,
    count(ns.cd_nota_saida)       as qt_nota_diario,
    count(ns.cd_nota_saida)       as qt_entrega_diario,
    identity(int,1,1)             as cd_interface,
    ns.dt_nota_saida              as dt_faturamento_diario    

  into
    #Diario_Caixa_Veiculo

  from
    Nota_Saida ns                                 with (nolock)
    left outer join operacao_fiscal opf           with (nolock) on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
    left outer join condicao_pagamento cpg        with (nolock) on cpg.cd_condicao_pagamento = ns.cd_condicao_pagamento
    left outer join forma_condicao_pagamento fcp  with (nolock) on fcp.cd_forma_condicao     = cpg.cd_forma_condicao

--select cd_condicao_pagamento,* from nota_saida where cd_nota_saida = 7611

--select * from forma_condicao_pagamento
--select * from condicao_pagamento where cd_condicao_pagamento = 64

--    left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente             = ns.cd_cliente

--select * from cliente_informacao_credito

  where
    isnull(ns.cd_veiculo,0) > 0 
    and ns.dt_nota_saida        between @dt_inicial and @dt_final
    and ns.dt_cancel_nota_saida is null
    and isnull(opf.ic_comercial_operacao,'N') = 'S'

  group by
    ns.cd_veiculo,
    ns.cd_motorista,
    ns.dt_nota_saida

  --Atualiza o Número do Diário

  update
    #Diario_Caixa_Veiculo
  set
    cd_diario_caixa = cd_diario_caixa + cd_interface

  --select * from #Diario_Caixa_Veiculo
 
  insert into Diario_Caixa_Veiculo
    select 
      *
    from
      #Diario_Caixa_Veiculo

  
  --Geração da Tabela auxiliar por Tipo de Pagamento

  select
    ns.dt_nota_saida              as dt_faturamento_diario,
    ns.cd_veiculo,
    ns.cd_motorista,
    fp.cd_forma_pagamento,
    sum( isnull(ns.vl_total,0) )  as vl_total_diario
  into
    #Aux_Resumo_Pagamento
  from
    Nota_Saida ns                                 with (nolock)
    left outer join operacao_fiscal opf           with (nolock) on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
    left outer join condicao_pagamento cpg        with (nolock) on cpg.cd_condicao_pagamento = ns.cd_condicao_pagamento
    left outer join forma_condicao_pagamento fcp  with (nolock) on fcp.cd_forma_condicao     = cpg.cd_forma_condicao
    left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente             = ns.cd_cliente
    left outer join forma_pagamento            fp with (nolock) on fp.cd_forma_pagamento     = 
                                                                   case when isnull(ns.cd_forma_pagamento,0)>0 then
                                                                     ns.cd_forma_pagamento
                                                                   else
                                                                     ci.cd_forma_pagamento
                                                                   end
    
--select * from cliente_informacao_credito

  where
    isnull(ns.cd_veiculo,0) > 0 
    and ns.dt_nota_saida        between @dt_inicial and @dt_final
    and ns.dt_cancel_nota_saida is null
    and isnull(opf.ic_comercial_operacao,'N') = 'S'
  group by
    ns.cd_veiculo,
    ns.cd_motorista,
    ns.dt_nota_saida,
    fp.cd_forma_pagamento

  --Diario_Caixa_Veiculo_Pagamento

  select
    identity(int,1,1)       as cd_diario_pagamento,
    d.cd_diario_caixa,
    a.cd_forma_pagamento,
    a.vl_total_diario       as vl_diario_pagamento,
    cast('' as varchar)     as nm_obs_diario_pagamento,
    null                    as qt_diario_pagamento,
    @cd_usuario             as cd_usuario,
    getdate()               as dt_usuario
  into
    #Diario_Caixa_Veiculo_Pagamento

  from
    #Diario_Caixa_Veiculo d
    inner join #Aux_Resumo_Pagamento a on a.cd_veiculo            = d.cd_veiculo        and
                                          a.cd_motorista          = d.cd_motorista      and
                                          a.dt_faturamento_diario = d.dt_faturamento_diario 

     
  insert into Diario_Caixa_Veiculo_Pagamento
    select 
      *
    from
      #Diario_Caixa_Veiculo_Pagamento

  drop table #Diario_Caixa_Veiculo
  drop table #Diario_Caixa_Veiculo_Pagamento

--select * from forma_pagamento
--select * from forma_condicao_pagamento

end

--select * from diario_caixa_veiculo

------------------------------------------------------------------------------
--Consulta
------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  select
    dc.*,
    --Veículo
    v.nm_veiculo,
    v.aa_veiculo,
    v.cd_placa_veiculo,
    v.cd_chassi_veiculo

  from
    Diario_Caixa_Veiculo    dc with (nolock) 
    left outer join Veiculo v  with (nolock) on v.cd_veiculo = dc.cd_veiculo
  where
    dc.dt_faturamento_diario between @dt_inicial and @dt_final and
    dc.cd_diario_caixa = case when isnull(@cd_diario,0) = 0 then dc.cd_diario_caixa else @cd_diario end
  order by
    v.nm_veiculo,
    dc.dt_entrega_diario
end


------------------------------------------------------------------------------
--Consulta da Forma de Pagamento
------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  print 'Forma de Pagamento'

  select
    dcv.*,
    fp.nm_forma_pagamento
  from
    Diario_Caixa_Veiculo_Pagamento dcv with (nolock) 
    inner join forma_pagamento     fp  with (nolock) on fp.cd_forma_pagamento = dcv.cd_forma_pagamento

  where
    dcv.cd_diario_caixa = @cd_diario  
  order by
    dcv.vl_diario_pagamento desc
    
end

------------------------------------------------------------------------------
--Notas que Compõe o Diário do Veículo
------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  select
    v.nm_fantasia_vendedor,
    ns.cd_vendedor,
    ns.cd_nota_saida,
    ns.dt_nota_saida,
    ns.nm_fantasia_nota_saida,
    ns.nm_razao_social_nota,
    ns.vl_total,
    cp.sg_condicao_pagamento,
    fp.nm_forma_pagamento,
    ns.nm_endereco_nota_saida+', '+cd_numero_end_nota_saida as nm_endereco,
    ns.nm_bairro_nota_saida,
    ns.nm_cidade_nota_saida,
    ns.sg_estado_nota_saida,
    ns.cd_cep_nota_saida,
   ( select top 1 cd_pedido_venda 
     from nota_saida_item with (nolock) 
     where
       cd_nota_saida = ns.cd_nota_saida ) as cd_pedido_venda,
    cv.sg_criterio_visita,
    vei.nm_veiculo,
    mot.nm_motorista
   from 
     nota_saida                         ns         with (nolock)
     left outer join cliente            c          with (nolock) on c.cd_cliente             = ns.cd_cliente
     left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente            = c.cd_cliente
     left outer join Vendedor           v          with (nolock) on v.cd_vendedor            = ns.cd_vendedor
     left outer join Condicao_Pagamento cp         with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
     left outer join Operacao_fiscal    opf        with (nolock) on opf.cd_operacao_fiscal   = ns.cd_operacao_fiscal
     left outer join Forma_Pagamento    fp         with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento
     left outer join criterio_visita    cv         with (nolock) on cv.cd_criterio_visita    = c.cd_criterio_visita
     left outer join Veiculo            vei        with (nolock) on vei.cd_veiculo           = ns.cd_veiculo 
     left outer join Motorista          mot        with (nolock) on mot.cd_motorista         = ns.cd_motorista
   where
     ns.dt_nota_saida between @dt_inicial and @dt_final                                      and
     ns.dt_cancel_nota_saida is null                                                         and
     ns.cd_veiculo = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end
   order by
     ns.cd_vendedor,
     ns.nm_fantasia_nota_saida

end

------------------------------------------------------------------------------
--Recebimento que Compõe o Diário do Veículo
------------------------------------------------------------------------------

if @ic_parametro = 4
begin
  --select * from movimento_caixa_recebimento

  select
    oc.nm_operador_caixa        as 'Operador',
    tl.nm_tipo_lancamento       as 'Tipo_Lancamento',
    mc.cd_movimento_caixa, 
    mc.dt_movimento_caixa       as 'DataMovimento',
    mc.cd_documento             as 'Documento',
    mc.vl_movimento_recebimento as 'Valor',
    mc.nm_obs_movimento_caixa   as 'Observacao',
    mc.dt_pagamento_caixa       as 'DataPagamento',
    hr.nm_historico_recebimento as 'Historico',
    mc.nm_historico_complemento as 'Complemento'   

  from
    Movimento_Caixa_Recebimento mc           with (nolock)
    left outer join Operador_Caixa oc        with (nolock) on oc.cd_operador_caixa        = mc.cd_operador_caixa
    left outer join Tipo_Lancamento_Caixa tl with (nolock) on tl.cd_tipo_lancamento       = mc.cd_tipo_lancamento
    left outer join Historico_Recebimento hr with (nolock) on hr.cd_historico_recebimento = mc.cd_historico_recebimento

  where
    mc.cd_veiculo = case when @cd_veiculo = 0 then mc.cd_veiculo else @cd_veiculo end and
    mc.dt_movimento_caixa between @dt_inicial and @dt_final                                      

  order by
    mc.dt_movimento_caixa,
    mc.cd_documento
 
end

------------------------------------------------------------------------------
--Atualização do Valor do Movimento de Caixa
------------------------------------------------------------------------------

if @ic_parametro = 5
begin


  --Atualiza o Valor Recebido do Diário de Caixa
  declare @vl_recebido_diario float


    select
      @vl_recebido_diario = sum(isnull(mc.vl_movimento_recebimento,0))
    from
      Movimento_Caixa_Recebimento mc           with (nolock)
      left outer join Operador_Caixa oc        with (nolock) on oc.cd_operador_caixa        = mc.cd_operador_caixa
      left outer join Tipo_Lancamento_Caixa tl with (nolock) on tl.cd_tipo_lancamento       = mc.cd_tipo_lancamento
      left outer join Historico_Recebimento hr with (nolock) on hr.cd_historico_recebimento = mc.cd_historico_recebimento

    where
      mc.cd_veiculo = @cd_veiculo and
      mc.dt_movimento_caixa between @dt_inicial and @dt_final                                      

    --Atualiza a Tabela

    update
      diario_caixa_veiculo
    set
      vl_recebido_diario = @vl_recebido_diario,
      vl_saldo_diario    = vl_total_diario - @vl_recebido_diario  
    from
      diario_caixa_veiculo dc
    where
      dc.cd_diario_caixa = @cd_diario 


end



-----------------------------------------------------------------------------------------------------------
--delete from diario_caixa_veiculo
--delete from diario_caixa_veiculo_pagamento
-----------------------------------------------------------------------------------------------------------

