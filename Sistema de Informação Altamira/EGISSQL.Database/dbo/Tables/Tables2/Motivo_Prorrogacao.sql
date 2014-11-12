CREATE TABLE [dbo].[Motivo_Prorrogacao] (
    [cd_motivo_prorrogacao] INT          NOT NULL,
    [nm_motivo_prorrogacao] VARCHAR (40) NULL,
    [sg_motivo_prorrogacao] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Prorrogacao] PRIMARY KEY CLUSTERED ([cd_motivo_prorrogacao] ASC) WITH (FILLFACTOR = 90)
);

