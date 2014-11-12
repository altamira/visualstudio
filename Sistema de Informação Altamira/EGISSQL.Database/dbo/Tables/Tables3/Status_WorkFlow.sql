CREATE TABLE [dbo].[Status_WorkFlow] (
    [cd_status]  INT          NOT NULL,
    [nm_status]  VARCHAR (40) NULL,
    [sg_status]  CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Status_WorkFlow] PRIMARY KEY CLUSTERED ([cd_status] ASC) WITH (FILLFACTOR = 90)
);

