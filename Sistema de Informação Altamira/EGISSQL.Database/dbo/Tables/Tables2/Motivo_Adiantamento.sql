CREATE TABLE [dbo].[Motivo_Adiantamento] (
    [cd_motivo_adiantamento] INT          NOT NULL,
    [nm_motivo_adiantamento] VARCHAR (40) NULL,
    [sg_motivo_adiantamento] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Adiantamento] PRIMARY KEY CLUSTERED ([cd_motivo_adiantamento] ASC) WITH (FILLFACTOR = 90)
);

