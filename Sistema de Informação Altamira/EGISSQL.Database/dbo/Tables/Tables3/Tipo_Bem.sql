CREATE TABLE [dbo].[Tipo_Bem] (
    [cd_tipo_bem]            INT          NOT NULL,
    [nm_tipo_bem]            VARCHAR (40) NULL,
    [sg_tipo_bem]            CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_pis_cofins_tipo_bem] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Bem] PRIMARY KEY CLUSTERED ([cd_tipo_bem] ASC) WITH (FILLFACTOR = 90)
);

