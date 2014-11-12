CREATE TABLE [dbo].[Situacao_Operacao_Simples] (
    [cd_situacao_operacao]      INT           NOT NULL,
    [nm_situacao_operacao]      VARCHAR (100) NULL,
    [cd_identificacao_situacao] INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Situacao_Operacao_Simples] PRIMARY KEY CLUSTERED ([cd_situacao_operacao] ASC)
);

