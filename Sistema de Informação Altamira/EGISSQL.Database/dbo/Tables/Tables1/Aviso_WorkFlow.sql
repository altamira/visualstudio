CREATE TABLE [dbo].[Aviso_WorkFlow] (
    [cd_aviso]   INT          NOT NULL,
    [nm_aviso]   VARCHAR (40) NULL,
    [sg_aviso]   CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Aviso_WorkFlow] PRIMARY KEY CLUSTERED ([cd_aviso] ASC) WITH (FILLFACTOR = 90)
);

