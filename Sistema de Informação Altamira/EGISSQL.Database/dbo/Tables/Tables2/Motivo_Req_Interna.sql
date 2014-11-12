CREATE TABLE [dbo].[Motivo_Req_Interna] (
    [cd_motivo_req_interna]     INT          NOT NULL,
    [nm_motivo_req_interna]     VARCHAR (40) NULL,
    [sg_motivo_req_interna]     CHAR (10)    NULL,
    [ic_pad_motivo_req_interna] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Req_Interna] PRIMARY KEY CLUSTERED ([cd_motivo_req_interna] ASC) WITH (FILLFACTOR = 90)
);

