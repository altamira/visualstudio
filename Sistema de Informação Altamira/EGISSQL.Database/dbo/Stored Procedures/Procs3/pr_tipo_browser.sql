

/****** Object:  Stored Procedure dbo.pr_tipo_browser    Script Date: 13/12/2002 15:08:43 ******/
--pr_tipo_browser
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton Marques de Souza
--Quantidade de acessos por Browsers
--Data         : 30.01.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_tipo_browser
@dt_inicial datetime,
@dt_final   datetime
as
select Browser, count(Browser) as Acessos 
from tb_host 
where Browser <> '' and
      Data between @dt_inicial and @dt_final 
group by Browser
order by Acessos desc 


