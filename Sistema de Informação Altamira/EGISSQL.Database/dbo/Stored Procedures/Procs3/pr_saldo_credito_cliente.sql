
-----------------------------------------------------------------------------------
--pr_saldo_credito_cliente
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta de Saldos de Crédito por Cliente
--                
--Data             : 28.10.2005
--Atualizado       : 28.10.2005
--                 : 
-----------------------------------------------------------------------------------

create procedure pr_saldo_credito_cliente
@dt_inicial           datetime,      --Data Inicial
@dt_final             datetime       --Data Final
as

--select * from cliente_informacao_credito

select
  c.nm_fantasia_cliente              as Cliente,
  c.dt_cadastro_cliente              as Cadastro,
  ci.vl_limite_credito_cliente       as Limite,
  ci.vl_saldo_credito_cliente        as SaldoCredito,
  isnull(ci.ic_credito_suspenso,'N') as Suspenso,
  Atraso = ( 
    select
      cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2))
    from
      Cliente cli left outer join
      Documento_Receber dr on dr.cd_cliente = cli.cd_cliente  
    where 
      cli.cd_cliente = c.cd_cliente and 
      dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U') and
      CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null ), 
  v.nm_fantasia_vendedor             as Vendedor
from
  Cliente c
  left outer join Cliente_Informacao_Credito ci on ci.cd_cliente = c.cd_cliente
  left outer join Vendedor v                    on v.cd_vendedor = c.cd_vendedor  
  left outer join status_cliente sc             on sc.cd_status_cliente = c.cd_status_cliente
where
  isnull(c.cd_status_cliente,0)=1 --Ativo
order by
  c.nm_fantasia_cliente

