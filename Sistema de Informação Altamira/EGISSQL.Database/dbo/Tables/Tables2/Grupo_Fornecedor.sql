CREATE TABLE [dbo].[Grupo_Fornecedor] (
    [cd_grupo_fornecedor]      INT          NOT NULL,
    [nm_grupo_fornecedor]      VARCHAR (40) NULL,
    [sg_grupo_fornecedor]      CHAR (10)    NULL,
    [cd_masc_grupo_fornecedor] VARCHAR (20) NULL,
    [ds_grupo_fornecedor]      TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Fornecedor] PRIMARY KEY CLUSTERED ([cd_grupo_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

