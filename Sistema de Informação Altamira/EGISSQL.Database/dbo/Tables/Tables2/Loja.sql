CREATE TABLE [dbo].[Loja] (
    [cd_loja]          INT           NOT NULL,
    [nm_loja]          VARCHAR (40)  NULL,
    [nm_fantasia_loja] VARCHAR (15)  NOT NULL,
    [sg_loja]          CHAR (10)     NULL,
    [ic_ativa_loja]    CHAR (1)      NULL,
    [nm_logotipo_loja] VARCHAR (100) NULL,
    [cd_usuario]       INT           NULL,
    [dt_usuario]       DATETIME      NULL,
    [ic_analise_loja]  CHAR (1)      NULL,
    [cd_numero_loja]   VARCHAR (15)  NULL,
    CONSTRAINT [PK_Loja] PRIMARY KEY CLUSTERED ([cd_loja] ASC) WITH (FILLFACTOR = 90)
);

