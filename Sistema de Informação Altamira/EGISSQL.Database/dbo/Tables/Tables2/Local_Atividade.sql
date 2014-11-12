CREATE TABLE [dbo].[Local_Atividade] (
    [cd_local_atividade] INT          NOT NULL,
    [nm_local_atividade] VARCHAR (40) NULL,
    [sg_local_atividade] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Local_Atividade] PRIMARY KEY CLUSTERED ([cd_local_atividade] ASC) WITH (FILLFACTOR = 90)
);

