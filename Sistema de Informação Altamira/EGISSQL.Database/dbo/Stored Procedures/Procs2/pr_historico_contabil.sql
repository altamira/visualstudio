

/****** Object:  Stored Procedure dbo.pr_historico_contabil    Script Date: 13/12/2002 15:08:33 ******/
--pr_historico_contabil
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Stored Procedure : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Histórico Contábil
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create procedure pr_historico_contabil
@ic_parametro int,
@cd_historico_contabil int
as
begin
  begin transaction
  if exists(select
              cd_lancamento_contabil
            from
              Movimento_contabil
            where
              cd_historico_contabil = @cd_historico_contabil)
    begin
      raiserror('Deleçao nao Permitida. Existem Lançamentos usando este Histórico Contábil.',16,1)
      return
    end
  else
    begin
      delete from 
        Historico_contabil
      where
        cd_historico_contabil = @cd_historico_contabil
    end
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end


