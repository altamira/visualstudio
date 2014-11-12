CREATE TABLE [dbo].[Auditoria_Composição] (
    [cd_auditoria]            INT           NOT NULL,
    [cd_item_auditoria]       INT           NOT NULL,
    [nm_item_auditoria]       VARCHAR (40)  NULL,
    [ds_item_auditoria]       TEXT          NULL,
    [nm_requisito_referencia] VARCHAR (40)  NULL,
    [cd_evidencia]            INT           NULL,
    [nm_evidencia_auditoria]  VARCHAR (40)  NULL,
    [nm_doc_item_auditoria]   VARCHAR (100) NULL,
    [nm_foto_item_auditoria]  VARCHAR (100) NULL,
    [nm_obs_item_auditoria]   VARCHAR (40)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Auditoria_Composição] PRIMARY KEY CLUSTERED ([cd_auditoria] ASC, [cd_item_auditoria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Auditoria_Composição_Evidencia_Auditoria] FOREIGN KEY ([cd_evidencia]) REFERENCES [dbo].[Evidencia_Auditoria] ([cd_evidencia])
);

