CREATE TABLE [dbo].[Motivo_Extra] (
    [cd_motivo_extra]     INT          NOT NULL,
    [nm_motivo_extra]     VARCHAR (50) NULL,
    [qt_hora_motivo_hora] FLOAT (53)   NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Extra] PRIMARY KEY CLUSTERED ([cd_motivo_extra] ASC)
);

