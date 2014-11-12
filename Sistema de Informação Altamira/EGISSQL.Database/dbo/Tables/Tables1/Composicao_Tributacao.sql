CREATE TABLE [dbo].[Composicao_Tributacao] (
    [cd_imposto]           INT      NOT NULL,
    [cd_tributacao]        INT      NOT NULL,
    [cd_evento_tributacao] INT      NOT NULL,
    [cd_item_composicao]   INT      NOT NULL,
    [ic_evento_tributacao] CHAR (1) NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Composicao_Tributacao] PRIMARY KEY CLUSTERED ([cd_imposto] ASC, [cd_tributacao] ASC, [cd_evento_tributacao] ASC, [cd_item_composicao] ASC) WITH (FILLFACTOR = 90)
);

