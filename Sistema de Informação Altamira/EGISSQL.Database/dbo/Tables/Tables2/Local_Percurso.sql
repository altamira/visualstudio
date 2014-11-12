CREATE TABLE [dbo].[Local_Percurso] (
    [cd_local_percurso]     INT          NOT NULL,
    [nm_local_percurso]     VARCHAR (40) NULL,
    [cd_cidade]             INT          NULL,
    [nm_obs_local_percurso] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Local_Percurso] PRIMARY KEY CLUSTERED ([cd_local_percurso] ASC) WITH (FILLFACTOR = 90)
);

