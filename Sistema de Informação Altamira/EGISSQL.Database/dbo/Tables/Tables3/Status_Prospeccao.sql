CREATE TABLE [dbo].[Status_Prospeccao] (
    [cd_status_prospeccao]     INT          NOT NULL,
    [nm_status_prospeccao]     VARCHAR (40) NULL,
    [sg_status_prospeccao]     CHAR (10)    NULL,
    [ic_pad_status_prospeccao] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_status_prospeccao] VARCHAR (40) NULL,
    [ic_operacao_status]       CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Prospeccao] PRIMARY KEY CLUSTERED ([cd_status_prospeccao] ASC) WITH (FILLFACTOR = 90)
);

