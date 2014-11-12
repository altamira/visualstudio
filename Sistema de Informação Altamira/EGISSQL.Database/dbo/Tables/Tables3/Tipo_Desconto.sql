CREATE TABLE [dbo].[Tipo_Desconto] (
    [cd_tipo_desconto] INT          NOT NULL,
    [nm_tipo_desconto] VARCHAR (40) NULL,
    [sg_tipo_desconto] CHAR (10)    NULL,
    [pc_tipo_desconto] FLOAT (53)   NULL,
    [ds_tipo_desconto] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Desconto] PRIMARY KEY CLUSTERED ([cd_tipo_desconto] ASC) WITH (FILLFACTOR = 90)
);

