CREATE TABLE [dbo].[Instrucao_Interna_Revisao] (
    [cd_instrucao]               INT           NOT NULL,
    [cd_item_revisao_instrucao]  INT           NOT NULL,
    [dt_revisao_instrucao]       DATETIME      NULL,
    [cd_interno_instrucao]       VARCHAR (20)  NOT NULL,
    [nm_revisao_instrucao]       VARCHAR (50)  NULL,
    [ds_revisao_instrucao]       TEXT          NULL,
    [nm_obs_revisao_instrucao]   VARCHAR (40)  NULL,
    [cd_usuario_formatador]      INT           NULL,
    [cd_usuario_emitente]        INT           NULL,
    [cd_usuario_aprovacao]       INT           NULL,
    [dt_aprovacao_revisao]       DATETIME      NULL,
    [nm_doc_revisao_instrucao]   VARCHAR (100) NULL,
    [nm_fluxo_revisao_instrucao] VARCHAR (100) NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    CONSTRAINT [PK_Instrucao_Interna_Revisao] PRIMARY KEY CLUSTERED ([cd_instrucao] ASC, [cd_item_revisao_instrucao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Instrucao_Interna_Revisao_Usuario] FOREIGN KEY ([cd_usuario_aprovacao]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

