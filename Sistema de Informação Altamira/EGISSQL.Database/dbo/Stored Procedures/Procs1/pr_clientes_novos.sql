--------------------------------------------------------------------------------------
--pr_clientes_novos_resumo
--------------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                            2006
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Clientes novos por Setor
--Data          : 09.09.2000
--Atualizado    : 09.09.2000
--              : 06/04/2002 - Alterado para o padrao do EGIS - Sandro Campos 
--              : 14.03.2006 - Colocado o Código do cliente - Carlos Fernandes
--              : 27.03.2006 - Coluna de Status do Cliente - Carlos Fernandes
--              : 25.05.2006 - Complemento dos dados - Carlos Fernandes
--------------------------------------------------------------------------------------
create procedure pr_clientes_novos
@cd_vendedor int = 0,
@cd_ano      int = 0
as

select 
       c.cd_cliente,             
       c.cd_vendedor            as 'setor',
       c.nm_fantasia_cliente    as 'cliente',
       c.dt_cadastro_cliente    as 'cadastro',  
       sc.nm_status_cliente     as 'status',
      isnull((select 
         v.nm_fantasia_vendedor 
       from 
         Vendedor v
       where
         v.cd_vendedor=c.cd_vendedor_interno),'Não Cadastrado') as 'VendInterno',
       case when isnull(c.cd_ddd,'') <> '' then
           '('+rtrim(cast(c.cd_ddd as varchar))+') '+c.cd_telefone
       else
         c.cd_telefone end	as 'Telefone',
       e.sg_estado		as 'UF',
       f.nm_fonte_informacao	as 'FonteInformacao'
 
from
    cliente c
    left outer join status_cliente sc  on sc.cd_status_cliente = c.cd_status_cliente
    left outer join Estado e           on c.cd_estado = e.cd_estado and
                                          c.cd_pais = e.cd_pais
    left outer join Fonte_Informacao f on c.cd_fonte_informacao = f.cd_fonte_informacao

where
  ((c.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))  and
  year(c.dt_cadastro_cliente)=@cd_ano

order by 3 desc
  
