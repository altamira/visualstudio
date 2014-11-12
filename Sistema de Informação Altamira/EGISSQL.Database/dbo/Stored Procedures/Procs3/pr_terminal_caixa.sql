
-------------------------------------------------------------------------------
--sp_helptext pr_terminal_caixa
-------------------------------------------------------------------------------
--pr_terminal_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Terminal de Caixa
--                   Gestão de Caixa de Logística
--                   Processos do Sistema 
--
--Data             : 20.10.2008
--Alteração        : 12.02.2009 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_terminal_caixa
@ic_parametro       int      = 0,
@dt_base            datetime = '',
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@cd_veiculo         int      = 0,
@cd_motorista       int      = 0,
@cd_loja            int      = 0,
@cd_vendedor        int      = 0,
@cd_usuario         int      = 0,
@cd_movimento_caixa int      = 0

as

--select * from movimento_caixa_recebimento


  if (@cd_loja <= 0)
  begin
    if IsNull(@cd_usuario,0) <> 0
    begin
      Select top 1 
        @cd_Loja = IsNull(us.cd_loja,0) 
      from 
        EgisAdmin.dbo.Usuario us with (nolock) 
      where 
         us.cd_usuario = @cd_usuario
    end	 
  end

if @ic_parametro = 1
begin

  --Seta as variáveis para rodar o script abaixo
  --select * from movimento_caixa_recebimento

  Select

    mc.cd_movimento_caixa,
    mc.dt_movimento_caixa,
    mc.cd_veiculo,
    mc.cd_motorista,
    mc.cd_funcionario,
    mc.cd_entregador,
    mc.cd_tipo_documento,
    mc.cd_documento,
    mc.cd_historico_recebimento,
    mc.nm_historico_complemento,
    mc.vl_movimento_recebimento,

--     'vl_movimento_recebimento' =
--     case when tmc.ic_entrada_saida = 'E'
--     then mc.vl_movimento_recebimento
--     else mc.vl_movimento_recebimento * -1
--     end,

    mc.cd_pedido_venda,
    mc.cd_item_pedido_venda,
    mc.cd_nota_saida,
    mc.qt_parcela_nota_saida,
    mc.cd_documento_receber,
    mc.cd_prestacao,
    mc.nm_obs_movimento_caixa,
    mc.cd_usuario,
    mc.dt_usuario,
    mc.dt_vencimento_caixa,
    mc.dt_pagamento_caixa,
    mc.cd_tipo_lancamento,
    mc.cd_terminal_caixa,
    mc.cd_operador_caixa,
    mc.cd_tipo_movimento_caixa,
    mc.cd_vendedor,
    mc.cd_condicao_pagamento,
    mc.cd_loja,
    mc.cd_cliente,
    mc.dt_cancel_movimento,

    --Mostra os Dados

    u.nm_usuario,
    c.nm_razao_social_cliente                   as nm_cliente,
    isnull(v1.nm_vendedor,oc.nm_operador_caixa) as nm_vendedor,
    cp.nm_condicao_pagamento,
    tmc.ic_entrada_saida,
    l.nm_fantasia_loja,
    oc.nm_operador_caixa,
    convert(varchar,mc.dt_usuario,108)          as Hora, 
    c.cd_cnpj_cliente,
    hr.nm_historico_recebimento,
    tc.nm_terminal_caixa,
    v.nm_veiculo,
    m.nm_motorista,
    td.nm_tipo_documento,    
    mc.nm_cheque_movimento
  From
    Movimento_Caixa_Recebimento mc           with (nolock) 
    left Outer Join egisadmin.dbo.Usuario u  with (nolock) on mc.cd_usuario               = u.cd_usuario
    left outer join Vendedor v1              with (nolock) on v1.cd_vendedor              = mc.cd_vendedor
    Left Outer Join Condicao_Pagamento cp    with (nolock) on cp.cd_condicao_pagamento    = mc.cd_condicao_pagamento
    Left Outer Join Cliente c                with (nolock) on c.cd_cliente                = mc.cd_cliente
    Left Outer join Tipo_Movimento_Caixa tmc with (nolock) on tmc.cd_tipo_movimento_caixa = mc.cd_tipo_movimento_caixa
    left outer join Loja l                   with (nolock) on l.cd_loja                   = mc.cd_loja
    left outer join Operador_caixa oc        with (nolock) on oc.cd_operador_caixa        = mc.cd_operador_caixa
    left outer join Historico_Recebimento hr with (nolock) on hr.cd_historico_recebimento = mc.cd_historico_recebimento
    left outer join Terminal_Caixa        tc with (nolock) on tc.cd_terminal_caixa        = mc.cd_terminal_caixa
    left outer join Veiculo               v  with (nolock) on v.cd_veiculo                = mc.cd_veiculo
    left outer join Motorista             m  with (nolock) on m.cd_motorista              = mc.cd_motorista
    left outer join Tipo_Documento        td with (nolock) on td.cd_tipo_documento        = mc.cd_tipo_documento
 Where
    mc.cd_movimento_caixa     = case when @cd_movimento_caixa = 0 then mc.cd_movimento_caixa else @cd_movimento_caixa end
    and
    mc.dt_movimento_caixa between (case when @cd_movimento_caixa = 0 then @dt_inicial else mc.dt_movimento_caixa end )
                          and     (case when @cd_movimento_caixa = 0 then @dt_final   else mc.dt_movimento_caixa end )

 Order By
   mc.cd_movimento_caixa  
  

end

--select * from historico_recebimento
--select * from tipo_movimento_caixa
--select * from movimento_caixa_recebimento
--select * from tipo_lancamento_caixa
--select * from operador_caixa

--drop table movimento_caixa_recebimento

