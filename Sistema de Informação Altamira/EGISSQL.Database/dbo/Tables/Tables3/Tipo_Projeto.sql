CREATE TABLE [dbo].[Tipo_Projeto] (
    [cd_tipo_projeto]          INT          NOT NULL,
    [nm_tipo_projeto]          VARCHAR (40) NULL,
    [sg_tipo_projeto]          CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_tipo_projeto]      VARCHAR (40) NULL,
    [ds_tipo_projeto]          TEXT         NULL,
    [nm_identica_tipo_projeto] VARCHAR (10) NULL,
    [ic_ativo_tipo_projeto]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Projeto] PRIMARY KEY NONCLUSTERED ([cd_tipo_projeto] ASC) WITH (FILLFACTOR = 90)
);

