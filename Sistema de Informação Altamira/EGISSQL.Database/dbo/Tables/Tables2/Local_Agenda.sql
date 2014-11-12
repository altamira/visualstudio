CREATE TABLE [dbo].[Local_Agenda] (
    [cd_local_agenda]        INT          NOT NULL,
    [nm_local_agenda]        VARCHAR (40) NULL,
    [sg_local_agenda]        CHAR (10)    NULL,
    [ic_padrao_local_agenda] CHAR (1)     NULL,
    [ds_local_agenda]        TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Local_Agenda] PRIMARY KEY CLUSTERED ([cd_local_agenda] ASC) WITH (FILLFACTOR = 90)
);

