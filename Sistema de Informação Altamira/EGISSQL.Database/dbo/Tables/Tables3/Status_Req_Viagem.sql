CREATE TABLE [dbo].[Status_Req_Viagem] (
    [cd_status_requisicao]     INT          NOT NULL,
    [nm_status_requisicao]     VARCHAR (40) NULL,
    [sg_status_requisicao]     CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_pad_status_requisicao] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Req_Viagem] PRIMARY KEY CLUSTERED ([cd_status_requisicao] ASC) WITH (FILLFACTOR = 90)
);

