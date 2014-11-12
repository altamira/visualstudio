CREATE TABLE [dbo].[Imagem] (
    [cd_imagem]         INT          NOT NULL,
    [nm_imagem]         VARCHAR (30) NOT NULL,
    [sg_imagem]         CHAR (10)    NULL,
    [nm_arquivo_imagem] VARCHAR (50) NULL,
    [nm_local_imagem]   VARCHAR (50) NULL,
    [ic_alteracao]      CHAR (1)     NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Imagem] PRIMARY KEY CLUSTERED ([cd_imagem] ASC) WITH (FILLFACTOR = 90)
);

