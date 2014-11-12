CREATE TABLE [dbo].[Tipo_Entrega] (
    [cd_tipo_entrega]     INT          NOT NULL,
    [nm_tipo_entrega]     VARCHAR (40) NULL,
    [sg_tipo_entrega]     CHAR (10)    NULL,
    [ic_pad_tipo_entrega] CHAR (1)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Entrega] PRIMARY KEY CLUSTERED ([cd_tipo_entrega] ASC) WITH (FILLFACTOR = 90)
);

