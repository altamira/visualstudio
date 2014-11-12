CREATE TABLE [dbo].[CNAE] (
    [cd_cnae]           INT          NOT NULL,
    [nm_cnae]           VARCHAR (60) NULL,
    [cd_siscomex]       INT          NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_divisao_cnae]   VARCHAR (2)  NULL,
    [cd_grupo_cnae]     VARCHAR (5)  NULL,
    [cd_classe_cnae]    VARCHAR (5)  NULL,
    [ds_cnae]           TEXT         NULL,
    [cd_subclasse_cnae] VARCHAR (5)  NULL
);

