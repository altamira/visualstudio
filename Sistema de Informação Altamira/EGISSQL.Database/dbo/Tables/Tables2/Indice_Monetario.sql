CREATE TABLE [dbo].[Indice_Monetario] (
    [cd_indice_monetario]            INT          NOT NULL,
    [nm_indice_monetario]            VARCHAR (40) NULL,
    [nm_fantasia_indice_monetario]   VARCHAR (15) NULL,
    [sg_indice_monetario]            VARCHAR (10) NULL,
    [ic_padrao_ativo_indice_monetar] CHAR (1)     NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    CONSTRAINT [PK_Indice_Monetario] PRIMARY KEY CLUSTERED ([cd_indice_monetario] ASC) WITH (FILLFACTOR = 90)
);

