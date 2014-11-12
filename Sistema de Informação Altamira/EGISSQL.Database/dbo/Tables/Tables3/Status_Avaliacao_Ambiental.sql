CREATE TABLE [dbo].[Status_Avaliacao_Ambiental] (
    [cd_status_avaliacao]     INT          NOT NULL,
    [nm_status_avaliacao]     VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [sg_status_avaliacao]     CHAR (10)    NULL,
    [ic_pad_status_avaliacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Avaliacao_Ambiental] PRIMARY KEY CLUSTERED ([cd_status_avaliacao] ASC) WITH (FILLFACTOR = 90)
);

