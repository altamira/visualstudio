

/****** Object:  Stored Procedure dbo.pr_plano_padrao    Script Date: 13/12/2002 15:08:38 ******/
--pr_plano_padrao
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Stored Procedure : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Plano_Padrao
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create procedure pr_plano_padrao
@ic_parametro int,
@cd_plano_padrao int
as
begin
  begin transaction
  if exists(select
              *
            from
              plano_conta_padrao
            where
              cd_plano_padrao = @cd_plano_padrao)
    begin
      raiserror('Deleçao nao Permitida. Existem contas criadas com este Plano Padrao.',16,1)
      return
    end
  else
    begin
      delete from 
        plano_padrao
      where
        cd_plano_padrao = @cd_plano_padrao
    end
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end


