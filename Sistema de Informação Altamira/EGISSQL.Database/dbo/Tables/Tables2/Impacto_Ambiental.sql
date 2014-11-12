CREATE TABLE [dbo].[Impacto_Ambiental] (
    [cd_impacto_ambiental]     INT          NOT NULL,
    [nm_impacto_ambiental]     VARCHAR (40) NULL,
    [ds_impacto_ambiental]     TEXT         NULL,
    [ic_ativo_impacto]         CHAR (1)     NULL,
    [nm_obs_impacto_ambiental] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Impacto_Ambiental] PRIMARY KEY CLUSTERED ([cd_impacto_ambiental] ASC) WITH (FILLFACTOR = 90)
);

