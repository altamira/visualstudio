CREATE TABLE [dbo].[Plano_Conta_Padrao] (
    [cd_plano_padrao]            INT          NOT NULL,
    [cd_conta_padrao]            INT          NOT NULL,
    [cd_mascara_conta_padrao]    VARCHAR (20) NOT NULL,
    [nm_conta_padrao]            VARCHAR (40) NOT NULL,
    [ic_tipo_conta_padrao]       CHAR (1)     NOT NULL,
    [ic_conta_analitica_padrao]  CHAR (1)     NOT NULL,
    [ic_conta_balanco_padrao]    CHAR (1)     NOT NULL,
    [ic_conta_resultado_padrao]  CHAR (1)     NOT NULL,
    [ic_conta_analise_padrao]    CHAR (1)     NOT NULL,
    [ic_conta_custo]             CHAR (1)     NOT NULL,
    [ic_lancamento_conta_padrao] CHAR (1)     NULL,
    [ic_situacao_conta_padrao]   CHAR (1)     NULL,
    [cd_grupo_conta]             INT          NOT NULL,
    [cd_conta_reduzido_padrao]   INT          NOT NULL,
    [qt_grau_conta_padrao]       INT          NULL,
    [cd_usuario]                 INT          NOT NULL,
    [dt_usuario]                 DATETIME     NOT NULL,
    [cd_conta_sintetica_padrao]  INT          NULL,
    [ic_conta_demonstrativo]     CHAR (1)     NULL,
    CONSTRAINT [PK_Plano_conta_padrao] PRIMARY KEY NONCLUSTERED ([cd_plano_padrao] ASC, [cd_conta_padrao] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_plano_conta_padrao
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Plano de Contas Padrao
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_plano_conta_padrao on dbo.Plano_conta_padrao
for delete
as
begin
  declare @cd_mascara_conta_padrao varchar(20)
  declare @cd_plano_padrao int
  select 
    @cd_plano_padrao = cd_plano_padrao, 
    @cd_mascara_conta_padrao = cd_mascara_conta_padrao
  from 
    deleted
  if exists(select
              cd_conta_padrao
            from
              Plano_conta_padrao
            where
              cd_mascara_conta_padrao like @cd_mascara_conta_padrao+'[.^]%' and
              cd_plano_padrao = @cd_plano_padrao)
    begin
      raiserror('Deleçao nao Permitida. Existem Contas Analíticas que participam desta conta Sintética.',16,1)
      rollback transaction
    end
end
