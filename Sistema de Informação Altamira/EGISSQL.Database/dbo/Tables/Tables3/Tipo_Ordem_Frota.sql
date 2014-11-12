CREATE TABLE [dbo].[Tipo_Ordem_Frota] (
    [cd_tipo_ordem]        INT          NOT NULL,
    [nm_tipo_ordem]        VARCHAR (40) NULL,
    [sg_tipo_ordem]        CHAR (10)    NULL,
    [ic_padrao_tipo_ordem] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Ordem_Frota] PRIMARY KEY CLUSTERED ([cd_tipo_ordem] ASC) WITH (FILLFACTOR = 90)
);

