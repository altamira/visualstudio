
CREATE PROCEDURE pr_cliente_problema_credito
--------------------------------------------------------------------------
--pr_cliente_problema_credito
--------------------------------------------------------------------------
--GBS - Global Business Soluttion  Ltda                               2004
--------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Daniel Carrasco Neto
--Banco de Dados       : SAPSQL
--Objetivo             : Listar todos os clientes com problemas de crédito
--Data                 : 25/02/2002
--Atualizado           : 01/04/2002 - Migracao p/ EGISSQL - Elias
--                     : 12/08/2003 - Acerto na SP - Utilizava 'where' como join e impossibilitava a consulta.
--                                    Substituido por Left outer join (DUELA)
--                     : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 16.09.2005 - Colocado o Motivo da Suspensão de Crédito - Carlos Fernandes
--                     : 14.03.2006 - Nova Coluna com o Total de Atraso - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------
@ic_parametro        as integer,
@nm_fantasia_cliente as varchar(30)

AS
  
-------------------------------------------------------------------------------
if @ic_parametro = 1    -- (Todos)
-------------------------------------------------------------------------------
begin
  select
    c.cd_cliente,
    cli.nm_fantasia_cliente,
    c.ds_observacao_credito,
    c.ic_credito_suspenso,
    c.dt_suspensao_credito,
    c.cd_usuario_cred_susp,
    u.nm_fantasia_usuario,  
    c.nm_credito_suspenso,
    sc.nm_suspensao_credito,
    ( select cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2))
    from
     Documento_Receber dr 
    where
      dr.cd_cliente = cli.cd_cliente 
     and dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U')
     and CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null ) as 'Total_Atraso'
    
  from
    Cliente_Informacao_Credito c
  left outer join Cliente cli on
     c.cd_cliente = cli.cd_cliente
  left outer join egisadmin.dbo.usuario u on
    c.cd_usuario = u.cd_usuario    
  left outer join Suspensao_Credito sc on sc.cd_suspensao_credito = c.cd_suspensao_credito
  where
     c.ic_credito_suspenso = 'S' 

  order by
     nm_fantasia_cliente
  

end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- (Filtrado pelo nm_fantasia_cliente)
-------------------------------------------------------------------------------
begin
  select
    c.cd_cliente,
    cli.nm_fantasia_cliente,
    c.ds_observacao_credito,
    c.ic_credito_suspenso,
    c.dt_suspensao_credito,
    c.cd_usuario_cred_susp,
    u.nm_fantasia_usuario,  
    c.nm_credito_suspenso,
    ( select cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2))
    from
     Documento_Receber dr 
    where
      dr.cd_cliente = cli.cd_cliente 
     and dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U')
     and CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null ) as 'Total_Atraso'
  from
    Cliente cli 
      left outer join Cliente_Informacao_Credito c on cli.cd_cliente = c.cd_cliente
      left outer join  egisadmin.dbo.usuario u     on c.cd_usuario_cred_susp = u.cd_usuario    

  where
     c.cd_cliente = cli.cd_cliente and
     cli.nm_fantasia_cliente like @nm_fantasia_cliente and
     c.ic_credito_suspenso = 'S'
  order by
     nm_fantasia_cliente

end

