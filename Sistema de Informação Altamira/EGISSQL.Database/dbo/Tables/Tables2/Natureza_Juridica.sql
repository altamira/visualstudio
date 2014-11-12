CREATE TABLE [dbo].[Natureza_Juridica] (
    [cd_natureza_juridica]      INT          NOT NULL,
    [nm_natureza_juridica]      VARCHAR (50) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_tipo_natureza_juridica] INT          NULL,
    CONSTRAINT [PK_Natureza_Juridica] PRIMARY KEY CLUSTERED ([cd_natureza_juridica] ASC) WITH (FILLFACTOR = 90)
);

