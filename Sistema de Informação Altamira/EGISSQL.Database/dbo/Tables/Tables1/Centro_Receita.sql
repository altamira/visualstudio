CREATE TABLE [dbo].[Centro_Receita] (
    [cd_centro_receita]       INT          NOT NULL,
    [nm_centro_receita]       VARCHAR (40) NULL,
    [sg_centro_receita]       CHAR (10)    NULL,
    [ic_ativo_centro_receita] CHAR (1)     NULL,
    [ds_centro_receita]       TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Centro_Receita] PRIMARY KEY CLUSTERED ([cd_centro_receita] ASC) WITH (FILLFACTOR = 90)
);

