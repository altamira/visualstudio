CREATE TABLE [dbo].[Grupo_Conta] (
    [cd_grupo_conta]           INT          NOT NULL,
    [nm_grupo_conta]           VARCHAR (30) NOT NULL,
    [ic_tipo_grupo_conta]      CHAR (1)     NULL,
    [cd_mascara_grupo_conta]   VARCHAR (20) NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_plano_conta]           CHAR (1)     NULL,
    [ic_resultado_grupo_conta] CHAR (1)     NULL,
    [ic_balanco_grupo_conta]   CHAR (1)     NULL,
    [ic_custo_grupo_conta]     CHAR (1)     NULL,
    [ic_demo_grupo_conta]      CHAR (1)     NULL,
    [ic_analise_grupo_conta]   CHAR (1)     NULL,
    [qt_grau_grupo_conta]      INT          NULL,
    CONSTRAINT [PK_Grupo_Conta] PRIMARY KEY NONCLUSTERED ([cd_grupo_conta] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_grupo_conta
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Grupo de Contas
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
CREATE trigger tr_apagar_grupo_conta on Grupo_Conta
for delete
as
begin
  declare @cd_grupo_conta int
  select 
    @cd_grupo_conta = cd_grupo_conta
  from 
    deleted
  if exists(select
              cd_conta
            from
              plano_conta
            where
              cd_grupo_conta = @cd_grupo_conta)
    begin
      raiserror('Deleçao nao Permitida. Existem contas no Plano de Contas da Empresa usando este Grupo.',16,1)
      --rollback transaction
    end
  if exists(select
              cd_conta_padrao
            from
              plano_conta_padrao
            where
              cd_grupo_conta = @cd_grupo_conta)
    begin
      raiserror('Deleçao nao Permitida. Existem contas no Plano de Contas Padrao usando este Grupo.',16,1)
      --rollback transaction
    end
end



