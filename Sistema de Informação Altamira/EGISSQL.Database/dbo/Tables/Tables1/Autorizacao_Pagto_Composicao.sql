CREATE TABLE [dbo].[Autorizacao_Pagto_Composicao] (
    [cd_ap]                      INT          NOT NULL,
    [cd_item_ap]                 INT          NOT NULL,
    [cd_tipo_documento]          INT          NULL,
    [cd_documento_ap]            INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo_documento_ap]       CHAR (1)     NULL,
    [cd_identificacao_documento] VARCHAR (30) NULL,
    CONSTRAINT [PK_Autorizacao_Pagto_Composicao] PRIMARY KEY CLUSTERED ([cd_ap] ASC, [cd_item_ap] ASC) WITH (FILLFACTOR = 90)
);

