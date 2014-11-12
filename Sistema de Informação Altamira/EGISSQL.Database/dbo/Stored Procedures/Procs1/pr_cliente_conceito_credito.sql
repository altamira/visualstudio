
-------------------------------------------------------------------------------
--pr_cliente_conceito_credito
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta de Cliente por Conceito de Credito
--Data             : 12/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_cliente_conceito_credito
@cd_cliente_conceito int
as

Select 
      cc.cd_conceito_credito,
      cc.nm_conceito_credito,
      cic.vl_limite_credito_cliente,
      cic.qt_maior_atraso,
      cic.qt_pagamento_atraso,  
      c.dt_cadastro_cliente,
      c.nm_fantasia_cliente,
      v.nm_fantasia_vendedor

From 
      Conceito_Credito cc left outer join
      Cliente c on c.cd_conceito_cliente = cc.cd_conceito_credito left outer join 	
      Cliente_Informacao_Credito cic on cic.cd_cliente = c.cd_cliente left outer join
      vendedor v on v.cd_vendedor = c.cd_vendedor
      
      
      
Where 
      IsNull(cc.cd_conceito_credito,0) = 
      case 
         When isnull(@cd_cliente_conceito,0) = 0 then 
            IsNull(cc.cd_conceito_credito,0) 
         else 
           @cd_cliente_conceito 
         end

order By cc.nm_conceito_credito 
