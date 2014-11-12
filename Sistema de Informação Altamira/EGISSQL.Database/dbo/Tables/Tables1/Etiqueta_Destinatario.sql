CREATE TABLE [dbo].[Etiqueta_Destinatario] (
    [cd_etiqueta_destinatario] INT           NOT NULL,
    [nm_etiqueta_destinatario] VARCHAR (60)  NOT NULL,
    [ic_condensado]            CHAR (1)      NULL,
    [cd_linha]                 INT           NULL,
    [cd_coluna]                INT           NULL,
    [nm_procedure]             VARCHAR (150) NULL,
    [nm_impressora_etiqueta]   VARCHAR (300) NULL,
    [cd_linha_etiqueta]        INT           NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_tipo_destinatario]     INT           NULL,
    [ic_padrao_etiqueta]       CHAR (1)      NULL,
    CONSTRAINT [PK_Etiqueta_Destinatario] PRIMARY KEY CLUSTERED ([cd_etiqueta_destinatario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Etiqueta_Destinatario_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

