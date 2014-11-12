CREATE TABLE [dbo].[Processo_Padrao_Teste] (
    [cd_processo_padrao]       INT          NOT NULL,
    [cd_teste]                 INT          NOT NULL,
    [cd_processo_padrao_teste] INT          NOT NULL,
    [nm_resultado]             VARCHAR (60) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [qt_maximo_teste]          FLOAT (53)   NULL,
    [qt_minimo_teste]          FLOAT (53)   NULL,
    [cd_unidade_medida]        INT          NULL,
    [cd_metodo_teste]          INT          NULL,
    CONSTRAINT [PK_Processo_Padrao_Teste] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_teste] ASC, [cd_processo_padrao_teste] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Teste_Metodo_Teste] FOREIGN KEY ([cd_metodo_teste]) REFERENCES [dbo].[Metodo_Teste] ([cd_metodo_teste]),
    CONSTRAINT [FK_Processo_Padrao_Teste_Teste] FOREIGN KEY ([cd_teste]) REFERENCES [dbo].[Teste] ([cd_teste])
);

