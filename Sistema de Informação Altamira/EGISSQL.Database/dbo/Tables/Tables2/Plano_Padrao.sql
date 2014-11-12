CREATE TABLE [dbo].[Plano_Padrao] (
    [cd_plano_padrao]           INT          NOT NULL,
    [nm_plano_padrao]           VARCHAR (30) NOT NULL,
    [nm_aplicacao_plano_padrao] VARCHAR (40) NULL,
    [sg_plano_padrao]           CHAR (10)    NULL,
    [dt_plano_padrao]           DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Plano_padrao] PRIMARY KEY CLUSTERED ([cd_plano_padrao] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_plano_padrao
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Plano_Padrao
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_plano_padrao on Plano_padrao
for delete
as
begin
  declare @cd_plano_padrao int
  select 
    @cd_plano_padrao = cd_plano_padrao
  from 
    deleted
  if exists(select
              *
            from
              plano_conta_padrao
            where
              cd_plano_padrao = @cd_plano_padrao)
    begin
      raiserror('Deleçao nao Permitida. Existem contas criadas com este Plano Padrao.',16,1)
      rollback transaction
    end
end
