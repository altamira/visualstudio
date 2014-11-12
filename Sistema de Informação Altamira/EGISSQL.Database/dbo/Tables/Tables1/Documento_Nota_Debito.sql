CREATE TABLE [dbo].[Documento_Nota_Debito] (
    [cd_nota_debito]            INT        NOT NULL,
    [cd_documento_receber]      INT        NOT NULL,
    [vl_documento_nota_debito]  FLOAT (53) NOT NULL,
    [qt_dia_atraso_nota_debito] INT        NOT NULL,
    [vl_juros_nota_debito]      FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Documento_Nota_Debito] PRIMARY KEY CLUSTERED ([cd_nota_debito] ASC, [cd_documento_receber] ASC) WITH (FILLFACTOR = 90)
);

