CREATE TABLE [dbo].[Processo_Producao_Teste] (
    [cd_processo]                INT          NOT NULL,
    [cd_processo_producao_teste] INT          NOT NULL,
    [cd_teste]                   INT          NULL,
    [nm_processo_producao_teste] VARCHAR (60) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Processo_Producao_Teste] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_processo_producao_teste] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Teste_Teste] FOREIGN KEY ([cd_teste]) REFERENCES [dbo].[Teste] ([cd_teste])
);

