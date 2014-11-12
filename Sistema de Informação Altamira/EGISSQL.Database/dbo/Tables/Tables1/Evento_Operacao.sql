CREATE TABLE [dbo].[Evento_Operacao] (
    [cd_evento]          INT          NOT NULL,
    [nm_evento]          VARCHAR (40) NULL,
    [nm_fantasia_evento] VARCHAR (15) NULL,
    [dt_inicio_evento]   DATETIME     NULL,
    [dt_final_evento]    DATETIME     NULL,
    [ds_evento]          TEXT         NULL,
    [ic_ativo_evento]    CHAR (1)     NULL,
    [nm_obs_evento]      VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Evento_Operacao] PRIMARY KEY CLUSTERED ([cd_evento] ASC) WITH (FILLFACTOR = 90)
);

