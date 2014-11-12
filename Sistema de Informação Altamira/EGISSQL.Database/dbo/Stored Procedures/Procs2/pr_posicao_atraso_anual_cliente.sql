
-------------------------------------------------------------------------------
--pr_posicao_atraso_anual_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Posição de Atrasos Anual por Vendedor/Cliente
--Data             : 09/08/2005
--Atualizado       :  
--------------------------------------------------------------------------------------------------
create procedure pr_posicao_atraso_anual_cliente
@dt_inicial           datetime,
@dt_final             datetime,	
@cd_vendedor          integer
as

Select sum(dr.vl_saldo_documento) as vl_total_previsao
into #previsao
from 
    Cliente c 
     left outer join Documento_Receber dr on
    dr.cd_cliente = c.cd_cliente
     left outer join Vendedor v on
    v.cd_vendedor = dr.cd_vendedor
where dr.dt_vencimento_documento between @dt_inicial and @dt_final and
      IsNull(v.cd_vendedor,0) = 
      case 
       When isnull(@cd_vendedor,0) = 0 then 
         IsNull(v.cd_vendedor,0) 
       else 
         @cd_vendedor 
      end



declare @vl_total_previsto float

set @vl_total_previsto = 0

select @vl_total_previsto = isnull((select vl_total_previsao from #previsao),0) from #Previsao



Select
      (select vl_total_previsao from #previsao) as vl_total_previsao,      
      ((dr.vl_saldo_documento/@vl_total_previsto) * 100) as percentual,
      --dr.cd_identificacao,
      v.nm_fantasia_vendedor,
      c.cd_cliente,
      c.nm_fantasia_cliente,
      dr.dt_vencimento_documento,
      year(dr.dt_vencimento_documento) as Ano,
      dr.vl_saldo_documento,
      case when month(dr.dt_vencimento_documento) = 1  then dr.vl_saldo_documento else 0 end as Janeiro,
      case when month(dr.dt_vencimento_documento) = 2  then dr.vl_saldo_documento else 0 end as Fevereiro,
      case when month(dr.dt_vencimento_documento) = 3  then dr.vl_saldo_documento else 0 end as Marco,  
      case when month(dr.dt_vencimento_documento) = 4  then dr.vl_saldo_documento else 0 end as Abril,  
      case when month(dr.dt_vencimento_documento) = 5  then dr.vl_saldo_documento else 0 end as Maio,
      case when month(dr.dt_vencimento_documento) = 6  then dr.vl_saldo_documento else 0 end as Junho,
      case when month(dr.dt_vencimento_documento) = 7  then dr.vl_saldo_documento else 0 end as Julho,
      case when month(dr.dt_vencimento_documento) = 8  then dr.vl_saldo_documento else 0 end as Agosto,
      case when month(dr.dt_vencimento_documento) = 9  then dr.vl_saldo_documento else 0 end as Setembro,       
      case when month(dr.dt_vencimento_documento) = 10 then dr.vl_saldo_documento else 0 end as Outubro,
      case when month(dr.dt_vencimento_documento) = 11 then dr.vl_saldo_documento else 0 end as Novembro,
      case when month(dr.dt_vencimento_documento) = 12 then dr.vl_saldo_documento else 0 end as Dezembro
from
    Cliente c
     left outer join Documento_Receber dr on
    dr.cd_cliente = c.cd_cliente
     left outer join Vendedor v on
    v.cd_vendedor = dr.cd_vendedor

where dr.dt_vencimento_documento between @dt_inicial and @dt_final and
      IsNull(v.cd_vendedor,0) = 
      case 
       When isnull(@cd_vendedor,0) = 0 then 
         IsNull(v.cd_vendedor,0) 
       else 
         @cd_vendedor 
      end
group by
      --dr.cd_identificacao,
      v.nm_fantasia_vendedor,
      c.cd_cliente,
      c.nm_fantasia_cliente,
      dr.dt_vencimento_documento,
      dr.dt_vencimento_documento,
      dr.vl_saldo_documento
order by dr.dt_vencimento_documento,c.nm_fantasia_cliente
--drop table #previsao
-- select dr.vl_saldo_documento 
-- from Cliente c left join Documento_Receber dr on dr.cd_cliente = c.cd_cliente 
-- where month(dt_vencimento_documento) = 1 
