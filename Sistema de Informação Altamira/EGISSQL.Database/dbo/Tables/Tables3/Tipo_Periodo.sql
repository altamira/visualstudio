CREATE TABLE [dbo].[Tipo_Periodo] (
    [cd_tipo_periodo]       INT          NOT NULL,
    [nm_tipo_periodo]       VARCHAR (40) NULL,
    [sg_tipo_periodo]       CHAR (10)    NULL,
    [ic_ativo_tipo_periodo] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Periodo] PRIMARY KEY CLUSTERED ([cd_tipo_periodo] ASC) WITH (FILLFACTOR = 90)
);

