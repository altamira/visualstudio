CREATE TABLE [dbo].[Plano_Academia] (
    [cd_plano]       INT          NOT NULL,
    [nm_plano]       VARCHAR (40) NULL,
    [ds_plano]       TEXT         NULL,
    [ic_plano_ativo] CHAR (1)     NULL,
    [vl_plano]       MONEY        NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Plano_Academia] PRIMARY KEY CLUSTERED ([cd_plano] ASC) WITH (FILLFACTOR = 90)
);

