CREATE TABLE [dbo].[Status_Req_Manutencao] (
    [cd_status_req_manutencao] INT          NOT NULL,
    [nm_status_req_manutencao] VARCHAR (40) NULL,
    [sg_status_req_manutencao] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Status_Req_Manutencao] PRIMARY KEY CLUSTERED ([cd_status_req_manutencao] ASC) WITH (FILLFACTOR = 90)
);

