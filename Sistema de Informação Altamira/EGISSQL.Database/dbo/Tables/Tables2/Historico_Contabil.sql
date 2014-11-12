CREATE TABLE [dbo].[Historico_Contabil] (
    [cd_historico_contabil] INT          NOT NULL,
    [nm_historico_contabil] VARCHAR (70) NOT NULL,
    [ic_compl_historico]    CHAR (1)     NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Historico_contabil] PRIMARY KEY CLUSTERED ([cd_historico_contabil] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_historico_contabil
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Historico_contabil
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_historico_contabil on Historico_contabil
for delete
as
begin
  declare @cd_historico_contabil int
  select 
    @cd_historico_contabil = cd_historico_contabil
  from 
    deleted
  if exists(select
              cd_lancamento_contabil
            from
              movimento_contabil
            where
              cd_historico_contabil = @cd_historico_contabil)
    begin
      raiserror('Deleçao nao Permitida. Existem lançamentos usando este Histórico Contábil.',16,1)
      rollback transaction
    end
end
