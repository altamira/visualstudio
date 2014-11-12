CREATE TABLE [dbo].[Carta_Anuencia_Composicao] (
    [cd_carta_anuencia]        INT           NOT NULL,
    [cd_documento_receber]     INT           NOT NULL,
    [nm_protocolo_composicao]  VARCHAR (20)  NULL,
    [cd_livro_composicao]      INT           NULL,
    [cd_folha_composicao]      INT           NULL,
    [sg_tipo_composicao]       CHAR (10)     NULL,
    [nm_observacao_composicao] VARCHAR (100) NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Carta_Anuencia_Composicao] PRIMARY KEY CLUSTERED ([cd_carta_anuencia] ASC, [cd_documento_receber] ASC) WITH (FILLFACTOR = 90)
);

