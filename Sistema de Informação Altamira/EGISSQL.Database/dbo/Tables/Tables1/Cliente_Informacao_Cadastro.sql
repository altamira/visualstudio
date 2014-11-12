CREATE TABLE [dbo].[Cliente_Informacao_Cadastro] (
    [cd_cliente]            INT           NOT NULL,
    [cd_tipo_info_cadastro] INT           NOT NULL,
    [dt_info_cadastro]      DATETIME      NULL,
    [ds_info_cadastro]      TEXT          NULL,
    [nm_obs_info_cadastro]  VARCHAR (40)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [nm_doc_info_cadastro]  VARCHAR (100) NULL,
    CONSTRAINT [PK_Cliente_Informacao_Cadastro] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_tipo_info_cadastro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Informacao_Cadastro_Tipo_Informacao_Cadastro] FOREIGN KEY ([cd_tipo_info_cadastro]) REFERENCES [dbo].[Tipo_Informacao_Cadastro] ([cd_tipo_info_cadastro])
);

