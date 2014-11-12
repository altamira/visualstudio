CREATE TABLE [dbo].[Inventario_PCP] (
    [cd_inventario_pcp]     INT          NOT NULL,
    [dt_inventario_pcp]     DATETIME     NOT NULL,
    [nm_obs_inventario_pcp] VARCHAR (50) NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Inventario_PCP] PRIMARY KEY CLUSTERED ([cd_inventario_pcp] ASC) WITH (FILLFACTOR = 90)
);

