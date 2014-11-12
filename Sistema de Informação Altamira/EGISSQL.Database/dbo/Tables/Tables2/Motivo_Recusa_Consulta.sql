CREATE TABLE [dbo].[Motivo_Recusa_Consulta] (
    [cd_motivo_recusa_consulta] INT          NOT NULL,
    [nm_motivo_recusa_consulta] VARCHAR (40) NULL,
    [sg_motivo_recusa_consulta] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Recusa_Consulta] PRIMARY KEY CLUSTERED ([cd_motivo_recusa_consulta] ASC) WITH (FILLFACTOR = 90)
);

