CREATE TABLE [dbo].[Tipo_Medicao] (
    [cd_tipo_medicao]        INT          NOT NULL,
    [nm_tipo_medicao]        VARCHAR (40) NULL,
    [sg_tipo_medicao]        CHAR (10)    NULL,
    [ic_padrao_tipo_medicao] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Medicao] PRIMARY KEY CLUSTERED ([cd_tipo_medicao] ASC) WITH (FILLFACTOR = 90)
);

