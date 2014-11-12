CREATE TABLE [dbo].[DI_Adicao] (
    [cd_di]                   INT        NOT NULL,
    [cd_classificacao_fiscal] INT        NOT NULL,
    [qt_peso_liquido_di]      FLOAT (53) NULL,
    [qt_peso_bruto_di]        FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_DI_Adicao] PRIMARY KEY CLUSTERED ([cd_di] ASC, [cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DI_Adicao_Di] FOREIGN KEY ([cd_di]) REFERENCES [dbo].[Di] ([cd_di])
);

