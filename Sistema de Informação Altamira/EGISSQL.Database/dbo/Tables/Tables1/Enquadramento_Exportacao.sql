CREATE TABLE [dbo].[Enquadramento_Exportacao] (
    [cd_enquadro_exportacao] INT          NOT NULL,
    [nm_enquadro_exportacao] VARCHAR (40) NULL,
    [sg_enquadro_exportacao] CHAR (10)    NULL,
    [ic_pad_enquadro]        CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Enquadramento_Exportacao] PRIMARY KEY CLUSTERED ([cd_enquadro_exportacao] ASC) WITH (FILLFACTOR = 90)
);

