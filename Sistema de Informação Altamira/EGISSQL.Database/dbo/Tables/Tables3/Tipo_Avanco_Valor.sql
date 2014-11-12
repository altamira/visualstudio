CREATE TABLE [dbo].[Tipo_Avanco_Valor] (
    [cd_tipo_avanco]       INT        NOT NULL,
    [cd_tipo_avanco_valor] INT        NOT NULL,
    [qt_valor_tipo_avanco] FLOAT (53) NOT NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Tipo_Avanco_Valor] PRIMARY KEY CLUSTERED ([cd_tipo_avanco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Avanco_Valor_Tipo_Avanco] FOREIGN KEY ([cd_tipo_avanco]) REFERENCES [dbo].[Tipo_Avanco] ([cd_tipo_avanco])
);

