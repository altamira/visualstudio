

/****** Object:  Stored Procedure dbo.pr_fila_fax    Script Date: 13/12/2002 15:08:31 ******/
--pr_fila_fax
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Correia Barros
--Carlos Cardoso Fernandes
--Consulta de Filas de Fax
--Data         : 09.02.2001
--Atualizado   : 
--------------------------------------------------------------------------------------
create procedure pr_fila_fax
@ic_status_fax char(1)
as
select * from fila_fax
 where ic_status_fax = @ic_status_fax
order by ic_prioridade_fax, dt_geracao_fax


