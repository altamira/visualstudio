CREATE TABLE [dbo].[Roteiro_Calculo_Folha] (
    [cd_roteiro_calculo]     INT          NOT NULL,
    [nm_roteiro_calculo]     VARCHAR (60) NULL,
    [ds_roteiro_calculo]     TEXT         NULL,
    [nm_obs_roteiro_calculo] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [qt_ordem_calculo]       INT          NULL,
    CONSTRAINT [PK_Roteiro_Calculo_Folha] PRIMARY KEY CLUSTERED ([cd_roteiro_calculo] ASC) WITH (FILLFACTOR = 90)
);

