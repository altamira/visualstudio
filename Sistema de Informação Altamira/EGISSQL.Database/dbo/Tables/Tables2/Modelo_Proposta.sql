CREATE TABLE [dbo].[Modelo_Proposta] (
    [cd_modelo_proposta] INT           NOT NULL,
    [nm_modelo_proposta] VARCHAR (40)  NULL,
    [nm_fantasia_modelo] VARCHAR (15)  NULL,
    [nm_titulo_proposta] VARCHAR (120) NULL,
    [ic_padrao_proposta] CHAR (1)      NULL,
    [ic_ativo_proposta]  CHAR (1)      NULL,
    [cd_classe]          INT           NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    CONSTRAINT [PK_Modelo_Proposta] PRIMARY KEY CLUSTERED ([cd_modelo_proposta] ASC) WITH (FILLFACTOR = 90)
);

