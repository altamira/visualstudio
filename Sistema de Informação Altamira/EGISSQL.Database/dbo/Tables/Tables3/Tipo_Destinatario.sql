CREATE TABLE [dbo].[Tipo_Destinatario] (
    [cd_tipo_destinatario]         INT          NOT NULL,
    [nm_tipo_destinatario]         VARCHAR (30) NOT NULL,
    [sg_tipo_destinatario]         CHAR (10)    NOT NULL,
    [cd_usuario]                   INT          NOT NULL,
    [dt_usuario]                   DATETIME     NOT NULL,
    [ic_ocor_tipo_destinatario]    CHAR (1)     NULL,
    [ic_pad_tipo_destinatario]     CHAR (1)     NULL,
    [ic_req_fat_tipo_destinatario] CHAR (1)     NULL,
    [ic_cfop_tipo_destinatario]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Destinatario] PRIMARY KEY CLUSTERED ([cd_tipo_destinatario] ASC) WITH (FILLFACTOR = 90)
);

