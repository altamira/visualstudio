CREATE TABLE [dbo].[Consulta_Contato] (
    [cd_consulta]               INT      NOT NULL,
    [cd_cliente]                INT      NOT NULL,
    [cd_contato]                INT      NOT NULL,
    [ic_envia_proposta_contato] CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Consulta_Contato] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_cliente] ASC, [cd_contato] ASC) WITH (FILLFACTOR = 90)
);

