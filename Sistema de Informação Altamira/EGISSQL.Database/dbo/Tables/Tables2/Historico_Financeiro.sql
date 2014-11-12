CREATE TABLE [dbo].[Historico_Financeiro] (
    [cd_historico_financeiro] INT          NOT NULL,
    [nm_historico_financeiro] VARCHAR (50) NULL,
    [sg_historico_financeiro] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Historico_Financeiro] PRIMARY KEY CLUSTERED ([cd_historico_financeiro] ASC) WITH (FILLFACTOR = 90)
);

