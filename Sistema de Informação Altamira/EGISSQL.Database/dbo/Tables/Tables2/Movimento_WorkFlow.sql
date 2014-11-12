CREATE TABLE [dbo].[Movimento_WorkFlow] (
    [cd_movimento]        INT          NOT NULL,
    [dt_movimento]        DATETIME     NOT NULL,
    [cd_processo]         INT          NOT NULL,
    [cd_documento]        VARCHAR (15) NULL,
    [cd_status]           INT          NULL,
    [nm_motivo_movimento] VARCHAR (40) NULL,
    [nm_obs_movimento]    VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_fluxo_processo]   INT          NULL,
    [vl_movimento]        FLOAT (53)   NULL,
    CONSTRAINT [PK_Movimento_WorkFlow] PRIMARY KEY CLUSTERED ([cd_movimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_WorkFlow_Status_WorkFlow] FOREIGN KEY ([cd_status]) REFERENCES [dbo].[Status_WorkFlow] ([cd_status])
);

