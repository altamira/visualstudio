CREATE TABLE [dbo].[Tipo_Duvida] (
    [cd_tipo_duvida]     INT          NOT NULL,
    [nm_tipo_duvida]     VARCHAR (40) NULL,
    [sg_tipo_duvida]     CHAR (10)    NULL,
    [ic_pad_tipo_duvida] CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Duvida] PRIMARY KEY CLUSTERED ([cd_tipo_duvida] ASC) WITH (FILLFACTOR = 90)
);

