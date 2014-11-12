
CREATE   PROCEDURE pr_meta_faturamento_diario
-------------------------------------------------------------------------  
--pr_meta_faturamento_diario  
-------------------------------------------------------------------------  
--GBS - Global Business Solution  Ltda                              2007 
-------------------------------------------------------------------------  
--Stored Procedure       : Microsoft SQL Server 2000  
--Autor(es)              : Anderson Messias da Silva
--Banco de Dados         : EgisSql  
--Objetivo               : Calcular as Metas de Faturamento Diários
--Data                   : 17/03/2007  
--Atualizado             : 16.04.2007 - Verificação dos Valores - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------  
  
@dt_base         datetime,  
@cd_vendedor     int = 0,  
@cd_tipo_mercado int = 0  
  
AS  
  
set @cd_vendedor     = isnull(@cd_vendedor,0)  
set @cd_tipo_mercado = isnull(@cd_tipo_mercado,0)  
  
declare @qt_dia_imediato as integer  
  
set @qt_dia_imediato = ( 
    select isnull(qt_dia_imediato_empresa,0)
    from Parametro_Comercial
    where cd_empresa = dbo.fn_empresa() 
)

-- Pedidos não Imediatos

select   
  mf.cd_empresa,  
  max(mf.vl_meta_faturamento)             as 'Meta_Mes',   


  --
--   sum(IsNull(vw.qt_item_nota_saida,0) * 
--       IsNull(vw.vl_unitario_item_nota,0)) as 'Vendas',

  sum(vw.vl_unitario_item_total)          as 'Vendas',

  max(mf.qt_meta_faturamento)             as 'Qt_Meta_Mes',
  sum(IsNull(vw.qt_item_nota_saida,0))    as 'Qt_Vendas'

into   
  #MetaFaturamentoInicial  
from  
  Meta_Faturamento mf,  
  vw_faturamento_bi vw
where  
  mf.cd_empresa = dbo.fn_empresa()                and
 (@dt_base between mf.dt_ini_meta_faturamento     and 
                   mf.dt_fim_meta_faturamento)    and
  month(vw.dt_nota_saida)  = month(@dt_base)      and
  year(vw.dt_nota_saida)   = year(@dt_base)       and
  vw.cd_vendedor = ( case IsNull(@cd_vendedor,0) when 0
                       then vw.cd_vendedor
                       else @cd_vendedor
                     end )
  and mf.cd_tipo_mercado = case when @cd_tipo_mercado = 0 then mf.cd_tipo_mercado else @cd_tipo_mercado end
group by
  mf.cd_empresa
  
  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
    sum(vw.vl_unitario_item_total) as 'Devolucao'
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
  where 
    month(vw.dt_nota_saida)  = month(@dt_base)          and
    year(vw.dt_nota_saida)   = year(@dt_base)           and
    (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0) and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 

--select * from #faturadevolucao

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    sum(vw.vl_unitario_item_total)  as 'DevolucaoAnterior'
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
  where 
     year(vw.dt_nota_saida)   = year(@dt_base)                and
         (vw.dt_nota_saida < @dt_base) and
     month(vw.dt_restricao_item_nota)  = month(@dt_base)      and
     year(vw.dt_restricao_item_nota)   = year(@dt_base)       and

--  vw.dt_restricao_item_nota between @dt_base and @dt_final
    (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0) and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 

--select * from #faturadevolucaoanoAnterior


  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
    sum(vw.vl_unitario_item_atual)  as 'Cancelamento'
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
  where 
    month(vw.dt_nota_saida)  = month(@dt_base)      and
    year(vw.dt_nota_saida)   = year(@dt_base)       and
    (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0)  and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 

--select * from #FaturaCancelado
  
select   
  cd_empresa,  
  Meta_Mes,   
  SUM( IsNull(Vendas,0) )                      
  - sum( isnull(Devolucao,0))
  - sum( isnull(DevolucaoAnterior,0))
  - sum( isnull(Cancelamento,0))                        as 'Vendas',
  Qt_Meta_Mes,   
  SUM( IsNull(Qt_Vendas,0) )                            as 'Qt_Vendas'
into   
 #MetaVendas  
from  
  #MetaFaturamentoInicial v, #FaturaDevolucao, #FaturaDevolucaoAnoAnterior, #FaturaCancelado  
group by  
  cd_empresa,  
  Meta_Mes,
  Qt_Meta_Mes  
  
--------------------------------------------------------------------------------------  
-- Mostra a Tabela com dados do Mês, Porcentagem, Dias Transcorridos e dias Úteis.  
--------------------------------------------------------------------------------------  

  declare @qt_dia_util   as integer  
  declare @qt_dia_transc as integer  
  declare @dt_agenda     as datetime

  set @dt_agenda = @dt_base

  if @dt_base>getdate()
     set @dt_agenda = getdate()

  set @qt_dia_util = ( select count(dt_agenda) from Agenda   
                       where month(dt_agenda) = month(@dt_agenda) and  
                       year(dt_agenda) = year(@dt_agenda) and  
                       ic_util = 'S')  
  
  set @qt_dia_transc = ( select count(dt_agenda) from Agenda   
                       where month(dt_agenda) = month(@dt_agenda) and  
                       year(dt_agenda) = year(@dt_agenda) and  
         dt_agenda <= @dt_agenda and  
                       ic_util = 'S')  

------------------------------------------------
-- Calculando Projeção, Necessidade e Posição  
------------------------------------------------
select   
  cd_empresa,  
  Meta_Mes,   
  Qt_Meta_Mes,   
  @qt_dia_util   as 'DiaUtil',  
  @qt_dia_transc as 'DiaTransc',  
  
  -- Valores
  cast(Vendas as decimal(25,2))                                        as 'Vendas',   
  (Vendas*100)/Meta_Mes                                                as 'perc_venda',  
  (Vendas/@qt_dia_transc)                                              as 'MediaDiaria',  
  ((Vendas/@qt_dia_transc) * @qt_dia_util)                             as 'Projecao',  
  case when Meta_Mes < Vendas then 0.00   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Mes - Vendas)  
  else   
   ((Meta_Mes - Vendas) / (@qt_dia_util - @qt_dia_transc))  
  end                                                                  as 'Necessidade',  
  ((Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Vendas                as 'Abaixo',  

  -- Quantidades
  cast(Qt_Vendas as decimal(25,2))                                     as 'Qt_Vendas',   
  (Qt_Vendas*100)/Qt_Meta_Mes                                          as 'Qt_perc_venda',  
  (Qt_Vendas/@qt_dia_transc)                                           as 'Qt_MediaDiaria',  
  ((Qt_Vendas/@qt_dia_transc) * @qt_dia_util)                          as 'Qt_Projecao',  
  case when Qt_Meta_Mes < Qt_Vendas then 0.00   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Qt_Meta_Mes - Qt_Vendas)  
  else   
   ((Qt_Meta_Mes - Qt_Vendas) / (@qt_dia_util - @qt_dia_transc))  
  end                                                                  as 'Qt_Necessidade',  
  ((Qt_Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Qt_Vendas          as 'Qt_Abaixo'
  
from  
  #MetaVendas  

order by 1 desc  

