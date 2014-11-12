CREATE TABLE [dbo].[Tipo_Informacao] (
    [cd_tipo_informacao]       INT          NOT NULL,
    [nm_tipo_informacao]       VARCHAR (40) NULL,
    [sg_tipo_informacao]       CHAR (10)    NULL,
    [ic_ativo_tipo_informacao] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Informacao] PRIMARY KEY CLUSTERED ([cd_tipo_informacao] ASC) WITH (FILLFACTOR = 90)
);

