CREATE TABLE [dbo].[CID10] (
    [cd_cid10]                INT          NOT NULL,
    [nm_fantasia_cid10]       CHAR (5)     NULL,
    [nm_cid10]                VARCHAR (50) NULL,
    [ic_restricao_sexo_cid10] CHAR (1)     NULL,
    [cd_grupo_cid10]          INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_CID10] PRIMARY KEY CLUSTERED ([cd_cid10] ASC) WITH (FILLFACTOR = 90)
);

