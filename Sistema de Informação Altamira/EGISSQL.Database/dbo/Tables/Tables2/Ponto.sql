CREATE TABLE [dbo].[Ponto] (
    [cd_ponto]           INT           NOT NULL,
    [nm_ponto]           VARCHAR (60)  NULL,
    [nm_fantasia_ponto]  VARCHAR (15)  NULL,
    [cd_identifica_cep]  INT           NULL,
    [cd_cep]             VARCHAR (8)   NULL,
    [nm_endereco_ponto]  VARCHAR (60)  NULL,
    [cd_numero_endereco] VARCHAR (10)  NULL,
    [nm_bairro_ponto]    VARCHAR (25)  NULL,
    [cd_pais]            INT           NULL,
    [cd_estado]          INT           NULL,
    [cd_cidade]          INT           NULL,
    [ds_ponto]           TEXT          NULL,
    [nm_foto_ponto]      VARCHAR (150) NULL,
    [dt_cadastro_ponto]  DATETIME      NULL,
    [dt_alteracao_ponto] DATETIME      NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    [nm_compl_endereco]  VARCHAR (40)  NULL,
    CONSTRAINT [PK_Ponto] PRIMARY KEY CLUSTERED ([cd_ponto] ASC) WITH (FILLFACTOR = 90)
);

