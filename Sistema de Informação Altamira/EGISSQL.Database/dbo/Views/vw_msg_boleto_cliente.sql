
CREATE VIEW vw_msg_boleto_cliente
------------------------------------------------------------------------------------
--sp_helptext vw_msg_boleto_cliente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Montagem do (%) de Desconto para o Cliente no Boleto
--
--
--Data                  : 27.02.2010
--Atualização           : 23.03.2010 - Ajuste no (%) sempre do Cadastro do Cliente
--
------------------------------------------------------------------------------------
as
 
select
  c.cd_cliente,
  c.nm_razao_social_cliente,
  isnull(ci.pc_desconto_boleto,0)         as pc_desconto_boleto,

  --Mensagem

  Cast('CONCEDER '+rtrim(ltrim(cast(

  
  case when isnull(ci.pc_desconto_boleto,0)>0 and isnull(ci.pc_desconto_boleto,0)<>999
  then
     isnull(ci.pc_desconto_boleto,0) 
  else
     case when isnull(ci.pc_desconto_boleto,0)=999 then
       0
     else
      ( select isnull(pc_desconto_boleto,0)
        from
          parametro_financeiro with (nolock)
        where
          cd_empresa = dbo.fn_empresa() )
     end
  end
 
  as varchar(02) )))

  +'% DESCTO. ATE VENCTO' as char(30))
                              as msg_boleto

from
  Cliente c
  left outer join cliente_informacao_credito ci on ci.cd_cliente = c.cd_cliente 

