CREATE TABLE [dbo].[Plano_Reacao] (
    [cd_plano_reacao] INT          NOT NULL,
    [nm_plano_reacao] VARCHAR (40) NULL,
    [sg_plano_reacao] CHAR (10)    NULL,
    [ds_plano_reacao] TEXT         NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Plano_Reacao] PRIMARY KEY CLUSTERED ([cd_plano_reacao] ASC) WITH (FILLFACTOR = 90)
);

