CREATE TABLE [dbo].[Relatorio_Plano_Conta] (
    [cd_relatorio]      INT      NOT NULL,
    [cd_item_relatorio] INT      NOT NULL,
    [cd_plano_conta]    INT      NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Relatorio_Plano_Conta] PRIMARY KEY CLUSTERED ([cd_relatorio] ASC, [cd_item_relatorio] ASC)
);

