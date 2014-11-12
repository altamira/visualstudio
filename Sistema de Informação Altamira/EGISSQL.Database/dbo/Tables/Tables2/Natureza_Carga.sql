CREATE TABLE [dbo].[Natureza_Carga] (
    [cd_natureza_carga]     INT          NOT NULL,
    [nm_natureza_carga]     VARCHAR (40) NULL,
    [nm_fantasia_natureza]  VARCHAR (15) NULL,
    [ds_natureza_carga]     TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [vl_natureza_carga]     FLOAT (53)   NULL,
    [nm_obs_natureza_carga] VARCHAR (40) NULL,
    CONSTRAINT [PK_Natureza_Carga] PRIMARY KEY CLUSTERED ([cd_natureza_carga] ASC) WITH (FILLFACTOR = 90)
);

