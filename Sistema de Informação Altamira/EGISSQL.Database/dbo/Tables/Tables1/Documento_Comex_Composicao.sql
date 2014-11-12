CREATE TABLE [dbo].[Documento_Comex_Composicao] (
    [cd_tipo_documento_comex]  INT           NOT NULL,
    [cd_campo_documento_comex] INT           NOT NULL,
    [ic_imprime]               CHAR (1)      NULL,
    [ic_condensado]            CHAR (1)      NULL,
    [ic_negrito]               CHAR (1)      NULL,
    [ic_enfatizado]            CHAR (1)      NULL,
    [nm_conteudo_fixo]         VARCHAR (100) NULL,
    [ic_tipo_alinhamento]      CHAR (1)      NULL,
    [nm_sp_documento]          VARCHAR (100) NULL,
    [nm_sp_atributo]           VARCHAR (50)  NULL,
    [nm_obs_campo]             VARCHAR (100) NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Documento_Comex_Composicao] PRIMARY KEY CLUSTERED ([cd_tipo_documento_comex] ASC, [cd_campo_documento_comex] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Comex_Composicao_Documento_Comex_Campo] FOREIGN KEY ([cd_campo_documento_comex]) REFERENCES [dbo].[Documento_Comex_Campo] ([cd_campo_documento_comex])
);

