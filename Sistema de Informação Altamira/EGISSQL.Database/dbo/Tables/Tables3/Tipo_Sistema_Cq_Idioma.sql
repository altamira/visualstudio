CREATE TABLE [dbo].[Tipo_Sistema_Cq_Idioma] (
    [cd_tipo_sistema] INT          NOT NULL,
    [cd_idioma]       INT          NOT NULL,
    [nm_tipo_sistema] VARCHAR (60) NULL,
    [sg_tipo_sistema] VARCHAR (20) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Sistema_Cq_Idioma] PRIMARY KEY CLUSTERED ([cd_tipo_sistema] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Sistema_Cq_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

