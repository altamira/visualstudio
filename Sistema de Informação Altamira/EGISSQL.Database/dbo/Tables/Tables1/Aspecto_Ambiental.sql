CREATE TABLE [dbo].[Aspecto_Ambiental] (
    [cd_aspecto_ambiental]     INT          NOT NULL,
    [nm_aspecto_ambiental]     VARCHAR (40) NULL,
    [ds_aspecto_ambiental]     TEXT         NULL,
    [ic_ativo_aspecto]         CHAR (1)     NULL,
    [cd_severidade_ambiental]  INT          NULL,
    [nm_obs_aspecto_ambiental] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Aspecto_Ambiental] PRIMARY KEY CLUSTERED ([cd_aspecto_ambiental] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aspecto_Ambiental_Severidade_Ambiental] FOREIGN KEY ([cd_severidade_ambiental]) REFERENCES [dbo].[Severidade_Ambiental] ([cd_severidade_ambiental])
);

