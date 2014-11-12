
-------------------------------------------------------------------------------
--pr_documento_receber_sem_portador
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 13/10/2005
--Atualizado       : 13/10/2005
--------------------------------------------------------------------------------------------------
create procedure pr_documento_receber_sem_portador
@dt_inicial datetime,
@dt_final   datetime

as

 --select * from documento_receber
  
 select 
  cd_identificacao        as documento,
  dt_emissao_documento    as emissao,
  dt_vencimento_documento as vencimento,
  vl_documento_receber    as Valor,
  cd_pedido_venda         as Pedido,
  cd_nota_saida           as NotaFiscal
 from
  documento_receber
 where
  isnull(cd_portador,0)=0

