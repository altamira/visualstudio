CREATE TABLE [dbo].[Campanha] (
    [cd_campanha]               INT           NOT NULL,
    [nm_campanha]               VARCHAR (30)  NOT NULL,
    [sg_campanha]               VARCHAR (10)  NOT NULL,
    [qt_cliente_campanha]       INT           NULL,
    [qt_contato_campanha]       INT           NULL,
    [qt_cliente_internet]       INT           NULL,
    [dt_inicial_campanha]       DATETIME      NOT NULL,
    [dt_final_campanha]         DATETIME      NOT NULL,
    [dt_geracao_campanha]       DATETIME      NULL,
    [cd_tipo_campanha]          INT           NOT NULL,
    [cd_meio_campanha]          INT           NOT NULL,
    [nm_html_campanha]          VARCHAR (100) NULL,
    [nm_arquivo_anexo_campanha] VARCHAR (100) NULL,
    [cd_usuario]                INT           NOT NULL,
    [dt_usuario]                DATETIME      NOT NULL,
    [ds_campanha]               TEXT          NULL,
    [ic_ativa_campanha]         CHAR (1)      NULL,
    CONSTRAINT [PK_Campanha] PRIMARY KEY NONCLUSTERED ([cd_campanha] ASC) WITH (FILLFACTOR = 90)
);

