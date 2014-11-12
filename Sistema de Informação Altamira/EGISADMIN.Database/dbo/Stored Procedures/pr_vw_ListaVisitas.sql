
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--pr_vw_Lista_de_Visitas
--------------------------------------------------------------------------------------
--GBS - Global Business Solution                     
--Stored Procedure : SQL Server Microsoft 2000
--Fabio Cesar
--Listagem de todas as visitas vincula ao vendedor
--Data          : 24.10.2001
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE procedure pr_vw_ListaVisitas
@cd_vendedor int = 0
as
select cd_visita,
       dt_visita,
       cd_tipo_visita,       
       nm_fantasia_cliente,
       cd_contato,
       ic_retorno_visita,
       dt_retorno_visita,
       ds_visita,
       cd_usuario,
       dt_usuario,
       nm_assunto_visita,
       ds_visita_retorno,
       nm_vendedor
from Visita
inner join Vendedor
on Vendedor.cd_vendedor = Visita.cd_vendedor
where ic_retorno_visita = 'N'
and visita.cd_vendedor = @cd_vendedor
order by dt_visita
select * from visita

