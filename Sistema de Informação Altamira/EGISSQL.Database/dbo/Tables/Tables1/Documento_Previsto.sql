CREATE TABLE [dbo].[Documento_Previsto] (
    [cd_documento_previsto]  INT          NOT NULL,
    [nm_documento_previsto]  VARCHAR (40) NULL,
    [nm_favorecido_previsto] VARCHAR (30) NULL,
    [cd_portador]            INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_tipo_operacao]       INT          NULL,
    [cd_loja]                INT          NULL,
    [cd_plano_financeiro]    INT          NULL,
    CONSTRAINT [PK_Documento_Previsto] PRIMARY KEY CLUSTERED ([cd_documento_previsto] ASC) WITH (FILLFACTOR = 90)
);

