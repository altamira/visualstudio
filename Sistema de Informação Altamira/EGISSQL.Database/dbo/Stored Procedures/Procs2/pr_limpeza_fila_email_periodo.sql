
-------------------------------------------------------------------------------
--pr_limpeza_fila_email_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Limpeza Automática da Fila de E-mail por Período
--                   Por Período
--Data             : 20/05/2005
--Atualizado       : 27.02.2009 - Desenvolvimento da rotina por Período
--
--------------------------------------------------------------------------------------------------
create procedure pr_limpeza_fila_email_periodo
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from servico_email

begin tran

  delete from servico_email
  where
    convert(datetime,left(convert(varchar,dt_servico_email,121),10)+' 00:00:00',121) between @dt_inicial and @dt_final

--convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar a tabela de Fila de Serviço de Fax, pois ocorreram erros !',16,1)
     rollback tran
   end


