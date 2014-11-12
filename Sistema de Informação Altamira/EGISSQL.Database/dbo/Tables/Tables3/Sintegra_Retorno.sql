CREATE TABLE [dbo].[Sintegra_Retorno] (
    [cd_retorno]        INT          NOT NULL,
    [dt_retorno]        DATETIME     NULL,
    [cd_status_retorno] INT          NULL,
    [ds_retorno]        TEXT         NULL,
    [nm_obs_retorno]    VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Sintegra_Retorno] PRIMARY KEY CLUSTERED ([cd_retorno] ASC) WITH (FILLFACTOR = 90)
);

