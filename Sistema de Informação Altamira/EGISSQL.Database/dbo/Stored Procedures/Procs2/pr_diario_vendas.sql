
create procedure pr_diario_vendas
  
------------------------------------------------------------------------  
--pr_diario_vendas  
------------------------------------------------------------------------  
--GBS - Global Business Solution Ltda                              2004  
------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)  : Carlos Cardoso Fernandes  
--Banco de Dados : EGISSQL  
--Objetivo  : Diário de Vendas  
--Data   : 19/02/2003  
--Alteração             : Fabio - 30.09.2003 - Mudança de definição a data a ser utilizada  
--                                   para filtragem deve ser a data base  
--                      : 18/11/2003 - Permitir mostrar um período - Dudu  
--                      : 23/11/2004 - Fazer filtragem por loja. - Daniel C. Neto.  
--                      : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso   
--                      : 22/01/2005 - Acerto da condição cd_loja - Clelson Camargo  
--                      : 11.07.2005 - Tipo de Mercado - Carlos Fernandes  
--                      : 09.05.2006 - Vendedor que fez o atendimento foi colocado na grid - Carlos Fernandes
--                      : 11.05.2006 - Código do Cliente - Carlos Fernandes
--                      : 04.12.2006 - Acertos no Cálculo - Carlos Fernandes
-- 01.04.2008 - Acerto da Consulta para quando o serviço e produtos são iguais - Carlos Fernandes
-- 09.04.2008 - Ajuste do Segmento de Mercado - Carlos Fernandes
-- 27.01.2009 - Ajuste do Diário de Vendas - Carlos Fernandes
-- 10.08.2009 - Pedidos de Amostra não entra na consulta - Carlos Fernandes 
-------------------------------------------------------------------------------------------------------------  
  
@dt_base         datetime,  
@cd_vendedor     int      = 0,  
@dt_final        datetime = null,  
@cd_tipo_mercado int      = 0,  
@cd_loja         int      = 0   
  
as  
  
set @cd_vendedor = isnull(@cd_vendedor, 0)  
set @dt_final    = isnull(@dt_final, @dt_base)  

declare @qt_dia_imediato as integer  
  
set @qt_dia_imediato = ( select qt_dia_imediato_empresa   
    from 
      Parametro_Comercial  with (nolock) 
    where 
      cd_empresa = dbo.fn_empresa())  
  
  --Diário Analítico  

  select  
    vw.qt_item_pedido_venda              as 'Qtde',  
    vw.cd_cliente                        as cd_cliente,
    vw.nm_fantasia_cliente               as 'Cliente',  
    vw.dt_pedido_venda                   as 'Data',  
    vw.nm_categoria_produto              as 'Produto',  
    isnull(vw.qt_item_pedido_venda *   
           vw.vl_unitario_item_pedido,0) as 'Total',  
    pg.nm_condicao_pagamento          as 'CondicaoPagamento',  
    case   
      when  
        (vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) <= @qt_dia_imediato  
      then 'Imediato'  
      else convert( varchar(10),vw.dt_entrega_vendas_pedido,103 ) end as 'Entrega',  
    Interno = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = vw.cd_vendedor_interno ),  
    Externo = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = vw.cd_vendedor ),
    vw.cd_usuario_atendente,
    u.nm_fantasia_usuario as Atendido,
    vw.ValorLiquido,
    vw.vl_frete_item_pedido,
    vw.vl_ipi,
    vw.ValorTotalIPI,
    vw.nm_ramo_atividade,
    vw.cd_pedido_venda,
    vw.cd_item_pedido_venda,
    vw.cd_consulta,
    vw.cd_item_consulta,
    case when isnull(vw.cd_consulta,0)>0 and isnull(vw.cd_item_consulta,0)>0 
    then
      isnull(vw.qt_item_pedido_venda *   
            vw.vl_unitario_item_pedido,0) 
    else
      0.00
    end                    as 'Total_Proposta'  


  from  
    vw_venda_bi vw                          with (nolock) 
    left outer join Condicao_Pagamento pg   with (nolock) on vw.cd_condicao_pagamento = pg.cd_condicao_pagamento  
    left outer join egisadmin.dbo.Usuario u with (nolock) on vw.cd_usuario_atendente  = u.cd_usuario 

  where  
    ( vw.dt_pedido_venda between @dt_base and @dt_final ) and  
    IsNull(vw.cd_vendedor,0) = ( case when IsNull(@cd_vendedor,0)=0
                                 then IsNull(vw.cd_vendedor,0)
                                 else @cd_vendedor  
                                 end ) and  
    --Carlos 11.07.2005  
    isnull(vw.cd_tipo_mercado,0) = case isnull(@cd_tipo_mercado,0) when 0 then IsNull(vw.cd_tipo_mercado,0)
                                                                   else @cd_tipo_mercado end and
    --Ludinei 01/03/2006
    vw.cd_item_pedido_venda <= (case when vw.cd_tipo_mercado = 1 then 80 else 999 end) and

    ((@cd_loja = 0) or (vw.cd_loja = @cd_loja))  

    and isnull(vw.ic_amostra_pedido_venda,'N')<>'S'
    and isnull(vw.ic_garantia_pedido_venda,'N')<>'S'

 order by  
   4 desc  
  

