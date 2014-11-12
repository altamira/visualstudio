CREATE TABLE [dbo].[Sub_Grupo_Produto] (
    [cd_grupo_produto]           INT          NOT NULL,
    [cd_sub_grupo_produto]       INT          NOT NULL,
    [nm_sub_grupo_produto]       VARCHAR (40) NULL,
    [sg_sub_grupo_produto]       CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_ordem_sub_grupo_produto] INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_ordem_sub_grupo]         INT          NULL,
    [nm_obs_sub_grupo_produto]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Sub_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_sub_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);

