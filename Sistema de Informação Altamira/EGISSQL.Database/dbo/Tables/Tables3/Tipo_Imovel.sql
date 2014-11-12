CREATE TABLE [dbo].[Tipo_Imovel] (
    [cd_tipo_imovel] INT          NOT NULL,
    [nm_tipo_imovel] VARCHAR (40) NULL,
    [sg_tipo_imovel] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Imovel] PRIMARY KEY CLUSTERED ([cd_tipo_imovel] ASC) WITH (FILLFACTOR = 90)
);

