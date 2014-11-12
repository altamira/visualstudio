CREATE TABLE [dbo].[Tipo_Desconto_Comissao] (
    [cd_tipo_desconto_comissao] INT          NOT NULL,
    [nm_tipo_desconto_comissao] VARCHAR (40) NOT NULL,
    [sg_tipo_desconto_comissao] CHAR (10)    NOT NULL,
    [ds_tipo_desconto_comissao] TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Desconto_Comissao] PRIMARY KEY CLUSTERED ([cd_tipo_desconto_comissao] ASC) WITH (FILLFACTOR = 90)
);

