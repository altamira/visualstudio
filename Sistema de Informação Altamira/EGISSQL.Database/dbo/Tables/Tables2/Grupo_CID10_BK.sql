CREATE TABLE [dbo].[Grupo_CID10_BK] (
    [cd_grupo_cid10]            INT          NOT NULL,
    [nm_fantasia_grupo_cid10]   CHAR (5)     NULL,
    [nm_grupo_cid10]            VARCHAR (50) NULL,
    [ic_restr_sexo_grupo_cid10] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_CID10] PRIMARY KEY CLUSTERED ([cd_grupo_cid10] ASC) WITH (FILLFACTOR = 90)
);

