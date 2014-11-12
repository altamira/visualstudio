CREATE TABLE [dbo].[Natureza_Atributo] (
    [cd_natureza_atributo]      INT          NOT NULL,
    [nm_natureza_atributo]      VARCHAR (30) NULL,
    [cd_imagem]                 INT          NOT NULL,
    [cd_usuario_atualiza]       INT          NULL,
    [dt_atualiza]               DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_fieldtype_procedimento] INT          NULL,
    CONSTRAINT [PK_Natureza_Atributo] PRIMARY KEY CLUSTERED ([cd_natureza_atributo] ASC) WITH (FILLFACTOR = 90)
);

