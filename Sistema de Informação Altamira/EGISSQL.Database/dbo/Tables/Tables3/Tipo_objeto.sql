CREATE TABLE [dbo].[Tipo_objeto] (
    [cd_tipo_objeto]        INT          NOT NULL,
    [nm_tipo_objeto]        VARCHAR (40) NULL,
    [sg_tipo_objeto]        CHAR (10)    NULL,
    [cd_classe]             INT          NULL,
    [ic_padrao_tipo_objeto] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_objeto] PRIMARY KEY CLUSTERED ([cd_tipo_objeto] ASC) WITH (FILLFACTOR = 90)
);

