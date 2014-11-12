CREATE TABLE [dbo].[Orcamento_Cq_Comentario] (
    [cd_consulta]             INT      NOT NULL,
    [cd_item_consulta]        INT      NOT NULL,
    [ds_comentarios_consulta] TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [ds_comentario_consulta]  TEXT     NULL,
    CONSTRAINT [PK_Orcamento_Cq_Comentarios] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

