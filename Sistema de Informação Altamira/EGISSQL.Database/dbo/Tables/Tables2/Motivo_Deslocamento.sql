CREATE TABLE [dbo].[Motivo_Deslocamento] (
    [cd_motivo_deslocamento]  INT          NOT NULL,
    [nm_motivo_deslocamento]  VARCHAR (40) NULL,
    [sg_motivo_deslocamento]  CHAR (10)    NULL,
    [ic_pad_mot_deslocamento] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Deslocamento] PRIMARY KEY CLUSTERED ([cd_motivo_deslocamento] ASC) WITH (FILLFACTOR = 90)
);

