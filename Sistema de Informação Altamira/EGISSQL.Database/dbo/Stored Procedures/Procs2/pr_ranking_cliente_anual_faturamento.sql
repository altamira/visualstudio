
-------------------------------------------------------------------------------
--pr_ranking_cliente_anual_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Ranking de Vendas por Vendedor
--Data             : 02.05.2006
--Alteração        : 08.05.2008 - Ajuste para bater com o Ranking de Cliente
-- 08.05.2008 - Cálculo por Moeda Forte - Carlos Fernandes                  
-------------------------------------------------------------------------------------------
create procedure pr_ranking_cliente_anual_faturamento
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_moeda        int = 1,  
@cd_tipo_mercado int = 0  

as

  
  declare @vl_moeda        float  
  declare @ic_devolucao_bi char(1) 
 
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                    else dbo.fn_vl_moeda(@cd_moeda) end )  

  set @ic_devolucao_bi = 'N'  
    
  Select   
   top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')  
  from   
   Parametro_BI  
  where  
   cd_empresa = dbo.fn_empresa()  


--select * from vw_faturamento_bi

Select 
      vw.cd_cliente,
      vw.nm_fantasia_destinatario                as 'Cliente',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0))) / 12 as 'Media'

into
  #FaturamentoReal
from
  vw_faturamento_bi vw
where
   vw.dt_nota_saida between @dt_inicial and @dt_final  
   and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
Group By 
   vw.cd_cliente,
   vw.nm_fantasia_destinatario

-------------------------------------------------------------------------------------------
--Devolução Mês
-------------------------------------------------------------------------------------------

Select 
      vw.cd_cliente,
      vw.nm_fantasia                as 'Cliente',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0))) / 12 as 'Media'

into
  #FaturamentoDevolucao
from
  vw_faturamento_devolucao_bi vw
where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

Group By 
   vw.cd_cliente,
   vw.nm_fantasia

-------------------------------------------------------------------------------------------
--Devolução do mês anterior
-------------------------------------------------------------------------------------------

Select 
      vw.cd_cliente,
      vw.nm_fantasia                as 'Cliente',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then   vw.vl_unitario_item_total  end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then   vw.vl_unitario_item_total  end,0))) / 12 as 'Media'

into
  #FaturamentoDevolucaoAnterior
from
    vw_faturamento_devolucao_mes_anterior_bi vw  
where
    year(vw.dt_nota_saida) = year(@dt_inicial) and  
   (vw.dt_nota_saida < @dt_inicial) and  
   vw.dt_restricao_item_nota between @dt_inicial and @dt_final  
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
Group By 
   vw.cd_cliente,
   vw.nm_fantasia


-------------------------------------------------------------------------------------------
--Cancelamento
-------------------------------------------------------------------------------------------

Select 
      vw.cd_cliente,
      vw.nm_fantasia                as 'Cliente',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.vl_unitario_item_nota end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.vl_unitario_item_nota end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.vl_unitario_item_nota end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.vl_unitario_item_nota end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.vl_unitario_item_nota end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.vl_unitario_item_nota end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.vl_unitario_item_nota end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.vl_unitario_item_nota end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.vl_unitario_item_nota end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.vl_unitario_item_nota end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.vl_unitario_item_nota end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.vl_unitario_item_nota end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.vl_unitario_item_nota end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.vl_unitario_item_nota end,0))) / 12 as 'Media'

into
  #FaturamentoCancelamento
from
  vw_faturamento_cancelado_bi vw  
where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

Group By 
   vw.cd_cliente,
   vw.nm_fantasia


--Mostra o Resultado Final



select
   a.cd_cliente,
   a.Cliente,

   cast(IsNull(a.total_ano,0) -  
       (isnull(b.total_ano,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.total_ano,0)  
        end) +   
       isnull(d.total_ano,0)) as money) as total_ano,  

   cast(IsNull(a.media,0) -  
       (isnull(b.media,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.media,0)  
        end) +   
       isnull(d.media,0)) as money) as media,  

   cast(IsNull(a.vlJaneiro,0) -  
       (isnull(b.vlJaneiro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlJaneiro,0)  
        end) +   
       isnull(d.vlJaneiro,0)) as money) as vlJaneiro,

   cast(IsNull(a.vlFevereiro,0) -  
       (isnull(b.vlFevereiro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlFevereiro,0)  
        end) +   
       isnull(d.vlFevereiro,0)) as money) as vlFevereiro,

   cast(IsNull(a.vlMarco,0) -  
       (isnull(b.vlMarco,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlMarco,0)  
        end) +   
       isnull(d.vlMarco,0)) as money) as vlMarco,

   cast(IsNull(a.vlAbril,0) -  
       (isnull(b.vlAbril,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlAbril,0)  
        end) +   
       isnull(d.vlAbril,0)) as money) as vlAbril,

   cast(IsNull(a.vlMaio,0) -  
       (isnull(b.vlMaio,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlMaio,0)  
        end) +   
       isnull(d.vlMaio,0)) as money) as vlMaio,

   cast(IsNull(a.vlJunho,0) -  
       (isnull(b.vlJunho,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlJunho,0)  
        end) +   
       isnull(d.vlJunho,0)) as money) as vlJunho,

   cast(IsNull(a.vlJulho,0) -  
       (isnull(b.vlJulho,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlJulho,0)  
        end) +   
       isnull(d.vlJulho,0)) as money) as vlJulho,

   cast(IsNull(a.vlAgosto,0) -  
       (isnull(b.vlAgosto,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlAgosto,0)  
        end) +   
       isnull(d.vlAgosto,0)) as money) as vlAgosto,

   cast(IsNull(a.vlSetembro,0) -  
       (isnull(b.vlSetembro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlSetembro,0)  
        end) +   
       isnull(d.vlSetembro,0)) as money) as vlSetembro,

   cast(IsNull(a.vlOutubro,0) -  
       (isnull(b.vlOutubro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlOutubro,0)  
        end) +   
       isnull(d.vlOutubro,0)) as money) as vlOutubro,

   cast(IsNull(a.vlNovembro,0) -  
       (isnull(b.vlNovembro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlNovembro,0)  
        end) +   
       isnull(d.vlNovembro,0)) as money) as vlNovembro,

   cast(IsNull(a.vlDezembro,0) -  
       (isnull(b.vlDezembro,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.vlDezembro,0)  
        end) +   
       isnull(d.vlDezembro,0)) as money) as vlDezembro








  
into   
   #FaturaResultado  
from   
   #FaturamentoReal a  
   left outer join  #FaturamentoDevolucao b             on a.cd_cliente = b.cd_cliente  
   left outer join  #FaturamentoDevolucaoAnterior c     on a.cd_cliente = c.cd_cliente  
   left outer join  #FaturamentoCancelamento d          on a.cd_cliente = d.cd_cliente  
  


declare  @vl_total float

set @vl_total = 0

select
  @vl_total = @vl_total + isnull(total_ano,0)
from
  #FaturaResultado

--select @vl_total

select 
  IDENTITY(int, 1,1)                   AS 'Posicao',
  *,
  Perc = cast(( total_ano / @vl_total ) * 100 as float )
into
  #Faturamento
from 
  #FaturaResultado
order by
  total_ano desc
  
select * from #Faturamento

