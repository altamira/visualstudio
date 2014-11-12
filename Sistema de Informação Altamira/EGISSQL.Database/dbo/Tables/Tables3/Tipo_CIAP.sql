CREATE TABLE [dbo].[Tipo_CIAP] (
    [cd_tipo_ciap]              INT          NOT NULL,
    [nm_tipo_ciap]              VARCHAR (40) NULL,
    [sg_tipo_ciap]              CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_padrao_tipo_ciap]       CHAR (1)     NULL,
    [ic_tipo_calculo_tipo_ciap] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_CIAP] PRIMARY KEY CLUSTERED ([cd_tipo_ciap] ASC) WITH (FILLFACTOR = 90)
);

