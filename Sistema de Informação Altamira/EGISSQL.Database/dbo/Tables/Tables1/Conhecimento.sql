CREATE TABLE [dbo].[Conhecimento] (
    [cd_conhecimento]      INT          NOT NULL,
    [dt_conhecimento]      DATETIME     NOT NULL,
    [nm_conhecimento]      VARCHAR (40) NOT NULL,
    [ds_conhecimento]      TEXT         NOT NULL,
    [cd_departamento]      INT          NOT NULL,
    [cd_tipo_conhecimento] INT          NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    CONSTRAINT [PK_Conhecimento] PRIMARY KEY CLUSTERED ([cd_conhecimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Conhecimento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Conhecimento_Tipo_Conhecimento] FOREIGN KEY ([cd_tipo_conhecimento]) REFERENCES [dbo].[Tipo_Conhecimento] ([cd_tipo_conhecimento])
);

