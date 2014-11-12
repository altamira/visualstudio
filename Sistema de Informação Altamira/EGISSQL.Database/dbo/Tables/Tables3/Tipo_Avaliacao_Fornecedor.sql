CREATE TABLE [dbo].[Tipo_Avaliacao_Fornecedor] (
    [cd_tipo_avaliacao] INT          NOT NULL,
    [nm_tipo_avaliacao] VARCHAR (40) NULL,
    [sg_tipo_avaliacao] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [qt_tipo_avaliacao] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Avaliacao_Fornecedor] PRIMARY KEY CLUSTERED ([cd_tipo_avaliacao] ASC) WITH (FILLFACTOR = 90)
);

