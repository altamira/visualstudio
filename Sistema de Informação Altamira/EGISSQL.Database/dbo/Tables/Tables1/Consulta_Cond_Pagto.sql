CREATE TABLE [dbo].[Consulta_Cond_Pagto] (
    [cd_consulta]               INT        NOT NULL,
    [cd_item_consulta_cond_pag] INT        NOT NULL,
    [qt_parcela_consulta_cond]  FLOAT (53) NOT NULL,
    [pc_parcela_consulta_cond]  FLOAT (53) NOT NULL,
    [vl_parcela_consulta_cond]  FLOAT (53) NOT NULL,
    [dt_parcela_consulta_cond]  DATETIME   NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Consulta_Cond_Pagto] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta_cond_pag] ASC) WITH (FILLFACTOR = 90)
);

