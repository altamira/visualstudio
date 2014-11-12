CREATE TABLE [dbo].[Tipo_Comissao] (
    [cd_tipo_comissao]        INT          NOT NULL,
    [nm_tipo_comissao]        VARCHAR (40) NULL,
    [sg_tipo_comissao]        CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_padrao_tipo_comissao] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Comissao] PRIMARY KEY CLUSTERED ([cd_tipo_comissao] ASC) WITH (FILLFACTOR = 90)
);

