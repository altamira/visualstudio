
CREATE PROCEDURE pr_cancela_reprovacao_requisicao_compra

--pr_cancela_reprovacao_requisicao_compra
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EgisSql
--Objetivo: Fazer o Cancelamento de uma Reprovação de Requisicao de Compra.
--Data: 26/05/2004
---------------------------------------------------

@cd_requisicao_compra as int,
@dt_inicial datetime,
@dt_final datetime

AS

SELECT DISTINCT
     'N' as ic_aprov_comprador_pedido,
     rc.cd_requisicao_compra, 
	   rc.dt_emissao_req_compra, 
	   rc.dt_necessidade_req_compra, 
     dp.nm_departamento,
     u.nm_fantasia_usuario

FROM       Requisicao_Compra rc Left outer join
           egisadmin.dbo.usuario u on u.cd_usuario=rc.cd_usuario Left outer join
           Departamento dp  on dp.cd_departamento=rc.cd_departamento 

WHERE      
           ( IsNull(rc.ic_reprovada_req_compra,'N') = 'S') and

           ( IsNull(rc.cd_requisicao_compra,0) = ( case when @cd_requisicao_compra = 0 then
                                                   IsNull(rc.cd_requisicao_compra,0) else
                                                   @cd_requisicao_compra end) ) and

           ( rc.dt_emissao_req_compra  between  
               ( case when @cd_requisicao_compra = 0 then
                       @dt_inicial else 
                 IsNull(rc.dt_emissao_req_compra,GetDate()) end ) and 
               ( case when @cd_requisicao_compra = 0 then
                       @dt_final else 
                 IsNull(rc.dt_emissao_req_compra,GetDate()) end ) )
  



